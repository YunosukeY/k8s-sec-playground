package lib.gatekeeper_config

import data.lib.wrapper
import future.keywords

violation_disallow_addtional_gatekeeper_config contains msg if {
	resource := wrapper.resource(input)

	startswith(resource.apiVersion, "config.gatekeeper.sh")
	resource.kind == "Config"
	resource.metadata.name != "config"

	msg := wrapper.format("Additional gatekeeper config is not allowed: %s", [resource.metadata.name])
}
