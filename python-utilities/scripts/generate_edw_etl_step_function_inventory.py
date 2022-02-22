import sys
import os
import json
import fnmatch

PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))

# this line allows the script to import directly from lib when run from the command line
sys.path.append(PROJECT_DIR_PATH)

from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.metadata_core.data_warehouse_metadata import ETLMetadata
from lib.state_machines_generator.state_machines_generator import AllEtlStateMachinesGenerator


def main():
    # load yaml metadata into DataWarehouseMetadata structure
    metadata_dir = os.path.join(PROJECT_DIR_PATH, '..', 'metadata', 'edw')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(metadata_dir)
    state_machine_file_extension = 'json'

    # initialize variable for write-to directory
    infrastructure_dir_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'infrastructure')
    pipelines_dir_path = os.path.join(infrastructure_dir_path, 'pipelines')
    # delete existing inventory of ETL state machines
    delete_prior_state_machine_configurations(pipelines_dir_path, state_machine_file_extension)

    state_machine_metadata = {}
    for database in data_warehouse_metadata.databases:
        for schema in database.schemas:
            for table in schema.tables:
                for etl in table.etls:
                    state_machine_metadata[etl.process_name] = {
                        "target_table": table.name,
                        "container_memory": etl.container_memory,
                        "comment": ETLMetadata.construct_process_description(table.primary_source_table, table.path,
                                                                             etl.input_type, etl.output_type),
                        "next_processes": sorted(table.next_etls)
                    }

    etl_state_machine_generator = AllEtlStateMachinesGenerator(state_machine_metadata)
    state_machine_configs = etl_state_machine_generator.build_etl_state_machines()
    formatted_config_strings = format_data_for_outputting(state_machine_configs)
    # output config files
    for name, config in formatted_config_strings.items():
        config_file_path = os.path.join(pipelines_dir_path, f'{name}.{state_machine_file_extension}')
        write_to_file(config, config_file_path)


def delete_prior_state_machine_configurations(directory: str, state_machine_file_extension: str):
    non_state_machine_files = list(filter(lambda x: not x.endswith(f'.{state_machine_file_extension}'), os.listdir(directory)))
    if non_state_machine_files:
        raise RuntimeError(f'Output directory contains unexpected non-{state_machine_file_extension} files, and may be invalid. Now exiting.')
    deleted_files_count = 0
    for file in os.listdir(directory):
        if not fnmatch.fnmatch(file, "SP-GROUP-*"):
            filepath = os.path.join(directory, file)
            try:
                os.remove(filepath)
                deleted_files_count += 1
            except Exception as e:
                print(f"Could not remove file '{filepath}'! Now exiting.")
                raise e
    print(f'Deleted {deleted_files_count} {state_machine_file_extension} files from {directory}.')


def format_data_for_outputting(state_machine_configs: dict) -> dict:
    return {name: json.dumps(config, indent=4).replace('"${subnetIDs}"', '${subnetIDs}') + '\n\n'
            for name, config in state_machine_configs.items()}


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
