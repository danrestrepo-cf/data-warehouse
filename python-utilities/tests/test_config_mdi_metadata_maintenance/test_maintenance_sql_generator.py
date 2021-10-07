import unittest
from typing import List

from tests.test_utils import MockLocalEDWConnection

from lib.config_mdi_metadata_maintenance.metadata_table import Row, MetadataTable
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper
from lib.db_connections import LocalEDWConnection
from lib.config_mdi_metadata_maintenance.maintenance_sql_generator import generate_metadata_maintenance_sql, TableMaintenanceSQL
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import MetadataComparisonFunctions


class TestingMetadataComparisonFunctions(MetadataComparisonFunctions):
    """
    A MetadataComparisonFunctions subclass useful for testing the functionality of generate_metadata_maintenance_sql

    Testing using a new subclass created exclusively for this test suite decouples these tests from any specific
    MetadataComparisonFunctions subclass used in the real application (e.g. process, edw_field_definitions, etc)
    """

    def __init__(self):
        super().__init__(key_fields=['column_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        # mock DB connection will return pre-set results regardless of the query run, so query is just set to empty str
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, "")

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for column in table.columns:
                        metadata_table.add_row({'column_name': column.name, 'data_type': column.data_type})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        row_grouper = RowGrouper(key_fields=['column_name'])
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for column in table.columns:
                        if column.data_type == 'TEXT':
                            group_number = 0
                        else:
                            group_number = 1
                        row_grouper.add_group_assignment({'column_name': column.name}, group_number)
        return row_grouper

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return f'INSERT rows: {str(rows)}'

    def generate_update_sql(self, rows: List[Row]) -> str:
        return f'UPDATE rows: {str(rows)}'

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return f'DELETE rows: {str(rows)}'


class TestGenerateMetadataMaintenanceSQL(unittest.TestCase):
    def test_returns_only_empty_strings_if_no_metadata_exists_on_either_side(self):
        db_connection = MockLocalEDWConnection([])
        expected = TableMaintenanceSQL(
            insert_sql='',
            update_sql='',
            delete_sql=''
        )
        self.assertEqual(expected, generate_metadata_maintenance_sql(db_connection, DataWarehouseMetadata('dw'),
                                                                     TestingMetadataComparisonFunctions()))

    def test_returns_only_empty_strings_if_no_metadata_differences_are_found(self):
        db_connection = MockLocalEDWConnection([
            {'column_name': 'col1', 'data_type': 'TEXT'}
        ])
        dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'dw1',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'schema1',
                                'tables': [
                                    {
                                        'name': 'table1',
                                        'columns': {
                                            'col1': {
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
        )
        expected = TableMaintenanceSQL(
            insert_sql='',
            update_sql='',
            delete_sql=''
        )
        self.assertEqual(expected, generate_metadata_maintenance_sql(db_connection, dw_metadata, TestingMetadataComparisonFunctions()))

    def test_returns_appropriate_insert_sql_if_metadata_is_missing_on_the_config_side(self):
        db_connection = MockLocalEDWConnection([])
        dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'dw1',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'schema1',
                                'tables': [
                                    {
                                        'name': 'table1',
                                        'columns': {
                                            'col1': {
                                                'data_type': 'TEXT'
                                            },
                                            'col2': {
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
        )
        expected = TableMaintenanceSQL(
            insert_sql='INSERT rows: [Row(key={\'column_name\': \'col1\'}, attributes={\'data_type\': \'TEXT\'}), Row(key={\'column_name\': \'col2\'}, attributes={\'data_type\': \'TEXT\'})]',
            update_sql='',
            delete_sql=''
        )
        self.assertEqual(expected, generate_metadata_maintenance_sql(db_connection, dw_metadata, TestingMetadataComparisonFunctions()))

    def test_creates_one_insert_sql_statement_per_row_group(self):
        db_connection = MockLocalEDWConnection([])
        dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'dw1',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'schema1',
                                'tables': [
                                    {
                                        'name': 'table1',
                                        'columns': {
                                            'col1': {
                                                'data_type': 'TEXT'
                                            },
                                            'col2': {
                                                'data_type': 'INT'
                                            },
                                            'col3': {
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
        )
        expected = TableMaintenanceSQL(
            insert_sql='INSERT rows: [Row(key={\'column_name\': \'col1\'}, attributes={\'data_type\': \'TEXT\'}), Row(key={\'column_name\': \'col3\'}, attributes={\'data_type\': \'TEXT\'})]\n\n' +
                       'INSERT rows: [Row(key={\'column_name\': \'col2\'}, attributes={\'data_type\': \'INT\'})]',
            update_sql='',
            delete_sql=''
        )
        self.assertEqual(expected, generate_metadata_maintenance_sql(db_connection, dw_metadata, TestingMetadataComparisonFunctions()))


if __name__ == '__main__':
    unittest.main()
