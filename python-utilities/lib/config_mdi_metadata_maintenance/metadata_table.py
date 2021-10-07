from dataclasses import dataclass
from typing import List, Iterable

from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap


@dataclass
class Row:
    key: dict
    attributes: dict

    @property
    def full_row(self) -> dict:
        return {**self.key, **self.attributes}


class MetadataTable:

    def __init__(self, key_fields: List[str]):
        self._key_fields = key_fields
        self._map = MultiKeyMap(key_fields)
        return

    def add_row(self, row: dict):
        """Add a single row to the metadata table. Row must have all required key fields."""
        self._map.add_entry(row, Row(
            key={field: value for field, value in row.items() if field in self._key_fields},
            attributes={field: value for field, value in row.items() if field not in self._key_fields}
        ))

    def add_rows(self, rows: Iterable[dict]):
        """Add multiple rows to the metadata table. All added rows must have all required key fields."""
        for row in rows:
            self.add_row(row)

    @property
    def rows(self) -> List[Row]:
        return self._map.values

    def row_exists_with_key(self, key: dict):
        """Return true if a row exists in the table with the given key, false otherwise"""
        return self._map.entry_exists_with_key(key)

    def get_attributes_by_key(self, key: dict) -> dict:
        """Return non-key metadata attributes for the row with the given key"""
        return self._map.get_value_by_key(key)

    def __repr__(self):
        return f'MetadataTable(rows={repr(self.rows)})'

    def __eq__(self, other: 'MetadataTable') -> bool:
        return isinstance(other, MetadataTable) and self.rows == other.rows
