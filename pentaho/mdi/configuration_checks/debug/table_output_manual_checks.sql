-- Asana: https://app.asana.com/0/0/1198065847802233


--
-- This example shows how we can identify the exact field that is erroring but is less readable (these tables will rarely change)
--


-- Table: step_metadata_table_output
SELECT
	smto.smto_process_name
	, 'mdi.step_metadata_table_output' AS table_name
	, smto.smto_step_definition_id


	-- check values are in valid domains
	, CASE
		  WHEN smto.smto_use_batch_update IN ('Y', 'N')
			  THEN ''
		  WHEN smto.smto_use_batch_update IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain'
	END AS smto_use_batch_update_status
	, CASE
		  WHEN smto.smto_ignore_insert_errors IN ('Y', 'N')
			  THEN ''
		  WHEN smto.smto_ignore_insert_errors IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain'
	END AS smto_ignore_insert_errors_status
	, CASE
		  WHEN smto.smto_truncate_table IN ('Y', 'N')
			  THEN ''
		  WHEN smto.smto_truncate_table IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain'
	END AS smto_truncate_table_status
	, CASE
		  WHEN smto.smto_specify_database_fields IN ('Y', 'N')
			  THEN ''
		  WHEN smto.smto_specify_database_fields IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain'
	END AS smto_specify_database_fields_status
	, CASE
		  WHEN smto.smto_partition_over_tables IN ('Y', 'N')
			  THEN ''
		  WHEN smto.smto_partition_over_tables IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain'
	END AS smto_partition_over_tables_status
	, CASE
		  WHEN smto.smto_table_name_defined_in_field IN ('Y', 'N')
			  THEN ''
		  WHEN smto.smto_table_name_defined_in_field IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain'
	END AS smto_table_name_defined_in_field_status
	, CASE
		  WHEN smto.smto_return_auto_generated_key_field IN ('Y', 'N')
			  THEN ''
		  WHEN smto.smto_return_auto_generated_key_field IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain'
	END AS smto_return_auto_generated_key_field_status
	, CASE
		  WHEN smto.smto_table_name_defined_in_field = 'Y' AND
			   (smto.smto_table_name_field != '' OR smto.smto_table_name_field IS NOT NULL)
			  OR
			   smto.smto_table_name_defined_in_field = 'N'
			  THEN ''
		  WHEN smto.smto_table_name_defined_in_field = 'N' AND
			   (smto.smto_table_name_field IS NOT NULL OR smto.smto_table_name_field != '')
			  THEN 'ERROR: if smto_table_name_defined_in_field=N then smto_table_name_field should be null or blank'
		  ELSE 'ERROR: if smto_table_name_defined_in_field=Y then smto_table_name_field should not be blank'
	END AS smto_table_name_defined_in_field_config_status

FROM
	mdi.step_metadata_table_output smto;



--
-- Verify all step definition IDs in row_metadata_table_output are configured with at least one row in step_metadata_table_output
--
SELECT
	rmto_row_definition_id
	, rmto_step_definition_id
	, 'ERROR: A row is configured with a value that is not in step_metadata_table_output. This record seems to have been orphaned!' AS "Error Message"
FROM
	mdi.row_metadata_table_output
WHERE
		row_metadata_table_output.rmto_step_definition_id NOT IN
		(SELECT step_metadata_table_output.smto_step_definition_id FROM mdi.step_metadata_table_output);


--
-- Verify all step definition IDs in step_metadata_table_output are configured with at least one row in row_metadata_table_output
--
SELECT
	smto_process_name
	, smto_step_definition_id
	, 'ERROR: A row is configured with a value that is not row_metadata_table_output. Either rows need to be added to row_metadata_table_output to finish configuring this or this step definition id needs to be deleted.' AS "Error Message"
FROM
	mdi.step_metadata_table_output
WHERE
		step_metadata_table_output.smto_step_definition_id NOT IN
		(SELECT row_metadata_table_output.rmto_step_definition_id FROM mdi.row_metadata_table_output);


--
-- Verify all step definition IDs in step_metadata_table_output are configured with at least one row in row_metadata_table_output
--
SELECT
	pr_process_name
	, pr_sp_name
	, pr_description
	, 'ERROR: A row is configured with a value that is not in step_metadata_table_output. Either rows need to be added to step_metadata_table_output and row_metadata_table_output to finish configuring this or this process name needs to be deleted.' AS "Error Message"
FROM
	mdi.process
WHERE
		process.pr_process_name NOT IN (SELECT smto_process_name FROM mdi.step_metadata_table_output);


















--
-- Verify all rows in row_metadata_csv_file_input are configured correctly based on the data type of the row compared to what else is configured in the table
--


