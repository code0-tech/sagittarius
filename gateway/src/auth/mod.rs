use std::sync::Arc;

use jsonwebtoken::{Algorithm, DecodingKey, Validation, decode};
use serde::Deserialize;
use tonic::Status;
use tonic::metadata::{MetadataMap, MetadataValue};

const BEARER_SCHEME: &str = "Bearer ";

#[derive(Debug, Deserialize)]
struct Claims {
    sub: String,
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

pub fn authentication_metadata(
    metadata: &MetadataMap,
) -> Result<MetadataValue<tonic::metadata::Ascii>, Status> {
    metadata
        .get("authentication")
        .cloned()
        .ok_or_else(|| Status::unauthenticated("missing authentication metadata"))
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
}
