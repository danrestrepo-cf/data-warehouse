import math
from typing import Optional, List, Callable
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.state_machines_generator.state_machines_metadata import ETLStateMachineComponentsMetadata, GroupStateMachinesComponentsMetadata


class AllStateMachinesGenerator:
    """Generates a state machine configuration dict for all ETL processes defined in yaml metadata"""

    def __init__(self, data_warehouse_metadata: DataWarehouseMetadata, group_generators: List['GroupStateMachineGenerator']):
        """
        Initialize SingleETLStateMachineGenerator and GroupStateMachinesGenerator with a DataWarehouseMetadata
        object, which is then parsed into ETLStateMachineComponentsMetadata and GroupStateMachinesComponentsMetadata
        objects.

        :param data_warehouse_metadata: a DataWarehouseMetadata object.
        """

        self.data_warehouse_metadata = data_warehouse_metadata
        self.group_generators = group_generators

        self.etl_state_machine_metadata = {}
        self.group_state_machine_metadata = []
        for database in self.data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for step_function in table.step_functions:
                        """NOTE: The below if statement is a temporary workaround for the KeyError exception that 
                        results from how the SP-200001-delete ETL(s) is/are defined (at the individual partition level) 
                        within its target table's yaml file vs. how it is called as a subsequent ETL (by just the 
                        parent name SP-200001-delete) in other yaml files.
                        
                        The long-term fix for this issue will be implemented here: https://app.asana.com/0/0/1201843492068511
                        """
                        if step_function.name.startswith('SP-200001-delete') is True:
                            parsed_process_name = '-'.join(step_function.name.split('-')[0:3])
                        else:
                            parsed_process_name = step_function.name
                        for etl in step_function.etls:
                            # parse DataWarehouseMetadata into structure needed to generate ETL state machines
                            self.etl_state_machine_metadata[parsed_process_name] = ETLStateMachineComponentsMetadata(
                                target_table=table.name,
                                container_memory=etl.container_memory,
                                comment=etl.description,
                                next_processes=sorted(etl.next_step_functions)
                            )
                            self.group_state_machine_metadata.append(GroupStateMachinesComponentsMetadata(
                                process_name=parsed_process_name,
                                target_schema=schema.name,
                                target_table=table.name,
                                has_dependency=len(etl.next_step_functions) > 0
                            ))
        self.data_warehouse_metadata = data_warehouse_metadata

        self.etl_state_machine_generator = SingleETLStateMachineGenerator(self.etl_state_machine_metadata)

    def build_state_machines(self) -> dict:
        """Build ETL and group state machine configuration dicts for given metadata"""
        etl_state_machines = {root: self.etl_state_machine_generator.build_etl_state_machine(root)
                              for root in self.etl_state_machine_metadata.keys()}

        group_state_machines = {}
        group_state_machines_list = [group_state_machine_generator.create_grouped_config(
            self.group_state_machine_metadata) for group_state_machine_generator in self.group_generators]
        for entry in group_state_machines_list:
            group_state_machines.update(entry)

        return {**etl_state_machines, **group_state_machines}


