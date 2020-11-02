package metadata

_metrics: _tags: {
	endpoint: {
		description: "The absolute path of originating file."
		required:    true
		examples: ["http://localhost:8080/server-status?auto"]
	}
	host: {
		description: "The hostname of the Apache HTTP server"
		required:    true
		examples: [_values.local_host]
	}

	_apache_defaults: [
		_metrics._tags.endpoint,
		_metrics._tags.host
	]
}
