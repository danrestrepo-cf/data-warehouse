--
-- EDW | edw_field_definition - fix data type mismatches between dimensions and source fields
-- https://app.asana.com/0/0/1200393611923107
--

-- add missing field source calculations
CREATE TEMPORARY TABLE temp_field_calculations (
    schema_name TEXT,
    table_name TEXT,
    field_name TEXT,
    calculation TEXT
);

INSERT
INTO temp_field_calculations (schema_name, table_name, field_name, calculation)
VALUES ('star_loan', 'transaction_junk_dim', 'piggyback_flag', 'prp_structure_type = ''COMBO''')
     , ('star_loan', 'borrower_demographics_dim', 'ethnicity_other_hispanic_or_latino_description_flag', 'borrower.b_ethnicity_other_hispanic_or_latino_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'other_race_national_origin_description_flag', 'borrower.b_other_race_national_origin_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'race_other_american_indian_or_alaska_native_description_flag', 'borrower.b_race_other_american_indian_or_alaska_native_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'race_other_asian_description_flag', 'borrower.b_race_other_asian_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'race_other_pacific_islander_description_flag', 'borrower.b_race_other_pacific_islander_description <> ''''');

UPDATE mdi.edw_field_definition
SET field_source_calculation = temp_field_calculations.calculation
  , source_edw_field_definition_dwid = NULL
FROM temp_field_calculations
   , mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_table_definition.schema_name = temp_field_calculations.schema_name
  AND edw_table_definition.table_name = temp_field_calculations.table_name
  AND edw_field_definition.field_name = temp_field_calculations.field_name;

-- update data type for borrower_demographics_dim.schooling_years
UPDATE mdi.edw_field_definition
SET data_type = 'INTEGER'
FROM mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
  AND edw_table_definition.schema_name = 'star_loan'
  AND edw_table_definition.table_name = 'borrower_demographics_dim'
  AND edw_field_definition.field_name = 'schooling_years';
