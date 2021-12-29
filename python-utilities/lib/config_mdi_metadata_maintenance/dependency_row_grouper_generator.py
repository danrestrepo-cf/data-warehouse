"""A family of classes that generates RowGroupers based on metadata dependency trees.

This module is needed because some config.mdi metadata tables (namely edw_table_definition,
edw_field_definition, and edw_join_tree_definition) have self-referential foreign keys.
A row for a history_octane table in edw_table_definition usually has a foreign key
to a row for a *staging_octane* table in edw_table_definition, for example. This
creates a problem when trying to perform inserts and deletes on these metadata tables,
since we cannot insert a row before its "source" row (unless we want to double back
and update it later), nor can we delete a row before any foreign keys that depend on
that row have been deleted or nullified themselves.

These issues also arise for inter-table foreign key relationships, but those
are easily solved by setting the order in which tables are updated such that no
conflicts occur (e.g. by always inserting new data into edw_table_definition before
edw_field_definition, since edw_field_definition has a foreign key to edw_table_definition).
To solve *intra*-table dependency issues, however, we need to know which specific
*rows* in a table to insert in what groupings/order.

The central idea behind this module is that of a dependency tree (even though
there is no class in this module that models a tree structure directly). Essentially,
this concept models dependency relationships between objects as a tree, where
child nodes are dependent upon their parents. Nodes with no dependencies are
connected to the "root" of the tree.

For example (using a familiar relationship between staging_octane, history_octane, and star_loan tables):

                            staging_octane.loan
                                   |
                            history_octane.loan
                                  /\
                                 /  \
                                /    \
                star_loan.loan_dim  star_loan.loan_fact

The staging_octane table is at level "0", its history_octane "child", which is
dependent on it, is at level "1", and the history_octane table's star_loan "children"
are each at level 2.

This module's classes enable the tracing/definition of a dependency tree within a
single metadata domain (e.g. edw_field_definition), and the subsequent generation
of a RowGrouper that groups rows based on their dependency tree depth so as to
insert/delete them in the "correct" order based on their dependencies.
"""

from abc import ABC, abstractmethod
from typing import List

from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper
from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, InvalidMetadataKeyException
from lib.metadata_core.metadata_object_path import TablePath


class NodeLineageTracer(ABC):
    """An abstract class defining a method for finding the parent of a given node in a dependency tree."""

    def __init__(self, key_fields: List[str]):
        self.key_fields = key_fields

    @abstractmethod
    def determine_node_parents(self, node_key: dict) -> List[dict]:
        pass

    class InvalidNodeException(Exception):
        pass


class TableInsertNodeLineageTracer(NodeLineageTracer):
    """A NodeLineageTracer that finds "parents" of table "nodes" in a DataWarehouseMetadata object.

    This lineage tracer is used to group rows when inserting into edw_table_definition.
    As such, a "parent" is defined as a table *on which the given table is dependent*.
    """

    def __init__(self, data_warehouse_metadata: DataWarehouseMetadata):
        super().__init__(key_fields=['database_name', 'schema_name', 'table_name'])
        self._metadata = data_warehouse_metadata

    def determine_node_parents(self, node_key: dict) -> List[dict]:
        table_address = TablePath(database=node_key['database_name'], schema=node_key['schema_name'], table=node_key['table_name'])
        try:
            table_metadata = self._metadata.get_table_by_path(table_address)
            if table_metadata.primary_source_table is not None:
                return [{
                    'database_name': table_metadata.primary_source_table.database,
                    'schema_name': table_metadata.primary_source_table.schema,
                    'table_name': table_metadata.primary_source_table.table
                }]
            else:
                return []
        except InvalidMetadataKeyException:
            table_address = f'{node_key["database_name"]}.{node_key["schema_name"]}.{node_key["table_name"]}'
            raise self.InvalidNodeException(f'Could not determine parents of table "{table_address}". Table doesn\'t exist in metadata.')


class TableDeleteNodeLineageTracer(NodeLineageTracer):
    """A NodeLineageTracer that finds "parents" of table "nodes" in a MetadataTable object.

    This lineage tracer is used to group rows when deleting from edw_table_definition.
    As such, a "parent" is defined as a table that *has a dependency on the given table*.
    """

    def __init__(self, metadata_table: MetadataTable):
        super().__init__(key_fields=['database_name', 'schema_name', 'table_name'])
        self._table_dependencies = MultiKeyMap(key_fields=['database_name', 'schema_name', 'table_name'])
        for row in metadata_table.rows:
            dependent_table = row.key
            if not self._table_dependencies.entry_exists_with_key(dependent_table):
                self._table_dependencies.add_entry(dependent_table, [])
            if row.attributes['source_database_name'] is not None:
                source_table = {
                    'database_name': row.attributes['source_database_name'],
                    'schema_name': row.attributes['source_schema_name'],
                    'table_name': row.attributes['source_table_name']
                }
                if not self._table_dependencies.entry_exists_with_key(source_table):
                    self._table_dependencies.add_entry(source_table, [])
                self._table_dependencies.get_value_by_key(source_table).append(dependent_table)

    def determine_node_parents(self, node_key: dict) -> List[dict]:
        try:
            return self._table_dependencies.get_value_by_key(node_key)
        except MultiKeyMap.InvalidKeyValuesException:
            table_address = f'{node_key["database_name"]}.{node_key["schema_name"]}.{node_key["table_name"]}'
            raise self.InvalidNodeException(f'Could not determine parents of table "{table_address}". Table doesn\'t exist in metadata.')


