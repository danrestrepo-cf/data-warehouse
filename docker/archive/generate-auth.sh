#!/usr/bin/env bash

#
# NOTE: This is being kept for future usage.  It is expecting JSON input and produces JSON output
# originally used in terraform where JSON was easier, but possibly useful for CI/CD later
#

# Exit if any of the intermediate steps fail
set -e

# Extract "rds endpoint", "aws region" and "deploy user" a arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "RDSENDPOINT=\(.endpoint) AWSREGION=\(.region) DEPLOYUSER=\(.user) ACCOUNT_ID=\(.account)"')"

FAKE_ACESS=${AWS_ACCESS_KEY_ID}

# we must assume the bi-admin role inside the script, as its being fired in a local provider
assume=$(aws sts assume-role --role-arn "arn:aws:iam::${ACCOUNT_ID}:role/bi-admin" --role-session-name flyway-session --duration-seconds 900)

export AWS_ACCESS_KEY_ID=$(echo $assume | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $assume | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $assume | jq -r '.Credentials.SessionToken')
export AWS_SECURITY_TOKEN=$(echo $assume | jq -r '.Credentials.SessionToken')

# Generate the password
result=$(aws rds generate-db-auth-token --hostname ${RDSENDPOINT} --port 5432 --region ${AWSREGION} --username ${DEPLOYUSER} --output text)

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg result "$result" \
  --arg accessKey "${AWS_ACCESS_KEY_ID}" \
  --arg acct "${ACCOUNT_ID}" \
  --arg RDS "${RDSENDPOINT}" \
  --arg region "${AWSREGION}" \
  --arg user "${DEPLOYUSER}" \
  --arg orig "${FAKE_ACESS}" \
  '{"password":$result, "access":$accessKey, "acct": $acct, "RDS": $RDS, "region": $region, "user": $user, "orig": $orig}'
