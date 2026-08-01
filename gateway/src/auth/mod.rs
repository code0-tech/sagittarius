use std::sync::Arc;
use std::time::{SystemTime, UNIX_EPOCH};

use jsonwebtoken::{Algorithm, DecodingKey, EncodingKey, Header, Validation, decode, encode};
use serde::{Deserialize, Serialize};
use tonic::Status;
use tonic::metadata::{MetadataMap, MetadataValue};

const BEARER_SCHEME: &str = "Bearer ";

#[derive(Debug, Deserialize, Serialize)]
struct Claims {
    sub: String,
    exp: u64,
}

#[derive(Clone)]
pub struct JwtClient {
    encoding_key: Arc<EncodingKey>,
    ttl_seconds: u64,
}

impl JwtClient {
    pub fn new_hs256(secret: &[u8], ttl_seconds: u64) -> Self {
        Self {
            encoding_key: Arc::new(EncodingKey::from_secret(secret)),
            ttl_seconds,
        }
    }

    pub fn authorization_for_runtime(
        &self,
        runtime_id: i64,
    ) -> Result<MetadataValue<tonic::metadata::Ascii>, Status> {
        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .map_err(|_| Status::internal("system clock is before the Unix epoch"))?
            .as_secs();
        let token = encode(
            &Header::new(Algorithm::HS256),
            &Claims {
                sub: runtime_id.to_string(),
                exp: now.saturating_add(self.ttl_seconds),
            },
            self.encoding_key.as_ref(),
        )
        .map_err(|_| Status::internal("failed to create Rails authentication JWT"))?;

        format!("{BEARER_SCHEME}{token}")
            .parse()
            .map_err(|_| Status::internal("failed to create authorization metadata"))
    }
}

#[derive(Clone)]
pub struct JwtVerifier {
    decoding_key: Arc<DecodingKey>,
    validation: Validation,
}

// Verifier for incoming push requests from SagittariusRails.
impl JwtVerifier {
    pub fn new_hs256(secret: &[u8]) -> Self {
        let mut validation = Validation::new(Algorithm::HS256);

        // Require these claims to exist.
        validation.set_required_spec_claims(&["sub"]);

        // Verify that the token was issued for this service.
        // validation.set_issuer(&[""]);
        // validation.set_audience(&[""]);

        Self {
            decoding_key: Arc::new(DecodingKey::from_secret(secret)),
            validation,
        }
    }

    pub fn runtime_id_from_metadata(&self, metadata: &MetadataMap) -> Result<i64, Status> {
        let authorization = authorization_metadata(metadata)?;

        let token = authorization
            .strip_prefix(BEARER_SCHEME)
            .ok_or_else(|| Status::unauthenticated("authorization must use the Bearer scheme"))?;

        let token_data = decode::<Claims>(token, self.decoding_key.as_ref(), &self.validation)
            .map_err(|_| Status::unauthenticated("invalid or expired JWT"))?;

        token_data
            .claims
            .sub
            .parse::<i64>()
            .map_err(|_| Status::unauthenticated("JWT subject must contain an integer runtime_id"))
    }
}

pub fn authorization_metadata(metadata: &MetadataMap) -> Result<&str, Status> {
    metadata
        .get("authorization")
        .ok_or_else(|| Status::unauthenticated("missing authorization metadata"))?
        .to_str()
        .map_err(|_| Status::unauthenticated("invalid authorization metadata"))
}

pub fn authentication_token(metadata: &MetadataMap) -> Result<String, Status> {
    let authentication = metadata
        .get("authentication")
        .ok_or_else(|| Status::unauthenticated("missing authentication metadata"))?
        .to_str()
        .map_err(|_| Status::unauthenticated("invalid authentication metadata"))?;

    Ok(authentication
        .strip_prefix(BEARER_SCHEME)
        .unwrap_or(authentication)
        .to_owned())
}

#[cfg(test)]
mod tests {
    use super::*;
    use jsonwebtoken::{EncodingKey, Header, encode};
    use serde::Serialize;

    #[derive(Serialize)]
    struct TestClaims {
        sub: String,
        exp: usize,
    }

    #[test]
    fn verifies_runtime_id_from_jwt_subject() {
        let token = encode(
            &Header::default(),
            &TestClaims {
                sub: "42".to_owned(),
                exp: 4_102_444_800,
            },
            &EncodingKey::from_secret(b"secret"),
        )
        .unwrap();
        let mut metadata = MetadataMap::new();
        metadata.insert("authorization", format!("Bearer {token}").parse().unwrap());

        let verifier = JwtVerifier::new_hs256(b"secret");

        assert_eq!(verifier.runtime_id_from_metadata(&metadata).unwrap(), 42);
    }

    #[test]
    fn rejects_non_integer_subject() {
        let token = encode(
            &Header::default(),
            &TestClaims {
                sub: "runtime-42".to_owned(),
                exp: 4_102_444_800,
            },
            &EncodingKey::from_secret(b"secret"),
        )
        .unwrap();
        let mut metadata = MetadataMap::new();
        metadata.insert("authorization", format!("Bearer {token}").parse().unwrap());

        let verifier = JwtVerifier::new_hs256(b"secret");

        assert!(verifier.runtime_id_from_metadata(&metadata).is_err());
    }

    #[test]
    fn creates_authorization_jwt_with_runtime_id_as_subject() {
        let client = JwtClient::new_hs256(b"secret", 60);

        let authorization = client.authorization_for_runtime(42).unwrap();
        let token = authorization
            .to_str()
            .unwrap()
            .strip_prefix(BEARER_SCHEME)
            .unwrap();
        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(b"secret"),
            &Validation::new(Algorithm::HS256),
        )
        .unwrap();

        assert_eq!(token_data.claims.sub, "42");
        assert!(token_data.claims.exp > 0);
    }
}
