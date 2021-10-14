import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import TableOutputFieldMetadataComparisonFunctions


class TestTableOutputFieldMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'SP-1', 'database_field_name': 't1_col1'},
            {'process_name': 'SP-1', 'database_field_name': 't1_col2'},
            {'process_name': 'SP-2', 'database_field_name': 't2_col1'}
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name', 'database_field_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, TableOutputFieldMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
                                        'columns': {
                                            't1_col1': {
                                                'data_type': 'TEXT'
                                            },
                                            't1_col2': {
                                                'data_type': 'TEXT'
                                            }
                                        },
                                        'etls': {
                                            'SP-1': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert'
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2',
                                        'primary_source_table': 'staging.staging_octane.table2',
                                        'columns': {
                                            't2_col1': {
                                                'data_type': 'TEXT'
                                            }
                                        },
                                        'etls': {
                                            'SP-2': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert'
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

        expected = MetadataTable(key_fields=['process_name', 'database_field_name'])
        expected.add_rows([
            {'process_name': 'SP-1', 'database_field_name': 't1_col1'},
            {'process_name': 'SP-1', 'database_field_name': 't1_col2'},
            {'process_name': 'SP-2', 'database_field_name': 't2_col1'}
        ])
        self.assertEqual(expected, TableOutputFieldMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_dependency_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'database_field_name': 't2_col1'}, attributes={})
        ]
        row_grouper = TableOutputFieldMetadataComparisonFunctions().construct_dependency_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'database_field_name': 't2_col1'}, attributes={})
        ]
        expected = "WITH insert_rows (process_name, database_field_name) AS (\n" + \
                   "    VALUES ('SP-1', 't1_col1')\n" + \
                   "         , ('SP-1', 't1_col2')\n" + \
                   "         , ('SP-2', 't2_col1')\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)\n" + \
                   "SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = insert_rows.process_name\n" + \
                   "JOIN mdi.table_output_step\n" + \
                   "     ON process.dwid = table_output_step.process_dwid;\n"
        self.assertEqual(expected, TableOutputFieldMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'database_field_name': 't2_col1'}, attributes={})
        ]
        expected = ""
        self.assertEqual(expected, TableOutputFieldMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'database_field_name': 't1_col2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'database_field_name': 't2_col1'}, attributes={})
        ]
        expected = "WITH delete_keys (process_name, database_field_name) AS (\n" + \
                   "    VALUES ('SP-1', 't1_col1')\n" + \
                   "         , ('SP-1', 't1_col2')\n" + \
                   "         , ('SP-2', 't2_col1')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.table_output_field\n" + \
                   "    USING delete_keys, mdi.process, mdi.table_output_step\n" + \
                   "WHERE delete_keys.process_name = process.name\n" + \
                   "  AND process.dwid = table_output_step.process_dwid\n" + \
                   "  AND table_output_step.dwid = table_output_field.table_output_step_dwid\n" + \
                   "  AND delete_keys.database_field_name = table_output_field.database_field_name;"
        self.assertEqual(expected, TableOutputFieldMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
