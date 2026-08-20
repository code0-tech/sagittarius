#![allow(dead_code)]

use std::{fmt, path::Path};

use code0_flow::flow_telemetry::OpenTelemetry;
use config::{Config as ConfigLoader, ConfigError, File};
use serde::{Deserialize, Serialize};

use crate::client::retry::RetryPolicy;

const CONFIG_FILE_ENV_VAR: &str = "GATEWAY_CONFIG_PATH";
const DEFAULT_CONFIG_PATH: &str = "gateway.yml";

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Config {
    pub environment: String,
    pub log_level: String,
    #[serde(alias = "telemetry")]
    #[serde(default = "default_opentelemetry")]
    pub opentelemetry: OpenTelemetry,
    pub auth: Auth,
    pub backend: Backend,
    pub grpc: Grpc,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Auth {
    pub jwt_secret: String,
    pub jwt_ttl_seconds: u64,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Backend {
    pub url: String,
    pub retry: RetryPolicy,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Grpc {
    pub port: u16,
    pub host: String,
    pub with_health_service: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            environment: "development".into(),
            log_level: "debug".into(),
            opentelemetry: default_opentelemetry(),
            auth: Auth::default(),
            backend: Backend::default(),
            grpc: Grpc::default(),
        }
    }
}

fn default_opentelemetry() -> OpenTelemetry {
    OpenTelemetry {
        service_name: env!("CARGO_PKG_NAME").into(),
        ..OpenTelemetry::default()
    }
}

impl Default for Grpc {
    fn default() -> Self {
        Self {
            port: 50051,
            host: String::from("127.0.0.1"),
            with_health_service: false,
        }
    }
}

impl Default for Auth {
    fn default() -> Self {
        Self {
            jwt_secret: String::from("jwt-secret"),
            jwt_ttl_seconds: 300,
        }
    }
}

impl Default for Backend {
    fn default() -> Self {
        Self {
            url: String::from("http://localhost:50051"),
            retry: RetryPolicy::default(),
        }
    }
}

impl Config {
    pub fn new() -> Self {
        Self::try_new()
            .unwrap_or_else(|error| panic!("failed to load Gateway configuration: {error}"))
    }

    pub fn try_new() -> Result<Self, ConfigError> {
        match std::env::var(CONFIG_FILE_ENV_VAR) {
            Ok(path) => Self::try_from_path(path, true),
            Err(_) => Self::try_from_path(DEFAULT_CONFIG_PATH, false),
        }
    }

    pub fn try_from_path(path: impl AsRef<Path>, required: bool) -> Result<Self, ConfigError> {
        let mut builder =
            ConfigLoader::builder().add_source(ConfigLoader::try_from(&Self::default())?);

        builder = builder.add_source(File::from(path.as_ref()).required(required));

        builder.build()?.try_deserialize()
    }
}

impl fmt::Display for Config {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(formatter, "Gateway configuration")?;
        writeln!(formatter, "  Environment: {}", self.environment)?;
        writeln!(formatter, "  Log level:   {}", self.log_level)?;
        writeln!(formatter, "  OpenTelemetry")?;
        writeln!(formatter, "    Enabled:   {}", self.opentelemetry.enabled)?;
        writeln!(
            formatter,
            "    Service:   {}",
            self.opentelemetry.service_name
        )?;
        writeln!(
            formatter,
            "    Logs:      {}",
            display_optional_url(&self.opentelemetry.logs_endpoint)
        )?;
        writeln!(
            formatter,
            "    Metrics:   {}",
            display_optional_url(&self.opentelemetry.metrics_endpoint)
        )?;
        writeln!(
            formatter,
            "    Traces:    {}",
            display_optional_url(&self.opentelemetry.traces_endpoint)
        )?;
        writeln!(formatter, "  Backend")?;
        writeln!(formatter, "    URL:       {}", self.backend.url)?;
        writeln!(
            formatter,
            "    Retry:     {} attempts, {}ms initial backoff, x{} multiplier",
            self.backend.retry.max_attempts,
            self.backend.retry.initial_backoff_ms,
            self.backend.retry.backoff_multiplier
        )?;
        writeln!(formatter, "  gRPC")?;
        writeln!(
            formatter,
            "    Address:   {}:{}",
            self.grpc.host, self.grpc.port
        )?;
        write!(
            formatter,
            "    Health service: {}",
            self.grpc.with_health_service
        )
    }
}

fn display_optional_url(url: &Option<String>) -> &str {
    url.as_deref()
        .filter(|value| !value.trim().is_empty())
        .unwrap_or("<disabled>")
}
