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
