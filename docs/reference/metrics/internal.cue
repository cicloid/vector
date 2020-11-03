package metadata

_metrics: _internal: {
	_default_tags:   _metrics._tags._default._internal_metrics
	_component_tags: _default_tags & _metrics._tags._default._component

	_api_started_total: {
		description: "The number of times the Vector GraphQL API has been started."
		required:    false
		type:        "counter"
		tags:        _default_tags
	}
	_auto_concurrency_averaged_rtt: {
		type: "histogram"
		tags: _default_tags
	}
	_auto_concurrency_in_flight: {
		description: "The number of outbound requests from the HTTP sink currently awaiting a response."
		type:        "histogram"
		tags:        _default_tags
	}
	_auto_concurrency_limit: {
		description: ""
		type:        "histogram"
		tags:        _default_tags
	}
	_auto_concurrency_observed_rtt: {
		type: "histogram"
		tags: _default_tags
	}
	_checkpoint_write_errors_total: {
		description: "The total number of errors writing checkpoints."
		type: "counter"
	}
	_checkpoints_total: {
		description: "The total number of files checkpointed."
		type: "counter"
	}
	_checksum_errors: {
		description: ""
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_collect_duration_nanoseconds: {
		type: "histogram"
	}
	_events_processed_total: {
		description: "The total number of events processed by this component."
		required:    true
		type:        "counter"
		tags:        _component_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_file_delete_errors: {
		description: "The total number of failures to delete a file."
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_file_watch_errors: {
		description: "The total number of errors caused by failure to watch a file."
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_files_added: {
		description: "The total number of files Vector has found to watch."
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_files_deleted: {
		description: "The total number of files deleted."
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_files_resumed: {
		description: "The total number of times Vector has resumed watching a file."
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_files_unwatched: {
		description: "The total number of times Vector has stopped watching a file."
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_fingerprint_read_errors: {
		description: "The total number of times failing to read a file for fingerprinting."
		type: "counter"
		tags: _default_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_http_bad_requests_total: {
		description: "The total number of HTTP `400 Bad Request` errors encountered."
		type: "counter"
	}
	_http_error_response_total: {
		type: "counter"
	}
	_http_request_errors_total: {
		type: "counter"
	}
	_memory_used: {
		type: "gauge"
	}
	_missing_keys_total: {
		description: "The total number of events dropped due to keys missing from the event."
		type: "counter"
	}
	_open_connections: {
		description: "The number of current open connections to Vector."
		type:        "gauge"
	}
	_parse_errors_total: {
		type: "counter"
	}
	_processed_bytes_total: {
		description: "The total number of bytes processed by the component."
		required:    true
		type:        "counter"
		tags:        _component_tags & {
			file: { required: false /* TODO */ }
		}
	}
	_processing_errors_total: {
		type: "counter"
		tags: _default_tags & {
			error_type: {
				description: "The type of the error"
				required:    true
				type: string: enum: {
					convert_failed:         ""
					failed_mapping:         ""
					failed_match:           ""
					failed_parse:           ""
					failed_serialize:       ""
					field_missing:          "The field is missing from the event."
					field_not_found:        ""
					invalid_metric:         ""
					parse_error:            ""
					render_error:           ""
					target_field_exists:    ""
					template_error:         ""
					type_conversion_failed: "Failed to convert from one type to another."
					value_invalid:          "The value produced is invalid."
				}
			}
		}
	}
	_request_duration_nanoseconds: {
		type: "histogram"
		tags: _component_tags
	}
	_requests_completed_total: {
		type: "counter"
		tags: _component_tags
	}
	_timestamp_parse_errors_total: {
		description: "The total number of errors encountered RFC3339 parsing timestamps."
		type: "counter"
		tags: _default_tags
	}
	_uptime_seconds: {
		description: "The total number of seconds the Vector instance has been up."
		required:    true
		type:        "gauge"
		tags:        _default_tags
	}
}
