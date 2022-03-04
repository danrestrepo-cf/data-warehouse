"""A collection of classes that store metadata used for generating EDW's inventory of state machines."""

from dataclasses import dataclass
from typing import List


@dataclass
class ETLStateMachineComponentsMetadata:
    """Metadata describing a state machine that executes a single ETL process

    Attributes:
        target_table: the name of the process' target_table
        container_memory: the amount of memory (MB) allocated for executing the process
        comment: a description of the process
        next_processes: a list of downstream, dependent processes
    """

    target_table: str
    container_memory: int
    comment: str
    next_processes: List[str]


@dataclass
class GroupStateMachinesComponentsMetadata:
    """Metadata describing a state machine that sends a number of SQS messages in parallel for triggering ETL state
    machines

    Attributes:
        process_name: the name of the ETL process for which a triggering message is sent
        target_schema: the name of the process' target_schema
        target_table: the name of the process' target_table
        has_dependency: an indicator as to whether the process has one or more downstream, dependent processes
    """

    process_name: str
    target_schema: str
    target_table: str
    has_dependency: bool
