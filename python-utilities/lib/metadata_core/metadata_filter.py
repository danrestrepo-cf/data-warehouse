"""A family of classes that delete objects from a DataWarehouseMetadata hierarchy based on given filters.

Public classes:
- InclusiveMetadataFilterer
    - use when you *filter to* a specific set of metadata
- ExclusiveMetadataFilterer
    - use when you want to *filter out* a specific set of metadata

Each filterer accepts filters at the Database, Schema, Table, and Column grains.
These filters take the form of Paths, describing the location of the filter objects
in the metadata hierarchy. Each path's attributes can either be used for exact
matches or for wildcard matches (where "*" is the wildcard character).

For example (using an ExclusiveMetadataFilterer):

    metadata_filterer = ExclusiveMetadataFilterer()
    metadata_filterer.add_table_criteria(TablePath('business', 'sales', 'private*'))
    metadata_filterer.add_column_criteria(ColumnPath('business', 'sales', 'client', 'client_ssn'))

    filtered_dw_metadata = metadata_filterer.filter(dw_metadata)

After executing the above code, any table in the "sales" schema in the
"business" database whose name begins with the word "private" would be deleted
from the given DataWarehouseMetadata. Additionally, the specific column "client_ssn"
in the client table in the sales schema in the business database would
also be filtered out.

If, in the above example, we had used an InclusiveMetadataFilterer instead, then
any table *except* tables matching business.sales.private* would have been
filtered out, as would any columns except for business.sales.admin_user.au_password.
"""

import copy
from typing import List
from abc import ABC, abstractmethod
import re

from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.metadata_core.metadata_object_path import DatabasePath, SchemaPath, TablePath, ColumnPath


class CriteriaMatcher:
    """A class that stores a set of criteria and determines whether given items match that criteria.

    Because this class is intended to be used to match against database identifiers,
    e.g. table names, column names, etc., the allowed character set of both the
    criteria and the items to match against is restricted to characters allowed
    in SQL object identifiers. The values are further restricted to only
    *English* letters (the SQL standard allows for any valid Unicode letter from
    any language), since this code is only intended to be used with the Cardinal
    EDW database (which uses only standard English letters in identifiers). The
    final list of allowed characters includes:
    - any upper- or lower-case letter in the English alphabet
    - any digit from 0-9
    - underscores
    - asterisks (to use as wildcard characters)
    """

    def __init__(self, field_names: List[str]):
        """
        :param field_names: the list of fields that both added criteria and items-to-be-matched must contain
        """
        self._field_names = field_names
        self._criteria = []

    @property
    def has_criteria(self) -> bool:
        """Return True if any criteria has previously been added to the CriteriaMatcher, False otherwise."""
        return len(self._criteria) > 0

    def add_criteria(self, criteria) -> None:
        """Add the given criteria object to the list of criteria to match against."""
        self._validate_all_field_values(criteria)
        self._criteria.append(criteria)

    def matches(self, item) -> bool:
        """Return True if the given item matches *any* previously-added criteria, False otherwise."""
        self._validate_all_field_values(item)
        for criterion in self._criteria:
            if all([self.input_value_matches_criteria_value(getattr(item, field_name), getattr(criterion, field_name)) for field_name in
                    self._field_names]):
                return True
        return False

    @staticmethod
    def input_value_matches_criteria_value(input_value, criteria_value) -> bool:
        """Return true if the input_value matches the criteria_value, False otherwise.

        A value matches a criteria value under either of two circumstances:
        - the values are exactly equal
        - the criteria value contains wildcards ("*") and the input value matches the wildcard pattern

        E.g. "alpha" (input) matches "alpha" or "*lp*a" (criteria)
        """
        return input_value is not None and bool(re.match(f"^{criteria_value.replace('*', '.*')}$", input_value))

    def _validate_all_field_values(self, item):
        for field_name in self._field_names:
            field_value = getattr(item, field_name)
            if not re.match(r'^[a-zA-Z0-9_*]+$', field_value):
                raise self.InvalidCharacterError(f'Value "{field_value}" contains invalid characters. Must be alphanumeric, _ or *.')

    class InvalidCharacterError(Exception):
        pass


