import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import TableOutputStepMetadataComparisonFunctions


class TestTableOutputStepMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'SP-1', 'target_schema': 'history_octane', 'target_table': 'table1', 'truncate_table': 'N',
             'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-2', 'target_schema': 'history_octane', 'target_table': 'table2', 'truncate_table': 'N',
             'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-3', 'target_schema': 'history_octane', 'target_table': 'table3', 'truncate_table': 'N',
             'connectionname': 'Staging DB Connection'},
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, TableOutputStepMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                                'truncate_table': True
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2',
                                        'primary_source_table': 'staging.staging_octane.table2',
                                        'etls': {
                                            'SP-2': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                                'truncate_table': False
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
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                                'truncate_table': False
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
            {'process_name': 'SP-1', 'target_schema': 'history_octane', 'target_table': 'table1', 'truncate_table': 'Y',
             'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-2', 'target_schema': 'history_octane', 'target_table': 'table2', 'truncate_table': 'N',
             'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-3', 'target_schema': 'ingress_schema_2', 'target_table': 'table3', 'truncate_table': 'N',
             'connectionname': 'Ingress DB Connection'},
        ])
        self.assertEqual(expected, TableOutputStepMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table1', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table2', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table3', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'})
        ]
        row_grouper = TableOutputStepMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table1', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table2', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table3', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'})
        ]
        expected = "WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (\n" + \
                   "    VALUES ('SP-1', 'history_octane', 'table1', 'Y', 'Staging DB Connection')\n" + \
                   "         , ('SP-2', 'history_octane', 'table2', 'Y', 'Staging DB Connection')\n" + \
                   "         , ('SP-3', 'history_octane', 'table3', 'Y', 'Staging DB Connection')\n" + \
                   ")\n" + \
                   "INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)\n" + \
                   "SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "ON process.name = insert_rows.process_name;"
        self.assertEqual(expected, TableOutputStepMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table1', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table2', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table3', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'})
        ]
        expected = "WITH update_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (\n" + \
                   "    VALUES ('SP-1', 'history_octane', 'table1', 'Y', 'Staging DB Connection')\n" + \
                   "         , ('SP-2', 'history_octane', 'table2', 'Y', 'Staging DB Connection')\n" + \
                   "         , ('SP-3', 'history_octane', 'table3', 'Y', 'Staging DB Connection')\n" + \
                   ")\n" + \
                   "UPDATE mdi.table_output_step\n" + \
                   "SET target_schema = update_rows.target_schema\n" + \
                   "  , target_table = update_rows.target_table\n" + \
                   "  , truncate_table = update_rows.truncate_table::mdi.pentaho_y_or_n\n" + \
                   "  , connectionname = update_rows.connectionname\n" + \
                   "FROM update_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = update_rows.process_name\n" + \
                   "WHERE process.dwid = table_output_step.process_dwid;"
        self.assertEqual(expected, TableOutputStepMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table1', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table2', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'target_schema': 'history_octane', 'target_table': 'table3', 'truncate_table': 'Y',
                            'connectionname': 'Staging DB Connection'})
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('SP-1')\n" + \
                   "         , ('SP-2')\n" + \
                   "         , ('SP-3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.table_output_step\n" + \
                   "    USING delete_keys, mdi.process\n" + \
                   "WHERE table_output_step.process_dwid = process.dwid\n" + \
                   "  AND process.name = delete_keys.process_name;"
        self.assertEqual(expected, TableOutputStepMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
