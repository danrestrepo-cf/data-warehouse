----------------------------------------
-- This script will read the metadata for all tables and fields in staging_octane and history_octane and will generate
-- a script that can be used to create table_definition, field_definition and join definition records for them.
--
-- The one part missing from this is the source_edw_field_definition_dwid in thehistory_octane field definitions. These
-- will need to be populated separately.
----------------------------------------
SELECT CONCAT(
               'with staging_def as (INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid) ',
               'VALUES (''staging'', ''staging_octane'', ''', TABLES.TABLE_NAME,
               ''', NULL) RETURNING dwid as staging_dwid) ',
               ', table_def as (INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid) ',
               'SELECT ''staging'', ''history_octane'', ''', TABLES.TABLE_NAME,
               ''', staging_def.staging_dwid from staging_def RETURNING primary_source_edw_table_definition_dwid AS staging_dwid, dwid AS history_dwid)',
               string_agg(', staging_' || COLUMNS.column_name ||
                          ' as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, source_edw_join_definition_dwid) ' ||
                          'SELECT table_def.staging_dwid, ''' || COLUMNS.column_name ||
                          ''', ' || case when COLUMNS.column_name = KEY_FIELDS.key_field then 'True' else 'False' end ||', NULL, NULL FROM table_def)',
                          ''),
               string_agg(', history_' || COLUMNS.column_name ||
                          ' as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, source_edw_join_definition_dwid) ' ||
                          'SELECT table_def.history_dwid, ''' || COLUMNS.column_name ||
                          ''', ' || case when COLUMNS.column_name = KEY_FIELDS.key_field then 'True' else 'False' end ||
                          ', NULL, NULL FROM table_def)',
                          ''),
               'select 1;')
FROM INFORMATION_SCHEMA.TABLES
         JOIN INFORMATION_SCHEMA.COLUMNS on TABLES.table_schema = COLUMNS.table_schema
    AND TABLES.table_name = COLUMNS.table_name
         JOIN (SELECT t.relname AS table_name, a.attname as key_field
               FROM pg_class t
                        join pg_index ix on t.oid = ix.indrelid
                        join pg_class i on i.oid = ix.indexrelid
                        join pg_attribute a on a.attrelid = t.oid and a.attnum = ANY (ix.indkey)
                        join pg_namespace on t.relnamespace = pg_namespace.oid
                        join pg_attribute version on version.attrelid = t.oid AND version.attname =
                                                                                  left(a.attname, length(a.attname) - 3) || 'version'
               WHERE pg_namespace.nspname = 'staging_octane'
                 and t.relkind = 'r'
                 and (i.relname like '%_pkey'
                   OR i.relname like 'pk_%'
                   )
                 -- 371
               union all
               select tables.table_name as name, 'code' as key_field
               from information_schema.tables
                        join information_schema.columns col1
                             on tables.table_name = col1.table_name and tables.table_schema = col1.table_schema and
                                col1.column_name = 'code'
                        join information_schema.columns col2
                             on tables.table_name = col2.table_name and tables.table_schema = col2.table_schema and
                                col2.column_name = 'value'
               where tables.table_name like '%type'
                 and tables.table_schema = 'staging_octane') KEY_FIELDS ON KEY_FIELDS.table_name = TABLES.table_name
WHERE TABLES.TABLE_SCHEMA = 'staging_octane'
GROUP BY TABLES.TABLE_NAME




