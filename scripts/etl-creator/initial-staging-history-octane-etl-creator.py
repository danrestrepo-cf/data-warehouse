import psycopg2
import psycopg2.extras
from datetime import date
from datetime import datetime
import sys
import getopt


class EDW:
    #######################
    # Common errors:
    #######################
    # Exception Message:
    # File "C:\Users\ramon.ecung\Projects\data-warehouse\scripts\etl-creator\env\lib\site-packages\psycopg2\extras.py", line 251, in execute
    #     return super(RealDictCursor, self).execute(query, vars)
    # IndexError: tuple index out of range
    # --------------------
    # Resolution:
    # This error likely means there is a single '%' in the query being executed which needs to be escaped by using '%%' instead
    #######################

    database_name = ""
    database_username = ""
    database_password = ""
    database_hostname = ""
    database_port = ""

    def __init__(self,
                 db_name="config",
                 db_username="postgres",
                 db_password="testonly",
                 db_hostname="localhost",
                 db_port="5432"):
        self.database_name = db_name
        self.database_username = db_username
        self.database_password = db_password
        self.database_hostname = db_hostname
        self.database_port = db_port

    def execute_select_query(self, query: str, database=database_name):
        conn = psycopg2.connect(database=database,
                                user=self.database_username,
                                password=self.database_password,
                                host=self.database_hostname,
                                port=self.database_port)
        cur = conn.cursor()
        cur.execute(query)
        rows = cur.fetchall()
        conn.close()
        return rows

    def execute_parameterized_query(self, query: str, *parameters):
        """
        This function connects to the database, executes a query using sanitization, commits any changes, and returns the resultant rows

        :param query: the SQL query to execute. sanitize any variables using '%s'
        :param parameters: a tuple of parameters with one value in the tuple per '%s' in the query
        :return: returns a list of RealDict objects with the data from the rows returned by the query
        """

        conn = psycopg2.connect(database=self.database_name,
                                user=self.database_username,
                                password=self.database_password,
                                host=self.database_hostname,
                                port=self.database_port)
        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute(query, parameters)
        conn.commit()
        rows = cur.fetchall()
        conn.close()
        return rows

    def get_child_join_data(self, root_join_dwid: int) -> list:
        query = '''SELECT
    parent_join_tree_definition.dwid as parent_join_tree_definition_dwid,
    parent_join_tree_definition.root_join_dwid as parent_join_tree_definition_root_join_dwid,
    parent_join_tree_definition.child_join_tree_dwid as parent_join_tree_definition_child_join_tree_dwid,

    child_join_tree_definition.dwid as child_join_tree_definition_dwid,
    child_join_tree_definition.root_join_dwid as child_join_tree_definition_root_join_dwid,
    child_join_tree_definition.child_join_tree_dwid as child_join_tree_definition_child_join_tree_dwid,

    child_join_definition.primary_edw_table_definition_dwid as primary_edw_table_definition_dwid,
    child_join_definition.target_edw_table_definition_dwid as target_edw_table_definition_dwid,
    child_join_definition.join_type as join_type,
    child_join_definition.join_condition as join_condition,

    primary_child_table_definition.schema_name as parent_schema_name,
    primary_child_table_definition.table_name as parent_table_name,
    primary_child_field_definition.field_name as parent_field_name,

    target_child_table_definition.schema_name as target_schema_name,
    target_child_table_definition.table_name as target_table_name,
    target_child_field_definition.field_name as target_field_name
FROM
    mdi.edw_join_tree_definition parent_join_tree_definition
    JOIN mdi.edw_join_tree_definition child_join_tree_definition ON parent_join_tree_definition.child_join_tree_dwid = child_join_tree_definition.dwid
    JOIN mdi.edw_join_definition child_join_definition ON child_join_tree_definition.root_join_dwid = child_join_definition.dwid

    JOIN mdi.edw_table_definition target_child_table_definition ON target_child_table_definition.dwid = child_join_definition.target_edw_table_definition_dwid
    JOIN mdi.edw_field_definition target_child_field_definition ON target_child_table_definition.dwid = target_child_field_definition.edw_table_definition_dwid AND target_child_field_definition.key_field_flag = TRUE

    JOIN mdi.edw_table_definition primary_child_table_definition ON primary_child_table_definition.dwid = child_join_definition.primary_edw_table_definition_dwid
    JOIN mdi.edw_field_definition primary_child_field_definition ON primary_child_table_definition.dwid = primary_child_field_definition.edw_table_definition_dwid AND primary_child_field_definition.key_field_flag = TRUE
WHERE
        parent_join_tree_definition.root_join_dwid = %s
'''
        return self.execute_parameterized_query(query, (root_join_dwid))

    def get_table_list_from_edw_table_definition(self, schema_name) -> list:
        query = '''SELECT
                        edw_table_definition.dwid
                        , edw_table_definition.database_name
                        , edw_table_definition.schema_name
                        , edw_table_definition.table_name
                        , edw_table_definition.primary_source_edw_table_definition_dwid
                    FROM
                        mdi.edw_table_definition
                    WHERE
                        schema_name = %s
                    ORDER BY
                        table_name ASC;'''
        return self.execute_parameterized_query(query, (schema_name))

    def get_field_list_from_edw_field_definition(self, edw_table_definition_dwid: int) -> list:
        """
        This returns all data needed to create a table-to-table/table-to-table-json MDI process.

        :param edw_table_definition_dwid: int, the primary key of the table definition row
        :return: a list of RealDict objects
        table_input_field_source_calculation, has_table_output_edw_join_tree_definition, join_type, join_condition, table_output_database_name, table_output_schema_name, table_output_table_name,
        table_output_field_name, table_output_field_name, table_output_key_field_flag
        """

        query = '''SELECT
    CASE WHEN source_field.source_edw_field_definition_dwid IS NULL THEN 0 ELSE 1 END as has_table_input_source_definition
    , CASE WHEN target_field.field_name in ('dwid','data_source_dwid','data_source_integration_columns','data_source_integration_id','data_source_modified_datetime','edw_created_datetime', 'edw_modified_datetime', 'etl_batch_id') THEN 1 ELSE 0 END as is_edw_standard_field
    , source_table.database_name as table_input_database_name
    , coalesce(source_table.schema_name, target_source_table.schema_name) as table_input_schema_name
    , coalesce(source_table.table_name, target_source_table.table_name) as table_input_table_name
    , coalesce(source_table.dwid, target_source_table.dwid) as table_input_edw_table_definition_dwid
    , source_field.key_field_flag as table_input_key_field_flag
    , COALESCE((SELECT edw_field_definition.field_name FROM mdi.edw_field_definition where edw_field_definition.key_field_flag=TRUE and edw_field_definition.edw_table_definition_dwid = source_table.dwid limit 1),
               (SELECT edw_field_definition.field_name FROM mdi.edw_field_definition where edw_field_definition.key_field_flag=TRUE and edw_field_definition.edw_table_definition_dwid = target_source_table.dwid limit 1))  as primary_source_key_field_name
    , (select primary_table_field.field_name from mdi.edw_field_definition primary_table_field
       where primary_table_field.key_field_flag = true
           and primary_table_field.edw_table_definition_dwid = target_table.primary_source_edw_table_definition_dwid and primary_table_field.field_name like '%%_pid' limit 1) as source_table_key_field_name
    , (select primary_table_field.field_name from mdi.edw_field_definition primary_table_field
       where primary_table_field.edw_table_definition_dwid = target_table.primary_source_edw_table_definition_dwid and primary_table_field.field_name like '%%_version' limit 1) as source_table_version_field_name
    , (SELECT edw_field_definition.field_name FROM mdi.edw_field_definition where edw_field_definition.key_field_flag=TRUE and edw_field_definition.edw_table_definition_dwid = coalesce(source_table.dwid, target_source_table.dwid) limit 1) as primary_source_key_field_name
    , source_field.field_name as table_input_field_name
    , source_field.field_source_calculation as table_input_field_source_calculation
    , source_field.dwid as table_input_edw_field_definition_dwid

    , initial_join_definition.join_type
    , initial_join_definition.join_condition
    , initial_join_definition.dwid as join_alias
    , child_join_definition.join_type as child_join_type
    , child_join_definition.join_condition as child_join_condition
    , child_join_definition.dwid as child_join_alias

    , primary_source_table.table_name as primary_source_table_name
    , primary_source_table.schema_name as primary_source_schema_name
    , target_field.field_source_calculation as insert_update_field_source_calculation

    , CASE WHEN target_field.source_edw_join_tree_definition_dwid IS NULL THEN 0 ELSE 1 END as has_insert_update_edw_join_tree_definition

    , target_table.primary_source_edw_table_definition_dwid
    , target_table.database_name as insert_update_database_name
    , target_table.schema_name as insert_update_schema_name
    , target_table.table_name as insert_update_table_name
    , target_field.field_name as insert_update_field_name
    , target_field.key_field_flag as insert_update_key_field_flag
    , target_field.reporting_key_flag as json_output_key_field

FROM
    mdi.edw_table_definition target_table
        JOIN mdi.edw_field_definition target_field ON target_table.dwid = target_field.edw_table_definition_dwid
        JOIN mdi.edw_table_definition primary_source_table ON target_table.primary_source_edw_table_definition_dwid = primary_source_table.dwid
        LEFT JOIN mdi.edw_field_definition source_field ON target_field.source_edw_field_definition_dwid = source_field.dwid
        LEFT JOIN mdi.edw_table_definition source_table ON source_field.edw_table_definition_dwid = source_table.dwid
        LEFT JOIN mdi.edw_join_tree_definition initial_join_tree ON target_field.source_edw_join_tree_definition_dwid = initial_join_tree.dwid
        LEFT JOIN mdi.edw_join_definition initial_join_definition ON initial_join_tree.root_join_dwid = initial_join_definition.dwid
        LEFT JOIN mdi.edw_table_definition target_source_table ON initial_join_definition.target_edw_table_definition_dwid = target_source_table.dwid
        LEFT JOIN mdi.edw_join_tree_definition child_join_tree ON initial_join_tree.child_join_tree_dwid = child_join_tree.dwid
        LEFT JOIN mdi.edw_join_definition child_join_definition ON child_join_tree.root_join_dwid = child_join_definition.dwid
WHERE
    target_table.dwid = %s
    -- AND target_field.field_name not in ('dwid','data_source_dwid','data_source_integration_columns','data_source_integration_id','data_source_modified_datetime','edw_created_datetime', 'edw_modified_datetime', 'etl_batch_id') -- exclude these in the join if the table input field name is null?
ORDER BY
    table_input_edw_field_definition_dwid ASC;'''

        return self.execute_parameterized_query(query, edw_table_definition_dwid)

    def get_all_staging_tables(self, schema):
        # returns a list of RealDict objects
        #   if table has a primary key - [(name of table, key field name, version field name)]
        #   if table is a 'type' table - [(name of table, code field name, null)]
        rows = self.execute_select_query(f'''
        SELECT t.relname AS name, a.attname as key_field, version.attname as version_field
        FROM pg_class t
         join pg_index ix on t.oid = ix.indrelid
         join pg_class i on i.oid = ix.indexrelid
         join pg_attribute a on a.attrelid = t.oid and a.attnum = ANY(ix.indkey)
         join pg_namespace on t.relnamespace = pg_namespace.oid
         join pg_attribute version on version.attrelid = t.oid AND version.attname = left(a.attname, length(a.attname)-3)||'version'
        WHERE pg_namespace.nspname = 'staging_octane'
          and t.relkind = 'r'
          and (i.relname like '%_pkey' OR i.relname like 'pk_%')
         -- 371
        union all
        select tables.table_name as name, 'code' as key_field, null as version_field
        from information_schema.tables
        join information_schema.columns col1 on tables.table_name = col1.table_name and tables.table_schema = col1.table_schema and col1.column_name = 'code'
        join information_schema.columns col2 on tables.table_name = col2.table_name and tables.table_schema = col2.table_schema and col2.column_name = 'value'
        where tables.table_name like '%type'
            and tables.table_schema = 'staging_octane'
        --425 (2 of these have 3 columns each)
        ;
        ''', 'staging')
        return rows

    def get_all_table_fields(self, schema, table):
        columns = []
        rows = self.execute_select_query(f'''
            SELECT columns.column_name
            FROM information_schema.columns
            WHERE columns.table_schema = '{schema}'
                AND columns.table_name = '{table}'
            ;''', 'staging')
        for row in rows:
            columns.append(row[0])
        return columns

    def get_state_machine_step_from_process_dwid(self, process_dwid: int) -> list:
        query = '''SELECT
    state_machine_step.process_dwid
     , state_machine_step.next_process_dwid
FROM
    mdi.state_machine_step
WHERE
    process_dwid = %s
;'''
        return self.execute_parameterized_query(query, (process_dwid))


