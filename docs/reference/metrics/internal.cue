package metadata

_metrics: _internal: {
	_component_tags: _metrics._tags._default._component
	_default_tags: _metrics._tags._default._internal_metrics

	api_started_total: {
		description: "The number of times the Vector GraphQL API has been started."
		required: false
		type: "counter"
		tags: _default_tags
	}
	auto_concurrency_in_flight: {
		description: "The number of outbound requests from the HTTP sink currently awaiting a response."
		type: "histogram"
		tags: _default_tags
	}
	auto_concurrency_limit: {
		description: ""
		type: "histogram"
		tags: _default_tags
	}
	auto_concurrency_averaged_rtt: {
		type: "histogram"
		tags: _default_tags
	}
	auto_concurrency_observed_rtt: {
		type: "histogram"
		tags: _
	}
	collect_duration_nanoseconds: {
		type: "histogram"
	}
	events_processed_total: {
		description: "The total number of events processed by this component."
		required:    true
		type:        "counter"
		tags:        _default_tags & _component_tags
	}
	http_error_response_total: {
		type: "counter"
	}
	http_request_errors_total: {
		type: "counter"
	}
	memory_used: {
		type: "gauge"
	}
	open_connections: {
		description: "The number of current open connections to Vector."
		type: "gauge"
	}
	parse_errors_total: {
		type: "counter"
	}
	processed_bytes_total: {
		description: "The total number of bytes processed by the component."
		required:    true
		type:        "counter"
		tags:        _default_tags & _component_tags
	}
	processing_errors_total: {
		type: "counter"
		tags: _default_tags & {
			error_type: {
				description: "The type of the error"
				required: true
				type: string: enum: {
					convert_failed: ""
					failed_mapping: ""
					failed_match: ""
					failed_parse: ""
					failed_serialize: ""
					field_missing: "The field is missing from the event."
					field_not_found: ""
					invalid_metric: ""
					parse_error: ""
					render_error: ""
					target_field_exists: ""
					template_error: ""
					type_conversion_failed: "Failed to convert from one type to another."
					value_invalid: "The value produced is invalid."
				}
			}
		}
	}
	request_duration_nanoseconds: {
		type: "histogram"
		tags: _component_tags
	}
	requests_completed_total: {
		type: "counter"
		tags: _component_tags
	}
	uptime_seconds: {
		description: "The total number of seconds the Vector instance has been up."
		required:    true
		type:        "gauge"
		tags:        _default_tags
	}
}
