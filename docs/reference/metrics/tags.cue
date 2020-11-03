package metadata

_metrics: _tags: {
	_collector: {
		description: "Which collector this metric comes from."
		required:    true
		type:        string
	}
	_component_kind: {
		description: "The component's kind (options are `source`, `sink`, or `transform`)."
		required:    true
		type: string: enum: {
			sink:      "Sink component."
			source:    "Source component."
			transform: "Transform component."
		}
	}
	_component_name: {
		description: "The name of the component as specified in the Vector configuration."
		required:    true
		type: string: examples: ["file_source", "splunk_sink"]
	}
	_component_type: {
		description: "The type of component (source, transform, or sink)."
		required:    true
		type: string: examples: ["file", "http", "honeycomb", "splunk_hec"]
	}
	_endpoint: {
		description: "The absolute path of originating file."
		required:    true
		type:        string
		examples: ["http://localhost:8080/server-status?auto"]
	}
	_host: {
		description: "The hostname of the originating system."
		required:    true
		type:        string
		examples: [_values.local_host]
	}
	_instance: {
		description: "The Vector instance identified by host and port."
		required:    true
		type:        string
		examples: [_values.instance]
	}
	_job: {
		description: "The name of the job producing Vector metrics."
		required:    true
		type: string: default: "vector"
	}

	_default: {
		// Default tags for the apache_metrics source
		_apache_metrics: _metrics._tags._endpoint & {
			host: {
				description: "The hostname of the Apache HTTP server."
				required:    true
				examples: [_values.local_host]
			}
		}
		// Default tags for Vector component metrics
		_component: {
			component_kind: _component_kind
			component_name: _component_name
			component_type: _component_type
			instance:       _instance
			job:            _job
		}
		// Default tags for the host_metrics source
		_host_metrics: {
			collector: _collector
			host:      _host
		}
		// Default tags for the internal_metrics source
		_internal_metrics: {
			instance: _instance
			job:      _job
		}
		// Default tags for the mongodb_metrics source
		_mongodb_metrics: {
			_endpoint: {
				description: "The absolute path of originating file."
				required:    true
				type:        string
				examples: ["mongodb://localhost:27017"]
			}
			_host: {
				description: "The hostname of the MongoDB server."
				required:    true
				type:        string
				examples: [_values.local_host]
			}
		}
	}
}