class ETL_creator():
    def __init__(self, field_metadata: list, process_name: str, edw_connection: EDW, insert_update_table_name: str,
                 edw_table_definition_dwid: int, table_input_step_connection: str = "Staging DB Connection",
                 insert_update_step_connection: str = "Staging DB Connection",
                 table_input_step_data_source_dwid: int = 0, insert_update_commit_size: int = 1000):
        """
        Used to create ETL configurations for dimensions

        :param field_metadata: A list of fields needed to create an ETL. Pass in results from EDW.get_table_list_from_edw_table_definition()
        :param process_name: The name used to populate config.mdi.process.name
        :param edw_connection: An instance of an EDW object that can be used for queries
        :param insert_update_table_name: The name of the table that data will be insert/updated into
        :param table_input_step_connection: The name of the connection the Table Input step in Pentaho will use to select data
        :param insert_update_step_connection: The name of the connection the Insert/Update step in Pentaho will use insert or update data into
        :param table_input_step_data_source_dwid: The data_source_dwid value to use in the SP's configuration
        :param insert_update_commit_size: The number of rows to process before committing a change
        """

        if len(field_metadata) == 0:
            raise(ValueError("field_metadata should contain at least one item in the list"))

        self.edw_table_definition_dwid = edw_table_definition_dwid

        # table: table_input_step/field and insert_update step/field/key
        self.field_metadata = field_metadata
        self.edw_connection = edw_connection
        self.table_input_step_connection = table_input_step_connection
        self.table_input_step_data_source_dwid = table_input_step_data_source_dwid   # star_common.data_source=1 (Octane)

        self.insert_update_step_connection = insert_update_step_connection
        self.insert_update_table_name = insert_update_table_name
        self.insert_update_schema_name = field_metadata[0]["insert_update_schema_name"]
        self.insert_update_table_name = field_metadata[0]["insert_update_table_name"]
        self.insert_update_commit_size = insert_update_commit_size

        # table: process
        self.process_name = process_name
        self.process_description = f"Dimension ETL to populate {self.insert_update_table_name} from history_octane"

        self.indent = "    "

    def create_table_input_sql(self) -> str:
        # this is used to alias the primary table and child join sub queries
        default_table_name = "primary_table"

        # create the FROM clause and main/primary table
        output_from_clause = f'''FROM (      
{self.indent}SELECT
{self.create_include_record_select_sql(self.field_metadata[0]["primary_source_table_name"], 2)},
{self.indent*2}current_record.*
{self.indent}FROM {self.field_metadata[0]["primary_source_schema_name"]}.{self.field_metadata[0]["primary_source_table_name"]} current_record
{self.indent*2}LEFT JOIN {self.field_metadata[0]["primary_source_schema_name"]}.{self.field_metadata[0]["primary_source_table_name"]} AS history_records ON current_record.{self.field_metadata[0]["source_table_key_field_name"]} = history_records.{self.field_metadata[0]["source_table_key_field_name"]}
{self.indent*3}AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
{self.indent}WHERE history_records.{self.field_metadata[0]["source_table_key_field_name"]} IS NULL
{self.indent}) AS {default_table_name}
'''
        output_where_clause = f'''WHERE
{self.indent}GREATEST(primary_table.include_record'''

        # create join sql
        output_join_sql = ""
        processed_join_dwids = []
        # add joins
        for field_definition in self.field_metadata:
            if field_definition["join_type"] is None:
                continue  # there is no join to process so skip to the next field_definition

            if field_definition["join_alias"] not in processed_join_dwids:
                # determine if we need a null outer join or inner join
                if field_definition["table_input_database_name"] == "staging" and field_definition["table_input_schema_name"] == "star_loan":
                    output_join_sql += self.create_non_history_octane_join_sql(field_definition)
                else:
                    output_join_sql += self.create_history_octane_join_sql(field_definition)
                output_where_clause += f', t{field_definition["join_alias"]}.include_record'
                processed_join_dwids.append(field_definition["join_alias"])
            else:
                output_join_sql += f'''{self.indent*2}-- ignoring this because the table alias t{field_definition["join_alias"]} has already been added: {field_definition["join_type"].upper()} JOIN {field_definition["table_input_schema_name"]}.{field_definition["table_input_table_name"]} t{field_definition["join_alias"]} ON {field_definition["join_condition"]}  
'''

        output_where_clause += ''') IS TRUE
'''

        # create select clause with list of fields
        output_select_clause = ""

        line_suffix = ''',
'''

        for field_definition in self.field_metadata:

            if field_definition["table_input_edw_table_definition_dwid"] == field_definition["primary_source_edw_table_definition_dwid"]:
                table_name = f"primary_table"
            else:
                table_name = f'''t{field_definition["join_alias"]}'''

            if field_definition["insert_update_field_source_calculation"] is None:

                # this is not a calculated field so if there is a source definition add the column to the select clause
                # otherwise it is an edw standard field that shouldn't be added (yet)
                if field_definition["has_table_input_source_definition"] == 1:
                    output_select_clause += f'''{self.indent*2}{table_name}.{field_definition["table_input_field_name"]} as {field_definition["insert_update_field_name"]}{line_suffix}'''
                else:
                    if field_definition["table_input_schema_name"] == "star_loan" and field_definition["table_input_database_name"] == "staging":
                        output_select_clause += f'''{self.indent*2}{table_name}.{field_definition["table_input_field_name"]} as {field_definition["insert_update_field_name"]}{line_suffix}'''
                    elif field_definition["is_edw_standard_field"] is False:
                        output_select_clause += f'''-- skipping this row because has_table_input_source_definition != 0:         {self.indent*2}{table_name}.{field_definition["table_input_field_name"]} as {field_definition["insert_update_field_name"]}{line_suffix}'''
                    elif field_definition["table_input_schema_name"] == None:  # standard fields have null table input fields
                        continue
                    else:
                        print(f'''field_definition['table_input_schema_name'] has the value of {field_definition['table_input_schema_name']}''')
                        raise ValueError("expected field_definition['table_input_schema_name'] to be history_octane or star_loan. Unexpected value found.")

            else:
                output_select_clause += f'''{self.indent*2}{field_definition["insert_update_field_source_calculation"].replace("'", "''")} as {field_definition["insert_update_field_name"]}{line_suffix}'''

        output_edw_standard_fields = self.create_edw_standard_fields_sql()

        # remove the trailing comma
        output_select_clause = f'''{output_select_clause[:len(output_select_clause) - 2]}
'''

        output_select_clause = f'''SELECT
{self.indent}{output_edw_standard_fields}{output_select_clause}'''

        output_order_by_statement = f'''ORDER BY
{self.indent}primary_table.data_source_updated_datetime ASC
'''
        statement_terminator = ";"

        output_sql_statement = f"{output_select_clause} {output_from_clause} {output_join_sql} {output_where_clause} {output_order_by_statement} {statement_terminator}"

        return output_sql_statement

    def create_edw_standard_fields_sql(self) -> str:
        """
        Returns a string that adds EDW's standard fields. Used to add the standard fields to the Table Input step's SQL

        :return: string that can be appended to the beginning of a SELECT statement (includes trailing comma)
        """
        output_edw_standard_fields = f'''{self.indent}{self.create_data_source_integration_columns_select_sql()},
{self.indent*2}{self.create_data_source_integration_id_select_sql()},
{self.indent*2}now() as edw_created_datetime,
{self.indent*2}now() as edw_modified_datetime,
{self.indent*2}primary_table.data_source_updated_datetime as data_source_modified_datetime,
'''
        return output_edw_standard_fields

    def create_data_source_dwid_select_sql(self, data_source_dwid_value: int) -> str:
        """
        Creates a string that can be added to a SELECT clause that contains the column data_source_dwid (no trailing comma included)

        :param data_source_dwid_value:
        :return: string that can be appended to a SELECT statement (no trailing comma)
        """
        return f"{data_source_dwid_value} as data_source_dwid"

    def create_data_source_integration_columns_select_sql(self) -> str:
        """
        Uses self.field_metadata list to create a string used to define the data_source_integration_columns field on the Table Input step SQL

        :return: a string that can be used in a select statement (no trailing comma)
        """
        output_select_clause = ""
        value_delimiter = " || ''~'' || "
        for field_definition in self.field_metadata:
            if field_definition["insert_update_key_field_flag"] is True:  # only process key fields
                output_select_clause += f'''\'\'{field_definition["insert_update_field_name"]}\'\'{value_delimiter}'''

        # remove the trailing value_delimiter string
        output_select_clause = output_select_clause[:len(output_select_clause)-len(value_delimiter)]

        return f"{output_select_clause} as data_source_integration_columns"

    def create_data_source_integration_id_select_sql(self) -> str:
        """
        used to create the data_source_integration_id field used in a select statement. contains the values of the key fields ordered by their edw_field_definition.dwid value

        :return: a string that can be appended to a select clause (no trailing comma)
        """
        output_select_clause = ""
        value_delimiter = " || ''~'' || "   # we need to use || instead of the CONCAT() function because there is a 100 parameter limit for functions in our install of postgresql
        # see "max_function_args (integer)" section of https://www.postgresql.org/docs/9.1/runtime-config-preset.html

        for field_definition in self.field_metadata:
            if field_definition["insert_update_key_field_flag"] is False:  # only process key fields
                continue
            else:
                # determine if the field is pulled from the primary table or not
                if field_definition["table_input_edw_table_definition_dwid"] == field_definition["primary_source_edw_table_definition_dwid"]:  # field is in the primary table
                    table_name = f"primary_table"
                else:  # field is not in the primary table so needs to be pulled from the aliased table from the join clause
                    table_name = f'''t{field_definition["join_alias"]}'''

                if field_definition["is_edw_standard_field"] == 1:  # process standard fields
                    output_select_clause += f'''CAST({self.table_input_step_data_source_dwid} as text) {value_delimiter}'''
                elif field_definition["insert_update_field_source_calculation"] is None:  # process non calculated fields
                    output_select_clause += f'''CAST({table_name}.{field_definition["table_input_field_name"]} as text) {value_delimiter}'''
                else:  # process calculated fields
                    # we're casting all of the calculated fields so they can be concatenated with || in postgresql
                    output_select_clause += f'''CAST({field_definition["insert_update_field_source_calculation"].replace("'", "''")} as text){value_delimiter}'''

        # remove the trailing value_delimiter string before appending the closing parenthesis for the CONCAT() function
        output_select_clause = output_select_clause[:len(output_select_clause)-len(value_delimiter)]
        output_select_clause += " as data_source_integration_id"
        return output_select_clause

    def create_non_history_octane_join_sql(self, field_definition: dict) -> str:
        output_join_sql = f'''
{self.indent}{field_definition["join_type"].upper()} JOIN (
{self.indent*2}SELECT
{self.indent*3}{self.create_include_record_select_sql(field_definition["table_input_table_name"])},
{self.indent*3}{field_definition["table_input_table_name"]}.*
{self.indent*2}FROM {field_definition["table_input_schema_name"]}.{field_definition["table_input_table_name"]}
{self.indent}) AS t{field_definition["join_alias"]} ON {field_definition["join_condition"]}
'''
        return output_join_sql

    def create_history_octane_join_sql(self, field_definition: dict) -> str:
        """
        Used to create a join statement that can also contain a child join

        :param field_definition: One row from the list self.field_metadata
        :return: returns a string that can be added to a SQL statement
        """

        child_join_needed = self.has_child_join(field_definition)
        child_join_sql = ""
        include_record_join_sql = f'''{self.create_include_record_select_sql(field_definition["table_input_table_name"])},'''

        if child_join_needed is True:
            child_join_sql = self.create_child_join_sql(field_definition["join_alias"])
            include_record_join_sql = ""

        output_join_sql = f'''
{self.indent}{field_definition["join_type"].upper()} JOIN (
{self.indent*2}SELECT * FROM (
{self.indent*3}SELECT {include_record_join_sql}
{self.indent*3}current_record.*
{self.indent*3}FROM {field_definition["table_input_schema_name"]}.{field_definition["table_input_table_name"]} current_record
{self.indent*4}LEFT JOIN {field_definition["table_input_schema_name"]}.{field_definition["table_input_table_name"]} AS history_records ON current_record.{field_definition["primary_source_key_field_name"]} = history_records.{field_definition["primary_source_key_field_name"]}
{self.indent*4}AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
{self.indent*3}WHERE history_records.{field_definition["primary_source_key_field_name"]} IS NULL
{self.indent*2}) as primary_table
{self.indent*2}{child_join_sql}
{self.indent}) AS t{field_definition["join_alias"]} ON {field_definition["join_condition"]}
'''
        return output_join_sql

    def create_include_record_select_sql(self,  partial_load_source_table: str, starting_indent_level: int = 1, add_newline_suffix: bool = False):
        if add_newline_suffix is False:
            suffix = ''
        else:
            suffix = '''
'''

        output = f'''{self.indent*starting_indent_level}<<{partial_load_source_table}_partial_load_condition>> as include_record{suffix}'''
        return output

    def create_child_join_sql(self, edw_join_definition_dwid: int, starting_indent_level: int = 4) -> str:
        # get the join details from the DB
        child_join_details = EDW().get_child_join_data(edw_join_definition_dwid)
        if len(child_join_details) == 0:
            return ""  # there are no child joins to process, return an empty string
        else:
            child_join_query_template = f'''
{self.indent*starting_indent_level}-- child join start    
{self.indent*starting_indent_level}{child_join_details[0]["join_type"].upper()} JOIN
{self.indent*starting_indent_level}(      
{self.indent*(starting_indent_level + 1)}SELECT
{self.create_include_record_select_sql(child_join_details[0]["target_table_name"], 5)},
{self.indent*(starting_indent_level + 2)}current_record.*
{self.indent*(starting_indent_level + 1)}FROM
{self.indent*(starting_indent_level + 2)}{child_join_details[0]["target_schema_name"]}.{child_join_details[0]["target_table_name"]} current_record
{self.indent*(starting_indent_level + 3)}LEFT JOIN {child_join_details[0]["target_schema_name"]}.{child_join_details[0]["target_table_name"]} AS history_records ON current_record.{child_join_details[0]["target_field_name"]} = history_records.{child_join_details[0]["target_field_name"]}
{self.indent*(starting_indent_level + 4)}AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
{self.indent*(starting_indent_level + 1)}WHERE
{self.indent*(starting_indent_level + 2)}history_records.{child_join_details[0]["target_field_name"]} IS NULL
{self.indent*starting_indent_level}) AS t{child_join_details[0]["child_join_tree_definition_root_join_dwid"]} ON {child_join_details[0]["join_condition"]}
{self.indent*starting_indent_level}-- child join end    
'''
        return child_join_query_template

    def has_child_join(self, field_definition: dict) -> bool:
        """
        Detects if a single row from self.field_metadata's list requires a child join

        :param field_definition: One row from the list self.field_metadata
        :return:
        """
        edw = EDW()
        child_join_data = edw.get_child_join_data(field_definition["join_alias"])

        if len(child_join_data) == 0:
            return False
        elif len(child_join_data) == 1:
            return True
        else:
            print(f'Unexpected error occurred. Expected child_join_data to have 0 or 1 rows but {len(child_join_data)} rows were found for edw_join_definition.dwid={field_definition["join_alias"]}.')
            print(field_definition)
            raise ValueError("Expected child_join_data to have 0 or 1 rows but more than 1 row was found. Script is not written to handle this scenario.")

    def create_table_input_to_insert_update_sql(self) -> str:
        """
        Creates SQL that can be executed against the config database in EDW to add SP configurations.

        :return: a string that contains SQL insert statements
        """

        config_insert = ""
        config_insert += f'''
-- The following statement adds an ETL configuration to populate {self.insert_update_schema_name}.{self.insert_update_table_name} ({self.process_name})

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('{self.process_name}', '{self.process_description}')
    RETURNING dwid)
'''
        table_input_sql = self.create_table_input_sql()

        config_insert += f'''
, temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, {self.table_input_step_data_source_dwid}, '{table_input_sql}', 0, '{self.table_input_step_connection}'
    FROM temp_process
    RETURNING dwid)
'''

        config_insert += f'''
, temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)
'''

        config_insert += f'''
, temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, '{self.insert_update_step_connection}', '{self.insert_update_schema_name}', '{self.insert_update_table_name}', {self.insert_update_commit_size}, 'N'
    FROM temp_process
    RETURNING dwid)
'''

        config_insert += f'''
, temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)
'''

        config_insert += f'''
, temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''

        config_insert += f'''
, temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''

        config_insert += f'''
, temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''

        config_insert += f'''
, temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''

        for index, field_definition in enumerate(self.field_metadata, start=8):
            # ignore fields that do not have source definitions (edw standard fields)
            if field_definition["has_table_input_source_definition"] == 0:
                continue

            #if field_definition["insert_update_key_field_flag"] == 1:
            #    update_flag = "N"
            #else:
            update_flag = "Y"

            config_insert += f'''
, temp_insert_update_field_{index} as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, '{field_definition["insert_update_field_name"]}', '{field_definition["insert_update_field_name"]}', '{update_flag}', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''

        config_insert += '''
, temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)
'''

        seen_table_name_values = []
        for index, field_definition in enumerate(self.field_metadata, start=1):
            # ignore fields that do not have source definitions (edw standard fields)
            if field_definition["is_edw_standard_field"] != 0:
                continue

            if field_definition["table_input_schema_name"] == None or field_definition["table_input_table_name"] == None:
                table_name = field_definition["primary_source_table_name"]
                schema_name = field_definition["primary_source_schema_name"]
            else:
                table_name = field_definition["table_input_table_name"]
                schema_name = field_definition["table_input_schema_name"]

            # if we've already added this table as a state_machine_step then no need to add it again
            if table_name in seen_table_name_values:
                continue

            seen_table_name_values.append(table_name)

            config_insert += f'''
