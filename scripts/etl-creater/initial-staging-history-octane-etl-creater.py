
import psycopg2
from datetime import date

class Insert_Script:
    process_insert = []
    table_input_step_insert = []
    table_output_step_insert = []
    table_output_field_step_insert = []
    json_output_field_insert = []
    state_machine_definition_insert = []
    state_machine_step_insert = []
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

    def add_state_machine_definition_insert(self, new_state_machine_definition_row):
        self.state_machine_definition_insert.append(new_state_machine_definition_row)

    def add_state_machine_step_insert(self, new_state_machine_step_row):
        self.state_machine_step_insert.append(new_state_machine_step_row)

    def create_script(self):
        temp1 = ",".join(self.process_insert)
        temp2 = ",".join(self.table_input_step_insert)
        temp3 = ",".join(self.table_output_step_insert)
        temp4 = ",".join(self.table_output_field_step_insert)
        temp5 = ",".join(self.json_output_field_insert)
        temp6 = ",".join(self.state_machine_definition_insert)
        temp7 = ",".join(self.state_machine_step_insert)
        final_script = (PROCESS_INSERT_HEADER + temp1 + ';'
                        + TABLE_INPUT_STEP_INSERT_HEADER + temp2 + ';'
                        + TABLE_OUTPUT_STEP_INSERT_HEADER + temp3 + ';'
                        + TABLE_OUTPUT_FIELD_STEP_INSERT_HEADER + temp4 + ';'
                        + JSON_OUTPUT_FIELD_INSERT_HEADER + temp5 + ';'
                        + STATE_MACHINE_DEFINITION_INSERT_HEADER + temp6 + ';'
                        + STATE_MACHINE_STEP_INSERT_HEADER + temp7 + ';'
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


    def get_all_staging_tables(self, schema):
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


def main():

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
    main()