import unittest

from lib.lura_information_schema_to_yaml.metadata_builders import (build_staging_octane_metadata,
                                                                   map_msql_data_type,
                                                                   generate_history_octane_metadata,
                                                                   restore_non_generated_objects_to_history_octane_metadata,
                                                                   remove_deleted_column_metadata_from_column)
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import ColumnMetadata


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
            },
            # should be completely ignored and not included in final output
            {
                'table_name': 'unknown_table',
                'column_name': 'c2',
                'constraint_name': 'fk2',
                'referenced_table_name': 'other_unknown_table',
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
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'c2': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 't2',
                                    'primary_key': ['c1'],
                                    'columns': {
                                        'c1': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
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
        self.assertEqual('DATE', map_msql_data_type('Date'))

    def test_maps_time_to_itself(self):
        self.assertEqual('TIME', map_msql_data_type('TIMe'))

    def test_maps_text_to_itself(self):
        self.assertEqual('TEXT', map_msql_data_type('text'))

    def test_maps_blob_to_bytea(self):
        self.assertEqual('BYTEA', map_msql_data_type('blob'))

    def test_maps_varchar_to_itself(self):
        self.assertEqual('VARCHAR(16)', map_msql_data_type('varchar(16)'))
        self.assertEqual('VARCHAR(256)', map_msql_data_type('varCHAR(256)'))

    def test_maps_timestamp_to_itself(self):
        self.assertEqual('TIMESTAMP', map_msql_data_type('timestamp'))

    def test_maps_datetime_to_timestamp(self):
        self.assertEqual('TIMESTAMP', map_msql_data_type('datetime'))

    def test_maps_tinyint_to_smallint(self):
        self.assertEqual('SMALLINT', map_msql_data_type('TINYINT(8)'))
        self.assertEqual('SMALLINT', map_msql_data_type('TINYINT(64)'))

    def test_maps_smallint_to_smallint(self):
        self.assertEqual('SMALLINT', map_msql_data_type('SMALLINT(8)'))
        self.assertEqual('SMALLINT', map_msql_data_type('SMALLINT(64)'))

    def test_maps_int_to_integer(self):
        self.assertEqual('INTEGER', map_msql_data_type('int(32)'))
        self.assertEqual('INTEGER', map_msql_data_type('int(64)'))

    def test_maps_bigint_to_bigint(self):
        self.assertEqual('BIGINT', map_msql_data_type('bigint(128)'))
        self.assertEqual('BIGINT', map_msql_data_type('bigint(64)'))

    def test_maps_bit_to_boolean(self):
        self.assertEqual('BOOLEAN', map_msql_data_type('BIT(1)'))
        self.assertEqual('BOOLEAN', map_msql_data_type('BIT(16)'))

    def test_maps_decimal_to_numeric(self):
        self.assertEqual('NUMERIC(11,5)', map_msql_data_type('DECIMAL(11,5)'))
        self.assertEqual('NUMERIC(16,30)', map_msql_data_type('DECIMAL(16,30)'))

    def test_raises_error_if_given_unknown_type(self):
        with self.assertRaises(ValueError):
            map_msql_data_type('unknown')


class TestGenerateHistoryOctaneMetadata(unittest.TestCase):

    def setUp(self) -> None:
        self.wide_table_staging_columns_dict = {}
        self.wide_table_history_columns_dict = {}

        # add pid and version columns to wide_table staging and history dicts
        self.wide_table_staging_columns_dict['wt_pid'] = {
            'data_type': 'INTEGER',
            'physical_column_flag': True
        }
        self.wide_table_history_columns_dict['wt_pid'] = {
            'data_type': 'INTEGER',
            'physical_column_flag': True,
            'source': {
                'field': 'primary_source_table.columns.wt_pid'
            }
        }
        self.wide_table_staging_columns_dict['wt_version'] = {
            'data_type': 'INTEGER',
            'physical_column_flag': True
        }
        self.wide_table_history_columns_dict['wt_version'] = {
            'data_type': 'INTEGER',
            'physical_column_flag': True,
            'source': {
                'field': 'primary_source_table.columns.wt_version'
            }
        }

        # add 100 columns to staging and history versions of wide_table
        wide_table_column_counter = 1
        while wide_table_column_counter < 101:
            self.wide_table_staging_columns_dict['wt_column_{}'.format(wide_table_column_counter)] = {
                'data_type': 'TEXT',
                'physical_column_flag': True
            }
            self.wide_table_history_columns_dict['wt_column_{}'.format(wide_table_column_counter)] = {
                'data_type': 'TEXT',
                'physical_column_flag': True,
                'source': {
                    'field': 'primary_source_table.columns.wt_column_{}'.format(wide_table_column_counter)
                }
            }
            wide_table_column_counter += 1

        # add standard history_octane columns to wide_table_history_columns_dict
        self.wide_table_history_columns_dict['data_source_updated_datetime'] = {
            'data_type': 'TIMESTAMPTZ',
            'physical_column_flag': True
        }
        self.wide_table_history_columns_dict['data_source_deleted_flag'] = {
            'data_type': 'BOOLEAN',
            'physical_column_flag': True
        }
        self.wide_table_history_columns_dict['etl_batch_id'] = {
            'data_type': 'TEXT',
            'physical_column_flag': True
        }

        self.metadata_dict = {
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
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'a_fk_col_1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'a_fk_col_2': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'a_version': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 'account_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'value': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                # these two new type tables do not have SP numbers assigned to them yet
                                {
                                    'name': 'a_new_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'value': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 'another_new_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'value': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 'wide_table',
                                    'primary_key': ['wt_pid'],
                                    'foreign_keys': {},
                                    'columns': self.wide_table_staging_columns_dict
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        self.staging_metadata = construct_data_warehouse_metadata_from_dict(self.metadata_dict)

        self.existing_yaml_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'step_functions': {
                                        'SP-1': {
                                            'etls': {
                                                'ETL-1': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'next_step_functions': ['SP-10', 'SP-11']
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    'name': 'account_type',
                                    'step_functions': {
                                        'SP-2': {
                                            'etls': {
                                                'ETL-2': {
                                                    'input_type': 'table',
                                                    'output_type': 'insert',
                                                    'next_step_functions': ['SP-20', 'SP-21']
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
        })

        # noinspection PyTypeChecker
        self.metadata_dict['databases'][0]['schemas'].append({
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
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.a_pid'
                            }
                        },
                        'a_fk_col_1': {
                            'data_type': 'INTEGER',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.a_fk_col_1'
                            }
                        },
                        'a_fk_col_2': {
                            'data_type': 'INTEGER',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.a_fk_col_2'
                            }
                        },
                        'a_version': {
                            'data_type': 'INTEGER',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.a_version'
                            }
                        },
                        'data_source_updated_datetime': {
                            'data_type': 'TIMESTAMPTZ',
                            'physical_column_flag': True
                        },
                        'data_source_deleted_flag': {
                            'data_type': 'BOOLEAN',
                            'physical_column_flag': True
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True
                        }
                    },
                    'step_functions': {
                        'SP-1': {
                            'etls': {
                                'ETL-1': {
                                    'input_type': 'table',
                                    'output_type': 'insert',
                                    'output_table': 'staging.history_octane.account',
                                    'json_output_field': 'a_pid',
                                    'truncate_table': False,
                                    'container_memory': 2048,
                                    'next_step_functions': ['SP-10', 'SP-11'],
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
                                                 "FROM (\n" +
                                                 "    SELECT current_records.*\n" +
                                                 "    FROM history_octane.account AS current_records\n" +
                                                 "    LEFT JOIN history_octane.account AS history_records\n" +
                                                 "              ON current_records.a_pid = history_records.a_pid\n" +
                                                 "                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime\n" +
                                                 "    WHERE history_records.data_source_updated_datetime IS NULL\n" +
                                                 "      AND current_records.data_source_deleted_flag = FALSE\n" +
                                                 ") AS history_table\n" +
                                                 "LEFT JOIN staging_octane.account staging_table\n" +
                                                 "          ON staging_table.a_pid = history_table.a_pid\n" +
                                                 "WHERE staging_table.a_pid IS NULL;"
                                }
                            }
                        }
                    }
                },
                {
                    'name': 'account_type',
                    'primary_source_table': 'staging.staging_octane.account_type',
                    'primary_key': ['code'],
                    'columns': {
                        'code': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.code'
                            }
                        },
                        'value': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.value'
                            }
                        },
                        'data_source_updated_datetime': {
                            'data_type': 'TIMESTAMPTZ',
                            'physical_column_flag': True
                        },
                        'data_source_deleted_flag': {
                            'data_type': 'BOOLEAN',
                            'physical_column_flag': True
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True
                        }
                    },
                    'step_functions': {
                        'SP-2': {
                            'etls': {
                                'ETL-2': {
                                    'input_type': 'table',
                                    'output_type': 'insert',
                                    'output_table': 'staging.history_octane.account_type',
                                    'json_output_field': 'code',
                                    'truncate_table': False,
                                    'container_memory': 2048,
                                    'next_step_functions': ['SP-20', 'SP-21'],
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
                            }
                        }
                    }
                },
                {
                    'name': 'a_new_type',
                    'primary_source_table': 'staging.staging_octane.a_new_type',
                    'primary_key': ['code'],
                    'columns': {
                        'code': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.code'
                            }
                        },
                        'value': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.value'
                            }
                        },
                        'data_source_updated_datetime': {
                            'data_type': 'TIMESTAMPTZ',
                            'physical_column_flag': True
                        },
                        'data_source_deleted_flag': {
                            'data_type': 'BOOLEAN',
                            'physical_column_flag': True
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True
                        }
                    },
                    'step_functions': {
                        'SP-3': {
                            'etls': {
                                'ETL-3': {
                                    'input_type': 'table',
                                    'output_type': 'insert',
                                    'output_table': 'staging.history_octane.a_new_type',
                                    'json_output_field': 'code',
                                    'truncate_table': False,
                                    'container_memory': 2048,
                                    'input_sql': "--finding records to insert into history_octane.a_new_type\n" +
                                                 "SELECT staging_table.code\n" +
                                                 "     , staging_table.value\n" +
                                                 "     , FALSE AS data_source_deleted_flag\n" +
                                                 "     , NOW( ) AS data_source_updated_datetime\n" +
                                                 "FROM staging_octane.a_new_type staging_table\n" +
                                                 "LEFT JOIN history_octane.a_new_type history_table\n" +
                                                 "          ON staging_table.code = history_table.code\n" +
                                                 "              AND staging_table.value = history_table.value\n" +
                                                 "WHERE history_table.code IS NULL;"
                                }
                            }
                        }
                    }
                },
                {
                    'name': 'another_new_type',
                    'primary_source_table': 'staging.staging_octane.another_new_type',
                    'primary_key': ['code'],
                    'columns': {
                        'code': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.code'
                            }
                        },
                        'value': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True,
                            'source': {
                                'field': 'primary_source_table.columns.value'
                            }
                        },
                        'data_source_updated_datetime': {
                            'data_type': 'TIMESTAMPTZ',
                            'physical_column_flag': True
                        },
                        'data_source_deleted_flag': {
                            'data_type': 'BOOLEAN',
                            'physical_column_flag': True
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT',
                            'physical_column_flag': True
                        }
                    },
                    'step_functions': {
                        'SP-4': {
                            'etls': {
                                'ETL-4': {
                                    'input_type': 'table',
                                    'output_type': 'insert',
                                    'output_table': 'staging.history_octane.another_new_type',
                                    'json_output_field': 'code',
                                    'truncate_table': False,
                                    'container_memory': 2048,
                                    'input_sql': "--finding records to insert into history_octane.another_new_type\n" +
                                                 "SELECT staging_table.code\n" +
                                                 "     , staging_table.value\n" +
                                                 "     , FALSE AS data_source_deleted_flag\n" +
                                                 "     , NOW( ) AS data_source_updated_datetime\n" +
                                                 "FROM staging_octane.another_new_type staging_table\n" +
                                                 "LEFT JOIN history_octane.another_new_type history_table\n" +
                                                 "          ON staging_table.code = history_table.code\n" +
                                                 "              AND staging_table.value = history_table.value\n" +
                                                 "WHERE history_table.code IS NULL;"
                                }
                            }
                        }
                    }
                },
                {
                    'name': 'wide_table',
                    'primary_source_table': 'staging.staging_octane.wide_table',
                    'primary_key': ['wt_pid', 'wt_version'],
                    'foreign_keys': {},
                    'columns': self.wide_table_history_columns_dict,
                    'step_functions': {
                        'SP-5': {
                            'etls': {
                                'ETL-5': {
                                    'input_type': 'table',
                                    'output_type': 'insert',
                                    'output_table': 'staging.history_octane.wide_table',
                                    'json_output_field': 'wt_pid',
                                    'truncate_table': False,
                                    'container_memory': 4096,
                                    'input_sql': "--finding records to insert into history_octane.wide_table\n" +
                                                 "SELECT staging_table.wt_pid\n" +
                                                 "     , staging_table.wt_version\n" +
                                                 "     , staging_table.wt_column_1\n" +
                                                 "     , staging_table.wt_column_2\n" +
                                                 "     , staging_table.wt_column_3\n" +
                                                 "     , staging_table.wt_column_4\n" +
                                                 "     , staging_table.wt_column_5\n" +
                                                 "     , staging_table.wt_column_6\n" +
                                                 "     , staging_table.wt_column_7\n" +
                                                 "     , staging_table.wt_column_8\n" +
                                                 "     , staging_table.wt_column_9\n" +
                                                 "     , staging_table.wt_column_10\n" +
                                                 "     , staging_table.wt_column_11\n" +
                                                 "     , staging_table.wt_column_12\n" +
                                                 "     , staging_table.wt_column_13\n" +
                                                 "     , staging_table.wt_column_14\n" +
                                                 "     , staging_table.wt_column_15\n" +
                                                 "     , staging_table.wt_column_16\n" +
                                                 "     , staging_table.wt_column_17\n" +
                                                 "     , staging_table.wt_column_18\n" +
                                                 "     , staging_table.wt_column_19\n" +
                                                 "     , staging_table.wt_column_20\n" +
                                                 "     , staging_table.wt_column_21\n" +
                                                 "     , staging_table.wt_column_22\n" +
                                                 "     , staging_table.wt_column_23\n" +
                                                 "     , staging_table.wt_column_24\n" +
                                                 "     , staging_table.wt_column_25\n" +
                                                 "     , staging_table.wt_column_26\n" +
                                                 "     , staging_table.wt_column_27\n" +
                                                 "     , staging_table.wt_column_28\n" +
                                                 "     , staging_table.wt_column_29\n" +
                                                 "     , staging_table.wt_column_30\n" +
                                                 "     , staging_table.wt_column_31\n" +
                                                 "     , staging_table.wt_column_32\n" +
                                                 "     , staging_table.wt_column_33\n" +
                                                 "     , staging_table.wt_column_34\n" +
                                                 "     , staging_table.wt_column_35\n" +
                                                 "     , staging_table.wt_column_36\n" +
                                                 "     , staging_table.wt_column_37\n" +
                                                 "     , staging_table.wt_column_38\n" +
                                                 "     , staging_table.wt_column_39\n" +
                                                 "     , staging_table.wt_column_40\n" +
                                                 "     , staging_table.wt_column_41\n" +
                                                 "     , staging_table.wt_column_42\n" +
                                                 "     , staging_table.wt_column_43\n" +
                                                 "     , staging_table.wt_column_44\n" +
                                                 "     , staging_table.wt_column_45\n" +
                                                 "     , staging_table.wt_column_46\n" +
                                                 "     , staging_table.wt_column_47\n" +
                                                 "     , staging_table.wt_column_48\n" +
                                                 "     , staging_table.wt_column_49\n" +
                                                 "     , staging_table.wt_column_50\n" +
                                                 "     , staging_table.wt_column_51\n" +
                                                 "     , staging_table.wt_column_52\n" +
                                                 "     , staging_table.wt_column_53\n" +
                                                 "     , staging_table.wt_column_54\n" +
                                                 "     , staging_table.wt_column_55\n" +
                                                 "     , staging_table.wt_column_56\n" +
                                                 "     , staging_table.wt_column_57\n" +
                                                 "     , staging_table.wt_column_58\n" +
                                                 "     , staging_table.wt_column_59\n" +
                                                 "     , staging_table.wt_column_60\n" +
                                                 "     , staging_table.wt_column_61\n" +
                                                 "     , staging_table.wt_column_62\n" +
                                                 "     , staging_table.wt_column_63\n" +
                                                 "     , staging_table.wt_column_64\n" +
                                                 "     , staging_table.wt_column_65\n" +
                                                 "     , staging_table.wt_column_66\n" +
                                                 "     , staging_table.wt_column_67\n" +
                                                 "     , staging_table.wt_column_68\n" +
                                                 "     , staging_table.wt_column_69\n" +
                                                 "     , staging_table.wt_column_70\n" +
                                                 "     , staging_table.wt_column_71\n" +
                                                 "     , staging_table.wt_column_72\n" +
                                                 "     , staging_table.wt_column_73\n" +
                                                 "     , staging_table.wt_column_74\n" +
                                                 "     , staging_table.wt_column_75\n" +
                                                 "     , staging_table.wt_column_76\n" +
                                                 "     , staging_table.wt_column_77\n" +
                                                 "     , staging_table.wt_column_78\n" +
                                                 "     , staging_table.wt_column_79\n" +
                                                 "     , staging_table.wt_column_80\n" +
                                                 "     , staging_table.wt_column_81\n" +
                                                 "     , staging_table.wt_column_82\n" +
                                                 "     , staging_table.wt_column_83\n" +
                                                 "     , staging_table.wt_column_84\n" +
                                                 "     , staging_table.wt_column_85\n" +
                                                 "     , staging_table.wt_column_86\n" +
                                                 "     , staging_table.wt_column_87\n" +
                                                 "     , staging_table.wt_column_88\n" +
                                                 "     , staging_table.wt_column_89\n" +
                                                 "     , staging_table.wt_column_90\n" +
                                                 "     , staging_table.wt_column_91\n" +
                                                 "     , staging_table.wt_column_92\n" +
                                                 "     , staging_table.wt_column_93\n" +
                                                 "     , staging_table.wt_column_94\n" +
                                                 "     , staging_table.wt_column_95\n" +
                                                 "     , staging_table.wt_column_96\n" +
                                                 "     , staging_table.wt_column_97\n" +
                                                 "     , staging_table.wt_column_98\n" +
                                                 "     , staging_table.wt_column_99\n" +
                                                 "     , staging_table.wt_column_100\n" +
                                                 "     , FALSE AS data_source_deleted_flag\n" +
                                                 "     , NOW( ) AS data_source_updated_datetime\n" +
                                                 "FROM staging_octane.wide_table staging_table\n" +
                                                 "LEFT JOIN history_octane.wide_table history_table\n" +
                                                 "          ON staging_table.wt_pid = history_table.wt_pid\n" +
                                                 "              AND staging_table.wt_version = history_table.wt_version\n" +
                                                 "WHERE history_table.wt_pid IS NULL\n" +
                                                 "UNION ALL\n" +
                                                 "SELECT history_table.wt_pid\n" +
                                                 "     , history_table.wt_version + 1\n" +
                                                 "     , history_table.wt_column_1\n" +
                                                 "     , history_table.wt_column_2\n" +
                                                 "     , history_table.wt_column_3\n" +
                                                 "     , history_table.wt_column_4\n" +
                                                 "     , history_table.wt_column_5\n" +
                                                 "     , history_table.wt_column_6\n" +
                                                 "     , history_table.wt_column_7\n" +
                                                 "     , history_table.wt_column_8\n" +
                                                 "     , history_table.wt_column_9\n" +
                                                 "     , history_table.wt_column_10\n" +
                                                 "     , history_table.wt_column_11\n" +
                                                 "     , history_table.wt_column_12\n" +
                                                 "     , history_table.wt_column_13\n" +
                                                 "     , history_table.wt_column_14\n" +
                                                 "     , history_table.wt_column_15\n" +
                                                 "     , history_table.wt_column_16\n" +
                                                 "     , history_table.wt_column_17\n" +
                                                 "     , history_table.wt_column_18\n" +
                                                 "     , history_table.wt_column_19\n" +
                                                 "     , history_table.wt_column_20\n" +
                                                 "     , history_table.wt_column_21\n" +
                                                 "     , history_table.wt_column_22\n" +
                                                 "     , history_table.wt_column_23\n" +
                                                 "     , history_table.wt_column_24\n" +
                                                 "     , history_table.wt_column_25\n" +
                                                 "     , history_table.wt_column_26\n" +
                                                 "     , history_table.wt_column_27\n" +
                                                 "     , history_table.wt_column_28\n" +
                                                 "     , history_table.wt_column_29\n" +
                                                 "     , history_table.wt_column_30\n" +
                                                 "     , history_table.wt_column_31\n" +
                                                 "     , history_table.wt_column_32\n" +
                                                 "     , history_table.wt_column_33\n" +
                                                 "     , history_table.wt_column_34\n" +
                                                 "     , history_table.wt_column_35\n" +
                                                 "     , history_table.wt_column_36\n" +
                                                 "     , history_table.wt_column_37\n" +
                                                 "     , history_table.wt_column_38\n" +
                                                 "     , history_table.wt_column_39\n" +
                                                 "     , history_table.wt_column_40\n" +
                                                 "     , history_table.wt_column_41\n" +
                                                 "     , history_table.wt_column_42\n" +
                                                 "     , history_table.wt_column_43\n" +
                                                 "     , history_table.wt_column_44\n" +
                                                 "     , history_table.wt_column_45\n" +
                                                 "     , history_table.wt_column_46\n" +
                                                 "     , history_table.wt_column_47\n" +
                                                 "     , history_table.wt_column_48\n" +
                                                 "     , history_table.wt_column_49\n" +
                                                 "     , history_table.wt_column_50\n" +
                                                 "     , history_table.wt_column_51\n" +
                                                 "     , history_table.wt_column_52\n" +
                                                 "     , history_table.wt_column_53\n" +
                                                 "     , history_table.wt_column_54\n" +
                                                 "     , history_table.wt_column_55\n" +
                                                 "     , history_table.wt_column_56\n" +
                                                 "     , history_table.wt_column_57\n" +
                                                 "     , history_table.wt_column_58\n" +
                                                 "     , history_table.wt_column_59\n" +
                                                 "     , history_table.wt_column_60\n" +
                                                 "     , history_table.wt_column_61\n" +
                                                 "     , history_table.wt_column_62\n" +
                                                 "     , history_table.wt_column_63\n" +
                                                 "     , history_table.wt_column_64\n" +
                                                 "     , history_table.wt_column_65\n" +
                                                 "     , history_table.wt_column_66\n" +
                                                 "     , history_table.wt_column_67\n" +
                                                 "     , history_table.wt_column_68\n" +
                                                 "     , history_table.wt_column_69\n" +
                                                 "     , history_table.wt_column_70\n" +
                                                 "     , history_table.wt_column_71\n" +
                                                 "     , history_table.wt_column_72\n" +
                                                 "     , history_table.wt_column_73\n" +
                                                 "     , history_table.wt_column_74\n" +
                                                 "     , history_table.wt_column_75\n" +
                                                 "     , history_table.wt_column_76\n" +
                                                 "     , history_table.wt_column_77\n" +
                                                 "     , history_table.wt_column_78\n" +
                                                 "     , history_table.wt_column_79\n" +
                                                 "     , history_table.wt_column_80\n" +
                                                 "     , history_table.wt_column_81\n" +
                                                 "     , history_table.wt_column_82\n" +
                                                 "     , history_table.wt_column_83\n" +
                                                 "     , history_table.wt_column_84\n" +
                                                 "     , history_table.wt_column_85\n" +
                                                 "     , history_table.wt_column_86\n" +
                                                 "     , history_table.wt_column_87\n" +
                                                 "     , history_table.wt_column_88\n" +
                                                 "     , history_table.wt_column_89\n" +
                                                 "     , history_table.wt_column_90\n" +
                                                 "     , history_table.wt_column_91\n" +
                                                 "     , history_table.wt_column_92\n" +
                                                 "     , history_table.wt_column_93\n" +
                                                 "     , history_table.wt_column_94\n" +
                                                 "     , history_table.wt_column_95\n" +
                                                 "     , history_table.wt_column_96\n" +
                                                 "     , history_table.wt_column_97\n" +
                                                 "     , history_table.wt_column_98\n" +
                                                 "     , history_table.wt_column_99\n" +
                                                 "     , history_table.wt_column_100\n" +
                                                 "     , TRUE AS data_source_deleted_flag\n" +
                                                 "     , NOW( ) AS data_source_updated_datetime\n" +
                                                 "FROM (\n" +
                                                 "    SELECT current_records.*\n" +
                                                 "    FROM history_octane.wide_table AS current_records\n" +
                                                 "    LEFT JOIN history_octane.wide_table AS history_records\n" +
                                                 "              ON current_records.wt_pid = history_records.wt_pid\n" +
                                                 "                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime\n" +
                                                 "    WHERE history_records.data_source_updated_datetime IS NULL\n"
                                                 "      AND current_records.data_source_deleted_flag = FALSE\n" +
                                                 ") AS history_table\n" +
                                                 "LEFT JOIN staging_octane.wide_table staging_table\n" +
                                                 "          ON staging_table.wt_pid = history_table.wt_pid\n" +
                                                 "WHERE staging_table.wt_pid IS NULL;"
                                }
                            }
                        }
                    }
                }
            ]
        })

    def test_throws_value_error_if_given_metadata_doesnt_contain_staging_octane_schema(self):
        with self.assertRaises(ValueError):
            generate_history_octane_metadata(construct_data_warehouse_metadata_from_dict({'name': 'edw'}), self.existing_yaml_metadata)

    def test_generates_history_octane_metadata_that_mirrors_existing_staging_octane_metadata_while_adding_history_specific_etl_data(self):
        expected = construct_data_warehouse_metadata_from_dict(self.metadata_dict)
        self.assertEqual(expected, generate_history_octane_metadata(self.staging_metadata, self.existing_yaml_metadata))


