import unittest
from generate_view_files import *
from collections import OrderedDict


class TestParseRawEDWConfigData(unittest.TestCase):

    def test_returns_empty_dict_when_given_empty_list(self):
        self.assertEqual({}, parse_raw_edw_config_data([]))

    def test_creates_three_level_structure_of_tables_containing_fields_containing_parameters(self):
        raw_data = [
            {
                'schema_name': 'star_loan',
                'table_name': 'loan_dim',
                'field_name': 'los_loan_number',
                'label': 'Loan Number',
                'primary_key': 'no',
                'other_field1': 'other_value1'
            },
            {
                'schema_name': 'star_loan',
                'table_name': 'loan_dim',
                'field_name': 'loan_dwid',
                'label': '""',
                'primary_key': 'yes',
                'other_field2': 'other_value2'
            },
            {
                'schema_name': 'star_loan',
                'table_name': 'borrower_dim',
                'field_name': 'office_phone',
                'label': 'Office Phone',
                'primary_key': 'no',
                'other_field3': 'other_value3'
            }
        ]
        expected = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'label': {'value': 'Loan Number', 'included': True},
                        'primary_key': {'value': 'no', 'included': True},
                        'other_field1': {'value': 'other_value1', 'included': True}
                    },
                    'loan_dwid': {
                        'label': {'value': '""', 'included': True},
                        'primary_key': {'value': 'yes', 'included': True},
                        'other_field2': {'value': 'other_value2', 'included': True}
                    }
                }
            },
            'borrower_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'office_phone': {
                        'label': {'value': 'Office Phone', 'included': True},
                        'primary_key': {'value': 'no', 'included': True},
                        'other_field3': {'value': 'other_value3', 'included': True}
                    }
                }
            }
        }
        self.assertEqual(expected, parse_raw_edw_config_data(raw_data))

    def test_doesnt_add_parameter_to_dimension_config_if_value_is_null(self):
        raw_data = [
            {
                'schema_name': 'star_loan',
                'table_name': 'loan_dim',
                'field_name': 'los_loan_number',
                'field1': 'value1'
            },
            {
                'schema_name': 'star_loan',
                'table_name': 'loan_dim',
                'field_name': 'los_loan_number',
                'field2': None
            }
        ]
        expected = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'field1': {'value': 'value1', 'included': True}
                    }
                }
            }
        }
        self.assertEqual(expected, parse_raw_edw_config_data(raw_data))


class TestMarkUnneededParametersAsNotIncluded(unittest.TestCase):

    def test_marks_primary_key_as_not_included_if_field_is_not_the_primary_key(self):
        data = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'primary_key': {'value': 'no', 'included': True},
                    },
                    'loan_dwid': {
                        'primary_key': {'value': 'yes', 'included': True}
                    }
                }
            }
        }
        expected = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'primary_key': {'value': 'no', 'included': False},
                    },
                    'loan_dwid': {
                        'primary_key': {'value': 'yes', 'included': True}
                    }
                }
            }
        }
        self.assertEqual(expected, mark_unneeded_parameters_as_not_included(data))

    def test_marks_hidden_as_not_included_if_field_is_not_hidden(self):
        data = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': True},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True}
                    }
                }
            }
        }
        expected = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': False},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True}
                    }
                }
            }
        }
        self.assertEqual(expected, mark_unneeded_parameters_as_not_included(data))

    def test_marks_label_as_not_included_if_field_is_hidden(self):
        data = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': False},
                        'label': {'value': 'Loan Number', 'included': True},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True},
                        'label': {'value': None, 'included': True},
                    }
                }
            }
        }
        expected = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': False},
                        'label': {'value': 'Loan Number', 'included': True},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True},
                        'label': {'value': None, 'included': False},
                    }
                }
            }
        }
        self.assertEqual(expected, mark_unneeded_parameters_as_not_included(data))

    def test_marks_description_as_not_included_if_field_is_hidden_or_description_is_empty(self):
        data = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': False},
                        'description': {'value': 'desc here', 'included': True},
                    },
                    'hoepa_apr': {
                        'hidden': {'value': 'no', 'included': False},
                        'description': {'value': '""', 'included': True},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True},
                        'description': {'value': '""', 'included': True},
                    }
                }
            }
        }
        expected = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': False},
                        'description': {'value': 'desc here', 'included': True},
                    },
                    'hoepa_apr': {
                        'hidden': {'value': 'no', 'included': False},
                        'description': {'value': '""', 'included': False},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True},
                        'description': {'value': '""', 'included': False},
                    }
                }
            }
        }
        self.assertEqual(expected, mark_unneeded_parameters_as_not_included(data))

    def test_marks_value_format_as_not_included_if_field_is_hidden_or_type_makes_it_irrelevant(self):
        data = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': False},
                        'type': {'value': 'number', 'included': True},
                        'value_format': {'value': '"0"', 'included': True},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True},
                        'type': {'value': 'number', 'included': True},
                        'value_format': {'value': '"0"', 'included': True},
                    },
                    'string_field': {
                        'hidden': {'value': 'no', 'included': True},
                        'type': {'value': 'string', 'included': True},
                        'value_format': {'value': '""', 'included': True},
                    },
                    'yesno_field': {
                        'hidden': {'value': 'no', 'included': True},
                        'type': {'value': 'yesno', 'included': True},
                        'value_format': {'value': '""', 'included': True},
                    }
                }
            }
        }
        expected = {
            'loan_dim': {
                'schema_name': 'star_loan',
                'dimensions': {
                    'los_loan_number': {
                        'hidden': {'value': 'no', 'included': False},
                        'type': {'value': 'number', 'included': True},
                        'value_format': {'value': '"0"', 'included': True},
                    },
                    'loan_dwid': {
                        'hidden': {'value': 'yes', 'included': True},
                        'type': {'value': 'number', 'included': True},
                        'value_format': {'value': '"0"', 'included': False},
                    },
                    'string_field': {
                        'hidden': {'value': 'no', 'included': False},
                        'type': {'value': 'string', 'included': True},
                        'value_format': {'value': '""', 'included': False},
                    },
                    'yesno_field': {
                        'hidden': {'value': 'no', 'included': False},
                        'type': {'value': 'yesno', 'included': True},
                        'value_format': {'value': '""', 'included': False},
                    }
                }
            }
        }
        self.assertEqual(expected, mark_unneeded_parameters_as_not_included(data))


