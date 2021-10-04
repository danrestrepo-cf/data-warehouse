import unittest
import context

from data_warehouse_metadata import (DataWarehouseMetadata,
                                     DatabaseMetadata,
                                     SchemaMetadata,
                                     TableMetadata,
                                     ColumnMetadata,
                                     InvalidMetadataKeyException)


class TestDataWarehouseMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_database_that_doesnt_exist(self):
        dw_metadata = DataWarehouseMetadata('edw')
        with self.assertRaises(InvalidMetadataKeyException):
            dw_metadata.get_database_metadata('staging')

    def test_can_get_database_metadata_by_database_name_if_the_database_has_been_added_to_the_metadata(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database_metadata(DatabaseMetadata('staging'))
        self.assertEqual(DatabaseMetadata('staging'), dw_metadata.get_database_metadata('staging'))

    def test_can_iterate_through_all_added_databases(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database_metadata(DatabaseMetadata('staging'))
        dw_metadata.add_database_metadata(DatabaseMetadata('config'))
        dw_metadata.add_database_metadata(DatabaseMetadata('ingress'))
        expected = [DatabaseMetadata('staging'), DatabaseMetadata('config'), DatabaseMetadata('ingress')]
        self.assertEqual(expected, [database for database in dw_metadata.databases])


class TestDatabaseMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_schema_that_doesnt_exist(self):
        db_metadata = DatabaseMetadata('staging')
        with self.assertRaises(InvalidMetadataKeyException):
            db_metadata.get_schema_metadata('staging_octane')

    def test_can_get_schema_metadata_by_schema_name_if_the_schema_has_been_added_to_the_metadata(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.add_schema_metadata(SchemaMetadata('staging_octane'))
        self.assertEqual(SchemaMetadata('staging_octane'), db_metadata.get_schema_metadata('staging_octane'))

    def test_can_iterate_through_all_added_schemas(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.add_schema_metadata(SchemaMetadata('staging_octane'))
        db_metadata.add_schema_metadata(SchemaMetadata('history_octane'))
        db_metadata.add_schema_metadata(SchemaMetadata('star_loan'))
        expected = [SchemaMetadata('staging_octane'), SchemaMetadata('history_octane'), SchemaMetadata('star_loan')]
        self.assertEqual(expected, [schema for schema in db_metadata.schemas])


class TestSchemaMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_table_that_doesnt_exist(self):
        schema_metadata = SchemaMetadata('staging_octane')
        with self.assertRaises(InvalidMetadataKeyException):
            schema_metadata.get_table_metadata('account')

    def test_can_get_schema_metadata_by_table_name_if_the_table_has_been_added_to_the_metadata(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table_metadata(TableMetadata('account'))
        self.assertEqual(TableMetadata('account'), schema_metadata.get_table_metadata('account'))

    def test_can_iterate_through_all_added_tables(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table_metadata(TableMetadata('account'))
        schema_metadata.add_table_metadata(TableMetadata('deal'))
        schema_metadata.add_table_metadata(TableMetadata('loan'))
        expected = [TableMetadata('account'), TableMetadata('deal'), TableMetadata('loan')]
        self.assertEqual(expected, [tables for tables in schema_metadata.tables])

if __name__ == '__main__':
    unittest.main()
