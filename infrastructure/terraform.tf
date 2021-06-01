locals {
  account-id = {
    qa   = "185672194546"
    prod = "766879632060"
  }
}
terraform {
  backend "s3" {
    bucket  = "dev-cardinal-bi-managed-infrastructure-s3"
    key     = "data-warehouse/pipelines/terraform.tf"
    region  = "us-east-1"
    // we are not using locking, as jenkins will control that
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }
}

// pull permissions from the environment
provider aws {
  region = local.aws-region

  assume_role {
    role_arn = "arn:aws:iam::${local.account-id[terraform.workspace]}:role/${local.bi-prefix}-infrastructure-deploy"
  }

  default_tags {
    tags = local.tags
  }
}
