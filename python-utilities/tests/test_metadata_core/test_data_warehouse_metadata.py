import unittest

from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       DatabaseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ColumnMetadata,
                                                       ETLMetadata,
                                                       StepFunctionMetadata,
                                                       ForeignKeyMetadata,
                                                       InvalidMetadataKeyException,
                                                       ETLInputType,
                                                       ETLOutputType,
                                                       ETLDataSource)
from lib.metadata_core.metadata_object_path import DatabasePath, SchemaPath, TablePath, ColumnPath
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
        dw_metadata.remove_database('staging')
        self.assertEqual([], dw_metadata.databases)

    def test_removing_database_that_doesnt_exist_does_nothing(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.remove_database('staging')
        self.assertEqual([], dw_metadata.databases)

    def test_can_indicate_whether_it_contains_a_given_database_by_name(self):
        dw_metadata = DataWarehouseMetadata('edw')
        dw_metadata.add_database(DatabaseMetadata('staging'))
        self.assertTrue(dw_metadata.contains_database('staging'))
        self.assertFalse(dw_metadata.contains_database('ingress'))


class TestDataWarehouseMetadataGetByPath(unittest.TestCase):

    def setUp(self) -> None:
        self.column_metadata = ColumnMetadata('col1')
        self.table_metadata = TableMetadata('table1')
        self.table_metadata.add_column(self.column_metadata)
        self.schema_metadata = SchemaMetadata('schema1')
        self.schema_metadata.add_table(self.table_metadata)
        self.database_metadata = DatabaseMetadata('db1')
        self.database_metadata.add_schema(self.schema_metadata)
        self.dw_metadata = DataWarehouseMetadata('edw')
        self.dw_metadata.add_database(self.database_metadata)

    def test_can_get_database_metadata_object_by_path(self):
        db_path = DatabasePath('db1')
        self.assertEqual(self.database_metadata, self.dw_metadata.get_database_by_path(db_path))

    def test_can_get_schema_metadata_object_by_path(self):
        schema_path = SchemaPath('db1', 'schema1')
        self.assertEqual(self.schema_metadata, self.dw_metadata.get_schema_by_path(schema_path))

    def test_can_get_table_metadata_object_by_path(self):
        table_path = TablePath('db1', 'schema1', 'table1')
        self.assertEqual(self.table_metadata, self.dw_metadata.get_table_by_path(table_path))

    def test_can_get_column_metadata_object_by_path(self):
        column_path = ColumnPath('db1', 'schema1', 'table1', 'col1')
        self.assertEqual(self.column_metadata, self.dw_metadata.get_column_by_path(column_path))


class TestDataWarehouseMetadataGetETLs(unittest.TestCase):

    def setUp(self):
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
                                        'name': 'table1',
                                        'primary_source_table': 'staging.staging_octane.table1',
                                        'step_functions': {
                                            'SP-1': {
                                                'etls': {
                                                    'ETL-1': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert',
                                                        'output_table': 'staging.history_octane.table1'
                                                    }
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2',
                                        'primary_source_table': 'staging.staging_octane.table2',
                                        'step_functions': {
                                            'SP-2': {
                                                'etls': {
                                                    'ETL-2': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update',
                                                        'output_table': 'staging.history_octane.table2'
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
                                                        'output_type': 'insert',
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

        self.expected_etl_1 = ETLMetadata(
            process_name='ETL-1',
            hardcoded_data_source=ETLDataSource.OCTANE,
            input_type=ETLInputType.TABLE,
            output_type=ETLOutputType.INSERT,
            output_table=TablePath(database='staging', schema='history_octane', table='table1'),
            primary_source_table=TablePath(database='staging', schema='staging_octane', table='table1')
        )

        self.expected_etl_2 = ETLMetadata(
            process_name='ETL-2',
            hardcoded_data_source=ETLDataSource.OCTANE,
            input_type=ETLInputType.TABLE,
            output_type=ETLOutputType.INSERT_UPDATE,
            output_table=TablePath(database='staging', schema='history_octane', table='table2'),
            primary_source_table=TablePath(database='staging', schema='staging_octane', table='table2')
        )

        self.expected_etl_3 = ETLMetadata(
            process_name='ETL-3',
            hardcoded_data_source=ETLDataSource.OCTANE,
            input_type=ETLInputType.TABLE,
            output_type=ETLOutputType.INSERT,
            output_table=TablePath(database='ingress', schema='ingress_schema_2', table='table3'),
            primary_source_table=TablePath(database='ingress', schema='ingress_schema_1', table='table3')
        )

    def test_gets_all_etls_when_no_filter_is_supplied(self):
        self.assertEqual([self.expected_etl_1, self.expected_etl_2, self.expected_etl_3], list(self.dw_metadata.get_etls()))

    def test_returns_empty_iterable_if_no_etls_match_condition(self):
        self.assertEqual([], list(self.dw_metadata.get_etls(filter_func=lambda x: False)))

    def test_returns_only_those_etls_matching_the_given_filter(self):
        self.assertEqual(
            [self.expected_etl_2],
            list(self.dw_metadata.get_etls(filter_func=lambda x: x.output_type == ETLOutputType.INSERT_UPDATE))
        )
        self.assertEqual(
            [self.expected_etl_1, self.expected_etl_2],
            list(self.dw_metadata.get_etls(filter_func=lambda x: x.output_table.schema == 'history_octane'))
        )


class TestDatabaseMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_schema_that_doesnt_exist(self):
        db_metadata = DatabaseMetadata('staging')
        with self.assertRaises(InvalidMetadataKeyException):
            db_metadata.get_schema('staging_octane')

    def test_initializes_with_database_path(self):
        db_metadata = DatabaseMetadata('staging')
        self.assertEqual(DatabasePath('staging'), db_metadata.path)

    def test_adding_schema_automatically_updates_schema_path(self):
        db_metadata = DatabaseMetadata('staging')
        schema_metadata = SchemaMetadata('staging_octane')
        db_metadata.add_schema(schema_metadata)
        self.assertEqual(SchemaPath('staging', 'staging_octane'), schema_metadata.path)

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
        db_metadata.remove_schema('staging_octane')
        self.assertEqual([], db_metadata.schemas)

    def test_removing_schema_that_doesnt_exist_does_nothing(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.remove_schema('staging_octane')
        self.assertEqual([], db_metadata.schemas)

    def test_can_indicate_whether_it_contains_a_given_schema_by_name(self):
        db_metadata = DatabaseMetadata('staging')
        db_metadata.add_schema(SchemaMetadata('staging_octane'))
        self.assertTrue(db_metadata.contains_schema('staging_octane'))
        self.assertFalse(db_metadata.contains_schema('history_octane'))


class TestSchemaMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_table_that_doesnt_exist(self):
        schema_metadata = SchemaMetadata('staging_octane')
        with self.assertRaises(InvalidMetadataKeyException):
            schema_metadata.get_table('account')

    def test_initializes_with_schema_path_containing_null_database(self):
        schema_metadata = SchemaMetadata('staging_octane')
        self.assertEqual(SchemaPath(None, 'staging_octane'), schema_metadata.path)

    def test_adding_table_automatically_updates_table_path(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.path.database = 'staging'
        table_metadata = TableMetadata('account')
        schema_metadata.add_table(table_metadata)
        self.assertEqual(TablePath('staging', 'staging_octane', 'account'), table_metadata.path)

    def test_can_get_table_metadata_by_table_name_if_the_table_has_been_added_to_the_metadata(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table(TableMetadata('account'))
        expected = TableMetadata('account')
        expected.path.schema = 'staging_octane'
        self.assertEqual(expected, schema_metadata.get_table('account'))

    def test_can_iterate_through_all_added_tables(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table(TableMetadata('account'))
        schema_metadata.add_table(TableMetadata('deal'))
        schema_metadata.add_table(TableMetadata('loan'))
        expected = [TableMetadata('account'), TableMetadata('deal'), TableMetadata('loan')]
        for table in expected:
            table.path.schema = 'staging_octane'
        self.assertEqual(expected, [table for table in schema_metadata.tables])

    def test_can_remove_table_metadata(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table(TableMetadata('account'))
        schema_metadata.remove_table('account')
        self.assertEqual([], schema_metadata.tables)

    def test_removing_table_that_doesnt_exist_does_nothing(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.remove_table('account')
        self.assertEqual([], schema_metadata.tables)

    def test_can_indicate_whether_it_contains_a_given_table_by_name(self):
        schema_metadata = SchemaMetadata('staging_octane')
        schema_metadata.add_table(TableMetadata('account'))
        self.assertTrue(schema_metadata.contains_table('account'))
        self.assertFalse(schema_metadata.contains_table('deal'))


class TestTableMetadata(unittest.TestCase):

    def test_throws_error_if_user_tries_to_get_column_that_doesnt_exist(self):
        table_metadata = TableMetadata('deal')
        with self.assertRaises(InvalidMetadataKeyException):
            table_metadata.get_column('d_pid')

    def test_initializes_with_table_path_containing_null_database_and_schema(self):
        table_metadata = TableMetadata('deal')
        self.assertEqual(TablePath(None, None, 'deal'), table_metadata.path)

    def test_adding_column_automatically_updates_column_path(self):
        table_metadata = TableMetadata('account')
        table_metadata.path.database = 'staging'
        table_metadata.path.schema = 'staging_octane'
        column_metadata = ColumnMetadata('a_pid')
        table_metadata.add_column(column_metadata)
        self.assertEqual(ColumnPath('staging', 'staging_octane', 'account', 'a_pid'), column_metadata.path)

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
        table_metadata.remove_column('a_pid')
        self.assertEqual([], table_metadata.columns)

    def test_removing_column_that_doesnt_exist_does_nothing(self):
        table_metadata = TableMetadata('account')
        table_metadata.remove_column('a_pid')
        self.assertEqual([], table_metadata.columns)

    def test_can_indicate_whether_it_contains_a_given_column_by_name(self):
        table_metadata = TableMetadata('account')
        table_metadata.add_column(ColumnMetadata('a_pid'))
        self.assertTrue(table_metadata.contains_column('a_pid'))
        self.assertFalse(table_metadata.contains_column('a_version'))

    def test_throws_error_if_user_tries_to_get_step_function_that_doesnt_exist(self):
        table_metadata = TableMetadata('deal')
        with self.assertRaises(InvalidMetadataKeyException):
            table_metadata.get_step_function('SP-100000')

    def test_can_get_step_function_metadata_by_step_function_name_if_the_step_function_has_been_added_to_the_metadata(self):
        table_metadata = TableMetadata('deal')
        table_metadata.add_step_function(StepFunctionMetadata('SP-100000'))
        self.assertEqual(StepFunctionMetadata('SP-100000'), table_metadata.get_step_function('SP-100000'))

    def test_can_iterate_through_all_added_step_functions(self):
        table_metadata = TableMetadata('deal')
        table_metadata.add_step_function(StepFunctionMetadata('SP-100000'))
        table_metadata.add_step_function(StepFunctionMetadata('SP-100001'))
        table_metadata.add_step_function(StepFunctionMetadata('SP-100002'))
        expected = [StepFunctionMetadata('SP-100000'), StepFunctionMetadata('SP-100001'), StepFunctionMetadata('SP-100002')]
        self.assertEqual(expected, [step_function for step_function in table_metadata.step_functions])

    def test_can_remove_step_function_metadata(self):
        table_metadata = TableMetadata('account')
        table_metadata.add_step_function(StepFunctionMetadata('SP-100123'))
        table_metadata.remove_step_function('SP-100123')
        self.assertEqual([], table_metadata.step_functions)

    def test_removing_step_function_that_doesnt_exist_does_nothing(self):
        table_metadata = TableMetadata('account')
        table_metadata.remove_step_function('SP-100123')
        self.assertEqual([], table_metadata.step_functions)

    def test_can_indicate_whether_it_contains_a_given_etl_by_name(self):
        table_metadata = TableMetadata('account')
        table_metadata.add_step_function(StepFunctionMetadata('SP-1'))
        self.assertTrue(table_metadata.contains_step_function('SP-1'))
        self.assertFalse(table_metadata.contains_step_function('SP-2'))

    def test_throws_error_if_user_tries_to_get_foreign_key_that_doesnt_exist(self):
        table_metadata = TableMetadata('deal')
        with self.assertRaises(InvalidMetadataKeyException):
            table_metadata.get_foreign_key('fk_0')

    def test_can_get_foreign_key_metadata_by_foreign_key_name_if_the_foreign_key_has_been_added_to_the_metadata(self):
        table_metadata = TableMetadata('deal')
        proposal_address = TablePath('staging', 'staging_octane', 'proposal')
        table_metadata.add_foreign_key(ForeignKeyMetadata('fk_0', proposal_address, [], []))
        self.assertEqual(ForeignKeyMetadata('fk_0', proposal_address, [], []), table_metadata.get_foreign_key('fk_0'))

    def test_can_iterate_through_all_added_foreign_keys(self):
        table_metadata = TableMetadata('deal')
        proposal_address = TablePath('staging', 'staging_octane', 'proposal')
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
            table=TablePath('db', 'schema', 'table'),
            native_columns=[],
            foreign_columns=[]
        ))
        table_metadata.remove_foreign_key('fk_1')
        self.assertEqual([], table_metadata.foreign_keys)

    def test_removing_foreign_key_that_doesnt_exist_does_nothing(self):
        table_metadata = TableMetadata('account')
        table_metadata.remove_foreign_key('fk_1')
        self.assertEqual([], table_metadata.foreign_keys)

    def test_can_indicate_whether_it_contains_a_given_foreign_key_by_name(self):
        table_metadata = TableMetadata('account')
        table_metadata.add_foreign_key(ForeignKeyMetadata('fk1', TablePath('db', 'sch', 't'), [], []))
        self.assertTrue(table_metadata.contains_foreign_key('fk1'))
        self.assertFalse(table_metadata.contains_foreign_key('fk2'))


class TestStepFunctionMetadata(unittest.TestCase):

    def test_trying_to_get_a_nonexistent_etl_throws_an_error(self):
        step_function = StepFunctionMetadata('SP-1')
        with self.assertRaises(InvalidMetadataKeyException):
            step_function.get_etl('ETL-1')

    def test_can_get_etl_that_was_previously_added(self):
        step_function = StepFunctionMetadata('SP-1')
        etl = ETLMetadata(process_name='ETL-1')
        step_function.add_etl(etl)
        self.assertEqual(etl, step_function.get_etl('ETL-1'))

    def test_can_get_list_of_all_previously_added_etls(self):
        step_function = StepFunctionMetadata('SP-1')
        etl1 = ETLMetadata(process_name='ETL-1')
        step_function.add_etl(etl1)
        etl2 = ETLMetadata(process_name='ETL-2')
        step_function.add_etl(etl2)
        self.assertEqual([etl1, etl2], step_function.etls)

    def test_trying_to_get_a_removed_etl_throws_an_error(self):
        step_function = StepFunctionMetadata('SP-1')
        etl = ETLMetadata(process_name='ETL-1')
        step_function.add_etl(etl)
        step_function.remove_etl('ETL-1')
        with self.assertRaises(InvalidMetadataKeyException):
            step_function.get_etl('ETL-1')

    def test_list_of_all_etls_does_not_include_removed_etls(self):
        step_function = StepFunctionMetadata('SP-1')
        etl1 = ETLMetadata(process_name='ETL-1')
        step_function.add_etl(etl1)
        etl2 = ETLMetadata(process_name='ETL-2')
        step_function.add_etl(etl2)
        step_function.remove_etl('ETL-1')
        self.assertEqual([etl2], step_function.etls)

    def test_trying_to_remove_a_nonexistent_etl_does_nothing(self):
        step_function = StepFunctionMetadata('SP-1')
        step_function.remove_etl('ETL-1')
        # expect no error to be thrown

    def test_has_parallel_limit_returns_false_if_limit_is_none_and_true_otherwise(self):
        step_function = StepFunctionMetadata('SP-1')
        self.assertFalse(step_function.has_parallel_limit)
        step_function.parallel_limit = 20
        self.assertTrue(step_function.has_parallel_limit)

    def test_has_etl_returns_true_if_step_function_contains_etl_and_false_otherwise(self):
        step_function = StepFunctionMetadata('SP-1')
        self.assertFalse(step_function.has_etl('ETL-1'))

        etl1 = ETLMetadata(process_name='ETL-1')
        step_function.add_etl(etl1)
        self.assertTrue(step_function.has_etl('ETL-1'))

        step_function.remove_etl('ETL-1')
        self.assertFalse(step_function.has_etl('ETL-1'))


class TestTableMetadataCanGetColumnSourcePaths(unittest.TestCase):

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
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.source_column'
                                                }
                                            },
                                            'column_with_distant_source': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.foreign_keys.fk_1.foreign_keys.fk_2.foreign_keys.fk_3.columns.distant_source_column'
                                                }
                                            },
                                            'column_with_single_column_calculated_source': {
                                                'data_type': 'BOOLEAN',
                                                'source': {
                                                    'calculation': {
                                                        'string': '$1 IS NOT NULL',
                                                        'using': [
                                                            'primary_source_table.foreign_keys.fk_1.foreign_keys.fk_2.foreign_keys.fk_3.columns.distant_source_column']
                                                    }
                                                }
                                            },
                                            'column_with_multi_column_calculated_source': {
                                                'data_type': 'BOOLEAN',
                                                'source': {
                                                    'calculation': {
                                                        'string': '$1 IS NOT NULL AND $2 IS NOT NULL',
                                                        'using': ['primary_source_table.columns.source_column',
                                                                  'primary_source_table.foreign_keys.fk_1.foreign_keys.fk_2.foreign_keys.fk_3.columns.distant_source_column']
                                                    }
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
                                                'data_type': 'TEXT'
                                            },
                                            'fk_col': {
                                                'data_type': 'TEXT'
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
                                                'data_type': 'TEXT'
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
                                                'data_type': 'TEXT'
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
                                                'data_type': 'TEXT'
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

    def test_empty_source_column_paths_list_if_column_has_no_source(self):
        table_address = TablePath('staging', 'staging_octane', 'source_table')
        table = self.dw_metadata.get_table_by_path(table_address)
        self.assertEqual([], table.get_source_column_paths('source_column', self.dw_metadata))

    def test_retrieves_source_column_metadata_if_there_are_no_fk_steps(self):
        table_address = TablePath('staging', 'history_octane', 'table_with_source')
        table = self.dw_metadata.get_table_by_path(table_address)
        source_column_addresses = [ColumnPath('staging', 'staging_octane', 'source_table', 'source_column')]
        fetched_source_column_paths = table.get_source_column_paths('column_with_source', self.dw_metadata)
        self.assertEqual(source_column_addresses, fetched_source_column_paths)

    def test_follows_fk_steps_to_retrieve_distant_source_column_metadata(self):
        table_address = TablePath('staging', 'history_octane', 'table_with_source')
        table = self.dw_metadata.get_table_by_path(table_address)
        source_column_addresses = [ColumnPath('staging', 'other_schema', 'distant_source_table', 'distant_source_column')]
        fetched_source_column_paths = table.get_source_column_paths('column_with_distant_source', self.dw_metadata)
        self.assertEqual(source_column_addresses, fetched_source_column_paths)

    def test_follows_calculation_fk_steps_to_retrieve_distant_source_column_metadata(self):
        table_address = TablePath('staging', 'history_octane', 'table_with_source')
        table = self.dw_metadata.get_table_by_path(table_address)
        source_column_addresses = [ColumnPath('staging', 'other_schema', 'distant_source_table', 'distant_source_column')]
        fetched_source_column_paths = table.get_source_column_paths('column_with_single_column_calculated_source', self.dw_metadata)
        self.assertEqual(source_column_addresses, fetched_source_column_paths)

    def test_follows_calculation_fk_steps_to_retrieve_multi_source_column_metadata(self):
        table_address = TablePath('staging', 'history_octane', 'table_with_source')
        table = self.dw_metadata.get_table_by_path(table_address)
        source_column_addresses = [ColumnPath('staging', 'staging_octane', 'source_table', 'source_column'),
                                   ColumnPath('staging', 'other_schema', 'distant_source_table', 'distant_source_column')]
        fetched_source_column_paths = table.get_source_column_paths('column_with_multi_column_calculated_source', self.dw_metadata)
        self.assertEqual(source_column_addresses, fetched_source_column_paths)


if __name__ == '__main__':
    unittest.main()
