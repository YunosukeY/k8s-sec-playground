package lib.network_policy

import data.lib.wrapper
import future.keywords

allowed_name := {
	"deny-all-ingress",
	"allow-cluster-internal",
	"allow-ingress-nginx",
}

violation_disallow_addtional_network_policy contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "crd.projectcalico.org")
	resource.kind == "GlobalNetworkPolicy"
	not resource.metadata.name in allowed_name

	msg := wrapper.format("Additional GlobalNetworkPolicy is not allowed: %s", [resource.metadata.name])
}

violation_disallow_addtional_network_policy contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "crd.projectcalico.org")
	resource.kind == "NetworkPolicy"
	not resource.metadata.name in allowed_name

	msg := wrapper.format("Additional NetworkPolicy is not allowed: %s", [resource.metadata.name])
}
