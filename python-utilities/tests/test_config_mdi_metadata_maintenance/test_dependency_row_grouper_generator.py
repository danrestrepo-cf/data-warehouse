import unittest
from typing import List

from lib.config_mdi_metadata_maintenance.dependency_row_grouper_generator import (DependencyRowGrouperGenerator,
                                                                                  NodeLineageTracer,
                                                                                  TableNodeLineageTracer,
                                                                                  ColumnNodeLineageTracer)
from lib.config_mdi_metadata_maintenance.metadata_table import Row
from lib.config_mdi_metadata_maintenance.multi_key_map import MultiKeyMap
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


def make_row(row_key: dict) -> Row:
    return Row(key=row_key, attributes={})


class TestDependencyRowGrouperGenerator(unittest.TestCase):
    class ExampleNodeLineageTracer(NodeLineageTracer):

        def determine_node_parents(self, node_key: dict) -> List[dict]:
            tuple_key = (node_key['a'], node_key['b'])
            parent_lookup = {
                # main test data
                (1, 2): [{'a': 3, 'b': 4}, {'a': 7, 'b': 8}],
                (3, 4): [{'a': 5, 'b': 6}],
                # cycle detection test data
                (100, 101): [{'a': 102, 'b': 103}],
                (102, 103): [{'a': 104, 'b': 105}],
                (104, 105): [{'a': 100, 'b': 101}],
            }
            if tuple_key not in parent_lookup:
                return []
            else:
                return parent_lookup[tuple_key]

    def setUp(self) -> None:
        self.row_grouper_generator = DependencyRowGrouperGenerator(self.ExampleNodeLineageTracer(key_fields=['a', 'b']))

    def test_throws_error_if_user_attempts_to_add_node_with_invalid_key_fields_to_tree(self):
        with self.assertRaises(MultiKeyMap.InvalidKeyFieldsException):
            self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'c': 1})

    def test_adds_node_with_no_parents_at_depth_zero(self):
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 5, 'b': 6})
        grouper = self.row_grouper_generator.generate_row_grouper()
        self.assertEqual(0, grouper.get_row_group_number(make_row({'a': 5, 'b': 6})))

    def test_adds_node_with_parent_that_exists_in_the_tree_at_one_depth_below_parent(self):
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 5, 'b': 6})
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 3, 'b': 4})
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 1, 'b': 2})
        grouper = self.row_grouper_generator.generate_row_grouper()
        self.assertEqual(0, grouper.get_row_group_number(make_row({'a': 5, 'b': 6})))
        self.assertEqual(1, grouper.get_row_group_number(make_row({'a': 3, 'b': 4})))
        self.assertEqual(2, grouper.get_row_group_number(make_row({'a': 1, 'b': 2})))

    def test_derives_node_depth_from_parent_with_greatest_depth(self):
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 5, 'b': 6})
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 3, 'b': 4})
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 7, 'b': 8})
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 1, 'b': 2})
        grouper = self.row_grouper_generator.generate_row_grouper()
        self.assertEqual(2, grouper.get_row_group_number(make_row({'a': 1, 'b': 2})))

    def test_adding_a_node_also_adds_any_node_parents_that_dont_yet_exist_in_the_tree(self):
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 1, 'b': 2})
        grouper = self.row_grouper_generator.generate_row_grouper()
        self.assertEqual(0, grouper.get_row_group_number(make_row({'a': 5, 'b': 6})))
        self.assertEqual(0, grouper.get_row_group_number(make_row({'a': 7, 'b': 8})))
        self.assertEqual(1, grouper.get_row_group_number(make_row({'a': 3, 'b': 4})))
        self.assertEqual(2, grouper.get_row_group_number(make_row({'a': 1, 'b': 2})))

    def test_throws_error_if_added_node_lineage_a_cyclical_reference_to_itself(self):
        with self.assertRaises(DependencyRowGrouperGenerator.TreeCycleException):
            self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 100, 'b': 101})


