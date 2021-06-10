--
-- EDW | Join metadata - Fix the join used for mortgage_insurance_dim.loan_dwid
-- https://app.asana.com/0/0/1200435129096005
--

WITH next_join_dwid AS (
    -- pre-emptively get the next join definition dwid to avoid doing a string replacement on join condition after insertion
    SELECT NEXTVAL( 'mdi.edw_join_definition_dwid_seq' ) AS dwid
)
   , new_join_definition AS (
    -- Insert new join definition between history_octane.loan and star_loan.loan_dim
    INSERT INTO mdi.edw_join_definition (dwid,
                                         primary_edw_table_definition_dwid,
                                         target_edw_table_definition_dwid,
                                         join_type,
                                         join_condition)
        SELECT next_join_dwid.dwid
             , primary_table_definition.dwid
             , target_table_definition.dwid
             , 'inner'
             , 'primary_table.loan_pid = t' || next_join_dwid.dwid || '.loan_pid AND t' || next_join_dwid.dwid || '.data_source_id = 1'
        FROM mdi.edw_table_definition primary_table_definition
        JOIN mdi.edw_table_definition target_table_definition
             ON target_table_definition.schema_name = 'star_loan'
                 AND target_table_definition.table_name = 'loan_dim'
        JOIN next_join_dwid
             ON TRUE -- next_join_dwid is a single-row table containing the next dwid in this table's sequence
        WHERE primary_table_definition.schema_name = 'history_octane'
          AND primary_table_definition.table_name = 'loan'
        RETURNING dwid
)
   , new_join_tree_definition AS (
    -- Insert new join tree definition for the new join definition inserted above
    INSERT INTO mdi.edw_join_tree_definition (root_join_dwid, sibling_join_tree_dwid, child_join_tree_dwid)
        SELECT new_join_definition.dwid, NULL, NULL
        FROM new_join_definition
        RETURNING dwid
)
-- Set join tree definition dwid for mortgage_insurance_dim.loan_dwid to the newly-inserted join tree's dwid
UPDATE mdi.edw_field_definition
SET source_edw_join_tree_definition_dwid = new_join_tree_definition.dwid
FROM new_join_tree_definition
   , mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_table_definition.schema_name = 'star_loan'
  AND edw_table_definition.table_name = 'mortgage_insurance_dim'
  AND edw_field_definition.field_name = 'loan_dwid';

--
-- EDW | edw_join_definition - Fix join condition for mortgage_insurance_dim
-- https://app.asana.com/0/0/1200441523296553
--

-- select all join definitions between history_octane.loan and star_loan.loan_dim
WITH loan_to_loan_dim_joins AS (
    SELECT edw_join_definition.dwid
         , edw_join_definition.join_condition
    FROM mdi.edw_join_definition
    JOIN mdi.edw_table_definition primary_table
         ON edw_join_definition.primary_edw_table_definition_dwid = primary_table.dwid
    JOIN mdi.edw_table_definition target_table
         ON edw_join_definition.target_edw_table_definition_dwid = target_table.dwid
    WHERE primary_table.schema_name = 'history_octane'
      AND primary_table.table_name = 'loan'
      AND target_table.schema_name = 'star_loan'
      AND target_table.table_name = 'loan_dim'
)
-- update the join condition for the join whose existing condition is "primary_table.loan_pid = t{dwid}.loan_pid AND t{dwid}.data_source_id = 1"
UPDATE mdi.edw_join_definition
SET join_condition = 'primary_table.l_pid = t' || loan_to_loan_dim_joins.dwid || '.loan_pid ' ||
                     'AND t' || loan_to_loan_dim_joins.dwid || '.data_source_dwid = 1'
FROM loan_to_loan_dim_joins
WHERE edw_join_definition.join_condition = 'primary_table.loan_pid = t' || loan_to_loan_dim_joins.dwid || '.loan_pid ' ||
                                              'AND t' || loan_to_loan_dim_joins.dwid || '.data_source_id = 1';
