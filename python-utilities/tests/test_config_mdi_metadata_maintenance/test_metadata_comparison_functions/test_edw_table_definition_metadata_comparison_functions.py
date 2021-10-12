import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import EDWTableDefinitionMetadataComparisonFunctions


class TestEDWTableDefinitionMetadataComparisonFunctions(unittest.TestCase):

    def setUp(self) -> None:
        self.metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'sch1',
                                'tables': [
                                    {
                                        'name': 't1',
                                        'primary_source_table': 'db1.sch1.t1_src'
                                    },
                                    {
                                        'name': 't1_src',
                                        'primary_source_table': 'db1.sch1.t1_src_src'
                                    },
                                    {
                                        'name': 't1_src_src'
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

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src'
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src_src'
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src_src',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            },
            {
                'database_name': 'db2',
                'schema_name': 'sch2',
                'table_name': 't2',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            },
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=[
            'database_name',
            'schema_name',
            'table_name'
        ])
        expected.add_rows(test_data)
        self.assertEqual(expected, EDWTableDefinitionMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

    def test_construct_metadata_table_from_source(self):
        expected = MetadataTable(key_fields=[
            'database_name',
            'schema_name',
            'table_name'
        ])
        expected.add_rows([
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src'
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src_src'
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src_src',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            },
            {
                'database_name': 'db2',
                'schema_name': 'sch2',
                'table_name': 't2',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            },
        ])
        self.assertEqual(expected, EDWTableDefinitionMetadataComparisonFunctions().construct_metadata_table_from_source(self.metadata))

    def test_construct_insert_row_grouper(self):
        t1_row = Row(
            key={
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1',
            },
            attributes={
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src'
            }
        )
        t1_src_row = Row(
            key={
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src',
            },
            attributes={
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src_src'
            }
        )
        t1_src_src_row = Row(
            key={
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src_src',
            },
            attributes={
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            }
        )
        t2_row = Row(
            key={
                'database_name': 'db2',
                'schema_name': 'sch2',
                'table_name': 't2',
            },
            attributes={
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            }
        )

        row_grouper = EDWTableDefinitionMetadataComparisonFunctions().construct_insert_row_grouper(self.metadata)
        expected = [
            [t1_src_src_row, t2_row],
            [t1_src_row],
            [t1_row]
        ]
        self.assertEqual(expected, row_grouper.group_rows([t1_row, t1_src_row, t1_src_src_row, t2_row]))

    def test_generate_insert_sql(self):
        test_data = [
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1',
                },
                attributes={
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src'
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src',
                },
                attributes={
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src_src'
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src_src',
                },
                attributes={
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None
                }
            ),
            Row(
                key={
                    'database_name': 'db2',
                    'schema_name': 'sch2',
                    'table_name': 't2',
                },
                attributes={
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None
                }
            )
        ]
        expected = "WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 't1', 'db1', 'sch1', 't1_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src', 'db1', 'sch1', 't1_src_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src_src', NULL, NULL, NULL)\n" + \
                   "         , ('db2', 'sch2', 't2', NULL, NULL, NULL)\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)\n" + \
                   "SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid\n" + \
                   "FROM insert_rows\n" + \
                   "LEFT JOIN mdi.edw_table_definition source_table_definition\n" + \
                   "     ON insert_rows.source_database_name = source_table_definition.database_name\n" + \
                   "         AND insert_rows.source_schema_name = source_table_definition.schema_name\n" + \
                   "         AND insert_rows.source_table_name = source_table_definition.table_name;"

        self.assertEqual(expected, EDWTableDefinitionMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1',
                },
                attributes={
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src'
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src',
                },
                attributes={
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src_src'
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src_src',
                },
                attributes={
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None
                }
            ),
            Row(
                key={
                    'database_name': 'db2',
                    'schema_name': 'sch2',
                    'table_name': 't2',
                },
                attributes={
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None
                }
            )
        ]
        expected = "WITH update_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 't1', 'db1', 'sch1', 't1_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src', 'db1', 'sch1', 't1_src_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src_src', NULL, NULL, NULL)\n" + \
                   "         , ('db2', 'sch2', 't2', NULL, NULL, NULL)\n" + \
                   ")\n" + \
                   "UPDATE mdi.edw_table_definition\n" + \
                   "SET primary_source_edw_table_definition_dwid = source_table_definition.dwid\n" + \
                   "FROM update_rows\n" + \
                   "LEFT JOIN mdi.edw_table_definition source_table_definition\n" + \
                   "          ON update_rows.source_database_name = source_table_definition.database_name\n" + \
                   "              AND update_rows.source_schema_name = source_table_definition.schema_name\n" + \
                   "              AND update_rows.source_table_name = source_table_definition.table_name\n" + \
                   "WHERE update_rows.database_name = edw_table_definition.database_name\n" + \
                   "  AND update_rows.schema_name = edw_table_definition.schema_name\n" + \
                   "  AND update_rows.table_name = edw_table_definition.table_name;"
        self.assertEqual(expected, EDWTableDefinitionMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1',
                },
                attributes={
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src'
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src',
                },
                attributes={
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src_src'
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src_src',
                },
                attributes={
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None
                }
            ),
            Row(
                key={
                    'database_name': 'db2',
                    'schema_name': 'sch2',
                    'table_name': 't2',
                },
                attributes={
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None
                }
            )
        ]
        expected = "WITH delete_keys (database_name, schema_name, table_name) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 't1')\n" + \
                   "         , ('db1', 'sch1', 't1_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src_src')\n" + \
                   "         , ('db2', 'sch2', 't2')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.edw_table_definition\n" + \
                   "    USING delete_keys\n" + \
                   "WHERE edw_table_definition.database_name = delete_keys.database_name\n" + \
                   "  AND edw_table_definition.schema_name = delete_keys.schema_name\n" + \
                   "  AND edw_table_definition.table_name = delete_keys.table_name;"
        self.assertEqual(expected, EDWTableDefinitionMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