class TestCreateSortedDimensionList(unittest.TestCase):
    def test_creates_list_of_dimensions_sorted_by_hidden_and_type_and_name(self):
        dimensions = {
            'dim3': {
                'type': {'value': 'string', 'included': True},
                'hidden': {'value': 'no', 'included': False}
            },
            'dim2': {
                'type': {'value': 'bool', 'included': True},
                'hidden': {'value': 'no', 'included': False}
            },
            'dim4': {
                'type': {'value': 'string', 'included': True},
                'hidden': {'value': 'yes', 'included': True}
            },
            'dim1': {
                'type': {'value': 'string', 'included': True},
                'hidden': {'value': 'no', 'included': False}
            },
        }
        expected = OrderedDict({
            'dim4': {
                'type': {'value': 'string', 'included': True},
                'hidden': {'value': 'yes', 'included': True}
            },
            'dim2': {
                'type': {'value': 'bool', 'included': True},
                'hidden': {'value': 'no', 'included': False}
            },
            'dim1': {
                'type': {'value': 'string', 'included': True},
                'hidden': {'value': 'no', 'included': False}
            },
            'dim3': {
                'type': {'value': 'string', 'included': True},
                'hidden': {'value': 'no', 'included': False}
            }
        })
        self.assertEqual(expected, sort_dimensions(dimensions))


class TestFormatDimensionConfigString(unittest.TestCase):

    def test_creates_empty_scaffold_if_dict_contains_no_options(self):
        expected = '  dimension: borrower_dim {\n' + \
                   '\n' + \
                   '  }'
        self.assertEqual(expected, format_dimension_config_string('borrower_dim', {}))

    def test_adds_all_given_parameters_to_the_config_string(self):
        expected = '  dimension: loan_pid {\n' + \
                   '    field1: a\n' + \
                   '    field2: b\n' + \
                   '    field3: c\n' + \
                   '  }'
        self.assertEqual(expected, format_dimension_config_string('loan_pid', {
            'field1': {'value': 'a', 'included': True},
            'field2': {'value': 'b', 'included': True},
            'field3': {'value': 'c', 'included': True}
        }))

    def test_comments_out_parameters_marked_as_not_included(self):
        expected = '  dimension: loan_pid {\n' + \
                   '    # field1: a\n' + \
                   '    field2: b\n' + \
                   '  }'
        self.assertEqual(expected, format_dimension_config_string('loan_pid', {
            'field1': {'value': 'a', 'included': False},
            'field2': {'value': 'b', 'included': True},
        }))


class TestFormatViewFileString(unittest.TestCase):

    def test_creates_empty_scaffold_if_dict_contains_no_dimensions(self):
        expected = 'view: borrower_dim {\n' + \
                   '  sql_table_name: star_loan.borrower_dim ;;\n' + \
                   '\n' + \
                   '\n' + \
                   '}'
        self.assertEqual(expected, format_view_file_string('star_loan', 'borrower_dim', {}))

    def test_adds_configurations_for_all_the_views_dimensions(self):
        dimensions = {
            'loan_dwid': {
                'hidden': {'value': 'yes', 'included': True},
                'value_format': {'value': None, 'included': False},
                'type': {'value': 'number', 'included': True}
            },
            'los_loan_number': {
                'hidden': {'value': 'no', 'included': False},
                'value_format': {'value': '"value_format_here"', 'included': True},
                'type': {'value': 'number', 'included': True}
            }
        }
        expected = 'view: borrower_dim {\n' + \
                   '  sql_table_name: star_loan.borrower_dim ;;\n' + \
                   '\n' + \
                   '  dimension: loan_dwid {\n' + \
                   '    hidden: yes\n' + \
                   '    type: number\n' + \
                   '    # value_format: None\n' + \
                   '  }\n' + \
                   '\n' + \
                   '  dimension: los_loan_number {\n' + \
                   '    # hidden: no\n' + \
                   '    type: number\n' + \
                   '    value_format: "value_format_here"\n' + \
                   '  }\n' + \
                   '}'
        self.assertEqual(expected, format_view_file_string('star_loan', 'borrower_dim', dimensions))


if __name__ == '__main__':
    unittest.main()
