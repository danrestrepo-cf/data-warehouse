'''

TODO:
    account for 'type' tables:
        Remove from current staging_to_history class
        create separate class for type tables (ignoring pids, always full load?)
    create section for deleted records
    output the insert statements into a script

'''

class ETL_config:
    process_name = ""
    process_description = ""
    table_input_step_sql = ""
    table_input_step_connection = ""
    table_output_step_schema = ""
    table_output_step_table = ""
    table_output_step_connection = ""
    table_output_step_fields = []

    process_dwid = ""
    table_input_step_dwid = ""
    table_output_step_dwid = ""

    def __init__ (self
                  , process_name
                  , process_description
                  , table_input_step_connection
                  , table_input_step_sql
                  , table_output_step_connection
                  , table_output_step_schema
                  , table_output_step_table
                  , table_output_step_fields):
        self.process_name = process_name
        self.process_description = process_description
        self.table_input_step_connection = table_input_step_connection
        self.table_input_step_sql = table_input_step_sql
        self.table_output_step_connection = table_output_step_connection
        self.table_output_step_schema = table_output_step_schema
        self.table_output_step_table = table_output_step_table
        self.table_output_step_fields = table_output_step_fields

    def create_config_insert_statements(self):
        process_insert = f'''
            INSERT INTO mdi.process (dwid, name, description)
            VALUES ({self.process_dwid}, {self.process_name}, {self.process_description})
            ;'''
        table_input_step_insert = f'''
            INSERT INTO table_input_step (dwid, process_dwid, data_source_dwid, sql, limit_size, connectionname)
            VALUES ({self.table_input_step_dwid}, {self.process_dwid}, 0, {self.table_input_step_sql}, 0, {self.table_input_step_connection})
            ;'''
        table_output_step_insert = f'''
            INSERT INTO mdi.table_output_step (dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field
                                          , table_name_field, auto_generated_key_field, partition_data_per
                                          , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                          , connectionname, partition_over_tables, specify_database_fields
                                          , ignore_insert_errors, use_batch_update )
            VALUES ( {self.table_output_step_dwid}, {self.process_dwid}, {self.table_output_step_schema}, {self.table_output_step_table}, 1000
                , NULL, NULL, NULL, NULL, 'N', NULL, 'Y'
                , {self.table_output_step_connection}, 'N'
                , 'Y', 'N', 'N' )
            ;'''
    table_output_field_step = []
    for i, field in enumerate(table_output_step_fields):
        table_output_field_dwid = ""
        table_output_field_step[i] = f'''
                INSERT INTO mdi.table_output_field (dwid, table_output_step_dwid, database_field_name, database_stream_name
                   , field_order, is_sensitive )
                VALUES ({self.table_output_field_dwid},  {self.table_output_step_dwid}, {field}, {field}, {i}, 0)
            ;'''
    print (process_insert+table_input_step_insert+table_output_step_insert+table_output_field_step

class Staging_to_History_ETL(ETL_config):

    def __init__(self, process_name, staging_table_name):
        self.process_name = process_name
        self.process_description = f'ETL to copy {table_name} data from staging_octane to history_octane'
        self.table_input_step_connection = 'Staging DB Connection'
        self.table_output_step_fields = edw.get_all_table_fields("staging_octane", self.staging_table_name)
        self.table_input_step_sql = f'''
            SELECT {','.join(self.table_output_step_fields)}, FALSE as data_source_deleted_flag, now() AS data_source_last_updated_datetime
            FROM staging_history.{table_name} where {main_pid} in (%%pids) or %%full_load_flag = true'''
        self.table_output_step_connection = 'Staging DB Connection'
        self.table_output_step_schema = "history_octane"
        self.table_output_step_table = self.staging_table_name
        super().__init__(self
                         , self.process_name
                         , self.process_description
                         , self.table_iuput_step_connection
                         , self.table_input_step_sql
                         , self.table_output_step_connection
                         , self.table_output_step_schema
                         , self.table_output_step_table
                         , self.table_output_step_fields)


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

    def execute_query(self, query: str):
        conn = psycopg2.connect(database=self.database_name,
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
            rows = self.execute_query(f'''
            SELECT tables.table_name
            FROM information_schema.tables
            WHERE tables.table_schema = {schema}
            ;
		''')

    def get_all_table_fields(self, schema, table):
        rows = self.execute_query(f'''
            SELECT columns.column_name
            FROM information_schema.columns
            WHERE columns.table_schema = {schema}
                AND columns.table_name = {table}
            ;
		''')

def main():
    staging_tables = edw.get_all_staging_tables()
edw = EDW()
etl_config_list = []

for i, staging_table_name in enumerate(staging_tables):
    etl_config = Staging_to_History_ETL(staging_table_name, f'SP-{i}')
etl_config_list.append(etl_config)


if __name__ == "__main__":
    main()