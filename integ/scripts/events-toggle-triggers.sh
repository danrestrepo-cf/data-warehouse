#!/usr/bin/env bash

# set the script to fail on any errors
set -e

# set the script to print all commands to the screen
set -x

if [ $# -ne 2 ]; then
  echo "Usage: ./events-toggle-triggers.sh [environment] [action]"
  echo "    action: one of 'enable' or 'disable' to enable/disable triggers"
  exit 1
fi

environment=$1
action=$2

if [ "${action}" != "enable" ] && [ "${action}" != "disable" ]; then
  echo "${action} is not supported, only 'enable' and 'disable' are supported."
  exit 1
fi

name_prefix="${environment}-bi-managed"

next_token="first"
# The next_token has "None None None" in it, which is odd, but we can regex check it
while [ "${next_token}" != "" ] && [[ ! $next_token =~ "None" ]]; do
  pagination=""
  if [ "${next_token}" != "" ] && [ "${next_token}" != "first" ]; then
    echo "Has next token: ${next_token}"
    pagination="--starting-token ${next_token}"
  fi

  echo "Fetching event rules to ${action}, starting with: ${name_prefix}"
  rule_names=$(aws events list-rules ${pagination} --name-prefix "${name_prefix}" \
    --output text --query 'Rules[].{Name:Name}')
  next_token=$(aws events list-rules ${pagination} --name-prefix "${name_prefix}" \
    --output text --query 'nextToken')
  while read -r rule_name; do
    if [ "${rule_name}" != "" ]; then
      if [ "${action}" == "enable" ]; then
        echo "Enabling rule ${rule_name}"
        aws events enable-rule --name "${rule_name}"
      elif [ "${action}" == "disable" ]; then
        echo "Disabling rule ${rule_name}"
        aws events disable-rule --name "${rule_name}"
      fi
      echo "Rule ${rule_name} has been ${action}d."
    fi
  done <<<"${rule_names}"
done

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/events/disable-rule.html
# "Allow a short period of time for changes to take effect."
echo "All rules have been disabled, waiting 30 seconds per AWS advice."
sleep 30
