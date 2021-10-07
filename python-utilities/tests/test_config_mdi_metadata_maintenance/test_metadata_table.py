import unittest
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap


class TestMetadataTable(unittest.TestCase):
    def test_throws_error_if_single_added_row_doesnt_contain_all_key_fields(self):
        table = MetadataTable(key_fields=['key1', 'key2'])
        with self.assertRaises(MultiKeyMap.InvalidKeyFieldsException):
            table.add_row({})
        with self.assertRaises(MultiKeyMap.InvalidKeyFieldsException):
            table.add_row({'key1': 1})

    def test_throws_error_if_any_added_row_doesnt_contain_all_key_fields(self):
        table = MetadataTable(key_fields=['key1', 'key2'])
        with self.assertRaises(MultiKeyMap.InvalidKeyFieldsException):
            table.add_rows([{'key1': 1, 'key2': 2},
                            {'key1': 3, 'key2': 4},
                            {'key1': 5, 'other_column_name': 6}])

    def test_confirms_existence_of_added_row_by_its_key(self):
        table = MetadataTable(key_fields=['key1', 'key2'])
        table.add_row({'key1': 1, 'key2': 2, 'attribute1': 'one'})
        self.assertTrue(table.row_exists_with_key({'key1': 1, 'key2': 2}))

    def test_confirms_nonexistence_of_row_that_wasnt_added_by_its_key(self):
        table = MetadataTable(key_fields=['key1', 'key2'])
        self.assertFalse(table.row_exists_with_key({'key1': 1, 'key2': 2}))

    def test_can_query_nonkey_attributes_given_row_key(self):
        table = MetadataTable(key_fields=['key1', 'key2'])
        table.add_row({'key1': 1, 'key2': 2, 'attribute1': 'one', 'attribute2': 'two'})
        self.assertEqual({'attribute1': 'one', 'attribute2': 'two'}, table.get_attributes_by_key({'key1': 1, 'key2': 2}))

    def test_throws_error_if_user_requests_attributes_for_nonexistent_key(self):
        table = MetadataTable(key_fields=['key1', 'key2'])
        with self.assertRaises(MultiKeyMap.InvalidKeyValuesException):
            table.get_attributes_by_key({'key1': 1, 'key2': 2})

    def test_can_iterate_through_table_rows(self):
        table = MetadataTable(key_fields=['key1', 'key2'])
        table.add_rows([{'key1': 1, 'key2': 2, 'attribute1': 'one', 'attribute2': 'two'},
                        {'key1': 3, 'key2': 4, 'attribute1': 'three', 'attribute2': 'four'},
                        {'key1': 5, 'key2': 6, 'attribute1': 'five', 'attribute2': 'six'}])
        expected = [
            Row(key={'key1': 1, 'key2': 2}, attributes={'attribute1': 'one', 'attribute2': 'two'}),
            Row(key={'key1': 3, 'key2': 4}, attributes={'attribute1': 'three', 'attribute2': 'four'}),
            Row(key={'key1': 5, 'key2': 6}, attributes={'attribute1': 'five', 'attribute2': 'six'})
        ]
        self.assertEqual(expected, [row for row in table.rows])


if __name__ == '__main__':
    unittest.main()
