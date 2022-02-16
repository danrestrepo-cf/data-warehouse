"""
Generate LookML View files from metadata in the EDW config database
"""

import sys
import os
from collections import defaultdict, OrderedDict
from typing import List

import psycopg2
import psycopg2.extras


def main():
    if incorrect_usage():
        print('usage: generate_view_files.py [output_directory]')
        return
    output_dir = get_output_directory_filepath()
    raw_edw_config_data = read_raw_config_data_from_edw()
    view_configs = mark_unneeded_parameters_as_not_included(parse_raw_edw_config_data(raw_edw_config_data))
    for table_name, view_config in view_configs.items():
        view_file_string = format_view_file_string(view_config['schema_name'], table_name, view_config['dimensions'])
        with open(os.path.join(output_dir, f'{table_name}.view.lkml'), 'w') as file:
            file.write(view_file_string)


def incorrect_usage() -> bool:
    return len(sys.argv) > 2


def get_output_directory_filepath() -> str:
    """
    Capture the output directory filepath and create the specified
    directory if it doesn't exist. If the output directory is not specified as
    a command-line argument, output files to a default directory in the
    same parent directory as this script.
    """
    if len(sys.argv) == 2:
        output_dir = sys.argv[1]
    else:
        output_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'generated_view_files')
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    return output_dir


def read_raw_config_data_from_edw() -> List[dict]:
    with EDW() as cursor:
        return cursor.select_as_list_of_dicts("""
            WITH postgres_to_looker_type_map (postgres_type, looker_type, looker_format, looker_datetime_datatype) AS (
                VALUES ('BIGINT', 'number', '"0"', NULL)
                     , ('BIGSERIAL', 'number', '"0"', NULL)
                     , ('BOOLEAN', 'yesno', '""', NULL)
                     , ('DATE', 'date', '"mm/dd/yyyy"', 'date')
                     , ('INTEGER', 'number', '"0"', NULL)
                     , ('NUMERIC(15,9)', 'number', '"0.000000000%"', NULL)
                     , ('NUMERIC(21,3)', 'number', '"$0.00"', NULL)
                     , ('TEXT', 'string', '""', NULL)
                     , ('TIMESTAMPTZ', 'date_time', '"mm/dd/yyyy hh:mm:ss AM/PM"', 'timestamp')
                     , ('TIMETZ', 'date_time_of_day', '"hh:mm:ss AM/PM"', 'timestamp')
            )
            SELECT edw_table_definition.schema_name
                 , edw_table_definition.table_name
                 , edw_field_definition.field_name
                 , edw_field_definition.reporting_hidden AS hidden
                 , '"' || COALESCE( edw_field_definition.reporting_label, '' ) || '"' AS label
                 , '"' || COALESCE( edw_field_definition.reporting_description, '' ) || '"' AS description
                 , CASE WHEN edw_field_definition.data_type LIKE 'VARCHAR%' THEN 'string' ELSE postgres_to_looker_type_map.looker_type END AS type
                 , COALESCE( postgres_to_looker_type_map.looker_format, '""' ) AS value_format
                 , postgres_to_looker_type_map.looker_datetime_datatype AS datatype
                 , CASE WHEN edw_field_definition.reporting_key_flag THEN 'yes' ELSE 'no' END AS primary_key
                 , '${TABLE}."' || edw_field_definition.field_name || '" ;;' AS sql
            FROM mdi.edw_field_definition
            JOIN mdi.edw_table_definition
                 ON edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
            LEFT JOIN postgres_to_looker_type_map
                      ON postgres_to_looker_type_map.postgres_type = edw_field_definition.data_type
            WHERE edw_table_definition.schema_name = 'star_loan';
        """)


def parse_raw_edw_config_data(edw_config_data: List[dict]) -> dict:
    """
    Parse the given list of rows read from EDW config tables into a more useful
    hierarchical data structure of the form:

     {
        table1: {
            'schema_name': schema_name,
            'dimensions': {
                field1: {
                    parameter1: {'value': value1, 'included': True},
                    parameter2: {'value': value2, 'included': True},
                    ...etc
                },
                field2: {
                    parameter1: {'value': value1, 'included': True},
                    parameter2: {'value': value2, 'included': True},
                    ...etc
                }
                ...etc
            }
        },

        table2: {
            ...etc
        },

        ...etc
    }

    :param edw_config_data: Looker view configuration data read directory from
           EDW's config database
    :return: a single dict describing the Looker View configurations of all tables
             present in the given raw edw data
    """
    parsed_data = {}
    for row in edw_config_data:
        if row['table_name'] not in parsed_data:
            parsed_data[row['table_name']] = {
                'schema_name': row['schema_name'],
                'dimensions': defaultdict(dict)
            }
        table_dimensions = parsed_data[row['table_name']]['dimensions']
        for parameter_name in get_parameter_field_names(row):
            add_parameter(table_dimensions[row['field_name']], parameter_name, row[parameter_name])
    return parsed_data


def get_parameter_field_names(raw_edw_config_row: dict) -> List[str]:
    """
    Get the set of fields from a raw config data row that will eventually be used
    as dimension parameters, excluding fields with a value of null
    """
    return [param for param in raw_edw_config_row.keys() if
            (raw_edw_config_row[param] is not None) and
            (param not in {'schema_name', 'table_name', 'field_name'})]


