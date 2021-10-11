import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import StateMachineDefinitionMetadataComparisonFunctions


class TestStateMachineDefinitionMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'SP-1', 'state_machine_name': 'SP-1', 'state_machine_comment': 'State Machine for SP-1'},
            {'process_name': 'SP-2', 'state_machine_name': 'SP-2', 'state_machine_comment': 'State Machine for SP-2'},
            {'process_name': 'SP-3', 'state_machine_name': 'SP-3', 'state_machine_comment': 'State Machine for SP-3'}
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, StateMachineDefinitionMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
                                        'name': 'table1',
                                        'primary_source_table': 'staging.staging_octane.table1',
                                        'etls': {
                                            'SP-1': {
                                                'data_type': 'TEXT',
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                                'json_output_field': 't1_pid'
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2',
                                        'primary_source_table': 'staging.staging_octane.table2',
                                        'etls': {
                                            'SP-2': {
                                                'data_type': 'TEXT',
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                                'json_output_field': 't2_pid'
                                            }
                                        }
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
                                                'data_type': 'TEXT',
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                                'json_output_field': 't3_pid'
                                            }
                                        }
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        )

        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows([
            {'process_name': 'SP-1', 'state_machine_name': 'SP-1',
             'state_machine_comment': 'ETL to copy table1 data from staging_octane to history_octane'},
            {'process_name': 'SP-2', 'state_machine_name': 'SP-2',
             'state_machine_comment': 'ETL to copy table2 data from staging_octane to history_octane'},
            {'process_name': 'SP-3', 'state_machine_name': 'SP-3',
             'state_machine_comment': 'table -> table-insert ETL from ingress.ingress_schema_1.table3 to ingress.ingress_schema_2.table3'}
        ])
        self.assertEqual(expected, StateMachineDefinitionMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'state_machine_name': 'SP-1', 'state_machine_comment': 'State Machine for SP-1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'state_machine_name': 'SP-2', 'state_machine_comment': 'State Machine for SP-2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'state_machine_name': 'SP-3', 'state_machine_comment': 'State Machine for SP-3'})
        ]
        row_grouper = StateMachineDefinitionMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'state_machine_name': 'SP-1', 'state_machine_comment': 'State Machine for SP-1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'state_machine_name': 'SP-2', 'state_machine_comment': 'State Machine for SP-2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'state_machine_name': 'SP-3', 'state_machine_comment': 'State Machine for SP-3'})
        ]
        expected = "WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (\n" + \
                   "    VALUES ('SP-1', 'SP-1', 'State Machine for SP-1')\n" + \
                   "         , ('SP-2', 'SP-2', 'State Machine for SP-2')\n" + \
                   "         , ('SP-3', 'SP-3', 'State Machine for SP-3')\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.state_machine_definition (process_dwid, name, comment)\n" + \
                   "SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = insert_rows.process_name;"
        self.assertEqual(expected, StateMachineDefinitionMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'state_machine_name': 'SP-1', 'state_machine_comment': 'State Machine for SP-1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'state_machine_name': 'SP-2', 'state_machine_comment': 'State Machine for SP-2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'state_machine_name': 'SP-3', 'state_machine_comment': 'State Machine for SP-3'})
        ]
        expected = "WITH update_rows (process_name, state_machine_name, state_machine_comment) AS (\n" + \
                   "    VALUES ('SP-1', 'SP-1', 'State Machine for SP-1')\n" + \
                   "         , ('SP-2', 'SP-2', 'State Machine for SP-2')\n" + \
                   "         , ('SP-3', 'SP-3', 'State Machine for SP-3')\n" + \
                   ")\n" + \
                   "UPDATE mdi.state_machine_definition\n" + \
                   "SET name = update_rows.state_machine_name\n" + \
                   "  , comment = update_rows.state_machine_comment\n" + \
                   "FROM update_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = update_rows.process_name\n" + \
                   "WHERE process.dwid = state_machine_definition.process_dwid;"
        self.assertEqual(expected, StateMachineDefinitionMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'state_machine_name': 'SP-1', 'state_machine_comment': 'State Machine for SP-1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'state_machine_name': 'SP-2', 'state_machine_comment': 'State Machine for SP-2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'state_machine_name': 'SP-3', 'state_machine_comment': 'State Machine for SP-3'})
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('SP-1')\n" + \
                   "         , ('SP-2')\n" + \
                   "         , ('SP-3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.state_machine_definition\n" + \
                   "    USING delete_keys, mdi.process\n" + \
                   "WHERE state_machine_definition.process_dwid = process.dwid\n" + \
                   "  AND process.name = delete_keys.process_name;"
        self.assertEqual(expected, StateMachineDefinitionMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
