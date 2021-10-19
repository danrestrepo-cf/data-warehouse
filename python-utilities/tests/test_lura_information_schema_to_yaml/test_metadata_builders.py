import unittest

from lib.lura_information_schema_to_yaml.metadata_builders import StagingOctaneMetadataBuilder
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


class TestStagingOctaneMetadataBuilder(unittest.TestCase):

    def test_creates_staging_octane_data_warehouse_metadata_object_with_only_one_database_and_schema(self):
        builder = StagingOctaneMetadataBuilder(column_metadata=[], foreign_key_metadata=[])
        result = builder.build_metadata()
        self.assertEqual('edw', result.name)
        self.assertEqual(['staging'], [database.name for database in result.databases])
        self.assertEqual(['staging_octane'], [schema.name for schema in result.get_database('staging').schemas])

    def test_creates_one_table_metadata_object_per_unique_table_name_in_column_metadata(self):
        column_metadata = [
            {
                'table_name': 't1',
                'column_name': 'c1',
                'column_type': 'TEXT',
                'is_primary_key': 1
            },
            {
                'table_name': 't1',
                'column_name': 'c2',
                'column_type': 'INT(64)',
                'is_primary_key': 0
            },
            {
                'table_name': 't2',
                'column_name': 'c1',
                'column_type': 'TEXT',
                'is_primary_key': 1
            }
        ]
        builder = StagingOctaneMetadataBuilder(column_metadata=column_metadata, foreign_key_metadata=[])
        result = builder.build_metadata()
        self.assertEqual(['t1', 't2'], [table.name for table in result.get_database('staging').get_schema('staging_octane').tables])

    def test_populates_primary_key_and_foreign_key_and_column_metadata_for_each_table(self):
        column_metadata = [
            {
                'table_name': 't1',
                'column_name': 'c1',
                'column_type': 'TEXT',
                'is_primary_key': 1
            },
            {
                'table_name': 't1',
                'column_name': 'c2',
                'column_type': 'INT(64)',
                'is_primary_key': 0
            },
            {
                'table_name': 't2',
                'column_name': 'c1',
                'column_type': 'TEXT',
                'is_primary_key': 1
            }
        ]

        foreign_key_metadata = [
            {
                'table_name': 't1',
                'column_name': 'c1',
                'constraint_name': 'fk1',
                'referenced_table_name': 't10',
                'referenced_column_name': 'c10'
            },
            {
                'table_name': 't1',
                'column_name': 'c2',
                'constraint_name': 'fk2',
                'referenced_table_name': 't20',
                'referenced_column_name': 'c20'
            }
        ]
        builder = StagingOctaneMetadataBuilder(column_metadata=column_metadata, foreign_key_metadata=foreign_key_metadata)

        expected = construct_data_warehouse_metadata_from_dict({
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'staging_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['c1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['c1'],
                                            'references': {
                                                'columns': ['c10'],
                                                'schema': 'staging_octane',
                                                'table': 't10'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['c2'],
                                            'references': {
                                                'columns': ['c20'],
                                                'schema': 'staging_octane',
                                                'table': 't20'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'c1': {
                                            'data_type': 'TEXT'
                                        },
                                        'c2': {
                                            'data_type': 'INTEGER'
                                        }
                                    }
                                },
                                {
                                    'name': 't2',
                                    'primary_key': ['c1'],
                                    'columns': {
                                        'c1': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        self.assertEqual(expected, builder.build_metadata())


class TestStagingOctaneMetadataBuilderDataTypeMapping(unittest.TestCase):

    def test_maps_date_to_itself(self):
        self.assertEqual('DATE', StagingOctaneMetadataBuilder.map_data_type('Date'))

    def test_maps_time_to_itself(self):
        self.assertEqual('TIME', StagingOctaneMetadataBuilder.map_data_type('TIMe'))

    def test_maps_text_to_itself(self):
        self.assertEqual('TEXT', StagingOctaneMetadataBuilder.map_data_type('text'))

    def test_maps_varchar_to_itself(self):
        self.assertEqual('VARCHAR(16)', StagingOctaneMetadataBuilder.map_data_type('varchar(16)'))
        self.assertEqual('VARCHAR(256)', StagingOctaneMetadataBuilder.map_data_type('varCHAR(256)'))

    def test_maps_datetime_to_timestamp(self):
        self.assertEqual('TIMESTAMP', StagingOctaneMetadataBuilder.map_data_type('datetime'))

    def test_maps_tinyint_to_smallint(self):
        self.assertEqual('SMALLINT', StagingOctaneMetadataBuilder.map_data_type('TINYINT(8)'))
        self.assertEqual('SMALLINT', StagingOctaneMetadataBuilder.map_data_type('TINYINT(64)'))

    def test_maps_int_to_integer(self):
        self.assertEqual('INTEGER', StagingOctaneMetadataBuilder.map_data_type('int(32)'))
        self.assertEqual('INTEGER', StagingOctaneMetadataBuilder.map_data_type('int(64)'))

    def test_maps_bigint_to_bigint(self):
        self.assertEqual('BIGINT', StagingOctaneMetadataBuilder.map_data_type('bigint(128)'))
        self.assertEqual('BIGINT', StagingOctaneMetadataBuilder.map_data_type('bigint(64)'))

    def test_maps_bit_to_boolean(self):
        self.assertEqual('BOOLEAN', StagingOctaneMetadataBuilder.map_data_type('BIT(1)'))
        self.assertEqual('BOOLEAN', StagingOctaneMetadataBuilder.map_data_type('BIT(16)'))

    def test_maps_decimal_to_numeric(self):
        self.assertEqual('NUMERIC(11,5)', StagingOctaneMetadataBuilder.map_data_type('DECIMAL(11,5)'))
        self.assertEqual('NUMERIC(16,30)', StagingOctaneMetadataBuilder.map_data_type('DECIMAL(16,30)'))

    def test_raises_error_if_given_unknown_type(self):
        with self.assertRaises(ValueError):
            StagingOctaneMetadataBuilder.map_data_type('unknown')


if __name__ == '__main__':
    unittest.main()
