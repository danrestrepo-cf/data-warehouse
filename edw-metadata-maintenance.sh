#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "ERROR: No argument provided for config metadata maintenance file output path."
  exit 1
fi

# Generate YAML files for staging_octane and history_octane
python3 python-utilities/scripts/generate_edw_metadata_files_from_octane_information_schema.py
# Generate SQL maintenance file for mdi.config schema (DML statements only)
python3 python-utilities/scripts/generate_sql_to_update_edw_metadata.py --output_file="$1"
