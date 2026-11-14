use std::collections::HashMap;
use std::sync::Arc;
use std::time::Duration;

use async_trait::async_trait;
use tokio::sync::{Mutex, mpsc};
use tonic::Status;

/// Decides whether a connected Aquila stream is still allowed to stay open.
///
/// Implemented against Rails' token service in production; the registry only depends on this
/// trait so the disconnect behaviour can be unit tested without a live Rails connection.
#[async_trait]
pub trait TokenValidator: Send + Sync {
    /// Returns `true` while `token` still authenticates as `runtime_id`. Once the runtime token is
    /// rotated the old token stops verifying and this returns `false`.
    async fn is_token_valid(&self, runtime_id: i64, token: String) -> bool;
}

/// A registry whose connected streams can be re-validated by the shared revalidation task,
/// regardless of the concrete response type each service streams.
#[async_trait]
pub trait Revalidatable: Send + Sync {
    async fn disconnect_rotated(&self, validator: &dyn TokenValidator);
}

/// A connected Aquila stream together with the authentication token it logged on with. The token
/// is retained so it can be re-validated against Rails: once a runtime's token is rotated the old
/// token no longer verifies and the stream is disconnected.
struct StreamEntry<T> {
    sender: mpsc::Sender<Result<T, Status>>,
    token: String,
}

/// The Aquila streams a gateway service currently holds open, keyed by runtime id.
pub struct StreamRegistry<T> {
    streams: Mutex<HashMap<i64, StreamEntry<T>>>,
    stream_kind: &'static str,
}

impl<T> StreamRegistry<T>
where
    T: Send + 'static,
{
    /// `stream_kind` names the stream in log and error messages, e.g. `"flow"`.
    pub fn new(stream_kind: &'static str) -> Arc<Self> {
        Arc::new(Self {
            streams: Mutex::new(HashMap::new()),
            stream_kind,
        })
    }

    /// Registers a freshly connected stream. Fails if the runtime already has one connected.
    pub async fn register(
        &self,
        runtime_id: i64,
        token: String,
        sender: mpsc::Sender<Result<T, Status>>,
    ) -> Result<(), Status> {
        let mut streams = self.streams.lock().await;

        if streams.contains_key(&runtime_id) {
            return Err(Status::already_exists(format!(
                "Aquila {} stream is already connected for runtime",
                self.stream_kind
            )));
        }

        streams.insert(runtime_id, StreamEntry { sender, token });
        Ok(())
    }

    /// Drops the stream for `runtime_id`, if any. Used when a stream closes on its own.
    pub async fn remove(&self, runtime_id: i64) {
        self.streams.lock().await.remove(&runtime_id);
    }

    /// Returns a sender for pushing onto the runtime's stream, or `unavailable` if none is connected.
    pub async fn sender_for(
        &self,
        runtime_id: i64,
    ) -> Result<mpsc::Sender<Result<T, Status>>, Status> {
        self.streams
            .lock()
            .await
            .get(&runtime_id)
            .map(|entry| entry.sender.clone())
            .ok_or_else(|| {
                Status::unavailable(format!(
                    "no Aquila {} stream connected for runtime {runtime_id}",
                    self.stream_kind
                ))
            })
    }

    /// Removes and returns the runtime's stream sender only if it still holds `token`.
    async fn take_if_token(
        &self,
        runtime_id: i64,
        token: &str,
    ) -> Option<mpsc::Sender<Result<T, Status>>> {
        let mut streams = self.streams.lock().await;

        match streams.get(&runtime_id) {
            Some(entry) if entry.token == token => streams.remove(&runtime_id).map(|e| e.sender),
            _ => None,
        }
    }
}

#[async_trait]
impl<T> Revalidatable for StreamRegistry<T>
where
    T: Send + 'static,
{
    /// Re-validates every connected stream's logon token and disconnects the ones whose token no
    /// longer verifies, e.g. because the runtime token was rotated. The runtime observes its stream
    /// ending with an `unauthenticated` status and must reconnect with its new token.
    async fn disconnect_rotated(&self, validator: &dyn TokenValidator) {
        let connected: Vec<(i64, String)> = {
            let streams = self.streams.lock().await;
            streams
                .iter()
                .map(|(runtime_id, entry)| (*runtime_id, entry.token.clone()))
                .collect()
        };

        for (runtime_id, token) in connected {
            if validator.is_token_valid(runtime_id, token.clone()).await {
                continue;
            }

            // Re-check and remove under the lock so a stream that reconnected with a new, valid
            // token in the meantime is not torn down by this stale verdict.
            if let Some(sender) = self.take_if_token(runtime_id, &token).await {
                log::info!(
                    "Disconnecting Aquila {} stream for runtime {}: token is no longer valid.",
                    self.stream_kind,
                    runtime_id
                );
                let _ = sender
                    .send(Err(Status::unauthenticated(
                        "Aquila authentication token is no longer valid",
                    )))
                    .await;
            }
        }
    }
}

