'''

TODO:
    output the insert statements into a script that combines all the inserts

'''


import psycopg2

DEBUG = False


PROCESS_INSERT_HEADER = '''
    INSERT INTO mdi.process (
        dwid, name, description
        ) 
    VALUES'''
TABLE_INPUT_STEP_INSERT_HEADER = '''
    INSERT INTO mdi.table_input_step (
        dwid, process_dwid, data_source_dwid, sql, limit_size, connectionname
        ) 
    VALUES'''
TABLE_OUTPUT_STEP_INSERT_HEADER = '''
    INSERT INTO mdi.table_output_step (
        dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field, 
        table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, 
        return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, 
        specify_database_fields, ignore_insert_errors, use_batch_update 
        ) 
    VALUES'''
TABLE_OUTPUT_FIELD_STEP_INSERT_HEADER = '''
    INSERT INTO mdi.table_output_field (
        dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order, 
        is_sensitive 
        ) 
    VALUES'''
JSON_OUTPUT_FIELD_INSERT_HEADER = '''
    INSERT INTO mdi.json_output_field (
        dwid, process_dwid, field_name
        ) 
    VALUES'''


class Insert_Script:
    process_insert = []
    table_input_step_insert = []
    table_output_step_insert = []
    table_output_field_step_insert = []
    json_output_field_insert = []
    final_script = ""

    def __init__(self):
        None

    def add_process_insert(self, new_process_row):
        self.process_insert.append(new_process_row)

    def add_table_input_step_insert(self, new_table_input_step_row):
        self.table_input_step_insert.append(new_table_input_step_row)

    def add_table_output_step_insert(self, new_table_output_step_row):
        self.table_output_step_insert.append(new_table_output_step_row)

    def add_table_output_field_step_insert(self, new_table_output_field_step_row):
        self.table_output_field_step_insert.append(new_table_output_field_step_row)

    def add_json_output_field_insert(self, new_json_output_field_row):
        self.json_output_field_insert.append(new_json_output_field_row)

    def create_script(self):
        temp1 = ",".join(self.process_insert)
        temp2 = ",".join(self.table_input_step_insert)
        temp3 = ",".join(self.table_output_step_insert)
        temp4 = ",".join(self.table_output_field_step_insert)
        temp5 = ",".join(self.json_output_field_insert)
        final_script = (PROCESS_INSERT_HEADER + temp1 + ';'
                           + TABLE_INPUT_STEP_INSERT_HEADER + temp2 + ';'
                           + TABLE_OUTPUT_STEP_INSERT_HEADER + temp3 + ';'
                           + TABLE_OUTPUT_FIELD_STEP_INSERT_HEADER + temp4 + ';'
                           + JSON_OUTPUT_FIELD_INSERT_HEADER + temp5 + ';'
                           )
        return final_script

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
                  , output_script):
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
        self.output_script = output_script

    def create_config_insert_statements(self):
        self.process_dwid = self.staging_connection.execute_query(f'''SELECT nextval('mdi."process_dwid_seq"')''', 'config')[0][0]
        process_insert = f'''
            ({self.process_dwid}, '{self.process_name}', '{self.process_description}') '''
        self.output_script.add_process_insert(process_insert)
        self.table_input_step_dwid = self.staging_connection.execute_query(f'''SELECT nextval('mdi."table_input_step_dwid_seq"')''', 'config')[0][0]
        table_input_step_insert = f'''
            ({self.table_input_step_dwid}, {self.process_dwid}, 0, '{self.table_input_step_sql}', 0, '{self.table_input_step_connection}')'''
        self.output_script.add_table_input_step_insert(table_input_step_insert)
        self.table_output_step_dwid = self.staging_connection.execute_query(f'''SELECT nextval('mdi."table_output_step_dwid_seq"')''', 'config')[0][0]
        table_output_step_insert = f'''
            ({self.table_output_step_dwid}, {self.process_dwid}, '{self.table_output_step_schema}', '{self.table_output_step_table}', 1000
                , NULL, NULL, NULL, NULL, 'N', NULL, 'Y'
                , '{self.table_output_step_connection}', 'N'
                , 'Y', 'N', 'N' ) '''
        self.output_script.add_table_output_step_insert(table_output_step_insert)
        table_output_field_step_inserts = []
        for i, field in enumerate(self.table_output_step_fields):
            table_output_field_dwid = self.staging_connection.execute_query(f'''SELECT nextval('mdi."table_output_field_dwid_seq"')''', 'config')[0][0]
            table_output_field_step_insert =  f'''({table_output_field_dwid},  {self.table_output_step_dwid}, '{field}', '{field}', {i}, False)'''
            table_output_field_step_inserts.append(table_output_field_step_insert)
            self.output_script.add_table_output_field_step_insert(table_output_field_step_insert)
        self.json_output_field_dwid = self.staging_connection.execute_query(f'''SELECT nextval('mdi."json_output_field_dwid_seq"')''', 'config')[0][0]
        json_output_field_insert = f'''
            ({self.json_output_field_dwid}, {self.process_dwid}, '{self.json_output_step_field}')'''
        self.output_script.add_json_output_field_insert(json_output_field_insert)
        if DEBUG:
            print (PROCESS_INSERT_HEADER + process_insert+';'
                +TABLE_INPUT_STEP_INSERT_HEADER+table_input_step_insert+';'
                +TABLE_OUTPUT_STEP_INSERT_HEADER+table_output_step_insert+';'
                +TABLE_OUTPUT_FIELD_STEP_INSERT_HEADER+",".join(table_output_field_step_inserts)+';'
                +JSON_OUTPUT_FIELD_INSERT_HEADER+json_output_field_insert+';')


