import math
from dataclasses import dataclass
from typing import Optional, List, Callable, Dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, StepFunctionMetadata, ETLMetadata
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

        self.state_machine_metadata = {}
        self.group_state_machine_metadata = []
        for database in self.data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for step_function in table.step_functions:
                        self.state_machine_metadata[step_function.name] = step_function

                        # """NOTE: The below if statement is a temporary workaround for the KeyError exception that
                        # results from how the SP-200001-delete ETL(s) is/are defined (at the individual partition level)
                        # within its target table's yaml file vs. how it is called as a subsequent ETL (by just the
                        # parent name SP-200001-delete) in other yaml files.
                        #
                        # The long-term fix for this issue will be implemented here: https://app.asana.com/0/0/1201843492068511
                        # """
                        # if step_function.name.startswith('SP-200001-delete') is True:
                        #     parsed_process_name = '-'.join(step_function.name.split('-')[0:3])
                        # else:
                        #     parsed_process_name = step_function.name
                        #
                        # for etl in step_function.etls:
                        #     # parse DataWarehouseMetadata into structure needed to generate ETL state machines
                        #     self.etl_state_machine_metadata[parsed_process_name] = ETLStateMachineComponentsMetadata(
                        #         target_table=etl.output_table.table,
                        #         container_memory=etl.container_memory,
                        #         comment=etl.description,
                        #         next_processes=sorted(etl.next_step_functions)
                        #     )
                        #     self.group_state_machine_metadata.append(GroupStateMachinesComponentsMetadata(
                        #         process_name=parsed_process_name,
                        #         target_schema=schema.name,
                        #         target_table=etl.output_table.table,
                        #         has_dependency=len(etl.next_step_functions) > 0
                        #     ))

        self.etl_state_machine_generator = NewStateMachineGenerator(self.state_machine_metadata)

    def build_state_machines(self) -> dict:
        """Build ETL and group state machine configuration dicts for given metadata"""
        etl_state_machines = self.etl_state_machine_generator.build_etl_state_machines()
        group_state_machines = {}
        group_state_machines_list = [group_state_machine_generator.create_grouped_config(self.group_state_machine_metadata)
                                     for group_state_machine_generator in self.group_generators]
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
            parallel_state = create_state_machine_scaffold(
                comment=state_machine_comment,
                start_at=state_machine_name,
                states={state_machine_name: create_parallel_state()}
            )
            parallel_state['States'][state_machine_name]['Branches'] = \
                self.create_parallel_message_state_branches(filtered_metadata, sub_group)
            result_config[state_machine_name] = parallel_state
        return result_config

    def get_state_machine_name_maker(self, group_state_machine_metadata: List[GroupStateMachinesComponentsMetadata]) -> Callable[
        [int], str]:
        if len(group_state_machine_metadata) <= self.group_state_limit:
            return lambda group_number: self.base_name
        else:
            return lambda group_number: f'{self.base_name}-{group_number + 1}'

    def get_state_machine_comment_maker(self, group_state_machine_metadata: List[GroupStateMachinesComponentsMetadata]) -> Callable[
        [int], str]:
        if len(group_state_machine_metadata) <= self.group_state_limit:
            return lambda group_number: self.comment
        else:
            return lambda group_number: f'{self.comment} - group {group_number + 1}'

    def create_parallel_message_state_branches(self, group_state_machine_metadata: List[GroupStateMachinesComponentsMetadata],
                                               sub_group_number: int) -> List[dict]:
        parallel_branches = []
        metadata_index_start = sub_group_number * self.group_state_limit
        metadata_index_end = (sub_group_number + 1) * self.group_state_limit
        for entry in group_state_machine_metadata[metadata_index_start:metadata_index_end]:
            process_name = entry.process_name
            target_table = entry.target_table
            message_state_name = f'{process_name}_message'
            message_state = create_state_machine_scaffold(
                comment=f'Send message to bi-managed-mdi-2-full-check-queue for {process_name}',
                start_at=message_state_name,
                states={message_state_name: create_message_state(
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


class NewStateMachineGenerator:

    def __init__(self, state_machine_metadata: Dict[str, StepFunctionMetadata]):
        self.state_machine_metadata = state_machine_metadata

    def build_etl_state_machines(self) -> Dict[str, dict]:
        """Generate AWS state machine config dicts for all step functions defined in the given state_machine_metadata.

        Generated state machines will execute one-to-many ETLs and cause zero-to-many subsequent messages to be placed
        on the EDW SQS queue to trigger "next step functions" as described in the provided metadata.
        """
        all_state_machines = {}
        for step_function in self.state_machine_metadata.values():
            # if a non-group step function has no ETLs (which, admittedly, probably won't happen), don't include it in the output
            if not step_function.etls:
                continue
            # state machine has 1 ETL (e.g. a standard history_octane step function)
            elif len(step_function.etls) == 1:
                etl = step_function.etls[0]
                state_machine = self.create_single_etl_state_machine(
                    comment=f'{step_function.name} - {etl.description}',
                    start_at_etl=etl
                )
            # state machine has multiple ETLs which need to be triggered in parallel
            else:
                target_table_str = f'{step_function.primary_target_table.database}.{step_function.primary_target_table.schema}.{step_function.primary_target_table.table}'
                state_machine = create_state_machine_scaffold(
                    comment=f'{step_function.name} - Multiple ETLs affecting {target_table_str}',
                    start_at='StartAt Parallel'
                )
                start_at_parallel_state = create_parallel_state()
                state_machine['States']['StartAt Parallel'] = start_at_parallel_state
                sorted_etls = sorted(step_function.etls, key=lambda etl: etl.process_name)
                # number of ETLs exceed the parallel_limit and the ETLs must be broken out into parallelized chains of sequential ETLs
                if step_function.parallel_limit and (len(sorted_etls) > step_function.parallel_limit):
                    next_state_lookup = self.ETLLatticeNextStateLookup(etls=sorted_etls, parallel_limit=step_function.parallel_limit)
                    for i, etl in enumerate(sorted_etls):
                        if etl.next_step_functions:
                            raise ValueError(
                                'The behavior of a parallel-limited/latticed ETL with next_step_functions is undefined. Unable to proceed.')
                        etl_group_number = i % step_function.parallel_limit
                        # if the child state machine for a given parallel sub-group doesn't exist yet, create it
                        if len(start_at_parallel_state['Branches']) <= etl_group_number:
                            start_at_parallel_state['Branches'].append(create_state_machine_scaffold(
                                comment=f'Sequential ETL chain beginning with {etl.process_name} ({etl.description})',
                                start_at=etl.process_name
                            ))
                        start_at_parallel_state['Branches'][etl_group_number]['States'][etl.process_name] = self.create_etl_task_state(
                            etl=etl,
                            next_state_name=next_state_lookup.get_next_state_name(etl.process_name),
                            pass_state_input_as_output=True
                        )
                # number of ETLs is within parallel_limit (or limit is not defined)
                else:
                    for etl in sorted_etls:
                        child_state_machine_config = self.create_single_etl_state_machine(
                            comment=f'{etl.process_name} - {etl.description}',
                            start_at_etl=etl
                        )
                        start_at_parallel_state['Branches'].append(child_state_machine_config)
            all_state_machines[step_function.name] = state_machine
        return all_state_machines

    class ETLLatticeNextStateLookup:
        """A map-like class facilitating lookup of the next ETL state in a sequential chain given the name of the current state.

        For use in constructing "latticed" ETL structures when a step function's ETL count exceeds its parallel_limit.
        """

        def __init__(self, etls: List[ETLMetadata], parallel_limit: int):
            if not parallel_limit or parallel_limit < 1:
                raise ValueError('Parallel limit must be at least 1')
            self._lookup = {}
            for i, etl in enumerate(etls):
                next_etl_index = i + parallel_limit
                if next_etl_index < len(etls):  # index maps to a valid ETL, therefore there *is* a next state
                    self._lookup[etl.process_name] = etls[next_etl_index].process_name
                else:  # the loop is on the last "row" of etls in the lattice, and there is no next state
                    self._lookup[etl.process_name] = None

        def get_next_state_name(self, current_state_name: str) -> str:
            return self._lookup[current_state_name]

    def create_single_etl_state_machine(self, comment: str, start_at_etl: ETLMetadata) -> dict:
        """Create a dict defining an AWS state machine that executes a single ETL.

        In this context, a "state machine" means a dict with the following structure:

            {
                'Comment': '...',
                'StartAt': 'ETL-123456',
                'States': {
                    'ETL-123456': {
                        ...
                    },
                    ...
                }
            }

        In other words, a "top level" state machine structure of the kind initiated
        by the create_single_etl_state_machine method, but fleshed out with an
        ETL task state and any following SQS Message states required to trigger
        the ETL's next step functions.

        Such a structure could be the actual top level of an overall AWS step function,
        or it could appear as a child state machine within a Parallel-type state.
        This method is invoked in both contexts.

        :param comment: the comment to be placed at the head of the state machine
        :param start_at_etl: ETL metdata used to define this state machine's "StartAt" state
        """
        state_machine = create_state_machine_scaffold(comment=comment, start_at=start_at_etl.process_name)
        if start_at_etl.next_step_functions:
            next_state_name = 'Load_type_choice'
            # this success state is used as the state machine "off ramp" by the Load_type_choice state
            state_machine['States']['Success'] = {'Type': 'Succeed'}
            self.add_states_to_trigger_next_step_functions(start_at_etl, state_machine)
        else:
            next_state_name = None
        state_machine['States'][start_at_etl.process_name] = self.create_etl_task_state(etl=start_at_etl, next_state_name=next_state_name)
        return state_machine

    def add_states_to_trigger_next_step_functions(self, etl: ETLMetadata, state_machine: dict) -> None:
        """Update the given state machine dict with any additional states needed to ensure the given ETL's next step functions are triggered.

        This method always adds a load type choice state which will exit the state
        machine early if the previous ETL produced no output. If the ETL has a single
        "next step function", the choice state directly triggers the appropriate
        SQS message state. If the ETL has multiple "next step funcitons", then the
        choice state triggers a parallel state, which in turn triggers all appropriate
        SQS message states.

        :param etl: ETL metadata defining a list of next_step_functions to be triggered
        :param state_machine: the state machine to which to add the new states
        """
        if len(etl.next_step_functions) == 1:  # directly trigger the single message state after the choice state
            message_state_name = f'{etl.next_step_functions[0]}_message'
            state_machine['States']['Load_type_choice'] = create_choice_state(message_state_name)
            next_step_function = self.get_step_function_metadata(etl.next_step_functions[0])
            state_machine['States'][message_state_name] = create_message_state(next_step_function)
        else:  # there are multiple next_step_functions which need to be wrapped in a parallel state
            parallel_state_name = f'{etl.process_name} Next Step Functions'
            state_machine['States']['Load_type_choice'] = create_choice_state(parallel_state_name)
            state_machine['States'][parallel_state_name] = create_parallel_state()
            for next_step_function_name in etl.next_step_functions:
                message_state_name = f'{next_step_function_name}_message'
                message_state_machine_config = create_state_machine_scaffold(
                    comment=f'Send message to bi-managed-mdi-2-full-check-queue for {next_step_function_name}',
                    start_at=message_state_name
                )
                next_step_function = self.get_step_function_metadata(next_step_function_name)
                message_state_machine_config['States'][message_state_name] = create_message_state(next_step_function)
                state_machine['States'][parallel_state_name]['Branches'].append(message_state_machine_config)

    def get_step_function_metadata(self, step_function_name: str) -> StepFunctionMetadata:
        """Retrieve the StepFunctionMetadata object with the given name, throwing an error if it can't be found."""
        if step_function_name not in self.state_machine_metadata:
            raise ValueError(f'Step function "{step_function_name}" not defined in given metadata')
        return self.state_machine_metadata[step_function_name]

    @staticmethod
    def create_etl_task_state(etl: ETLMetadata, next_state_name: Optional[str] = None, pass_state_input_as_output: bool = False) -> dict:
        """Create an AWS Task state configuration that triggers an MDI-2 Pentaho process (ETL).

        :param etl: an ETLMetadata object describing the ETL to be executed by this task state
        :param next_state_name: the name of the next state after this one in the state machine.
               If None, then this task state is treated as a terminal state.
        :param pass_state_input_as_output: a flag indicating whether or not to discard
               the "normal" output of the task state and instead pass on the state's *input*
               to the next state in the state machine. Only used for step functions which
               kick off more ETLs than their parallel_limit allows to execute at once.
        """
        task_state = {
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
                    'Memory': str(etl.container_memory),
                    'ContainerOverrides': [
                        {
                            'Memory': etl.container_memory,
                            'Environment': [
                                {
                                    'Name': 'PROCESS_NAME',
                                    'Value': etl.process_name
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
            task_state['End'] = True
            task_state['Resource'] += '.sync'
        else:
            task_state['Next'] = next_state_name
            task_state['Resource'] += '.waitForTaskToken'

        if pass_state_input_as_output:
            task_state['ResultPath'] = None

        return task_state


# State machine utility functions used by multiple classes in this library


def create_state_machine_scaffold(comment: str, start_at: str, states: Optional[dict] = None) -> dict:
    if states is None:
        states = {}
    root_config = {
        'Comment': comment,
        'StartAt': start_at,
        'States': states
    }
    return root_config


def create_message_state(next_step_function: StepFunctionMetadata) -> dict:
    """Create an AWS Task state configuration that sends a message to an AWS SQS queue"""
    message_config = {
        'Type': 'Task',
        'Resource': 'arn:aws:states:::sqs:sendMessage',
        'Parameters': {
            'QueueUrl': '${fullCheckQueueUrl}',
            'MessageGroupId': next_step_function.primary_target_table.table,
            'MessageDeduplicationId.$': "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
            'MessageAttributes': {
                'ProcessId': {
                    'DataType': 'String',
                    'StringValue': next_step_function.name
                }
            },
            'MessageBody.$': "States.JsonToString($)"
        },
        'End': True
    }
    return message_config


def create_parallel_state() -> dict:
    """Create an empty AWS Parallel state configuration for processes that send multiple SQS messages"""
    parallel_config = {
        'Type': 'Parallel',
        'End': True,
        'Branches': []
    }
    return parallel_config


def create_choice_state(next_state_name: str) -> dict:
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


def create_result_selector_attribute_config(state_name: str) -> dict:
    """Create an AWS ResultSelector attribute configuration"""
    result_selector_config = {
        'StateName': state_name,
        'HttpHeadersDate.$': '$.SdkHttpMetadata.HttpHeaders.Date'
    }
    return result_selector_config
