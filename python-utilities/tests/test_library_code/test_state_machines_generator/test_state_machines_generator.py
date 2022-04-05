import unittest
from typing import Optional
from lib.state_machines_generator.state_machines_generator import generate_all_state_machines, GroupStateMachineGenerator
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


class StateMachineTestCase(unittest.TestCase):
    """TestCase subclass with custom assertions related to state machines."""

    def assertTaskStateEquals(self, expected_etl_name: str, expected_ecs_memory: int, expected_next_state: Optional[str],
                              expected_resource_suffix: str, expect_to_have_end: bool, null_result_path: bool, actual_state: dict):
        expected_task_config = {
            'Type': 'Task',
            'Resource': f'arn:aws:states:::ecs:runTask{expected_resource_suffix}',
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
                    'Memory': str(expected_ecs_memory),
                    'ContainerOverrides': [
                        {
                            'Memory': expected_ecs_memory,
                            'Environment': [
                                {
                                    'Name': 'PROCESS_NAME',
                                    'Value': expected_etl_name
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
        if expect_to_have_end:
            expected_task_config['End'] = True
        if expected_next_state:
            expected_task_config['Next'] = expected_next_state
        if null_result_path:
            expected_task_config['ResultPath'] = None
        self.assertEqual(expected_task_config, actual_state)

    def assertChoiceStateEquals(self, expected_next_state_name: str, actual_state: dict):
        expected_choice_state = {
            'Type': 'Choice',
            'Choices': [
                {
                    'Variable': '$.load_type',
                    'StringEquals': 'NONE',
                    'Next': 'Success'
                }
            ],
            'Default': expected_next_state_name
        }
        self.assertEqual(expected_choice_state, actual_state)

    def assertMessageStateEquals(self, expected_target_table: str, expected_step_function_name: str, actual_state: dict):
        expected_message_config = {
            'Type': 'Task',
            'Resource': 'arn:aws:states:::sqs:sendMessage',
            'Parameters': {
                'QueueUrl': '${fullCheckQueueUrl}',
                'MessageGroupId': expected_target_table,
                'MessageDeduplicationId.$': "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                'MessageAttributes': {
                    'ProcessId': {
                        'DataType': 'String',
                        'StringValue': expected_step_function_name
                    }
                },
                'MessageBody.$': "States.JsonToString($)"
            },
            'End': True
        }
        self.assertEqual(expected_message_config, actual_state)

    def assertHasSuccessState(self, actual_state_machine: dict):
        expected_success_state = {'Type': 'Succeed'}
        self.assertEqual(expected_success_state, actual_state_machine['States']['Success'])


class TestNonGroupStateMachines(StateMachineTestCase):

    def setUp(self):
        data_warehouse_metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'dw',
            'databases': [
                {
                    'name': 'db1',
                    'schemas': [
                        {
                            'name': 'sch1',
                            'tables': [
                                {
                                    'name': 'table1',
                                    'primary_source_table': 'db1.sch1.table0',
                                    'step_functions': {
                                        # SFN kicking off 1 ETL with 1 "next_step_function"
                                        'SP-10': {
                                            'etls': {
                                                'ETL-100': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table1',
                                                    'container_memory': 2048,
                                                    'next_step_functions': ['SP-20']
                                                }
                                            }
                                        },
                                        # SFN kicking off multiple ETLs with multiple "next_step_functions"
                                        'SP-11': {
                                            'etls': {
                                                'ETL-101': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table1',
                                                    'container_memory': 4096,
                                                    'next_step_functions': ['SP-21', 'SP-22']
                                                },
                                                'ETL-102': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table1',
                                                    'container_memory': 2048,
                                                    'next_step_functions': ['SP-22', 'SP-23', 'SP-24']
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    'name': 'table2',
                                    'primary_source_table': 'db1.sch1.table1',
                                    'step_functions': {
                                        # SFN kicking off 1 ETL with 0 "next_step_functions"
                                        'SP-20': {
                                            'parallel_limit': 30,
                                            # show that nothing special happens if parallel_limit is defined, but larger than # of ETLs
                                            'etls': {
                                                'ETL-200': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2',
                                                    'container_memory': 2048
                                                }
                                            }
                                        },
                                        # SFN kicking off more ETLs than parallel_limit allows to execute at once
                                        'SP-21': {
                                            'parallel_limit': 2,
                                            'etls': {
                                                'ETL-201-1': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-1',
                                                    'container_memory': 2048
                                                },
                                                'ETL-201-2': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-2',
                                                    'container_memory': 2048
                                                },
                                                'ETL-201-3': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-3',
                                                    'container_memory': 4096
                                                },
                                                'ETL-201-4': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-4',
                                                    'container_memory': 2048
                                                },
                                                'ETL-201-5': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-5',
                                                    'container_memory': 2048
                                                }
                                            }
                                        },
                                        # SFN kicking off 1 ETL with multiple "next_step_functions"
                                        'SP-22': {
                                            'etls': {
                                                'ETL-202': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2',
                                                    'container_memory': 2048,
                                                    'next_step_functions': ['SP-23', 'SP-24']
                                                }
                                            }
                                        },
                                        # SPs 23 and 24 only exist so SP-11 and SP-22 don't throw an error b/c of missing "next_step_functions"
                                        'SP-23': {
                                            'etls': {
                                                'ETL-203': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2',
                                                    'container_memory': 2048
                                                }
                                            }
                                        },
                                        'SP-24': {
                                            'etls': {
                                                'ETL-204': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2',
                                                    'container_memory': 2048
                                                }
                                            }
                                        },
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })
        self.state_machines = generate_all_state_machines(data_warehouse_metadata, [])

    def test_sfn_with_one_etl_starts_at_that_etl(self):
        self.assertEqual('ETL-100', self.state_machines['SP-10']['StartAt'])
        self.assertTrue('ETL-100' in self.state_machines['SP-10']['States'])

    def test_etl_with_no_next_step_functions_is_terminal_with_no_next_state(self):
        self.assertTaskStateEquals(
            expected_etl_name='ETL-200',
            expected_ecs_memory=2048,
            expected_next_state=None,
            expected_resource_suffix='.sync',
            expect_to_have_end=True,
            null_result_path=False,
            actual_state=self.state_machines['SP-20']['States']['ETL-200']
        )

    def test_etl_with_any_next_step_functions_is_non_terminal_and_points_to_load_type_choice_state_next(self):
        self.assertTaskStateEquals(
            expected_etl_name='ETL-100',
            expected_ecs_memory=2048,
            expected_next_state='Load_type_choice',
            expected_resource_suffix='.waitForTaskToken',
            expect_to_have_end=False,
            null_result_path=False,
            actual_state=self.state_machines['SP-10']['States']['ETL-100']
        )

    def test_etl_with_1_next_step_function_has_choice_state_going_directly_to_message_state_which_triggers_the_step_function(self):
        self.assertChoiceStateEquals(
            expected_next_state_name='SP-20_message',
            actual_state=self.state_machines['SP-10']['States']['Load_type_choice']
        )
        self.assertHasSuccessState(self.state_machines['SP-10'])
        self.assertMessageStateEquals(
            expected_target_table='table2',
            expected_step_function_name='SP-20',
            actual_state=self.state_machines['SP-10']['States']['SP-20_message']
        )

    def test_sfn_with_multiple_etls_starts_at_a_parallel_step_which_triggers_all_etls(self):
        self.assertEqual('StartAt_Parallel', self.state_machines['SP-11']['StartAt'])
        self.assertEqual('Parallel', self.state_machines['SP-11']['States']['StartAt_Parallel']['Type'])
        self.assertTrue(self.state_machines['SP-11']['States']['StartAt_Parallel']['End'])
        self.assertEqual('ETL-101', self.state_machines['SP-11']['States']['StartAt_Parallel']['Branches'][0]['StartAt'])
        self.assertEqual('ETL-102', self.state_machines['SP-11']['States']['StartAt_Parallel']['Branches'][1]['StartAt'])
        self.assertTaskStateEquals(
            expected_etl_name='ETL-101',
            expected_ecs_memory=4096,
            expected_next_state='Load_type_choice',
            expected_resource_suffix='.waitForTaskToken',
            expect_to_have_end=False,
            null_result_path=False,
            actual_state=self.state_machines['SP-11']['States']['StartAt_Parallel']['Branches'][0]['States']['ETL-101']
        )
        self.assertTaskStateEquals(
            expected_etl_name='ETL-102',
            expected_ecs_memory=2048,
            expected_next_state='Load_type_choice_1',
            expected_resource_suffix='.waitForTaskToken',
            expect_to_have_end=False,
            null_result_path=False,
            actual_state=self.state_machines['SP-11']['States']['StartAt_Parallel']['Branches'][1]['States']['ETL-102']
        )

    def test_sfn_with_1_etl_and_multiple_next_step_functions_kicks_off_a_parallel_state_triggering_all_message_states(self):
        self.assertChoiceStateEquals(
            expected_next_state_name='ETL-202_Next_Step_Functions',
            actual_state=self.state_machines['SP-22']['States']['Load_type_choice']
        )
        self.assertHasSuccessState(self.state_machines['SP-22'])
        self.assertEqual('Parallel', self.state_machines['SP-22']['States']['ETL-202_Next_Step_Functions']['Type'])
        self.assertTrue(self.state_machines['SP-22']['States']['ETL-202_Next_Step_Functions']['End'])
        self.assertEqual('SP-23_message',
                         self.state_machines['SP-22']['States']['ETL-202_Next_Step_Functions']['Branches'][0]['StartAt'])
        self.assertEqual('SP-24_message',
                         self.state_machines['SP-22']['States']['ETL-202_Next_Step_Functions']['Branches'][1]['StartAt'])
        self.assertMessageStateEquals(
            expected_target_table='table2',
            expected_step_function_name='SP-23',
            actual_state=self.state_machines['SP-22']['States']['ETL-202_Next_Step_Functions']['Branches'][0]['States']['SP-23_message']
        )
        self.assertMessageStateEquals(
            expected_target_table='table2',
            expected_step_function_name='SP-24',
            actual_state=self.state_machines['SP-22']['States']['ETL-202_Next_Step_Functions']['Branches'][1]['States']['SP-24_message']
        )

    def test_sfn_with_multiple_etls_and_multiple_next_step_functions_kicks_off_a_parallel_state_triggering_all_message_states(self):
        etl101 = self.state_machines['SP-11']['States']['StartAt_Parallel']['Branches'][0]
        self.assertChoiceStateEquals(
            expected_next_state_name='ETL-101_Next_Step_Functions',
            actual_state=etl101['States']['Load_type_choice']
        )
        self.assertHasSuccessState(etl101)
        self.assertEqual('Parallel', etl101['States']['ETL-101_Next_Step_Functions']['Type'])
        self.assertTrue(etl101['States']['ETL-101_Next_Step_Functions']['End'])
        self.assertEqual('SP-21_message', etl101['States']['ETL-101_Next_Step_Functions']['Branches'][0]['StartAt'])
        self.assertEqual('SP-22_message', etl101['States']['ETL-101_Next_Step_Functions']['Branches'][1]['StartAt'])
        self.assertMessageStateEquals(
            expected_target_table='table2',
            expected_step_function_name='SP-21',
            actual_state=etl101['States']['ETL-101_Next_Step_Functions']['Branches'][0]['States']['SP-21_message']
        )
        self.assertMessageStateEquals(
            expected_target_table='table2',
            expected_step_function_name='SP-22',
            actual_state=etl101['States']['ETL-101_Next_Step_Functions']['Branches'][1]['States']['SP-22_message']
        )

    def test_duplicate_message_state_name_is_suffixed_to_ensure_uniqueness(self):
        etl102 = self.state_machines['SP-11']['States']['StartAt_Parallel']['Branches'][1]
        self.assertMessageStateEquals(
            expected_target_table='table2',
            expected_step_function_name='SP-22',
            actual_state=etl102['States']['ETL-102_Next_Step_Functions']['Branches'][0]['States']['SP-22_message_1']
        )

    def test_sfn_with_more_etls_than_its_parallel_limit_splits_etls_into_parallel_groups_that_each_run_in_series(self):
        # SP-21 triggers 5 ETLs but has a parallel limit of 2, so there should be 2 parallel tracks of 3 and 2 sequential ETLs, respectively
        #
        #    StartAtParallel
        #   /               \
        #  1                 2
        #  3                 4
        #  5
        self.assertEqual('StartAt_Parallel', self.state_machines['SP-21']['StartAt'])
        self.assertEqual('Parallel', self.state_machines['SP-21']['States']['StartAt_Parallel']['Type'])
        self.assertTrue(self.state_machines['SP-21']['States']['StartAt_Parallel']['End'])
        self.assertEqual(2, len(self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches']))
        self.assertEqual('ETL-201-1', self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches'][0]['StartAt'])
        self.assertEqual('ETL-201-2', self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches'][1]['StartAt'])
        self.assertTaskStateEquals(
            expected_etl_name='ETL-201-1',
            expected_ecs_memory=2048,
            expected_next_state='ETL-201-3',
            expected_resource_suffix='.waitForTaskToken',
            expect_to_have_end=False,
            null_result_path=True,
            actual_state=self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches'][0]['States']['ETL-201-1']
        )
        self.assertTaskStateEquals(
            expected_etl_name='ETL-201-2',
            expected_ecs_memory=2048,
            expected_next_state='ETL-201-4',
            expected_resource_suffix='.waitForTaskToken',
            expect_to_have_end=False,
            null_result_path=True,
            actual_state=self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches'][1]['States']['ETL-201-2']
        )
        self.assertTaskStateEquals(
            expected_etl_name='ETL-201-3',
            expected_ecs_memory=4096,
            expected_next_state='ETL-201-5',
            expected_resource_suffix='.waitForTaskToken',
            expect_to_have_end=False,
            null_result_path=True,
            actual_state=self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches'][0]['States']['ETL-201-3']
        )
        self.assertTaskStateEquals(  # group 2 terminal state
            expected_etl_name='ETL-201-4',
            expected_ecs_memory=2048,
            expected_next_state=None,
            expected_resource_suffix='.sync',
            expect_to_have_end=True,
            null_result_path=True,
            actual_state=self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches'][1]['States']['ETL-201-4']
        )
        self.assertTaskStateEquals(  # group 1 terminal state
            expected_etl_name='ETL-201-5',
            expected_ecs_memory=2048,
            expected_next_state=None,
            expected_resource_suffix='.sync',
            expect_to_have_end=True,
            null_result_path=True,
            actual_state=self.state_machines['SP-21']['States']['StartAt_Parallel']['Branches'][0]['States']['ETL-201-5']
        )

    def test_throws_error_if_ETL_points_to_nonexistent_next_step_function(self):
        data_warehouse_metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'dw',
            'databases': [
                {
                    'name': 'db1',
                    'schemas': [
                        {
                            'name': 'sch1',
                            'tables': [
                                {
                                    'name': 'table1',
                                    'primary_source_table': 'db1.sch1.table0',
                                    'step_functions': {
                                        'SP-10': {
                                            'etls': {
                                                'ETL-100': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table1',
                                                    'container_memory': 2048,
                                                    # SP-20 not defined anywhere in the overall metadata
                                                    'next_step_functions': ['SP-20']
                                                }
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })
        with self.assertRaises(ValueError):
            generate_all_state_machines(data_warehouse_metadata, [])

    def test_throws_error_if_latticed_etl_has_next_step_function(self):
        data_warehouse_metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'dw',
            'databases': [
                {
                    'name': 'db1',
                    'schemas': [
                        {
                            'name': 'sch1',
                            'tables': [
                                {
                                    'name': 'table2',
                                    'primary_source_table': 'db1.sch1.table1',
                                    'step_functions': {
                                        'SP-21': {
                                            'parallel_limit': 2,
                                            'etls': {
                                                'ETL-201-1': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-1',
                                                    'container_memory': 2048
                                                },
                                                'ETL-201-2': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-2',
                                                    'container_memory': 2048,
                                                    'next_step_functions': ['SP-22']
                                                },
                                                'ETL-201-3': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2-3',
                                                    'container_memory': 4096
                                                }
                                            }
                                        },
                                        # SFN kicking off 1 ETL with multiple "next_step_functions"
                                        'SP-22': {
                                            'etls': {
                                                'ETL-202': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'output_table': 'db1.sch1.table2',
                                                    'container_memory': 2048
                                                }
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })
        with self.assertRaises(ValueError):
            generate_all_state_machines(data_warehouse_metadata, [])


class TestGroupStateMachinesGenerator(unittest.TestCase):

    def setUp(self):
        self.maxDiff = None
        self.dw_dict = \
            {
                'name': 'dw',
                'databases': [
                    {
                        'name': 'database_1',
                        'schemas': [
                            {
                                'name': 'schema_1',
                                'tables': [
                                    {
                                        'name': 'table_0',
                                        'primary_key': [
                                            'column_1'
                                        ],
                                        'columns': {
                                            'column_1': {
                                                'data_type': 'TEXT'
                                            },
                                            'column_2': {
                                                'data_type': 'INT'
                                            }
                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'schema_2',
                                'tables': [
                                    {
                                        'name': 'table_1',
                                        'primary_source_table': 'database_1.schema_1.table_0',
                                        'primary_key': [
                                            'column_1'
                                        ],
                                        'columns': {
                                            'column_1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.column_1'
                                                }
                                            }
                                        },
                                        'step_functions': {
                                            'SP-1': {
                                                'etls': {
                                                    'ETL-1': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert',
                                                        'output_table': 'database_1.schema_2.table_1',
                                                        'json_output_field': 'column_1',
                                                        'truncate_table': False,
                                                        'container_memory': 2048,
                                                        'input_sql': 'SQL for ETL-1'
                                                    }
                                                }
                                            }
                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'schema_3',
                                'tables': [
                                    {
                                        'name': 'table_2',
                                        'primary_source_table': 'database_1.schema_2.table_1',
                                        'primary_key': [
                                            'column_1'
                                        ],
                                        'columns': {
                                            'column_1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.column_1'
                                                }
                                            }
                                        },
                                        'step_functions': {
                                            'SP-2': {
                                                'etls': {
                                                    'ETL-2': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update',
                                                        'output_table': 'database_1.schema_3.table_2',
                                                        'json_output_field': 'column_1',
                                                        'insert_update_keys': ['column_1'],
                                                        'container_memory': 2048,
                                                        'next_step_functions': ['SP-3'],
                                                        'input_sql': 'SQL for ETL-2'
                                                    }
                                                }
                                            }
                                        },
                                    },
                                    {
                                        'name': 'table_3',
                                        'primary_source_table': 'database_1.schema_3.table_2',
                                        'primary_key': [
                                            'column_1'
                                        ],
                                        'columns': {
                                            'column_1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.column_1'
                                                }
                                            }
                                        },
                                        'step_functions': {
                                            'SP-3': {
                                                'etls': {
                                                    'ETL-3': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update',
                                                        'output_table': 'database_1.schema_3.table_3',
                                                        'json_output_field': 'column_1',
                                                        'insert_update_keys': ['column_1'],
                                                        'container_memory': 4096,
                                                        'next_step_functions': ['SP-4', 'SP-5'],
                                                        'input_sql': 'SQL for ETL-3'
                                                    }
                                                }
                                            }
                                        },
                                    },
                                    {
                                        'name': 'table_4',
                                        'primary_source_table': 'database_1.schema_3.table_3',
                                        'primary_key': [
                                            'column_1'
                                        ],
                                        'columns': {
                                            'column_1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.column_1'
                                                }
                                            }
                                        },
                                        'step_functions': {
                                            'SP-4': {
                                                'etls': {
                                                    'SP-4': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update',
                                                        'output_table': 'database_1.schema_3.table_4',
                                                        'json_output_field': 'column_1',
                                                        'insert_update_keys': ['column_1'],
                                                        'container_memory': 2048,
                                                        'input_sql': 'SQL for SP-4'
                                                    }
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table_5',
                                        'primary_source_table': 'database_1.schema_3.table_3',
                                        'primary_key': [
                                            'column_1'
                                        ],
                                        'columns': {
                                            'column_1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.column_1'
                                                }
                                            }
                                        },
                                        'step_functions': {
                                            'SP-5': {
                                                'etls': {
                                                    'ETL-5': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'delete',
                                                        'output_table': 'database_1.schema_3.table_5',
                                                        'json_output_field': 'column_1',
                                                        'delete_keys': ['column_1'],
                                                        'container_memory': 2048,
                                                        'input_sql': 'SQL for ETL-5'
                                                    }
                                                }
                                            }
                                        }
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        self.data_warehouse_metadata = construct_data_warehouse_metadata_from_dict(self.dw_dict)

    def test_generate_various_group_step_function_configurations(self):
        group_state_machines = [
            GroupStateMachineGenerator(lambda x: x, 1, 'SP-GROUP-A', 'Trigger all ETLs - group limit 1'),
            GroupStateMachineGenerator(lambda x: not x.etls_have_next_step_functions, 2, 'SP-GROUP-B',
                                       'Trigger all standalone ETLs - group limit 2'),
            GroupStateMachineGenerator(lambda x: x.primary_target_table.schema == 'schema_3', 5, 'SP-GROUP-C',
                                       'Trigger all schema_3 ETLs - group limit 5')
        ]

        state_machines_result = generate_all_state_machines(self.data_warehouse_metadata, group_state_machines)
        # state_machines_result includes entries for five ETL state machines that we don't care about for this test
        # so we'll manually remove those entries here
        unwanted_keys = ['SP-1', 'SP-2', 'SP-3', 'SP-4', 'SP-5']
        for unwanted_key in unwanted_keys:
            state_machines_result.pop(unwanted_key)
        state_machines_expected = {
            "SP-GROUP-A-1": {
                "Comment": "Trigger all ETLs - group limit 1 - group 1",
                "StartAt": "SP-GROUP-A-1",
                "States": {
                    "SP-GROUP-A-1": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-1",
                                "StartAt": "SP-1_message",
                                "States": {
                                    "SP-1_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_1",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-1"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-1_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }
                }
            },
            "SP-GROUP-A-2": {
                "Comment": "Trigger all ETLs - group limit 1 - group 2",
                "StartAt": "SP-GROUP-A-2",
                "States": {
                    "SP-GROUP-A-2": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-2",
                                "StartAt": "SP-2_message",
                                "States": {
                                    "SP-2_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_2",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-2"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-2_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }
                }
            },
            "SP-GROUP-A-3": {
                "Comment": "Trigger all ETLs - group limit 1 - group 3",
                "StartAt": "SP-GROUP-A-3",
                "States": {
                    "SP-GROUP-A-3": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-3",
                                "StartAt": "SP-3_message",
                                "States": {
                                    "SP-3_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_3",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-3"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-3_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }
                }
            },
            "SP-GROUP-A-4": {
                "Comment": "Trigger all ETLs - group limit 1 - group 4",
                "StartAt": "SP-GROUP-A-4",
                "States": {
                    "SP-GROUP-A-4": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-4",
                                "StartAt": "SP-4_message",
                                "States": {
                                    "SP-4_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_4",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-4"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-4_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }
                }
            },
            "SP-GROUP-A-5": {
                "Comment": "Trigger all ETLs - group limit 1 - group 5",
                "StartAt": "SP-GROUP-A-5",
                "States": {
                    "SP-GROUP-A-5": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-5",
                                "StartAt": "SP-5_message",
                                "States": {
                                    "SP-5_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_5",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-5"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-5_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }
                }
            },
            "SP-GROUP-B-1": {
                "Comment": "Trigger all standalone ETLs - group limit 2 - group 1",
                "StartAt": "SP-GROUP-B-1",
                "States": {
                    "SP-GROUP-B-1": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-1",
                                "StartAt": "SP-1_message",
                                "States": {
                                    "SP-1_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_1",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-1"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-1_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            },
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-4",
                                "StartAt": "SP-4_message",
                                "States": {
                                    "SP-4_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_4",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-4"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-4_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }

                }
            },
            "SP-GROUP-B-2": {
                "Comment": "Trigger all standalone ETLs - group limit 2 - group 2",
                "StartAt": "SP-GROUP-B-2",
                "States": {
                    "SP-GROUP-B-2": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-5",
                                "StartAt": "SP-5_message",
                                "States": {
                                    "SP-5_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_5",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-5"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-5_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }
                }
            },
            'SP-GROUP-C': {
                "Comment": "Trigger all schema_3 ETLs - group limit 5",
                "StartAt": "SP-GROUP-C",
                "States": {
                    "SP-GROUP-C": {
                        "Type": "Parallel",
                        "End": True,
                        "Branches": [
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-2",
                                "StartAt": "SP-2_message",
                                "States": {
                                    "SP-2_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_2",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-2"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-2_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            },
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-3",
                                "StartAt": "SP-3_message",
                                "States": {
                                    "SP-3_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_3",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-3"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-3_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            },
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-4",
                                "StartAt": "SP-4_message",
                                "States": {
                                    "SP-4_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_4",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-4"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-4_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            },
                            {
                                "Comment": "Send message to bi-managed-mdi-2-full-check-queue for SP-5",
                                "StartAt": "SP-5_message",
                                "States": {
                                    "SP-5_message": {
                                        "Type": "Task",
                                        "Resource": "arn:aws:states:::sqs:sendMessage",
                                        "Parameters": {
                                            "QueueUrl": "${fullCheckQueueUrl}",
                                            "MessageGroupId": "table_5",
                                            "MessageDeduplicationId.$": "States.Format('{}_{}', $$.State.Name, $$.State.EnteredTime)",
                                            "MessageAttributes": {
                                                "ProcessId": {
                                                    "DataType": "String",
                                                    "StringValue": "SP-5"
                                                }
                                            },
                                            "MessageBody.$": "States.JsonToString($)"
                                        },
                                        "ResultSelector": {
                                            "StateName": "SP-5_message",
                                            "HttpHeadersDate.$": "$.SdkHttpMetadata.HttpHeaders.Date"
                                        },
                                        "End": True
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        }
        self.assertEqual(state_machines_result, state_machines_expected)
