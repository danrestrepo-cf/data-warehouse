import unittest

from tests.test_utils import MockDBConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import ProcessMetadataComparisonFunctions


class TestProcessMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'SP-1', 'process_description': 'ETL to populate table1'},
            {'process_name': 'SP-2', 'process_description': 'ETL to populate table2'},
            {'process_name': 'SP-3', 'process_description': 'ETL to populate table3'}
        ]
        db_conn = MockDBConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, ProcessMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
                                                'output_type': 'insert'
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
                                                'output_type': 'insert'
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

        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows([
            {'process_name': 'SP-1', 'process_description': 'ETL to insert records into staging.history_octane.table1 using staging.staging_octane.table1 as the primary source'},
            {'process_name': 'SP-2', 'process_description': 'ETL to insert records into staging.history_octane.table2 using staging.staging_octane.table2 as the primary source'},
            {'process_name': 'SP-3',
             'process_description': 'ETL to insert records into ingress.ingress_schema_2.table3 using ingress.ingress_schema_1.table3 as the primary source'}
        ])
        self.assertEqual(expected, ProcessMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'process_description': 'ETL to populate table1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'process_description': 'ETL to populate table2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'process_description': 'ETL to populate table3'})
        ]
        row_grouper = ProcessMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_construct_delete_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'process_description': 'ETL to populate table1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'process_description': 'ETL to populate table2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'process_description': 'ETL to populate table3'})
        ]
        row_grouper = ProcessMetadataComparisonFunctions().construct_delete_row_grouper(MetadataTable([]))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'process_description': 'ETL to populate table1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'process_description': 'ETL to populate table2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'process_description': 'ETL to populate table3'})
        ]
        expected = "INSERT\n" + \
                   "INTO mdi.process (name, description)\n" + \
                   "VALUES ('SP-1', 'ETL to populate table1')\n" + \
                   "     , ('SP-2', 'ETL to populate table2')\n" + \
                   "     , ('SP-3', 'ETL to populate table3');"
        self.assertEqual(expected, ProcessMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'process_description': 'ETL to populate table1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'process_description': 'ETL to populate table2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'process_description': 'ETL to populate table3'})
        ]
        expected = "WITH update_rows (process_name, process_description) AS (\n" + \
                   "    VALUES ('SP-1', 'ETL to populate table1')\n" + \
                   "         , ('SP-2', 'ETL to populate table2')\n" + \
                   "         , ('SP-3', 'ETL to populate table3')\n" + \
                   ")\n" + \
                   "UPDATE mdi.process\n" + \
                   "SET description = update_rows.process_description\n" + \
                   "FROM update_rows\n" + \
                   "WHERE update_rows.process_name = process.name;"
        self.assertEqual(expected, ProcessMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'process_description': 'ETL to populate table1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'process_description': 'ETL to populate table2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'process_description': 'ETL to populate table3'})
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('SP-1')\n" + \
                   "         , ('SP-2')\n" + \
                   "         , ('SP-3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.process\n" + \
                   "USING delete_keys\n" + \
                   "WHERE process.name = delete_keys.process_name;"
        self.assertEqual(expected, ProcessMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
