import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import StateMachineStepMetadataComparisonFunctions


class TestStateMachineStepMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'SP-1', 'next_process_name': 'SP-10'},
            {'process_name': 'SP-2', 'next_process_name': 'SP-20'},
            {'process_name': 'SP-3', 'next_process_name': 'SP-30'}
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name', 'next_process_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, StateMachineStepMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

    def test_construct_metadata_table_from_source(self):
        dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'staging',
                        'schemas': [
                            {
                                'name': 'history_octane',
                                'tables': [
                                    {
                                        'name': 'table0',
                                        'primary_source_table': 'staging.staging_octane.table1',
                                        'etls': {
                                            'SP-0': {
                                                'data_type': 'TEXT',
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert'
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table1',
                                        'primary_source_table': 'staging.staging_octane.table2',
                                        'etls': {
                                            'SP-1': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert'
                                            },
                                            'SP-2': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert'
                                            }
                                        },
                                        'next_etls': [
                                            'SP-10',
                                            'SP-20'
                                        ]
                                    }
                                ]
                            }
                        ]
                    },
                    {
                        'name': 'ingress',
                        'schemas': [
                            {
                                'name': 'ingress_schema_2',
                                'tables': [
                                    {
                                        'name': 'table3',
                                        'primary_source_table': 'ingress.ingress_schema_1.table3',
                                        'etls': {
                                            'SP-3': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                            }
                                        },
                                        'next_etls': [
                                            'SP-30'
                                        ]
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        )

        expected = MetadataTable(key_fields=['process_name', 'next_process_name'])
        expected.add_rows([
            {'process_name': 'SP-1', 'next_process_name': 'SP-10'},
            {'process_name': 'SP-1', 'next_process_name': 'SP-20'},
            {'process_name': 'SP-2', 'next_process_name': 'SP-10'},
            {'process_name': 'SP-2', 'next_process_name': 'SP-20'},
            {'process_name': 'SP-3', 'next_process_name': 'SP-30'}
        ])
        self.assertEqual(expected, StateMachineStepMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_dependency_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'next_process_name': 'SP-10'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'next_process_name': 'SP-20'}, attributes={}),
            Row(key={'process_name': 'SP-3', 'next_process_name': 'SP-30'}, attributes={})
        ]
        row_grouper = StateMachineStepMetadataComparisonFunctions().construct_dependency_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'next_process_name': 'SP-10'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'next_process_name': 'SP-20'}, attributes={}),
            Row(key={'process_name': 'SP-3', 'next_process_name': 'SP-30'}, attributes={})
        ]
        expected = "WITH insert_rows (process_name, next_process_name) AS (\n" + \
                   "    VALUES ('SP-1', 'SP-10')\n" + \
                   "         , ('SP-2', 'SP-20')\n" + \
                   "         , ('SP-3', 'SP-30')\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.state_machine_step (process_dwid, next_process_dwid)\n" + \
                   "SELECT process.dwid, next_process.dwid\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = insert_rows.process_name\n" + \
                   "JOIN mdi.process next_process\n" + \
                   "     ON next_process.name = insert_rows.next_process_name;"
        self.assertEqual(expected, StateMachineStepMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'next_process_name': 'SP-10'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'next_process_name': 'SP-20'}, attributes={}),
            Row(key={'process_name': 'SP-3', 'next_process_name': 'SP-30'}, attributes={})
        ]
        expected = ''
        self.assertEqual(expected, StateMachineStepMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'next_process_name': 'SP-10'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'next_process_name': 'SP-20'}, attributes={}),
            Row(key={'process_name': 'SP-3', 'next_process_name': 'SP-30'}, attributes={})
        ]
        expected = "WITH delete_keys (process_name, next_process_name) AS (\n" + \
                   "    VALUES ('SP-1', 'SP-10')\n" + \
                   "         , ('SP-2', 'SP-20')\n" + \
                   "         , ('SP-3', 'SP-30')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.state_machine_step\n" + \
                   "    USING delete_keys, mdi.process, mdi.process next_process\n" + \
                   "WHERE state_machine_step.process_dwid = process.dwid\n" + \
                   "  AND state_machine_step.next_process_dwid = next_process.dwid\n" + \
                   "  AND delete_keys.process_name = process.name\n" + \
                   "  AND delete_keys.next_process_name = next_process.name;"
        self.assertEqual(expected, StateMachineStepMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
