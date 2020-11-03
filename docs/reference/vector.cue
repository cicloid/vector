package metadata

// Configuration related to a running Vector instance
vector: {
	output: metrics: {
		uptime_seconds: _metrics._internal._uptime_seconds // Vector's "heartbeat"
	}
}
