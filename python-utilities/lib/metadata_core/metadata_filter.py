from dataclasses import dataclass, field
from typing import List


@dataclass
class MetadataFilter:
    databases: List[str] = field(default_factory=list)
    schemas: List[str] = field(default_factory=list)
    tables: List[str] = field(default_factory=list)
    columns: List[str] = field(default_factory=list)


class MetadataFilterMatcher:

    def __init__(self):
        self._filters = []

    def add_filter(self, metadata_filter: MetadataFilter):
        self._filters.append(metadata_filter)

    def matches(self, database: str = None, schema: str = None, table: str = None, column: str = None) -> bool:
        if len(self._filters) == 0:
            return True
        for metadata_filter in self._filters:
            if self._matches_single_filter(metadata_filter, database, schema, table, column):
                return True
        return False

    def _matches_single_filter(self, metadata_filter: MetadataFilter, database: str, schema: str, table: str, column: str) -> bool:
        return self._any_attributes_match(metadata_filter.databases, database) and \
               self._any_attributes_match(metadata_filter.schemas, schema) and \
               self._any_attributes_match(metadata_filter.tables, table) and \
               self._any_attributes_match(metadata_filter.columns, column)

    def _any_attributes_match(self, filter_attrs: List[str], input_attr: str) -> bool:
        return any([self._attributes_match(filter_attr, input_attr) for filter_attr in filter_attrs]) or len(filter_attrs) == 0

    @staticmethod
    def _attributes_match(filter_attr: str, input_attr: str) -> bool:
        return filter_attr == input_attr
