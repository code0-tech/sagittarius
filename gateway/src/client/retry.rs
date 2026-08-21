use std::future::Future;
use std::time::Duration;

use serde::{Deserialize, Serialize};
use tonic::{Code, Status};

/// Retry behaviour for calls to Rails. Configurable via `gateway.yml`
/// (`backend.retry`) so operators can tune it per environment without a
/// rebuild.
#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct RetryPolicy {
    /// Total number of attempts per call, including the first one. `1`
    /// disables retrying.
    pub max_attempts: u32,
    /// Delay before the first retry.
    pub initial_backoff_ms: u64,
    /// Multiplier applied to the backoff after every retry.
    pub backoff_multiplier: f64,
}

impl Default for RetryPolicy {
    fn default() -> Self {
        Self {
            max_attempts: 3,
            initial_backoff_ms: 100,
            backoff_multiplier: 2.0,
        }
    }
}

impl RetryPolicy {
    /// A policy that never retries, useful for tests.
    pub fn disabled() -> Self {
        Self {
            max_attempts: 1,
            ..Self::default()
        }
    }
}

/// Whether a failed call is worth retrying. Only transient/connectivity
/// errors qualify - request errors like `InvalidArgument` or
/// `Unauthenticated` are stable across retries and would only waste time.
fn is_retryable(status: &Status) -> bool {
    matches!(
        status.code(),
        Code::Unavailable | Code::DeadlineExceeded | Code::Aborted | Code::ResourceExhausted
    )
}

/// Retries a unary Rails gRPC call according to `policy`, backing off
/// exponentially between attempts. The lazy channel reconnects automatically
/// on the next call after a broken connection, so a bounded number of
/// retries is enough to ride out a transient outage instead of failing the
/// caller's request outright.
pub async fn retry<F, Fut, T>(policy: &RetryPolicy, mut call: F) -> Result<T, Status>
where
    F: FnMut() -> Fut,
    Fut: Future<Output = Result<T, Status>>,
{
    let max_attempts = policy.max_attempts.max(1);
    let mut backoff = Duration::from_millis(policy.initial_backoff_ms);

    for attempt in 1..=max_attempts {
        match call().await {
            Ok(value) => return Ok(value),
            Err(status) if attempt < max_attempts && is_retryable(&status) => {
                log::warn!(
                    "Rails call failed with {:?} (attempt {}/{}), retrying in {:?}",
                    status.code(),
                    attempt,
                    max_attempts,
                    backoff
                );
                tokio::time::sleep(backoff).await;
                backoff = backoff.mul_f64(policy.backoff_multiplier.max(1.0));
            }
            Err(status) => return Err(status),
        }
    }

    unreachable!("loop always returns on the final attempt")
}