class GroupStateMachineGenerator:
    """Generates a group state machine configuration dict for the provided metadata"""

    def __init__(self, group_criteria_function: Callable[[GroupStateMachinesComponentsMetadata], bool],
                 group_state_limit: int, base_name: str,
                 comment: str):
        """
        :param group_criteria_function: A function for specifying which ETL state machines will be triggered by
        the group state machine.
        :param group_state_limit: The maximum number of message states allowed within a given subgroup of a group state
        machine. If the number of message states allocated to the group exceeds this limit, then the overall group
        will be split into two or more subgroups.
        :param base_name: The parent identifier of the group state machine, e.g. SP-GROUP-1
        :param comment: A description of the ETL state machine population that is triggered by the group state machine
        """
        self.group_criteria_function = group_criteria_function
        self.group_state_limit = group_state_limit
        self.base_name = base_name
        self.comment = comment

    def create_grouped_config(self, group_state_machine_metadata: List[GroupStateMachinesComponentsMetadata]) -> dict:
        """Create a grouped state machine configuration dict for sending SQS queue messages in parallel for state
        machines in the provided group metadata"""
        result_config = {}
        # filter group state machine metadata according to group_criteria function
        filtered_metadata = \
            sorted([entry for entry in group_state_machine_metadata if self.group_criteria_function(entry)],
                   key=lambda x: x.process_name)
        make_state_machine_name = self.get_state_machine_name_maker(filtered_metadata)
        make_state_machine_comment = self.get_state_machine_comment_maker(filtered_metadata)
        sub_group_count = math.ceil(len(filtered_metadata) / self.group_state_limit)
        for sub_group in range(0, sub_group_count):  # only executes once if # of state machines is within limit
            state_machine_comment = make_state_machine_comment(sub_group)
            state_machine_name = make_state_machine_name(sub_group)
            parallel_state = create_root_config(
                comment=state_machine_comment,
                start_at=state_machine_name,
                states={state_machine_name: create_parallel_config()}
            )
            parallel_state['States'][state_machine_name]['Branches'] = \
                self.create_parallel_message_state_branches(filtered_metadata, sub_group)
            result_config[state_machine_name] = parallel_state
        return result_config

    def get_state_machine_name_maker(self, group_state_machine_metadata: List[GroupStateMachinesComponentsMetadata]) -> Callable[[int], str]:
        if len(group_state_machine_metadata) <= self.group_state_limit:
            return lambda group_number: self.base_name
        else:
            return lambda group_number: f'{self.base_name}-{group_number + 1}'

    def get_state_machine_comment_maker(self, group_state_machine_metadata: List[GroupStateMachinesComponentsMetadata]) -> Callable[[int], str]:
        if len(group_state_machine_metadata) <= self.group_state_limit:
            return lambda group_number: self.comment
        else:
            return lambda group_number: f'{self.comment} - group {group_number+1}'

    def create_parallel_message_state_branches(self, group_state_machine_metadata: List[GroupStateMachinesComponentsMetadata],
                                               sub_group_number: int) -> List[dict]:
        parallel_branches = []
        metadata_index_start = sub_group_number * self.group_state_limit
        metadata_index_end = (sub_group_number + 1) * self.group_state_limit
        for entry in group_state_machine_metadata[metadata_index_start:metadata_index_end]:
            process_name = entry.process_name
            target_table = entry.target_table
            message_state_name = f'{process_name}_message'
            message_state = create_root_config(
                comment=f'Send message to bi-managed-mdi-2-full-check-queue for {process_name}',
                start_at=message_state_name,
                states={message_state_name: create_message_config(
                    process_name=process_name,
                    target_table=target_table)}
            )

            # insert ResultSelector attribute into message state's attributes before the 'End' attribute
            # this is needed to filter out unnecessary result information from successful message states
            message_state_attributes = message_state['States'][message_state_name]
            result_selector_position = list(message_state_attributes.keys()).index('End')
            message_state_attributes_items = list(message_state_attributes.items())
            message_state_attributes_items.insert(
                result_selector_position, ('ResultSelector', create_result_selector_attribute_config(message_state_name))
            )
            message_state_attributes = dict(message_state_attributes_items)
            message_state['States'][message_state_name] = message_state_attributes

            parallel_branches.append(message_state)
        return parallel_branches


