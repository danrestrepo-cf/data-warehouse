import unittest

from tests.test_utils import MockDBConnection

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import InsertUpdateFieldMetadataComparisonFunctions


class TestInsertUpdateFieldMetadataComparisonFunctions(unittest.TestCase):

    def test_construct_metadata_table_from_config_db(self):
        """
        Note: this test doesn't actually test the config.mdi SQL query itself,
        just that the query's results are handled correctly. The query is tested
        via other integration/system tests
        """
        test_data = [
            {'process_name': 'ETL-1', 'update_lookup': 't1_col1', 'update_flag': 'N'},
            {'process_name': 'ETL-1', 'update_lookup': 't1_col2', 'update_flag': 'Y'},
            {'process_name': 'ETL-2', 'update_lookup': 't2_col1', 'update_flag': 'N'}
        ]
        db_conn = MockDBConnection(query_results=test_data)
        expected = MetadataTable(key_fields=['process_name', 'update_lookup'])
        expected.add_rows(test_data)
        self.assertEqual(expected, InsertUpdateFieldMetadataComparisonFunctions().construct_metadata_table_from_config_db(db_conn))

    def test_construct_metadata_table_from_source(self):
        dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'staging',
                        'schemas': [
                            {
                                'name': 'star_loan',
                                'tables': [
                                    {
                                        'name': 'table1',
                                        'primary_source_table': 'staging.history_octane.table1',
                                        'columns': {
                                            'dwid': {
                                                'data_type': 'BIGINT',
                                            },
                                            't1_col1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.t1_col1_src'
                                                },
                                                'update_flag': False
                                            },
                                            't1_col2': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.t1_col2_src'
                                                },
                                                'update_flag': True
                                            },
                                            't1_col3': {
                                                'data_type': 'TEXT',
                                                'update_flag': True
                                            }
                                        },
                                        'step_functions': {
                                            'SP-1': {
                                                'etls': {
                                                    'ETL-1': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update'
                                                    }
                                                }
                                            }
                                        }
                                    },
                                    {
                                        'name': 'table2',
                                        'primary_source_table': 'staging.history_octane.table2',
                                        'columns': {
                                            'dwid': {
                                                'data_type': 'BIGINT'
                                            },
                                            't2_col1': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.t2_col1_src'
                                                },
                                                'update_flag': False
                                            }
                                        },
                                        'step_functions': {
                                            'SP-1': {
                                                'etls': {
                                                    'ETL-2': {
                                                        'hardcoded_data_source': 'Octane',
                                                        'input_type': 'table',
                                                        'output_type': 'insert_update'
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
            }
        )

        expected = MetadataTable(key_fields=['process_name', 'update_lookup'])
        expected.add_rows([
            {'process_name': 'ETL-1', 'update_lookup': 't1_col1', 'update_flag': 'N'},
            {'process_name': 'ETL-1', 'update_lookup': 't1_col2', 'update_flag': 'Y'},
            {'process_name': 'ETL-1', 'update_lookup': 't1_col3', 'update_flag': 'Y'},
            {'process_name': 'ETL-2', 'update_lookup': 't2_col1', 'update_flag': 'N'}
        ])
        self.assertEqual(expected, InsertUpdateFieldMetadataComparisonFunctions().construct_metadata_table_from_source(dw_metadata))

    def test_construct_insert_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col1'}, attributes={'update_flag': 'N'}),
            Row(key={'process_name': 'ETL-2', 'update_lookup': 't1_col2'}, attributes={'update_flag': 'Y'}),
            Row(key={'process_name': 'ETL-3', 'update_lookup': 't2_col1'}, attributes={'update_flag': 'N'})
        ]
        row_grouper = InsertUpdateFieldMetadataComparisonFunctions().construct_insert_row_grouper(DataWarehouseMetadata('dw'))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_construct_delete_row_grouper(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col1'}, attributes={'update_flag': 'N'}),
            Row(key={'process_name': 'ETL-2', 'update_lookup': 't1_col2'}, attributes={'update_flag': 'Y'}),
            Row(key={'process_name': 'ETL-3', 'update_lookup': 't2_col1'}, attributes={'update_flag': 'N'})
        ]
        row_grouper = InsertUpdateFieldMetadataComparisonFunctions().construct_delete_row_grouper(MetadataTable([]))
        self.assertEqual([test_data], row_grouper.group_rows(test_data))

    def test_generate_insert_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col1'}, attributes={'update_flag': 'N'}),
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col2'}, attributes={'update_flag': 'Y'}),
            Row(key={'process_name': 'ETL-2', 'update_lookup': 't2_col1'}, attributes={'update_flag': 'N'})
        ]
        expected = "WITH insert_rows (process_name, update_lookup, update_flag) AS (\n" + \
                   "    VALUES ('ETL-1', 't1_col1', 'N')\n" + \
                   "         , ('ETL-1', 't1_col2', 'Y')\n" + \
                   "         , ('ETL-2', 't2_col1', 'N')\n" + \
                   ")\n" + \
                   "INSERT\n" + \
                   "INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)\n" + \
                   "SELECT insert_update_step.dwid, insert_rows.update_lookup, insert_rows.update_lookup, insert_rows.update_flag::mdi.pentaho_y_or_n, FALSE\n" + \
                   "FROM insert_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = insert_rows.process_name\n" + \
                   "JOIN mdi.insert_update_step\n" + \
                   "     ON process.dwid = insert_update_step.process_dwid;\n"
        self.assertEqual(expected, InsertUpdateFieldMetadataComparisonFunctions().generate_insert_sql(test_data))

    def test_generate_update_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col1'}, attributes={'update_flag': 'N'}),
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col2'}, attributes={'update_flag': 'Y'}),
            Row(key={'process_name': 'ETL-2', 'update_lookup': 't2_col1'}, attributes={'update_flag': 'N'})
        ]
        expected = "WITH update_rows (process_name, update_lookup, update_flag) AS (\n" + \
                   "    VALUES ('ETL-1', 't1_col1', 'N')\n" + \
                   "         , ('ETL-1', 't1_col2', 'Y')\n" + \
                   "         , ('ETL-2', 't2_col1', 'N')\n" + \
                   ")\n" + \
                   "UPDATE mdi.insert_update_field\n" + \
                   "SET update_flag = update_rows.update_flag::mdi.pentaho_y_or_n\n" + \
                   "FROM update_rows\n" + \
                   "JOIN mdi.process\n" + \
                   "     ON process.name = update_rows.process_name\n" + \
                   "JOIN mdi.insert_update_step\n" + \
                   "     ON process.dwid = insert_update_step.process_dwid\n" + \
                   "WHERE insert_update_step.dwid = insert_update_field.insert_update_step_dwid\n" + \
                   "     AND update_rows.update_lookup = insert_update_field.update_lookup;\n"
        self.assertEqual(expected, InsertUpdateFieldMetadataComparisonFunctions().generate_update_sql(test_data))

    def test_generate_delete_sql(self):
        test_data = [
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col1'}, attributes={'update_flag': 'N'}),
            Row(key={'process_name': 'ETL-1', 'update_lookup': 't1_col2'}, attributes={'update_flag': 'Y'}),
            Row(key={'process_name': 'ETL-2', 'update_lookup': 't2_col1'}, attributes={'update_flag': 'N'})
        ]
        expected = "WITH delete_keys (process_name, update_lookup) AS (\n" + \
                   "    VALUES ('ETL-1', 't1_col1')\n" + \
                   "         , ('ETL-1', 't1_col2')\n" + \
                   "         , ('ETL-2', 't2_col1')\n" + \
                   ")\n" + \
                   "DELETE\n" + \
                   "FROM mdi.insert_update_field\n" + \
                   "    USING delete_keys, mdi.process, mdi.insert_update_step\n" + \
                   "WHERE delete_keys.process_name = process.name\n" + \
                   "  AND process.dwid = insert_update_step.process_dwid\n" + \
                   "  AND insert_update_step.dwid = insert_update_field.insert_update_step_dwid\n" + \
                   "  AND delete_keys.update_lookup = insert_update_field.update_lookup;\n"
        self.assertEqual(expected, InsertUpdateFieldMetadataComparisonFunctions().generate_delete_sql(test_data))


if __name__ == '__main__':
    unittest.main()
