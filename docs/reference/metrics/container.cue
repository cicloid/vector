package metadata

_metrics: _container: {
	_communication_errors_total: {
		description: "The total number of errors stemming from communication with the Docker daemon."
		type: "counter"
	}

	_container_events_processed_total: {
		description: "The total number of container events processed."
		type: "counter"
	}

	_container_metadata_fetch_errors_total: {
		description: "The total number of errors caused by failure to fetch container metadata."
		type: "counter"
	}

	_containers_unwatched_total: {
		description: "The total number of times Vector stopped watching for container logs."
		counter: "counter"
	}

	_containers_watched_total: {
		description: "The total number of times Vector started watching for container logs."
		counter: "counter"
	}

	_logging_driver_errors_total: {
		description: "The total number of logging driver errors encountered caused by not using either the `jsonfile` or `journald` driver."
		type: "counter"
	}
}
