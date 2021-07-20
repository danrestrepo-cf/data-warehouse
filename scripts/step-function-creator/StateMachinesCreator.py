from typing import List, Optional
from collections import defaultdict


class StateMachinesCreator:
    """Generates a configuration dict for a every state machine in the metadata, as well as an overall scheduler configuration string"""

    def __init__(self, raw_state_machine_metadata: List[dict], raw_step_tree_metadata: List[dict]):
        """
        Initialize StateMachineCreator with metadata from EDW's config database

        Note: state machine metadata only contains metadata about the *root* of
        each state machine, while step tree metadata describes the entire structure
        of each state machine's step tree

        :param raw_state_machine_metadata: a list of state machine metadata rows of the form:

                    {
                        "process_name": "SP-123456",
                        "state_machine_name": "Octane__something",
                        "comment": "comment text",
                        "cron_schedule": "0/15 * * * ? *"
                    }

               This raw data is immediately parsed into a more useful data structure of the form:

                    {
                        "SP-123456": {
                            "name": "Octane__table_etl",
                            "comment": "comment text here",
                            "cron_schedule": "0/15 * * * ? *"
                        },
                        ...etc
                    }

        :param raw_step_tree_metadata: a list of state machine step tree metadata rows of the form:

                    {"process_name": "SP-123456", "child_process_name": "SP-234567"}

               This raw data is immediately parsed into a more useful data structure of the form:

                    {
                        "SP-123456": ["SP-234567", "SP-345678"],
                        "SP-234567": ["SP-456789"],
                        ...etc
                    }
        """
        # initialize internal metadata data structures
        self.state_machine_metadata = {
            row['process_name']: {
                'name': row['state_machine_name'],
                'comment': row['comment'],
                'cron_schedule': row['cron_schedule']
            }
            for row in raw_state_machine_metadata
        }
        self.step_tree_metadata = defaultdict(list)
        for row in raw_step_tree_metadata:
            self.step_tree_metadata[row['process_name']].append(row['child_process_name'])
        self.state_machine_creator = SingleStateMachineCreator(self.state_machine_metadata, self.step_tree_metadata)
        # perform error checking on metadata
        self.throw_error_if_metadata_contains_loops()

    def create_schedule_config_string(self, indent_space_count: int = 2, file_extension: str = 'json') -> str:
        """
        Generate Terraform schedule configuration file contents from state machine metadata

        :param indent_space_count: the number of spaces per indent in the output file string
        :param file_extension: the file extension to append to each scheduled file name
        :return: a Terraform schedule configuration string (ready to be written to a file)
        """
        indent = ' ' * indent_space_count
        file_configs = '\n'.join([f'{indent * 2}"{config["name"]}.{file_extension}" = "cron({config["cron_schedule"]})"'
                                  for config in sorted(self.state_machine_metadata.values(), key=lambda x: x['name'].casefold())
                                  if config['cron_schedule'] is not None])
        return 'locals {\n' + \
               indent + 'schedules = {\n' + \
               file_configs + '\n' + \
               indent + '}\n' + \
               '}\n'

    def build_state_machines(self) -> dict:
        """Build state machine configuration dicts for every state machine in the given metadata"""
        return {self.state_machine_metadata[root]['name']: self.state_machine_creator.build_state_machine(root)
                for root in self.state_machine_metadata.keys()}

    def throw_error_if_metadata_contains_loops(self):
        """Check all state machine metadata for loops, throwing an error if any are found"""
        for root_process in self.state_machine_metadata.keys():
            found_processes = set()
            self.recursively_check_for_loops(found_processes, root_process)

    def recursively_check_for_loops(self, found_processes: set, process: str):
        """Recursively check the given process (and its descendants) for loops"""
        if process in found_processes:
            raise self.InvalidMetadataError()
        found_processes.add(process)
        if process in self.step_tree_metadata:
            for child_process in self.step_tree_metadata[process]:
                self.recursively_check_for_loops(found_processes.copy(), child_process)

    class InvalidMetadataError(Exception):
        """Custom error to be thrown during class initialization if the metadata is invalid"""


