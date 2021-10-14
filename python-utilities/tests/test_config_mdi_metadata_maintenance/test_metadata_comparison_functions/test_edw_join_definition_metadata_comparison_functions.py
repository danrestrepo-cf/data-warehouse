import unittest

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import EDWJoinDefinitionMetadataComparisonFunctions


class TestEDWJoinDefinitionMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {
                'primary_database_name': 'db1',
                'primary_schema_name': 'sch1',
                'primary_table_name': 'table10',
                'target_database_name': 'db1',
                'target_schema_name': 'sch1',
                'target_table_name': 'table11',
                'join_condition': 'primary_table.col1 = target_table.col1'
            },
            {
                'primary_database_name': 'db1',
                'primary_schema_name': 'sch1',
                'primary_table_name': 'table20',
                'target_database_name': 'db1',
                'target_schema_name': 'sch1',
                'target_table_name': 'table21',
                'join_condition': 'primary_table.col2 = target_table.col2'
            },
            {
                'primary_database_name': 'db2',
                'primary_schema_name': 'sch2',
                'primary_table_name': 'table30',
                'target_database_name': 'db2',
                'target_schema_name': 'sch2',
                'target_table_name': 'table31',
                'join_condition': 'primary_table.col3 = target_table.col3'
            },
        ]
        db_conn = MockLocalEDWConnection(query_results=test_data)
        expected = MetadataTable(key_fields=[
            'primary_database_name',
            'primary_schema_name',
            'primary_table_name',
            'target_database_name',
            'target_schema_name',
            'target_table_name',
            'join_condition'
        ])
        expected.add_rows(test_data)
        self.assertEqual(expected, EDWJoinDefinitionMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

    def test_construct_metadata_table_from_source(self):
        dw_metadata = construct_data_warehouse_metadata_from_dict(
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
                                        'name': 'table10',
                                        'foreign_keys': {
                                            'fk1': {
                                                'columns': ['col1'],
                                                'references': {
                                                    'columns': ['col1'],
                                                    'schema': 'sch1',
                                                    'table': 'table11'
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table20',
                                        'foreign_keys': {
                                            'fk2': {
                                                'columns': ['col1', 'col2'],
                                                'references': {
                                                    'columns': ['col1', 'col2'],
                                                    'schema': 'sch1',
                                                    'table': 'table21'
                                                }
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
                                        'name': 'table30',
                                        'foreign_keys': {
                                            'fk3': {
                                                'columns': ['col3'],
                                                'references': {
                                                    'columns': ['col3'],
                                                    'schema': 'sch2',
                                                    'table': 'table31'
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

        expected = MetadataTable(key_fields=[
            'primary_database_name',
            'primary_schema_name',
            'primary_table_name',
            'target_database_name',
            'target_schema_name',
            'target_table_name',
            'join_condition'
        ])
        expected.add_rows([
            {
                'primary_database_name': 'db1',
                'primary_schema_name': 'sch1',
                'primary_table_name': 'table10',
                'target_database_name': 'db1',
                'target_schema_name': 'sch1',
                'target_table_name': 'table11',
                'join_condition': 'primary_table.col1 = target_table.col1'
            },
            {
                'primary_database_name': 'db1',
                'primary_schema_name': 'sch1',
                'primary_table_name': 'table20',
                'target_database_name': 'db1',
                'target_schema_name': 'sch1',
                'target_table_name': 'table21',
                'join_condition': 'primary_table.col1 = target_table.col1 AND primary_table.col2 = target_table.col2'
            },
            {
                'primary_database_name': 'db2',
                'primary_schema_name': 'sch2',
                'primary_table_name': 'table30',
                'target_database_name': 'db2',
                'target_schema_name': 'sch2',
                'target_table_name': 'table31',
                'join_condition': 'primary_table.col3 = target_table.col3'
            },
        ])
        self.assertEqual(expected, EDWJoinDefinitionMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_dependency_row_grouper(self):
        test_data = [
            Row(
                key={
                    'primary_database_name': 'db1',
                    'primary_schema_name': 'sch1',
                    'primary_table_name': 'table10',
                    'target_database_name': 'db1',
                    'target_schema_name': 'sch1',
                    'target_table_name': 'table11',
                    'join_condition': 'primary_table.col1 = target_table.col1'
                },
                attributes={}
            ),
            Row(
                key={
                    'primary_database_name': 'db1',
                    'primary_schema_name': 'sch1',
                    'primary_table_name': 'table20',
                    'target_database_name': 'db1',
                    'target_schema_name': 'sch1',
                    'target_table_name': 'table21',
                    'join_condition': 'primary_table.col1 = target_table.col1 AND primary_table.col2 = target_table.col2'
                },
                attributes={}
            ),
            Row(
                key={

                    'primary_database_name': 'db2',
                    'primary_schema_name': 'sch2',
                    'primary_table_name': 'table30',
                    'target_database_name': 'db2',
                    'target_schema_name': 'sch2',
                    'target_table_name': 'table31',
                    'join_condition': 'primary_table.col3 = target_table.col3'
                },
                attributes={}
            )
        ]
        row_grouper = EDWJoinDefinitionMetadataComparisonFunctions().construct_dependency_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(
                key={
                    'primary_database_name': 'db1',
                    'primary_schema_name': 'sch1',
                    'primary_table_name': 'table10',
                    'target_database_name': 'db1',
                    'target_schema_name': 'sch1',
                    'target_table_name': 'table11',
                    'join_condition': 'primary_table.col1 = target_table.col1'
                },
                attributes={}
            ),
            Row(
                key={
                    'primary_database_name': 'db1',
                    'primary_schema_name': 'sch1',
                    'primary_table_name': 'table20',
                    'target_database_name': 'db1',
                    'target_schema_name': 'sch1',
                    'target_table_name': 'table21',
                    'join_condition': 'primary_table.col1 = target_table.col1 AND primary_table.col2 = target_table.col2'
                },
                attributes={}
            ),
            Row(
                key={

                    'primary_database_name': 'db2',
                    'primary_schema_name': 'sch2',
                    'primary_table_name': 'table30',
                    'target_database_name': 'db2',
                    'target_schema_name': 'sch2',
                    'target_table_name': 'table31',
                    'join_condition': 'primary_table.col3 = target_table.col3'
                },
                attributes={}
            )
        ]
        expected = "WITH insert_rows (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 'table10', 'db1', 'sch1', 'table11', 'primary_table.col1 = target_table.col1')\n" + \
                   "         , ('db1', 'sch1', 'table20', 'db1', 'sch1', 'table21', 'primary_table.col1 = target_table.col1 AND primary_table.col2 = target_table.col2')\n" + \
                   "         , ('db2', 'sch2', 'table30', 'db2', 'sch2', 'table31', 'primary_table.col3 = target_table.col3')\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.edw_join_definition (dwid, primary_edw_table_definition_dwid, target_edw_table_definition_dwid, join_type, join_condition)\n" + \
                   "SELECT NEXTVAL( 'mdi.edw_join_definition_dwid_seq' )\n" + \
                   "     , primary_table.dwid\n" + \
                   "     , target_table.dwid\n" + \
                   "     , 'left'\n" + \
                   "     , REPLACE( insert_rows.join_condition, 'target_table', 't' || CURRVAL( 'mdi.edw_join_definition_dwid_seq' ) )\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.edw_table_definition primary_table\n" + \
                   "     ON insert_rows.primary_database_name = primary_table.database_name\n" + \
                   "         AND insert_rows.primary_schema_name = primary_table.schema_name\n" + \
                   "         AND insert_rows.primary_table_name = primary_table.table_name\n" + \
                   "JOIN mdi.edw_table_definition target_table\n" + \
                   "     ON insert_rows.target_database_name = target_table.database_name\n" + \
                   "         AND insert_rows.target_schema_name = target_table.schema_name\n" + \
                   "         AND insert_rows.target_table_name = target_table.table_name;"
        self.assertEqual(expected, EDWJoinDefinitionMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(
                key={
                    'primary_database_name': 'db1',
                    'primary_schema_name': 'sch1',
                    'primary_table_name': 'table10',
                    'target_database_name': 'db1',
                    'target_schema_name': 'sch1',
                    'target_table_name': 'table11',
                    'join_condition': 'primary_table.col1 = target_table.col1'
                },
                attributes={}
            )
        ]
        expected = ""
        self.assertEqual(expected, EDWJoinDefinitionMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(
                key={
                    'primary_database_name': 'db1',
                    'primary_schema_name': 'sch1',
                    'primary_table_name': 'table10',
                    'target_database_name': 'db1',
                    'target_schema_name': 'sch1',
                    'target_table_name': 'table11',
                    'join_condition': 'primary_table.col1 = target_table.col1'
                },
                attributes={}
            ),
            Row(
                key={
                    'primary_database_name': 'db1',
                    'primary_schema_name': 'sch1',
                    'primary_table_name': 'table20',
                    'target_database_name': 'db1',
                    'target_schema_name': 'sch1',
                    'target_table_name': 'table21',
                    'join_condition': 'primary_table.col1 = target_table.col1 AND primary_table.col2 = target_table.col2'
                },
                attributes={}
            ),
            Row(
                key={

                    'primary_database_name': 'db2',
                    'primary_schema_name': 'sch2',
                    'primary_table_name': 'table30',
                    'target_database_name': 'db2',
                    'target_schema_name': 'sch2',
                    'target_table_name': 'table31',
                    'join_condition': 'primary_table.col3 = target_table.col3'
                },
                attributes={}
            )
        ]
        expected = "WITH delete_keys (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (\n" + \
                   "    VALUES ('db1', 'sch1', 'table10', 'db1', 'sch1', 'table11', 'primary_table.col1 = target_table.col1')\n" + \
                   "         , ('db1', 'sch1', 'table20', 'db1', 'sch1', 'table21', 'primary_table.col1 = target_table.col1 AND primary_table.col2 = target_table.col2')\n" + \
                   "         , ('db2', 'sch2', 'table30', 'db2', 'sch2', 'table31', 'primary_table.col3 = target_table.col3')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.edw_join_definition\n" + \
                   "    USING delete_keys, edw_table_definition primary_table, edw_table_definition target_table\n" + \
                   "WHERE delete_keys.primary_database_name = primary_table.database_name\n" + \
                   "  AND delete_keys.primary_schema_name = primary_table.schema_name\n" + \
                   "  AND delete_keys.primary_table_name = primary_table.table_name\n" + \
                   "  AND delete_keys.target_database_name = target_table.database_name\n" + \
                   "  AND delete_keys.target_schema_name = target_table.schema_name\n" + \
                   "  AND delete_keys.target_table_name = target_table.table_name\n" + \
                   "  AND primary_table.dwid = edw_join_definition.primary_edw_table_definition_dwid\n" + \
                   "  AND target_table.dwid = edw_join_definition.target_edw_table_definition_dwid\n" + \
                   "  AND delete_keys.join_condition = REGEXP_REPLACE( edw_join_definition.join_condition, 't[0-9]+\.', 'target_table.' );"
        self.assertEqual(expected, EDWJoinDefinitionMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
