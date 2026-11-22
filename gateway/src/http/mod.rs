//! HTTP ingress for file uploads and downloads (#1131).
//!
//! Historically clients uploaded files directly to the Rails `POST /files/upload`
//! endpoint (`FilesController#upload`). This module moves that front door into the
//! Proxy: the gateway terminates the multipart upload, enforces the configured
//! per-object size cap while the bytes stream through, and forwards the request to
//! Rails without ever holding the whole file in memory.
//!
//! Rails stays the system of record -- it runs the `Ability` authorization check,
//! computes the authoritative checksum and persists the blob through ActiveStorage --
//! so its JSON response is passed straight back to the caller. The caller's
//! `Authorization` header is forwarded untouched; the Proxy performs no authorization
//! of its own.
//!
//! `PUT /storage_objects/upload` and `GET /storage_objects/download` are the endpoints behind the
//! signed, absolute URLs Rails hands out to actions (via `GetFileUploadUrl` /
//! `GetFileDownloadUrl`). Both are plain streaming passthroughs to Rails that keep the query
//! string (which carries the signature) and need no `Authorization`: the signature is the
//! capability and Rails validates it. The PUT body is the raw file content.

use std::{
    collections::hash_map::RandomState,
    hash::{BuildHasher, Hasher},
    io,
    sync::{
        Arc,
        atomic::{AtomicBool, Ordering},
    },
};

use axum::{
    Json, Router,
    body::{Body, Bytes},
    extract::{DefaultBodyLimit, Multipart, RawQuery, State, multipart::MultipartError},
    http::{HeaderMap, HeaderName, StatusCode, header},
    response::{IntoResponse, Response},
    routing::{get, post, put},
};
use tokio::sync::mpsc;
use tokio_stream::{StreamExt, wrappers::ReceiverStream};

use crate::config::Files;

/// Headroom on top of the file size cap for the multipart framing and the text fields,
/// so the body limit does not trip before the (more precise) per-file cap does.
const MULTIPART_OVERHEAD_BYTES: u64 = 1024 * 1024;
/// Upper bound for a single non-file field; these are small identifiers, never payloads.
const MAX_TEXT_FIELD_BYTES: usize = 64 * 1024;
/// Response headers carried over from Rails on a download.
const DOWNLOAD_HEADERS: [HeaderName; 8] = [
    header::CONTENT_TYPE,
    header::CONTENT_LENGTH,
    header::CONTENT_DISPOSITION,
    header::CONTENT_RANGE,
    header::ACCEPT_RANGES,
    header::CACHE_CONTROL,
    header::ETAG,
    header::LAST_MODIFIED,
];

#[derive(Clone)]
pub struct FileUploadState {
    files: Files,
    client: reqwest::Client,
}

impl FileUploadState {
    pub fn new(files: Files, client: reqwest::Client) -> Self {
        Self { files, client }
    }
}

pub fn router(state: FileUploadState) -> Router {
    // axum rejects bodies over 2 MB by default, far below any sensible file size, so the
    // limit follows the configured cap (0 = no cap, no limit).
    let body_limit = match state.files.max_file_size_bytes {
        0 => DefaultBodyLimit::disable(),
        max => DefaultBodyLimit::max(
            usize::try_from(max.saturating_add(MULTIPART_OVERHEAD_BYTES)).unwrap_or(usize::MAX),
        ),
    };

    Router::new()
        .route("/health", get(|| async { StatusCode::OK }))
        // Generic attachment upload (e.g. avatars) -> Rails FilesController.
        .route("/files/upload", post(files_upload))
        // Project-scoped storage objects (the FILE data type) -> StorageObjectsController.
        .route("/storage_objects/upload", post(storage_objects_upload))
        .route(
            "/storage_objects/upload",
            put(storage_objects_signed_upload),
        )
        .route("/storage_objects/download", get(storage_objects_download))
        .layer(body_limit)
        .with_state(Arc::new(state))
}

/// Builds a Rails-shaped error body (`{ "message": ..., "error_code": ... }`).
fn error(status: StatusCode, message: impl Into<String>) -> Response {
    (
        status,
        Json(serde_json::json!({
            "message": message.into(),
            "error_code": error_code(status),
        })),
    )
        .into_response()
}