class FieldInsertNodeLineageTracer(NodeLineageTracer):
    """A NodeLineageTracer that finds "parents" of field "nodes" in a DataWarehouseMetadata object.

    This lineage tracer is used to group rows when inserting into edw_field_definition.
    As such, a "parent" is defined as a field *on which the given field is dependent*.
    """

    def __init__(self, data_warehouse_metadata: DataWarehouseMetadata):
        super().__init__(key_fields=['database_name', 'schema_name', 'table_name', 'field_name'])
        self._metadata = data_warehouse_metadata

    def determine_node_parents(self, node_key: dict) -> List[dict]:
        table_path = TablePath(database=node_key['database_name'], schema=node_key['schema_name'], table=node_key['table_name'])
        try:
            table_metadata = self._metadata.get_table_by_path(table_path)
            return [{
                'database_name': column_path.database,
                'schema_name': column_path.schema,
                'table_name': column_path.table,
                'field_name': column_path.column
            } for column_path in table_metadata.get_source_column_paths(node_key['field_name'], self._metadata)]
        except InvalidMetadataKeyException:
            full_col_name = f'{node_key["database_name"]}.{node_key["schema_name"]}.{node_key["table_name"]}.{node_key["field_name"]}'
            raise self.InvalidNodeException(f'Could not determine parents of column "{full_col_name}". Column doesn\'t exist in metadata.')


class FieldDeleteNodeLineageTracer(NodeLineageTracer):
    """A NodeLineageTracer that finds "parents" of field "nodes" in a MetadataTable object.

    This lineage tracer is used to group rows when deleting from edw_field_definition.
    As such, a "parent" is defined as a field that *has a dependency on the given field*.
    """

    def __init__(self, metadata_table: MetadataTable):
        super().__init__(key_fields=['database_name', 'schema_name', 'table_name', 'field_name'])
        self._field_dependencies = MultiKeyMap(key_fields=['database_name', 'schema_name', 'table_name', 'field_name'])
        for row in metadata_table.rows:
            dependent_field = row.key
            if not self._field_dependencies.entry_exists_with_key(dependent_field):
                self._field_dependencies.add_entry(dependent_field, [])
            if row.attributes['source_database_name'] is not None:
                source_field = {
                    'database_name': row.attributes['source_database_name'],
                    'schema_name': row.attributes['source_schema_name'],
                    'table_name': row.attributes['source_table_name'],
                    'field_name': row.attributes['source_field_name']
                }
                if not self._field_dependencies.entry_exists_with_key(source_field):
                    self._field_dependencies.add_entry(source_field, [])
                self._field_dependencies.get_value_by_key(source_field).append(dependent_field)

    def determine_node_parents(self, node_key: dict) -> List[dict]:
        try:
            return self._field_dependencies.get_value_by_key(node_key)
        except MultiKeyMap.InvalidKeyValuesException:
            full_col_name = f'{node_key["database_name"]}.{node_key["schema_name"]}.{node_key["table_name"]}.{node_key["field_name"]}'
            raise self.InvalidNodeException(f'Could not determine parents of column "{full_col_name}". Column doesn\'t exist in metadata.')


class DependencyRowGrouperGenerator:
    """A class that traverses a dependency tree and generates the corresponding row grouper for that tree.

     By using dependency tree depth as a row's group number, we ensure that rows
     are always grouped in a *later* group than *any* of their "parent" nodes.
    """

    def __init__(self, node_lineage_tracer: NodeLineageTracer):
        """
        :param node_lineage_tracer: an object that defines the logic by which a
        dependency tree node's "parents" are identified.
        """
        self._node_lineage_tracer = node_lineage_tracer
        self._map = MultiKeyMap(node_lineage_tracer.key_fields)

    def calculate_and_store_dependency_tree_node_depth(self, node_key: dict):
        """If the tree depth of the given node key has not already been recorded, calculate and record it for future reference.

        The "depth" of a node is defined as the max number of hops away from the tree
        root it is. A node that is not dependent on anything (e.g. a staging_octane
        field definition with no source field) is at depth 0. A node that is dependent
        on another node of depth 0 is at depth 1 (e.g. a history_octane field definition
        with a source field pointing to staging_octane).

        Another way to define the depth of a node is as "the depth of its deepest
        parent + 1". For a more complex example, let's say a fact table field
        was dependent on a calculation involving a history_octane table field (depth 1)
        and a dimension table field (depth 2). The fact table field would be at
        depth *3* because its deepest "parent" node was at depth 2.
        """
        if not self._map.entry_exists_with_key(node_key):
            self._recursively_calculate_and_store_dependency_tree_node_depth(node_key, set())

    def _recursively_calculate_and_store_dependency_tree_node_depth(self, current_node_key: dict, seen_node_keys: set):
        """Calculate and store node depth for the current node and any of its ancestors, recursively."""
        node_key_tuple = self._map.create_key_values_tuple_from_dict(current_node_key)
        if node_key_tuple in seen_node_keys:
            raise self.TreeCycleException(current_node_key)
        seen_node_keys.add(node_key_tuple)
        parent_depth = -1
        for parent_key in self._node_lineage_tracer.determine_node_parents(current_node_key):
            if not self._map.entry_exists_with_key(parent_key):
                self._recursively_calculate_and_store_dependency_tree_node_depth(parent_key, seen_node_keys.copy())
            parent_depth = max(parent_depth, self._map.get_value_by_key(parent_key))
        self._map.add_entry(current_node_key, parent_depth + 1)

    def generate_row_grouper(self):
        """Generate a RowGrouper that maps row keys to their dependency tree depth number."""
        return RowGrouper(self._map)

    class TreeCycleException(Exception):
        def __init__(self, node_key: dict):
            super().__init__(f'Node with key {node_key} appears multiple times in the same direct node lineage')
