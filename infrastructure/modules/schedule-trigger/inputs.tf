variable aws-region {
  type        = string
  description = "AWS Region to create resources in."
}

variable environment {
  type        = string
  description = "Environment for the resources being managed."
}

#
# Module Inputs
#

variable name {
  type        = string
  description = "Name of these resources"
}

variable state-machine-arn {
  type        = string
  description = "The state machine to trigger."
}

variable schedule {
  type        = string
  description = "The schedule to trigger the state machine on."
}

variable enabled {
  type        = bool
  description = "If true, the trigger will be enabled (firing) when modifications are complete.  If its a rate then it will fire automatically when enabled."
}

variable trigger-input-json {
  type        = string
  description = "The input passed to the target state machine."
}

variable trigger-role-arn {
  type        = string
  description = "Allowed resources for CloudWatch to trigger."
}

#
# Input Calculations
#

module aws-utils {
  source      = "git::ssh://github.com/mofnong/terraform-modules.git//aws/utils/aws-properties?ref=v1.6.1"
  environment = var.environment
  team-name   = "BI"
  module-name = "data-warehouse/infrastructure/modules/schedule-trigger"
}

locals {
  tags = module.aws-utils.system-tags
}