fn error_code(status: StatusCode) -> &'static str {
    match status {
        StatusCode::UNAUTHORIZED => "unauthenticated",
        StatusCode::PAYLOAD_TOO_LARGE => "file_too_large",
        StatusCode::BAD_GATEWAY => "storage_unavailable",
        _ => "invalid_upload",
    }
}

async fn files_upload(
    State(state): State<Arc<FileUploadState>>,
    headers: HeaderMap,
    multipart: Multipart,
) -> Response {
    let target = state.files.rails_upload_url.clone();
    forward(state, target, headers, multipart).await
}

async fn storage_objects_upload(
    State(state): State<Arc<FileUploadState>>,
    headers: HeaderMap,
    multipart: Multipart,
) -> Response {
    let target = state.files.rails_storage_upload_url.clone();
    forward(state, target, headers, multipart).await
}

/// Streams the raw body of a signed upload (`PUT ...?signature=...`) to Rails, keeping the query
/// string. Nothing is buffered: chunks flow through, and the byte count is checked against
/// `files.max_file_size_bytes` as they pass (a declared `Content-Length` above the cap is rejected
/// up front). Exceeding the cap aborts the request to Rails, so it never sees a complete body, and the
/// caller gets a 413. Otherwise Rails' status and JSON body are passed back verbatim. `Content-Type`
/// and `Content-Length` are forwarded; no credentials are, the signature is the capability.
async fn storage_objects_signed_upload(
    State(state): State<Arc<FileUploadState>>,
    RawQuery(query): RawQuery,
    headers: HeaderMap,
    body: Body,
) -> Response {
    let max = state.files.max_file_size_bytes;

    let declared_length = headers
        .get(header::CONTENT_LENGTH)
        .and_then(|value| value.to_str().ok())
        .and_then(|value| value.parse::<u64>().ok());
    if max != 0 && declared_length.is_some_and(|length| length > max) {
        return error(
            StatusCode::PAYLOAD_TOO_LARGE,
            "File exceeds the maximum allowed size",
        );
    }

    let mut target = state.files.rails_storage_upload_url.clone();
    if let Some(query) = query {
        target.push('?');
        target.push_str(&query);
    }

    let exceeded = Arc::new(AtomicBool::new(false));
    let exceeded_in_stream = exceeded.clone();
    let mut size: u64 = 0;
    let stream = body.into_data_stream().map(move |chunk| match chunk {
        Ok(chunk) => {
            size += chunk.len() as u64;
            if max != 0 && size > max {
                exceeded_in_stream.store(true, Ordering::SeqCst);
                Err(io::Error::other("File exceeds the maximum allowed size"))
            } else {
                Ok(chunk)
            }
        }
        Err(err) => Err(io::Error::other(err)),
    });

    let mut request = state.client.put(&target);
    if let Some(content_type) = headers.get(header::CONTENT_TYPE) {
        request = request.header(reqwest::header::CONTENT_TYPE, content_type);
    }
    if let Some(length) = declared_length {
        request = request.header(reqwest::header::CONTENT_LENGTH, length);
    }

    let sent = request
        .body(reqwest::Body::wrap_stream(stream))
        .send()
        .await;

    if exceeded.load(Ordering::SeqCst) {
        return error(
            StatusCode::PAYLOAD_TOO_LARGE,
            "File exceeds the maximum allowed size",
        );
    }

    match sent {
        Ok(rails_response) => {
            let status = StatusCode::from_u16(rails_response.status().as_u16())
                .unwrap_or(StatusCode::BAD_GATEWAY);
            let body = rails_response.bytes().await.unwrap_or_default();
            (status, [(header::CONTENT_TYPE, "application/json")], body).into_response()
        }
        Err(err) => {
            log::error!("Failed to forward signed upload to Rails: {err}");
            error(StatusCode::BAD_GATEWAY, "Failed to reach storage backend")
        }
    }
}

/// A failure while relaying the upload, mapped to the status the caller should see.
#[derive(Debug)]
struct UploadError {
    status: StatusCode,
    message: String,
}

