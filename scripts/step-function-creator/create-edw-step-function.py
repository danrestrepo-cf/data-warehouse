from EDW import EDW
import StateMachineCreator
import os


def main():
    edw = EDW()

    # detect if there are any misconfigured state_machine_step records
    if not edw.has_only_valid_state_machine_configs():
        print(f"Invalid state machine configuration detected. Now exiting.")
        exit(2)

    # remove any files from a previous run
    # this assumes that the working directory is a subfolder of the scripts folder
    output_file_path = "../../infrastructure/pipelines/"
    empty_directory(output_file_path)

    # get list of step_machine_definitions
    state_machine_definitions = edw.get_all_state_machine_definitions()

    # create a dict that will hold each of the state machine
    state_machines = {}

    # create dictionary to hold state_machine objects
    for state_machine_definition in state_machine_definitions:
        # parse data from tuple
        state_machine_starting_process_dwid = state_machine_definition[0]
        state_machine_name = state_machine_definition[1]
        state_machine_comment = state_machine_definition[2]

        state_machines[state_machine_starting_process_dwid] = StateMachineCreator.StateMachineCreator(state_machine_comment, state_machine_name)

        # get list of all steps for the current state_machine_definition based on the starting process_dwid
        states_to_create = edw.get_all_step_children_by_process_id(state_machine_starting_process_dwid)

        for state_to_create in states_to_create:
            # parse data from tuple
            # state_process_dwid = state_to_create[0]
            state_process_name = state_to_create[1]
            state_machines[state_machine_starting_process_dwid].add_state_to_state_machine_sequential(state_process_name)

        output_data(state_machines[state_machine_starting_process_dwid], state_machine_name, output_file_path)


def empty_directory(directory: str):
    for file in os.scandir(directory):
        try:
            os.remove(file.path)
        except Exception as e:
            print(f"Could not remove file '{file.path}'! Exiting...")
            raise e


def output_data(state_machine: StateMachineCreator, file_name: str, file_path: str = "../../infrastructure/pipelines/", file_extension: str = "json"):
    filename_with_extension = f"{file_name}.{file_extension}"

    try:
        f = open(f"{file_path}{filename_with_extension}", "w")
        f.write(str(state_machine))
        f.close()
    except Exception as e:
        print(f"Could not open or save file {file_path}{filename_with_extension}!")
        print(f"The file's contents would have been: {str(state_machine)}")
        raise e

    print(f"Saved '{file_path}{filename_with_extension}'")

if __name__ == "__main__":
    main()
