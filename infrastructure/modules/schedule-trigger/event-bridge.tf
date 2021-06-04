// NOTE: CloudWatch Events is being migrated to Event Bridge
// https://github.com/terraform-providers/terraform-provider-aws/issues/9330

resource aws_cloudwatch_event_rule this {
  name       = var.name
  is_enabled = true

  schedule_expression = var.schedule

  tags = local.tags
}

resource aws_cloudwatch_event_target this {
  target_id = var.name
  rule      = aws_cloudwatch_event_rule.this.name

  arn      = var.state-machine-arn
  role_arn = var.trigger-role-arn

  input_transformer {
    // this must be a json string, as the values are literals
    input_template = var.trigger-input-json
  }
}
