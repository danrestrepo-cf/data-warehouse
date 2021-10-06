from dataclasses import dataclass
from typing import List, Iterable


@dataclass
class Row:
    key: dict
    attributes: dict


class MetadataTable:

    def __init__(self, key_fields: List[str]):
        self._rows = {}
        self._key_fields = key_fields
        return

    def add_row(self, row: dict):
        """Add a single row to the metadata table. Row must have all required key fields."""
        row_key = self._create_key_values_tuple_from_dict(row)
        self._rows[row_key] = Row(
            key={field: value for field, value in row.items() if field in self._key_fields},
            attributes={field: value for field, value in row.items() if field not in self._key_fields}
        )

    def add_rows(self, rows: Iterable[dict]):
        """Add multiple rows to the metadata table. All added rows must have all required key fields."""
        for row in rows:
            self.add_row(row)

    @property
    def rows(self) -> List[Row]:
        return list(self._rows.values())

    def row_exists_with_key(self, key: dict):
        """Return true if a row exists in the table with the given key, false otherwise"""
        return self._create_key_values_tuple_from_dict(key) in self._rows

    def get_attributes_by_key(self, key: dict) -> dict:
        """Return non-key metadata attributes for the row with the given key"""
        key_tuple = self._create_key_values_tuple_from_dict(key)
        if key_tuple not in self._rows:
            raise self.InvalidKeyValuesException(key_tuple)
        return self._rows[key_tuple].attributes

    def _create_key_values_tuple_from_dict(self, d: dict):
        # throw error if given dict doesn't contain all required key fields
        for key_field in self._key_fields:
            if key_field not in d:
                raise self.InvalidKeyFieldsException(self._key_fields, d)
        return tuple(d[key_field] for key_field in self._key_fields)

    class InvalidKeyFieldsException(Exception):
        def __init__(self, key_fields: List[str], row: dict):
            super().__init__(f'{row} does not contain required key fields {key_fields}')

    class InvalidKeyValuesException(Exception):
        def __init__(self, key: tuple):
            super().__init__(f'No row exists with key values matching {key}')