class TestAddDeletedTablesAndColumnsToHistoryOctaneMetadata(unittest.TestCase):
    def test_remove_deleted_column_metadata_from_column(self):
        source_column = ColumnMetadata(name='c1'
                                       , data_type='TEXT'
                                       , physical_column_flag=True
                                       , source=None
                                       , update_flag=True)

        expected_column = ColumnMetadata(name='c1'
                                         , data_type='TEXT'
                                         , physical_column_flag=True
                                         , source=None
                                         , update_flag=None)

        self.assertEqual(expected_column, remove_deleted_column_metadata_from_column(source_column))

    def test_renaming_field_in_staging_octane_schema(self):
        octane_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3_rename': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3_rename': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        yaml_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 't2',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    },
                                    'next_etls': ['SP-1'],
                                    'primary_source_table': 'staging.staging_octane.t1'
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        expected_datawarehouse_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3_rename': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3_rename': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        self.assertEqual(expected_datawarehouse_metadata,
                         restore_non_generated_objects_to_history_octane_metadata(octane_metadata, yaml_metadata))

    def test_renaming_table_in_staging_octane_schema(self):
        octane_metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'staging_octane',
                            'tables': [
                                {
                                    'name': 't1_rename',
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1_rename',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1_rename'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        yaml_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        expected_datawarehouse_metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'staging_octane',
                            'tables': [
                                {
                                    'name': 't1_rename',
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 't1_rename',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1_rename'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    },
                                    'next_etls': []
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        self.assertEqual(expected_datawarehouse_metadata,
                         restore_non_generated_objects_to_history_octane_metadata(octane_metadata, yaml_metadata))

    def test_adding_field_to_staging_octane_schema(self):
        octane_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f4': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['f4'],
                                            'references': {
                                                'columns': ['f4'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f4': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        yaml_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['f4'],
                                            'references': {
                                                'columns': ['f4'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        expected_datawarehouse_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f4': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['f4'],
                                            'references': {
                                                'columns': ['f4'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f4': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        self.assertEqual(expected_datawarehouse_metadata,
                         restore_non_generated_objects_to_history_octane_metadata(octane_metadata, yaml_metadata))

    def test_removing_field_from_staging_octane_schema(self):
        octane_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        yaml_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 't2',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True,
                                            'source': 'test',
                                            'update_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        expected_datawarehouse_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                },
                                {
                                    'name': 't2',
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        self.assertEqual(expected_datawarehouse_metadata, restore_non_generated_objects_to_history_octane_metadata(
            octane_metadata, yaml_metadata))

    def test_preserve_non_physical_column_in_history_octane_metadata(self):
        octane_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['f2'],
                                            'references': {
                                                'columns': ['f2'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        yaml_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['f2'],
                                            'references': {
                                                'columns': ['f2'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'v1': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': False
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        expected_datawarehouse_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'primary_key': ['pk1'],
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 't1',
                                    'primary_key': ['pk1'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['f1'],
                                            'references': {
                                                'columns': ['f1'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        },
                                        'fk2': {
                                            'columns': ['f2'],
                                            'references': {
                                                'columns': ['f2'],
                                                'schema': 'staging_octane',
                                                'table': 't1'
                                            }
                                        }
                                    },
                                    'columns': {
                                        'pk1': {
                                            'data_type': 'BIGINT',
                                            'physical_column_flag': True
                                        },
                                        'f1': {
                                            'data_type': 'INTEGER',
                                            'physical_column_flag': True
                                        },
                                        'f2': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'f3': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': True
                                        },
                                        'v1': {
                                            'data_type': 'TEXT',
                                            'physical_column_flag': False
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        })

        self.assertEqual(expected_datawarehouse_metadata,
                         restore_non_generated_objects_to_history_octane_metadata(octane_metadata, yaml_metadata))


if __name__ == '__main__':
    unittest.main()
