import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       DatabaseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ETLMetadata,
                                                       TableAddress)
from lib.config_mdi_metadata_maintenance.metadata_comparison_configurations import (ProcessMetadataComparisonFunctions)


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
        etl1_metadata = ETLMetadata(process_name='SP-1')
        etl2_metadata = ETLMetadata(process_name='SP-2')
        etl3_metadata = ETLMetadata(process_name='SP-3')

        table1_metadata = TableMetadata(name='table1', primary_source_table=TableAddress('staging', 'staging_octane', 'table1'))
        table1_metadata.add_etl(etl1_metadata)
        table2_metadata = TableMetadata(name='table2', primary_source_table=TableAddress('staging', 'staging_octane', 'table2'))
        table2_metadata.add_etl(etl2_metadata)
        table3_metadata = TableMetadata(name='table3', primary_source_table=TableAddress('ingress', 'ingress_schema_1', 'table3'))
        table3_metadata.add_etl(etl3_metadata)

        schema1_metadata = SchemaMetadata(name='history_octane')
        schema1_metadata.add_table(table1_metadata)
        schema1_metadata.add_table(table2_metadata)
        schema2_metadata = SchemaMetadata(name='ingress_schema_2')
        schema2_metadata.add_table(table3_metadata)

        db1_metadata = DatabaseMetadata(name='staging')
        db1_metadata.add_schema(schema1_metadata)
        db2_metadata = DatabaseMetadata(name='ingress')
        db2_metadata.add_schema(schema2_metadata)

        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database(db1_metadata)
        dw_metadata.add_database(db2_metadata)

        expected = MetadataTable(key_fields=['process_name'])
        expected.add_rows([
            {'process_name': 'SP-1', 'process_description': 'ETL to copy table1 data from staging_octane to history_octane'},
            {'process_name': 'SP-2', 'process_description': 'ETL to copy table2 data from staging_octane to history_octane'},
            {'process_name': 'SP-3',
             'process_description': 'table -> table-insert ETL from ingress.ingress_schema_1.table3 to ingress.ingress_schema_2.table3'}
        ])
        self.assertEqual(expected, ProcessMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

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


if __name__ == '__main__':
    unittest.main()
