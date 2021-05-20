
module aws-utils {
  source      = "git::ssh://github.com/mofnong/terraform-modules.git//aws/utils/aws-properties?ref=v1.6.1"
  environment = terraform.workspace
  team-name   = "BI"
  module-name = "data-warehouse/infrastructure"
}

locals {
  tags = module.aws-utils.system-tags
}
