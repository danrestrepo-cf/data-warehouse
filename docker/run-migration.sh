#!/usr/bin/env bash
# TODO: this must be executed via aws-vault

path_to_script=$(dirname "$0")
absolute_path="$(pwd)/${path_to_script}"

set -e

if [ $# -lt 1 ]; then
  echo "Usage: ./run-migration.sh [environment]"
  exit 1
fi

# clean up the dev setup before we run it against a "real" database
rm -f ${path_to_script}/database/migrations/*/beforeMigrate.sql

# TODO: shove these into a property file (sops) and read it out
environment=$1
RDS_ENDPOINT=""
if [ $environment == 'qa' ]; then
  echo "Using QA environment."
  RDS_ENDPOINT="qa-data-warehouse.cluster-cmpcw6cvsrlr.us-east-1.rds.amazonaws.com"
elif [ $environment == "uat" ]; then
  echo "UAT not supported yet."
  exit 1
elif [ $environment == "prod" ]; then
  echo "Using Production environment."
  RDS_ENDPOINT="prod-data-warehouse.cluster-cymvd4vzfjnm.us-east-1.rds.amazonaws.com"
else
  echo "Unknown $environment supplied."
  exit 1
fi
AWS_REGION=us-east-1

# Deploy user runs the structure changes
DEPLOY_USER="deployer"

for database in ingress staging config; do
  # generate a new token for each database in case one has timed out
  AUTH_TOKEN=$(aws rds generate-db-auth-token --hostname ${RDS_ENDPOINT} --port 5432 --region ${AWS_REGION} --username ${DEPLOY_USER} --output text)
  docker run -i \
    -v ${absolute_path}/database/migrations/${database}:/flyway/sql \
    --rm flyway/flyway:6 \
    -url=jdbc:postgresql://${RDS_ENDPOINT}:5432/${database}?requiressl=true \
    -schemas=flyway \
    -user=${DEPLOY_USER} \
    -password="${AUTH_TOKEN}" \
    -connectRetries=60 \
    migrate
done

# This runs as the admin user to prevent permission escalation in the main migrations
ADMIN_USER="admin"

for database in ingress staging config; do
  # generate a new token for each database in case one has timed out
  AUTH_TOKEN=$(aws rds generate-db-auth-token --hostname ${RDS_ENDPOINT} --port 5432 --region ${AWS_REGION} --username ${ADMIN_USER} --output text)
  docker run -i \
    -v ${absolute_path}/database/migrations/${database}-permissions:/flyway/sql \
    --rm flyway/flyway:6 \
    -url=jdbc:postgresql://${RDS_ENDPOINT}:5432/${database}?requiressl=true \
    -schemas=flyway-permissions \
    -user=${ADMIN_USER} \
    -password="${AUTH_TOKEN}" \
    -connectRetries=60 \
    migrate
done
