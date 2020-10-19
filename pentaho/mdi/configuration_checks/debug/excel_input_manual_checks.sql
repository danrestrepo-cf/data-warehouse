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
