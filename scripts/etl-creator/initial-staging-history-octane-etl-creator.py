import psycopg2
from datetime import date
import sys, getopt

class EDW:
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
        conn = psycopg2.connect(database=self.database_name,
                                user=self.database_username,
                                password=self.database_password,
                                host=self.database_hostname,
                                port=self.database_port)
        cur = conn.cursor()
        cur.execute(query, parameters)
        conn.commit()
        rows = cur.fetchall()
        conn.close()
        return rows

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
                        schema_name ASC;'''
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
                        CASE WHEN table_input_edw_field_definition.source_edw_field_definition_dwid IS NULL THEN 0 ELSE 1 END as has_table_input_source_definition
                        , table_input_edw_table_definition.database_name as table_input_database_name
                        , table_input_edw_table_definition.schema_name as table_input_schema_name
                        , table_input_edw_table_definition.table_name as table_input_table_name
                        , table_input_edw_field_definition.field_name as table_input_field_name
                        , table_output_edw_field_definition.field_source_calculation as table_output_field_source_calculation
                    
                        , table_input_edw_field_definition.field_source_calculation as table_input_field_source_calculation
                        , CASE WHEN table_output_edw_field_definition.source_edw_join_tree_definition_dwid IS NULL THEN 0 ELSE 1 END as has_table_output_edw_join_tree_definition
                        , table_input_join_definition.join_type
                        , table_input_join_definition.join_condition
                        , edw_table_definition.database_name as table_output_database_name
                        , edw_table_definition.schema_name as table_output_schema_name
                        , edw_table_definition.table_name as table_output_table_name
                        , table_output_edw_field_definition.field_name as table_output_field_name
                        , table_output_edw_field_definition.key_field_flag as table_output_key_field_flag
                    FROM
                        mdi.edw_table_definition
                            JOIN mdi.edw_field_definition table_output_edw_field_definition ON edw_table_definition.dwid = table_output_edw_field_definition.edw_table_definition_dwid
                            LEFT JOIN mdi.edw_field_definition table_input_edw_field_definition ON table_output_edw_field_definition.source_edw_field_definition_dwid = table_input_edw_field_definition.dwid
                            LEFT JOIN mdi.edw_table_definition table_input_edw_table_definition ON table_input_edw_field_definition.edw_table_definition_dwid = table_input_edw_table_definition.dwid
                            LEFT JOIN mdi.edw_join_tree_definition table_input_join_tree_definition ON table_output_edw_field_definition.source_edw_join_tree_definition_dwid = table_input_join_tree_definition.dwid
                            LEFT JOIN mdi.edw_join_definition table_input_join_definition ON table_input_join_tree_definition.root_join_dwid = table_input_join_definition.dwid
                    WHERE
                        edw_table_definition.dwid = %s
                        AND table_output_edw_field_definition.field_name not in ('dwid', 'data_source_dwid','data_source_integration_columns','data_source_integration_id','data_source_modified_datetime','edw_created_datetime', 'edw_modified_datetime', 'etl_batch_id') -- exclude these in the join if the table input field name is null?
                    ORDER BY
                        table_output_edw_field_definition.key_field_flag DESC
                        , table_output_edw_field_definition.field_name ASC
                        , has_table_input_source_definition;'''

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
                  , process_name
                  , process_description
                  , table_input_step_connection
                  , table_input_step_sql
                  , table_output_step_connection
                  , table_output_step_schema
                  , table_output_step_table
                  , table_output_step_fields
                  , json_output_step_field
                  , staging_connection
                  , state_machine_name
                  , state_machine_comment):
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


class DimensionETLCreator():
    def __init__(self, table_metadata: list, process_name: str, edw_connection: EDW):
        if len(table_metadata) == 0:
            raise(ValueError("table_metadata should contain at least one item in the list"))

        # table: table_input_step/field and insert_update step/field/key
        self.table_metadata = table_metadata
        self.table_input_step_connection = "Staging DB Connection"
        self.insert_update_step_connection = "Staging DB Connection"
        self.insert_update_table_name = ""
        self.table_input_step_data_source_dwid = 1   # star_common.data_source=1 (Octane)
        self.default_commit_size = 1000

        # table: process
        self.process_name = process_name
        self.process_description = f"Dimension ETL to populate {self.insert_update_table_name} from history_octane.{self.process_name}"

        # table: json_output_field
        self.json_output_step_field = "self.main_pid"
        self.state_machine_name = f""
        self.state_machine_comment = self.process_description


    def create_sql_comment(self, comment: str, original_string:str = "") -> str:
        return f"{original_string}  \n-- {comment}"

    def create_process(self, name: str, description: str) -> (int, str):
        config_insert=""
        config_insert += f'''
                
                with temp_process as (INSERT INTO mdi.process (name, description) 
                    VALUES ('{self.process_name}', '{self.process_description}')
                    RETURNING dwid 
                )'''

        return config_insert

    def create_table_input_step(self, sql: str, enable_lazy_conversion: str, cached_row_meta: str,
                                connectionname: str, data_source_dwid: int,
                                limit_size: int = 1000, replace_variables: str = "N", execute_for_each_row: str = "N") -> str:
        config_insert=""
        config_insert += f'''
                , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname) 
                    select temp_process.dwid, 0, '{self.table_input_step_sql}', 0, '{self.table_input_step_connection}'
                    from temp_process
                    RETURNING dwid 
                )'''

        return table_input_step_template



    # insert_update_step_template = {"process_dwid":None,
    #                                     "connectionname":None,
    #                                     "schema_name":None,
    #                                     "table_name":None,
    #                                     "commit_size":self.default_commit_size,
    #                                     "do_not":None}
    #
    # insert_update_field_template = {"insert_update_step_dwid":None,
    #                                      "update_lookup":None,
    #                                      "update_stream":None,
    #                                      "update_flag":None,
    #                                      "is_sensitive":None}
    #
    # insert_update_key_template = {"insert_update_step_dwid":None,
    #                                    "key_lookup":None,
    #                                    "key_stream1":None,
    #                                    "key_stream2":None,
    #                                    "key_condition":None}
    #
    # json_output_field = {"process_dwid":None,
    #                           "field_name":None}
    #
    # # state_machine_step_template = {"process_dwid":None,
    #                                         "next_process_dwid":None}




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

    def generate_sql(self):
        sql = self.create_sql_comment(f"-- The following statement adds a configuration for '{self.process_name}'\n")
        sql += self.create_process(self.process_name, self.process_description)
        # sql += self.create_table_input_step()
        x=1



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


def main(argv):
    script_name = argv[0]
    argv = argv[1:]

    try:
        opts, args = getopt.getopt(argv, "ht:i",["help","table","information_schema"])
    except getops.GetopsError:
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
    print(f"Will create configs for this schema: {schema_name_to_process}")

    edw = EDW(db_name="config")
    table_list = edw.get_table_list_from_edw_table_definition(schema_name_to_process)

    for index, table in enumerate(table_list, start=200000):
        edw_table_definition_dwid = table[0]
        database_name = table[1]
        schema_name = table[2]
        table_name = table[3]
        primary_source_edw_table_definition_dwid = table[4]

        process_name = f"SP-{index}"

        fields = edw.get_field_list_from_edw_field_definition(edw_table_definition_dwid)
        etl_config = DimensionETLCreator(fields, process_name, EDW(db_name="staging"))
        x = etl_config.generate_sql()
        print("")

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
