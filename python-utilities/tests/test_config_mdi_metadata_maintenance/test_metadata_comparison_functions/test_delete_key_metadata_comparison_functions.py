import unittest

from tests.test_utils import MockDBConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import DeleteKeyMetadataComparisonFunctions


class TestDeleteKeyMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'SP-1', 'table_name_field': 'column1'},
            {'process_name': 'SP-2', 'table_name_field': 'column2'},
            {'process_name': 'SP-3', 'table_name_field': 'column3'},
        ]
        db_conn = MockDBConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name', 'table_name_field'])
        expected.add_rows(test_data)
        self.assertEqual(expected, DeleteKeyMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
                                        'etls': {
                                            'SP-1': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'delete',
                                                'delete_keys': [
                                                    'column1'
                                                ]
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2_dim',
                                        'primary_source_table': 'staging.history_octane.table2',
                                        'etls': {
                                            'SP-2': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'delete',
                                                'delete_keys': [
                                                    'column2',
                                                    'column3'
                                                ]
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
                                                'output_type': 'delete',
                                                'delete_keys': [
                                                    'column4'
                                                ]
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

        expected = MetadataTable(key_fields=['process_name', 'table_name_field'])
        expected.add_rows([
            {'process_name': 'SP-1', 'table_name_field': 'column1'},
            {'process_name': 'SP-2', 'table_name_field': 'column2'},
            {'process_name': 'SP-2', 'table_name_field': 'column3'},
            {'process_name': 'SP-3', 'table_name_field': 'column4'}
        ])
        self.assertEqual(expected, DeleteKeyMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'table_name_field': 'column3'}, attributes={})
        ]
        row_grouper = DeleteKeyMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_construct_delete_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'table_name_field': 'column3'}, attributes={})
        ]
        row_grouper = DeleteKeyMetadataComparisonFunctions().construct_delete_row_grouper(MetadataTable([]))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'table_name_field': 'column3'}, attributes={})
        ]
        expected = "WITH insert_rows (process_name, table_name_field) AS (\n" + \
                   "    VALUES ('SP-1', 'column1')\n" + \
                   "         , ('SP-1', 'column2')\n" + \
                   "         , ('SP-2', 'column3')\n" + \
                   ")\n" + \
                   "INSERT INTO mdi.delete_key (delete_step_dwid, table_name_field, stream_fieldname_1, stream_fieldname_2, comparator, is_sensitive)\n" + \
                   "SELECT delete_step.dwid, insert_rows.table_name_field, insert_rows.table_name_field, '', '=', FALSE\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "ON process.name = insert_rows.process_name\n" + \
                   "JOIN mdi.delete_step\n" + \
                   "ON process.dwid = delete_step.process_dwid;"
        self.assertEqual(expected, DeleteKeyMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'table_name_field': 'column3'}, attributes={})
        ]
        expected = ""
        self.assertEqual(expected, DeleteKeyMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column1'}, attributes={}),
            Row(key={'process_name': 'SP-1', 'table_name_field': 'column2'}, attributes={}),
            Row(key={'process_name': 'SP-2', 'table_name_field': 'column3'}, attributes={})
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('SP-1', 'column1')\n" + \
                   "         , ('SP-1', 'column2')\n" + \
                   "         , ('SP-2', 'column3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.delete_key\n" + \
                   "    USING delete_keys, mdi.process, mdi.delete_step\n" + \
                   "WHERE delete_key.delete_step_dwid = delete_step.dwid" \
                   "  AND delete_step.process_dwid = process.dwid\n" + \
                   "  AND process.name = delete_keys.process_name;"
        self.assertEqual(expected, DeleteKeyMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
