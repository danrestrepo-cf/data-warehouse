import sys
import os
import json

import constants

# this line allows the script to import directly from lib when run from the command line
sys.path.append(constants.PROJECT_DIR_PATH)

from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_filter import InclusiveMetadataFilterer
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml


def main():
    # load yaml metadata into DataWarehouseMetadata structure
    metadata_dir = os.path.join(constants.PROJECT_DIR_PATH, '..', 'metadata', 'edw')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(metadata_dir)

    step_function_file_extension = 'json'
    infrastructure_dir_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'infrastructure')
    pipelines_dir_path = os.path.join(infrastructure_dir_path, 'pipelines')
    delete_prior_history_octane_etl_trigger_step_functions(pipelines_dir_path)

    # filter DataWarehouseMetadata object to history_octane schema objects
    filterer = InclusiveMetadataFilterer()
    filterer.add_schema_criteria(SchemaPath('staging', 'history_octane'))
    data_warehouse_metadata = filterer.filter(data_warehouse_metadata)

    # parse relevant metadata into a list of dicts
    history_octane_etl_metadata = []
    for database in data_warehouse_metadata.databases:
        for schema in database.schemas:
            for table in schema.tables:
                etl_metadata = {
                    "process_name": None,
                    "target_table": table.name,
                    "next_processes": table.next_etls
                }
                for etl in table.etls:
                    etl_metadata["process_name"] = etl.process_name
                    history_octane_etl_metadata.append(etl_metadata)

    # generate step function dicts
    sp_group_1 = generate_parallel_state('SP-GROUP-1', 'Trigger every history_octane ETL - This should process all staging_octane data into history_octane and will trigger any downstream processes')
    sp_group_2 = generate_parallel_state('SP-GROUP-2', 'Trigger history_octane ETLs that have one or more dependent ETLs - This should process all staging_octane data that feeds any star_* tables')

    sp_group_1_branches = sp_group_1["States"]["SP-GROUP-1"]["Branches"]
    sp_group_2_branches = sp_group_2["States"]["SP-GROUP-2"]["Branches"]

    for etl_metadata in history_octane_etl_metadata:
        sp_group_1_branches.append(generate_message_state(etl_metadata["process_name"], etl_metadata["target_table"]))
        if len(etl_metadata["next_processes"]) > 0:
            sp_group_2_branches.append(generate_message_state(etl_metadata["process_name"], etl_metadata["target_table"]))

    formatted_sp_group_1 = json.dumps(sp_group_1, indent=4)
    formatted_sp_group_2 = json.dumps(sp_group_2, indent=4)

    write_to_file(formatted_sp_group_1, os.path.join(pipelines_dir_path, f'SP-GROUP-1.{step_function_file_extension}'))
    write_to_file(formatted_sp_group_2, os.path.join(pipelines_dir_path, f'SP-GROUP-2.{step_function_file_extension}'))


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


def delete_prior_history_octane_etl_trigger_step_functions(directory: str):
    step_function_file_names = ['SP-GROUP-1.json', 'SP-GROUP-2.json']
    deleted_files_count = 0
    for file in step_function_file_names:
        filepath = os.path.join(directory, file)
        try:
            os.remove(filepath)
            deleted_files_count += 1
        except Exception as e:
            print(f"Could not remove file '{filepath}'! Now exiting.")
            raise e
    print(f'Deleted {deleted_files_count} files from {directory}.')


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
