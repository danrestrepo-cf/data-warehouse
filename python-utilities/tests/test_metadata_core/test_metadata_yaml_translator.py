import unittest
import pathlib
import os
import shutil
import yaml

from lib.metadata_core.metadata_yaml_translator import (generate_data_warehouse_metadata_from_yaml,
                                                        write_data_warehouse_metadata_to_yaml,
                                                        construct_data_warehouse_metadata_from_dict,
                                                        DictToMetadataBuilder,
                                                        filter_out_dict_keys_with_no_value)
from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       DatabaseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ColumnMetadata,
                                                       ETLMetadata,
                                                       ForeignKeyMetadata,
                                                       ForeignColumnPath,
                                                       ETLDataSource,
                                                       ETLInputType,
                                                       ETLOutputType)
from lib.metadata_core.metadata_object_path import TablePath

test_dir = os.path.dirname(os.path.abspath(__file__))


def write_yaml(data: dict, output_file_path: str):
    with open(output_file_path, 'w') as output_file:
        yaml.dump(data, output_file, default_flow_style=False, sort_keys=False)


class MetadataDirectoryTestCase(unittest.TestCase):
    """A test utility class containing standardized logic for created and destroying a test data warehouse metadata directory structure"""

    def setUp(self) -> None:
        self.root_filepath = os.path.join(test_dir, 'dw')
        os.mkdir(self.root_filepath)

    def tearDown(self) -> None:
        if os.path.isdir(self.root_filepath):
            shutil.rmtree(self.root_filepath)


class TestThrowErrorIfRootDirDoesntExist(unittest.TestCase):
    def test_throws_error_if_root_dir_doesnt_exist(self):
        with self.assertRaises(FileNotFoundError):
            generate_data_warehouse_metadata_from_yaml('nonexistant_dir_12345')


class TestGenerateEmptyDataWarehouse(MetadataDirectoryTestCase):

    def test_generates_empty_data_warehouse_metadata_when_given_empty_dir(self):
        expected = DataWarehouseMetadata('dw')
        self.assertEqual(expected, generate_data_warehouse_metadata_from_yaml(self.root_filepath))


class TestGenerateDataWarehouseWithEmptyDatabases(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.db2_filepath = os.path.join(self.root_filepath, 'db.db2')
        self.unrelated_file_filepath = os.path.join(self.root_filepath, 'db.something.txt')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.db2_filepath)
        pathlib.Path(self.unrelated_file_filepath).touch()

    def test_generates_empty_database_metadata_when_given_empty_dir(self):
        expected = DataWarehouseMetadata('dw')
        expected.add_database(DatabaseMetadata('db1'))
        expected.add_database(DatabaseMetadata('db2'))
        self.assertEqual(expected, generate_data_warehouse_metadata_from_yaml(self.root_filepath))