class MetadataFilterer(ABC):
    """An abstract class that filters out certain metadata from a DataWarehouseMetadata structure based on given criteria."""

    def __init__(self):
        self._database_matcher = CriteriaMatcher(field_names=['database'])
        self._schema_matcher = CriteriaMatcher(field_names=['database', 'schema'])
        self._table_matcher = CriteriaMatcher(field_names=['database', 'schema', 'table'])
        self._column_matcher = CriteriaMatcher(field_names=['database', 'schema', 'table', 'column'])

    def filter(self, metadata: DataWarehouseMetadata) -> DataWarehouseMetadata:
        """Remove any nodes from the given metadata hierarchy that should be filtered out.

        The decision of which nodes should be filtered out depends on the implementation
        of the abstract method "process_match_result". Metadata objects will be filtered
        out if they either (a) *match* the stored list of criteria (as in ExclusiveMetadataFilterer)
        or (b) *do not match* the stored list of criteria (as in InclusiveMetadataFilterer).
        """
        filtered_metadata = copy.deepcopy(metadata)
        for database in metadata.databases:
            if self.metadata_should_be_filtered_out(self._database_matcher, database):
                filtered_metadata.remove_database(database.name)
            else:
                for schema in database.schemas:
                    if self.metadata_should_be_filtered_out(self._schema_matcher, schema):
                        filtered_metadata.get_database(database.name).remove_schema(schema.name)
                    else:
                        for table in schema.tables:
                            if self.metadata_should_be_filtered_out(self._table_matcher, table):
                                filtered_metadata.get_schema_by_path(schema.path).remove_table(table.name)
                            else:
                                for column in table.columns:
                                    if self.metadata_should_be_filtered_out(self._column_matcher, column):
                                        filtered_metadata.get_table_by_path(table.path).remove_column(column.name)
                                        for foreign_key in table.foreign_keys:
                                            if column.name in foreign_key.native_columns:
                                                filtered_metadata.get_table_by_path(table.path).remove_foreign_key(
                                                    foreign_key.name)
        return filtered_metadata

    def add_database_criteria(self, database_path: DatabasePath) -> None:
        """Add database criteria to the list of filters."""
        self._database_matcher.add_criteria(database_path)

    def add_schema_criteria(self, schema_path: SchemaPath) -> None:
        """Add schema criteria to the list of filters."""
        self._schema_matcher.add_criteria(schema_path)

    def add_table_criteria(self, table_path: TablePath) -> None:
        """Add table criteria to the list of filters."""
        self._table_matcher.add_criteria(table_path)

    def add_column_criteria(self, column_path: ColumnPath) -> None:
        """Add column criteria to the list of filters."""
        self._column_matcher.add_criteria(column_path)

    def metadata_should_be_filtered_out(self, criteria_matcher: CriteriaMatcher, metadata_object) -> bool:
        return criteria_matcher.has_criteria and self.process_match_result(criteria_matcher.matches(metadata_object.path))

    @staticmethod
    @abstractmethod
    def process_match_result(criteria_match_result: bool) -> bool:
        """Abstract method to perform additional processing on the result of a criteria match."""
        pass


class InclusiveMetadataFilterer(MetadataFilterer):
    """A MetadataFilterer that filters out any metadata that *does not match* at least one filter."""

    @staticmethod
    def process_match_result(criteria_match_result: bool) -> bool:
        """Return the *inverse* of the given criteria match result."""
        return not criteria_match_result


class ExclusiveMetadataFilterer(MetadataFilterer):
    """A MetadataFilterer that filters out any metadata that *matches* at least one filter."""

    @staticmethod
    def process_match_result(criteria_match_result: bool) -> bool:
        """Return the given criteria match result with no alterations."""
        return criteria_match_result