, temp_state_machine_step_insert_{index} as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                table_output_step.target_schema = '{schema_name}'
                AND table_output_step.target_table = '{table_name}'
            UNION
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = '{schema_name}'
                AND insert_update_step.table_name = '{table_name}') as process_dwid   
            , temp_process.dwid as next_process_dwid
    FROM temp_process)
'''

        config_insert += f'''
SELECT 'Done adding MDI configuration for {self.insert_update_schema_name}.{self.insert_update_table_name} ({self.process_name})' as etl_creator_status;

'''
        return config_insert


def main(argv):
    script_name = argv[0]
    argv = argv[1:]

    try:
        opts, args = getopt.getopt(argv, "ht:", ["help", "information_schema"])
    except getopt.GetopsError:
        display_usage(script_name)
        exit(-1)
    for opt, arg in opts:
        if opt in ("-h", "--h", "-help", "--help"):
            display_usage(script_name)
            exit(0)
        elif opt in ("-t", "--t", "-table_definition", "--table_definition"):
            generate_mdi_configs_based_on_table_definition(arg)


def display_usage(script_name: str) -> None:
    print(f'''{script_name} script usage:
    -h      print usage information
    -t <schema name>   create configs based on mdi.edw_table_definition''')


def generate_mdi_configs_based_on_table_definition(schema_name_to_process: str, ) -> None:
    print(f"-- Will create configs for this schema: {schema_name_to_process}")
    print(f"-- Generated at {datetime.now()}")

    edw = EDW(db_name="config")
    table_list = edw.get_table_list_from_edw_table_definition(schema_name_to_process)

    output = ""

    # start at 200003 to leave a few numbers for https://app.asana.com/0/0/1200167382809187/
    for index, table in enumerate(table_list, start=200003):
        edw_table_definition_dwid = table["dwid"]
        database_name = table["database_name"]
        table_name = table["table_name"]

        process_name = f"SP-{index}"

        fields = edw.get_field_list_from_edw_field_definition(edw_table_definition_dwid)
        etl_config = ETL_creator(field_metadata=fields,
                                 process_name=process_name,
                                 edw_connection=EDW(db_name=database_name),
                                 insert_update_table_name=table_name,
                                 table_input_step_data_source_dwid=1,
                                 edw_table_definition_dwid=edw_table_definition_dwid)

        sql_configuration = etl_config.create_table_input_to_insert_update_sql()

        output = f'''{output}

{sql_configuration}'''

        print(sql_configuration)  # output data to screen

    save_output(output)


def save_output(output_data: str, file_name: str = "", file_path: str = "./", file_extension: str = "sql") -> None:
    if file_name == "":  # if no filename defined then use the current date
        file_name = date.today().strftime("%Y%m%d")

    f = open(f"{file_path}{file_name}.{file_extension}", "w")
    f.write(output_data)
    f.close()


if __name__ == "__main__":
    main(sys.argv)