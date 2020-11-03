package metadata

_metrics: _kubernetes: {
	_k8s_docker_format_parse_failures_total: {
		description: "The total number of failures to parse a message as a JSON object."
		type:        "counter"
	}

	_k8s_event_annotation_failures_total: {
		description: "The total number of failures to annotate Vector events with Kubernetes Pod metadata."
		type:        "counter"
	}
}
