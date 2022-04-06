import unittest
from typing import List

from lib.config_mdi_metadata_maintenance.dependency_row_grouper_generator import (DependencyRowGrouperGenerator,
                                                                                  NodeLineageTracer,
                                                                                  TableInsertNodeLineageTracer,
                                                                                  TableDeleteNodeLineageTracer,
                                                                                  FieldInsertNodeLineageTracer,
                                                                                  FieldDeleteNodeLineageTracer)
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
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

    def test_adding_node_that_already_exists_does_nothing(self):
        self.row_grouper_generator.calculate_and_store_dependency_tree_node_depth({'a': 5, 'b': 6})
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


class TestTableInsertNodeLineageTracer(unittest.TestCase):

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
        node_lineage_tracer = TableInsertNodeLineageTracer(self.dw_metadata)
        with self.assertRaises(NodeLineageTracer.InvalidNodeException):
            node_lineage_tracer.determine_node_parents({
                'database_name': 'bad db',
                'schema_name': 'bad schema',
                'table_name': 'bad table'
            })

    def test_returns_empty_list_for_table_with_no_source_table(self):
        node_lineage_tracer = TableInsertNodeLineageTracer(self.dw_metadata)
        expected = []
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'staging_octane',
            'table_name': 'source_table'
        }))

    def test_returns_single_item_list_containing_source_table_key_if_table_has_a_source(self):
        node_lineage_tracer = TableInsertNodeLineageTracer(self.dw_metadata)
        expected = [{
            'database_name': 'staging',
            'schema_name': 'staging_octane',
            'table_name': 'source_table'
        }]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source'
        }))


class TestTableDeleteNodeLineageTracer(unittest.TestCase):

    def setUp(self) -> None:
        self.metadata_table = MetadataTable(key_fields=['database_name', 'schema_name', 'table_name'])
        # todo: test for completely isolated table/field, e.g. one with no dependents or sources
        self.metadata_table.add_rows([
            {
                'database_name': 'staging',
                'schema_name': 'staging_octane',
                'table_name': 'source_table',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            },
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'table_with_source',
                'source_database_name': 'staging',
                'source_schema_name': 'staging_octane',
                'source_table_name': 'source_table'
            },
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'other_table_with_source',
                'source_database_name': 'staging',
                'source_schema_name': 'staging_octane',
                'source_table_name': 'source_table'
            },
            {
                'database_name': 'ingress',
                'schema_name': 'ingress_schema',
                'table_name': 'isolated_table',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None
            },
        ])

    def test_throws_error_if_given_table_doesnt_exist_in_metadata(self):
        node_lineage_tracer = TableDeleteNodeLineageTracer(self.metadata_table)
        with self.assertRaises(NodeLineageTracer.InvalidNodeException):
            node_lineage_tracer.determine_node_parents({
                'database_name': 'bad db',
                'schema_name': 'bad schema',
                'table_name': 'bad table'
            })

    def test_returns_empty_list_for_table_with_no_dependent_tables(self):
        node_lineage_tracer = TableDeleteNodeLineageTracer(self.metadata_table)
        expected = []
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source'
        }))
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'other_table_with_source'
        }))
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'ingress',
            'schema_name': 'ingress_schema',
            'table_name': 'isolated_table'
        }))

    def test_returns_list_containing_dependent_table_keys_if_table_has_dependents(self):
        node_lineage_tracer = TableDeleteNodeLineageTracer(self.metadata_table)
        expected = [
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'table_with_source'
            },
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'other_table_with_source'
            }
        ]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'staging_octane',
            'table_name': 'source_table'
        }))