class SingleETLStateMachineGenerator:
    """Generates a single state machine configuration dict to trigger a given ETL"""

    def __init__(self, state_machine_metadata: dict):
        self.all_state_machine_metadata = state_machine_metadata
        self.parent_state_machine_metadata = {k:v for (k,v) in self.all_state_machine_metadata.items()
                                              if len(v.next_processes) > 0}

    def build_etl_state_machine(self, root_process: str) -> dict:
        """Build a full ETL state machine configuration dict that can be output to a json file"""
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
        root_config = create_root_config(
            comment=comment,
            start_at=state_name
        )
        root_config_states = root_config['States']
        ecs_memory = self.all_state_machine_metadata[root_process].container_memory

        # process has no children
        if root_process not in self.parent_state_machine_metadata:
            root_config_states[state_name] = create_task_config(
                process_name=root_process,
                next_state_name=None,
                ecs_memory=ecs_memory)
            return root_config
        # process has one sequential child
        elif len(self.parent_state_machine_metadata[root_process].next_processes) == 1:
            next_process = self.parent_state_machine_metadata[root_process].next_processes[0]
            next_process_target_table = self.all_state_machine_metadata[next_process].target_table
            root_config_states[state_name] = create_task_config(
                process_name=root_process,
                next_state_name=next_process,
                ecs_memory=ecs_memory)
            root_config_states['Load_type_choice'] = create_choice_config(f'{next_process}_message')
            root_config_states['Success'] = create_success_config()
            root_config_states[f'{next_process}_message'] = create_message_config(
                process_name=next_process,
                target_table=next_process_target_table)
            return root_config
        # process has multiple children which should run in parallel
        else:
            next_processes = self.parent_state_machine_metadata[root_process].next_processes
            root_config_states[state_name] = create_task_config(
                process_name=root_process,
                next_state_name=next_processes,
                ecs_memory=ecs_memory)
            root_config_states['Load_type_choice'] = create_choice_config('Parallel')
            root_config_states['Success'] = create_success_config()
            root_config_states['Parallel'] = create_parallel_config()
            for next_process in next_processes:
                next_process_target_table = self.all_state_machine_metadata[next_process].target_table
                next_process_message_state_name = f'{next_process}_message'
                root_config_states['Parallel']['Branches'].append(
                    create_root_config(
                        comment=f'Send message to bi-managed-mdi-2-full-check-queue for {next_process}',
                        start_at=next_process_message_state_name,
                        states={next_process_message_state_name: create_message_config(
                            process_name=next_process,
                            target_table=next_process_target_table
                        )}
                    )
                )
            return root_config

    def determine_state_machine_header_comment(self, process: str, state_name: str) -> str:
        """Create a state machine header comment based on whether the root process is a true root or just a sub-root in a parallel step"""
        if process in self.all_state_machine_metadata.keys():  # process is a top-level root
            root_metadata = self.all_state_machine_metadata[process]
            return process + ' - ' + root_metadata.comment
        else:  # process is a child process being executed in parallel
            return f'Parallel - {state_name}'


def create_root_config(comment: str, start_at: str, states: Optional[dict]=None) -> dict:
    if states is None:
        states = {}
    root_config = {
        'Comment': comment,
        'StartAt': start_at,
        'States': states
    }
    return root_config


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


def create_message_config(process_name: str, target_table: str) -> dict:
    """Create an AWS Task state configuration that sends a message to an AWS SQS queue"""
    message_config = {
        'Type': 'Task',
        'Resource': 'arn:aws:states:::sqs:sendMessage',
        'Parameters': {
            'QueueUrl': '${fullCheckQueueUrl}',
            'MessageGroupId': target_table,
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


def create_parallel_config() -> dict:
    """Create an empty AWS Parallel state configuration for processes that send multiple SQS messages"""
    parallel_config = {
        'Type': 'Parallel',
        'End': True,
        'Branches': []
    }
    return parallel_config


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


def create_success_config() -> dict:
    """Create an AWS Succeed state configuration"""
    return {
        'Type': 'Succeed'
    }


def create_result_selector_attribute_config(state_name: str) -> dict:
    """Create an AWS ResultSelector attribute configuration"""
    result_selector_config = {
        'StateName': state_name,
        'HttpHeadersDate.$': '$.SdkHttpMetadata.HttpHeaders.Date'
    }
    return result_selector_config
