#!/usr/bin/env bash

set -e

if [ $# -gt 0 ]; then
  rds_group=$1
fi

octane_prod=188213074036
data_warehouse_prod=766879632060

mkdir -p ~/.aws

create_profile() {
  profile=$1
  account=$2
  role_name=${3:-$profile}
  config=~/.aws/config
  if ! grep -q $profile $config; then
    echo "ADDING profile ${profile}"
    echo "" >>$config
    echo "[profile $profile]" >>$config
    echo "sso_start_url = https://cardinalfinancial.awsapps.com/start" >>$config
    echo "sso_region = us-east-1" >>$config
    echo "sso_account_id = ${account}" >>$config
    echo "sso_role_name = ${role_name}" >>$config
    echo "region = us-east-1" >>$config
    echo "output = json" >>$config
  else
    echo "PROFILE ${profile} EXISTS"
  fi
}

create_profile qa-data-warehouse-readonly 185672194546 data-warehouse-readonly
create_profile prod-data-warehouse-readonly ${data_warehouse_prod} data-warehouse-readonly
create_profile octane-database-readonly ${octane_prod}
if [ -n "${rds_group}" ]; then
  create_profile database-access ${octane_prod} database-access-"${rds_group}"
  create_profile database-access-data-warehouse ${data_warehouse_prod} database-access-"${rds_group}"
fi
