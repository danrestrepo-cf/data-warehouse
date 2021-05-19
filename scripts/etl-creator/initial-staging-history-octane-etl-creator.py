import psycopg2
import psycopg2.extras
from datetime import date
from datetime import datetime
import sys, getopt

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
        '''
        This function connects to the database, executes a query using sanitization, commits any changes, and returns the resultant rows

        :param query: the SQL query to execute. sanitize any variables using '%s'
        :param parameters: a tuple of parameters with one value in the tuple per '%s' in the query
        :return: returns a list of tuples with the data from the rows returned by the query
        '''

        conn = psycopg2.connect(database=self.database_name,
                                user=self.database_username,
                                password=self.database_password,
                                host=self.database_hostname,
                                port=self.database_port)
        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        cur.execute(query, parameters)
        # print(cur.query)
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

    def get_target_field_list_from_edw_field_definition(self, edw_table_definition_dwid: int) -> list:
        '''
        This returns data from the edw_table_definition and edw_field_definition tables.

        :param edw_table_definition_dwid: int, the primary key of the table definition row
        :return: a list of tuples in the format [(database_name, schema_name, table_name, field_name, key_field_flag)]
        '''

        query = '''SELECT
                        edw_table_definition.database_name
                        , edw_table_definition.schema_name
                        , edw_table_definition.table_name
                        , edw_field_definition.field_name
                        , edw_field_definition.key_field_flag
                    FROM
                        mdi.edw_table_definition
                        JOIN mdi.edw_field_definition on edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                    WHERE
                        edw_table_definition.dwid = %s
                    ORDER BY
                        edw_field_definition.key_field_flag DESC
                        , edw_field_definition.field_name ASC
                    ;'''
        return self.execute_parameterized_query(query, edw_table_definition_dwid)

    def get_field_list_from_edw_field_definition(self, edw_table_definition_dwid: int) -> list:
        '''
        This returns all data needed to create a table-to-table/table-to-table-json MDI process. * Only supports root_join_dwids currently! *

        :param edw_table_definition_dwid: int, the primary key of the table definition row
        :return: a list of tuples in the format [(table_input_database_name, table_input_schema_name, table_input_table_name, table_input_field_name, table_output_field_source_calculation
        table_input_field_source_calculation, has_table_output_edw_join_tree_definition, join_type, join_condition, table_output_database_name, table_output_schema_name, table_output_table_name,
        table_output_field_name, table_output_field_name, table_output_key_field_flag
        '''

        query = '''SELECT
    CASE WHEN source_field.source_edw_field_definition_dwid IS NULL THEN 0 ELSE 1 END as has_table_input_source_definition
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
--         LEFT JOIN mdi.edw_table_definition calculated_field_source_table ON initial_join_definition.target_edw_table_definition_dwid = source_table.dwid
--         LEFT JOIN mdi.edw_field_definition calculated_field_source_field ON target_field.source_edw_field_definition_dwid = source_field.dwid

        LEFT JOIN mdi.edw_join_tree_definition child_join_tree ON initial_join_tree.child_join_tree_dwid = child_join_tree.dwid
        LEFT JOIN mdi.edw_join_definition child_join_definition ON child_join_tree.root_join_dwid = child_join_definition.dwid
        
WHERE
    target_table.dwid = %s
    AND target_field.field_name not in ('dwid','data_source_dwid','data_source_integration_columns','data_source_integration_id','data_source_modified_datetime','edw_created_datetime', 'edw_modified_datetime', 'etl_batch_id') -- exclude these in the join if the table input field name is null?
ORDER BY
    table_input_edw_field_definition_dwid ASC;'''

        return self.execute_parameterized_query(query, edw_table_definition_dwid)

    def get_all_staging_tables(self, schema):
        # returns a list of 3-tuples
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
            ;
		''', 'staging')
        for row in rows:
            columns.append(row[0])
        return columns


class ETL_config:
    process_name = ""
    process_description = ""
    table_input_step_sql = ""
    table_input_step_connection = ""
    table_output_step_schema = ""
    table_output_step_table = ""
    table_output_step_connection = ""
    table_output_step_fields = []
    json_output_step_field = ""
    staging_connection = ""
    state_machine_name = ""
    state_machine_comment = ""

    process_dwid = ""
    table_input_step_dwid = ""
    table_output_step_dwid = ""
    json_output_field_dwid = ""

    process_insert = ""
    table_input_step_insert = ""
    table_output_step_insert = ""
    table_output_field_steps = ""

    def __init__ (self
                  , process_name: str
                  , process_description: str
                  , table_input_step_connection: str
                  , table_input_step_sql: str
                  , table_output_step_connection: str
                  , table_output_step_schema: str
                  , table_output_step_table: str
                  , table_output_step_fields: list
                  , json_output_step_field: str
                  , staging_connection: str
                  , state_machine_name: str
                  , state_machine_comment: str):
        self.process_name = process_name
        self.process_description = process_description
        self.table_input_step_connection = table_input_step_connection
        self.table_input_step_sql = table_input_step_sql
        self.table_output_step_connection = table_output_step_connection
        self.table_output_step_schema = table_output_step_schema
        self.table_output_step_table = table_output_step_table
        self.table_output_step_fields = table_output_step_fields
        self.json_output_step_field = json_output_step_field
        self.staging_connection = staging_connection
        self.state_machine_name = state_machine_name
        self.state_machine_comment = state_machine_comment

    def create_config_insert_statements(self):
        config_insert = ""
        config_insert += f'''
            -- The following statement adds a configuration for '{self.table_output_step_table}'
            with temp_process as (INSERT INTO mdi.process (name, description) 
                VALUES ('{self.process_name}', '{self.process_description}')
                RETURNING dwid 
            )'''
        config_insert += f'''
            , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname) 
                select temp_process.dwid, 0, '{self.table_input_step_sql}', 0, '{self.table_input_step_connection}'
                from temp_process
                RETURNING dwid 
            )'''
        config_insert += f'''
            , temp_table_output_step as (INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, 
                table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update) 
                SELECT temp_process.dwid, '{self.table_output_step_schema}', '{self.table_output_step_table}', 1000, NULL, NULL, NULL, NULL
                , 'N', NULL, 'N', '{self.table_output_step_connection}', 'N', 'Y', 'N', 'N'
                FROM temp_process
                RETURNING dwid
            )'''
        self.table_output_step_fields.append('data_source_updated_datetime')
        self.table_output_step_fields.append('data_source_deleted_flag')
        config_insert +=  f'''
            , temp_table_output_field as (INSERT INTO mdi.table_output_field (
                table_output_step_dwid, database_field_name, database_stream_name, field_order, 
                is_sensitive 
                ) '''
        config_insert_field = []
        for i, field in enumerate(self.table_output_step_fields):
                config_insert_field.append( f'''     
                    SELECT temp_table_output_step.dwid, '{field}', '{field}', {i}, False
                    from temp_table_output_step
                ''')
        config_insert += ' UNION ALL '.join(config_insert_field)
        config_insert += ')'
        config_insert += f'''
            , temp_json_output as (INSERT INTO mdi.json_output_field (process_dwid, field_name) 
                select temp_process.dwid, '{self.json_output_step_field}'
                from temp_process)'''

        config_insert += f'''
            , temp_state_machine_definition as (INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
                SELECT temp_process.dwid, '{self.state_machine_name}', '{self.state_machine_comment}'
                from temp_process)'''

        config_insert += f'''
            INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)
                SELECT temp_process.dwid, NULL
                from temp_process;

            '''
        return config_insert


class Staging_to_History_ETL(ETL_config):
    def __init__(self, staging_table_metadata, process_name, staging_connection):
        self.staging_table_metadata = staging_table_metadata
        self.staging_table_name = self.staging_table_metadata[0]
        self.process_name = process_name
        self.main_pid = self.staging_table_metadata[1]
        self.version_pid = self.staging_table_metadata[2]
        self.process_description = f'ETL to copy {self.staging_table_name} data from staging_octane to history_octane'
        self.table_input_step_connection = 'Staging DB Connection'
        self.table_output_step_fields = staging_connection.get_all_table_fields("staging_octane", self.staging_table_name)
        if self.version_pid is None:
            join_condition = ""
            for i, field in enumerate(self.table_output_step_fields):
                if(i>0):
                    join_condition +=' AND '
                join_condition +='staging_table.'+field+' = history_table.'+field
            self.table_input_step_sql = f'''
            SELECT staging_table.{', staging_table.'.join(self.table_output_step_fields)}, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.{self.staging_table_name} staging_table
            LEFT JOIN history_octane.{self.staging_table_name} history_table on {join_condition}
            WHERE history_table.{self.main_pid} is NULL
            '''
        else:
            list_of_fields = ""
            for i, field in enumerate(self.table_output_step_fields):
                if(i>0):
                    list_of_fields +=', '
                list_of_fields += 'history_table.'+field
                if(field==self.version_pid):
                    list_of_fields += '+1'
            self.table_input_step_sql = f'''
            --finding records to insert into hitory_octane.{self.staging_table_name}
            SELECT staging_table.{', staging_table.'.join(self.table_output_step_fields)}, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.{self.staging_table_name} staging_table
            LEFT JOIN history_octane.{self.staging_table_name} history_table on staging_table.{self.main_pid} = history_table.{self.main_pid} and staging_table.{self.version_pid} = history_table.{self.version_pid}
            WHERE history_table.{self.main_pid} is NULL
            UNION ALL
            SELECT {list_of_fields}, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM history_octane.{self.staging_table_name} history_table
            LEFT JOIN staging_octane.{self.staging_table_name} staging_table on staging_table.{self.main_pid} = history_table.{self.main_pid}
            WHERE staging_table.{self.main_pid} is NULL
                AND not exists (select 1 from history_octane.{self.staging_table_name} deleted_records where deleted_records.{self.main_pid} = history_table.{self.main_pid} and deleted_records.data_source_deleted_flag = True)
            '''
        self.table_output_step_connection = 'Staging DB Connection'
        self.table_output_step_schema = "history_octane"
        self.table_output_step_table = self.staging_table_name
        self.staging_connection = staging_connection
        self.json_output_step_field = self.main_pid
        self.state_machine_name = f'Octane {self.staging_table_name}'
        self.state_machine_comment = self.process_description
        super().__init__(self.process_name
                         , self.process_description
                         , self.table_input_step_connection
                         , self.table_input_step_sql
                         , self.table_output_step_connection
                         , self.table_output_step_schema
                         , self.table_output_step_table
                         , self.table_output_step_fields
                         , self.json_output_step_field
                         , self.staging_connection
                         , self.state_machine_name
                         , self.state_machine_comment)


class DimensionETLCreator():
    def __init__(self, field_metadata: list, process_name: str, edw_connection: EDW, insert_update_table_name: str,
                 edw_table_definition_dwid: int, table_input_step_connection: str = "Staging DB Connection",
                 insert_update_step_connection: str = "Staging DB Connection",
                 table_input_step_data_source_dwid: int = 0, insert_update_commit_size: int = 1000):
        '''
        Used to create ETL configurations for dimensions

        :param field_metadata:
        :param process_name:
        :param edw_connection:
        :param insert_update_table_name:
        :param table_input_sql:
        :param table_input_step_connection:
        :param insert_update_step_connection:
        :param table_input_step_data_source_dwid:
        :param insert_update_commit_size:
        '''
        if len(field_metadata) == 0:
            raise(ValueError("table_metadata should contain at least one item in the list"))

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
        # from json import dumps
        # print(len(self.field_metadata))
        # print(len(self.field_metadata)+6)
        # print(dumps(self.field_metadata,indent=4))
        number_of_rows_returned = len(self.field_metadata)

        # this is used to alias the primary table and child join sub queries
        default_table_name = "primary_table"

        # create the FROM clause and main/primary table
        output_from_clause = f'''FROM 
     (select * from
         (select row_number() over (partition by {self.field_metadata[0]["source_table_key_field_name"]} order by data_source_updated_datetime DESC) as row_number,*
          from
              {self.field_metadata[0]["primary_source_schema_name"]}.{self.field_metadata[0]["primary_source_table_name"]}
         ) as t
      where t.row_number = 1) AS {default_table_name}
