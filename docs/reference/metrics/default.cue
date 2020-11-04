package metadata

// Reusable sets of components
_metrics: _default: {
	// Metrics common to all components
	_component_metrics: {
		events_processed_total: _metrics._internal._events_processed_total
		processed_bytes_total:  _metrics._internal._processed_bytes_total
		uptime_seconds:         _metrics._internal._uptime_seconds
	}

	// Metrics common to Prometheus components
	_prometheus_metrics: {
		events_processed_total:       _metrics._internal._events_processed_total
		http_error_response_total:    _metrics._internal._http_error_response_total
		http_request_errors_total:    _metrics._internal._http_request_errors_total
		parse_errors_total:           _metrics._internal._parse_errors_total
		processed_bytes_total:        _metrics._internal._processed_bytes_total
		request_duration_nanoseconds: _metrics._internal._request_duration_nanoseconds
		requests_completed_total:     _metrics._internal._requests_completed_total
	}
}
