SELECT
    CONCAT('INSERT INTO mdi.edw_join_definition (primary_edw_table_definition_dwid, target_edw_table_definition_dwid, join_type, join_condition) ',
           'SELECT (SELECT dwid from mdi.edw_table_definition where edw_table_definition.table_name = ''',KEY_COLUMN_USAGE.TABLE_NAME,''' and schema_name = ''staging_octane'')',
           ', (SELECT dwid from mdi.edw_table_definition where edw_table_definition.table_name = ''',KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME,'''and schema_name = ''staging_octane'')',
           ', ''',case when min(COLUMNS.IS_NULLABLE) = 'YES' then 'left' else 'inner' end,
           ''', ''',group_CONCAT( KEY_COLUMN_USAGE.TABLE_NAME,'.',KEY_COLUMN_USAGE.COLUMN_NAME,' = ',KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME,'.',KEY_COLUMN_USAGE.REFERENCED_COLUMN_NAME SEPARATOR ' AND '),
           ''' WHERE (SELECT dwid from mdi.edw_table_definition where edw_table_definition.table_name = ''',KEY_COLUMN_USAGE.TABLE_NAME,''' and schema_name = ''staging_octane'') IS NOT NULL',
           ' AND (SELECT dwid from mdi.edw_table_definition where edw_table_definition.table_name = ''',KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME,'''and schema_name = ''staging_octane'') IS NOT NULL;') AS INSERT_STATEMENT
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        JOIN INFORMATION_SCHEMA.COLUMNS ON KEY_COLUMN_USAGE.TABLE_SCHEMA = COLUMNS.TABLE_SCHEMA
        AND KEY_COLUMN_USAGE.TABLE_NAME = COLUMNS.TABLE_NAME
        AND KEY_COLUMN_USAGE.COLUMN_NAME = COLUMNS.COLUMN_NAME
WHERE
        KEY_COLUMN_USAGE.REFERENCED_TABLE_SCHEMA = 'lura_prod'
group by CONSTRAINT_NAME
;