'''

        # create join sql
        output_join_sql = ""
        processed_join_dwids = []
        # add joins
        for field_definition in self.field_metadata:
            if field_definition["join_type"] is None:
                continue # there is no join to process so skip to the next field_definition

            if field_definition["join_alias"] not in processed_join_dwids:
                output_join_sql += self.create_join_sql(field_definition)
                processed_join_dwids.append(field_definition["join_alias"])
            else:
                output_join_sql += f'''{self.indent*2}-- ignoring this because the table alias t{field_definition["join_alias"]} has already been added: {field_definition["join_type"].upper()} JOIN {field_definition["table_input_schema_name"]}.{field_definition["table_input_table_name"]} t{field_definition["join_alias"]} ON {field_definition["join_condition"]}  
'''

        # create select clause with list of fields
        output_select_clause = ""
        for index, field_definition in enumerate(self.field_metadata, start=1):
            # if this is not the last field definition then put a comma at the end of the sql being added
            if index != number_of_rows_returned:
                line_suffix = f''',
'''
            else:
                line_suffix = f'''
'''

            if field_definition["insert_update_field_source_calculation"] is None:

                if field_definition["table_input_edw_table_definition_dwid"] == field_definition["primary_source_edw_table_definition_dwid"]:
                    table_name = f"primary_table"
                else:
                    table_name = f'''t{field_definition["join_alias"]}'''

                # this is not a calculated field so if there is a source definition add the column to the select clause
                # otherwise it is an edw standard field that shouldn't be added (yet)
                if field_definition["has_table_input_source_definition"] == 1:
                    output_select_clause += f'''{self.indent*2}{table_name}.{field_definition["table_input_field_name"]} as {field_definition["insert_update_field_name"]}{line_suffix}'''
                else:
                    output_select_clause += f'''-- skipping this row because has_table_input_source_definition != 0:         {self.indent*2}{table_name}.{field_definition["table_input_field_name"]} as {field_definition["insert_update_field_name"]}{line_suffix}'''

            else:
                output_select_clause += f'''{self.indent*2}{field_definition["insert_update_field_source_calculation"].replace("'", "''")}{line_suffix}'''

        output_edw_standard_fields = self.create_edw_standard_fields_sql()

        output_select_clause = f'''SELECT
{self.indent}{output_edw_standard_fields}{output_select_clause}'''

        order_by_statement = f'''ORDER BY
{self.indent}primary_table.data_source_updated_datetime ASC
'''
        statement_terminator = ";"

        output_sql_statement = f"{output_select_clause} {output_from_clause} {output_join_sql} {order_by_statement} {statement_terminator}"

        return output_sql_statement

    def create_edw_standard_fields_sql(self) -> str:
        output_edw_standard_fields = f'''{self.indent}{self.create_data_source_dwid_select_sql(data_source_dwid_value = 0)},
{self.indent*2}{self.create_data_source_integration_columns_select_sql()},
{self.indent*2}{self.create_data_source_integration_id_select_sql()},
{self.indent*2}now() as edw_created_datetime,
{self.indent*2}now() as edw_modified_datetime,
{self.indent*2}primary_table.data_source_updated_datetime as data_source_modified_datetime,
'''
        return output_edw_standard_fields

    def create_data_source_dwid_select_sql(self, data_source_dwid_value: int) -> str:
        return f"{data_source_dwid_value} as data_source_dwid"

    def create_data_source_integration_columns_select_sql(self) -> str:
        output_select_clause = ""
        value_delimiter = " || ''~'' || "
        for field_definition in self.field_metadata:
            if field_definition["insert_update_key_field_flag"] == True:  # only process key fields
                if field_definition["insert_update_field_source_calculation"] is None:  # process non calculated fields

                    # determine if the field is pulled from the primary table or not
                    if field_definition["table_input_edw_table_definition_dwid"] == field_definition["primary_source_edw_table_definition_dwid"]:  # field is in the primary table
                        table_name = f"primary_table"
                    else:  # field is not in the primary table so needs to be pulled from the aliased table from the join clause
                        table_name = f'''t{field_definition["join_alias"]}'''

                    if field_definition["has_table_input_source_definition"] == 1:  # don't process edw standard fields
                        output_select_clause += f'''\'\'{table_name}.{field_definition["table_input_field_name"]}\'\'{value_delimiter}'''
                else:  # process calculated fields
                    output_select_clause += f'''\'\'{field_definition["insert_update_field_source_calculation"].replace("'", "''")}\'\'{value_delimiter}'''

        # remove the trailing value_delimiter string before appending the closing parenthesis for the CONCAT() function
        output_select_clause = output_select_clause[:len(output_select_clause)-len(value_delimiter)]

        return f"{output_select_clause} as data_source_integration_columns"

    def create_data_source_integration_id_select_sql(self) -> str:
        output_select_clause = ""
        value_delimiter = " || ''~'' || "   # we need to use || instead of the CONCAT() function because there is a 100 parameter limit for functions in our install of postgresql
                                            # see "max_function_args (integer)" section of https://www.postgresql.org/docs/9.1/runtime-config-preset.html

        for field_definition in self.field_metadata:
            if field_definition["insert_update_key_field_flag"] == True:  # only process key fields
                if field_definition["insert_update_field_source_calculation"] is None:  # process non calculated fields

                    # determine if the field is pulled from the primary table or not
                    if field_definition["table_input_edw_table_definition_dwid"] == field_definition["primary_source_edw_table_definition_dwid"]:  # field is in the primary table
                        table_name = f"primary_table"
                    else:  # field is not in the primary table so needs to be pulled from the aliased table from the join clause
                        table_name = f'''t{field_definition["join_alias"]}'''

                    if field_definition["has_table_input_source_definition"] == 1:  # don't process edw standard fields
                        output_select_clause += f'''{table_name}.{field_definition["table_input_field_name"]}{value_delimiter}'''
                else:  # process calculated fields
                    if "case" in field_definition["insert_update_field_source_calculation"].lower():  # detect if we need to cast the field calculation to text or not
                        output_select_clause += f'''{field_definition["insert_update_field_source_calculation"].replace("'", "''")}{value_delimiter}'''
                    else:
                        output_select_clause += f'''CAST({field_definition["insert_update_field_source_calculation"].replace("'", "''")} as text){value_delimiter}'''

        # remove the trailing value_delimiter string before appending the closing parenthesis for the CONCAT() function
        output_select_clause = output_select_clause[:len(output_select_clause)-len(value_delimiter)]
        output_select_clause += " as data_source_integration_id"
        return output_select_clause

    def create_join_sql(self, field_definition: dict) -> str:
        child_join_needed = self.has_child_join(field_definition)
        child_join_sql = ""

        if child_join_needed == True:
            child_join_sql = self.create_child_join_sql(field_definition["join_alias"])

        output_join_sql = f'''  -- join start
        {field_definition["join_type"].upper()} JOIN
            (
                select
                    *
                from
                    (
                        SELECT
                            row_number() OVER (PARTITION BY {field_definition["primary_source_key_field_name"]} ORDER BY data_source_updated_datetime DESC) AS row_num
                            , *
                        FROM
                            {field_definition["table_input_schema_name"]}.{field_definition["table_input_table_name"]}
                    ) AS primary_table
                    [[REPLACE_WITH_CHILD_JOIN_SQL_OR_BLANK_STRING]]
                WHERE
                    row_num=1

            ) AS t{field_definition["join_alias"]} ON {field_definition["join_condition"]}
    -- join end

'''.replace("[[REPLACE_WITH_CHILD_JOIN_SQL_OR_BLANK_STRING]]", child_join_sql)



        return output_join_sql

    def create_child_join_sql(self, edw_join_definition_dwid: dict) -> str:
        # get the join details from the DB
        child_join_details = EDW().get_child_join_data(edw_join_definition_dwid)
        child_join_query_template = f'''
-- child join start
INNER JOIN
(
    SELECT * FROM
        (SELECT row_number() OVER (PARTITION BY {child_join_details[0]["target_field_name"]} ORDER BY data_source_updated_datetime DESC) AS row_number, * FROM {child_join_details[0]["target_schema_name"]}.{child_join_details[0]["target_table_name"]}) AS t
    WHERE
        t.row_number = 1
) AS t{child_join_details[0]["child_join_tree_definition_root_join_dwid"]} ON {child_join_details[0]["join_condition"]}
-- child join end
'''
        return child_join_query_template

    def has_child_join(self, field_definition: dict) -> bool:
        edw = EDW()
        child_join_data = edw.get_child_join_data(field_definition["join_alias"])

        if len(child_join_data) == 0:
            return False
        elif len(child_join_data) == 1:
            return True
        else:
            raise ValueError("Expected child_join_data to have 0 or 1 rows but more than 1 row was found. Script is not written to handle this scenario.")


    def get_process_dwid_from_table_name(self, search_text: str) -> int:
        '''
        Used to get the process_dwid based on a table name. If 0 or more than 1 row is found ValueErrors are thrown.

        ** THIS CODE IS FRAGILE ** -- highly coupled with the format of the test in mdi.process.description. We're
        looking into a change here https://app.asana.com/0/0/1200287150179725/

        :param search_text: the name of the table (or other text) that
        :return: returns the process_dwid of a row in mdi.process that has *table_name* in its description
        '''

        edw = EDW()
        search_text = f"%% {search_text} %%" # %% escapes the % character for the psycopg2 module. we need to build the
                                             # string manually because the module automatically adds single quotes around strings.
                                             # may be able to fix this with module psycopg2.sql's sql builder functions.

        query = '''SELECT dwid AS process_dwid FROM mdi.process WHERE description LIKE %s AND name LIKE \'SP-10%%\''''

        rows = edw.execute_parameterized_query(query, search_text)

        number_of_rows_returned = len(rows)

        if number_of_rows_returned > 1:
            raise(ValueError("Expected 1 row to be returned when querying mdi.process but multiple rows returned."))
        elif number_of_rows_returned == 0:
            raise(ValueError("Expected 1 row to be returned when querying mdi.process but zero rows returned."))
        elif number_of_rows_returned == 1:
            process_dwid = rows[0]["process_dwid"] # we know there is only one row in the list and we want the process_dwid value from that dict
            return process_dwid
        else:
            raise(Exception("Unexpected program state encountered while looking up the process_dwid values from the table name.")) # should never hit this code but throw an error for future me if we do enter a problem state

    def create_table_input_to_insert_update_sql(self) -> str:
        '''
        Creates SQL that can be executed against the config database in EDW to add SP configurations.

        :return: a string that contains SQL insert statements
        '''

        config_insert = ""
        config_insert += f'''
-- The following statement adds an ETL configuration to populate {self.insert_update_schema_name}.{self.insert_update_table_name} ({self.process_name})

with temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
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

        for index, field_definition in enumerate(self.field_metadata, start=1):
            if field_definition["json_output_key_field"] == True:
                config_insert += f'''
