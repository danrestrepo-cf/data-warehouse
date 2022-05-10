import unittest

from tests.testing_utils import MockDBConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import EDWFieldDefinitionMetadataComparisonFunctions


class TestEDWFieldDefinitionMetadataComparisonFunctions(unittest.TestCase):

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
                                        'primary_source_table': 'db1.sch1.t1_src',
                                        'columns': {
                                            'c1': {
                                                'data_type': 'TEXT',
                                                'physical_column_flag': True,
                                                'source': {
                                                    'field': 'primary_source_table.columns.c1_src'
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 't1_src',
                                        'primary_source_table': 'db1.sch1.t1_src_src',
                                        'columns': {
                                            'c1_src': {
                                                'data_type': 'TEXT',
                                                'physical_column_flag': True,
                                                'source': {
                                                    'field': 'primary_source_table.columns.c1_src_src'
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 't1_src_src',
                                        'columns': {
                                            'c1_src_src': {
                                                'data_type': 'TEXT',
                                                'physical_column_flag': True
                                            }
                                        }
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
                                        'name': 't2',
                                        'columns': {
                                            'c2': {
                                                'data_type': 'INT',
                                                'physical_column_flag': True
                                            },
                                            'c3': {
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
                'field_name': 'c1',
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src',
                'source_field_name': 'c1_src',
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src',
                'field_name': 'c1_src',
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src_src',
                'source_field_name': 'c1_src_src',
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src_src',
                'field_name': 'c1_src_src',
                'data_type': 'TEXT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            },
            {
                'database_name': 'db2',
                'schema_name': 'sch2',
                'table_name': 't2',
                'field_name': 'c2',
                'data_type': 'INT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            }
        ]
        db_conn = MockDBConnection(query_results=test_data)
        expected = MetadataTable(key_fields=[
            'database_name',
            'schema_name',
            'table_name',
            'field_name'
        ])
        expected.add_rows(test_data)
        self.assertEqual(expected, EDWFieldDefinitionMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

    def test_construct_metadata_table_from_source(self):
        expected = MetadataTable(key_fields=[
            'database_name',
            'schema_name',
            'table_name',
            'field_name'
        ])
        expected.add_rows([

            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1',
                'field_name': 'c1',
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src',
                'source_field_name': 'c1_src',
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src',
                'field_name': 'c1_src',
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src_src',
                'source_field_name': 'c1_src_src',
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src_src',
                'field_name': 'c1_src_src',
                'data_type': 'TEXT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            },
            {
                'database_name': 'db2',
                'schema_name': 'sch2',
                'table_name': 't2',
                'field_name': 'c2',
                'data_type': 'INT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            }
        ])
        self.assertEqual(expected, EDWFieldDefinitionMetadataComparisonFunctions().construct_metadata_table_from_source(self.metadata))

    def test_construct_insert_row_grouper(self):
        c1_row = Row(
            key={
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1',
                'field_name': 'c1',
            },
            attributes={
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src',
                'field_name': 'c1_src',
            }
        )
        c1_src_row = Row(
            key={
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src',
                'field_name': 'c1_src',
            },
            attributes={
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src_src',
                'source_field_name': 'c1_src_src',
            }
        )
        c1_src_src_row = Row(
            key={
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src_src',
                'field_name': 'c1_src_src',
            },
            attributes={
                'data_type': 'TEXT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            }
        )
        c2_row = Row(
            key={
                'database_name': 'db2',
                'schema_name': 'sch2',
                'table_name': 't2',
                'field_name': 'c2',
            },
            attributes={
                'data_type': 'INT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            }
        )

        row_grouper = EDWFieldDefinitionMetadataComparisonFunctions().construct_insert_row_grouper(self.metadata)
        expected = [
            [c1_src_src_row, c2_row],
            [c1_src_row],
            [c1_row]
        ]
        self.assertEqual(expected, row_grouper.group_rows([c1_row, c1_src_row, c1_src_src_row, c2_row]))

    def test_construct_delete_row_grouper(self):
        metadata_table = MetadataTable(key_fields=[
            'database_name',
            'schema_name',
            'table_name',
            'field_name'
        ])
        metadata_table.add_rows([

            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1',
                'field_name': 'c1',
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src',
                'source_field_name': 'c1_src',
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src',
                'field_name': 'c1_src',
                'data_type': 'TEXT',
                'source_database_name': 'db1',
                'source_schema_name': 'sch1',
                'source_table_name': 't1_src_src',
                'source_field_name': 'c1_src_src',
            },
            {
                'database_name': 'db1',
                'schema_name': 'sch1',
                'table_name': 't1_src_src',
                'field_name': 'c1_src_src',
                'data_type': 'TEXT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            },
            {
                'database_name': 'db2',
                'schema_name': 'sch2',
                'table_name': 't2',
                'field_name': 'c2',
                'data_type': 'INT',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            }
        ])

        c1_row = metadata_table.rows[0]
        c1_src_row = metadata_table.rows[1]
        c1_src_src_row = metadata_table.rows[2]
        c2_row = metadata_table.rows[3]

        row_grouper = EDWFieldDefinitionMetadataComparisonFunctions().construct_delete_row_grouper(metadata_table)
        expected = [
            [c1_row, c2_row],
            [c1_src_row],
            [c1_src_src_row]
        ]
        self.assertEqual(expected, row_grouper.group_rows([c1_row, c1_src_row, c1_src_src_row, c2_row]))

    def test_generate_insert_sql(self):
        test_data = [
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1',
                    'field_name': 'c1',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src',
                    'source_field_name': 'c1_src',
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src',
                    'field_name': 'c1_src',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src_src',
                    'source_field_name': 'c1_src_src',
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src_src',
                    'field_name': 'c1_src_src',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None,
                    'source_field_name': None
                }
            ),
            Row(
                key={
                    'database_name': 'db2',
                    'schema_name': 'sch2',
                    'table_name': 't2',
                    'field_name': 'c2',
                },
                attributes={
                    'data_type': 'INT',
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None,
                    'source_field_name': None
                }
            )
        ]
        expected = "WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 't1', 'c1', 'TEXT', 'db1', 'sch1', 't1_src', 'c1_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src', 'c1_src', 'TEXT', 'db1', 'sch1', 't1_src_src', 'c1_src_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src_src', 'c1_src_src', 'TEXT', NULL, NULL, NULL, NULL)\n" + \
                   "         , ('db2', 'sch2', 't2', 'c2', 'INT', NULL, NULL, NULL, NULL)\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)\n" + \
                   "SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.edw_table_definition\n" + \
                   "     ON insert_rows.database_name = edw_table_definition.database_name\n" + \
                   "         AND insert_rows.schema_name = edw_table_definition.schema_name\n" + \
                   "         AND insert_rows.table_name = edw_table_definition.table_name\n" + \
                   "LEFT JOIN mdi.edw_table_definition source_table_definition\n" + \
                   "          ON insert_rows.source_database_name = source_table_definition.database_name\n" + \
                   "              AND insert_rows.source_schema_name = source_table_definition.schema_name\n" + \
                   "              AND insert_rows.source_table_name = source_table_definition.table_name\n" + \
                   "LEFT JOIN mdi.edw_field_definition source_field_definition\n" + \
                   "          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid\n" + \
                   "              AND insert_rows.source_field_name = source_field_definition.field_name;"

        self.assertEqual(expected, EDWFieldDefinitionMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1',
                    'field_name': 'c1',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src',
                    'source_field_name': 'c1_src',
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src',
                    'field_name': 'c1_src',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src_src',
                    'source_field_name': 'c1_src_src',
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src_src',
                    'field_name': 'c1_src_src',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None,
                    'source_field_name': None
                }
            ),
            Row(
                key={
                    'database_name': 'db2',
                    'schema_name': 'sch2',
                    'table_name': 't2',
                    'field_name': 'c2',
                },
                attributes={
                    'data_type': 'INT',
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None,
                    'source_field_name': None
                }
            )
        ]
        expected = "WITH update_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 't1', 'c1', 'TEXT', 'db1', 'sch1', 't1_src', 'c1_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src', 'c1_src', 'TEXT', 'db1', 'sch1', 't1_src_src', 'c1_src_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src_src', 'c1_src_src', 'TEXT', NULL, NULL, NULL, NULL)\n" + \
                   "         , ('db2', 'sch2', 't2', 'c2', 'INT', NULL, NULL, NULL, NULL)\n" + \
                   ")\n" + \
                   "UPDATE mdi.edw_field_definition\n" + \
                   "SET data_type = update_rows.data_type\n" + \
                   "  , source_edw_field_definition_dwid = source_field_definition.dwid\n" + \
                   "FROM update_rows\n" + \
                   "JOIN mdi.edw_table_definition\n" + \
                   "     ON update_rows.database_name = edw_table_definition.database_name\n" + \
                   "         AND update_rows.schema_name = edw_table_definition.schema_name\n" + \
                   "         AND update_rows.table_name = edw_table_definition.table_name\n" + \
                   "LEFT JOIN mdi.edw_table_definition source_table_definition\n" + \
                   "          ON update_rows.source_database_name = source_table_definition.database_name\n" + \
                   "              AND update_rows.source_schema_name = source_table_definition.schema_name\n" + \
                   "              AND update_rows.source_table_name = source_table_definition.table_name\n" + \
                   "LEFT JOIN mdi.edw_field_definition source_field_definition\n" + \
                   "          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid\n" + \
                   "              AND update_rows.source_field_name = source_field_definition.field_name\n" + \
                   "WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid\n" + \
                   "  AND edw_field_definition.field_name = update_rows.field_name;"
        self.assertEqual(expected, EDWFieldDefinitionMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1',
                    'field_name': 'c1',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src',
                    'source_field_name': 'c1_src',
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src',
                    'field_name': 'c1_src',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': 'db1',
                    'source_schema_name': 'sch1',
                    'source_table_name': 't1_src_src',
                    'source_field_name': 'c1_src_src',
                }
            ),
            Row(
                key={
                    'database_name': 'db1',
                    'schema_name': 'sch1',
                    'table_name': 't1_src_src',
                    'field_name': 'c1_src_src',
                },
                attributes={
                    'data_type': 'TEXT',
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None,
                    'source_field_name': None
                }
            ),
            Row(
                key={
                    'database_name': 'db2',
                    'schema_name': 'sch2',
                    'table_name': 't2',
                    'field_name': 'c2',
                },
                attributes={
                    'data_type': 'INT',
                    'source_database_name': None,
                    'source_schema_name': None,
                    'source_table_name': None,
                    'source_field_name': None
                }
            )
        ]
        expected = "WITH delete_keys (database_name, schema_name, table_name, field_name) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 't1', 'c1')\n" + \
                   "         , ('db1', 'sch1', 't1_src', 'c1_src')\n" + \
                   "         , ('db1', 'sch1', 't1_src_src', 'c1_src_src')\n" + \
                   "         , ('db2', 'sch2', 't2', 'c2')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.edw_field_definition\n" + \
                   "    USING delete_keys, mdi.edw_table_definition\n" + \
                   "WHERE edw_table_definition.database_name = delete_keys.database_name\n" + \
                   "  AND edw_table_definition.schema_name = delete_keys.schema_name\n" + \
                   "  AND edw_table_definition.table_name = delete_keys.table_name\n" + \
                   "  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid\n" + \
                   "  AND edw_field_definition.field_name = delete_keys.field_name;"
        self.assertEqual(expected, EDWFieldDefinitionMetadataComparisonFunctions().generate_delete_sql(test_data))

    if __name__ == '__main__':
        unittest.main()
