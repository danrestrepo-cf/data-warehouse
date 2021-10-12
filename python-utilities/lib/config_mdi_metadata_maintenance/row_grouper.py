from typing import List
from collections import defaultdict
from lib.config_mdi_metadata_maintenance.metadata_table import Row
from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap


class RowGrouper:

    def __init__(self, row_group_map: MultiKeyMap):
        self._map = row_group_map

    def add_group_assignment(self, key: dict, group_number: int):
        self._map.add_entry(key, group_number)

    def get_row_group_number(self, row: Row) -> int:
        return self._map.get_value_by_key(row.key)

    def group_rows(self, rows: List[Row]) -> List[List[Row]]:
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
    """A special RowGrouper that always returns all given rows in the same group"""

    def __init__(self):
        super().__init__(MultiKeyMap([]))

    def group_rows(self, rows: List[Row]) -> List[List[Row]]:
        return [rows]

    def add_group_assignment(self, key: dict, group_number: int):
        pass  # group assignments aren't needed in this subclass
