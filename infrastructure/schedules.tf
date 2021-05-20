locals {
  default-schedule = "rate(15 minutes)"
  schedules        = {
    "sp-100090.json" = local.default-schedule
  }
}