, temp_json_output_field_{index} as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, '{field_definition["insert_update_field_name"]}'
    FROM temp_process)
'''

        config_insert += f'''
, temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, '{self.insert_update_step_connection}', '{self.insert_update_schema_name}', '{self.insert_update_table_name}', {self.insert_update_commit_size}, 'N'
    FROM temp_process
    RETURNING dwid)
'''

        for index, field_definition in enumerate(self.field_metadata, start=1):
            #ignore fields that do not have source definitions (edw standard fields)
            if field_definition["has_table_input_source_definition"] == 0:
                continue

            # loop over only the key fields
            if field_definition["insert_update_key_field_flag"] != 1:
                continue

            config_insert += f'''
, temp_insert_update_key_{index} as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, '{field_definition["insert_update_field_name"]}', '{field_definition["insert_update_field_name"]}', '='
    FROM temp_insert_update_step
    RETURNING dwid)
'''


        config_insert += f'''
, temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'false'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'false'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'false'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'Y', 'false'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'false'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''
        config_insert += f'''
, temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'Y', 'false'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''

        for index, field_definition in enumerate(self.field_metadata, start=7):
            #ignore fields that do not have source definitions (edw standard fields)
            if field_definition["has_table_input_source_definition"] == 0:
                continue

            config_insert += f'''
