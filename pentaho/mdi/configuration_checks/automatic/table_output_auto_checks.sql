-- Asana: https://app.asana.com/0/0/1198065847802233





--
-- This example pulls a list of misconfigured process names for the table output step
--


-- Table: step_metadata_table_output
SELECT
	'mdi.step_metadata_table_output' AS "Misconfigured Table Name"
	, smto.smto_step_definition_id as "Step Definition ID"
	, smto.smto_process_name AS "Misconfigured Process Name"
FROM
	mdi.step_metadata_table_output smto
WHERE
	-- check values are in valid domains
	(smto.smto_use_batch_update NOT IN ('Y', 'N')) -- 'ERROR: column is not configured with a value in the settings domain'
	OR (smto.smto_ignore_insert_errors NOT IN ('Y', 'N'))
	OR smto.smto_truncate_table != 'N' -- Valid domains are Y, N, and NULL but we do not want to truncate any tables. Removed to flag any jobs that ARE configured to truncate.
	OR (smto.smto_specify_database_fields NOT IN ('Y', 'N'))
	OR (smto.smto_table_name_defined_in_field NOT IN ('Y', 'N'))
	OR (smto.smto_return_auto_generated_key_field IN ('Y', 'N'))

	-- 'ERROR: if smto_table_name_defined_in_field=Y then smto_table_name_field should not be blank'
	OR (smto.smto_table_name_defined_in_field = 'Y' AND (smto.smto_table_name_field != '' OR smto.smto_table_name_field IS NOT NULL))
;




--
-- Verify all rows in row_metadata_csv_file_input are configured correctly based on the data type of the row compared to what else is configured in the table
--
SELECT
	'mdi.row_metadata_csv_file_input' AS "Misconfigured Table Name"
	, smcfi.smcfi_process_name as "Misconfigured Table Name"
	, smcfi.smcfi_step_definition_id as "Step Definition ID"
	, rmcfi.rmcfi_field_name as "Misconfigured Field Name"
	, rmcfi.rmcfi_field_type as "Misconfigured Field Type"
	, 'ERROR: The settings in row_metadata_csv_file_input.rmcfi_field_name=''' || rmcfi.rmcfi_field_name || ''' are not correct for process ''' || smcfi.smcfi_process_name || '''' AS "Error Message"

FROM
	mdi.row_metadata_csv_file_input AS rmcfi
		JOIN mdi.step_metadata_csv_file_input AS smcfi
		ON smcfi.smcfi_step_definition_id = rmcfi.rmcfi_step_definition_id
WHERE
	(rmcfi.rmcfi_field_type NOT IN ('String', 'Integer', 'Date', 'Boolean', 'Number', 'Timestamp', 'BigNumber', 'Boolean'))
	OR
	-- if the row is a String, then other columns should be configured with standard values
	(
				rmcfi.rmcfi_field_type = 'String' AND (
				rmcfi.rmcfi_field_format IS NOT NULL
				OR rmcfi.rmcfi_field_length IS NOT NULL -- don't limit the length of strings that are loaded from a csv
				OR rmcfi.rmcfi_field_precision IS NOT NULL
				OR rmcfi.rmcfi_field_currency != '$'
				OR rmcfi.rmcfi_field_decimal != '.'
				OR rmcfi.rmcfi_field_group != ','
				-- OR rmcfi.rmcfi_field_trim_type != 'none' -- we do not want to trim raw input data
				OR rmcfi.rmcfi_field_trim_type != 'both' -- TODO: remove this line and uncomment line above before moving to prod
			)
		)
	OR
	-- if the row is a Integer, then other columns should be configured with standard values
	(
				rmcfi.rmcfi_field_type = 'Integer' AND (
				rmcfi.rmcfi_field_format IS NOT NULL
				OR rmcfi.rmcfi_field_decimal != '.'
				OR rmcfi.rmcfi_field_group != ','
				OR rmcfi.rmcfi_field_trim_type != 'none' -- we do not want to trim raw input data
			)
		)
	OR
	-- if the row is a Number, then other columns should be configured with standard values
	(
				rmcfi.rmcfi_field_type = 'Number' AND (
					rmcfi.rmcfi_field_decimal != '.'
				OR rmcfi.rmcfi_field_group != ','
				OR rmcfi.rmcfi_field_trim_type != 'none' -- we do not want to trim raw input data
			)
		)
	OR
	-- if the row is a Date, then other columns should be configured with standard values
	(
				rmcfi.rmcfi_field_type = 'Date' AND (
				rmcfi.rmcfi_field_format IS NULL
				OR rmcfi.rmcfi_field_length IS NOT NULL
				OR rmcfi.rmcfi_field_precision IS NOT NULL
				OR rmcfi.rmcfi_field_currency != '$'
				OR rmcfi.rmcfi_field_decimal != '.'
				OR rmcfi.rmcfi_field_group != ','
				OR rmcfi.rmcfi_field_trim_type != 'none' -- we do not want to trim raw input data
			)
		)
ORDER BY
	smcfi.smcfi_process_name DESC
	, rmcfi_field_order DESC
;