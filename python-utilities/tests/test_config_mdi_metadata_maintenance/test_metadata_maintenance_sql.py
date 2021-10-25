import unittest
from typing import List

from tests.test_utils import MockDBConnection

from lib.config_mdi_metadata_maintenance.metadata_table import Row, MetadataTable
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_maintenance_sql import MetadataMaintenanceSQLGenerator, TableMaintenanceSQL
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

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
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
        row_grouper = RowGrouper(MultiKeyMap(key_fields=['column_name']))
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

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        row_grouper = RowGrouper(MultiKeyMap(key_fields=['column_name']))
        for row in metadata_table.rows:
            if row.attributes['data_type'] == 'TEXT':
                group_number = 1
            else:
                group_number = 0
            row_grouper.add_group_assignment({'column_name': row.key['column_name']}, group_number)
        return row_grouper

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return f'INSERT rows: {str(rows)}'

    def generate_update_sql(self, rows: List[Row]) -> str:
        return f'UPDATE rows: {str(rows)}'

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return f'DELETE rows: {str(rows)}'


class TestGenerateTableMaintenanceSQL(unittest.TestCase):
    def test_returns_only_empty_strings_if_no_metadata_exists_on_either_side(self):
        db_connection = MockDBConnection([])
        expected = TableMaintenanceSQL(
            insert_sql='',
            update_sql='',
            delete_sql=''
        )
        generator = MetadataMaintenanceSQLGenerator(db_connection, DataWarehouseMetadata('dw'))
        self.assertEqual(expected, generator.generate_table_metadata_maintenance_sql(TestingMetadataComparisonFunctions()))

    def test_returns_only_empty_strings_if_no_metadata_differences_are_found(self):
        db_connection = MockDBConnection([
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
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        self.assertEqual(expected, generator.generate_table_metadata_maintenance_sql(TestingMetadataComparisonFunctions()))

    def test_returns_appropriate_insert_sql_if_metadata_is_missing_on_the_config_side(self):
        db_connection = MockDBConnection([])
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
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        self.assertEqual(expected, generator.generate_table_metadata_maintenance_sql(TestingMetadataComparisonFunctions()))

    def test_creates_one_insert_sql_statement_per_row_group(self):
        db_connection = MockDBConnection([])
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
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        self.assertEqual(expected, generator.generate_table_metadata_maintenance_sql(TestingMetadataComparisonFunctions()))

    def test_returns_appropriate_update_sql_if_metadata_is_different_between_source_and_config(self):
        db_connection = MockDBConnection([
            {'column_name': 'col1', 'data_type': 'INT'},
            {'column_name': 'col2', 'data_type': 'TEXT'}
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
                                            },
                                            'col2': {
                                                'data_type': 'INT'
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
            update_sql='UPDATE rows: [Row(key={\'column_name\': \'col1\'}, attributes={\'data_type\': \'TEXT\'}), Row(key={\'column_name\': \'col2\'}, attributes={\'data_type\': \'INT\'})]',
            delete_sql=''
        )
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        self.assertEqual(expected, generator.generate_table_metadata_maintenance_sql(TestingMetadataComparisonFunctions()))

    def test_returns_appropriate_delete_sql_if_metadata_is_missing_from_source(self):
        db_connection = MockDBConnection([
            {'column_name': 'col1', 'data_type': 'TEXT'},
            {'column_name': 'col2', 'data_type': 'TEXT'}
        ])
        dw_metadata = DataWarehouseMetadata('dw')
        expected = TableMaintenanceSQL(
            insert_sql='',
            update_sql='',
            delete_sql='DELETE rows: [Row(key={\'column_name\': \'col1\'}, attributes={\'data_type\': \'TEXT\'}), Row(key={\'column_name\': \'col2\'}, attributes={\'data_type\': \'TEXT\'})]'
        )
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        self.assertEqual(expected, generator.generate_table_metadata_maintenance_sql(TestingMetadataComparisonFunctions()))

    def test_creates_one_delete_sql_statement_per_row_group(self):
        db_connection = MockDBConnection([
            {'column_name': 'col1', 'data_type': 'INT'},
            {'column_name': 'col2', 'data_type': 'TEXT'}
        ])
        dw_metadata = DataWarehouseMetadata('dw')
        expected = TableMaintenanceSQL(
            insert_sql='',
            update_sql='',
            delete_sql='DELETE rows: [Row(key={\'column_name\': \'col1\'}, attributes={\'data_type\': \'INT\'})]\n\n' +
                       'DELETE rows: [Row(key={\'column_name\': \'col2\'}, attributes={\'data_type\': \'TEXT\'})]'
        )
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        self.assertEqual(expected, generator.generate_table_metadata_maintenance_sql(TestingMetadataComparisonFunctions()))


# MetadataComparisonFunctions subclasses used for testing the full metadata maintenance process
class TestComparisonFunctions1(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['column_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
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
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return f'INSERT rows for Table1'

    def generate_update_sql(self, rows: List[Row]) -> str:
        return f'UPDATE rows for Table1'

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return f'DELETE rows for Table1'


class TestComparisonFunctions2(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['column_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
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
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return f'INSERT rows for Table2'

    def generate_update_sql(self, rows: List[Row]) -> str:
        return f'UPDATE rows for Table2'

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return f'DELETE rows for Table2'


class TestComparisonFunctions3(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['column_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
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
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return f'INSERT rows for Table3'

    def generate_update_sql(self, rows: List[Row]) -> str:
        return f'UPDATE rows for Table3'

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return f'DELETE rows for Table3'


class TestSetOrderErrorChecking(unittest.TestCase):

    def test_set_insert_order_throws_error_if_table_list_doesnt_match_known_comparison_functions(self):
        generator = MetadataMaintenanceSQLGenerator(MockDBConnection([]), DataWarehouseMetadata('dw'))
        generator.add_metadata_comparison_functions('Table1', TestComparisonFunctions1())
        generator.add_metadata_comparison_functions('Table2', TestComparisonFunctions2())
        generator.add_metadata_comparison_functions('Table3', TestComparisonFunctions3())
        with self.assertRaises(MetadataMaintenanceSQLGenerator.InvalidTableOrderException) as e:
            generator.set_insert_table_order(['Table2'])
        expected_msg = 'Tables missing from table order list: Table1, Table3'
        self.assertEqual(expected_msg, str(e.exception))

    def test_set_update_order_throws_error_if_table_list_doesnt_match_known_comparison_functions(self):
        generator = MetadataMaintenanceSQLGenerator(MockDBConnection([]), DataWarehouseMetadata('dw'))
        generator.add_metadata_comparison_functions('Table1', TestComparisonFunctions1())
        generator.add_metadata_comparison_functions('Table2', TestComparisonFunctions2())
        generator.add_metadata_comparison_functions('Table3', TestComparisonFunctions3())
        with self.assertRaises(MetadataMaintenanceSQLGenerator.InvalidTableOrderException) as e:
            generator.set_update_table_order(['Table1', 'Table2', 'Table3', 'Table4', 'Table5'])
        expected_msg = 'Unknown tables in table order list: Table4, Table5'
        self.assertEqual(expected_msg, str(e.exception))

    def test_set_delete_order_throws_error_if_table_list_doesnt_match_known_comparison_functions(self):
        generator = MetadataMaintenanceSQLGenerator(MockDBConnection([]), DataWarehouseMetadata('dw'))
        generator.add_metadata_comparison_functions('Table1', TestComparisonFunctions1())
        generator.add_metadata_comparison_functions('Table2', TestComparisonFunctions2())
        generator.add_metadata_comparison_functions('Table3', TestComparisonFunctions3())
        with self.assertRaises(MetadataMaintenanceSQLGenerator.InvalidTableOrderException) as e:
            generator.set_delete_table_order(['Table1', 'Table3', 'Table4'])
        expected_msg = 'Tables missing from table order list: Table2; Unknown tables in table order list: Table4'
        self.assertEqual(expected_msg, str(e.exception))


class TestGenerateAllMetadataMaintenanceSQL(unittest.TestCase):

    def test_returns_empty_string_if_no_maintenance_is_needed(self):
        db_connection = MockDBConnection([
            {'column_name': 'col1', 'data_type': 'TEXT'},
            {'column_name': 'col2', 'data_type': 'INT'}
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
                                            },
                                            'col2': {
                                                'data_type': 'INT'
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
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        generator.add_metadata_comparison_functions('Table1', TestComparisonFunctions1())
        generator.add_metadata_comparison_functions('Table2', TestComparisonFunctions2())
        generator.add_metadata_comparison_functions('Table3', TestComparisonFunctions3())
        self.assertEqual('', generator.generate_all_metadata_maintenance_sql())

    def test_returns_all_generated_sql_in_the_order_in_which_the_comparison_functions_were_recorded_by_default(self):
        db_connection = MockDBConnection([
            {'column_name': 'col1', 'data_type': 'INT'},
            {'column_name': 'col2', 'data_type': 'TEXT'}
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
                                            },
                                            'col3': {
                                                'data_type': 'INT'
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
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        generator.add_metadata_comparison_functions('Table1', TestComparisonFunctions1())
        generator.add_metadata_comparison_functions('Table2', TestComparisonFunctions2())
        generator.add_metadata_comparison_functions('Table3', TestComparisonFunctions3())
        expected = '/*\nINSERTIONS\n*/\n\n' + \
                   '--Table1\n' + \
                   'INSERT rows for Table1\n\n' + \
                   '--Table2\n' + \
                   'INSERT rows for Table2\n\n' + \
                   '--Table3\n' + \
                   'INSERT rows for Table3\n\n' + \
                   '/*\nUPDATES\n*/\n\n' + \
                   '--Table1\n' + \
                   'UPDATE rows for Table1\n\n' + \
                   '--Table2\n' + \
                   'UPDATE rows for Table2\n\n' + \
                   '--Table3\n' + \
                   'UPDATE rows for Table3\n\n' + \
                   '/*\nDELETIONS\n*/\n\n' + \
                   '--Table1\n' + \
                   'DELETE rows for Table1\n\n' + \
                   '--Table2\n' + \
                   'DELETE rows for Table2\n\n' + \
                   '--Table3\n' + \
                   'DELETE rows for Table3'
        self.assertEqual(expected, generator.generate_all_metadata_maintenance_sql())

    def test_returns_all_generated_sql_in_custom_order_if_order_is_specified(self):
        db_connection = MockDBConnection([
            {'column_name': 'col1', 'data_type': 'INT'},
            {'column_name': 'col2', 'data_type': 'TEXT'}
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
                                            },
                                            'col3': {
                                                'data_type': 'INT'
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
        generator = MetadataMaintenanceSQLGenerator(db_connection, dw_metadata)
        generator.add_metadata_comparison_functions('Table1', TestComparisonFunctions1())
        generator.add_metadata_comparison_functions('Table2', TestComparisonFunctions2())
        generator.add_metadata_comparison_functions('Table3', TestComparisonFunctions3())
        generator.set_insert_table_order(['Table2', 'Table3', 'Table1'])
        generator.set_update_table_order(['Table2', 'Table1', 'Table3'])
        generator.set_delete_table_order(['Table3', 'Table2', 'Table1'])
        expected = '/*\nINSERTIONS\n*/\n\n' + \
                   '--Table2\n' + \
                   'INSERT rows for Table2\n\n' + \
                   '--Table3\n' + \
                   'INSERT rows for Table3\n\n' + \
                   '--Table1\n' + \
                   'INSERT rows for Table1\n\n' + \
                   '/*\nUPDATES\n*/\n\n' + \
                   '--Table2\n' + \
                   'UPDATE rows for Table2\n\n' + \
                   '--Table1\n' + \
                   'UPDATE rows for Table1\n\n' + \
                   '--Table3\n' + \
                   'UPDATE rows for Table3\n\n' + \
                   '/*\nDELETIONS\n*/\n\n' + \
                   '--Table3\n' + \
                   'DELETE rows for Table3\n\n' + \
                   '--Table2\n' + \
                   'DELETE rows for Table2\n\n' + \
                   '--Table1\n' + \
                   'DELETE rows for Table1'
        self.assertEqual(expected, generator.generate_all_metadata_maintenance_sql())


if __name__ == '__main__':
    unittest.main()
