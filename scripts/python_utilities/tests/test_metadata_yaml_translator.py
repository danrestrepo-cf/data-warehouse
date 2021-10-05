import unittest
import context
import pathlib
import os
import shutil
import yaml

from metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from data_warehouse_metadata import (DataWarehouseMetadata,
                                     DatabaseMetadata,
                                     SchemaMetadata,
                                     TableMetadata,
                                     ColumnMetadata,
                                     ETLMetadata,
                                     ForeignKeyMetadata,
                                     ForeignColumnPath,
                                     TableAddress,
                                     ETLDataSource,
                                     ETLInputType,
                                     ETLOutputType,
                                     InvalidMetadataKeyException)

test_dir = os.path.dirname(os.path.abspath(__file__))


def write_yaml(data: dict, output_file_path: str):
    with open(output_file_path, 'w') as output_file:
        yaml.dump(data, output_file, default_flow_style=False, sort_keys=False)


class TestThrowErrorIfRootDirDoesntExist(unittest.TestCase):
    def test_throws_error_if_root_dir_doesnt_exist(self):
        with self.assertRaises(FileNotFoundError):
            generate_data_warehouse_metadata_from_yaml('nonexistant_dir_12345')


class TestGenerateEmptyDataWarehouse(unittest.TestCase):

    def setUp(self) -> None:
        self.root_filepath = os.path.join(test_dir, 'empty_test_dw')
        os.mkdir(self.root_filepath)

    def test_generates_empty_data_warehouse_metadata_when_given_empty_dir(self):
        expected = DataWarehouseMetadata('empty_test_dw')
        self.assertEqual(expected, generate_data_warehouse_metadata_from_yaml(self.root_filepath))

    def tearDown(self) -> None:
        if os.path.isdir(self.root_filepath):
            shutil.rmtree(self.root_filepath)


class TestGenerateDataWarehouseWithEmptyDatabases(unittest.TestCase):

    def setUp(self) -> None:
        self.root_filepath = os.path.join(test_dir, 'dw')
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.db2_filepath = os.path.join(self.root_filepath, 'db.db2')
        self.unrelated_file_filepath = os.path.join(self.root_filepath, 'db.something.txt')
        os.mkdir(self.root_filepath)
        os.mkdir(self.db1_filepath)
        os.mkdir(self.db2_filepath)
        pathlib.Path(self.unrelated_file_filepath).touch()

    def test_generates_empty_database_metadata_when_given_empty_dir(self):
        expected = DataWarehouseMetadata('dw')
        expected.add_database(DatabaseMetadata('db1'))
        expected.add_database(DatabaseMetadata('db2'))
        self.assertEqual(expected, generate_data_warehouse_metadata_from_yaml(self.root_filepath))

    def tearDown(self) -> None:
        if os.path.isdir(self.root_filepath):
            shutil.rmtree(self.root_filepath)


class TestGenerateDataWarehouseWithEmptySchemas(unittest.TestCase):

    def setUp(self) -> None:
        self.root_filepath = os.path.join(test_dir, 'dw')
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.sch2_filepath = os.path.join(self.db1_filepath, 'schema.sch2')
        self.unrelated_file_filepath = os.path.join(self.db1_filepath, 'schema.something.txt')
        os.mkdir(self.root_filepath)
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

    def tearDown(self) -> None:
        if os.path.isdir(self.root_filepath):
            shutil.rmtree(self.root_filepath)


class TestThrowErrorIfYAMLFileIsUnparsable(unittest.TestCase):

    def setUp(self) -> None:
        self.root_filepath = os.path.join(test_dir, 'dw')
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.table1_filepath = os.path.join(self.sch1_filepath, 'table.table1.yaml')
        os.mkdir(self.root_filepath)
        os.mkdir(self.db1_filepath)
        os.mkdir(self.sch1_filepath)
        with open(self.table1_filepath, 'w') as file:
            file.write('sdfj98fjfj98j3\n\n\tjf984j9!!~````')

    def test_throws_error_if_yaml_file_is_unparsable(self):
        with self.assertRaises(yaml.YAMLError):
            generate_data_warehouse_metadata_from_yaml(self.root_filepath)

    def tearDown(self) -> None:
        if os.path.isdir(self.root_filepath):
            shutil.rmtree(self.root_filepath)


class TestGenerateDataWarehouseWithMinimalYAMLFiles(unittest.TestCase):

    def setUp(self) -> None:
        self.root_filepath = os.path.join(test_dir, 'dw')
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.table1_filepath = os.path.join(self.sch1_filepath, 'table.table1.yaml')
        self.table2_filepath = os.path.join(self.sch1_filepath, 'table.table2.yaml')
        os.mkdir(self.root_filepath)
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

    def tearDown(self) -> None:
        if os.path.isdir(self.root_filepath):
            shutil.rmtree(self.root_filepath)


class TestGenerateDataWarehouseWithFullYAMLFile(unittest.TestCase):

    def setUp(self) -> None:
        self.root_filepath = os.path.join(test_dir, 'dw')
        self.db1_filepath = os.path.join(self.root_filepath, 'db.db1')
        self.sch1_filepath = os.path.join(self.db1_filepath, 'schema.sch1')
        self.table1_filepath = os.path.join(self.sch1_filepath, 'table.table1.yaml')
        os.mkdir(self.root_filepath)
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
        write_yaml(table1_metadata, self.table1_filepath)
        self.metadata = generate_data_warehouse_metadata_from_yaml(self.root_filepath)
        self.table1_metadata = self.metadata.get_database('db1').get_schema('sch1').get_table('table1')

    def test_parses_simple_attributes_correctly(self):
        self.assertEqual(TableAddress('db1', 'sch2', 'table01'), self.table1_metadata.primary_source_table)
        self.assertEqual(['col1', 'col2'], self.table1_metadata.primary_key)
        self.assertEqual(['SP-201', 'SP-202'], self.table1_metadata.next_etls)

    def test_parses_foreign_keys_into_ForeignKeyMetadata_objects(self):
        expected = [
            ForeignKeyMetadata('fk_1', TableAddress('db1', 'sch1', 'table2'), ['col1', 'col2'], ['t2_col1', 't2_col2']),
            ForeignKeyMetadata('fk_2', TableAddress('db1', 'sch3', 'table12'), ['col3'], ['t12_col7'])
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

    def tearDown(self) -> None:
        if os.path.isdir(self.root_filepath):
            shutil.rmtree(self.root_filepath)


if __name__ == '__main__':
    unittest.main()