class TestTableNodeLineageTracer(unittest.TestCase):

    def setUp(self) -> None:
        self.dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'staging',
                        'schemas': [
                            {
                                'name': 'history_octane',
                                'tables': [
                                    {
                                        'name': 'table_with_source',
                                        'primary_source_table': 'staging.staging_octane.source_table'
                                    }
                                ]
                            },
                            {
                                'name': 'staging_octane',
                                'tables': [
                                    {
                                        'name': 'source_table'
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        )

    def test_throws_error_if_given_table_doesnt_exist_in_metadata(self):
        node_lineage_tracer = TableNodeLineageTracer(self.dw_metadata)
        with self.assertRaises(NodeLineageTracer.InvalidNodeException):
            node_lineage_tracer.determine_node_parents({
                'database': 'bad db',
                'schema': 'bad schema',
                'table': 'bad table'
            })

    def test_returns_empty_list_for_table_with_no_source_table(self):
        node_lineage_tracer = TableNodeLineageTracer(self.dw_metadata)
        expected = []
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database': 'staging',
            'schema': 'staging_octane',
            'table': 'source_table'
        }))

    def test_returns_single_item_list_containing_source_table_key_if_table_has_a_source(self):
        node_lineage_tracer = TableNodeLineageTracer(self.dw_metadata)
        expected = [{
            'database': 'staging',
            'schema': 'staging_octane',
            'table': 'source_table'
        }]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database': 'staging',
            'schema': 'history_octane',
            'table': 'table_with_source'
        }))


class TestColumnNodeLineageTracer(unittest.TestCase):

    def setUp(self) -> None:
        self.dw_metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'staging',
                        'schemas': [
                            {
                                'name': 'history_octane',
                                'tables': [
                                    {
                                        'name': 'table_with_source',
                                        'primary_source_table': 'staging.staging_octane.source_table',
                                        'columns': {
                                            'column_with_source': {
                                                'data_source': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.source_column'
                                                }
                                            },
                                            'column_with_distant_source': {
                                                'data_source': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.foreign_keys.fk_1.columns.distant_source_column'
                                                }
                                            }

                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'staging_octane',
                                'tables': [
                                    {
                                        'name': 'source_table',
                                        'columns': {
                                            'source_column': {
                                                'data_source': 'TEXT'
                                            },
                                            'fk_col': {
                                                'data_source': 'TEXT'
                                            }
                                        },
                                        'foreign_keys': {
                                            'fk_1': {
                                                'columns': ['fk_col'],
                                                'references': {
                                                    'columns': ['fk_col'],
                                                    'schema': 'other_schema',
                                                    'table': 'distant_source_table'
                                                }
                                            }
                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'other_schema',
                                'tables': [
                                    {
                                        'name': 'distant_source_table',
                                        'columns': {
                                            'fk_col': {
                                                'data_source': 'TEXT'
                                            },
                                            'distant_source_column': {
                                                'data_source': 'TEXT'
                                            }
                                        }
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        )

    def test_throws_error_if_given_column_doesnt_exist_in_metadata(self):
        node_lineage_tracer = ColumnNodeLineageTracer(self.dw_metadata)
        with self.assertRaises(NodeLineageTracer.InvalidNodeException):
            node_lineage_tracer.determine_node_parents({
                'database': 'bad db',
                'schema': 'bad schema',
                'table': 'bad table',
                'column': 'bad column'
            })

    def test_returns_empty_list_for_column_with_no_source_column(self):
        node_lineage_tracer = ColumnNodeLineageTracer(self.dw_metadata)
        expected = []
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database': 'staging',
            'schema': 'staging_octane',
            'table': 'source_table',
            'column': 'source_column'
        }))

    def test_returns_single_item_list_containing_source_column_key_if_column_source_is_from_primary_source_table(self):
        node_lineage_tracer = ColumnNodeLineageTracer(self.dw_metadata)
        expected = [{
            'database': 'staging',
            'schema': 'staging_octane',
            'table': 'source_table',
            'column': 'source_column'
        }]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database': 'staging',
            'schema': 'history_octane',
            'table': 'table_with_source',
            'column': 'column_with_source'
        }))

    def test_returns_single_item_list_containing_source_column_key_if_column_source_is_from_distant_source_table(self):
        node_lineage_tracer = ColumnNodeLineageTracer(self.dw_metadata)
        expected = [{
            'database': 'staging',
            'schema': 'other_schema',
            'table': 'distant_source_table',
            'column': 'distant_source_column'
        }]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database': 'staging',
            'schema': 'history_octane',
            'table': 'table_with_source',
            'column': 'column_with_distant_source'
        }))


if __name__ == '__main__':
    unittest.main()
