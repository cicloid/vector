package metadata

// Configuration related to a running Vector instance
vector: {
	output: metrics: _metrics._vector._all & {
		events_processed_total: _metrics._internal._events_processed_total
		processed_bytes_total:  _metrics._internal._processed_bytes_total
		protobuf_decode_errors_total: {
			description: "The total number of errors decoding Protocol Buffers messages."
			type:        "counter"
			tags:        _metrics._tags._default._host_metrics
		}
		uptime_seconds: _metrics._internal._uptime_seconds
	}
}
