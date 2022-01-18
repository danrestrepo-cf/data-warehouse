"""Generate two step functions that will add a number of messages to the bi-managed-mdi-2-full-check.fifo SQS queue:
    1. SP-GROUP-1: adds a message for each ETL that operates on a history_octane table
    2. SP-GROUP-2 adds a message for each ETL that operates on a history_octane table AND has one or more dependent ETLs

1/18/2022 - CBoulé - Script created - https://app.asana.com/0/0/1200518782862171
"""

import sys
import os
import json
import fnmatch

PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))

# this line allows the script to import directly from lib when run from the command line
sys.path.append(PROJECT_DIR_PATH)

from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_filter import InclusiveMetadataFilterer
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml


def main():
    # load yaml metadata into DataWarehouseMetadata structure
    metadata_dir = os.path.join(PROJECT_DIR_PATH, '..', 'metadata', 'edw')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(metadata_dir)

    step_function_file_extension = 'json'
    infrastructure_dir_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'infrastructure')
    pipelines_dir_path = os.path.join(infrastructure_dir_path, 'pipelines')
    delete_existing_group_step_functions(pipelines_dir_path)

    # filter DataWarehouseMetadata object to history_octane schema objects
    filterer = InclusiveMetadataFilterer()
    filterer.add_schema_criteria(SchemaPath('staging', 'history_octane'))
    data_warehouse_metadata = filterer.filter(data_warehouse_metadata)

    # parse relevant metadata into a list of dicts
    history_octane_etl_metadata = []
    for database in data_warehouse_metadata.databases:
        for schema in database.schemas:
            for table in schema.tables:
                for etl in table.etls:
                    etl_metadata = {
                        "process_name": etl.process_name,
                        "target_table": table.name,
                        "next_processes": table.next_etls
                    }
                    history_octane_etl_metadata.append(etl_metadata)
    history_octane_etl_metadata = sorted(history_octane_etl_metadata, key=lambda x: x["process_name"])

    # generate step function dicts
    sp_group_1 = generate_parallel_state('SP-GROUP-1', 'Trigger every history_octane ETL - This should process all staging_octane data into history_octane and will trigger any downstream processes')
    sp_group_2 = generate_parallel_state('SP-GROUP-2', 'Trigger history_octane ETLs that have one or more dependent ETLs - This should process all staging_octane data that feeds any star_* tables')

    for etl_metadata in history_octane_etl_metadata:
        sp_group_1["States"]["SP-GROUP-1"]["Branches"].append(generate_message_state(etl_metadata["process_name"], etl_metadata["target_table"]))
        if len(etl_metadata["next_processes"]) > 0:
            sp_group_2["States"]["SP-GROUP-2"]["Branches"].append(generate_message_state(etl_metadata["process_name"], etl_metadata["target_table"]))

    write_to_file(json.dumps(sp_group_1, indent=4), os.path.join(pipelines_dir_path, f'SP-GROUP-1.{step_function_file_extension}'))
    write_to_file(json.dumps(sp_group_2, indent=4), os.path.join(pipelines_dir_path, f'SP-GROUP-2.{step_function_file_extension}'))


def generate_message_state(process_name: str, target_table: str) -> dict:
    message_state_dict = {
        "Comment": "Send message to bi-managed-mdi-2-full-check-queue for {}".format(process_name),
        "StartAt": "{}_message".format(process_name),
        "States": {
            "{}_message".format(process_name): {
                "Type": "Task",
                "Resource": "arn:aws:states:::sqs:sendMessage",
                "Parameters": {
                    "QueueUrl": "https://sqs.us-east-1.amazonaws.com/185672194546/qa-bi-managed-mdi-2-full-check.fifo",
                    "MessageGroupId": target_table,
                    "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                    "MessageAttributes": {
                        "ProcessId": {
                            "DataType": "String",
                            "StringValue": process_name
                        }
                    },
                    "MessageBody.$": "States.JsonToString($)"
                },
                "End": True
            }
        }
    }
    return message_state_dict


def generate_parallel_state(state_name: str, comment: str) -> dict:
    parallel_state_dict = {
        "Comment": comment,
        "StartAt": state_name,
        "States": {
            state_name: {
                "Type": "Parallel",
                "End": True,
                "Branches": []
            }
        }
    }
    return parallel_state_dict


def delete_existing_group_step_functions(directory: str):
    deleted_files_count = 0
    for file in os.listdir(directory):
        if fnmatch.fnmatch(file, "SP-GROUP-*"):
            filepath = os.path.join(directory, file)
            try:
                os.remove(filepath)
                deleted_files_count += 1
            except Exception as e:
                print(f"Could not remove file '{filepath}'! Now exiting.")
                raise e
    print(f'Deleted {deleted_files_count} history_octane group step function files from {directory}.')


def write_to_file(file_contents: str, file_path: str):
    try:
        f = open(file_path, "w")
        f.write(file_contents)
        f.close()
    except Exception as e:
        print(f"Could not open or save file {file_path}!")
        print(f"The file's contents would have been: {str(file_contents)}")
        raise e
    print(f"Saved '{file_path}'")


if __name__ == '__main__':
    main()