SELECT
	'mdi.row_metadata_csv_file_input' AS "Misconfigured Table Name"
	, smcfi.smcfi_process_name
	, smcfi.smcfi_step_definition_id
	, rmcfi.rmcfi_field_name as "Misconfigured Field Name"

	-- check values are in valid domains
	, CASE
		  WHEN LENGTH(rmcfi.rmcfi_field_name) > 0
			  THEN ''
		  ELSE 'ERROR: column is not at least 1 character long'
	END AS rmcfi_field_name_status

	, CASE
		  WHEN rmcfi.rmcfi_field_type IN ('String', 'Integer', 'Date', 'Boolean', 'Number', 'Timestamp', 'BigNumber', 'Boolean')
			  THEN ''
		  WHEN rmcfi.rmcfi_field_type IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain. Expected values: String, Integer, Date, Boolean, Number, Timestamp, BigNumber, Boolean. Configured value is ''' || rmcfi.rmcfi_field_type || ''''
	END AS rmcfi_field_type_status

	, CASE
		  WHEN rmcfi.rmcfi_field_currency = '$'
			  THEN ''
		  WHEN rmcfi.rmcfi_field_currency IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain. Expected values: ''$'' but the configured value is ''' || rmcfi.rmcfi_field_currency || ''''
	END AS rmcfi_field_currency_status

	, CASE
		  WHEN rmcfi.rmcfi_field_decimal = '.'
			  THEN ''
		  WHEN rmcfi.rmcfi_field_decimal IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain. Expected values: ''.'' but the configured value is ''' || rmcfi.rmcfi_field_decimal || ''''
	END AS rmcfi_field_decimal_status

	, CASE
		  WHEN rmcfi.rmcfi_field_group = ','
			  THEN ''
		  WHEN rmcfi.rmcfi_field_group IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain. Expected values: '','' but the configured value is ''' || rmcfi.rmcfi_field_group || ''''
	END AS rmcfi_field_group_status

	, CASE
		  WHEN rmcfi.rmcfi_field_trim_type IN ('both', 'none', 'left', 'right')
			  THEN ''
		  WHEN rmcfi.rmcfi_field_trim_type IS NULL
			  THEN ''
		  ELSE 'ERROR: column is not configured with a value in the setting''s domain. Expected values: both, none, left, right. Configured value is ''' || rmcfi.rmcfi_field_trim_type || ''''
	END AS rmcfi_field_trim_type_status

	, CASE
	    -- String
	    WHEN rmcfi.rmcfi_field_type = 'String' AND rmcfi.rmcfi_field_format IS NOT NULL THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_format is *not* NULL.'
		WHEN rmcfi.rmcfi_field_type = 'String' AND rmcfi.rmcfi_field_length IS NOT NULL THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_length is *not* NULL.'
		WHEN rmcfi.rmcfi_field_type = 'String' AND rmcfi.rmcfi_field_precision IS NOT NULL THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_precision is *not* NULL.'
		WHEN rmcfi.rmcfi_field_type = 'String' AND rmcfi.rmcfi_field_currency != '$' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_currency is *not* ''$''.'
		WHEN rmcfi.rmcfi_field_type = 'String' AND rmcfi.rmcfi_field_decimal != '.' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_decimal is *not* ''.''.'
		WHEN rmcfi.rmcfi_field_type = 'String' AND rmcfi.rmcfi_field_group != ',' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_group is *not* '',''.'
		WHEN rmcfi.rmcfi_field_type = 'String' AND rmcfi.rmcfi_field_trim_type != 'none' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_trim_type is *not* ''none''.'
		-- Integer
	    WHEN rmcfi.rmcfi_field_type = 'Integer' AND rmcfi.rmcfi_field_format IS NOT NULL THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_format is *not* NULL'
		WHEN rmcfi.rmcfi_field_type = 'Integer' AND rmcfi.rmcfi_field_decimal != '.' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_decimal is *not* ''.''.'
		WHEN rmcfi.rmcfi_field_type = 'Integer' AND rmcfi.rmcfi_field_group != ',' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_group is *not* '',''.'
		WHEN rmcfi.rmcfi_field_type = 'Integer' AND rmcfi.rmcfi_field_trim_type != 'none' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_trim_type is *not* ''none''.'

	    -- Number
		WHEN rmcfi.rmcfi_field_type = 'Number' AND rmcfi.rmcfi_field_decimal != '.' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_decimal is *not* ''.''.'
		WHEN rmcfi.rmcfi_field_type = 'Number' AND rmcfi.rmcfi_field_group != ',' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_group is *not* '',''.'
		WHEN rmcfi.rmcfi_field_type = 'Number' AND rmcfi.rmcfi_field_trim_type != 'none' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_trim_type is *not* ''none''.'

	    -- Date
		WHEN rmcfi.rmcfi_field_type = 'Date' AND rmcfi.rmcfi_field_format IS NULL THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_format *is* NULL.'
		WHEN rmcfi.rmcfi_field_type = 'Date' AND rmcfi.rmcfi_field_precision IS NOT NULL THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_precision is *not* NULL.'
		WHEN rmcfi.rmcfi_field_type = 'Date' AND rmcfi.rmcfi_field_currency != '$' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_currency is *not* ''$''.'
		WHEN rmcfi.rmcfi_field_type = 'Date' AND rmcfi.rmcfi_field_decimal != '.' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_decimal is *not* ''.''.'
		WHEN rmcfi.rmcfi_field_type = 'Date' AND rmcfi.rmcfi_field_group != ',' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_group is *not* '',''.'
		WHEN rmcfi.rmcfi_field_type = 'Date' AND rmcfi.rmcfi_field_trim_type != 'none' THEN 'ERROR: rmcfi_field_type is configured as ' || rmcfi.rmcfi_field_type || ' but rmcfi_field_trim_type is *not* ''none''.'

	    ELSE ''
	end as rmcfi_field_type_config_status

FROM
	mdi.row_metadata_csv_file_input AS rmcfi
		JOIN mdi.step_metadata_csv_file_input AS smcfi
		ON smcfi.smcfi_step_definition_id = rmcfi.rmcfi_step_definition_id
Order By
	smcfi.smcfi_process_name DESC
	, rmcfi.rmcfi_last_updated DESC;





