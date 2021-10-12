import unittest

from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       DatabaseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ColumnMetadata,
                                                       ETLMetadata,
                                                       ForeignKeyMetadata,
                                                       InvalidMetadataKeyException,
                                                       TableAddress)
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


class TestDataWarehouseMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_database_that_doesnt_exist(self):
        dw_metadata = DataWarehouseMetadata('edw')
        with self.assertRaises(InvalidMetadataKeyException):
            dw_metadata.get_database('staging')

    def test_can_get_database_metadata_by_database_name_if_the_database_has_been_added_to_the_metadata(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database(DatabaseMetadata('staging'))
        self.assertEqual(DatabaseMetadata('staging'), dw_metadata.get_database('staging'))

    def test_can_iterate_through_all_added_databases(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database(DatabaseMetadata('staging'))
        dw_metadata.add_database(DatabaseMetadata('config'))
        dw_metadata.add_database(DatabaseMetadata('ingress'))
        expected = [DatabaseMetadata('staging'), DatabaseMetadata('config'), DatabaseMetadata('ingress')]
        self.assertEqual(expected, [database for database in dw_metadata.databases])

    def test_can_remove_database_metadata(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database(DatabaseMetadata('staging'))
        dw_metadata.remove_database_metadata('staging')
        self.assertEqual([], dw_metadata.databases)

    def test_removing_database_that_doesnt_exist_does_nothing(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.remove_database_metadata('staging')
        self.assertEqual([], dw_metadata.databases)

    def test_can_get_table_metadata_object_by_address(self):
        table_metadata = TableMetadata('table1')
        schema_metadata = SchemaMetadata('schema1')
        schema_metadata.add_table(table_metadata)
        database_metadata = DatabaseMetadata('db1')
        database_metadata.add_schema(schema_metadata)
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database(database_metadata)
        table_address = TableAddress('db1', 'schema1', 'table1')
        self.assertEqual(table_metadata, dw_metadata.get_table_by_address(table_address))


class TestDatabaseMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_schema_that_doesnt_exist(self):
        db_metadata = DatabaseMetadata('staging')
        with self.assertRaises(InvalidMetadataKeyException):
            db_metadata.get_schema('staging_octane')

    def test_can_get_schema_metadata_by_schema_name_if_the_schema_has_been_added_to_the_metadata(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.add_schema(SchemaMetadata('staging_octane'))
        self.assertEqual(SchemaMetadata('staging_octane'), db_metadata.get_schema('staging_octane'))

    def test_can_iterate_through_all_added_schemas(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.add_schema(SchemaMetadata('staging_octane'))
        db_metadata.add_schema(SchemaMetadata('history_octane'))
        db_metadata.add_schema(SchemaMetadata('star_loan'))
        expected = [SchemaMetadata('staging_octane'), SchemaMetadata('history_octane'), SchemaMetadata('star_loan')]
        self.assertEqual(expected, [schema for schema in db_metadata.schemas])

    def test_can_remove_schema_metadata(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.add_schema(SchemaMetadata('staging_octane'))
        db_metadata.remove_schema_metadata('staging_octane')
        self.assertEqual([], db_metadata.schemas)

    def test_removing_schema_that_doesnt_exist_does_nothing(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.remove_schema_metadata('staging_octane')
        self.assertEqual([], db_metadata.schemas)


class TestSchemaMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_table_that_doesnt_exist(self):
        schema_metadata = SchemaMetadata('staging_octane')
        with self.assertRaises(InvalidMetadataKeyException):
            schema_metadata.get_table('account')

    def test_can_get_table_metadata_by_table_name_if_the_table_has_been_added_to_the_metadata(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table(TableMetadata('account'))
        self.assertEqual(TableMetadata('account'), schema_metadata.get_table('account'))

    def test_can_iterate_through_all_added_tables(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table(TableMetadata('account'))
        schema_metadata.add_table(TableMetadata('deal'))
        schema_metadata.add_table(TableMetadata('loan'))
        expected = [TableMetadata('account'), TableMetadata('deal'), TableMetadata('loan')]
        self.assertEqual(expected, [table for table in schema_metadata.tables])

    def test_can_remove_table_metadata(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table(TableMetadata('account'))
        schema_metadata.remove_table_metadata('account')
        self.assertEqual([], schema_metadata.tables)

    def test_removing_table_that_doesnt_exist_does_nothing(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.remove_table_metadata('account')
        self.assertEqual([], schema_metadata.tables)


class TestTableMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_column_that_doesnt_exist(self):
        table_metadata = TableMetadata('deal')
        with self.assertRaises(InvalidMetadataKeyException):
            table_metadata.get_column('d_pid')

    def test_can_get_column_metadata_by_column_name_if_the_column_has_been_added_to_the_metadata(self):
        table_metadata = TableMetadata('deal')
        table_metadata.add_column(ColumnMetadata('d_pid'))
        self.assertEqual(ColumnMetadata('d_pid'), table_metadata.get_column('d_pid'))

    def test_can_iterate_through_all_added_columns(self):
        table_metadata = TableMetadata('deal')
        table_metadata.add_column(ColumnMetadata('d_pid'))
        table_metadata.add_column(ColumnMetadata('d_active_proposal_pid'))
        table_metadata.add_column(ColumnMetadata('d_test_loan'))
        expected = [ColumnMetadata('d_pid'), ColumnMetadata('d_active_proposal_pid'), ColumnMetadata('d_test_loan')]
        self.assertEqual(expected, [column for column in table_metadata.columns])

    def test_can_remove_column_metadata(self):
        table_metadata = TableMetadata('account')
        table_metadata.add_column(ColumnMetadata('a_pid'))
        table_metadata.remove_column_metadata('a_pid')
        self.assertEqual([], table_metadata.columns)

    def test_removing_column_that_doesnt_exist_does_nothing(self):
        table_metadata = TableMetadata('account')
        table_metadata.remove_column_metadata('a_pid')
        self.assertEqual([], table_metadata.columns)

    def test_throws_error_if_user_tries_to_get_etl_that_doesnt_exist(self):
        table_metadata = TableMetadata('deal')
        with self.assertRaises(InvalidMetadataKeyException):
            table_metadata.get_etl('SP-100000')

    def test_can_get_etl_metadata_by_etl_name_if_the_etl_has_been_added_to_the_metadata(self):
        table_metadata = TableMetadata('deal')
        table_metadata.add_etl(ETLMetadata('SP-100000'))
        self.assertEqual(ETLMetadata('SP-100000'), table_metadata.get_etl('SP-100000'))

    def test_can_iterate_through_all_added_etls(self):
        table_metadata = TableMetadata('deal')
        table_metadata.add_etl(ETLMetadata('SP-100000'))
        table_metadata.add_etl(ETLMetadata('SP-100001'))
        table_metadata.add_etl(ETLMetadata('SP-100002'))
        expected = [ETLMetadata('SP-100000'), ETLMetadata('SP-100001'), ETLMetadata('SP-100002')]
        self.assertEqual(expected, [etl for etl in table_metadata.etls])

    def test_can_remove_etl_metadata(self):
        table_metadata = TableMetadata('account')
        table_metadata.add_etl(ETLMetadata('SP-100123'))
        table_metadata.remove_etl_metadata('SP-100123')
        self.assertEqual([], table_metadata.etls)

    def test_removing_etl_that_doesnt_exist_does_nothing(self):
        table_metadata = TableMetadata('account')
        table_metadata.remove_etl_metadata('SP-100123')
        self.assertEqual([], table_metadata.etls)

    def test_throws_error_if_user_tries_to_get_foreign_key_that_doesnt_exist(self):
        table_metadata = TableMetadata('deal')
        with self.assertRaises(InvalidMetadataKeyException):
            table_metadata.get_foreign_key('fk_0')

    def test_can_get_foreign_key_metadata_by_foreign_key_name_if_the_foreign_key_has_been_added_to_the_metadata(self):
        table_metadata = TableMetadata('deal')
        proposal_address = TableAddress('staging', 'staging_octane', 'proposal')
        table_metadata.add_foreign_key(ForeignKeyMetadata('fk_0', proposal_address, [], []))
        self.assertEqual(ForeignKeyMetadata('fk_0', proposal_address, [], []), table_metadata.get_foreign_key('fk_0'))

    def test_can_iterate_through_all_added_foreign_keys(self):
        table_metadata = TableMetadata('deal')
        proposal_address = TableAddress('staging', 'staging_octane', 'proposal')
        table_metadata.add_foreign_key(ForeignKeyMetadata('fk_0', proposal_address, [], []))
        table_metadata.add_foreign_key(ForeignKeyMetadata('fk_1', proposal_address, [], []))
        table_metadata.add_foreign_key(ForeignKeyMetadata('fk_2', proposal_address, [], []))
        expected = [
            ForeignKeyMetadata('fk_0', proposal_address, [], []),
            ForeignKeyMetadata('fk_1', proposal_address, [], []),
            ForeignKeyMetadata('fk_2', proposal_address, [], [])
        ]
        self.assertEqual(expected, [foreign_key for foreign_key in table_metadata.foreign_keys])

    def test_can_remove_foreign_key_metadata(self):
        table_metadata = TableMetadata('account')
        table_metadata.add_foreign_key(ForeignKeyMetadata(
            name='fk_1',
            table=TableAddress('db', 'schema', 'table'),
            native_columns=[],
            foreign_columns=[]
        ))
        table_metadata.remove_foreign_key_metadata('fk_1')
        self.assertEqual([], table_metadata.foreign_keys)

    def test_removing_foreign_key_that_doesnt_exist_does_nothing(self):
        table_metadata = TableMetadata('account')
        table_metadata.remove_foreign_key_metadata('fk_1')
        self.assertEqual([], table_metadata.foreign_keys)

    def test_can_generate_its_own_address(self):
        table_metadata = TableMetadata(name='account', schema_name='staging_octane', database_name='staging')
        expected = TableAddress(table='account', schema='staging_octane', database='staging')
        self.assertEqual(expected, table_metadata.address)


class TestTableMetadataCanGetColumnSourceTable(unittest.TestCase):

    def setUp(self) -> None:
        self.dw_metadata = construct_data_warehouse_metadata_from_dict(
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
                                        'name': 'table_with_source',
                                        'primary_source_table': 'staging.staging_octane.source_table',
                                        'columns': {
                                            'column_with_source': {
                                                'data_source': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.source_column'
                                                }
                                            },
                                            'column_with_distant_source': {
                                                'data_source': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.foreign_keys.fk_1.foreign_keys.fk_2.foreign_keys.fk_3.columns.distant_source_column'
                                                }
                                            }

                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'staging_octane',
                                'tables': [
                                    {
                                        'name': 'source_table',
                                        'columns': {
                                            'source_column': {
                                                'data_source': 'TEXT'
                                            },
                                            'fk_col': {
                                                'data_source': 'TEXT'
                                            }
                                        },
                                        'foreign_keys': {
                                            'fk_1': {
                                                'columns': ['fk_col'],
                                                'references': {
                                                    'columns': ['fk_col'],
                                                    'schema': 'other_schema',
                                                    'table': 'other_table_1'
                                                }
                                            }
                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'other_schema',
                                'tables': [
                                    {
                                        'name': 'other_table_1',
                                        'columns': {
                                            'fk_col': {
                                                'data_source': 'TEXT'
                                            }
                                        },
                                        'foreign_keys': {
                                            'fk_2': {
                                                'columns': ['fk_col'],
                                                'references': {
                                                    'columns': ['fk_col'],
                                                    'schema': 'other_schema',
                                                    'table': 'other_table_2'
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'other_table_2',
                                        'columns': {
                                            'fk_col': {
                                                'data_source': 'TEXT'
                                            }
                                        },
                                        'foreign_keys': {
                                            'fk_3': {
                                                'columns': ['fk_col'],
                                                'references': {
                                                    'columns': ['fk_col'],
                                                    'schema': 'other_schema',
                                                    'table': 'distant_source_table'
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'distant_source_table',
                                        'columns': {
                                            'distant_source_column': {
                                                'data_source': 'TEXT'
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

    def test_none_if_column_has_no_source(self):
        table_address = TableAddress('staging', 'staging_octane', 'source_table')
        table = self.dw_metadata.get_table_by_address(table_address)
        self.assertEqual(None, table.get_column_source_table('source_column', self.dw_metadata))

    def test_retrieves_primary_source_table_metadata_if_there_are_no_fk_steps(self):
        table_address = TableAddress('staging', 'history_octane', 'table_with_source')
        table = self.dw_metadata.get_table_by_address(table_address)
        source_table_address = TableAddress('staging', 'staging_octane', 'source_table')
        source_table = self.dw_metadata.get_table_by_address(source_table_address)
        self.assertEqual(source_table, table.get_column_source_table('column_with_source', self.dw_metadata))

    def test_follows_fk_steps_to_retrieve_distant_source_table_metadata(self):
        table_address = TableAddress('staging', 'history_octane', 'table_with_source')
        table = self.dw_metadata.get_table_by_address(table_address)
        source_table_address = TableAddress('staging', 'other_schema', 'distant_source_table')
        source_table = self.dw_metadata.get_table_by_address(source_table_address)
        self.assertEqual(source_table, table.get_column_source_table('column_with_distant_source', self.dw_metadata))


if __name__ == '__main__':
    unittest.main()
