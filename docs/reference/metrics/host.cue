package metadata

_metrics: _host: {
	// CPU
	host_cpu_seconds_total: {
		description: "The number of CPU seconds accumulated in different operating modes."
		type:        "counter"
		tags:        _metrics._tags._default._host_metrics & {
			collector: examples: ["cpu"]
			cpu: {
				description: "The index of the CPU core or socket."
				required:    true
				examples: ["1"]
			}
			mode: {
				description: "Which mode the CPU was running in during the given time."
				required:    true
				examples: ["idle", "system", "user", "nice"]
			}
		}
	}

	// Disk
	host_disk_read_bytes_total:       _disk_counter & {description: "The accumulated number of bytes read in."}
	host_disk_reads_completed_total:  _disk_counter & {description: "The accumulated number of read operations completed."}
	host_disk_written_bytes_total:    _disk_counter & {description: "The accumulated number of bytes written out."}
	host_disk_writes_completed_total: _disk_counter & {description: "The accumulated number of write operations completed."}

	// Filesystem
	host_filesystem_free_bytes:  _filesystem_bytes & {description: "The number of bytes free on the named filesystem."}
	host_filesystem_total_bytes: _filesystem_bytes & {description: "The total number of bytes in the named filesystem."}
	host_filesystem_used_bytes:  _filesystem_bytes & {description: "The number of bytes used on the named filesystem."}

	// Load
	host_load1:  _loadavg & {description: "System load averaged over the last 1 second."}
	host_load5:  _loadavg & {description: "System load averaged over the last 5 seconds."}
	host_load15: _loadavg & {description: "System load averaged over the last 15 seconds."}

	// Memory
	host_memory_free_bytes:             _memory_gauge & {description:                 "The number of bytes of main memory not used."}
	host_memory_available_bytes:        _memory_gauge & {description:                 "The number of bytes of main memory available."}
	host_memory_swap_free_bytes:        _memory_gauge & {description:                 "The number of free bytes of swap space."}
	host_memory_swap_total_bytes:       _memory_gauge & {description:                 "The total number of bytes of swap space."}
	host_memory_swap_used_bytes:        _memory_gauge & {description:                 "The number of used bytes of swap space."}
	host_memory_total_bytes:            _memory_gauge & {description:                 "The total number of bytes of main memory."}
	host_memory_active_bytes:           _memory_gauge & _memory_nowin & {description: "The number of bytes of active main memory."}
	host_memory_buffers_bytes:          _memory_linux & {description:                 "The number of bytes of main memory used by buffers."}
	host_memory_cached_bytes:           _memory_linux & {description:                 "The number of bytes of main memory used by cached blocks."}
	host_memory_shared_bytes:           _memory_linux & {description:                 "The number of bytes of main memory shared between processes."}
	host_memory_used_bytes:             _memory_linux & {description:                 "The number of bytes of main memory used by programs or caches."}
	host_memory_inactive_bytes:         _memory_macos & {description:                 "The number of bytes of main memory that is not active."}
	host_memory_swapped_in_bytes_total: _memory_counter & _memory_nowin & {
		description: "The number of bytes that have been swapped in to main memory."
	}
	host_memory_swapped_out_bytes_total: _memory_counter & _memory_nowin & {
		description: "The number of bytes that have been swapped out from main memory."
	}
	host_memory_wired_bytes: _memory_macos & {description: "The number of wired bytes of main memory."}

	// Network
	host_network_receive_bytes_total:         _network_gauge & {description: "The number of bytes received on this interface."}
	host_network_receive_errs_total:          _network_gauge & {description: "The number of errors encountered during receives on this interface."}
	host_network_receive_packets_total:       _network_gauge & {description: "The number of packets received on this interface."}
	host_network_transmit_bytes_total:        _network_gauge & {description: "The number of bytes transmitted on this interface."}
	host_network_transmit_errs_total:         _network_gauge & {description: "The number of errors encountered during transmits on this interface."}
	host_network_transmit_packets_drop_total: _network_nomac & {description: "The number of packets dropped during transmits on this interface."}
	host_network_transmit_packets_total:      _network_nomac & {description: "The number of packets transmitted on this interface."}

	// Helpers
	_disk_device: {
		description: "The disk device name."
		required:    true
		examples: ["sda", "sda1", "dm-1"]
	}
	_disk_counter: {
		type: "counter"
		tags: _metrics._tags._default._host_metrics & {
			collector: examples: ["disk"]
			device: _disk_device
		}
	}
	_filesystem_bytes: {
		type: "gauge"
		tags: _metrics._tags._default._host_metrics & {
			collector: examples: ["filesystem"]
			device: _disk_device
			filesystem: {
				description: "The name of the filesystem type."
				required:    true
				examples: ["ext4", "ntfs"]
			}
		}
	}
	_loadavg: {
		type: "gauge"
		tags: _metrics._tags._default._host_metrics & {
			collector: examples: ["loadavg"]
		}
		relevant_when: "OS is not Windows"
	}
	_memory_counter: {
		type: "counter"
		tags: _metrics._tags._default._host_metrics & {
			collector: examples: ["memory"]
		}
	}
	_memory_gauge: {
		type: "gauge"
		tags: _metrics._tags._default._host_metrics & {
			collector: examples: ["memory"]
		}
	}
	_memory_linux: _memory_gauge & {relevant_when: "OS is Linux"}
	_memory_macos: _memory_gauge & {relevant_when: "OS is MacOS X"}
	_memory_nowin: {relevant_when: "OS is not Windows"}
	_network_gauge: {
		type: "gauge"
		tags: _metrics._tags._default._host_metrics & {
			collector: examples: ["network"]
			device: {
				description: "The network interface device name."
				required:    true
				examples: ["eth0", "enp5s3"]
			}
		}
	}
	_network_nomac: _network_gauge & {relevant_when: "OS is not MacOS"}
}
