#!/usr/bin/env bash

# set the script to fail on any errors
set -e

# set the script to print all commands to the screen
# intentionally commented but can be toggled on if needed
# set -x

name_prefix="bi-managed"

echo "Fetching step functions to disable, containing: ${name_prefix}"
next_token="first"
# The next_token has "None None None" in it, which is odd, but we can regex check it
while [ "${next_token}" != "" ] && [[ ! $next_token =~ "None" ]]; do
  pagination="--no-paginate"
  if [ "${next_token}" != "" ] && [ "${next_token}" != "first" ]; then
    echo "Has next token: ${next_token}"
    pagination="--starting-token ${next_token}"
  fi

  # filter to only machines with bi-managed in their name: https://jmespath.org/tutorial.html
  state_machines=$(aws stepfunctions list-state-machines ${pagination} \
    --output text --query "stateMachines[?contains(name, '${name_prefix}')].{stateMachineArn:stateMachineArn}")
  next_token=$(aws stepfunctions list-state-machines ${pagination} \
    --output text --query 'nextToken')

  while read -r state_machine; do
    if [ "${state_machine}" != "" ]; then
      echo "Stopping executions on ${state_machine}"

      executions=$(aws stepfunctions list-executions --state-machine-arn ${state_machine} --status-filter RUNNING \
        --output text --query 'executions[].{executionArn:executionArn}')
      while read -r execution; do

        if [ "${execution}" != "" ]; then
          echo "Stopping ${state_machine} execution ${execution}"
          aws stepfunctions stop-execution --execution-arn ${execution}
        fi
      done <<<"${executions}"

      echo "Stopped ${state_machine} executions."
    fi
  done <<<"${state_machines}"
done

echo "All state machine executions have been stopped ."