, temp_insert_update_field_{index} as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, '{field_definition["insert_update_field_name"]}', '{field_definition["insert_update_field_name"]}', 'Y', 'false'
    FROM temp_insert_update_step
    RETURNING dwid) 
'''

        seen_table_name_values = []
        for index, field_definition in enumerate(self.field_metadata, start=1):
            #ignore fields that do not have source definitions (edw standard fields)
            if field_definition["has_table_input_source_definition"] == 0:
                continue

            # if we've already seen this table name then move to the next row
            state_machine_step_process_dwid = self.get_process_dwid_from_table_name(field_definition["table_input_table_name"])
            if field_definition["table_input_table_name"] in seen_table_name_values:
                continue

            seen_table_name_values.append(field_definition["table_input_table_name"])

            config_insert += f'''
, temp_state_machine_step_update_{index} as (UPDATE mdi.state_machine_step set next_process_dwid = temp_process.dwid FROM temp_process WHERE process_dwid={state_machine_step_process_dwid} AND next_process_dwid IS NULL)   -- mdi.state_machine_step

, temp_state_machine_step_insert_{index} as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)
'''

        config_insert += f'''
SELECT 'Done adding MDI configuration for {self.insert_update_schema_name}.{self.insert_update_table_name} ({self.process_name})' as etl_creator_status; -- needed for the cte to return at least one row, appears in flyway/jenkins/aws logs
        
