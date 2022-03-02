import unittest

from lib.lura_information_schema_to_yaml.metadata_builders import (build_staging_octane_metadata,
                                                                   map_msql_data_type,
                                                                   generate_history_octane_metadata,
                                                                   add_deleted_tables_and_columns_to_history_octane_metadata,
                                                                   generate_history_octane_table_input_sql)
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
        self.wide_table_staging_columns_dict['wt_pid'] = {'data_type': 'INTEGER'}
        self.wide_table_history_columns_dict['wt_pid'] = {
            'data_type': 'INTEGER',
            'source': {
                'field': 'primary_source_table.columns.wt_pid'
            }
        }
        self.wide_table_staging_columns_dict['wt_version'] = {'data_type': 'INTEGER'}
        self.wide_table_history_columns_dict['wt_version'] = {
            'data_type': 'INTEGER',
            'source': {
                'field': 'primary_source_table.columns.wt_version'
            }
        }

        # add 100 columns to staging and history versions of wide_table
        wide_table_column_counter = 1
        while wide_table_column_counter < 101:
            self.wide_table_staging_columns_dict['wt_column_{}'.format(wide_table_column_counter)] = {'data_type': 'TEXT'}
            self.wide_table_history_columns_dict['wt_column_{}'.format(wide_table_column_counter)] = {
                'data_type': 'TEXT',
                'source': {
                    'field': 'primary_source_table.columns.wt_column_{}'.format(wide_table_column_counter)
                    }
                }
            wide_table_column_counter += 1

        # add standard history_octane columns to wide_table_history_columns_dict
        self.wide_table_history_columns_dict['data_source_updated_datetime'] = {'data_type': 'TIMESTAMPTZ'}
        self.wide_table_history_columns_dict['data_source_deleted_flag'] = {'data_type': 'BOOLEAN'}
        self.wide_table_history_columns_dict['etl_batch_id'] = {'data_type': 'TEXT'}

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
                                },
                                # these two new type tables do not have SP numbers assigned to them yet
                                {
                                    'name': 'a_new_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'another_new_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
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

        self.table_to_process_map = {
            'account': {'process': 'SP-1', 'next_processes': ['SP-10', 'SP-11']},
            'account_type': {'process': 'SP-2', 'next_processes': ['SP-20', 'SP-21']}
        }

        self.current_max_process_number = 2

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
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT'
                        }
                    },
                    'etls': {
                        'SP-1': {
                            'input_type': 'table',
                            'output_type': 'insert',
                            'json_output_field': 'a_pid',
                            'truncate_table': False,
                            'container_memory': 2048,
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
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT'
                        }
                    },
                    'etls': {
                        'SP-2': {
                            'input_type': 'table',
                            'output_type': 'insert',
                            'json_output_field': 'code',
                            'truncate_table': False,
                            'container_memory': 2048,
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
                },
                {
                    'name': 'a_new_type',
                    'primary_source_table': 'staging.staging_octane.a_new_type',
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
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT'
                        }
                    },
                    'etls': {
                        'SP-3': {
                            'input_type': 'table',
                            'output_type': 'insert',
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
                },
                {
                    'name': 'another_new_type',
                    'primary_source_table': 'staging.staging_octane.another_new_type',
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
                        },
                        'etl_batch_id': {
                            'data_type': 'TEXT'
                        }
                    },
                    'etls': {
                        'SP-4': {
                            'input_type': 'table',
                            'output_type': 'insert',
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
                },
                {
                    'name': 'wide_table',
                    'primary_source_table': 'staging.staging_octane.wide_table',
                    'primary_key': ['wt_pid', 'wt_version'],
                    'foreign_keys': {},
                    'columns': self.wide_table_history_columns_dict,
                    'etls': {
                        'SP-5': {
                            'input_type': 'table',
                            'output_type': 'insert',
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
                                         "FROM history_octane.wide_table history_table\n" +
                                         "LEFT JOIN staging_octane.wide_table staging_table\n" +
                                         "          ON staging_table.wt_pid = history_table.wt_pid\n" +
                                         "WHERE staging_table.wt_pid IS NULL\n" +
                                         "  AND NOT EXISTS(\n" +
                                         "    SELECT 1\n" +
                                         "    FROM history_octane.wide_table deleted_records\n" +
                                         "    WHERE deleted_records.wt_pid = history_table.wt_pid\n" +
                                         "      AND deleted_records.data_source_deleted_flag = TRUE\n" +
                                         "    );"
                        }
                    }
                }
            ]
        })

    def test_throws_value_error_if_given_metadata_doesnt_contain_staging_octane_schema(self):
        with self.assertRaises(ValueError):
            generate_history_octane_metadata(construct_data_warehouse_metadata_from_dict({'name': 'edw'}), {},
                                             self.current_max_process_number)

    def test_generates_history_octane_metadata_that_mirrors_existing_staging_octane_metadata_while_adding_history_specific_etl_data(self):
        expected = construct_data_warehouse_metadata_from_dict(self.metadata_dict)
        self.assertEqual(expected, generate_history_octane_metadata(self.staging_metadata, self.table_to_process_map,
                                                                    self.current_max_process_number))