class Staging_to_History_ETL(ETL_config):
    def __init__(self, staging_table_metadata, process_name, staging_connection, output_script):
        self.staging_table_metadata = staging_table_metadata
        self.staging_table_name = self.staging_table_metadata[0]
        self.process_name = process_name
        self.main_pid = self.staging_table_metadata[1]
        self.version_pid = self.staging_table_metadata[2]
        self.process_description = f'ETL to copy {self.staging_table_name} data from staging_octane to history_octane'
        self.table_input_step_connection = 'Staging DB Connection'
        self.table_output_step_fields = staging_connection.get_all_table_fields("staging_octane", self.staging_table_name)
        self.output_script = output_script
        # self.table_input_step_sql = f'''
        #     SELECT {','.join(self.table_output_step_fields)}, FALSE as data_source_deleted_flag, now() AS data_source_last_updated_datetime
        #     FROM staging_octane.{self.staging_table_name} where {self.main_pid} in (%pids) or %full_load_flag = true'''
        if self.version_pid is None:
            join_condition = ""
            for i, field in enumerate(self.table_output_step_fields):
                if(i>0):
                    join_condition +=' AND '
                join_condition +='staging_table.'+field+' = history_table.'+field
            self.table_input_step_sql = f'''
            SELECT staging_table.{', staging_table.'.join(self.table_output_step_fields)}, FALSE as data_source_deleted_flag, now() AS data_source_last_updated_datetime
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
            SELECT staging_table.{', staging_table.'.join(self.table_output_step_fields)}, FALSE as data_source_deleted_flag, now() AS data_source_last_updated_datetime
            FROM staging_octane.{self.staging_table_name} staging_table
            LEFT JOIN history_octane.{self.staging_table_name} history_table on staging_table.{self.main_pid} = history_table.{self.main_pid} and staging_table.{self.version_pid} = history_table.{self.version_pid}
            WHERE history_table.{self.main_pid} is NULL
            UNION ALL
            SELECT {list_of_fields}, TRUE as data_source_deleted_flag, now() AS data_source_last_updated_datetime
            FROM history_octane.{self.staging_table_name} history_table
            LEFT JOIN staging_octane.{self.staging_table_name} staging_table on staging_table.{self.main_pid} = history_table.{self.main_pid}
            WHERE staging_table.{self.main_pid} is NULL
            '''
        self.table_output_step_connection = 'Staging DB Connection'
        self.table_output_step_schema = "history_octane"
        self.table_output_step_table = self.staging_table_name
        self.staging_connection = staging_connection
        self.json_output_step_field = self.main_pid
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
                         , self.output_script)


class Db_connection:
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

    def execute_query(self, query: str, database=database_name):
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


    def get_all_staging_tables(self, schema):
        table_names = []
        rows = self.execute_query(f'''
        SELECT t.relname AS name, a.attname as key_field, version.attname as version_field
        FROM pg_class t
         join pg_index ix on t.oid = ix.indrelid
         join pg_class i on i.oid = ix.indexrelid
         join pg_attribute a on a.attrelid = t.oid and a.attnum = ANY(ix.indkey)
         join pg_namespace on t.relnamespace = pg_namespace.oid
         join pg_attribute version on version.attrelid = t.oid AND version.attname = left(a.attname, length(a.attname)-3)||'version'
        WHERE pg_namespace.nspname = 'staging_octane'
          and t.relkind = 'r'
          and i.relname like '%_pkey'
            and t.relname like 'a%'
         -- 371
        union all
        select tables.table_name as name, 'code' as key_field, null as version_field
        from information_schema.tables
        join information_schema.columns col1 on tables.table_name = col1.table_name and tables.table_schema = col1.table_schema and col1.column_name = 'code'
        join information_schema.columns col2 on tables.table_name = col2.table_name and tables.table_schema = col2.table_schema and col2.column_name = 'value'
        where tables.table_name like '%type'
            and tables.table_schema = 'staging_octane'
            and tables.table_name like 'a%'
        --425 (2 of these have 3 columns each)
        ;
        ''', 'staging')
        return rows

    def get_all_table_fields(self, schema, table):
        columns = []
        rows = self.execute_query(f'''
            SELECT columns.column_name
            FROM information_schema.columns
            WHERE columns.table_schema = '{schema}'
                AND columns.table_name = '{table}'
            ;
		''', 'staging')
        for row in rows:
            columns.append(row[0])
        return columns


def main():

    edw_staging = Db_connection(db_name="staging")
    output_script = Insert_Script()
    staging_tables = edw_staging.get_all_staging_tables('staging_octane')
    etl_config_list = []
    for i, staging_table_metadata in enumerate(staging_tables, start=100000):
        etl_config = Staging_to_History_ETL(staging_table_metadata, f'SP-{i}', edw_staging, output_script)
        etl_config.create_config_insert_statements()
    etl_config_list.append(etl_config)
    print(output_script.create_script())

if __name__ == "__main__":
    main()