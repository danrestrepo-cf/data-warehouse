import unittest

from lib.lura_information_schema_to_yaml.metadata_builders import (build_staging_octane_metadata,
                                                                   map_data_type,
                                                                   generate_history_octane_metadata,
                                                                   add_deleted_tables_and_columns_to_history_octane_metadata,
                                                                   generate_table_input_sql)
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.metadata_object_path import TablePath


class TestBuildStagingOctaneMetadata(unittest.TestCase):

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

        self.assertEqual(expected, build_staging_octane_metadata(column_metadata, foreign_key_metadata))


class TestMapDataType(unittest.TestCase):

    def test_maps_date_to_itself(self):
        self.assertEqual('DATE', map_data_type('Date'))

    def test_maps_time_to_itself(self):
        self.assertEqual('TIME', map_data_type('TIMe'))

    def test_maps_text_to_itself(self):
        self.assertEqual('TEXT', map_data_type('text'))

    def test_maps_blob_to_bytea(self):
        self.assertEqual('BYTEA', map_data_type('blob'))

    def test_maps_varchar_to_itself(self):
        self.assertEqual('VARCHAR(16)', map_data_type('varchar(16)'))
        self.assertEqual('VARCHAR(256)', map_data_type('varCHAR(256)'))

    def test_maps_timestamp_to_itself(self):
        self.assertEqual('TIMESTAMP', map_data_type('timestamp'))

    def test_maps_datetime_to_timestamp(self):
        self.assertEqual('TIMESTAMP', map_data_type('datetime'))

    def test_maps_tinyint_to_smallint(self):
        self.assertEqual('SMALLINT', map_data_type('TINYINT(8)'))
        self.assertEqual('SMALLINT', map_data_type('TINYINT(64)'))

    def test_maps_smallint_to_smallint(self):
        self.assertEqual('SMALLINT', map_data_type('SMALLINT(8)'))
        self.assertEqual('SMALLINT', map_data_type('SMALLINT(64)'))

    def test_maps_int_to_integer(self):
        self.assertEqual('INTEGER', map_data_type('int(32)'))
        self.assertEqual('INTEGER', map_data_type('int(64)'))

    def test_maps_bigint_to_bigint(self):
        self.assertEqual('BIGINT', map_data_type('bigint(128)'))
        self.assertEqual('BIGINT', map_data_type('bigint(64)'))

    def test_maps_bit_to_boolean(self):
        self.assertEqual('BOOLEAN', map_data_type('BIT(1)'))
        self.assertEqual('BOOLEAN', map_data_type('BIT(16)'))

    def test_maps_decimal_to_numeric(self):
        self.assertEqual('NUMERIC(11,5)', map_data_type('DECIMAL(11,5)'))
        self.assertEqual('NUMERIC(16,30)', map_data_type('DECIMAL(16,30)'))

    def test_raises_error_if_given_unknown_type(self):
        with self.assertRaises(ValueError):
            map_data_type('unknown')


