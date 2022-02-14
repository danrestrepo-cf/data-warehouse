import unittest
from lib.state_machines_generator.state_machines_generator import AllEtlStateMachinesGenerator


class TestSequentialOutputAndVaryingConfigAttributes(unittest.TestCase):

    def setUp(self):
        self.state_machine_metadata = {
            'SP-1': {
                'target_table': 'table_1',
                'container_memory': 2048,
                'comment': 'Comment 1',
                'next_processes': ['SP-2']
            },
            'SP-2': {
                'target_table': 'table_2',
                'container_memory': 2048,
                'comment': 'Comment 2',
                'next_processes': ['SP-3']
            },
            'SP-3': {
                'target_table': 'table_3',
                'container_memory': 4096,
                'comment': 'Comment 3',
                'next_processes': []
            }
        }

        self.result = AllEtlStateMachinesGenerator(self.state_machine_metadata).build_etl_state_machines()
        self.sp_1_config = self.result['SP-1']
        self.sp_2_config = self.result['SP-2']
        self.sp_3_config = self.result['SP-3']

    def test_sets_startat_to_root_process_name(self):
        self.assertEqual('SP-1', self.sp_1_config['StartAt'])

    def test_configures_next_and_end_attributes_correctly(self):
        self.assertEqual('Load_type_choice', self.sp_1_config['States']['SP-1']['Next'])
        self.assertEqual('SP-2_message', self.sp_1_config['States']['Load_type_choice']['Default'])
        self.assertTrue('End' not in self.sp_1_config['States']['SP-1'])
        self.assertTrue('End' in self.sp_1_config['States']['SP-2_message'])
        self.assertTrue('Next' not in self.sp_3_config['States']['SP-3'])
        self.assertTrue('End' in self.sp_3_config['States']['SP-3'])

    def test_configures_resource_suffix_correctly(self):
        self.assertEqual('arn:aws:states:::ecs:runTask.waitForTaskToken', self.sp_1_config['States']['SP-1']['Resource'])
        self.assertEqual('arn:aws:states:::ecs:runTask.waitForTaskToken', self.sp_2_config['States']['SP-2']['Resource'])
        self.assertEqual('arn:aws:states:::ecs:runTask.sync', self.sp_3_config['States']['SP-3']['Resource'])

    def test_throws_error_if_next_process_not_included_in_provided_metadata(self):
        invalid_state_machine_metadata = self.state_machine_metadata
        invalid_state_machine_metadata['SP-3']['next_processes'] = ['SP-4']
        with self.assertRaises(KeyError):
            AllEtlStateMachinesGenerator(invalid_state_machine_metadata).build_etl_state_machines()


class TestParallelOutputStructure(unittest.TestCase):

    def setUp(self):
        state_machine_metadata = {
            'SP-1': {
                'target_table': 'table_1',
                'container_memory': 2048,
                'comment': 'Comment 1',
                'next_processes': ['SP-2', 'SP-3']
            },
            'SP-2': {
                'target_table': 'table_2',
                'container_memory': 2048,
                'comment': 'Comment 2',
                'next_processes': []
            },
            'SP-3': {
                'target_table': 'table_3',
                'container_memory': 4096,
                'comment': 'Comment 3',
                'next_processes': []
            }
        }

        self.sp_1_config = AllEtlStateMachinesGenerator(state_machine_metadata).build_etl_state_machines()['SP-1']

    def test_sets_startat_to_root_process_name(self):
        self.assertEqual('SP-1', self.sp_1_config['StartAt'])

    def test_sets_first_state_next_pointer_to_parallel_state_name(self):
        self.assertEqual('Load_type_choice', self.sp_1_config['States']['SP-1']['Next'])
        self.assertEqual('Parallel', self.sp_1_config['States']['Load_type_choice']['Default'])

    def test_creates_parallel_state_in_top_level_states_list(self):
        self.assertEqual('Parallel', self.sp_1_config['States']['Parallel']['Type'])
        self.assertTrue(self.sp_1_config['States']['Parallel']['End'])
        self.assertEqual(2, len(self.sp_1_config['States']['Parallel']['Branches']))

    def test_populates_parallel_branches_with_message_states(self):
        sp_1_branches = self.sp_1_config['States']['Parallel']['Branches']
        self.assertEqual('SP-2_message', sp_1_branches[0]['StartAt'])
        self.assertEqual('SP-3_message', sp_1_branches[1]['StartAt'])
        self.assertEqual('Send message to bi-managed-mdi-2-full-check-queue for SP-2', sp_1_branches[0]['Comment'])
        self.assertEqual('Send message to bi-managed-mdi-2-full-check-queue for SP-3', sp_1_branches[1]['Comment'])
        self.assertEqual(1, len(sp_1_branches[0]['States']))
        self.assertEqual(1, len(sp_1_branches[1]['States']))
        self.assertTrue(sp_1_branches[0]['States']['SP-2_message']['End'])
        self.assertTrue(sp_1_branches[1]['States']['SP-3_message']['End'])
        self.assertEqual('arn:aws:states:::sqs:sendMessage', sp_1_branches[0]['States']['SP-2_message']['Resource'])
        self.assertEqual('arn:aws:states:::sqs:sendMessage', sp_1_branches[1]['States']['SP-3_message']['Resource'])

