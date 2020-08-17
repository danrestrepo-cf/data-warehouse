#!/bin/bash

./aws-ecr-login.sh

if [ $# -lt 2 ]; then
  echo "Usage: ./push-image.sh [environment] [app]"
  exit 1
fi

environment=$1
app=$2
if [ "$environment" == "qa" ]; then
  account=185672194546
elif [ "$environment" == "uat" ]; then
  account=0
elif [ "$environment" == "prod" ]; then
  account=766879632060
else
  echo "Invalid environment, require one of [qa, uat, prod].  Got: $environment"
  exit 1
fi

local_name=edw/${app}
remote_name=edw/${environment}-${app}

#tag it
docker tag ${local_name}:latest ${account}.dkr.ecr.us-east-1.amazonaws.com/${remote_name}:latest
#push it
docker push ${account}.dkr.ecr.us-east-1.amazonaws.com/${remote_name}:latest
