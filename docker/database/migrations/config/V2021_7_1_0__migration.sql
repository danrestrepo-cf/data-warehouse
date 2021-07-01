--
-- EDW | star_loan - null data in calculated dimension field(s) (manual metadata fix)
-- https://app.asana.com/0/0/1200548658779340/
--

INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
    SELECT insert_update_step.dwid AS insert_update_step_dwid
         , edw_field_definition.field_name AS update_lookup
         , edw_field_definition.field_name AS update_stream
         , 'Y' AS update_flag
         , FALSE AS is_sensitive
    FROM mdi.edw_table_definition
             JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
             LEFT JOIN mdi.insert_update_step ON edw_table_definition.schema_name = insert_update_step.schema_name
        AND edw_table_definition.table_name = insert_update_step.table_name
             LEFT JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
        AND edw_field_definition.field_name = insert_update_field.update_lookup
    WHERE edw_field_definition.field_name <> 'dwid'
      AND insert_update_step.schema_name = 'star_loan'
      AND insert_update_field.dwid IS NULL;
