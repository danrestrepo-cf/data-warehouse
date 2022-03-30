import unittest
import os
import re
from typing import List, Dict

from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.metadata_core.data_warehouse_metadata import TableMetadata

METADATA_DIR = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'metadata', 'edw'))


def get_table_yaml_file_path(table: TableMetadata) -> str:
    return os.path.join(METADATA_DIR, f'db.{table.path.database}', f'schema.{table.path.schema}',
                        f'table.{table.path.table}.yaml')


class TestYAMLMetadata(unittest.TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        # reading in all metadata YAMLs is an expensive I/O operation. Since no
        # test in this suite should modify this data, we perform this operation
        # only once up front in a class method
        cls.metadata = generate_data_warehouse_metadata_from_yaml(METADATA_DIR)

    def test_next_step_functions_never_result_in_recursive_loops(self):

        def relationship_contains_loop(start: str, relationships: Dict[str, List[str]], already_seen: set) -> bool:
            """Recursively check whether the next_step_functions chain starting from the given 'start' step function results in a loop."""
            if start in already_seen:
                return True
            else:
                already_seen.add(start)
                for next_step_function in relationships[start]:
                    if relationship_contains_loop(next_step_function, relationships, already_seen.copy()):
                        return True
                return False

        sfn_relationships = {}
        sfn_parent_files = {}
        sfns_with_looping_descendants = []

        # construct a map of step functions to all "next_step_functions" their ETLs trigger
        for database in self.metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for step_function in table.step_functions:
                        sfn_parent_files[step_function.name] = get_table_yaml_file_path(table)
                        sfn_relationships[step_function.name] = []
                        for etl in step_function.etls:
                            for next_step_function_name in etl.next_step_functions:
                                sfn_relationships[step_function.name].append(next_step_function_name)

        # determine if any step functions initiate a looping chain of "next_step_functions"
        for sfn_name in sfn_relationships.keys():
            already_seen_sfns = set()
            if relationship_contains_loop(sfn_name, sfn_relationships, already_seen_sfns):
                sfns_with_looping_descendants.append(sfn_name)

        if sfns_with_looping_descendants:
            error_message_sfn_list = [f'{sfn} (defined in {sfn_parent_files[sfn]})' for sfn in sfns_with_looping_descendants]
            self.fail(f'Triggering loops detected involving step functions: {", ".join(error_message_sfn_list)}')

    def test_etl_names_contain_only_valid_characters(self):
        bad_etls = []
        etl_parent_files = {}
        for database in self.metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for step_function in table.step_functions:
                        for etl in step_function.etls:
                            if not re.match(r'^[a-zA-Z0-9_-]+$', etl.process_name):
                                etl_parent_files[etl.process_name] = get_table_yaml_file_path(table)
                                bad_etls.append(etl)
        if bad_etls:
            error_message_etl_list = [f'{etl.process_name} (defined in {etl_parent_files[etl.process_name]})' for etl in bad_etls]
            self.fail(f'Invalid ETL names: {", ".join(error_message_etl_list)}')
