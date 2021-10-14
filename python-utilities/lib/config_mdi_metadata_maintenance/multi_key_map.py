from typing import List, Any


class MultiKeyMap:
    def __init__(self, key_fields: List[str]):
        self._key_fields = key_fields
        self._values = {}

    def add_entry(self, key_dict: dict, value: Any):
        """Add a single key-value pair to the Map. Key must have all required key fields."""
        key = self.create_key_values_tuple_from_dict(key_dict)
        if key in self._values:
            raise self.DuplicateKeyValuesException(key)
        else:
            self._values[key] = value

    @property
    def values(self) -> List[Any]:
        return list(self._values.values())

    def entry_exists_with_key(self, key: dict):
        """Return true if an entry exists in the map with the given key, false otherwise"""
        return self.create_key_values_tuple_from_dict(key) in self._values

    def get_value_by_key(self, key: dict) -> Any:
        """Return the value associated with the given key, throwing an error if no entry with the given key exists"""
        key_tuple = self.create_key_values_tuple_from_dict(key)
        if key_tuple not in self._values:
            raise self.InvalidKeyValuesException(key_tuple)
        return self._values[key_tuple]

    def create_key_values_tuple_from_dict(self, d: dict):
        """
        Create a tuple of key values from a dictionary, throwing an error if not all required key fields are present
        Any non-key fields in the dict will be ignored
        """
        for key_field in self._key_fields:
            if key_field not in d:
                raise self.InvalidKeyFieldsException(self._key_fields, d)
        return tuple(d[key_field] for key_field in self._key_fields)

    def __repr__(self) -> str:
        return repr(self._values)

    class InvalidKeyFieldsException(Exception):
        def __init__(self, key_fields: List[str], key_dict: dict):
            super().__init__(f'{key_dict} does not contain required key fields {key_fields}')

    class InvalidKeyValuesException(Exception):
        def __init__(self, key: tuple):
            super().__init__(f'No entry exists with key values matching {key}')

    class DuplicateKeyValuesException(Exception):
        def __init__(self, key: tuple):
            super().__init__(f'An entry with key: {key} already exists')
