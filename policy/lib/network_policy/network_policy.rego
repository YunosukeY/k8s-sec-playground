package lib.network_policy

import data.lib.wrapper
import future.keywords

violation_disallow_addtional_network_policy contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "crd.projectcalico.org")
	resource.kind == "GlobalNetworkPolicy"
	resource.metadata.name != "deny-all-ingress"
	resource.metadata.name != "allow-cluster-internal"
	resource.metadata.name != "allow-ingress-nginx"

	msg := wrapper.format("Additional network policy is not allowed: %s", [resource.metadata.name])
}

violation_disallow_addtional_network_policy contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "crd.projectcalico.org")
	resource.kind == "NetworkPolicy"

	msg := wrapper.format("Additional network policy is not allowed: %s", [resource.metadata.name])
}
