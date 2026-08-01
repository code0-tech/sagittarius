//! Runtime version resolution.
//!
//! `env!("CARGO_PKG_VERSION")` is a compile-time constant, so stamping a
//! per-pipeline release version into `Cargo.toml` before `cargo build` (as
//! CI used to) invalidates the build cache for every crate that reads it on
//! every single build. Reading `GATEWAY_VERSION` at runtime instead lets the
//! image's final Docker layer stamp the release version without touching
//! anything upstream of it. Falls back to the compiled-in crate version when
//! the env var isn't set (local dev, tests).

use std::sync::OnceLock;

static VERSION: OnceLock<String> = OnceLock::new();

pub fn runtime_version() -> &'static str {
    VERSION.get_or_init(|| {
        std::env::var("GATEWAY_VERSION").unwrap_or_else(|_| env!("CARGO_PKG_VERSION").to_string())
    })
}
