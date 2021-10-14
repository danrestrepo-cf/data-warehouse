import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import TableInputStepMetadataComparisonFunctions


class TestTableInputStepMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'SP-1', 'data_source_dwid': 1, 'sql': 'SQL for SP-1', 'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-2', 'data_source_dwid': 1, 'sql': 'SQL for SP-2', 'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-3', 'data_source_dwid': 1, 'sql': 'SQL for SP-3', 'connectionname': 'Staging DB Connection'}
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, TableInputStepMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
                                                'input_sql': 'SQL for SP-1'
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
                                                'input_sql': 'SQL for SP-2'
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
                                                'input_sql': 'SQL for SP-3'
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
            {'process_name': 'SP-1', 'data_source_dwid': 1, 'sql': 'SQL for SP-1', 'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-2', 'data_source_dwid': 1, 'sql': 'SQL for SP-2', 'connectionname': 'Staging DB Connection'},
            {'process_name': 'SP-3', 'data_source_dwid': 1, 'sql': 'SQL for SP-3', 'connectionname': 'Ingress DB Connection'}
        ])
        self.assertEqual(expected, TableInputStepMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_throws_error_if_database_name_cannot_be_converted_to_valid_pentaho_connection_name(self):
        dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'other_db',
                        'schemas': [
                            {
                                'name': 'schema1',
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
                                                'input_sql': 'SQL for SP-1'
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
        with self.assertRaises(ValueError):
            TableInputStepMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata)

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-1', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-2', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-3', 'connectionname': 'Staging DB Connection'}),
        ]
        row_grouper = TableInputStepMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-1', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-2', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-3', 'connectionname': 'Staging DB Connection'}),
        ]
        expected = "WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (\n" + \
                   "    VALUES ('SP-1', 1, 'SQL for SP-1', 'Staging DB Connection')\n" + \
                   "         , ('SP-2', 1, 'SQL for SP-2', 'Staging DB Connection')\n" + \
                   "         , ('SP-3', 1, 'SQL for SP-3', 'Staging DB Connection')\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)\n" + \
                   "SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = insert_rows.process_name;"

        self.assertEqual(expected, TableInputStepMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-1', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-2', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-3', 'connectionname': 'Staging DB Connection'}),
        ]
        expected = "WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (\n" + \
                   "    VALUES ('SP-1', 1, 'SQL for SP-1', 'Staging DB Connection')\n" + \
                   "         , ('SP-2', 1, 'SQL for SP-2', 'Staging DB Connection')\n" + \
                   "         , ('SP-3', 1, 'SQL for SP-3', 'Staging DB Connection')\n" + \
                   ")\n" + \
                   "UPDATE mdi.table_input_step\n" + \
                   "SET data_source_dwid = update_rows.data_source_dwid\n" + \
                   "  , sql = update_rows.sql\n" + \
                   "  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name\n" + \
                   "FROM update_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = update_rows.process_name\n" + \
                   "WHERE process.dwid = table_input_step.process_dwid;"
        self.assertEqual(expected, TableInputStepMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-1', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-2'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-2', 'connectionname': 'Staging DB Connection'}),
            Row(key={'process_name': 'SP-3'},
                attributes={'data_source_dwid': 1, 'sql': 'SQL for SP-3', 'connectionname': 'Staging DB Connection'}),
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('SP-1')\n" + \
                   "         , ('SP-2')\n" + \
                   "         , ('SP-3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.table_input_step\n" + \
                   "    USING delete_keys, mdi.process\n" + \
                   "WHERE table_input_step.process_dwid = process.dwid\n" + \
                   "  AND process.name = delete_keys.process_name;"
        self.assertEqual(expected, TableInputStepMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
