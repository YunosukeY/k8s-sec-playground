package main

import data.lib.wrapper
import future.keywords

violation contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "config.gatekeeper.sh")
	resource.kind == "Config"
	resource.metadata.name != "config"

	msg := wrapper.format("Additional gatekeeper config is not allowed: %s", [resource.metadata.name])
}
