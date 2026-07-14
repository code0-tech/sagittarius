#![allow(dead_code)]

use std::{fmt, path::Path};

use code0_flow::flow_telemetry::OpenTelemetry;
use config::{Config as ConfigLoader, ConfigError, File};
use serde::{Deserialize, Serialize};

const CONFIG_FILE: &str = "gateway";

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
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Backend {
    pub url: String,
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
        }
    }
}

impl Default for Backend {
    fn default() -> Self {
        Self {
            url: String::from("http://localhost:50051"),
        }
    }
}

impl Config {
    pub fn new() -> Self {
        Self::try_new()
            .unwrap_or_else(|error| panic!("failed to load Gateway configuration: {error}"))
    }

    pub fn try_new() -> Result<Self, ConfigError> {
        Self::try_from_optional_path(None)
    }

    pub fn try_from_path(path: impl AsRef<Path>) -> Result<Self, ConfigError> {
        Self::try_from_optional_path(Some(path.as_ref()))
    }

    fn try_from_optional_path(path: Option<&Path>) -> Result<Self, ConfigError> {
        let mut builder =
            ConfigLoader::builder().add_source(ConfigLoader::try_from(&Self::default())?);

        builder = match path {
            Some(path) => builder.add_source(File::from(path).required(true)),
            None => builder.add_source(File::with_name(CONFIG_FILE).required(false)),
        };

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
