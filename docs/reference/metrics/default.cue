package metadata

// Reusable sets of components
_metrics: _default: {
	// Metrics common to all components
	_component_metrics: {
		events_processed_total: _metrics._internal._events_processed_total
		processed_bytes_total:  _metrics._internal._processed_bytes_total
		uptime_seconds:         _metrics._internal._uptime_seconds
	}
}
