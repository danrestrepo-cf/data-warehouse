import unittest

from lib.config_mdi_metadata_maintenance.row_grouper import DefaultRowGrouper
from lib.config_mdi_metadata_maintenance.metadata_table import Row


class TestDefaultRowGrouper(unittest.TestCase):
    def test_returns_all_given_rows_in_the_same_group(self):
        row_grouper = DefaultRowGrouper()
        test_data = [Row({'col1': 1}, {'col2': 2}), Row({'col1': 10}, {'col2': 20}), Row({'col1': 100}, {'col2': 200})]
        expected = [[Row({'col1': 1}, {'col2': 2}), Row({'col1': 10}, {'col2': 20}), Row({'col1': 100}, {'col2': 200})]]
        self.assertEqual(expected, row_grouper.group_rows(test_data))


if __name__ == '__main__':
    unittest.main()
