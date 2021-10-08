import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       DatabaseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ETLMetadata,
                                                       TableAddress)
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import (ProcessMetadataComparisonFunctions,
                                                                               JSONOutputFieldMetadataComparisonFunctions)


class TestProcessMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        test_data = [
            {'process_name': 'SP-1', 'process_description': 'ETL to populate table1'},
            {'process_name': 'SP-2', 'process_description': 'ETL to populate table2'},
            {'process_name': 'SP-3', 'process_description': 'ETL to populate table3'}
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
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
                                                'data_type': 'TEXT',
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
                                                'data_type': 'TEXT',
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
                                                'data_type': 'TEXT',
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
            {'process_name': 'SP-1', 'process_description': 'ETL to copy table1 data from staging_octane to history_octane'},
            {'process_name': 'SP-2', 'process_description': 'ETL to copy table2 data from staging_octane to history_octane'},
            {'process_name': 'SP-3',
             'process_description': 'table -> table-insert ETL from ingress.ingress_schema_1.table3 to ingress.ingress_schema_2.table3'}
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

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'process_description': 'ETL to populate table1'}),
            Row(key={'process_name': 'SP-2'}, attributes={'process_description': 'ETL to populate table2'}),
            Row(key={'process_name': 'SP-3'}, attributes={'process_description': 'ETL to populate table3'})
        ]
        expected = "INSERT\n" + \
                   "INTO mdi.process\n" + \
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


class TestJSONOutputFieldMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        test_data = [
            {'process_name': 'SP-1', 'json_output_field': 't1_pid'},
            {'process_name': 'SP-2', 'json_output_field': 't2_pid'},
            {'process_name': 'SP-3', 'json_output_field': 't3_pid'}
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows(test_data)
        self.assertEqual(expected, JSONOutputFieldMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

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
            {'process_name': 'SP-1', 'json_output_field': 't1_pid'},
            {'process_name': 'SP-2', 'json_output_field': 't2_pid'},
            {'process_name': 'SP-3', 'json_output_field': 't3_pid'}
        ])
        self.assertEqual(expected, JSONOutputFieldMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'json_output_field': 't1_pid'}),
            Row(key={'process_name': 'SP-2'}, attributes={'json_output_field': 't2_pid'}),
            Row(key={'process_name': 'SP-3'}, attributes={'json_output_field': 't3_pid'})
        ]
        row_grouper = JSONOutputFieldMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'json_output_field': 't1_pid'}),
            Row(key={'process_name': 'SP-2'}, attributes={'json_output_field': 't2_pid'}),
            Row(key={'process_name': 'SP-3'}, attributes={'json_output_field': 't3_pid'})
        ]
        expected = "WITH insert_rows (process_name, json_output_field) AS (\n" + \
                   "    VALUES ('SP-1', 't1_pid')\n" + \
                   "         , ('SP-2', 't2_pid')\n" + \
                   "         , ('SP-3', 't3_pid')\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.json_output_field (process_dwid, field_name)\n" + \
                   "SELECT process.dwid, insert_rows.json_output_field\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON insert_rows.process_name = process.name;"
        self.assertEqual(expected, JSONOutputFieldMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'json_output_field': 't1_pid'}),
            Row(key={'process_name': 'SP-2'}, attributes={'json_output_field': 't2_pid'}),
            Row(key={'process_name': 'SP-3'}, attributes={'json_output_field': 't3_pid'})
        ]
        expected = "WITH update_rows (process_name, json_output_field) AS (\n" + \
                   "    VALUES ('SP-1', 't1_pid')\n" + \
                   "         , ('SP-2', 't2_pid')\n" + \
                   "         , ('SP-3', 't3_pid')\n" + \
                   ")\n" + \
                   "UPDATE mdi.json_output_field\n" + \
                   "SET field_name = update_rows.json_output_field\n" + \
                   "FROM update_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = update_rows.process_name\n" + \
                   "WHERE json_output_field.process_dwid = process.dwid;"
        self.assertEqual(expected, JSONOutputFieldMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'SP-1'}, attributes={'json_output_field': 't1_pid'}),
            Row(key={'process_name': 'SP-2'}, attributes={'json_output_field': 't2_pid'}),
            Row(key={'process_name': 'SP-3'}, attributes={'json_output_field': 't3_pid'})
        ]
        expected = "WITH delete_keys (process_name) AS (\n" + \
                   "    VALUES ('SP-1')\n" + \
                   "         , ('SP-2')\n" + \
                   "         , ('SP-3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.json_output_field\n" + \
                   "    USING delete_keys, mdi.process\n" + \
                   "WHERE json_output_field.process_dwid = process.dwid\n" + \
                   "  AND process.name = delete_keys.process_name;"
        self.assertEqual(expected, JSONOutputFieldMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
