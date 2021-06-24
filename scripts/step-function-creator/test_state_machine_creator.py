import unittest
from StateMachinesCreator import StateMachinesCreator


class TestSchedulesOutput(unittest.TestCase):

    def test_creates_well_formatted_schedules_config_string_that_can_be_written_to_a_file(self):
        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': '0/15 * * * ? *'},
            {'process_name': 'SP-2', 'state_machine_name': 'Octane__2', 'comment': 'comment 1', 'cron_schedule': '0/16 * * * ? *'},
            {'process_name': 'SP-3', 'state_machine_name': 'Octane__3', 'comment': 'comment 1', 'cron_schedule': '0/17 * * * ? *'}
        ]
        expected = 'locals {\n' + \
                   '  schedules = {\n' + \
                   '    "Octane__1.json" = "cron(0/15 * * * ? *)"\n' + \
                   '    "Octane__2.json" = "cron(0/16 * * * ? *)"\n' + \
                   '    "Octane__3.json" = "cron(0/17 * * * ? *)"\n' + \
                   '  }\n' + \
                   '}\n'
        result = StateMachinesCreator(state_machine_metadata, []).create_schedule_config_string()
        self.assertEqual(expected, result)

    def test_excludes_processes_from_the_schedule_if_their_chron_schedule_is_null(self):
        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': '0/15 * * * ? *'},
            {'process_name': 'SP-2', 'state_machine_name': 'Octane__2', 'comment': 'comment 1', 'cron_schedule': None},
        ]
        expected = 'locals {\n' + \
                   '  schedules = {\n' + \
                   '    "Octane__1.json" = "cron(0/15 * * * ? *)"\n' + \
                   '  }\n' + \
                   '}\n'
        result = StateMachinesCreator(state_machine_metadata, []).create_schedule_config_string()
        self.assertEqual(expected, result)


class TestCanDetectLoopInMetadata(unittest.TestCase):

    def test_throws_error_when_initialized_with_metadata_containing_a_loop(self):
        step_metadata = [
            {'process_name': 'SP-1', 'child_process_name': 'SP-2'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-3'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-4'},
            {'process_name': 'SP-3', 'child_process_name': 'SP-1'}
        ]

        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': '0/15 * * * ? *'}
        ]
        with self.assertRaises(StateMachinesCreator.InvalidMetadataError):
            StateMachinesCreator(state_machine_metadata, step_metadata)

    def test_doesnt_throw_error_when_metadata_contains_the_same_process_multiple_times_but_doesnt_loop(self):
        step_metadata = [
            {'process_name': 'SP-1', 'child_process_name': 'SP-2'},
            {'process_name': 'SP-1', 'child_process_name': 'SP-3'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-4'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-5'},
            {'process_name': 'SP-3', 'child_process_name': 'SP-4'}
        ]

        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': '0/15 * * * ? *'}
        ]
        StateMachinesCreator(state_machine_metadata, step_metadata)  # expect no error


class TestSequentialOutputAndVaryingConfigAttributes(unittest.TestCase):

    def setUp(self):
        step_metadata = [
            {'process_name': 'SP-1', 'child_process_name': 'SP-2'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-3'}
        ]

        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': 'cron(0/15 * * * ? *)'}
        ]

        self.result = StateMachinesCreator(state_machine_metadata, step_metadata).build_state_machines()['Octane__1']

    def test_sets_startat_to_root_process_name(self):
        self.assertEqual('SP-1', self.result['StartAt'])

    def test_configures_next_and_end_attributes_correctly(self):
        self.assertEqual('SP-2', self.result['States']['SP-1']['Next'])
        self.assertTrue('End' not in self.result['States']['SP-1'])
        self.assertEqual('SP-3', self.result['States']['SP-2']['Next'])
        self.assertTrue('End' not in self.result['States']['SP-2'])
        self.assertTrue(self.result['States']['SP-3']['End'])
        self.assertTrue('Next' not in self.result['States']['SP-3'])

    def test_configures_resource_suffix_correctly(self):
        self.assertEqual('arn:aws:states:::ecs:runTask.waitForTaskToken', self.result['States']['SP-1']['Resource'])
        self.assertEqual('arn:aws:states:::ecs:runTask.waitForTaskToken', self.result['States']['SP-2']['Resource'])
        self.assertEqual('arn:aws:states:::ecs:runTask.sync', self.result['States']['SP-3']['Resource'])


class TestParallelOutputStructure(unittest.TestCase):

    def setUp(self):
        step_metadata = [
            {'process_name': 'SP-1', 'child_process_name': 'SP-2'},
            {'process_name': 'SP-1', 'child_process_name': 'SP-3'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-4'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-5'}
        ]

        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': '0/15 * * * ? *'}
        ]

        self.result = StateMachinesCreator(state_machine_metadata, step_metadata).build_state_machines()['Octane__1']

    def test_sets_startat_to_root_process_name(self):
        self.assertEqual('SP-1', self.result['StartAt'])

    def test_sets_first_state_next_pointer_to_hashed_parallel_state_name(self):
        self.assertEqual('parallel', self.result['States']['SP-1']['Next'])

    def test_creates_parallel_state_in_top_level_states_list(self):
        self.assertEqual('Parallel', self.result['States']['parallel']['Type'])
        self.assertTrue(self.result['States']['parallel']['End'])
        self.assertEqual(2, len(self.result['States']['parallel']['Branches']))

    def test_populates_parallel_branches_with_top_level_style_state_machine_configs(self):
        self.assertEqual('SP-2', self.result['States']['parallel']['Branches'][0]['StartAt'])
        self.assertEqual('SP-3', self.result['States']['parallel']['Branches'][1]['StartAt'])
        self.assertEqual(1, len(self.result['States']['parallel']['Branches'][1]['States']))
        self.assertTrue('SP-2' in self.result['States']['parallel']['Branches'][0]['States'])
        self.assertTrue('parallel_1' in self.result['States']['parallel']['Branches'][0]['States'])
        nested_parallel_state = self.result['States']['parallel']['Branches'][0]['States']['parallel_1']
        self.assertEqual('SP-4', nested_parallel_state['Branches'][0]['StartAt'])
        self.assertEqual('SP-5', nested_parallel_state['Branches'][1]['StartAt'])


