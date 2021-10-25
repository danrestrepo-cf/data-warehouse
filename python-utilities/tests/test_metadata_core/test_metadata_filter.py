import copy
import unittest

from lib.metadata_core.metadata_filter import InclusiveMetadataFilterer, ExclusiveMetadataFilterer, CriteriaMatcher
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict
from lib.metadata_core.metadata_object_path import DatabasePath, SchemaPath, TablePath, ColumnPath


class TestCriteriaMatcher(unittest.TestCase):

    def test_has_criteria_returns_false_if_no_criteria_have_been_added(self):
        criteria_matcher = CriteriaMatcher(['database'])
        self.assertFalse(criteria_matcher.has_criteria)

    def test_has_criteria_returns_true_if_at_least_one_criterion_has_been_added(self):
        criteria_matcher = CriteriaMatcher(['database'])
        criteria_matcher.add_criteria(DatabasePath('db1'))
        self.assertTrue(criteria_matcher.has_criteria)

    def test_matches_if_all_input_attributes_exactly_match_at_least_one_criterion_attribute_set(self):
        criteria_matcher = CriteriaMatcher(['database', 'schema'])
        criteria_matcher.add_criteria(SchemaPath('db1', 'sch1'))
        criteria_matcher.add_criteria(SchemaPath('db1', 'sch2'))
        self.assertTrue(criteria_matcher.matches(SchemaPath('db1', 'sch1')))
        self.assertTrue(criteria_matcher.matches(SchemaPath('db1', 'sch2')))

    def test_does_not_match_if_not_all_input_attributes_exactly_match_at_least_one_criterion_attribute_set(self):
        criteria_matcher = CriteriaMatcher(['database', 'schema'])
        self.assertFalse(criteria_matcher.matches(SchemaPath('db1', 'sch1')))
        criteria_matcher.add_criteria(SchemaPath('db3', 'sch4'))
        self.assertFalse(criteria_matcher.matches(SchemaPath('db1', 'sch1')))

    def test_asterisks_within_criterion_attributes_are_treated_like_wildcards(self):
        criteria_matcher = CriteriaMatcher(['database', 'schema'])
        criteria_matcher.add_criteria(SchemaPath('db1', 'sch*'))
        criteria_matcher.add_criteria(SchemaPath('db1', '*woo*hoo*'))
        self.assertTrue(criteria_matcher.matches(SchemaPath('db1', 'sch1')))
        self.assertTrue(criteria_matcher.matches(SchemaPath('db1', '123woo456hoo789')))
        self.assertFalse(criteria_matcher.matches(SchemaPath('db1', 'oohoo')))