def add_parameter(dimension: dict, name: str, value):
    """
    Update the given dimension dict with a new parameter record of the form:

    name: {"value": value, "included": True}

    :param dimension: the dimension dict to which to add the parameter
    :param name: the name of the parameter to add
    :param value: the initial value of the parameter
    """
    dimension[name] = {'value': value, 'included': True}


def mark_unneeded_parameters_as_not_included(parsed_config_data: dict) -> dict:
    """
    Mark certain dimension parameters as not "included", based on various criteria
    (e.g. the "primary_key" attribute only needs to be included if its value is "yes")

    :param parsed_config_data: the Looker view config data structure, after having
                               its parameter values replaced with parameter attribute
                               dicts
    :return: the config data structure with each parameter's "included" attribute
             set based on various parameter values
    """
    for view_config in parsed_config_data.values():
        for dimension in view_config['dimensions'].values():
            if 'primary_key' in dimension.keys():
                dimension['primary_key']['included'] = dimension['primary_key']['value'] == 'yes'
            if 'hidden' in dimension.keys():
                dimension['hidden']['included'] = dimension['hidden']['value'] == 'yes'
                if 'label' in dimension.keys():
                    dimension['label']['included'] = dimension['hidden']['value'] == 'no'
                if 'description' in dimension.keys():
                    dimension['description']['included'] = (dimension['hidden']['value'] == 'no') and \
                                                           (dimension['description']['value'] != '""')
                if 'value_format' in dimension.keys() and 'type' in dimension.keys():
                    dimension['value_format']['included'] = (dimension['hidden']['value'] == 'no') and \
                                                            (dimension['type']['value'] not in ('string', 'yesno'))
    return parsed_config_data


def format_view_file_string(schema_name: str, table_name: str, dimensions: dict) -> str:
    """
    Generate the Looker view configuration file contents for the given table.

    Output will be a string in the format:

    view: table_name {
      sql_table_name: schema_name.table_name ;;

      dimension: field1 {
        parameter1: abc
        parameter2: def
        ...etc
      }
      ...etc
    }

    :param schema_name: the Postgres table's schema
    :param table_name: the Postgres table powering the Looker view in question
    :param dimensions: a dictionary of Looker dimensions (Postgres column names)
           and their configuration attributes
    :return: a string containing the full Looker view configuration code for the
             given table, ready to be written to a file
    """
    sorted_dimensions = sort_dimensions(dimensions)
    dimensions_string = '\n\n'.join([format_dimension_config_string(dimension, params) for dimension, params in sorted_dimensions.items()])
    return f'view: {table_name} {{\n' + \
           f'  sql_table_name: {schema_name}.{table_name} ;;\n' + \
           '\n' + \
           dimensions_string + \
           '\n}'


def sort_dimensions(dimensions: dict) -> OrderedDict:
    """
    Create a sorted copy of the given dimension dict, sorted by hidden, type, and
    dimension name
    """
    return OrderedDict(
        sorted(
            sorted(
                dimensions.items(),
                key=lambda d: (d[1]['type']['value'], d[0])
            ),
            key=lambda d: d[1]['hidden']['value'],
            reverse=True
        )
    )


def format_dimension_config_string(dimension_name: str, parameters: dict) -> str:
    """
    Generate the Looker dimension configuration code to be included in the view
    file containing this dimension.

    Output will be a string in the format:

    dimension: dimension_name {
        parameter1: abc
        parameter2: def
        ...etc
    }

    :param dimension_name: the name of the dimension being configured
    :param parameters: a dictionary of Looker dimension parameters
    :return: a string containing the full Looker dimension configuration code for
             the given dimension
    """
    parameters_string = '\n'.join([build_parameter_string(param, parameters[param]) for param in sorted(parameters.keys())])
    return f'  dimension: {dimension_name} {{\n' + \
           parameters_string + \
           '\n  }'


def build_parameter_string(parameter: str, param_attributes: dict) -> str:
    """
    Generate the Looker configuration code for a single dimension parameter.

    Examples: "# hidden: no" or "type: string"

    :param parameter: the name of hte parameter
    :param param_attributes: a dictionary specifying the value of the parameter
           ("value") and whether or not it should be included in the configuration
           ("included")
    :return:
    """
    comment_symbol = '' if param_attributes['included'] else '# '
    return f"    {comment_symbol}{parameter}: {param_attributes['value']}"


class EDW:
    """
    A connection to EDW. When used as a context manager, returns an EDWCursor
    instance.
    """

    def __init__(self, host: str = 'localhost', dbname: str = 'config', user: str = 'postgres', password: str = 'testonly'):
        self.host = host
        self.dbname = dbname
        self.user = user
        self.password = password

    def __enter__(self):
        self.conn = psycopg2.connect(host=self.host, database=self.dbname, user=self.user, password=self.password, port=5432)
        return EDWCursor(self.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor))

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()


class EDWCursor:
    """
    A simple wrapper around psycopg2's cursor with method(s) added to facilitate
    more expressive code
    """

    def __init__(self, cursor):
        self.cursor = cursor

    def select_as_list_of_dicts(self, sql: str) -> List[dict]:
        self.cursor.execute(sql)
        return self.cursor.fetchall()


if __name__ == '__main__':
    main()
