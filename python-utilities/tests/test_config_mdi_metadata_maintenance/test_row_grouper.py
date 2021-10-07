import unittest

from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.config_mdi_metadata_maintenance.metadata_table import Row


class TestRowGrouper(unittest.TestCase):

    def test_single_group_row_grouper_returns_all_given_rows_in_the_same_group(self):
        row_grouper = SingleGroupRowGrouper()
        test_data = [Row({'col1': 1}, {'col2': 2}), Row({'col1': 10}, {'col2': 20}), Row({'col1': 100}, {'col2': 200})]
        expected = [[Row({'col1': 1}, {'col2': 2}), Row({'col1': 10}, {'col2': 20}), Row({'col1': 100}, {'col2': 200})]]
        self.assertEqual(expected, row_grouper.group_rows(test_data))

    def test_throws_error_if_one_of_the_given_rows_cannot_be_assigned_a_group(self):
        row_grouper = RowGrouper(['col1'])
        test_data = [Row({'col1': 1}, {'col2': 2})]
        with self.assertRaises(RowGrouper.UnableToGroupRowException):
            row_grouper.group_rows(test_data)

    def test_returns_a_list_of_row_lists_where_the_index_in_the_outer_list_corresponds_to_the_order_of_the_rows_group_number(self):
        row_grouper = RowGrouper(['col1', 'col2'])
        row_grouper.add_group_assignment({'col1': 1, 'col2': 2}, 0)
        row_grouper.add_group_assignment({'col1': 10, 'col2': 20}, -1)
        row_grouper.add_group_assignment({'col1': 100, 'col2': 200}, 2)
        row_grouper.add_group_assignment({'col1': 1000, 'col2': 2000}, 0)
        test_data = [
            Row({'col1': 1, 'col2': 2}, {'col3': 3}),
            Row({'col1': 10, 'col2': 20}, {'col3': 30}),
            Row({'col1': 100, 'col2': 200}, {'col3': 300}),
            Row({'col1': 1000, 'col2': 2000}, {'col3': 3000})
        ]
        expected = [
            [Row({'col1': 10, 'col2': 20}, {'col3': 30})],
            [Row({'col1': 1, 'col2': 2}, {'col3': 3}), Row({'col1': 1000, 'col2': 2000}, {'col3': 3000})],
            [Row({'col1': 100, 'col2': 200}, {'col3': 300})]
        ]
        self.assertEqual(expected, row_grouper.group_rows(test_data))


if __name__ == '__main__':
    unittest.main()