class TestInclusiveMetadataFilterer(unittest.TestCase):

    def setUp(self) -> None:
        self.filterer = InclusiveMetadataFilterer()
        self.metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'sch1',
                                'tables': [
                                    {
                                        'name': 't1'
                                    },
                                    {
                                        'name': 't2',
                                        'columns': {
                                            'c1': {
                                                'data_type': 'TEXT'
                                            }
                                        }
                                    },
                                    {
                                        'name': 't3',
                                        'columns': {
                                            'c1': {
                                                'data_type': 'TEXT'
                                            }
                                        },
                                        'foreign_keys': {
                                            'fk1': {
                                                'columns': ['c1'],
                                                'references': {
                                                    'columns': ['c1_99'],
                                                    'schema': 'sch99',
                                                    'table': 'table99'
                                                }
                                            }
                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'sch2'
                            }
                        ]
                    },
                    {
                        'name': 'db2',
                        'schemas': [
                            {
                                'name': 'sch2',
                                'tables': [
                                    {
                                        'name': 't2',
                                        'columns': {
                                            'c2': {
                                                'data_type': 'INT'
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

    def test_does_nothing_if_no_filters_have_been_added(self):
        expected = copy.deepcopy(self.metadata)
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_databases_that_do_not_match_at_least_one_filter(self):
        self.filterer.add_database_criteria(DatabasePath('db1'))
        expected = copy.deepcopy(self.metadata)
        expected.remove_database('db2')
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_schemas_that_do_not_match_at_least_one_filter(self):
        self.filterer.add_schema_criteria(SchemaPath('db1', 'sch*'))
        expected = copy.deepcopy(self.metadata)
        expected.get_database('db2').remove_schema('sch2')
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_tables_that_do_not_match_at_least_one_filter(self):
        self.filterer.add_table_criteria(TablePath('db*', 'sch*', 't2'))
        expected = copy.deepcopy(self.metadata)
        expected.get_database('db1').get_schema('sch1').remove_table('t1')
        expected.get_database('db1').get_schema('sch1').remove_table('t3')
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_columns_that_do_not_match_at_least_one_filter_as_well_as_their_foreign_keys(self):
        self.filterer.add_column_criteria(ColumnPath('db1', 'sch1', 't2', 'c1'))
        expected = copy.deepcopy(self.metadata)
        expected.get_database('db1').get_schema('sch1').get_table('t3').remove_foreign_key('fk1')
        expected.get_database('db1').get_schema('sch1').get_table('t3').remove_column('c1')
        expected.get_database('db2').get_schema('sch2').get_table('t2').remove_column('c2')
        self.assertEqual(expected, self.filterer.filter(self.metadata))


class TestExclusiveMetadataFilterer(unittest.TestCase):

    def setUp(self) -> None:
        self.filterer = ExclusiveMetadataFilterer()
        self.metadata = construct_data_warehouse_metadata_from_dict(
            {
                'name': 'edw',
                'databases': [
                    {
                        'name': 'db1',
                        'schemas': [
                            {
                                'name': 'sch1',
                                'tables': [
                                    {
                                        'name': 't1'
                                    },
                                    {
                                        'name': 't2',
                                        'columns': {
                                            'c1': {
                                                'data_type': 'TEXT'
                                            }
                                        }
                                    },
                                    {
                                        'name': 't3',
                                        'columns': {
                                            'c1': {
                                                'data_type': 'TEXT'
                                            }
                                        }
                                    }
                                ]
                            },
                            {
                                'name': 'sch2'
                            }
                        ]
                    },
                    {
                        'name': 'db2',
                        'schemas': [
                            {
                                'name': 'sch2',
                                'tables': [
                                    {
                                        'name': 't2',
                                        'columns': {
                                            'c2': {
                                                'data_type': 'INT'
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

    def test_does_nothing_if_no_filters_have_been_added(self):
        expected = copy.deepcopy(self.metadata)
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_databases_that_match_at_least_one_filter(self):
        self.filterer.add_database_criteria(DatabasePath('db1'))
        expected = copy.deepcopy(self.metadata)
        expected.remove_database('db1')
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_schemas_that_match_at_least_one_filter(self):
        self.filterer.add_schema_criteria(SchemaPath('db1', 'sch*'))
        expected = copy.deepcopy(self.metadata)
        expected.get_database('db1').remove_schema('sch1')
        expected.get_database('db1').remove_schema('sch2')
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_tables_that_match_at_least_one_filter(self):
        self.filterer.add_table_criteria(TablePath('db*', 'sch*', 't2'))
        expected = copy.deepcopy(self.metadata)
        expected.get_database('db1').get_schema('sch1').remove_table('t2')
        expected.get_database('db2').get_schema('sch2').remove_table('t2')
        self.assertEqual(expected, self.filterer.filter(self.metadata))

    def test_removes_any_columns_that_do_not_match_at_least_one_filter(self):
        self.filterer.add_column_criteria(ColumnPath('db1', 'sch1', 't2', 'c1'))
        expected = copy.deepcopy(self.metadata)
        expected.get_database('db1').get_schema('sch1').get_table('t2').remove_column('c1')
        self.assertEqual(expected, self.filterer.filter(self.metadata))


if __name__ == '__main__':
    unittest.main()
