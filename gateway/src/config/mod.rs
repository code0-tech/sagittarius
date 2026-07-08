#![allow(dead_code)]

use std::path::Path;

use config::{Config as ConfigLoader, ConfigError, File};
use serde::{Deserialize, Serialize};

const CONFIG_FILE: &str = "gateway";

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Config {
    pub backend: Backend,
    pub grpc: Grpc,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Backend {
    pub url: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(default)]
pub struct Grpc {
    port: u16,
    host: String,
}

impl Default for Grpc {
    fn default() -> Self {
        Self {
            port: 50051,
            host: String::from("127.0.0.1"),
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

impl Default for Config {
    fn default() -> Self {
        Self {
            backend: Default::default(),
            grpc: Default::default(),
        }
    }
}

impl Config {
    pub fn new() -> Self {
        Self::try_new()
            .unwrap_or_else(|error| panic!("failed to load Aquila configuration: {error}"))
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
