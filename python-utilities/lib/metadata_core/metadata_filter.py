import copy
from typing import List
from abc import ABC, abstractmethod
import re

from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.metadata_core.metadata_object_path import DatabasePath, SchemaPath, TablePath, ColumnPath


class CriteriaMatcher:

    def __init__(self, field_names: List[str]):
        self._field_names = field_names
        self._criteria = []

    @property
    def has_criteria(self) -> bool:
        return len(self._criteria) > 0

    def add_criteria(self, criteria) -> None:
        self._criteria.append(criteria)

    def matches(self, item) -> bool:
        for criterion in self._criteria:
            if all([self.input_value_matches_criteria_value(getattr(item, field_name), getattr(criterion, field_name)) for field_name in
                    self._field_names]):
                return True
        return False

    @staticmethod
    def input_value_matches_criteria_value(input_value, criteria_value) -> bool:
        return input_value is not None and bool(re.match(criteria_value.replace('*', '.*'), input_value))


class MetadataFilterer(ABC):

    def __init__(self):
        self._database_matcher = CriteriaMatcher(field_names=['database'])
        self._schema_matcher = CriteriaMatcher(field_names=['database', 'schema'])
        self._table_matcher = CriteriaMatcher(field_names=['database', 'schema', 'table'])
        self._column_matcher = CriteriaMatcher(field_names=['database', 'schema', 'table', 'column'])

    def filter(self, metadata: DataWarehouseMetadata) -> DataWarehouseMetadata:
        filtered_metadata = copy.deepcopy(metadata)
        for database in metadata.databases:
            if self.metadata_should_be_filtered_out(self._database_matcher, database):
                filtered_metadata.remove_database_metadata(database.name)
            else:
                for schema in database.schemas:
                    if self.metadata_should_be_filtered_out(self._schema_matcher, schema):
                        filtered_metadata.get_database(database.name).remove_schema_metadata(schema.name)
                    else:
                        for table in schema.tables:
                            if self.metadata_should_be_filtered_out(self._table_matcher, table):
                                filtered_metadata.get_schema_by_path(schema.path).remove_table_metadata(table.name)
                            else:
                                for column in table.columns:
                                    if self.metadata_should_be_filtered_out(self._column_matcher, column):
                                        filtered_metadata.get_table_by_path(table.path).remove_column_metadata(column.name)
                                        for foreign_key in table.foreign_keys:
                                            if column.name in foreign_key.native_columns:
                                                filtered_metadata.get_table_by_path(table.path).remove_foreign_key_metadata(
                                                    foreign_key.name)

        return filtered_metadata

    def add_database_criteria(self, database_path: DatabasePath) -> None:
        self._database_matcher.add_criteria(database_path)

    def add_schema_criteria(self, schema_path: SchemaPath) -> None:
        self._schema_matcher.add_criteria(schema_path)

    def add_table_criteria(self, table_path: TablePath) -> None:
        self._table_matcher.add_criteria(table_path)

    def add_column_criteria(self, column_path: ColumnPath) -> None:
        self._column_matcher.add_criteria(column_path)

    def metadata_should_be_filtered_out(self, criteria_matcher: CriteriaMatcher, metadata_object) -> bool:
        return criteria_matcher.has_criteria and self.process_match_result(criteria_matcher.matches(metadata_object.path))

    @staticmethod
    @abstractmethod
    def process_match_result(criteria_match_result: bool) -> bool:
        pass


class InclusiveMetadataFilterer(MetadataFilterer):

    @staticmethod
    def process_match_result(criteria_match_result: bool) -> bool:
        return not criteria_match_result


class ExclusiveMetadataFilterer(MetadataFilterer):

    @staticmethod
    def process_match_result(criteria_match_result: bool) -> bool:
        return criteria_match_result