impl UploadError {
    fn new(status: StatusCode, message: impl Into<String>) -> Self {
        Self {
            status,
            message: message.into(),
        }
    }

    /// The receiving side went away (Rails answered early or the connection broke); the
    /// response of the Rails request is what the caller gets in that case.
    fn upstream_closed() -> Self {
        Self::new(StatusCode::BAD_GATEWAY, "Storage backend closed the upload")
    }

    fn from_multipart(err: MultipartError) -> Self {
        Self::new(
            err.status(),
            format!("Malformed multipart body: {}", err.body_text()),
        )
    }
}

/// Terminates a multipart upload and forwards it to the given Rails URL as it arrives.
///
/// The incoming fields are re-encoded into a new multipart body in arrival order and
/// streamed to Rails through a bounded channel, so memory use does not depend on the file
/// size, and fields may come before or after the `attachment`. The `attachment` size is
/// checked while streaming. Every other text field is passed through verbatim so a single
/// handler serves every Rails upload contract.
///
/// Rails performs authorization and persistence, so its JSON response is passed straight
/// back. The caller's `Authorization` header is forwarded untouched; the Proxy performs no
/// authorization of its own.
async fn forward(
    state: Arc<FileUploadState>,
    target: String,
    headers: HeaderMap,
    multipart: Multipart,
) -> Response {
    let authorization = match headers.get(header::AUTHORIZATION) {
        Some(value) => match value.to_str() {
            Ok(value) => value.to_string(),
            Err(_) => return error(StatusCode::BAD_REQUEST, "Invalid authorization header"),
        },
        None => return error(StatusCode::UNAUTHORIZED, "Missing authorization"),
    };

    let boundary = boundary();
    let (sender, receiver) = mpsc::channel::<Result<Bytes, io::Error>>(8);
    let max = state.files.max_file_size_bytes;

    let pump_boundary = boundary.clone();
    let pump = tokio::spawn(async move {
        let result = pump(multipart, &sender, &pump_boundary, max).await;
        if let Err(err) = &result {
            // Failing the body stream aborts the request to Rails, so it never sees a
            // complete (and thus acceptable) multipart body.
            let _ = sender
                .send(Err(io::Error::other(err.message.clone())))
                .await;
        }
        result
    });

    let sent = state
        .client
        .post(&target)
        .header(reqwest::header::AUTHORIZATION, authorization)
        .header(
            reqwest::header::CONTENT_TYPE,
            format!("multipart/form-data; boundary={boundary}"),
        )
        .body(reqwest::Body::wrap_stream(ReceiverStream::new(receiver)))
        .send()
        .await;

    // The request is finished, so the receiver is gone and the pump ends promptly.
    let pumped = pump.await;
    if let Ok(Err(err)) = &pumped
        && err.status != StatusCode::BAD_GATEWAY
    {
        return error(err.status, err.message.clone());
    }

    match sent {
        Ok(rails_response) => {
            let status = StatusCode::from_u16(rails_response.status().as_u16())
                .unwrap_or(StatusCode::BAD_GATEWAY);
            let body = rails_response.bytes().await.unwrap_or_default();
            // Pass the Rails JSON body through verbatim.
            (status, [(header::CONTENT_TYPE, "application/json")], body).into_response()
        }
        Err(err) => {
            log::error!("Failed to forward upload to Rails: {err}");
            error(StatusCode::BAD_GATEWAY, "Failed to reach storage backend")
        }
    }
}

