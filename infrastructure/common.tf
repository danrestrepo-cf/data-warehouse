locals {
  aws-region   = "us-east-1"
  cluster-name = "${terraform.workspace}-data-warehouse"
  bi-prefix    = "${terraform.workspace}-bi-managed"

  // the VPC is "dev" for BI QA
  vpc-prefix = split("-", data.aws_vpc.this.tags["Name"])[0]

  task-to-container = {
    "mdi_2_container" = "${terraform.workspace}-mdi-2"
  }
  task-to-arn       = {
    // confirmed you don't need the full ARN in the same account
    // confirmed you don't need the revision, omitting it wil use the latest (need permissions to all, family* not family:*)
    "mdi_2_arn" = data.aws_ecs_task_definition.mdi-2.family
  }
}

data aws_caller_identity this {}

data aws_iam_role step-function {
  name = "${local.bi-prefix}-step-function"
}

data aws_iam_role event-trigger {
  name = "${local.bi-prefix}-invoke-step-function"
}

data aws_ecs_cluster this {
  cluster_name = local.cluster-name
}

data aws_security_group this {
  name = "${local.cluster-name}-task"
}

data aws_vpc this {
  id = data.aws_security_group.this.vpc_id
}

data aws_subnet_ids private {
  vpc_id = data.aws_security_group.this.vpc_id

  tags = {
    Name = "${local.vpc-prefix}-bi-private-${local.aws-region}*"
  }
}
// Known ECS tasks

data aws_ecs_task_definition mdi-2 {
  task_definition = "${terraform.workspace}-mdi-2"
}
