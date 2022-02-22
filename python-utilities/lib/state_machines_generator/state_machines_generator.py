from typing import Optional
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLMetadata


class AllEtlStateMachinesGenerator:
    """Generates a state machine configuration dict for all ETL processes defined in yaml metadata"""

    def __init__(self, data_warehouse_metadata: DataWarehouseMetadata):
        """
        Initialize SingleEtlStateMachineGenerator with metadata from EDW's yaml inventory

        :param data_warehouse_metadata: a DataWarehouseMetadata object.

            This object is immediately parsed into the following form:

                {
                    "SP-123456":
                        {
                            "target_table": "[name of SP-123456 target table]",
                            "container_memory": [amount of ECS container memory used to execute SP-123456],
                            "comment": "[state machine comment text]",
                            "next_processes: "[list of processes triggered by SP-123456]"
                        },
                    ... etc
                }
        """

        etl_state_machine_metadata = {}
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        etl_state_machine_metadata[etl.process_name] = {
                            "target_table": table.name,
                            "container_memory": etl.container_memory,
                            "comment": ETLMetadata.construct_process_description(table.primary_source_table, table.path,
                                                                                 etl.input_type, etl.output_type),
                            "next_processes": sorted(table.next_etls)
                        }

        self.etl_state_machine_metadata = etl_state_machine_metadata
        self.etl_state_machine_generator = SingleEtlStateMachineGenerator(self.etl_state_machine_metadata)

    def build_etl_state_machines(self) -> dict:
        """Build ETL state machine configuration dicts for all ETLs in the given metadata"""
        return {root: self.etl_state_machine_generator.build_etl_state_machine(root)
                for root in self.etl_state_machine_metadata.keys()}


class SingleEtlStateMachineGenerator:
    """Generates a single state machine configuration dict"""

    def __init__(self, state_machine_metadata: dict):
        self.all_state_machine_metadata = state_machine_metadata
        self.parent_state_machine_metadata = {k:v for (k, v) in self.all_state_machine_metadata.items() if len(v['next_processes']) > 0}

    def build_etl_state_machine(self, root_process: str) -> dict:
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
        ecs_memory = self.all_state_machine_metadata[root_process]['container_memory']

        # process has no children
        if root_process not in self.parent_state_machine_metadata:
            root_config_states[state_name] = self.create_task_config(root_process, None, ecs_memory)
            return root_config
        # process has one sequential child
        elif len(self.parent_state_machine_metadata[root_process]['next_processes']) == 1:
            next_process = self.parent_state_machine_metadata[root_process]['next_processes'][0]
            next_process_target_table = self.all_state_machine_metadata[next_process]['target_table']
            root_config_states[state_name] = self.create_task_config(root_process, next_process, ecs_memory)
            root_config_states['Load_type_choice'] = self.create_choice_config(f'{next_process}_message')
            root_config_states['Success'] = self.create_success_config()
            root_config_states[f'{next_process}_message'] = self.create_message_config(next_process, next_process_target_table)
            return root_config
        # process has multiple children which should run in parallel
        else:
            next_processes = self.parent_state_machine_metadata[root_process]['next_processes']
            root_config_states[state_name] = self.create_task_config(root_process, next_processes, ecs_memory)
            root_config_states['Load_type_choice'] = self.create_choice_config('Parallel')
            root_config_states['Success'] = self.create_success_config()
            root_config_states['Parallel'] = self.create_parallel_config()
            for next_process in next_processes:
                next_process_target_table = self.all_state_machine_metadata[next_process]['target_table']
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
        if process in self.all_state_machine_metadata.keys():  # process is a top-level root
            root_metadata = self.all_state_machine_metadata[process]
            return process + ' - ' + root_metadata['comment']
        else:  # process is a child process being executed in parallel
            return f'Parallel - {state_name}'

    @staticmethod
    def create_task_config(process_name: str, next_state_name: Optional[str], ecs_memory: int) -> dict:
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
                    'Memory': str(ecs_memory),
                    'ContainerOverrides': [
                        {
                            'Memory': ecs_memory,
                            'Environment': [
                                {
                                    'Name': 'PROCESS_NAME',
                                    'Value': process_name
                                },
                                {
                                    'Name': 'INPUT_DATA',
                                    'Value.$': "States.Format('\\{\"token_id\":\"{}\",\"mdi_input_json\":{}\\}', $$.Task.Token, States.JsonToString($))"
                                },
                                {
                                    'Name': 'TOKEN_ID',
                                    'Value.$': "$$.Task.Token"
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