/// Reads the incoming multipart fields and writes them, re-encoded, to `sender`.
async fn pump(
    mut multipart: Multipart,
    sender: &mpsc::Sender<Result<Bytes, io::Error>>,
    boundary: &str,
    max: u64,
) -> Result<(), UploadError> {
    let mut size: u64 = 0;
    let mut file_name = String::new();
    let mut saw_attachment = false;

    while let Some(mut field) = multipart
        .next_field()
        .await
        .map_err(UploadError::from_multipart)?
    {
        let Some(name) = field.name().map(str::to_owned) else {
            continue;
        };

        if name == "attachment" {
            if saw_attachment {
                return Err(UploadError::new(
                    StatusCode::BAD_REQUEST,
                    "Only one attachment is allowed",
                ));
            }
            saw_attachment = true;

            file_name = field.file_name().unwrap_or("file").to_string();
            let content_type = field
                .content_type()
                .unwrap_or("application/octet-stream")
                .to_string();
            send(
                sender,
                part_header(boundary, &name, Some((&file_name, &content_type))),
            )
            .await?;

            while let Some(chunk) = field.chunk().await.map_err(UploadError::from_multipart)? {
                size += chunk.len() as u64;
                if max != 0 && size > max {
                    return Err(UploadError::new(
                        StatusCode::PAYLOAD_TOO_LARGE,
                        "File exceeds the maximum allowed size",
                    ));
                }
                send(sender, chunk).await?;
            }
            send(sender, Bytes::from_static(b"\r\n")).await?;
        } else {
            let mut value = Vec::new();
            while let Some(chunk) = field.chunk().await.map_err(UploadError::from_multipart)? {
                value.extend_from_slice(&chunk);
                if value.len() > MAX_TEXT_FIELD_BYTES {
                    return Err(UploadError::new(
                        StatusCode::PAYLOAD_TOO_LARGE,
                        format!("Field {name} is too large"),
                    ));
                }
            }
            send(sender, part_header(boundary, &name, None)).await?;
            send(sender, Bytes::from(value)).await?;
            send(sender, Bytes::from_static(b"\r\n")).await?;
        }
    }

    if !saw_attachment {
        return Err(UploadError::new(
            StatusCode::BAD_REQUEST,
            "Missing attachment",
        ));
    }

    log::info!("Proxied upload: name={file_name:?} size={size}");
    send(sender, Bytes::from(format!("--{boundary}--\r\n"))).await
}

async fn send(
    sender: &mpsc::Sender<Result<Bytes, io::Error>>,
    bytes: Bytes,
) -> Result<(), UploadError> {
    sender
        .send(Ok(bytes))
        .await
        .map_err(|_| UploadError::upstream_closed())
}

/// The boundary delimiting the forwarded parts. It is unguessable (128 random bits) so an
/// uploader cannot embed it in file content to smuggle extra fields past the Proxy.
fn boundary() -> String {
    let part = || {
        // every RandomState carries its own random keys
        let mut hasher = RandomState::new().build_hasher();
        hasher.write_u128(
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .map(|elapsed| elapsed.as_nanos())
                .unwrap_or_default(),
        );
        hasher.finish()
    };
    format!("gateway-{:016x}{:016x}", part(), part())
}

/// Encodes the part preamble: delimiter, `Content-Disposition` and (for files) `Content-Type`.
fn part_header(boundary: &str, name: &str, file: Option<(&str, &str)>) -> Bytes {
    let mut header = format!(
        "--{boundary}\r\nContent-Disposition: form-data; name=\"{}\"",
        escape_quoted(name)
    );
    if let Some((file_name, content_type)) = file {
        header.push_str(&format!(
            "; filename=\"{}\"\r\nContent-Type: {}",
            escape_quoted(file_name),
            content_type.replace(['\r', '\n'], "")
        ));
    }
    header.push_str("\r\n\r\n");
    Bytes::from(header)
}

/// Escapes a value for use inside a quoted `Content-Disposition` parameter.
fn escape_quoted(value: &str) -> String {
    value
        .replace('"', "%22")
        .replace('\r', "%0D")
        .replace('\n', "%0A")
}

