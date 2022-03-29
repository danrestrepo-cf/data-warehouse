import math
from typing import Optional, List, Callable, Dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, StepFunctionMetadata, ETLMetadata


def generate_all_state_machines(data_warehouse_metadata: DataWarehouseMetadata,
                                group_generators: List['GroupStateMachineGenerator']) -> dict:
    """
    Generate a dict with all AWS state machine configurations used by EDW, including SP-GROUP and regular ETL state machines.

    :param data_warehouse_metadata: a DataWarehouseMetadata object defining the AWS
    step functions/ETLs used to generate state machine configuration dicts
    :param group_generators: a list of generator objects that create SP-GROUP state
    machines from the given data warehouse metadata. All group/subgroup configurations
    generated in this way are included together in the final output alongside any
    ETL state machines.
    :returns a dict of the form:
        {
            "state_machine_name": {
                ...state machine configuration...
            },
            ...
        }
    """
    # build a StepFunctionMetadata look-up dict of the form {step_function_name: StepFunctionMetadata object}
    step_functions = {}
    for database in data_warehouse_metadata.databases:
        for schema in database.schemas:
            for table in schema.tables:
                for step_function in table.step_functions:
                    step_functions[step_function.name] = step_function
    # generate all ETL and GROUP state machine dicts
    all_state_machines = {}
    for step_function_name, step_function in step_functions.items():
        # if a non-group step function has no ETLs (which, admittedly, probably won't happen), don't include it in the output
        if not step_function.etls:
            continue
        all_state_machines[step_function_name] = ETLStateMachineGenerator(step_function_name, step_functions).generate()
    for group_state_machine_generator in group_generators:
        subgroup_collection = group_state_machine_generator.generate(list(step_functions.values()))
        all_state_machines.update(subgroup_collection)
    return all_state_machines


class GroupStateMachineGenerator:
    """Generates a group state machine configuration dict for the provided metadata"""

    def __init__(self, group_criteria_function: Callable[[StepFunctionMetadata], bool], group_state_limit: int, base_name: str,
                 comment: str):
        """
        :param group_criteria_function: A function which should return True if the given step
        function should be triggered by the group state machine, and False otherwise.
        :param group_state_limit: The maximum number of message states allowed within a given subgroup of a group state
        machine. If the number of message states allocated to the group exceeds this limit, then the overall group
        will be split into two or more subgroups.
        :param base_name: The parent identifier of the group state machine, e.g. SP-GROUP-1
        :param comment: A description of the step function population that is triggered by the group state machine
        """
        self.group_criteria_function = group_criteria_function
        self.group_state_limit = group_state_limit
        self.base_name = base_name
        self.comment = comment

    def generate(self, step_functions: List[StepFunctionMetadata]) -> dict:
        """Create a grouped state machine configuration dict for sending SQS queue messages in parallel for state
        machines in the provided group metadata"""
        result_config = {}
        # filter group state machine metadata according to group_criteria function
        filtered_step_functions = sorted(
            [step_function for step_function in step_functions if self.group_criteria_function(step_function)],
            key=lambda step_function: step_function.name
        )
        make_state_machine_name = self.get_state_machine_name_maker(filtered_step_functions)
        make_state_machine_comment = self.get_state_machine_comment_maker(filtered_step_functions)
        sub_group_count = math.ceil(len(filtered_step_functions) / self.group_state_limit)
        for sub_group in range(0, sub_group_count):  # only executes once if # of state machines is within limit
            state_machine_comment = make_state_machine_comment(sub_group)
            state_machine_name = make_state_machine_name(sub_group)
            parallel_state = create_state_machine_scaffold(
                comment=state_machine_comment,
                start_at=state_machine_name,
                states={state_machine_name: create_parallel_state()}
            )
            parallel_state['States'][state_machine_name]['Branches'] = self.create_parallel_message_state_branches(filtered_step_functions,
                                                                                                                   sub_group)
            result_config[state_machine_name] = parallel_state
        return result_config

    def get_state_machine_name_maker(self, step_functions: List[StepFunctionMetadata]) -> Callable[[int], str]:
        """Generate a function that creates a state machine name given a group number."""
        if len(step_functions) <= self.group_state_limit:
            return lambda group_number: self.base_name
        else:
            return lambda group_number: f'{self.base_name}-{group_number + 1}'

    def get_state_machine_comment_maker(self, step_functions: List[StepFunctionMetadata]) -> Callable[[int], str]:
        """Generate a function that creates a state machine comment given a group number."""
        if len(step_functions) <= self.group_state_limit:
            return lambda group_number: self.comment
        else:
            return lambda group_number: f'{self.comment} - group {group_number + 1}'

    def create_parallel_message_state_branches(self, step_functions: List[StepFunctionMetadata], sub_group_number: int) -> List[dict]:
        """Create child state machines to populate a Parallel state which trigger the given step functions via SQS message."""
        parallel_branches = []
        metadata_index_start = sub_group_number * self.group_state_limit
        metadata_index_end = metadata_index_start + self.group_state_limit
        for step_function in step_functions[metadata_index_start:metadata_index_end]:
            message_state_name = make_message_state_name(step_function.name)
            message_state = create_state_machine_scaffold(
                comment=f'Send message to bi-managed-mdi-2-full-check-queue for {step_function.name}',
                start_at=message_state_name,
                states={message_state_name: create_message_state(step_function, include_results_selector=True)}
            )
            parallel_branches.append(message_state)
        return parallel_branches


