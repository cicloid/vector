package metadata

_metrics: _windows: {
	_default_tags: _metrics._tags._default._internal_metrics

	windows_service_does_not_exist: {
		description: """
			The total number of errors raised due to the Windows service not
			existing.
			"""
		type: "counter"
		tags: _default_tags
	}
	windows_service_install: {
		description: """
			The total number of times the Windows service has been installed.
			"""
		type: "counter"
		tags: _default_tags
	}
	windows_service_restart: {
		description: """
			The total number of times the Windows service has been restarted.
			"""
		type: "counter"
		tags: _default_tags
	}
	windows_service_start: {
		description: """
			The total number of times the Windows service has been started.
			"""
		type: "counter"
		tags: _default_tags
	}
	windows_service_stop: {
		description: """
			The total number of times the Windows service has been stopped.
			"""
		type: "counter"
		tags: _default_tags
	}
	windows_service_uninstall: {
		description: """
			The total number of times the Windows service has been uninstalled.
			"""
		type: "counter"
		tags: _default_tags
	}
}
