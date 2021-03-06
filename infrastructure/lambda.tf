locals {
  next-step-name = "next-step-trigger"
}

// this is maintained by analysis-infrastructure/data-warehouse/roles/next-step-trigger
data aws_iam_role next-step {
  name = "${local.bi-prefix}-${local.next-step-name}"
}

data archive_file next-step {
  type        = "zip"
  source_file = "${path.module}/scripts/${local.next-step-name}.py"
  output_path = "${local.next-step-name}.zip"
}

resource aws_lambda_function next-step {
  function_name = "${local.bi-prefix}-${local.next-step-name}"
  role          = data.aws_iam_role.next-step.arn
  handler       = "${local.next-step-name}.execute"
  runtime       = "python3.7"
  timeout       = local.next-step-max-process-time-seconds

  memory_size = 128

  filename         = data.archive_file.next-step.output_path
  source_code_hash = data.archive_file.next-step.output_base64sha256

  // NOT in a VPC, as its not accessing anything private nor should it

  environment {
    variables = {
      sfn_arn_prefix = "arn:aws:states:${local.aws-region}:${local.account-id[terraform.workspace]}:stateMachine:${local.bi-prefix}"
    }
  }

  // tags at the provider level
}

resource aws_lambda_event_source_mapping mdi-2-full-check-to-next-step {
  enabled = true

  function_name    = aws_lambda_function.next-step.arn
  event_source_arn = aws_sqs_queue.mdi-2-full-check.arn

  batch_size = 1
}