class TestEntireOutput(unittest.TestCase):

    def test_entire_output_dict(self):
        self.maxDiff = None
        state_machine_metadata = {
            'SP-1': {
                'target_table': 'table_1',
                'container_memory': 2048,
                'comment': 'Comment 1',
                'next_processes': []
            },
            'SP-2': {
                'target_table': 'table_2',
                'container_memory': 2048,
                'comment': 'Comment 2',
                'next_processes': ['SP-3']
            },
            'SP-3': {
                'target_table': 'table_3',
                'container_memory': 4096,
                'comment': 'Comment 3',
                'next_processes': ['SP-4', 'SP-5']
            },
            'SP-4': {
                'target_table': 'table_4',
                'container_memory': 2048,
                'comment': 'Comment 4',
                'next_processes': []
            },
            'SP-5': {
                'target_table': 'table_5',
                'container_memory': 4096,
                'comment': 'Comment 5',
                'next_processes': []
            }
        }

        sp_1_config_expected = {
            "Comment": "SP-1 - Comment 1",
            "StartAt": "SP-1",
            "States": {
                "SP-1": {
                    "Type": "Task",
                    "Resource": "arn:aws:states:::ecs:runTask.sync",
                    "Parameters": {
                        "LaunchType": "FARGATE",
                        "Cluster": "${ecsClusterARN}",
                        "TaskDefinition": "${mdi_2_arn}",
                        "NetworkConfiguration": {
                            "AwsvpcConfiguration": {
                                "AssignPublicIp": "DISABLED",
                                "SecurityGroups": [
                                    "${securityGroupId}"
                                ],
                                "Subnets": '${subnetIDs}'
                            }
                        },
                        "Overrides": {
                            "Memory": "2048",
                            "ContainerOverrides": [
                                {
                                    "Memory": 2048,
                                    "Environment": [
                                        {
                                            "Name": "PROCESS_NAME",
                                            "Value": "SP-1"
                                        },
                                        {
                                            "Name": "INPUT_DATA",
                                            "Value.$": "States.Format('\\{\"token_id\":\"{}\",\"mdi_input_json\":{}\\}', $$.Task.Token, States.JsonToString($))"
                                        },
                                        {
                                            "Name": "TOKEN_ID",
                                            "Value.$": "$$.Task.Token"
                                        }
                                    ],
                                    "Name": "${mdi_2_container}"
                                }
                            ]
                        }
                    },
                    "End": True
                }
            }
        }

        sp_2_config_expected = {
            "Comment": "SP-2 - Comment 2",
            "StartAt": "SP-2",
            "States": {
                "SP-2": {
                    "Type": "Task",
                    "Resource": "arn:aws:states:::ecs:runTask.waitForTaskToken",
                    "Parameters": {
                        "LaunchType": "FARGATE",
                        "Cluster": "${ecsClusterARN}",
                        "TaskDefinition": "${mdi_2_arn}",
                        "NetworkConfiguration": {
                            "AwsvpcConfiguration": {
                                "AssignPublicIp": "DISABLED",
                                "SecurityGroups": [
                                    "${securityGroupId}"
                                ],
                                "Subnets": '${subnetIDs}'
                            }
                        },
                        "Overrides": {
                            "Memory": "2048",
                            "ContainerOverrides": [
                                {
                                    "Memory": 2048,
                                    "Environment": [
                                        {
                                            "Name": "PROCESS_NAME",
                                            "Value": "SP-2"
                                        },
                                        {
                                            "Name": "INPUT_DATA",
                                            "Value.$": "States.Format('\\{\"token_id\":\"{}\",\"mdi_input_json\":{}\\}', $$.Task.Token, States.JsonToString($))"
                                        },
                                        {
                                            "Name": "TOKEN_ID",
                                            "Value.$": "$$.Task.Token"
                                        }
                                    ],
                                    "Name": "${mdi_2_container}"
                                }
                            ]
                        }
                    },
                    "Next": "Load_type_choice"
                },
                "Load_type_choice": {
                    "Type": "Choice",
                    "Choices": [
                        {
                            "Variable": "$.load_type",
                            "StringEquals": "NONE",
                            "Next": "Success"
                        }
                    ],
                    "Default": "SP-3_message"
                },
                "Success": {
                    "Type": "Succeed"
                },
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
                    "End": True
                }
            }
        }

        sp_3_config_expected = {
            "Comment": "SP-3 - Comment 3",
            "StartAt": "SP-3",
            "States": {
                "SP-3": {
                    "Type": "Task",
                    "Resource": "arn:aws:states:::ecs:runTask.waitForTaskToken",
                    "Parameters": {
                        "LaunchType": "FARGATE",
                        "Cluster": "${ecsClusterARN}",
                        "TaskDefinition": "${mdi_2_arn}",
                        "NetworkConfiguration": {
                            "AwsvpcConfiguration": {
                                "AssignPublicIp": "DISABLED",
                                "SecurityGroups": [
                                    "${securityGroupId}"
                                ],
                                "Subnets": '${subnetIDs}'
                            }
                        },
                        "Overrides": {
                            "Memory": "4096",
                            "ContainerOverrides": [
                                {
                                    "Memory": 4096,
                                    "Environment": [
                                        {
                                            "Name": "PROCESS_NAME",
                                            "Value": "SP-3"
                                        },
                                        {
                                            "Name": "INPUT_DATA",
                                            "Value.$": "States.Format('\\{\"token_id\":\"{}\",\"mdi_input_json\":{}\\}', $$.Task.Token, States.JsonToString($))"
                                        },
                                        {
                                            "Name": "TOKEN_ID",
                                            "Value.$": "$$.Task.Token"
                                        }
                                    ],
                                    "Name": "${mdi_2_container}"
                                }
                            ]
                        }
                    },
                    "Next": "Load_type_choice"
                },
                "Load_type_choice": {
                    "Type": "Choice",
                    "Choices": [
                        {
                            "Variable": "$.load_type",
                            "StringEquals": "NONE",
                            "Next": "Success"
                        }
                    ],
                    "Default": "Parallel"
                },
                "Success": {
                    "Type": "Succeed"
                },
                "Parallel": {
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
                                    "End": True
                                }
                            }
                        }
                    ]
                }
            }
        }

        result = AllEtlStateMachinesGenerator(state_machine_metadata).build_etl_state_machines()
        sp_1_config_result = result['SP-1']
        sp_2_config_result = result['SP-2']
        sp_3_config_result = result['SP-3']

        self.assertEqual(sp_1_config_expected, sp_1_config_result)
        self.assertEqual(sp_2_config_expected, sp_2_config_result)
        self.assertEqual(sp_3_config_expected, sp_3_config_result)


if __name__ == '__main__':
    unittest.main()
