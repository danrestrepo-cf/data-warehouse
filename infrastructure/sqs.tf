locals {
  next-step-max-process-time-seconds = 5 * 60
}

resource aws_sqs_queue full-check {
  name                  = "${local.bi-prefix}-full-check.fifo"
  fifo_queue            = true
  deduplication_scope   = "messageGroup"
  fifo_throughput_limit = "perMessageGroupId"

  // TODO: we don't need this if its just IDs
  //  kms_master_key_id                 = "alias/aws/sqs"
  //  kms_data_key_reuse_period_seconds = 300

  max_message_size = 256 * 1024 // max 256 KiB

  delay_seconds              = 0
  visibility_timeout_seconds = local.next-step-max-process-time-seconds
  message_retention_seconds  = 4 * 24 * 60 * 60 // 4 days
  receive_wait_time_seconds  = 10

  //  redrive_policy            = jsonencode({
  //    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
  //    maxReceiveCount     = 4
  //  })

  // TODO: policy = json({})

  // tags are handled in the provider
}
