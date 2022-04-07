import unittest

from lib.metadata_core.metadata_object_path import DatabasePath, SchemaPath, TablePath, ColumnPath


class TestDatabasePath(unittest.TestCase):

    def test_can_make_schema_path(self):
        db_path = DatabasePath(database='db1')
        expected = SchemaPath(database='db1', schema='sch1')
        self.assertEqual(expected, db_path.make_schema_path('sch1'))


class TestSchemaPath(unittest.TestCase):

    def test_can_generate_database_path(self):
        schema_path = SchemaPath(database='db1', schema='sch1')
        expected = DatabasePath(database='db1')
        self.assertEqual(expected, schema_path.database_path)

    def test_can_make_table_path(self):
        schema_path = SchemaPath(database='db1', schema='sch1')
        expected = TablePath(database='db1', schema='sch1', table='t1')
        self.assertEqual(expected, schema_path.make_table_path('t1'))


class TestTablePath(unittest.TestCase):

    def test_can_generate_database_path(self):
        table_path = TablePath(database='db1', schema='sch1', table='t1')
        expected = DatabasePath(database='db1')
        self.assertEqual(expected, table_path.database_path)

    def test_can_generate_schema_path(self):
        table_path = TablePath(database='db1', schema='sch1', table='t1')
        expected = SchemaPath(database='db1', schema='sch1')
        self.assertEqual(expected, table_path.schema_path)

    def test_can_make_column_path(self):
        table_path = TablePath(database='db1', schema='sch1', table='t1')
        expected = ColumnPath(database='db1', schema='sch1', table='t1', column='c1')
        self.assertEqual(expected, table_path.make_column_path('c1'))


class TestColumnPath(unittest.TestCase):

    def test_can_generate_database_path(self):
        column_path = ColumnPath(database='db1', schema='sch1', table='t1', column='c1')
        expected = DatabasePath(database='db1')
        self.assertEqual(expected, column_path.database_path)

    def test_can_generate_schema_path(self):
        column_path = ColumnPath(database='db1', schema='sch1', table='t1', column='c1')
        expected = SchemaPath(database='db1', schema='sch1')
        self.assertEqual(expected, column_path.schema_path)

    def test_can_generate_table_path(self):
        column_path = ColumnPath(database='db1', schema='sch1', table='t1', column='c1')
        expected = TablePath(database='db1', schema='sch1', table='t1')
        self.assertEqual(expected, column_path.table_path)


if __name__ == '__main__':
    unittest.main()
