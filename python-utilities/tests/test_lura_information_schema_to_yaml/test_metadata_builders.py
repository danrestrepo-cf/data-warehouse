import unittest

from lib.lura_information_schema_to_yaml.metadata_builders import build_staging_octane_metadata, map_data_type, add_history_octane_metadata
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


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

    def test_maps_varchar_to_itself(self):
        self.assertEqual('VARCHAR(16)', map_data_type('varchar(16)'))
        self.assertEqual('VARCHAR(256)', map_data_type('varCHAR(256)'))

    def test_maps_datetime_to_timestamp(self):
        self.assertEqual('TIMESTAMP', map_data_type('datetime'))

    def test_maps_tinyint_to_smallint(self):
        self.assertEqual('SMALLINT', map_data_type('TINYINT(8)'))
        self.assertEqual('SMALLINT', map_data_type('TINYINT(64)'))

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


class TestAddHistoryOctaneMetadata(unittest.TestCase):

    def test_throws_value_error_if_given_metadata_doesnt_contain_staging_octane_schema(self):
        with self.assertRaises(ValueError):
            add_history_octane_metadata(construct_data_warehouse_metadata_from_dict({'name': 'edw'}), {})

    def test(self):
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
                            'hardcoded_data_source': 'Octane',
                            'input_type': 'table',
                            'output_type': 'insert',
                            'json_output_field': 'a_pid',
                            'truncate_table': False,
                            'input_sql': 'SQL for SP-1'
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
                            'hardcoded_data_source': 'Octane',
                            'input_type': 'table',
                            'output_type': 'insert',
                            'json_output_field': 'code',
                            'truncate_table': False,
                            'input_sql': 'SQL for SP-2'
                        }
                    },
                    'next_etls': ['SP-20', 'SP-21']
                }
            ]
        })

        expected = construct_data_warehouse_metadata_from_dict(metadata_dict)
        self.assertEqual(expected, add_history_octane_metadata(staging_metadata, table_to_process_map))


# history_octane_column_metadata = [
#     {'table_name': 'account', 'column_name': 'a_deleted_column', 'data_type': 'TEXT'},
#     {'table_name': 'deleted_table', 'column_name': 'dt_pid', 'data_type': 'BIGINT'},
#     {'table_name': 'deleted_table', 'column_name': 'dt_version', 'data_type': 'INTEGER'},
#     {'table_name': 'deleted_type_table', 'column_name': 'code', 'data_type': 'TEXT'},
#     {'table_name': 'deleted_type_table', 'column_name': 'value', 'data_type': 'TEXT'}
# ]

# ,
# {
#     'name': 'deleted_table',
#     'primary_key': ['dt_pid', 'dt_version'],
#     'columns': {
#         'dt_pid': {
#             'data_type': 'BIGINT'
#         },
#         'dt_version': {
#             'data_type': 'INTEGER'
#         }
#     }
# },
# {
#     'name': 'deleted_type_table',
#     'primary_key': ['code'],
#     'columns': {
#         'code': {
#             'data_type': 'TEXT'
#         },
#         'value': {
#             'data_type': 'TEXT'
#         }
#     }
# }

#
# 'a_deleted_column': {
#     'data_type': 'TEXT'
# },

if __name__ == '__main__':
    unittest.main()
