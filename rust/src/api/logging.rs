use std::sync::{Mutex, OnceLock};

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use serde::Serialize;

#[derive(Debug, Clone, Serialize)]
#[frb(non_opaque)]
pub enum BridgeLogLevel {
    Trace,
    Debug,
    Info,
    Warn,
    Error,
}

#[derive(Debug, Clone, Serialize)]
#[frb(non_opaque)]
pub struct BridgeLogEntry {
    pub level: BridgeLogLevel,
    pub source: String,
    pub message: String,
    pub caller: String,
    pub timestamp_millis: u64,
}

static LOG_SINK: OnceLock<Mutex<Option<StreamSink<BridgeLogEntry>>>> = OnceLock::new();

fn sink_cell() -> &'static Mutex<Option<StreamSink<BridgeLogEntry>>> {
    LOG_SINK.get_or_init(|| Mutex::new(None))
}

fn now_millis() -> u64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .map(|duration| duration.as_millis() as u64)
        .unwrap_or_default()
}

pub fn create_log_stream(sink: StreamSink<BridgeLogEntry>) {
    if let Ok(mut slot) = sink_cell().lock() {
        *slot = Some(sink);
    }
    log_info("logging", "Rust log stream connected");
}

pub(crate) fn emit_log(
    level: BridgeLogLevel,
    source: impl Into<String>,
    message: impl Into<String>,
    caller: &'static std::panic::Location<'static>,
) {
    let entry = BridgeLogEntry {
        level,
        source: source.into(),
        message: message.into(),
        caller: format!("{}:{}:{}", caller.file(), caller.line(), caller.column()),
        timestamp_millis: now_millis(),
    };

    if let Ok(slot) = sink_cell().lock() {
        if let Some(sink) = slot.as_ref() {
            let _ = sink.add(entry);
        }
    }
}

#[track_caller]
pub(crate) fn log_debug(source: impl Into<String>, message: impl Into<String>) {
    emit_log(
        BridgeLogLevel::Debug,
        source,
        message,
        std::panic::Location::caller(),
    );
}

#[track_caller]
pub(crate) fn log_info(source: impl Into<String>, message: impl Into<String>) {
    emit_log(
        BridgeLogLevel::Info,
        source,
        message,
        std::panic::Location::caller(),
    );
}

#[track_caller]
pub(crate) fn log_warn(source: impl Into<String>, message: impl Into<String>) {
    emit_log(
        BridgeLogLevel::Warn,
        source,
        message,
        std::panic::Location::caller(),
    );
}

#[track_caller]
pub(crate) fn log_error(source: impl Into<String>, message: impl Into<String>) {
    emit_log(
        BridgeLogLevel::Error,
        source,
        message,
        std::panic::Location::caller(),
    );
}