class TestFieldInsertNodeLineageTracer(unittest.TestCase):

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
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.columns.source_field'
                                                }
                                            },
                                            'column_with_distant_source': {
                                                'data_type': 'TEXT',
                                                'source': {
                                                    'field': 'primary_source_table.foreign_keys.fk_1.columns.distant_source_field'
                                                }
                                            },
                                            'column_with_single_column_calculated_source': {
                                                'data_type': 'BOOLEAN',
                                                'source': {
                                                    'calculation': {
                                                        'string': '$1 IS NOT NULL',
                                                        'using': ['primary_source_table.foreign_keys.fk_1.columns.distant_source_field']
                                                    }
                                                }
                                            },
                                            'column_with_multi_column_calculated_source': {
                                                'data_type': 'BOOLEAN',
                                                'source': {
                                                    'calculation': {
                                                        'string': '$1 IS NOT NULL AND $2 IS NOT NULL',
                                                        'using': ['primary_source_table.columns.source_field',
                                                                  'primary_source_table.foreign_keys.fk_1.columns.distant_source_field']
                                                    }
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
                                            'source_field': {
                                                'data_type': 'TEXT'
                                            },
                                            'fk_col': {
                                                'data_type': 'TEXT'
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
                                                'data_type': 'TEXT'
                                            },
                                            'distant_source_field': {
                                                'data_type': 'TEXT'
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

    def test_throws_error_if_given_field_doesnt_exist_in_metadata(self):
        node_lineage_tracer = FieldInsertNodeLineageTracer(self.dw_metadata)
        with self.assertRaises(NodeLineageTracer.InvalidNodeException):
            node_lineage_tracer.determine_node_parents({
                'database_name': 'bad db',
                'schema_name': 'bad schema',
                'table_name': 'bad table',
                'field_name': 'bad column'
            })

    def test_returns_empty_list_for_field_with_no_source_field(self):
        node_lineage_tracer = FieldInsertNodeLineageTracer(self.dw_metadata)
        expected = []
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'staging_octane',
            'table_name': 'source_table',
            'field_name': 'source_field'
        }))

    def test_returns_single_item_list_containing_source_field_key_if_field_source_is_from_primary_source_table(self):
        node_lineage_tracer = FieldInsertNodeLineageTracer(self.dw_metadata)
        expected = [{
            'database_name': 'staging',
            'schema_name': 'staging_octane',
            'table_name': 'source_table',
            'field_name': 'source_field'
        }]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source',
            'field_name': 'column_with_source'
        }))

    def test_returns_single_item_list_containing_source_field_key_if_field_source_is_from_distant_source_table(self):
        node_lineage_tracer = FieldInsertNodeLineageTracer(self.dw_metadata)
        expected = [{
            'database_name': 'staging',
            'schema_name': 'other_schema',
            'table_name': 'distant_source_table',
            'field_name': 'distant_source_field'
        }]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source',
            'field_name': 'column_with_distant_source'
        }))

    def test_returns_single_item_list_containing_source_field_key_if_field_source_is_single_column_calculated(self):
        node_lineage_tracer = FieldInsertNodeLineageTracer(self.dw_metadata)
        expected = [{
            'database_name': 'staging',
            'schema_name': 'other_schema',
            'table_name': 'distant_source_table',
            'field_name': 'distant_source_field'
        }]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source',
            'field_name': 'column_with_single_column_calculated_source'
        }))

    def test_returns_multi_item_list_containing_source_field_keys_if_field_source_is_multi_column_calculated(self):
        node_lineage_tracer = FieldInsertNodeLineageTracer(self.dw_metadata)
        expected = [
            {
                'database_name': 'staging',
                'schema_name': 'staging_octane',
                'table_name': 'source_table',
                'field_name': 'source_field'
            },
            {
                'database_name': 'staging',
                'schema_name': 'other_schema',
                'table_name': 'distant_source_table',
                'field_name': 'distant_source_field'
            }
        ]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source',
            'field_name': 'column_with_multi_column_calculated_source'
        }))

class TestFieldDeleteNodeLineageTracer(unittest.TestCase):

    def setUp(self) -> None:
        self.metadata_table = MetadataTable(key_fields=['database_name', 'schema_name', 'table_name', 'field_name'])
        self.metadata_table.add_rows([
            {
                'database_name': 'staging',
                'schema_name': 'staging_octane',
                'table_name': 'source_table',
                'field_name': 'source_field',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            },
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'table_with_source',
                'field_name': 'field_with_source',
                'source_database_name': 'staging',
                'source_schema_name': 'staging_octane',
                'source_table_name': 'source_table',
                'source_field_name': 'source_field',
            },
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'table_with_source',
                'field_name': 'other_field_with_source',
                'source_database_name': 'staging',
                'source_schema_name': 'staging_octane',
                'source_table_name': 'source_table',
                'source_field_name': 'source_field',
            },
            {
                'database_name': 'ingress',
                'schema_name': 'ingress_schema',
                'table_name': 'isolated_table',
                'field_name': 'isolated_field',
                'source_database_name': None,
                'source_schema_name': None,
                'source_table_name': None,
                'source_field_name': None
            },
        ])

    def test_throws_error_if_given_field_doesnt_exist_in_metadata(self):
        node_lineage_tracer = FieldDeleteNodeLineageTracer(self.metadata_table)
        with self.assertRaises(NodeLineageTracer.InvalidNodeException):
            node_lineage_tracer.determine_node_parents({
                'database_name': 'bad db',
                'schema_name': 'bad schema',
                'table_name': 'bad table',
                'field_name': 'bad field'
            })

    def test_returns_empty_list_for_field_with_no_dependent_column(self):
        node_lineage_tracer = FieldDeleteNodeLineageTracer(self.metadata_table)
        expected = []
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source',
            'field_name': 'field_with_source'
        }))
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'history_octane',
            'table_name': 'table_with_source',
            'field_name': 'other_field_with_source'
        }))
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'ingress',
            'schema_name': 'ingress_schema',
            'table_name': 'isolated_table',
            'field_name': 'isolated_field',
        }))

    def test_returns_list_containing_dependent_field_keys_if_field_has_dependents(self):
        node_lineage_tracer = FieldDeleteNodeLineageTracer(self.metadata_table)
        expected = [
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'table_with_source',
                'field_name': 'field_with_source'
            },
            {
                'database_name': 'staging',
                'schema_name': 'history_octane',
                'table_name': 'table_with_source',
                'field_name': 'other_field_with_source'
            }
        ]
        self.assertEqual(expected, node_lineage_tracer.determine_node_parents({
            'database_name': 'staging',
            'schema_name': 'staging_octane',
            'table_name': 'source_table',
            'field_name': 'source_field'
        }))


if __name__ == '__main__':
    unittest.main()
