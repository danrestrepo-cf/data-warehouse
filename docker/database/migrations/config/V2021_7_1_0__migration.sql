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
    WHERE insert_update_step.schema_name = 'star_loan'
      AND edw_field_definition.field_name IN ('race_other_pacific_islander_description_flag'
        , 'piggyback_flag'
        , 'party_to_lawsuit_explanation_flag'
        , 'ethnicity_other_hispanic_or_latino_description_flag'
        , 'borrowed_down_payment_explanation_flag'
        , 'race_other_american_indian_or_alaska_native_description_flag'
        , 'note_endorser_explanation_flag'
        , 'other_race_national_origin_description_flag'
        , 'race_other_asian_description_flag'
        , 'obligated_loan_foreclosure_explanation_flag'
        , 'outstanding_judgments_explanation_flag'
        , 'los_loan_number'
        , 'presently_delinquent_explanation_flag'
        , 'bankruptcy_explanation_flag'
        , 'property_foreclosure_explanation_flag'
        , 'alimony_child_support_explanation_flag'
        );