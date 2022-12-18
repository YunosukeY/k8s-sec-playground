package main

import data.lib.gatekeeper_config
import data.lib.network_policy
import future.keywords

violation contains msg if {
	some msg in gatekeeper_config.violation_disallow_addtional_gatekeeper_config
}

violation contains msg if {
	some msg in network_policy.violation_disallow_addtional_network_policy
}