''' # add some line breaks to the sql so the output is more readable when there are many in a row generated
        return config_insert


def main(argv):
    script_name = argv[0]
    argv = argv[1:]

    try:
        opts, args = getopt.getopt(argv, "ht:i",["help","table","information_schema"])
    except getopt.GetopsError:
        display_usage(script_name)
        exit(-1)
    for opt, arg in opts:
        if opt in ("-h", "--h", "-help", "--help"):
            display_usage(script_name)
            exit(0)
        elif opt in ("-i", "--i", "-information_schema", "--information_schema"):
            generate_mdi_configs_based_on_information_schema()
        elif opt in ("-t", "--t", "-table_definition", "--table_definition"):
            generate_mdi_configs_based_on_table_definition(arg)

def display_usage(script_name: str) -> None:
    print(f'''{script_name} script usage:
    -h      print usage information
    -i      create configs based on staging db information_schema
    -t <schema name>   create configs based on mdi.edw_table_definition''')

def generate_mdi_configs_based_on_table_definition(schema_name_to_process: str) -> None:
    print(f"-- Will create configs for this schema: {schema_name_to_process}")
    print(f"-- Generated at {datetime.now()}")

    edw = EDW(db_name="config")
    table_list = edw.get_table_list_from_edw_table_definition(schema_name_to_process)

    for index, table in enumerate(table_list, start=200000):
        edw_table_definition_dwid = table["dwid"]
        database_name = table["database_name"]
        schema_name = table["schema_name"]
        table_name = table["table_name"]
        primary_source_edw_table_definition_dwid = table["primary_source_edw_table_definition_dwid"]

        process_name = f"SP-{index}"

        fields = edw.get_field_list_from_edw_field_definition(edw_table_definition_dwid)
        etl_config = DimensionETLCreator(field_metadata=fields,
                                         process_name=process_name,
                                         edw_connection=EDW(db_name=database_name),
                                         insert_update_table_name = table_name,
                                         table_input_step_data_source_dwid=1,
                                         edw_table_definition_dwid=edw_table_definition_dwid)
        sql_configuration = etl_config.create_table_input_to_insert_update_sql()
        print(sql_configuration)

def generate_mdi_configs_based_on_information_schema():
    edw = EDW(db_name="staging")
    staging_tables = edw.get_all_staging_tables('staging_octane')
    full_config_insert_script = ""
    for i, staging_table_metadata in enumerate(staging_tables, start=100001):
        etl_config = Staging_to_History_ETL(staging_table_metadata, f'SP-{i}', edw)
        config_insert = etl_config.create_config_insert_statements()
        full_config_insert_script+=config_insert # ********* This is the main output of this script *********
    f = open("config_insert_"+date.today().strftime("%Y%m%d")+".sql", "w")
    f.write(full_config_insert_script)
    f.close()

if __name__ == "__main__":
    main(sys.argv)







#
#
#
# select
# application.apl_pid as application_pid
# , 1 as data_source_dwid
# , 'apl_pid~data_source_dwid~' as data_source_integration_columns
# , CONCAT( application.apl_pid, '~1~' ) as data_source_integration_id
# -- , application.data_source_updated_datetime as data_source_modified_datetime
# , NOW( ) as edw_created_datetime
# , NOW( ) as edw_modified_datetime
# , application.apl_proposal_pid as proposal_pid
# from
# staging_octane.application;