class TestGeneratesUniqueStateNamesWhenStatesAppearMultipleTimes(unittest.TestCase):

    def setUp(self):
        # SP-1 -> [SP-2,SP-3,SP-4,SP-5]
        # SP-2 -> SP-6
        # SP-3 -> SP-6
        # SP-4 -> SP-6
        # SP-5 -> SP-7
        # SP-6 -> [SP-7,SP-8]
        step_metadata = [
            {'process_name': 'SP-1', 'child_process_name': 'SP-2'},
            {'process_name': 'SP-1', 'child_process_name': 'SP-3'},
            {'process_name': 'SP-1', 'child_process_name': 'SP-4'},
            {'process_name': 'SP-1', 'child_process_name': 'SP-5'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-6'},
            {'process_name': 'SP-3', 'child_process_name': 'SP-6'},
            {'process_name': 'SP-4', 'child_process_name': 'SP-6'},
            {'process_name': 'SP-5', 'child_process_name': 'SP-7'},
            {'process_name': 'SP-6', 'child_process_name': 'SP-7'},
            {'process_name': 'SP-6', 'child_process_name': 'SP-8'}
        ]

        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': '0/15 * * * ? *'}
        ]
        self.result = StateMachinesCreator(state_machine_metadata, step_metadata).build_state_machines()

    def test_adds_auto_incrementing_integer_suffix_to_repeated_non_parallel_state_names(self):
        self.assertTrue('SP-6' in self.result['Octane__1']['States']['parallel']['Branches'][0]['States'])
        self.assertTrue('SP-6_1' in self.result['Octane__1']['States']['parallel']['Branches'][1]['States'])
        self.assertTrue('SP-6_2' in self.result['Octane__1']['States']['parallel']['Branches'][2]['States'])

    def test_adds_auto_incrementing_integer_suffix_to_repeated_parallel_state_names(self):
        self.assertTrue('parallel_1' in self.result['Octane__1']['States']['parallel']['Branches'][0]['States'])
        self.assertTrue('parallel_2' in self.result['Octane__1']['States']['parallel']['Branches'][1]['States'])
        self.assertTrue('parallel_3' in self.result['Octane__1']['States']['parallel']['Branches'][2]['States'])

    def test_adds_correct_unique_state_name_to_parallel_step_header(self):
        nested_parallel_step = self.result['Octane__1']['States']['parallel']['Branches'][2]['States']['parallel_3']
        self.assertEqual('Parallel - SP-7_2', nested_parallel_step['Branches'][0]['Comment'])
        self.assertEqual('SP-7_2', nested_parallel_step['Branches'][0]['StartAt'])


class TestEntireOutput(unittest.TestCase):

    def test_entire_output_dict(self):
        step_metadata = [
            {'process_name': 'SP-1', 'child_process_name': 'SP-2'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-3'},
            {'process_name': 'SP-2', 'child_process_name': 'SP-4'}
        ]

        state_machine_metadata = [
            {'process_name': 'SP-1', 'state_machine_name': 'Octane__1', 'comment': 'comment 1', 'cron_schedule': '0/15 * * * ? *'}
        ]

        expected = {
            'Comment': 'Octane__1 - comment 1',
            'StartAt': 'SP-1',
            'States': {
                'SP-1': {
                    'Type': 'Task',
                    'Resource': 'arn:aws:states:::ecs:runTask.waitForTaskToken',
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
                                            'Value': 'SP-1'
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
                    'Next': 'SP-2'
                },
                'SP-2': {
                    'Type': 'Task',
                    'Resource': 'arn:aws:states:::ecs:runTask.waitForTaskToken',
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
                                            'Value': 'SP-2'
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
                    'Next': 'parallel'
                },
                'parallel': {
                    'Type': 'Parallel',
                    'End': True,
                    'Branches': [
                        {
                            'Comment': 'Parallel - SP-3',
                            'StartAt': 'SP-3',
                            'States': {
                                'SP-3': {
                                    'Type': 'Task',
                                    'Resource': 'arn:aws:states:::ecs:runTask.sync',
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
                                                            'Value': 'SP-3'
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
                                    'End': True
                                }
                            }
                        },
                        {
                            'Comment': 'Parallel - SP-4',
                            'StartAt': 'SP-4',
                            'States': {
                                'SP-4': {
                                    'Type': 'Task',
                                    'Resource': 'arn:aws:states:::ecs:runTask.sync',
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
                                                            'Value': 'SP-4'
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
                                    'End': True
                                }
                            }
                        }
                    ]
                }
            }
        }

        result = StateMachinesCreator(state_machine_metadata, step_metadata).build_state_machines()['Octane__1']
        self.assertEqual(expected, result)


if __name__ == '__main__':
    unittest.main()
