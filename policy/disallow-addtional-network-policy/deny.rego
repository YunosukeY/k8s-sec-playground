package main

import data.lib.wrapper
import future.keywords

violation contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "crd.projectcalico.org")
	resource.kind == "GlobalNetworkPolicy"
	resource.metadata.name != "deny-all-ingress"
	resource.metadata.name != "allow-cluster-internal"
	resource.metadata.name != "allow-ingress-nginx"

	msg := wrapper.format("Additional network policy is not allowed: %s", [resource.metadata.name])
}

violation contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "crd.projectcalico.org")
	resource.kind == "NetworkPolicy"

	msg := wrapper.format("Additional network policy is not allowed: %s", [resource.metadata.name])
}
