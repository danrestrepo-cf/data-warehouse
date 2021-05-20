#!/usr/bin/env bash

# set the script to fail on any errors
set -e

# set the script to print all commands to the screen
set -x

if [ $# -ne 1 ]; then
  echo "Usage: ./events-disable-triggers.sh [environment]"
  exit 1
fi

environment=$1

name_prefix="${environment}-bi-managed"

echo "Fetching event rules to disable, starting with: ${name_prefix}"
rule_names=$(aws events list-rules --no-paginate --name-prefix "${name_prefix}" \
  --output text --query 'Rules[].{Name:Name}')
while read -r rule_name; do
  if [ "${rule_name}" != "" ]; then
    echo "Disabling rule ${rule_name}"
    aws events disable-rule --name "${rule_name}"
    echo "Rule ${rule_name} has been disabled."
  fi
done <<<"${rule_names}"

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/events/disable-rule.html
# "Allow a short period of time for changes to take effect."
echo "All rules have been disabled, waiting 30 seconds per AWS advice."
sleep 30