class SingleStateMachineCreator:
    """Generates a configuration dict for a single state machine"""

    def __init__(self, state_machine_metadata: dict, step_tree_metadata: dict):
        self.state_machine_metadata = state_machine_metadata
        self.step_tree_metadata = step_tree_metadata
        self.counters = defaultdict(int)

    def build_state_machine(self, root_process: str) -> dict:
        """Build a full state machine configuration dict that can be output to a json file"""
        return self.create_step_tree(root_process)

    def create_step_tree(self, root_process: str) -> dict:
        """Initiate the recursive step tree creator function with the state machine's top-level root process

        Note: this method can be triggered by either:
         - creating the top-level structure of an entire state machine, in which
           case "root_process" is the root of the entire machine
         - creating parallel execution branches, in which case "root_process" is
           just one of many child processes being executed in parallel

        :param root_process: the root process of this state machine config
        :return: the full state machine configuration tree starting from the given
                 root process
        """
        state_name = self.get_unique_state_name(root_process)
        comment = self.determine_state_machine_header_comment(root_process, state_name)
        root_config = {
            "Comment": comment,
            "StartAt": state_name,
            "States": {}
        }
        # process has no children
        if root_process not in self.step_tree_metadata:
            root_config['States'][state_name] = self.create_task_config(root_process, None)
            return root_config
        # process has one sequential child
        elif len(self.step_tree_metadata[root_process]) == 1:
            next_process = self.step_tree_metadata[root_process][0]
            next_state_name = self.get_unique_state_name(next_process)
            root_config['States'][state_name] = self.create_task_config(root_process, next_process)
            root_config['States'][next_state_name] = self.create_message_config(next_state_name)
            return root_config
        # process has multiple children which should run in parallel
        else:
            parallel_state_name = self.get_unique_state_name('parallel')
            self.increment_counter('parallel')
            root_config['States'][state_name] = self.create_task_config(root_process, parallel_state_name)
            root_config['States'][parallel_state_name] = self.create_parallel_config()
            for value in self.step_tree_metadata[root_process]:
                root_config['States'][parallel_state_name]['Branches'].append(self.create_message_config(value))
            return root_config



    def determine_state_machine_header_comment(self, process: str, state_name: str) -> str:
        """Create a state machine header comment based on whether the root process is a true root or just a sub-root in a parallel step"""
        if process in self.state_machine_metadata:  # process is a top-level root
            root_metadata = self.state_machine_metadata[process]
            return root_metadata['name'] + ' - ' + root_metadata['comment']
        else:  # process is a child process being executed in parallel
            return f'Parallel - {state_name}'

    # def recursively_create_step_tree(self, cur_root_config: dict, process_name: str, state_name: str) -> dict:
    #     """
    #     Recursively populate a state machine configuration dict with state configurations
    #     for a given process and its descendants.
    #
    #     :param cur_root_config: the current state machine configuration dict to
    #            which states are being added
    #     :param process_name: the process for which to add a state
    #     :param state_name: the name of the state to add. This is the same as the
    #            process name unless the process name appears multiple times in the
    #            configuration
    #     :return: the current state machine configuration, after the given process's
    #              state (and any states for that process's descendants) have been
    #              added
    #     """
    #     self.increment_counter(process_name)
    #     # process has no children
    #     if process_name not in self.step_tree_metadata:
    #         cur_root_config['States'][state_name] = self.create_task_config(process_name, None)
    #         return cur_root_config
    #     # process has one sequential child
    #     elif len(self.step_tree_metadata[process_name]) == 1:
    #         next_process = self.step_tree_metadata[process_name][0]
    #         next_state_name = self.get_unique_state_name(next_process)
    #         self.add_non_terminal_state_config(state_name, process_name, next_state_name, cur_root_config['States'])
    #         return self.recursively_create_step_tree(cur_root_config, next_process, next_state_name)
    #     # process has multiple children which should run in parallel
    #     else:
    #         next_state_name = self.get_unique_state_name('parallel')
    #         self.increment_counter('parallel')
    #         self.add_non_terminal_state_config(state_name, process_name, next_state_name, cur_root_config['States'])
    #         cur_root_config['States'][next_state_name] = {
    #             'Type': 'Parallel',
    #             'End': True,
    #             'Branches': [self.create_step_tree(parallel_root) for parallel_root in self.step_tree_metadata[process_name]]
    #         }
    #         return cur_root_config
    #
    # def add_non_terminal_state_config(self, state_name: str, process_name: str, next_state_name: Optional[str], states_dict: dict):
    #     """Add a non-terminal state configuration, including subsequent Choice and Success states, to the given state config dict"""
    #     choice_state_name = self.get_unique_state_name('choice')
    #     success_state_name = self.get_unique_state_name('success')
    #     states_dict[state_name] = self.create_task_config(process_name, choice_state_name)
    #     states_dict[choice_state_name] = self.create_choice_config(success_state_name, next_state_name)
    #     states_dict[success_state_name] = self.create_success_config()
    #     self.increment_counter('choice')
    #     self.increment_counter('success')

    @staticmethod
    def create_task_config(process_name: str, next_state_name: Optional[str]) -> dict:
        """Create an AWS Task state configuration that triggers an MDI-2 Pentaho process"""
        state_config = {
            'Type': 'Task',
            'Resource': 'arn:aws:states:::ecs:runTask',
            'Parameters': {
                'LaunchType': 'FARGATE',
                'Cluster': '${ecsClusterARN}',
                'TaskDefinition': '${mdi_2_arn}',
                'NetworkConfiguration': {
                    'AwsvpcConfiguration': {
                        'AssignPublicIp': 'DISABLED',
                        'SecurityGroups': [
                            '${securityGroupId}'
                        ],
                        'Subnets': '${subnetIDs}'
                    }
                },
                'Overrides': {
                    'ContainerOverrides': [
                        {
                            'Environment': [
                                {
                                    'Name': 'PROCESS_NAME',
                                    'Value': process_name
                                },
                                {
                                    'Name': 'INPUT_DATA',
                                    'Value.$': "States.Format('\\{\"token_id\":\"{}\",\"mdi_input_json\":{}\\}', $$.Task.Token, States.JsonToString($))"
                                }
                            ],
                            'Name': '${mdi_2_container}'
                        }
                    ]
                }
            },
        }
        if next_state_name is None:
            state_config['End'] = True
            state_config['Resource'] += '.sync' # Is this still needed?
        else:
            state_config['Next'] = next_state_name
            state_config['Resource'] += '.waitForTaskToken'
        return state_config

    @staticmethod
    def create_message_config(process_name: str) -> dict:
        """Create an AWS Task state configuration that sends a message to an AWS SQS queue"""
        message_config = {
            'Comment': f'Send message to FullCheckQueue for {process_name}',
            'Type': 'Task',
            'Resources': 'arn:aws:states:::sqs:sendMessage',
            'Parameters': {
                'QueueUrl': '[QueueUrl]',
                'MessageAttributes': {
                    'MessageGroupId': {
                        'DataType': 'String',
                        'StringValue': '[name of target table for subsequent SP]'
                    },
                    'ProcessId': {
                        'DataType': 'String',
                        'StringValue': process_name
                    }
                },
            },
            'End': 'True'
        }
        return message_config

    @staticmethod
    def create_parallel_config() -> dict:
        """Create an empty AWS Parallel state configuration for processes that send multiple SQS messages"""
        parallel_config = {
            'Type': 'Parallel',
            'End': 'True',
            'Branches': []
        }
        return parallel_config

    # @staticmethod
    # def create_choice_config(success_state_name: str, next_state_name: str) -> dict:
    #     """Create an AWS Choice state configuration that branches to a Success state if the previous step outputted a load_type of NONE"""
    #     return {
    #         'Type': 'Choice',
    #         'Choices': [
    #             {
    #                 'Variable': '$.load_type',
    #                 'StringEquals': 'NONE',
    #                 'Next': success_state_name
    #             }
    #         ],
    #         'Default': next_state_name
    #     }
    #
    # @staticmethod
    # def create_success_config() -> dict:
    #     """Create an AWS Succeed state configuration"""
    #     return {
    #         'Type': 'Succeed'
    #     }

    def get_unique_state_name(self, process: str) -> str:
        """Get the guaranteed-unique state name for the given process"""
        if self.counters[process] == 0:
            return process
        else:
            return f'{process}_{self.counters[process]}'

    def increment_counter(self, process: str):
        """Record a single usage of a process in the state machine"""
        self.counters[process] += 1