/// Spawns the single background task that disconnects streams whose token has been rotated. It
/// sweeps every registry (one per streaming service) on each tick. A zero interval disables it.
pub fn spawn_token_revalidation(
    registries: Vec<Arc<dyn Revalidatable>>,
    validator: Arc<dyn TokenValidator>,
    interval: Duration,
) {
    if interval.is_zero() || registries.is_empty() {
        return;
    }

    tokio::spawn(async move {
        let mut ticker = tokio::time::interval(interval);
        // The first tick fires immediately; skip it so streams are not re-validated the moment
        // they connect.
        ticker.tick().await;

        loop {
            ticker.tick().await;
            for registry in &registries {
                registry.disconnect_rotated(validator.as_ref()).await;
            }
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::HashSet;

    struct FakeValidator {
        valid_tokens: HashSet<String>,
    }

    impl FakeValidator {
        fn accepting<I: IntoIterator<Item = &'static str>>(tokens: I) -> Self {
            Self {
                valid_tokens: tokens.into_iter().map(str::to_owned).collect(),
            }
        }
    }

    #[async_trait]
    impl TokenValidator for FakeValidator {
        async fn is_token_valid(&self, _runtime_id: i64, token: String) -> bool {
            self.valid_tokens.contains(&token)
        }
    }

    async fn register_test_stream(
        registry: &StreamRegistry<i32>,
        runtime_id: i64,
        token: &str,
    ) -> mpsc::Receiver<Result<i32, Status>> {
        let (tx, rx) = mpsc::channel(4);
        registry
            .register(runtime_id, token.to_owned(), tx)
            .await
            .expect("stream should register");
        rx
    }

    #[tokio::test]
    async fn register_rejects_duplicate_runtime() {
        let registry = StreamRegistry::<i32>::new("flow");
        let _rx = register_test_stream(&registry, 1, "token").await;

        let (tx, _rx2) = mpsc::channel(4);
        let error = registry
            .register(1, "token".to_owned(), tx)
            .await
            .expect_err("duplicate runtime should be rejected");

        assert_eq!(error.code(), tonic::Code::AlreadyExists);
    }

    #[tokio::test]
    async fn disconnect_rotated_closes_streams_with_invalid_tokens() {
        let registry = StreamRegistry::<i32>::new("flow");
        let mut rx = register_test_stream(&registry, 1, "old-token").await;

        registry
            .disconnect_rotated(&FakeValidator::accepting([]))
            .await;

        let item = rx.recv().await.expect("stream should receive a status");
        assert_eq!(item.unwrap_err().code(), tonic::Code::Unauthenticated);
        assert!(rx.recv().await.is_none(), "stream should be closed");
        assert!(
            registry.sender_for(1).await.is_err(),
            "stream should be removed from the registry"
        );
    }

    #[tokio::test]
    async fn disconnect_rotated_keeps_streams_with_valid_tokens() {
        let registry = StreamRegistry::<i32>::new("flow");
        let _rx = register_test_stream(&registry, 1, "valid-token").await;

        registry
            .disconnect_rotated(&FakeValidator::accepting(["valid-token"]))
            .await;

        assert!(
            registry.sender_for(1).await.is_ok(),
            "valid stream should stay connected"
        );
    }

    #[tokio::test]
    async fn take_if_token_ignores_stream_that_reconnected_with_a_new_token() {
        let registry = StreamRegistry::<i32>::new("flow");
        // The runtime reconnected with a rotated token under the same id.
        let _rx = register_test_stream(&registry, 1, "new-token").await;

        // A stale verdict about the old token must not tear down the reconnected stream.
        assert!(registry.take_if_token(1, "old-token").await.is_none());
        assert!(
            registry.sender_for(1).await.is_ok(),
            "reconnected stream must survive the stale verdict"
        );
    }
}
