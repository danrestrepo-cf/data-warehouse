#!/usr/bin/env bash
# TODO: this must be executed via aws-vault

set -e

if [ $# -lt 1 ]; then
  echo "Usage: ./run-migration.sh [environment]"
  exit 1
fi

# temporary hack to clean up the volume before we run it against a "real" database
rm -f database/migrations/*/beforeMigrate.sql

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
DEPLOY_USER=deployer

AUTH_TOKEN=$(aws rds generate-db-auth-token --hostname ${RDS_ENDPOINT} --port 5432 --region ${AWS_REGION} --username ${DEPLOY_USER} --output text)

for database in ingress staging config; do
  docker run -it \
    -v $(pwd)/database/migrations/${database}:/flyway/sql \
    --rm flyway/flyway:6 \
    -url=jdbc:postgresql://${RDS_ENDPOINT}:5432/${database}?requiressl=true \
    -schemas=flyway \
    -user=${DEPLOY_USER} \
    -password="${AUTH_TOKEN}" \
    -connectRetries=60 \
    migrate
done
