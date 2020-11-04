package metadata

// Metrics for the Vector instance itself (as opposed to per-component metrics)
_metrics: _vector: {
	// Export
	_all: {
		config_load_errors_total:    _config_load_errors_total
		vector_recover_errors_total: _vector_recover_errors_total
		vector_reload_errors_total:  _vector_reload_errors_total
		vector_reloaded_total:       _vector_reloaded_total
		vector_started_total:        _vector_started_total
		vector_stopped_total:        _vector_stopped_total
	}

	_default_tags: _metrics._tags._default._internal_metrics

	_config_load_errors_total: {
		description: "The total number of errors loading the Vector configuration."
		type:        "counter"
		tags:        _default_tags
	}
	_vector_quit_total: {
		description: "The total number of times the Vector instance has quit."
		type:        "counter"
		tags:        _default_tags
	}
	_vector_recover_errors_total: {
		description: "The total number of errors caused by Vector failing to recover from a failed reload."
		type:        "counter"
		tags:        _default_tags
	}
	_vector_reload_errors_total: {
		description: "The total number of errors encountered when reloading Vector."
		type:        "counter"
		tags:        _default_tags
	}
	_vector_reloaded_total: {
		description: "The total number of times the Vector instance has been reloaded."
		type:        "counter"
		tags:        _default_tags
	}
	_vector_started_total: {
		description: "The total number of times the Vector instance has been started."
		type:        "counter"
		tags:        _default_tags
	}
	_vector_stopped_total: {
		description: "The total number of times the Vector instance has been stopped."
		type:        "counter"
		tags:        _default_tags
	}
}
