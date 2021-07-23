import os
import json

from EDW import EDW
from StateMachinesCreator import StateMachinesCreator


def main():
    # load metadata
    edw = EDW()
    state_machine_metadata = edw.get_state_machine_metadata()
    step_tree_metadata = edw.get_step_tree_metadata()
    target_table_metadata = edw.get_target_table_metadata()
    state_machine_file_extension = 'json'

    try:
        # generate and format state machine configuration strings
        state_machine_creator = StateMachinesCreator(state_machine_metadata, step_tree_metadata, target_table_metadata)
        state_machine_configs = state_machine_creator.build_state_machines()
        formatted_config_strings = format_data_for_outputting(state_machine_configs)

        # the following file path should be changed if this script is ever moved to a new location in the repo
        infrastructure_dir_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'infrastructure')
        pipelines_dir_path = os.path.join(infrastructure_dir_path, 'pipelines')
        delete_prior_state_machine_configurations(pipelines_dir_path, state_machine_file_extension)

        # output config files
        for name, config in formatted_config_strings.items():
            config_file_path = os.path.join(pipelines_dir_path, f'{name}.{state_machine_file_extension}')
            write_to_file(config, config_file_path)
        # output schedules.tf file
        schedules_file_contents = state_machine_creator.create_schedule_config_string(
            indent_space_count=2,
            file_extension=state_machine_file_extension
        )
        schedules_filepath = os.path.join(infrastructure_dir_path, 'schedules.tf')
        write_to_file(schedules_file_contents, schedules_filepath)
    except StateMachinesCreator.InvalidMetadataError:
        print("Invalid state machine configuration detected. Now exiting.")
        exit(2)
    except RuntimeError as e:
        print(e)
        exit(2)


def delete_prior_state_machine_configurations(directory: str, state_machine_file_extension: str):
    non_state_machine_files = list(filter(lambda x: not x.endswith(f'.{state_machine_file_extension}'), os.listdir(directory)))
    if non_state_machine_files:
        raise RuntimeError(f'Output directory contains unexpected non-{state_machine_file_extension} files, and may be invalid. Now exiting.')
    deleted_files_count = 0
    for file in os.listdir(directory):
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


if __name__ == "__main__":
    main()