class TestGenerateHistoryOctaneMetadata(unittest.TestCase):

    def test_throws_value_error_if_given_metadata_doesnt_contain_staging_octane_schema(self):
        with self.assertRaises(ValueError):
            generate_history_octane_metadata(construct_data_warehouse_metadata_from_dict({'name': 'edw'}), {})

    def test_generates_history_octane_metadata_that_mirrors_existing_staging_octane_metadata_while_adding_history_specific_etl_data(self):
        metadata_dict = {
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'staging_octane',
                            'tables': [
                                {
                                    'name': 'account',
                                    'primary_key': ['a_pid'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['fk_col_1'],
                                            'references': {
                                                'columns': ['c10'],
                                                'schema': 'staging_octane',
                                                'table': 't10'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['fk_col_2'],
                                            'references': {
                                                'columns': ['c20'],
                                                'schema': 'staging_octane',
                                                'table': 't20'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'a_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'a_fk_col_1': {
                                            'data_type': 'INTEGER'
                                        },
                                        'a_fk_col_2': {
                                            'data_type': 'INTEGER'
                                        },
                                        'a_version': {
                                            'data_type': 'INTEGER'
                                        }
                                    }
                                },
                                {
                                    'name': 'account_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
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
        staging_metadata = construct_data_warehouse_metadata_from_dict(metadata_dict)

        table_to_process_map = {
            'account': {'process': 'SP-1', 'next_processes': ['SP-10', 'SP-11']},
            'account_type': {'process': 'SP-2', 'next_processes': ['SP-20', 'SP-21']}
        }

        # noinspection PyTypeChecker
        metadata_dict['databases'][0]['schemas'].append({
            'name': 'history_octane',
            'tables': [
                {
                    'name': 'account',
                    'primary_key': ['a_pid', 'a_version'],
                    'primary_source_table': 'staging.staging_octane.account',
                    'foreign_keys': {
                        'fk1': {
                            'columns': ['fk_col_1'],
                            'references': {
                                'columns': ['c10'],
                                'schema': 'history_octane',
                                'table': 't10'
                            }
                        },
                        'fk2': {
                            'columns': ['fk_col_2'],
                            'references': {
                                'columns': ['c20'],
                                'schema': 'history_octane',
                                'table': 't20'
                            }
                        }
                    },
                    'columns': {
                        'a_pid': {
                            'data_type': 'BIGINT',
                            'source': {
                                'field': 'primary_source_table.columns.a_pid'
                            }
                        },
                        'a_fk_col_1': {
                            'data_type': 'INTEGER',
                            'source': {
                                'field': 'primary_source_table.columns.a_fk_col_1'
                            }
                        },
                        'a_fk_col_2': {
                            'data_type': 'INTEGER',
                            'source': {
                                'field': 'primary_source_table.columns.a_fk_col_2'
                            }
                        },
                        'a_version': {
                            'data_type': 'INTEGER',
                            'source': {
                                'field': 'primary_source_table.columns.a_version'
                            }
                        },
                        'data_source_updated_datetime': {
                            'data_type': 'TIMESTAMPTZ'
                        },
                        'data_source_deleted_flag': {
                            'data_type': 'BOOLEAN'
                        }
                    },
                    'etls': {
                        'SP-1': {
                            'input_type': 'table',
                            'output_type': 'insert',
                            'json_output_field': 'a_pid',
                            'truncate_table': False,
                            'input_sql': "--finding records to insert into history_octane.account\n" +
                                         "SELECT staging_table.a_pid\n" +
                                         "     , staging_table.a_fk_col_1\n" +
                                         "     , staging_table.a_fk_col_2\n" +
                                         "     , staging_table.a_version\n" +
                                         "     , FALSE AS data_source_deleted_flag\n" +
                                         "     , NOW( ) AS data_source_updated_datetime\n" +
                                         "FROM staging_octane.account staging_table\n" +
                                         "LEFT JOIN history_octane.account history_table\n" +
                                         "          ON staging_table.a_pid = history_table.a_pid\n" +
                                         "              AND staging_table.a_version = history_table.a_version\n" +
                                         "WHERE history_table.a_pid IS NULL\n" +
                                         "UNION ALL\n" +
                                         "SELECT history_table.a_pid\n" +
                                         "     , history_table.a_fk_col_1\n" +
                                         "     , history_table.a_fk_col_2\n" +
                                         "     , history_table.a_version + 1\n" +
                                         "     , TRUE AS data_source_deleted_flag\n" +
                                         "     , NOW( ) AS data_source_updated_datetime\n" +
                                         "FROM history_octane.account history_table\n" +
                                         "LEFT JOIN staging_octane.account staging_table\n" +
                                         "          ON staging_table.a_pid = history_table.a_pid\n" +
                                         "WHERE staging_table.a_pid IS NULL\n" +
                                         "  AND NOT EXISTS(\n" +
                                         "    SELECT 1\n" +
                                         "    FROM history_octane.account deleted_records\n" +
                                         "    WHERE deleted_records.a_pid = history_table.a_pid\n" +
                                         "      AND deleted_records.data_source_deleted_flag = TRUE\n" +
                                         "    );"

                        }
                    },
                    'next_etls': ['SP-10', 'SP-11']
                },
                {
                    'name': 'account_type',
                    'primary_source_table': 'staging.staging_octane.account_type',
                    'primary_key': ['code'],
                    'columns': {
                        'code': {
                            'data_type': 'TEXT',
                            'source': {
                                'field': 'primary_source_table.columns.code'
                            }
                        },
                        'value': {
                            'data_type': 'TEXT',
                            'source': {
                                'field': 'primary_source_table.columns.value'
                            }
                        },
                        'data_source_updated_datetime': {
                            'data_type': 'TIMESTAMPTZ'
                        },
                        'data_source_deleted_flag': {
                            'data_type': 'BOOLEAN'
                        }
                    },
                    'etls': {
                        'SP-2': {
                            'input_type': 'table',
                            'output_type': 'insert',
                            'json_output_field': 'code',
                            'truncate_table': False,
                            'input_sql': "--finding records to insert into history_octane.account_type\n" +
                                         "SELECT staging_table.code\n" +
                                         "     , staging_table.value\n" +
                                         "     , FALSE AS data_source_deleted_flag\n" +
                                         "     , NOW( ) AS data_source_updated_datetime\n" +
                                         "FROM staging_octane.account_type staging_table\n" +
                                         "LEFT JOIN history_octane.account_type history_table\n" +
                                         "          ON staging_table.code = history_table.code\n" +
                                         "              AND staging_table.value = history_table.value\n" +
                                         "WHERE history_table.code IS NULL;"
                        }
                    },
                    'next_etls': ['SP-20', 'SP-21']
                }
            ]
        })

        expected = construct_data_warehouse_metadata_from_dict(metadata_dict)
        self.assertEqual(expected, generate_history_octane_metadata(staging_metadata, table_to_process_map))


class TestAddDeletedTablesAndColumnsToHistoryOctaneMetadata(unittest.TestCase):

    def test_incorporates_given_columns_and_tables_into_the_given_data_warehouse_metadata_structure_if_they_dont_already_exist(self):
        deleted_column_metadata = [
            {'table_name': 'account', 'column_name': 'a_deleted_column', 'data_type': 'TEXT'},
            {'table_name': 'deleted_table', 'column_name': 'dt_pid', 'data_type': 'BIGINT'},
            {'table_name': 'deleted_table', 'column_name': 'dt_version', 'data_type': 'INTEGER'},
            {'table_name': 'deleted_type_table', 'column_name': 'code', 'data_type': 'TEXT'},
            {'table_name': 'deleted_type_table', 'column_name': 'value', 'data_type': 'TEXT'}
        ]

        input_metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 'account',
                                    'primary_key': ['a_pid'],
                                    'columns': {
                                        'a_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'a_version': {
                                            'data_type': 'INTEGER'
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        expected = construct_data_warehouse_metadata_from_dict({
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 'account',
                                    'primary_key': ['a_pid'],
                                    'columns': {
                                        'a_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'a_version': {
                                            'data_type': 'INTEGER'
                                        },
                                        'a_deleted_column': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'deleted_table',
                                    'primary_key': ['dt_pid', 'dt_version'],
                                    'columns': {
                                        'dt_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'dt_version': {
                                            'data_type': 'INTEGER'
                                        }
                                    }
                                },
                                {
                                    'name': 'deleted_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
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
        self.assertEqual(expected, add_deleted_tables_and_columns_to_history_octane_metadata(input_metadata, deleted_column_metadata))


class TestGenerateTableInputSQL(unittest.TestCase):

    def setUp(self) -> None:
        self.metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'staging_octane',
                            'tables': [
                                {
                                    'name': 'regular_table',
                                    'primary_key': ['rt_pid'],
                                    'columns': {
                                        'rt_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'rt_version': {
                                            'data_type': 'INTEGER'
                                        },
                                        'rt_normal_column': {
                                            'data_type': 'TEXT'
                                        },
                                        'rt_decoy_version': {
                                            'data_type': 'TEXT'
                                        },
                                        'rt_decoy_pid': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'regular_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
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

    def test_produces_correct_sql_for_regular_table(self):
        table = self.metadata.get_table_by_path(TablePath('staging', 'staging_octane', 'regular_table'))
        expected = ("--finding records to insert into history_octane.regular_table\n" +
                    "SELECT staging_table.rt_pid\n" +
                    "     , staging_table.rt_version\n" +
                    "     , staging_table.rt_normal_column\n" +
                    "     , staging_table.rt_decoy_version\n" +
                    "     , staging_table.rt_decoy_pid\n" +
                    "     , FALSE AS data_source_deleted_flag\n" +
                    "     , NOW( ) AS data_source_updated_datetime\n" +
                    "FROM staging_octane.regular_table staging_table\n" +
                    "LEFT JOIN history_octane.regular_table history_table\n" +
                    "          ON staging_table.rt_pid = history_table.rt_pid\n" +
                    "              AND staging_table.rt_version = history_table.rt_version\n" +
                    "WHERE history_table.rt_pid IS NULL\n" +
                    "UNION ALL\n" +
                    "SELECT history_table.rt_pid\n" +
                    "     , history_table.rt_version + 1\n" +
                    "     , history_table.rt_normal_column\n" +
                    "     , history_table.rt_decoy_version\n" +
                    "     , history_table.rt_decoy_pid\n" +
                    "     , TRUE AS data_source_deleted_flag\n" +
                    "     , NOW( ) AS data_source_updated_datetime\n" +
                    "FROM history_octane.regular_table history_table\n" +
                    "LEFT JOIN staging_octane.regular_table staging_table\n" +
                    "          ON staging_table.rt_pid = history_table.rt_pid\n" +
                    "WHERE staging_table.rt_pid IS NULL\n" +
                    "  AND NOT EXISTS(\n" +
                    "    SELECT 1\n" +
                    "    FROM history_octane.regular_table deleted_records\n" +
                    "    WHERE deleted_records.rt_pid = history_table.rt_pid\n" +
                    "      AND deleted_records.data_source_deleted_flag = TRUE\n" +
                    "    );")
        self.assertEqual(expected, generate_table_input_sql(table))

    def test_produces_correct_sql_for_regular_type_table(self):
        table = self.metadata.get_table_by_path(TablePath('staging', 'staging_octane', 'regular_type'))
        expected = ("--finding records to insert into history_octane.regular_type\n" +
                    "SELECT staging_table.code\n" +
                    "     , staging_table.value\n" +
                    "     , FALSE AS data_source_deleted_flag\n" +
                    "     , NOW( ) AS data_source_updated_datetime\n" +
                    "FROM staging_octane.regular_type staging_table\n" +
                    "LEFT JOIN history_octane.regular_type history_table\n" +
                    "          ON staging_table.code = history_table.code\n" +
                    "              AND staging_table.value = history_table.value\n" +
                    "WHERE history_table.code IS NULL;")
        self.assertEqual(expected, generate_table_input_sql(table))


if __name__ == '__main__':
    unittest.main()