class TestGenerateDataWarehouseWithEmptySchemas(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.sch2_filepath = os.path.join(self.db1_filepath, 'schema.sch2')
        self.unrelated_file_filepath = os.path.join(self.db1_filepath, 'schema.something.txt')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        os.mkdir(self.sch2_filepath)
        pathlib.Path(self.unrelated_file_filepath).touch()

    def test_generates_empty_schema_metadata_when_given_empty_dir(self):
        expected = DataWarehouseMetadata('dw')
        db1 = DatabaseMetadata('db1')
        expected.add_database(db1)
        db1.add_schema(SchemaMetadata('sch1'))
        db1.add_schema(SchemaMetadata('sch2'))
        self.assertEqual(expected, generate_data_warehouse_metadata_from_yaml(self.root_filepath))


class TestThrowErrorIfYAMLFileIsUnparsable(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.table1_filepath = os.path.join(self.sch1_filepath, 'table.table1.yaml')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        with open(self.table1_filepath, 'w') as file:
            file.write('sdfj98fjfj98j3\n\n\tjf984j9!!~````')

    def test_throws_error_if_yaml_file_is_unparsable(self):
        with self.assertRaises(yaml.YAMLError):
            generate_data_warehouse_metadata_from_yaml(self.root_filepath)


class TestGenerateDataWarehouseWithMinimalYAMLFiles(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.table1_filepath = os.path.join(self.sch1_filepath, 'table.table1.yaml')
        self.table2_filepath = os.path.join(self.sch1_filepath, 'table.table2.yaml')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        write_yaml({'name': 'table1'}, self.table1_filepath)
        write_yaml({'name': 'table2'}, self.table2_filepath)

    def test_generates_minimal_table_given_minimal_table_yaml(self):
        expected = DataWarehouseMetadata('dw')
        db1 = DatabaseMetadata('db1')
        expected.add_database(db1)
        sch1 = SchemaMetadata('sch1')
        db1.add_schema(sch1)
        sch1.add_table(TableMetadata('table1'))
        sch1.add_table(TableMetadata('table2'))
        self.assertEqual(expected, generate_data_warehouse_metadata_from_yaml(self.root_filepath))


class TestGenerateDataWarehouseWithFullYAMLFile(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.table1_filepath = os.path.join(self.sch1_filepath, 'table.table1.yaml')
        self.table2_filepath = os.path.join(self.sch1_filepath, 'table.table2.yaml')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        table1_metadata = {
            'name': 'table1',
            'primary_source_table': 'db1.sch2.table01',
            'primary_key': [
                'col1',
                'col2'
            ],
            'foreign_keys': {
                'fk_1': {
                    'columns': [
                        'col1',
                        'col2'
                    ],
                    'references': {
                        'columns': [
                            't2_col1',
                            't2_col2'
                        ],
                        'schema': 'sch1',
                        'table': 'table2'
                    }
                },
                'fk_2': {
                    'columns': [
                        'col3'
                    ],
                    'references': {
                        'columns': [
                            't12_col7'
                        ],
                        'schema': 'sch3',
                        'table': 'table12'
                    }
                }
            },
            'columns': {
                'col1': {
                    'data_type': 'BIGINT',
                    'source': {
                        'field': 'primary_source_table.columns.t01_col1'
                    }
                },
                'col2': {
                    'data_type': 'BIGINT',
                    'source': {
                        'field': 'primary_source_table.columns.t01_col2'
                    }
                },
                'col3': {
                    'data_type': 'VARCHAR(16)',
                    'source': {
                        'field': 'primary_source_table.foreign_keys.fk_1.foreign_keys.fk_3.columns.distant_col1'
                    }
                }
            },
            'etls': {
                'SP-101': {
                    'hardcoded_data_source': 'Octane',
                    'input_type': 'table',
                    'output_type': 'insert',
                    'json_output_field': 'col1',
                    'truncate_table': False,
                    'insert_update_keys': [
                        'col1',
                        'col2'
                    ],
                    'delete_keys': [
                        'col1',
                        'col2'
                    ],
                    'input_sql': 'SELECT * FROM sch1.table01;',
                },
                'SP-102': {
                    'hardcoded_data_source': 'Octane',
                    'input_type': 'table',
                    'output_type': 'insert',
                    'json_output_field': 'col2',
                    'truncate_table': True,
                    'insert_update_keys': [
                        'col3'
                    ],
                    'delete_keys': [
                        'col2'
                    ],
                    'input_sql': 'SELECT * FROM sch1.table02;',
                }
            },
            'next_etls': [
                'SP-201',
                'SP-202'
            ]
        }
        table2_metadata = {
            'name': 'table2',
            'columns': {
                'col0': {}
            },
            'etls': {
                'SP-100': {
                    'input_type': 'table',
                    'output_type': 'insert'
                }
            }
        }
        write_yaml(table1_metadata, self.table1_filepath)
        write_yaml(table2_metadata, self.table2_filepath)
        self.metadata = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.table1_metadata = self.metadata.get_database('db1').get_schema('sch1').get_table('table1')
        self.table2_metadata = self.metadata.get_database('db1').get_schema('sch1').get_table('table2')

    def test_translates_missing_keys_into_null_values(self):
        expected_cols = [ColumnMetadata(name='col0', data_type=None, source_field=None)]
        expected_etls = [ETLMetadata(
            process_name='SP-100',
            hardcoded_data_source=None,
            input_type=ETLInputType.TABLE,
            output_type=ETLOutputType.INSERT,
            json_output_field=None,
            truncate_table=None,
            insert_update_keys=None,
            delete_keys=None,
            input_sql=None
        )]
        self.assertEqual(expected_cols, self.table2_metadata.columns)
        self.assertEqual(expected_etls, self.table2_metadata.etls)

    def test_parses_simple_attributes_correctly(self):
        self.assertEqual(TablePath('db1', 'sch2', 'table01'), self.table1_metadata.primary_source_table)
        self.assertEqual('db1', self.table1_metadata.path.database)
        self.assertEqual('sch1', self.table1_metadata.path.schema)
        self.assertEqual(['col1', 'col2'], self.table1_metadata.primary_key)
        self.assertEqual(['SP-201', 'SP-202'], self.table1_metadata.next_etls)

    def test_parses_foreign_keys_into_ForeignKeyMetadata_objects(self):
        expected = [
            ForeignKeyMetadata('fk_1', TablePath('db1', 'sch1', 'table2'), ['col1', 'col2'], ['t2_col1', 't2_col2']),
            ForeignKeyMetadata('fk_2', TablePath('db1', 'sch3', 'table12'), ['col3'], ['t12_col7'])
        ]
        self.assertEqual(expected, self.table1_metadata.foreign_keys)

    def test_parses_columns_into_ColumnMetadata_objects(self):
        expected = [
            ColumnMetadata('col1', 'BIGINT', ForeignColumnPath([], 't01_col1')),
            ColumnMetadata('col2', 'BIGINT', ForeignColumnPath([], 't01_col2')),
            ColumnMetadata('col3', 'VARCHAR(16)', ForeignColumnPath(['fk_1', 'fk_3'], 'distant_col1'))
        ]
        self.assertEqual(expected, self.table1_metadata.columns)

    def test_parses_etls_into_ETLMetadata_objects(self):
        expected = [
            ETLMetadata(
                process_name='SP-101',
                hardcoded_data_source=ETLDataSource.OCTANE,
                input_type=ETLInputType.TABLE,
                output_type=ETLOutputType.INSERT,
                json_output_field='col1',
                truncate_table=False,
                insert_update_keys=[
                    'col1',
                    'col2'
                ],
                delete_keys=[
                    'col1',
                    'col2'
                ],
                input_sql='SELECT * FROM sch1.table01;'
            ),
            ETLMetadata(
                process_name='SP-102',
                hardcoded_data_source=ETLDataSource.OCTANE,
                input_type=ETLInputType.TABLE,
                output_type=ETLOutputType.INSERT,
                json_output_field='col2',
                truncate_table=True,
                insert_update_keys=[
                    'col3'
                ],
                delete_keys=[
                    'col2'
                ],
                input_sql='SELECT * FROM sch1.table02;'
            )
        ]
        self.assertEqual(expected, self.table1_metadata.etls)


class TestGenerateDataWarehouseWithInvalidForeignKeyFields(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.bad_fk_fields_table_filepath = os.path.join(self.sch1_filepath, 'table.bad_fk_fields.yaml')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        write_yaml({'name': 'bad_fk_fields', 'foreign_keys': {'fk_1': {}}}, self.bad_fk_fields_table_filepath)

    def test_throws_error_if_fk_doesnt_have_all_required_fields(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            generate_data_warehouse_metadata_from_yaml(self.root_filepath)


class TestGenerateDataWarehouseWithInvalidETLFields(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.bad_etl_fields_table_filepath = os.path.join(self.sch1_filepath, 'table.bad_etl_fields.yaml')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        write_yaml({'name': 'bad_etl_fields', 'etls': {'SP-100': {}}}, self.bad_etl_fields_table_filepath)

    def test_throws_error_if_etl_doesnt_have_all_required_fields(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            generate_data_warehouse_metadata_from_yaml(self.root_filepath)


class TestGenerateDataWarehouseWithInvalidPrimarySourceTable(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.bad_pst_table_filepath = os.path.join(self.sch1_filepath, 'table.bad_pst.yaml')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        write_yaml({'name': 'bad_pst', 'primary_source_table': 'a_table'}, self.bad_pst_table_filepath)

    def test_throws_error_if_primary_source_table_has_an_incorrect_format(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            generate_data_warehouse_metadata_from_yaml(self.root_filepath)


class TestParseForeignColumnPath(unittest.TestCase):

    def test_throws_error_if_path_is_none(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_foreign_column_path(None)

    def test_throws_error_if_path_doesnt_start_with_primary_source_table(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_foreign_column_path('')

    def test_throws_error_if_path_has_odd_number_of_periods(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_foreign_column_path('primary_source_table.foreign_keys.fk_1.foreign_keys')

    def test_throws_error_if_path_contains_an_invalid_keyword(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_foreign_column_path('primary_source_table.strange_keys.fk_1')

    def test_throws_error_if_the_destination_column_appears_in_the_path_before_its_end(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_foreign_column_path('primary_source_table.columns.col1.foreign_keys.fk_2')

    def test_throws_error_if_the_path_contains_no_destination_column(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_foreign_column_path('primary_source_table.foreign_keys.fk_2')

    def test_correctly_parses_valid_path(self):
        expected = ForeignColumnPath(['fk_1', 'fk_2', 'fk_3'], 'col')
        test_path = 'primary_source_table.foreign_keys.fk_1.foreign_keys.fk_2.foreign_keys.fk_3.columns.col'
        self.assertEqual(expected, DictToMetadataBuilder().parse_foreign_column_path(test_path))


class TestParseETLEnumParsers(unittest.TestCase):

    def test_throws_error_if_data_source_is_invalid(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_etl_data_source('invalid_data_source')

    def test_throws_error_if_input_type_is_invalid(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_etl_input_type('invalid_input_type')

    def test_throws_error_if_output_type_is_invalid(self):
        with self.assertRaises(DictToMetadataBuilder.InvalidTableMetadataException):
            DictToMetadataBuilder().parse_etl_output_type('invalid_input_type')


class TestWriteDataWarehouseMetadataToYAML_NoExistingDirectoryStructure(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        # intentionally don't call super().setUp() so root dir is not created yet
        self.root_filepath = os.path.join(test_dir, 'dw')

    def test_creates_full_directory_structure_if_one_doesnt_exist_at_the_specified_output_location(self):
        metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'dw',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'sch1',
                                'tables': [
                                    {
                                        'name': 't1',
                                        'primary_source_table': 'db2.sch2.t2',
                                        'primary_key': [
                                            'col1', 'col2'
                                        ],
                                        'foreign_keys': {
                                            'fk1': {
                                                'columns': ['col3'],
                                                'references': {
                                                    'columns': ['col3'],
                                                    'schema': 'sch2',
                                                    'table': 't2'
                                                }
                                            },
                                            'fk2': {
                                                'columns': ['col2', 'col4'],
                                                'references': {
                                                    'columns': ['col7', 'col4'],
                                                    'schema': 'sch3',
                                                    'table': 't3'
                                                }
                                            }
                                        },
                                        'columns': {
                                            'col1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.foreign_keys.fk3.foreign_keys.fk67.columns.col1'
                                                }
                                            },
                                            'col2': {
                                                'data_type': 'INT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.col2'
                                                }
                                            },
                                            'col3': {
                                                'data_type': 'INT'
                                            },
                                            'col4': {
                                                'data_type': 'INT'
                                            }
                                        },
                                        'etls': {
                                            'SP-1': {
                                                'hardcoded_data_source': 'Octane',
                                                'input_type': 'table',
                                                'output_type': 'insert',
                                                'json_output_field': 'col1',
                                                'truncate_table': False,
                                                'insert_update_keys': ['col1', 'col2'],
                                                'delete_keys': ['col2', 'col3'],
                                                'input_sql': 'SQL for SP-1'
                                            }
                                        },
                                        'next_etls': [
                                            'SP-4', 'SP-5'
                                        ]
                                    }
                                ]
                            }
                        ]
                    },
                    {
                        'name': 'db2',
                        'schemas': [
                            {
                                'name': 'sch2',
                                'tables': [
                                    {
                                        'name': 't2'
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        )
        write_data_warehouse_metadata_to_yaml(test_dir, metadata)
        result = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.assertEqual(metadata, result)


class TestWriteDataWarehouseMetadataToYAML_ExistingDirectoriesAndFiles(MetadataDirectoryTestCase):

    def setUp(self) -> None:
        super().setUp()
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.db2_filepath = os.path.join(self.root_filepath, 'db.db2')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.sch2_filepath = os.path.join(self.db1_filepath, 'schema.sch2')
        self.sch3_filepath = os.path.join(self.db2_filepath, 'schema.sch3')
        self.t1_filepath = os.path.join(self.sch1_filepath, 'table.t1.yaml')
        self.t2_filepath = os.path.join(self.sch1_filepath, 'table.t2.yaml')
        self.v1_filepath = os.path.join(self.sch1_filepath, 'view.v1.yaml')
        self.t3_filepath = os.path.join(self.sch2_filepath, 'table.t3.yaml')
        os.mkdir(self.db1_filepath)
        os.mkdir(self.db2_filepath)
        os.mkdir(self.sch1_filepath)
        os.mkdir(self.sch2_filepath)
        os.mkdir(self.sch3_filepath)
        write_yaml({'name': 't1'}, self.t1_filepath)
        write_yaml({'name': 't2'}, self.t2_filepath)
        write_yaml({'name': 'v1'}, self.v1_filepath)
        write_yaml({'name': 't3'}, self.t3_filepath)

        self.original_metadata_read_from_files = generate_data_warehouse_metadata_from_yaml(self.root_filepath)

        self.metadata_to_write = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'dw',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'sch1',
                                'tables': [
                                    {
                                        'name': 't1',
                                        'primary_key': ['col1']
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        )

    def test_doesnt_rebuild_any_directories_by_default(self):
        write_data_warehouse_metadata_to_yaml(test_dir, self.metadata_to_write)
        expected = self.original_metadata_read_from_files
        expected.get_table_by_path(TablePath('db1', 'sch1', 't1')).primary_key.append('col1')
        result = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.assertEqual(expected, result)

    def test_rebuilds_entire_data_warehouse_directory_structure_if_relevant_option_is_set_to_true(self):
        write_data_warehouse_metadata_to_yaml(test_dir, self.metadata_to_write, rebuild_data_warehouse_dir=True)
        result = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.assertEqual(self.metadata_to_write, result)

    def test_rebuilds_databases_dirs_for_the_included_databases_if_relevant_option_is_set_to_true(self):
        write_data_warehouse_metadata_to_yaml(test_dir, self.metadata_to_write, rebuild_database_dirs=True)
        expected = self.original_metadata_read_from_files
        expected.get_table_by_path(TablePath('db1', 'sch1', 't1')).primary_key.append('col1')
        expected.get_database('db1').remove_schema_metadata('sch2')
        expected.get_database('db1').get_schema('sch1').remove_table_metadata('t2')
        result = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.assertEqual(expected, result)

    def test_rebuilds_schema_dirs_for_the_included_schemas_if_relevant_option_is_set_to_true(self):
        write_data_warehouse_metadata_to_yaml(test_dir, self.metadata_to_write, rebuild_schema_dirs=True)
        expected = self.original_metadata_read_from_files
        expected.get_table_by_path(TablePath('db1', 'sch1', 't1')).primary_key.append('col1')
        expected.get_database('db1').get_schema('sch1').remove_table_metadata('t2')
        result = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.assertEqual(expected, result)

    def test_rebuilds_table_files_for_the_included_schemas_if_relevant_option_is_set_to_true(self):
        write_data_warehouse_metadata_to_yaml(test_dir, self.metadata_to_write, rebuild_table_files=True)
        expected = self.original_metadata_read_from_files
        expected.get_table_by_path(TablePath('db1', 'sch1', 't1')).primary_key.append('col1')
        expected.get_database('db1').get_schema('sch1').remove_table_metadata('t2')
        result = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.assertEqual(expected, result)
        self.assertTrue(os.path.exists(self.v1_filepath))


class TestFilterOutDictKeysWithNoValue(unittest.TestCase):

    def test_filters_out_nulls_and_empty_lists_and_empty_dicts_at_the_top_level(self):
        input_dict = {
            'a': 'value',
            'b': None,
            'c': [],
            'd': {}
        }
        expected = {'a': 'value'}
        self.assertEqual(expected, filter_out_dict_keys_with_no_value(input_dict))

    def test_recursively_filters_out_nulls_and_empty_lists_and_empty_dicts_at_any_depth(self):
        input_dict = {
            'a': 'value',
            'b': None,
            'c': {
                'd': {
                    'e': [],
                    'f': 1
                },
                'g': {}
            }
        }
        expected = {
            'a': 'value',
            'c': {
                'd': {
                    'f': 1
                }
            }
        }
        self.assertEqual(expected, filter_out_dict_keys_with_no_value(input_dict))


if __name__ == '__main__':
    unittest.main()