/// Streams a signed download from Rails back to the caller, keeping the query string
/// (which carries the signature). No `Authorization` is involved: the signature is the
/// capability, and Rails validates it.
async fn storage_objects_download(
    State(state): State<Arc<FileUploadState>>,
    RawQuery(query): RawQuery,
) -> Response {
    let mut target = state.files.rails_storage_download_url.clone();
    if let Some(query) = query {
        target.push('?');
        target.push_str(&query);
    }

    let upstream = match state.client.get(&target).send().await {
        Ok(response) => response,
        Err(err) => {
            log::error!("Failed to fetch download from Rails: {err}");
            return error(StatusCode::BAD_GATEWAY, "Failed to reach storage backend");
        }
    };

    let status =
        StatusCode::from_u16(upstream.status().as_u16()).unwrap_or(StatusCode::BAD_GATEWAY);
    let mut response = Response::builder().status(status);
    for name in &DOWNLOAD_HEADERS {
        if let Some(value) = upstream.headers().get(name) {
            response = response.header(name, value);
        }
    }

    response
        .body(Body::from_stream(upstream.bytes_stream()))
        .unwrap_or_else(|_| error(StatusCode::BAD_GATEWAY, "Invalid storage response"))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::net::SocketAddr;
    use tokio::sync::Mutex;

    use std::collections::HashMap;

    #[derive(Default, Clone)]
    struct Captured {
        authorization: Option<String>,
        text_fields: HashMap<String, String>,
        file_name: Option<String>,
        content_type: Option<String>,
        query: Option<String>,
        size: usize,
    }

    /// Stand-in for the Rails `POST /files/upload` endpoint: records what the
    /// Proxy forwarded and returns the Rails success shape.
    async fn mock_rails(
        State(captured): State<Arc<Mutex<Captured>>>,
        headers: HeaderMap,
        mut multipart: Multipart,
    ) -> Response {
        let mut record = Captured {
            authorization: headers
                .get(header::AUTHORIZATION)
                .and_then(|value| value.to_str().ok())
                .map(String::from),
            ..Captured::default()
        };

        while let Ok(Some(field)) = multipart.next_field().await {
            let name = field.name().map(String::from);
            match name.as_deref() {
                Some("attachment") => {
                    record.file_name = field.file_name().map(String::from);
                    record.size = field.bytes().await.map(|bytes| bytes.len()).unwrap_or(0);
                }
                Some(field_name) => {
                    let field_name = field_name.to_string();
                    if let Ok(value) = field.text().await {
                        record.text_fields.insert(field_name, value);
                    }
                }
                None => {}
            }
        }

        *captured.lock().await = record;
        (
            StatusCode::OK,
            [(header::CONTENT_TYPE, "application/json")],
            r#"{"path":"/rails/active_storage/blob"}"#,
        )
            .into_response()
    }

    /// Stand-in for the Rails `PUT /storage_objects/upload` endpoint: records the headers,
    /// query string and the body size, and answers 404 for the `missing` signature.
    async fn mock_signed_upload(
        RawQuery(query): RawQuery,
        State(captured): State<Arc<Mutex<Captured>>>,
        headers: HeaderMap,
        body: Bytes,
    ) -> Response {
        let query = query.unwrap_or_default();
        let header_value = |name: HeaderName| {
            headers
                .get(name)
                .and_then(|value| value.to_str().ok())
                .map(String::from)
        };
        *captured.lock().await = Captured {
            authorization: header_value(header::AUTHORIZATION),
            content_type: header_value(header::CONTENT_TYPE),
            query: Some(query.clone()),
            size: body.len(),
            ..Captured::default()
        };

        if query.contains("signature=missing") {
            return error(StatusCode::NOT_FOUND, "Not found");
        }
        (
            StatusCode::OK,
            [(header::CONTENT_TYPE, "application/json")],
            format!(r#"{{"byte_size":{}}}"#, body.len()),
        )
            .into_response()
    }

    /// Stand-in for the Rails `GET /storage_objects/download` endpoint: serves a 3 MiB
    /// body for the `big` signature, a 404 for `missing`, and echoes the signature otherwise.
    async fn mock_download(
        RawQuery(query): RawQuery,
        State(captured): State<Arc<Mutex<Captured>>>,
        headers: HeaderMap,
    ) -> Response {
        let query = query.unwrap_or_default();
        captured.lock().await.authorization = headers
            .get(header::AUTHORIZATION)
            .and_then(|value| value.to_str().ok())
            .map(String::from);

        if query.contains("signature=missing") {
            return StatusCode::NOT_FOUND.into_response();
        }

        let body = if query.contains("signature=big") {
            vec![b'x'; 3 * 1024 * 1024]
        } else {
            format!("signed:{query}").into_bytes()
        };
        (
            StatusCode::OK,
            [
                (header::CONTENT_TYPE, "text/plain"),
                (
                    header::CONTENT_DISPOSITION,
                    "attachment; filename=\"a.txt\"",
                ),
            ],
            body,
        )
            .into_response()
    }

    async fn spawn(app: Router) -> SocketAddr {
        let listener = tokio::net::TcpListener::bind("127.0.0.1:0").await.unwrap();
        let addr = listener.local_addr().unwrap();
        tokio::spawn(async move { axum::serve(listener, app).await.unwrap() });
        addr
    }

    /// Boots a mock Rails + the Proxy and returns (proxy_addr, captured_handle).
    async fn harness(max_file_size_bytes: u64) -> (SocketAddr, Arc<Mutex<Captured>>) {
        let captured = Arc::new(Mutex::new(Captured::default()));
        let rails = Router::new()
            .route("/files/upload", post(mock_rails))
            .route(
                "/storage_objects/upload",
                post(mock_rails).put(mock_signed_upload),
            )
            .route("/storage_objects/download", get(mock_download))
            // the stand-in must accept what the Proxy forwards, whatever its size
            .layer(DefaultBodyLimit::disable())
            .with_state(captured.clone());
        let rails_addr = spawn(rails).await;

        let state = FileUploadState::new(
            Files {
                rails_upload_url: format!("http://{rails_addr}/files/upload"),
                rails_storage_upload_url: format!("http://{rails_addr}/storage_objects/upload"),
                rails_storage_download_url: format!("http://{rails_addr}/storage_objects/download"),
                max_file_size_bytes,
            },
            reqwest::Client::new(),
        );
        let proxy_addr = spawn(router(state)).await;
        (proxy_addr, captured)
    }

    fn upload_form(payload: &[u8]) -> reqwest::multipart::Form {
        let part = reqwest::multipart::Part::bytes(payload.to_vec())
            .file_name("hello.txt")
            .mime_str("text/plain")
            .unwrap();
        reqwest::multipart::Form::new()
            .part("attachment", part)
            .text("attachment_name", "avatar")
            .text("id", "gid://sagittarius/User/1")
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn forwards_upload_to_rails_and_passes_response_through() {
        let payload = b"hello world";
        let (proxy_addr, captured) = harness(0).await;

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/files/upload"))
            .header(reqwest::header::AUTHORIZATION, "Bearer test-token")
            .multipart(upload_form(payload))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);
        assert!(
            response
                .text()
                .await
                .unwrap()
                .contains("/rails/active_storage/blob")
        );

        let record = captured.lock().await.clone();
        assert_eq!(record.authorization.as_deref(), Some("Bearer test-token"));
        assert_eq!(
            record
                .text_fields
                .get("attachment_name")
                .map(String::as_str),
            Some("avatar")
        );
        assert_eq!(
            record.text_fields.get("id").map(String::as_str),
            Some("gid://sagittarius/User/1")
        );
        assert_eq!(record.file_name.as_deref(), Some("hello.txt"));
        assert_eq!(record.size, payload.len());
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn forwards_storage_object_upload_with_project_id() {
        let payload = b"stored bytes";
        let (proxy_addr, captured) = harness(0).await;

        let form = reqwest::multipart::Form::new()
            .part(
                "attachment",
                reqwest::multipart::Part::bytes(payload.to_vec())
                    .file_name("doc.txt")
                    .mime_str("text/plain")
                    .unwrap(),
            )
            .text("project_id", "7");

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/storage_objects/upload"))
            .header(reqwest::header::AUTHORIZATION, "Session abc")
            .multipart(form)
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);

        let record = captured.lock().await.clone();
        assert_eq!(
            record.text_fields.get("project_id").map(String::as_str),
            Some("7")
        );
        assert_eq!(record.file_name.as_deref(), Some("doc.txt"));
        assert_eq!(record.size, payload.len());
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn rejects_uploads_over_the_size_cap() {
        let (proxy_addr, _captured) = harness(4).await;

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/files/upload"))
            .header(reqwest::header::AUTHORIZATION, "Bearer test-token")
            .multipart(upload_form(b"this is far too large"))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 413);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn rejects_uploads_without_authorization() {
        let (proxy_addr, _captured) = harness(0).await;

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/files/upload"))
            .multipart(upload_form(b"hello"))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 401);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn forwards_uploads_larger_than_axums_default_body_limit() {
        // 3 MiB exceeds axum's 2 MB default body limit.
        let payload = vec![7u8; 3 * 1024 * 1024];
        let (proxy_addr, captured) = harness(10 * 1024 * 1024).await;

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/storage_objects/upload"))
            .header(reqwest::header::AUTHORIZATION, "Bearer test-token")
            .multipart(upload_form(&payload))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);
        let record = captured.lock().await.clone();
        assert_eq!(record.size, payload.len());
        assert_eq!(record.file_name.as_deref(), Some("hello.txt"));
        // fields that follow the attachment are still forwarded
        assert_eq!(
            record
                .text_fields
                .get("attachment_name")
                .map(String::as_str),
            Some("avatar")
        );
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn forwards_fields_that_precede_the_attachment() {
        let (proxy_addr, captured) = harness(0).await;
        let form = reqwest::multipart::Form::new()
            .text("project_id", "12")
            .text("expires_at", "1700000000000")
            .part(
                "attachment",
                reqwest::multipart::Part::bytes(b"bytes".to_vec())
                    .file_name("a \"quoted\".txt")
                    .mime_str("text/plain")
                    .unwrap(),
            );

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/storage_objects/upload"))
            .header(reqwest::header::AUTHORIZATION, "Bearer test-token")
            .multipart(form)
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);
        let record = captured.lock().await.clone();
        assert_eq!(
            record.text_fields.get("project_id").map(String::as_str),
            Some("12")
        );
        assert_eq!(
            record.text_fields.get("expires_at").map(String::as_str),
            Some("1700000000000")
        );
        assert_eq!(record.size, 5);
        assert_eq!(record.file_name.as_deref(), Some("a %22quoted%22.txt"));
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn rejects_bodies_far_over_the_cap_without_reaching_rails() {
        // 4 MiB against a 1 KiB cap trips the body limit (cap + 1 MiB framing headroom).
        let (proxy_addr, captured) = harness(1024).await;

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/storage_objects/upload"))
            .header(reqwest::header::AUTHORIZATION, "Bearer test-token")
            .multipart(upload_form(&vec![1u8; 4 * 1024 * 1024]))
            .send()
            .await;

        // Depending on timing the client sees the 413 or the aborted connection.
        if let Ok(response) = response {
            assert_eq!(response.status(), 413);
        }
        assert_eq!(captured.lock().await.size, 0);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn rejects_uploads_without_an_attachment() {
        let (proxy_addr, _captured) = harness(0).await;

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/storage_objects/upload"))
            .header(reqwest::header::AUTHORIZATION, "Bearer test-token")
            .multipart(reqwest::multipart::Form::new().text("project_id", "1"))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 400);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn error_responses_carry_a_message_and_error_code() {
        let (proxy_addr, _captured) = harness(4).await;

        let response = reqwest::Client::new()
            .post(format!("http://{proxy_addr}/files/upload"))
            .header(reqwest::header::AUTHORIZATION, "Bearer test-token")
            .multipart(upload_form(b"this is far too large"))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 413);
        let body: serde_json::Value = response.json().await.unwrap();
        assert!(body["message"].is_string());
        assert_eq!(body["error_code"], "file_too_large");
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn download_passes_the_query_string_and_headers_through() {
        let (proxy_addr, captured) = harness(0).await;

        let response = reqwest::Client::new()
            .get(format!(
                "http://{proxy_addr}/storage_objects/download?signature=abc%3D%3D--def"
            ))
            .header(reqwest::header::AUTHORIZATION, "Bearer must-not-leak")
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);
        assert_eq!(response.headers()[header::CONTENT_TYPE], "text/plain");
        assert_eq!(
            response.headers()[header::CONTENT_DISPOSITION],
            "attachment; filename=\"a.txt\""
        );
        assert_eq!(
            response.text().await.unwrap(),
            "signed:signature=abc%3D%3D--def"
        );
        // the signature is the capability; credentials are not forwarded on downloads
        assert_eq!(captured.lock().await.authorization, None);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn download_streams_bodies_larger_than_two_megabytes() {
        let (proxy_addr, _captured) = harness(0).await;

        let response = reqwest::Client::new()
            .get(format!(
                "http://{proxy_addr}/storage_objects/download?signature=big"
            ))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);
        assert_eq!(response.bytes().await.unwrap().len(), 3 * 1024 * 1024);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn download_passes_rails_error_statuses_through() {
        let (proxy_addr, _captured) = harness(0).await;

        let response = reqwest::Client::new()
            .get(format!(
                "http://{proxy_addr}/storage_objects/download?signature=missing"
            ))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 404);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn signed_upload_streams_the_body_and_passes_query_and_response_through() {
        let (proxy_addr, captured) = harness(0).await;

        let response = reqwest::Client::new()
            .put(format!(
                "http://{proxy_addr}/storage_objects/upload?signature=abc%3D%3D--def"
            ))
            .header(reqwest::header::CONTENT_TYPE, "application/pdf")
            .header(reqwest::header::AUTHORIZATION, "Bearer must-not-leak")
            .body("raw file bytes")
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);
        assert_eq!(response.headers()[header::CONTENT_TYPE], "application/json");
        assert_eq!(response.text().await.unwrap(), r#"{"byte_size":14}"#);

        let record = captured.lock().await.clone();
        assert_eq!(record.query.as_deref(), Some("signature=abc%3D%3D--def"));
        assert_eq!(record.content_type.as_deref(), Some("application/pdf"));
        assert_eq!(record.size, 14);
        // the signature is the capability; credentials are not forwarded
        assert_eq!(record.authorization, None);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn signed_upload_streams_bodies_larger_than_two_megabytes() {
        let (proxy_addr, captured) = harness(10 * 1024 * 1024).await;

        let response = reqwest::Client::new()
            .put(format!(
                "http://{proxy_addr}/storage_objects/upload?signature=big"
            ))
            .body(vec![7u8; 3 * 1024 * 1024])
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 200);
        assert_eq!(captured.lock().await.size, 3 * 1024 * 1024);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn signed_upload_rejects_a_declared_length_over_the_cap_without_reaching_rails() {
        let (proxy_addr, captured) = harness(4).await;

        let response = reqwest::Client::new()
            .put(format!(
                "http://{proxy_addr}/storage_objects/upload?signature=abc"
            ))
            .body("this is far too large")
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 413);
        let body: serde_json::Value = response.json().await.unwrap();
        assert_eq!(body["error_code"], "file_too_large");
        assert_eq!(captured.lock().await.query, None);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn signed_upload_enforces_the_cap_on_a_chunked_stream() {
        let (proxy_addr, _captured) = harness(8).await;

        // no Content-Length: the size is only known while streaming
        let chunks = futures_chunks(vec![b"12345".to_vec(), b"67890".to_vec()]);
        let response = reqwest::Client::new()
            .put(format!(
                "http://{proxy_addr}/storage_objects/upload?signature=abc"
            ))
            .body(reqwest::Body::wrap_stream(chunks))
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 413);
    }

    #[tokio::test(flavor = "multi_thread")]
    async fn signed_upload_passes_rails_error_statuses_through() {
        let (proxy_addr, _captured) = harness(0).await;

        let response = reqwest::Client::new()
            .put(format!(
                "http://{proxy_addr}/storage_objects/upload?signature=missing"
            ))
            .body("bytes")
            .send()
            .await
            .unwrap();

        assert_eq!(response.status(), 404);
        let body: serde_json::Value = response.json().await.unwrap();
        assert_eq!(body["message"], "Not found");
    }

    fn futures_chunks(
        chunks: Vec<Vec<u8>>,
    ) -> impl tokio_stream::Stream<Item = Result<Vec<u8>, io::Error>> {
        tokio_stream::iter(chunks.into_iter().map(Ok))
    }
}