class ETLStateMachineGenerator:

    def __init__(self, step_function_name: str, state_machine_metadata: Dict[str, StepFunctionMetadata]):
        self.step_function = state_machine_metadata[step_function_name]
        self.state_machine_metadata = state_machine_metadata
        self.name_registry = self.NameRegistry()
        self.choice_state_count = 0

    def generate(self) -> Dict[str, dict]:
        """Generate AWS state machine config dicts for all step functions defined in the given state_machine_metadata.

        Generated state machines will execute one-to-many ETLs and cause zero-to-many subsequent messages to be placed
        on the EDW SQS queue to trigger "next step functions" as described in the provided metadata.
        """
        # state machine has 1 ETL (e.g. a standard history_octane step function)
        if len(self.step_function.etls) == 1:
            etl = self.step_function.etls[0]
            state_machine = self.create_single_etl_state_machine(
                comment=f'{self.step_function.name} - {etl.description}',
                start_at_etl=etl
            )
        # state machine has multiple ETLs which need to be triggered in parallel
        else:
            target_table_str = f'{self.step_function.primary_target_table.database}.{self.step_function.primary_target_table.schema}.{self.step_function.primary_target_table.table}'
            state_machine = create_state_machine_scaffold(
                comment=f'{self.step_function.name} - Multiple ETLs affecting {target_table_str}',
                start_at='StartAt Parallel'
            )
            start_at_parallel_state = create_parallel_state()
            state_machine['States']['StartAt Parallel'] = start_at_parallel_state
            sorted_etls = sorted(self.step_function.etls, key=lambda etl: etl.process_name)
            # number of ETLs exceed the parallel_limit and the ETLs must be broken out into parallelized chains of sequential ETLs
            if self.step_function.has_parallel_limit and (len(sorted_etls) > self.step_function.parallel_limit):
                next_state_lookup = self.ETLLatticeNextStateLookup(etls=sorted_etls, parallel_limit=self.step_function.parallel_limit)
                for i, etl in enumerate(sorted_etls):
                    if etl.next_step_functions:
                        raise ValueError(
                            'The behavior of a parallel-limited/latticed ETL with next_step_functions is undefined. Unable to proceed.')
                    etl_group_number = i % self.step_function.parallel_limit
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
        return state_machine

    class NameRegistry:
        """A class to keep track of how many times each state name in the state machine has been used.

        This class is mainly used to ensure that all message state names in the
        state machine are unique in the case of multiple ETLs each triggering some
        of the same "next_step_functions". All state names within a state machine
        must be globally unique according to the AWS state language specification.
        """

        def __init__(self):
            self._name_suffixes = {}

        def make_unique_state_name(self, raw_name: str):
            """Generate a new version of the given state name that is guaranteed to be globally unique in the state machine."""
            if raw_name not in self._name_suffixes:
                self._name_suffixes[raw_name] = 1
                return raw_name  # base case: no suffix required if name is already unique
            else:
                unique_name = f'{raw_name}_{self._name_suffixes[raw_name]}'
                self._name_suffixes[raw_name] += 1
                # cover case where a future state's attempted *raw* name is the same as this state's raw name + suffix
                # e.g. the second "Success" state is given the name "Success_1". If another state's *raw* name is "Success_1",
                # then it would be given the name "Success_1_1" by this method
                self._name_suffixes[unique_name] = 1
                return unique_name

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

    def get_choice_state_suffix(self) -> str:
        if self.choice_state_count < 2:
            return ''
        else:
            return f'_{self.choice_state_count - 1}'

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
        # add key for main ETL first (but don't populate it yet) to ensure human-friendly state ordering in final output
        state_machine['States'][start_at_etl.process_name] = None
        if start_at_etl.next_step_functions:
            self.choice_state_count += 1
            next_state_name = f'Load_type_choice{self.get_choice_state_suffix()}'
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
            raw_message_state_name = make_message_state_name(etl.next_step_functions[0])
            message_state_name = self.name_registry.make_unique_state_name(raw_message_state_name)
            self.add_load_type_choice(state_machine, next_state_name=message_state_name)
            next_step_function = self.get_step_function_metadata(etl.next_step_functions[0])
            state_machine['States'][message_state_name] = create_message_state(next_step_function)
        else:  # there are multiple next_step_functions which need to be wrapped in a parallel state
            parallel_state_name = f'{etl.process_name} Next Step Functions'
            self.add_load_type_choice(state_machine, next_state_name=parallel_state_name)
            state_machine['States'][parallel_state_name] = create_parallel_state()
            for next_step_function_name in sorted(etl.next_step_functions):
                raw_message_state_name = make_message_state_name(next_step_function_name)
                message_state_name = self.name_registry.make_unique_state_name(raw_message_state_name)
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
            'ResultPath': None,
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

        # Even though "ResultPath": None is not needed for *most* task states,
        # it is included by default and then actively *removed* if it isn't needed
        # in order to more easily specify where in the final state output the key appears.
        # If we instead omitted it by default and then only *included* it if needed,
        # it would appear at the bottom of the JSON unless other more complicated
        # steps were taken.
        if not pass_state_input_as_output:
            del task_state['ResultPath']

        return task_state

    def add_load_type_choice(self, state_machine: dict, next_state_name: str) -> None:
        """Create an AWS Choice state configuration that branches to a Success state if the previous step outputted a load_type of NONE.

        :param state_machine: a state machine dict to which to add the Choice and Success states
        :param next_state_name: the state to branch to if the preceding ETL *did*
        have output
        """
        success_state_name = f'Success{self.get_choice_state_suffix()}'
        state_machine['States'][f'Load_type_choice{self.get_choice_state_suffix()}'] = {
            'Type': 'Choice',
            'Choices': [
                {
                    'Variable': '$.load_type',
                    'StringEquals': 'NONE',
                    'Next': success_state_name
                }
            ],
            'Default': next_state_name
        }
        state_machine['States'][success_state_name] = {'Type': 'Succeed'}


