use super::{ErrorTypes, InternalEvent};
use metrics::counter;
use std::num::ParseFloatError;

pub(crate) struct LogToMetricEventProcessed;

impl InternalEvent for LogToMetricEventProcessed {
    fn emit_logs(&self) {
        trace!(message = "Processed one event.");
    }

    fn emit_metrics(&self) {
        counter!("events_processed_total", 1);
    }
}

pub(crate) struct LogToMetricFieldNotFound<'a> {
    pub field: &'a str,
}

impl<'a> InternalEvent for LogToMetricFieldNotFound<'a> {
    fn emit_logs(&self) {
        warn!(
            message = "Field not found.",
            missing_field = %self.field,
            rate_limit_sec = 30
        );
    }

    fn emit_metrics(&self) {
        counter!("processing_errors_total", 1,
                 "error_type" => ErrorTypes::FieldMissing.to_str(),
        );
    }
}

pub(crate) struct LogToMetricParseFloatError<'a> {
    pub field: &'a str,
    pub error: ParseFloatError,
}

impl<'a> InternalEvent for LogToMetricParseFloatError<'a> {
    fn emit_logs(&self) {
        warn!(
            message = "Failed to parse field as float.",
            field = %self.field,
            error = ?self.error,
            rate_limit_secs = 30
        );
    }

    fn emit_metrics(&self) {
        counter!("processing_errors_total", 1,
                 "error_type" => ErrorTypes::ParseFailed.to_str(),
        );
    }
}

pub(crate) struct LogToMetricTemplateRenderError {
    pub missing_keys: Vec<String>,
}

impl InternalEvent for LogToMetricTemplateRenderError {
    fn emit_logs(&self) {
        let error = format!("Keys {:?} do not exist on the event.", self.missing_keys);
        warn!(
            message = "Failed to render template.",
            %error,
            rate_limit_secs = 30
        );
    }

    fn emit_metrics(&self) {
        counter!("processing_errors_total", 1,
                 "error_type" => ErrorTypes::RenderError.to_str(),
        );
    }
}

pub(crate) struct LogToMetricTemplateParseError {
    pub error: crate::template::TemplateError,
}

impl InternalEvent for LogToMetricTemplateParseError {
    fn emit_logs(&self) {
        warn!(message = "Failed to parse template.", error = ?self.error, rate_limit_secs = 30);
    }

    fn emit_metrics(&self) {
        counter!("processing_errors_total", 1,
                 "error_type" => ErrorTypes::TemplateError.to_str(),
        );
    }
}
