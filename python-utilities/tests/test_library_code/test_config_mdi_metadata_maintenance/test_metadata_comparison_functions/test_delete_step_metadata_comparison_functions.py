import unittest

from tests.testing_utils import MockDBConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import DeleteStepMetadataComparisonFunctions


class TestDeleteStepMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests.
        """
        test_data = [
            {'process_name': 'ETL-1', 'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan',
             'table_name': 'table1'},
            {'process_name': 'ETL-2', 'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan',
             'table_name': 'table2'},
            {'process_name': 'ETL-3', 'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan',
             'table_name': 'table3'},
        ]
        db_conn = MockDBConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, DeleteStepMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
                                        'name': 'table1',
                                        'primary_source_table': 'staging.history_octane.table1',
                                        'step_functions': {
                                            'SP-1': {
                                                'etls': {
                                                    'ETL-1': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'delete',
                                                        'output_table': 'staging.star_loan.table1'
                                                    }
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2',
                                        'primary_source_table': 'staging.history_octane.table2',
                                        'step_functions': {
                                            'SP-2': {
                                                'etls': {
                                                    'ETL-2': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'delete',
                                                        'output_table': 'staging.star_loan.table22'
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
                                                        'output_type': 'delete',
                                                        'output_table': 'ingress.ingress_schema_2.table3'
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

        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows([
            {'process_name': 'ETL-1', 'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan',
             'table_name': 'table1'},
            {'process_name': 'ETL-2', 'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan',
             'table_name': 'table22'},
            {'process_name': 'ETL-3', 'connectionname': 'Ingress DB Connection', 'schema_name': 'ingress_schema_2',
             'table_name': 'table3'},
        ])
        self.assertEqual(expected, DeleteStepMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'ETL-1'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table1'}),
            Row(key={'process_name': 'ETL-2'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table22'}),
            Row(key={'process_name': 'ETL-3'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table3'})
        ]
        row_grouper = DeleteStepMetadataComparisonFunctions().construct_insert_row_grouper(
            DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_construct_delete_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'ETL-1'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table1'}),
            Row(key={'process_name': 'ETL-2'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table22'}),
            Row(key={'process_name': 'ETL-3'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table3'})
        ]
        row_grouper = DeleteStepMetadataComparisonFunctions().construct_delete_row_grouper(MetadataTable([]))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table1'}),
            Row(key={'process_name': 'ETL-2'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table22'}),
            Row(key={'process_name': 'ETL-3'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table3'})
        ]
        expected = "WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (\n" + \
                   "    VALUES ('ETL-1', 'Staging DB Connection', 'star_loan', 'table1')\n" + \
                   "         , ('ETL-2', 'Staging DB Connection', 'star_loan', 'table22')\n" + \
                   "         , ('ETL-3', 'Staging DB Connection', 'star_loan', 'table3')\n" + \
                   ")\n" + \
                   "INSERT INTO mdi.delete_step (process_dwid, connectionname, schema_name, table_name, commit_size)\n" + \
                   "SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "ON process.name = insert_rows.process_name;"
        self.assertEqual(expected, DeleteStepMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table1'}),
            Row(key={'process_name': 'ETL-2'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table22'}),
            Row(key={'process_name': 'ETL-3'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table3'})
        ]
        expected = "WITH update_rows (process_name, connectionname, schema_name, table_name) AS (\n" + \
                   "    VALUES ('ETL-1', 'Staging DB Connection', 'star_loan', 'table1')\n" + \
                   "         , ('ETL-2', 'Staging DB Connection', 'star_loan', 'table22')\n" + \
                   "         , ('ETL-3', 'Staging DB Connection', 'star_loan', 'table3')\n" + \
                   ")\n" + \
                   "UPDATE mdi.delete_step\n" + \
                   "SET connectionname = update_rows.connectionname\n" + \
                   "  , schema_name = update_rows.schema_name\n" + \
                   "  , table_name = update_rows.table_name\n" + \
                   "FROM update_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = update_rows.process_name\n" + \
                   "WHERE process.dwid = delete_step.process_dwid;"
        self.assertEqual(expected, DeleteStepMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table1'}),
            Row(key={'process_name': 'ETL-2'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table22'}),
            Row(key={'process_name': 'ETL-3'},
                attributes={'connectionname': 'Staging DB Connection', 'schema_name': 'star_loan', 'table_name':
                    'table3'})
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('ETL-1')\n" + \
                   "         , ('ETL-2')\n" + \
                   "         , ('ETL-3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.delete_step\n" + \
                   "    USING delete_keys, mdi.process\n" + \
                   "WHERE delete_step.process_dwid = process.dwid\n" + \
                   "  AND process.name = delete_keys.process_name;"
        self.assertEqual(expected, DeleteStepMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
