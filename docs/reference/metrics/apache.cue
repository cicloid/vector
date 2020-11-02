package metadata

_metrics: _apache: {
	_default_tags: _metrics._tags._default._apache_metrics

	apache_access_total: {
		description:   "The total number of time the Apache server has been accessed."
		relevant_when: "`ExtendedStatus On`"
		type:          "counter"
		tags:          _default_tags
	}
	apache_connections: {
		description: "The total number of time the Apache server has been accessed."
		type:        "gauge"
		tags:        _default_tags & {
			state: {
				description: "The state of the connection"
				required:    true
				examples: ["closing", "keepalive", "total", "writing"]
			}
		}
	}
	apache_cpu_load: {
		description:   "The current CPU of the Apache server."
		relevant_when: "`ExtendedStatus On`"
		type:          "gauge"
		tags:          _default_tags
	}
	apache_cpu_seconds_total: {
		description:   "The CPU time of various Apache processes."
		relevant_when: "`ExtendedStatus On`"
		type:          "counter"
		tags:          _default_tags & {
			state: {
				description: "The state of the connection"
				required:    true
				examples: ["children_system", "children_user", "system", "user"]
			}
		}
	}
	apache_duration_seconds_total: {
		description:   "The amount of time the Apache server has been running."
		relevant_when: "`ExtendedStatus On`"
		type:          "counter"
		tags:          _default_tags
	}
	apache_scoreboard: {
		description: "The amount of times various Apache server tasks have been run."
		type:        "gauge"
		tags:        _default_tags & {
			state: {
				description: "The connect state"
				required:    true
				examples: ["closing", "dnslookup", "finishing", "idle_cleanup", "keepalive", "logging", "open", "reading", "sending", "starting", "waiting"]
			}
		}
	}
	apache_sent_bytes_total: {
		description:   "The amount of bytes sent by the Apache server."
		relevant_when: "`ExtendedStatus On`"
		type:          "counter"
		tags:          _default_tags
	}
	apache_uptime_seconds_total: {
		description: "The amount of time the Apache server has been running."
		type:        "counter"
		tags:        _default_tags
	}
	apache_workers: {
		description: "Apache worker statuses."
		type:        "gauge"
		tags:        _default_tags & {
			state: {
				description: "The state of the worker"
				required:    true
				examples: ["busy", "idle"]
			}
		}
	}
	apache_up: {
		description: "If the Apache server is up or not."
		type:        "gauge"
		tags:        _default_tags
	}
}
