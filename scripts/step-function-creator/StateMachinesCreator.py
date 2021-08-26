from typing import List, Optional
from collections import defaultdict


class StateMachinesCreator:
    """Generates a configuration dict for a every state machine in the metadata, as well as an overall scheduler configuration string"""

    def __init__(self, raw_state_machine_metadata: List[dict], raw_step_tree_metadata: List[dict],
                 raw_target_table_metadata: List[dict]):
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
        self.target_table_metadata = raw_target_table_metadata

        self.state_machine_creator = SingleStateMachineCreator(self.state_machine_metadata, self.step_tree_metadata,
                                                               self.target_table_metadata)
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

    def __init__(self, state_machine_metadata: dict, step_tree_metadata: dict, target_table_metadata: List[dict]):
        self.state_machine_metadata = state_machine_metadata
        self.step_tree_metadata = step_tree_metadata
        self.target_table_metadata = target_table_metadata

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

        state_name = root_process
        comment = self.determine_state_machine_header_comment(root_process, state_name)
        root_config = {
            "Comment": comment,
            "StartAt": state_name,
            "States": {}
        }
        root_config_states = root_config['States']
        
        # process has no children
        if root_process not in self.step_tree_metadata:
            root_config_states[state_name] = self.create_task_config(root_process, None)
            return root_config
        # process has one sequential child
        elif len(self.step_tree_metadata[root_process]) == 1:
            next_process = self.step_tree_metadata[root_process][0]
            next_process_target_table = next((item['target_table'] for item in self.target_table_metadata if item['process_name'] == next_process), None)
            root_config_states[state_name] = self.create_task_config(root_process, next_process)
            root_config_states['Load_type_choice'] = self.create_choice_config(f'{next_process}_message')
            root_config_states['Success'] = self.create_success_config()
            root_config_states[f'{next_process}_message'] = self.create_message_config(next_process,next_process_target_table)
            return root_config
        # process has multiple children which should run in parallel
        else:
            next_processes = self.step_tree_metadata[root_process]
            root_config_states[state_name] = self.create_task_config(root_process, next_processes)
            root_config_states['Load_type_choice'] = self.create_choice_config('Parallel')
            root_config_states['Success'] = self.create_success_config()
            root_config_states['Parallel'] = self.create_parallel_config()
            for next_process in next_processes:
                next_process_target_table = next((item['target_table'] for item in self.target_table_metadata if
                                                  item['process_name'] == next_process), None)
                root_config_states['Parallel']['Branches'].append({
                    "Comment": f'Send message to bi-managed-mdi-2-full-check-queue for {next_process}',
                    "StartAt": f'{next_process}_message',
                    "States": {
                        f'{next_process}_message': self.create_message_config(next_process, next_process_target_table)
                    }
                })
            return root_config



    def determine_state_machine_header_comment(self, process: str, state_name: str) -> str:
        """Create a state machine header comment based on whether the root process is a true root or just a sub-root in a parallel step"""
        if process in self.state_machine_metadata:  # process is a top-level root
            root_metadata = self.state_machine_metadata[process]
            return root_metadata['name'] + ' - ' + root_metadata['comment']
        else:  # process is a child process being executed in parallel
            return f'Parallel - {state_name}'

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
            state_config['Resource'] += '.sync'
        else:
            state_config['Next'] = 'Load_type_choice'
            state_config['Resource'] += '.waitForTaskToken'
        return state_config

    @staticmethod
    def create_message_config(process_name: str, next_process_target_table: str) -> dict:
        """Create an AWS Task state configuration that sends a message to an AWS SQS queue"""
        message_config = {
            'Type': 'Task',
            'Resource': 'arn:aws:states:::sqs:sendMessage',
            'Parameters': {
                'QueueUrl': '${fullCheckQueueUrl}',
                'MessageGroupId': next_process_target_table,
                'MessageDeduplicationId.$': "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                'MessageAttributes': {
                    'ProcessId': {
                        'DataType': 'String',
                        'StringValue': process_name
                    }
                },
                'MessageBody.$': "States.JsonToString($)"
            },
            'End': True
        }
        return message_config

    @staticmethod
    def create_parallel_config() -> dict:
        """Create an empty AWS Parallel state configuration for processes that send multiple SQS messages"""
        parallel_config = {
            'Type': 'Parallel',
            'End': True,
            'Branches': []
        }
        return parallel_config

    @staticmethod
    def create_choice_config(next_state_name: str) -> dict:
        """Create an AWS Choice state configuration that branches to a Success state if the previous step outputted a load_type of NONE"""
        return {
            'Type': 'Choice',
            'Choices': [
                {
                    'Variable': '$.load_type',
                    'StringEquals': 'NONE',
                    'Next': 'Success'
                }
            ],
            'Default': next_state_name
        }

    @staticmethod
    def create_success_config() -> dict:
        """Create an AWS Succeed state configuration"""
        return {
            'Type': 'Succeed'
        }
