locals {
  schedules = {
    // Note: EventBridge cron schedules are UTC+0, so an hour of "5" means 12:00 AM in EST, 1:00 AM in EDT
    // see https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule-schedule.html
    "SP-GROUP-2.json" = "cron(15 5 * * ? *)"
  }
}
