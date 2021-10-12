from abc import ABC, abstractmethod
from typing import List

from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper
from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, InvalidMetadataKeyException, TableAddress


class NodeLineageTracer(ABC):

    def __init__(self, key_fields: List[str]):
        self.key_fields = key_fields

    @abstractmethod
    def determine_node_parents(self, node_key: dict) -> List[dict]:
        pass

    class InvalidNodeException(Exception):
        pass


class TableNodeLineageTracer(NodeLineageTracer):

    def __init__(self, data_warehouse_metadata: DataWarehouseMetadata):
        super().__init__(key_fields=[])
        self._metadata = data_warehouse_metadata

    def determine_node_parents(self, node_key: dict) -> List[dict]:
        try:
            table_metadata = self._metadata.get_database(node_key['database']).get_schema(node_key['schema']).get_table(node_key['table'])
            if table_metadata.primary_source_table is not None:
                return [{
                    'database': table_metadata.primary_source_table.database,
                    'schema': table_metadata.primary_source_table.schema,
                    'table': table_metadata.primary_source_table.table
                }]
            else:
                return []
        except InvalidMetadataKeyException:
            table_address = f'{node_key["database"]}.{node_key["schema"]}.{node_key["table"]}'
            raise self.InvalidNodeException(f'Could not determine parents of table "{table_address}". Table doesn\'t exist in metadata.')


class ColumnNodeLineageTracer(NodeLineageTracer):

    def __init__(self, data_warehouse_metadata: DataWarehouseMetadata):
        super().__init__(key_fields=[])
        self._metadata = data_warehouse_metadata

    def determine_node_parents(self, node_key: dict) -> List[dict]:
        table_address = TableAddress(database=node_key['database'], schema=node_key['schema'], table=node_key['table'])
        try:
            table_metadata = self._metadata.get_table_by_address(table_address)
            column_metadata = table_metadata.get_column(node_key['column'])
            if column_metadata.source_field is not None:
                source_table = self._metadata.get_table_by_address(table_metadata.primary_source_table)
                for foreign_key in column_metadata.source_field.fk_steps:
                    source_table = self._metadata.get_table_by_address(source_table.get_foreign_key(foreign_key).table)
                return [{
                    'database': source_table.database_name,
                    'schema': source_table.schema_name,
                    'table': source_table.name,
                    'column': column_metadata.source_field.column_name
                }]
            else:
                return []
        except InvalidMetadataKeyException:
            table_address = f'{node_key["database"]}.{node_key["schema"]}.{node_key["table"]}'
            raise self.InvalidNodeException(f'Could not determine parents of table "{table_address}". Table doesn\'t exist in metadata.')


class DependencyRowGrouperGenerator:

    def __init__(self, node_lineage_tracer: NodeLineageTracer):
        self._node_lineage_tracer = node_lineage_tracer
        self._map = MultiKeyMap(node_lineage_tracer.key_fields)

    def calculate_and_store_dependency_tree_node_depth(self, node_key: dict):
        self._recursively_calculate_and_store_dependency_tree_node_depth(node_key, set())

    def _recursively_calculate_and_store_dependency_tree_node_depth(self, current_node_key: dict, seen_node_keys: set):
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
        return RowGrouper(self._map)

    class TreeCycleException(Exception):
        def __init__(self, node_key: dict):
            super().__init__(f'Node with key {node_key} appears multiple times in the same direct node lineage')
