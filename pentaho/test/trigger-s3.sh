#!/usr/bin/env bash

test_dir=$(dirname "$0")
environment="qa"

# always copy, not sync, because it'll trigger the event
aws s3 cp ${test_dir}/SP6/inputs/Encompass.csv s3://${environment}-data-warehouse-ingress/encompass-SP6/pending/Encompass.csv
aws s3 cp ${test_dir}/SP8.1/test-case-23/inputs/test_case_source_file.csv s3://${environment}-data-warehouse-ingress/dmi-SP8-1/pending/dmi-V35-state.csv
aws s3 cp ${test_dir}/SP9.1/test-case-23/inputs/test_case_source_file.csv s3://${environment}-data-warehouse-ingress/dmi-SP9-1/pending/dmi-V35-national.csv
aws s3 cp ${test_dir}/SP10.1/test-case-23/inputs/test_case_source_file.csv s3://${environment}-data-warehouse-ingress/dmi-SP10-1/pending/dmi-V35-s540a.csv
