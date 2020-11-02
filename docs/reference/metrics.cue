package metadata

_metrics: _tags: {
	component_kind: {
		description: "The component's kind (`source`, `sink`, or `transform`)."
		required:    true
		type: string: enum: {
			sink:      "Sink component."
			source:    "Source component."
			transform: "Transform component."
		}
	}
	component_name: {
		description: "The name of the component as specified in the Vector configuration."
		required:    true
		type: string: examples: ["file_source", "splunk_sink"]
	}
	component_type: {
		description: "The type of component (source, transform, or sink)."
		required:    true
		type: string: examples: ["file", "http", "honeycomb", "splunk_hec"]
	}
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
	instance: {
		description: "The Vector instance identified by host and port."
		required:    true
		examples: [_values.instance]
	}
	job: {
		description: "The name of the job producing Vector metrics."
		required: true
		type: string: default: "vector"
	}

	_apache_defaults: [
		_metrics._tags.endpoint,
		_metrics._tags.host
	]

	_internal_defaults: [
		_metrics._tags.instance,
		_metrics._tags.job
	]
}
