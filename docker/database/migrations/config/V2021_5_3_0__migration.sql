--
-- EDW field metadata | Remove alias from calculations
-- https://app.asana.com/0/0/1200343485858659
--

UPDATE mdi.edw_field_definition
SET field_source_calculation = 'CASE WHEN l_lien_priority_type = ''FIRST'' OR prp_structure_type = ''STANDALONE_2ND'' THEN FALSE ELSE TRUE END'
WHERE field_name = 'piggyback_flag'
  AND edw_table_definition_dwid IN
      (SELECT edw_table_definition.dwid
       FROM mdi.edw_table_definition
       WHERE edw_table_definition.schema_name = 'star_loan'
         AND edw_table_definition.table_name = 'loan_junk_dim')
;
UPDATE mdi.edw_field_definition
SET field_source_calculation = 'CASE WHEN l_lien_priority_type = ''FIRST'' OR prp_structure_type = ''STANDALONE_2ND'' THEN d_los_loan_id_main ELSE d_los_loan_id_piggyback END'
WHERE field_name = 'los_loan_number'
  AND edw_table_definition_dwid IN
      (SELECT edw_table_definition.dwid
       FROM mdi.edw_table_definition
       WHERE edw_table_definition.schema_name = 'star_loan'
         AND edw_table_definition.table_name = 'loan_dim')
;
