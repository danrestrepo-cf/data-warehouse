"""Generate two step functions that will add a number of messages to the bi-managed-mdi-2-full-check.fifo SQS queue:
    1. SP-GROUP-1: adds a message for each ETL that operates on a history_octane table
    2. SP-GROUP-2 adds a message for each ETL that operates on a history_octane table AND has one or more dependent ETLs

1/18/2022 - CBoulé - Script created - https://app.asana.com/0/0/1200518782862171
"""

import sys
import os
import json
import fnmatch
import math

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

    # initialize variable for write-to directory
    infrastructure_dir_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'infrastructure')
    pipelines_dir_path = os.path.join(infrastructure_dir_path, 'pipelines')

    # filter DataWarehouseMetadata object to history_octane schema objects
    filterer = InclusiveMetadataFilterer()
    filterer.add_schema_criteria(SchemaPath('staging', 'history_octane'))
    data_warehouse_metadata = filterer.filter(data_warehouse_metadata)

    # parse relevant metadata into a list of dicts
    etl_dict_list = []
    for database in data_warehouse_metadata.databases:
        for schema in database.schemas:
            for table in schema.tables:
                for etl in table.etls:
                    etl_dict = {
                        "process_name": etl.process_name,
                        "target_table": table.name,
                        "next_processes": table.next_etls
                    }
                    etl_dict_list.append(etl_dict)
    history_octane_etl_dict_list = sorted(etl_dict_list, key=lambda x: x["process_name"])
    sp_group_2_etl_dict_list = [etl for etl in history_octane_etl_dict_list if len(etl["next_processes"]) > 0]

    # delete existing group step functions and re-generate
    delete_existing_group_step_functions(pipelines_dir_path)
    generate_grouped_step_functions('SP-GROUP-1', 'Trigger every history_octane ETL - This should process all '
                                    'staging_octane data into history_octane and will trigger any downstream processes',
                                    history_octane_etl_dict_list, 500, pipelines_dir_path)
    generate_grouped_step_functions('SP-GROUP-2', 'Trigger history_octane ETLs that have one or more dependent ETLs - '
                                    'This should process all staging_octane data that feeds any star_* tables',
                                    sp_group_2_etl_dict_list, 500, pipelines_dir_path)


def generate_grouped_step_functions(step_function_base_name: str, step_function_comment: str, etl_dict_list: list[dict],
                                    step_function_state_limit: int, output_dir: str):
    unprocessed_etl_dict_list_length = len(etl_dict_list)
    for i in range(0, math.ceil(unprocessed_etl_dict_list_length / step_function_state_limit)):
        if unprocessed_etl_dict_list_length > step_function_state_limit:
            step_function_subgroup_suffix = i+1
            step_function_name = f"{step_function_base_name}-{step_function_subgroup_suffix}"
            parallel_state = generate_parallel_state(step_function_name, f"{step_function_comment} - group {step_function_subgroup_suffix}")
        else:
            step_function_name = f"{step_function_base_name}"
            parallel_state = generate_parallel_state(step_function_name, f"{step_function_comment}")
        parallel_branches = parallel_state["States"][step_function_name]["Branches"]
        for j in range(0, len(etl_dict_list)):
            while len(parallel_branches) <= step_function_state_limit and len(etl_dict_list) > 0:
                etl_dict = etl_dict_list.pop(j)
                parallel_branches.append(generate_message_state(etl_dict["process_name"], etl_dict["target_table"]))
        write_to_file(json.dumps(parallel_state, indent=4), os.path.join(output_dir, f'{step_function_name}.json'))


def generate_message_state(process_name: str, target_table: str) -> dict:
    message_state_dict = {
        "Comment": "Send message to bi-managed-mdi-2-full-check-queue for {}".format(process_name),
        "StartAt": "{}_message".format(process_name),
        "States": {
            "{}_message".format(process_name): {
                "Type": "Task",
                "Resource": "arn:aws:states:::sqs:sendMessage",
                "Parameters": {
                    "QueueUrl": '${fullCheckQueueUrl}',
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
