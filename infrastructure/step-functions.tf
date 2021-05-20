resource aws_sfn_state_machine this {
  for_each = fileset("${path.module}/pipelines", "*.json")

  // ex: qa-bi-managed-sp-1000090
  name     = join(local.bi-prefix, split(each.key, ".")[0])
  role_arn = data.aws_iam_role.step-function.arn

  definition = templatefile(file(each.key), merge(local.task-to-arn, local.task-to-container, {
    ecsClusterARN   = data.aws_ecs_cluster.this.arn
    securityGroupId = data.aws_security_group.this.id
    subnetIDs       = "[${data.aws_subnet_id.az1.id}, ${data.aws_subnet_id.az2.id}]"
  }))

  tags = local.tags
}

module schedule-trigger {
  for_each = local.schedules

  source = "./modules/schedule-trigger"

  aws-region  = local.aws-region
  environment = terraform.workspace

  name               = "${local.bi-prefix}-${each.key}"
  state-machine-arn  = aws_sfn_state_machine.this[each.key].arn
  schedule           = each.value
  trigger-role-arn   = data.aws_iam_role.event-trigger.arn
  trigger-input-json = jsonencode({
    full_load_flag   = true
    key_field_name   = null
    key_field_values = null
  })
}