#
# State machine utility functions used by multiple classes in this library
#

def create_state_machine_scaffold(comment: str, start_at: str, states: Optional[dict] = None) -> dict:
    """Create a bare-minimum state machine structure including a comment, start-at, and sub-dict of states."""
    return {
        'Comment': comment,
        'StartAt': start_at,
        'States': states or {}
    }


def make_message_state_name(step_function_name: str) -> str:
    """Return a standardized name for a SQS message state which triggers a step function of the given name."""
    return f'{step_function_name}_message'


def create_message_state(triggered_step_function: StepFunctionMetadata, include_results_selector: bool = False) -> dict:
    """Create an AWS Task state configuration that sends a message to an AWS SQS queue"""
    message_config = {
        'Type': 'Task',
        'Resource': 'arn:aws:states:::sqs:sendMessage',
        'Parameters': {
            'QueueUrl': '${fullCheckQueueUrl}',
            'MessageGroupId': triggered_step_function.primary_target_table.table,
            'MessageDeduplicationId.$': "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
            'MessageAttributes': {
                'ProcessId': {
                    'DataType': 'String',
                    'StringValue': triggered_step_function.name
                }
            },
            'MessageBody.$': "States.JsonToString($)"
        },
        'ResultSelector': {
            'StateName': make_message_state_name(triggered_step_function.name),
            'HttpHeadersDate.$': '$.SdkHttpMetadata.HttpHeaders.Date'
        },
        'End': True
    }
    # see comment about ResultPath on create_etl_task_state method above
    if not include_results_selector:
        del message_config['ResultSelector']
    return message_config


def create_parallel_state() -> dict:
    """Create an empty AWS Parallel state configuration for processes that send multiple SQS messages"""
    return {
        'Type': 'Parallel',
        'End': True,
        'Branches': []
    }