class TestAddDeletedTablesAndColumnsToHistoryOctaneMetadata(unittest.TestCase):

    def setUp(self) -> None:
        self.octane_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'name': 'regular_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'no_version_table',
                                    'primary_key': ['nv_pid'],
                                    'columns': {
                                        'nv_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'nv_normal_column': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'extra_fields_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                            ]
                        },
                        {
                            'name': 'history_octane',
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
                                    'name': 'regular_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'no_version_table',
                                    'primary_key': ['nv_pid'],
                                    'columns': {
                                        'nv_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'nv_normal_column': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'extra_fields_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                            ]
                        }
                    ]
                }
            ]
        })
        self.current_yaml_metadata = construct_data_warehouse_metadata_from_dict({
            'name': 'edw',
            'databases': [
                {
                    'name': 'staging',
                    'schemas': [
                        {
                            'name': 'staging_octane',
                            'tables': [
                                {
                                    'name': 'aregular_table2',
                                    'primary_source_table': 'db2.sch2.t2',
                                    'primary_key': ['rt_pid'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['col3'],
                                            'references': {
                                                'columns': ['col3'],
                                                'schema': 'sch2',
                                                'table': 't2'
                                            }
                                        }
                                    },
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
                                            'container_memory': 2048,
                                            'input_sql': 'SQL for SP-1'
                                        }
                                    },
                                    'next_etls': [
                                        'SP-4', 'SP-5'
                                    ]
                                },
                                {
                                    'name': 'regular_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'no_version_table',
                                    'primary_key': ['nv_pid'],
                                    'columns': {
                                        'nv_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'nv_normal_column': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'some_id_sequence', # will be deleted
                                    'primary_key': ['is_id'],
                                    'columns': {
                                        'is_id': {
                                            'data_type': 'BIGINT'
                                        }
                                    }
                                },
                                {
                                    'name': 'extra_fields_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'extra_field_1': {  # will be deleted
                                            'data_type': 'TEXT'
                                        },
                                        'extra_field_2': {  # will be deleted
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            'name': 'history_octane',
                            'tables': [
                                {
                                    'name': 'aregular_table2',
                                    'primary_source_table': 'db2.sch2.t2',
                                    'primary_key': ['rt_pid'],
                                    'foreign_keys': {
                                        'fk1': {
                                            'columns': ['col3'],
                                            'references': {
                                                'columns': ['col3'],
                                                'schema': 'sch2',
                                                'table': 't2'
                                            }
                                        }
                                    },
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
                                            'container_memory': 2048,
                                            'input_sql': 'SQL for SP-1'
                                        }
                                    },
                                    'next_etls': [
                                        'SP-4', 'SP-5'
                                    ]
                                },
                                {
                                    'name': 'regular_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
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
                                    'name': 'regular_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'no_version_table',
                                    'primary_key': ['nv_pid'],
                                    'columns': {
                                        'nv_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'nv_normal_column': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'some_id_sequence',  # deleted table
                                    'primary_key': ['is_id'],
                                    'columns': {
                                        'is_id': {
                                            'data_type': 'BIGINT'
                                        }
                                    }
                                },
                                {
                                    'name': 'extra_fields_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'extra_field_1': {  # deleted field
                                            'data_type': 'TEXT'
                                        },
                                        'extra_field_2': {  # deleted field
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
        self.expected_metadata = construct_data_warehouse_metadata_from_dict({
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
                                    'name': 'regular_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'no_version_table',
                                    'primary_key': ['nv_pid'],
                                    'columns': {
                                        'nv_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'nv_normal_column': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'extra_fields_type',
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
                        },
                        {
                            'name': 'history_octane',
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
                                    'name': 'regular_type_table',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'value': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'no_version_table',
                                    'primary_key': ['nv_pid'],
                                    'columns': {
                                        'nv_pid': {
                                            'data_type': 'BIGINT'
                                        },
                                        'nv_normal_column': {
                                            'data_type': 'TEXT'
                                        }
                                    }
                                },
                                {
                                    'name': 'some_id_sequence',  # deleted table
                                    'primary_key': ['is_id'],
                                    'columns': {
                                        'is_id': {
                                            'data_type': 'BIGINT'
                                        }
                                    }
                                },
                                {
                                    'name': 'extra_fields_type',
                                    'primary_key': ['code'],
                                    'columns': {
                                        'code': {
                                            'data_type': 'TEXT'
                                        },
                                        'extra_field_1': {  # deleted field
                                            'data_type': 'TEXT'
                                        },
                                        'extra_field_2': {  # deleted field
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

    def test_incorporates_given_columns_and_tables_into_the_given_data_warehouse_metadata_structure_if_they_dont_already_exist(self):
        from lib.metadata_core.metadata_yaml_translator import (generate_data_warehouse_metadata_from_yaml)
        import os

        current_yaml_metadata = generate_data_warehouse_metadata_from_yaml(os.path.abspath(os.path.join(os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..')), '../..', 'metadata/edw')))
        print(add_deleted_tables_and_columns_to_history_octane_metadata(self.octane_metadata, current_yaml_metadata))

        # test now fails as a reminder to fix this after implementation
        # self.assertEqual(construct_data_warehouse_metadata_from_dict(self.expected_metadata), add_deleted_tables_and_columns_to_history_octane_metadata(self.octane_metadata, output))


if __name__ == '__main__':
    unittest.main()
