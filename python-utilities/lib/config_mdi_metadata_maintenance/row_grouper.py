from typing import List
from collections import defaultdict
from lib.config_mdi_metadata_maintenance.metadata_table import Row
from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap


class RowGrouper:
    """A class that groups rows into sub-lists based on a stored mapping of row keys to group numbers."""

    def __init__(self, row_group_map: MultiKeyMap):
        """
        :param row_group_map: a multi-key map from row keys to group numbers. This
        map can be passed in already filled out, or can be passed in empty and filled
        out later through this class's methods.
        """
        self._map = row_group_map

    def add_group_assignment(self, key: dict, group_number: int):
        """Record a the group assignment of single row key."""
        self._map.add_entry(key, group_number)

    def get_row_group_number(self, row: Row) -> int:
        """Retrieve the assigned group number of the given row based on its key."""
        return self._map.get_value_by_key(row.key)

    def group_rows(self, rows: List[Row]) -> List[List[Row]]:
        """Group the given list of rows into a list of sub-lists in group-number-order.

        For example, if the grouper has previously been given the following group number assignments:

            ('a', 'b'): 1
            ('c', 'd'): 2
            ('e', 'f'): 1

        And this method is called with the following list passed in (assume the key is ('col1', 'col2')):
            [
                {'col1': 'a', 'col2': 'b', 'col3': 1},
                {'col1': 'c', 'col2': 'd', 'col3': 2},
                {'col1': 'e', 'col2': 'f', 'col3': 3},
            ]

        Then the result will be the following 2D list:
            [
                [
                    {'col1': 'a', 'col2': 'b', 'col3': 1},
                    {'col1': 'e', 'col2': 'f', 'col3': 3}
                ],
                [
                    {'col1': 'c', 'col2': 'd', 'col3': 2}
                ]
            ]
        """
        groups = defaultdict(list)
        for row in rows:
            if not self._map.entry_exists_with_key(row.key):
                raise self.UnableToGroupRowException(row)
            else:
                groups[self.get_row_group_number(row)].append(row)
        return [groups[group_number] for group_number in sorted(groups.keys())]

    class UnableToGroupRowException(Exception):
        def __init__(self, row: Row):
            super().__init__(f'Unable to determine group for row: {row}')


class SingleGroupRowGrouper(RowGrouper):
    """A special RowGrouper that always returns all given rows in the same group."""

    def __init__(self):
        super().__init__(MultiKeyMap([]))

    def group_rows(self, rows: List[Row]) -> List[List[Row]]:
        return [rows]

    def add_group_assignment(self, key: dict, group_number: int):
        pass  # group assignments aren't needed in this subclass
