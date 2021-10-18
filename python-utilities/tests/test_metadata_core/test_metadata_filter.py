import unittest

from lib.metadata_core.metadata_filter import MetadataFilterMatcher, MetadataFilter


class TestMetadataFilterMatcher(unittest.TestCase):

    def setUp(self) -> None:
        self.matcher = MetadataFilterMatcher()

    def test_matches_anything_if_there_are_no_reference_filters(self):
        self.assertTrue(self.matcher.matches())
        self.assertTrue(self.matcher.matches(database='', schema='', table='', column=''))
        self.assertTrue(self.matcher.matches(database='db', column='c1'))

    def test_matches_if_the_given_attributes_exactly_match_at_least_one_filter(self):
        self.matcher.add_filter(MetadataFilter(databases=['db1']))
        self.matcher.add_filter(MetadataFilter(schemas=['sch1']))
        self.matcher.add_filter(MetadataFilter(tables=['t1']))
        self.matcher.add_filter(MetadataFilter(columns=['c1']))

        self.assertTrue(self.matcher.matches(database='db1'))
        self.assertTrue(self.matcher.matches(schema='sch1'))
        self.assertTrue(self.matcher.matches(table='t1'))
        self.assertTrue(self.matcher.matches(column='c1'))

    def test_doesnt_match_if_the_given_attributes_dont_match_at_least_one_filter(self):
        self.matcher.add_filter(MetadataFilter(databases=['db1']))
        self.assertFalse(self.matcher.matches(database='db2'))

    def test_doesnt_match_if_even_one_attribute_doesnt_match(self):
        self.matcher.add_filter(MetadataFilter(databases=['db1'], schemas=['sch1'], tables=['t1'], columns=['c1']))
        self.assertFalse(self.matcher.matches(database='db1', schema='sch1', table='t1', column='doesnt_match'))

    def test_matches_any_attribute_set_in_the_cartesian_product_of_a_filters_attributes(self):
        self.matcher.add_filter(
            MetadataFilter(databases=['db1', 'db2'], schemas=['sch1', 'sch2'], tables=['t1', 't2'], columns=['c1', 'c2'])
        )
        self.assertTrue(self.matcher.matches(database='db1', schema='sch2', table='t1', column='c2'))
        self.assertTrue(self.matcher.matches(database='db2', schema='sch1', table='t2', column='c1'))

    def test_matches_if_all_specified_filter_attributes_are_matched_even_if_there_are_more_input_attributes_than_filter_attributes(self):
        self.matcher.add_filter(MetadataFilter(schemas=['sch1']))
        self.assertTrue(self.matcher.matches(database='db1', schema='sch1', table='t1', column='doesnt_match'))

    def test_an_attribute_consisting_only_of_an_asterisk_matches_anything(self):
        self.matcher.add_filter(MetadataFilter(databases=['*'], schemas=['*'], tables=['*'], columns=['*']))
        self.assertTrue(self.matcher.matches(database='db1', schema='sch1', table='t1', column='c1'))
        self.assertTrue(self.matcher.matches(database='db2', schema='sch2', table='t2', column='c2'))

    def test_asterisks_within_attributes_are_treated_like_wildcards(self):
        self.matcher.add_filter(MetadataFilter(databases=['d*b*1'], schemas=['*ch*'], tables=['t*'], columns=['*olu*']))
        self.assertTrue(self.matcher.matches(database='db1', schema='sch1', table='t1', column='olum'))
        self.assertTrue(self.matcher.matches(database='database1', schema='schema1', table='table1', column='column1'))

    def test_has_filters_returns_false_if_no_filters_have_been_added_to_the_filter_matcher(self):
        self.assertFalse(self.matcher.has_filters)

    def test_has_filters_returns_true_if_at_least_one_filter_has_been_added_to_the_filter_matcher(self):
        self.matcher.add_filter(MetadataFilter(databases=['db1']))
        self.assertTrue(self.matcher.has_filters)


if __name__ == '__main__':
    unittest.main()
