import unittest

from tests.testing_utils import MockDBConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import InsertUpdateKeyMetadataComparisonFunctions


class TestInsertUpdateKeyMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'ETL-1', 'key_lookup': 'column1'},
            {'process_name': 'ETL-2', 'key_lookup': 'column2'},
            {'process_name': 'ETL-3', 'key_lookup': 'column3'},
        ]
        db_conn = MockDBConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name', 'key_lookup'])
        expected.add_rows(test_data)
        self.assertEqual(expected, InsertUpdateKeyMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

    def test_construct_metadata_table_from_source(self):
        dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'staging',
                        'schemas': [
                            {
                                'name': 'star_loan',
                                'tables': [
                                    {
                                        'name': 'table1_dim',
                                        'primary_source_table': 'staging.history_octane.table1',
                                        'step_functions': {
                                            'SP-1': {
                                                'etls': {
                                                    'ETL-1': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update',
                                                        'insert_update_keys': [
                                                            'column1'
                                                        ]
                                                    }
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2_dim',
                                        'primary_source_table': 'staging.history_octane.table2',
                                        'step_functions': {
                                            'SP-2': {
                                                'etls': {
                                                    'ETL-2': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update',
                                                        'insert_update_keys': [
                                                            'column2',
                                                            'column3'
                                                        ]
                                                    }
                                                }
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
                                        'step_functions': {
                                            'SP-3': {
                                                'etls': {
                                                    'ETL-3': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update',
                                                        'insert_update_keys': [
                                                            'column4'
                                                        ]
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
        )

        expected = MetadataTable(key_fields=['process_name', 'key_lookup'])
        expected.add_rows([
            {'process_name': 'ETL-1', 'key_lookup': 'column1'},
            {'process_name': 'ETL-2', 'key_lookup': 'column2'},
            {'process_name': 'ETL-2', 'key_lookup': 'column3'},
            {'process_name': 'ETL-3', 'key_lookup': 'column4'},
        ])
        self.assertEqual(expected, InsertUpdateKeyMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column1'}, attributes={}),
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column2'}, attributes={}),
            Row(key={'process_name': 'ETL-2', 'key_lookup': 'column3'}, attributes={})
        ]
        row_grouper = InsertUpdateKeyMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_construct_delete_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column1'}, attributes={}),
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column2'}, attributes={}),
            Row(key={'process_name': 'ETL-2', 'key_lookup': 'column3'}, attributes={})
        ]
        row_grouper = InsertUpdateKeyMetadataComparisonFunctions().construct_delete_row_grouper(MetadataTable([]))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column1'}, attributes={}),
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column2'}, attributes={}),
            Row(key={'process_name': 'ETL-2', 'key_lookup': 'column3'}, attributes={})
        ]
        expected = "WITH insert_rows (process_name, key_lookup) AS (\n" + \
                   "    VALUES ('ETL-1', 'column1')\n" + \
                   "         , ('ETL-1', 'column2')\n" + \
                   "         , ('ETL-2', 'column3')\n" + \
                   ")\n" + \
                   "INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)\n" + \
                   "SELECT insert_update_step.dwid, insert_rows.key_lookup, insert_rows.key_lookup, NULL, '='\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "ON process.name = insert_rows.process_name\n" + \
                   "JOIN mdi.insert_update_step\n" + \
                   "ON process.dwid = insert_update_step.process_dwid;"
        self.assertEqual(expected, InsertUpdateKeyMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column1'}, attributes={}),
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column2'}, attributes={}),
            Row(key={'process_name': 'ETL-2', 'key_lookup': 'column3'}, attributes={})
        ]
        expected = ""
        self.assertEqual(expected, InsertUpdateKeyMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column1'}, attributes={}),
            Row(key={'process_name': 'ETL-1', 'key_lookup': 'column2'}, attributes={}),
            Row(key={'process_name': 'ETL-2', 'key_lookup': 'column3'}, attributes={})
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('ETL-1', 'column1')\n" + \
                   "         , ('ETL-1', 'column2')\n" + \
                   "         , ('ETL-2', 'column3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.insert_update_key\n" + \
                   "    USING delete_keys, mdi.process, mdi.insert_update_step\n" + \
                   "WHERE insert_update_key.insert_update_step_dwid = insert_update_step.dwid" \
                   "  AND insert_update_step.process_dwid = process.dwid\n" + \
                   "  AND process.name = delete_keys.process_name;"
        self.assertEqual(expected, InsertUpdateKeyMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
