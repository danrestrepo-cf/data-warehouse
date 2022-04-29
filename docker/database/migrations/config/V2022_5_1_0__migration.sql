--
-- EDW | ETL-200028 (transaction_aux_govt_programs_dim insert/update): Fix join on prp_cema in ETL query
-- https://app.asana.com/0/0/1202163275833617
--

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('ETL-200028', 1, 'WITH transaction_aux_govt_programs_dim_incl_new_records AS (
	SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
		, COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
		  COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
		, NOW() AS edw_created_datetime
		, NOW() AS edw_modified_datetime
		, proposal.data_source_updated_datetime AS data_source_modified_datetime
		, transaction_dim.dwid AS transaction_dwid
		, deal.d_pid AS deal_pid
		, proposal.prp_pid AS active_proposal_pid
		, proposal.prp_fha_mip_refund_request_input_error AS fha_mip_refund_request_input_error_flag
		, proposal.prp_fha_non_arms_length_ltv_exception_verified AS fha_non_arms_length_ltv_exception_verified_flag
      , proposal.prp_request_fha_mip_refund_required AS request_fha_mip_refund_required_flag
      , proposal.prp_texas_equity_conversion_determination_datetime_override AS texas_equity_conversion_determination_datetime_override_flag
      , proposal.prp_texas_equity_determination_datetime_override AS texas_equity_determination_datetime_override_flag
      , proposal.prp_va_maintenance_utilities_auto_compute AS va_maintenance_utilities_auto_compute_flag
      , proposal.prp_fha_prior_agency_case_endorsement_date AS fha_prior_agency_case_endorsement_date
      , proposal.prp_fha_refinance_authorization_expiration_date AS fha_refinance_authorization_expiration_date
      , proposal.prp_texas_equity_determination_datetime AS texas_equity_determination_datetime
      , proposal.prp_usda_gsa_sam_checked_date AS usda_gsa_sam_checked_date
      , proposal.prp_va_notice_of_value_date AS va_notice_of_value_date
      , proposal.prp_cema_borrower_savings AS cema_borrower_savings
      , proposal.prp_fha_va_reasonable_value_amount AS fha_va_reasonable_value_amount
      , proposal.prp_va_actual_guaranty_amount AS va_actual_guaranty_amount
      , proposal.prp_va_amount_used_to_calculate_maximum_guaranty AS va_amount_used_to_calculate_maximum_guaranty
      , proposal.prp_va_energy_efficient_improvements_amount AS va_energy_efficient_improvements_amount
      , proposal.prp_va_guaranty_percent AS va_guaranty_percent
      , proposal.prp_va_maintenance_utilities_per_square_feet_amount AS va_maintenance_utilities_per_square_feet_amount
      , proposal.prp_va_maximum_base_loan_amount AS va_maximum_base_loan_amount
      , proposal.prp_va_maximum_funding_fee_amount AS va_maximum_funding_fee_amount
      , proposal.prp_va_maximum_total_loan_amount AS va_maximum_total_loan_amount
      , proposal.prp_va_monthly_maintenance_utilities_amount AS va_monthly_maintenance_utilities_amount
      , proposal.prp_va_notice_of_value_estimated_reasonable_value_amount AS va_notice_of_value_estimated_reasonable_value_amount
      , proposal.prp_va_required_cash_amount AS va_required_cash_amount
      , proposal.prp_va_required_guaranty_amount AS va_required_guaranty_amount
      , proposal.prp_fha_prior_agency_case_id AS fha_prior_agency_case_id
      , proposal.prp_fha_refinance_authorization_number AS fha_refinance_authorization_number
      , proposal.prp_fhac_refinance_authorization_messages AS fhac_refinance_authorization_messages
      , proposal.prp_texas_equity_conversion_determ_datetime_override_reason AS texas_equity_conversion_determ_datetime_override_reason
      , proposal.prp_texas_equity_determination_datetime_override_reason AS texas_equity_determination_datetime_override_reason
      , proposal.prp_va_prior_paid_in_full_loan_number AS va_prior_paid_in_full_loan_number
    	, fha_non_arms_length_ltv_limit_exception_type.value AS fha_non_arms_length_ltv_exception
    	, proposal.prp_fha_non_arms_length_ltv_exception_type AS fha_non_arms_length_ltv_exception_code
    	, hud_fha_de_approval_type.value AS hud_fha_de_approval
    	, proposal.prp_hud_fha_de_approval_type AS hud_fha_de_approval_code
    	, usda_rd_single_family_housing_type.value AS usda_rd_single_family_housing
    	, proposal.prp_usda_rd_single_family_housing_type AS usda_rd_single_family_housing_code
    	, va_notice_of_value_source_type.value AS va_notice_of_value_source
    	, proposal.prp_va_notice_of_value_source_type AS va_notice_of_value_source_code
    	, va_past_credit_record_type.value AS va_past_credit_record
    	, proposal.prp_va_past_credit_record_type AS va_past_credit_record_code
    	, cema_ynnau_type.value AS cema
    	, proposal.prp_cema AS cema_code
	    , fha_eligible_maximum_financing_ynu_type.value AS fha_eligible_maximum_financing
    	, proposal.prp_fha_eligible_maximum_financing AS fha_eligible_maximum_financing_code
    	, usda_gsa_sam_exclusion_ynu_type.value AS usda_gsa_sam_exclusion
	    , proposal.prp_usda_gsa_sam_exclusion AS usda_gsa_sam_exclusion_code
		, va_meets_credit_standards_ynu_type.value AS va_meets_credit_standards
	    , proposal.prp_va_meets_credit_standards AS va_meets_credit_standards_code
    	, va_monthly_utilities_included_ynu_type.value AS va_monthly_utilities_included
	    , proposal.prp_va_monthly_utilities_included AS va_monthly_utilities_included_code
		, GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, fha_non_arms_length_ltv_limit_exception_type
		    .etl_end_date_time, hud_fha_de_approval_type.etl_end_date_time, usda_rd_single_family_housing_type
		        .etl_end_date_time, va_notice_of_value_source_type.etl_end_date_time, va_past_credit_record_type
		            .etl_end_date_time, cema_ynnau_type.etl_end_date_time, fha_eligible_maximum_financing_ynu_type
		                .etl_end_date_time, usda_gsa_sam_exclusion_ynu_type.etl_end_date_time,
		    va_meets_credit_standards_ynu_type.etl_end_date_time, va_monthly_utilities_included_ynu_type
		        .etl_end_date_time, transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
	FROM (
		SELECT <<deal_partial_load_condition>> AS include_record
			, deal.*
			, etl_log.etl_end_date_time
		FROM history_octane.deal
			LEFT JOIN history_octane.deal AS history_records
				ON deal.d_pid = history_records.d_pid
					AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
			JOIN star_common.etl_log
				ON deal.etl_batch_id = etl_log.etl_batch_id
		WHERE history_records.d_pid IS NULL
	) AS deal
		JOIN (
			SELECT *
			FROM (
				SELECT <<proposal_partial_load_condition>> AS include_record
					, proposal.*
					, etl_log.etl_end_date_time
				FROM history_octane.proposal
					LEFT JOIN history_octane.proposal AS history_records
						ON proposal.prp_pid = history_records.prp_pid
							AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON proposal.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.prp_pid IS NULL
			) AS primary_table
		) AS proposal
			ON deal.d_active_proposal_pid = proposal.prp_pid
		JOIN (
		    SELECT *
		    FROM (
		        SELECT <<fha_non_arms_length_ltv_limit_exception_type_partial_load_condition>> AS include_record
		        	, fha_non_arms_length_ltv_limit_exception_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.fha_non_arms_length_ltv_limit_exception_type
		        	LEFT JOIN history_octane.fha_non_arms_length_ltv_limit_exception_type AS history_records
		        		ON fha_non_arms_length_ltv_limit_exception_type.code = history_records.code
		        			AND fha_non_arms_length_ltv_limit_exception_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON fha_non_arms_length_ltv_limit_exception_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS fha_non_arms_length_ltv_limit_exception_type
	    		ON proposal.prp_fha_non_arms_length_ltv_exception_type = fha_non_arms_length_ltv_limit_exception_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<hud_fha_de_approval_type_partial_load_condition>> AS include_record
	            	, hud_fha_de_approval_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.hud_fha_de_approval_type
	            	LEFT JOIN history_octane.hud_fha_de_approval_type AS history_records
	            		ON hud_fha_de_approval_type.code = history_records.code
	            			AND hud_fha_de_approval_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON hud_fha_de_approval_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS hud_fha_de_approval_type
	    	ON proposal.prp_hud_fha_de_approval_type = hud_fha_de_approval_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<usda_rd_single_family_housing_type_partial_load_condition>> AS include_record
	            	, usda_rd_single_family_housing_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.usda_rd_single_family_housing_type
	            	LEFT JOIN history_octane.usda_rd_single_family_housing_type AS history_records
	            		ON usda_rd_single_family_housing_type.code = history_records.code
	            			AND usda_rd_single_family_housing_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON usda_rd_single_family_housing_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS usda_rd_single_family_housing_type
			ON proposal.prp_usda_rd_single_family_housing_type = usda_rd_single_family_housing_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<va_notice_of_value_source_type_partial_load_condition>> AS include_record
	            	, va_notice_of_value_source_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.va_notice_of_value_source_type
	            	LEFT JOIN history_octane.va_notice_of_value_source_type AS history_records
	            		ON va_notice_of_value_source_type.code = history_records.code
	            			AND va_notice_of_value_source_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON va_notice_of_value_source_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_notice_of_value_source_type
	    	ON proposal.prp_va_notice_of_value_source_type = va_notice_of_value_source_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<va_past_credit_record_type_partial_load_condition>> AS include_record
	            	, va_past_credit_record_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.va_past_credit_record_type
	            	LEFT JOIN history_octane.va_past_credit_record_type AS history_records
	            		ON va_past_credit_record_type.code = history_records.code
	            			AND va_past_credit_record_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON va_past_credit_record_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_past_credit_record_type
	    	ON proposal.prp_va_past_credit_record_type = va_past_credit_record_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<yes_no_na_unknown_type_partial_load_condition>> AS include_record
	            	, yes_no_na_unknown_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.yes_no_na_unknown_type
	            	LEFT JOIN history_octane.yes_no_na_unknown_type AS history_records
	            		ON yes_no_na_unknown_type.code = history_records.code
	            			AND yes_no_na_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON yes_no_na_unknown_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
				) AS primary_table
			) AS cema_ynnau_type
	    		ON proposal.prp_cema = cema_ynnau_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
	            	, yes_no_unknown_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.yes_no_unknown_type
	            	LEFT JOIN history_octane.yes_no_unknown_type AS history_records
	            		ON yes_no_unknown_type.code = history_records.code
	            			AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS fha_eligible_maximum_financing_ynu_type
	    		ON proposal.prp_fha_eligible_maximum_financing = fha_eligible_maximum_financing_ynu_type.code
		JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS usda_gsa_sam_exclusion_ynu_type
	    	ON proposal.prp_usda_gsa_sam_exclusion = usda_gsa_sam_exclusion_ynu_type.code
		JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_meets_credit_standards_ynu_type
	    	ON proposal.prp_va_meets_credit_standards = va_meets_credit_standards_ynu_type.code
		JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_monthly_utilities_included_ynu_type
	    	ON proposal.prp_va_monthly_utilities_included = va_monthly_utilities_included_ynu_type.code
		JOIN (
			SELECT <<transaction_dim_partial_load_condition>> AS include_record
				, transaction_dim.*
				, etl_log.etl_end_date_time
			FROM star_loan.transaction_dim
				JOIN star_common.etl_log
					ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
		) AS transaction_dim
			ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, fha_non_arms_length_ltv_limit_exception_type
		.include_record, hud_fha_de_approval_type.include_record, usda_rd_single_family_housing_type
					   .include_record, va_notice_of_value_source_type.include_record, va_past_credit_record_type
					   .include_record, cema_ynnau_type.include_record, fha_eligible_maximum_financing_ynu_type
					   .include_record, usda_gsa_sam_exclusion_ynu_type.include_record,
				   va_meets_credit_standards_ynu_type.include_record, va_monthly_utilities_included_ynu_type
					   .include_record, transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_govt_programs_dim_incl_new_records.*
FROM transaction_aux_govt_programs_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_govt_programs_dim
	ON transaction_aux_govt_programs_dim_incl_new_records.data_source_integration_id =
	   transaction_aux_govt_programs_dim.data_source_integration_id
WHERE transaction_aux_govt_programs_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_govt_programs_dim_incl_new_records.*
FROM transaction_aux_govt_programs_dim_incl_new_records
JOIN (
    SELECT transaction_aux_govt_programs_dim.data_source_integration_id
    	, etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_govt_programs_dim
    	JOIN star_common.etl_log
    		ON transaction_aux_govt_programs_dim.etl_batch_id = etl_log.etl_batch_id
		) AS transaction_aux_govt_programs_dim_etl_start_times
		ON transaction_aux_govt_programs_dim_incl_new_records.data_source_integration_id =
		   transaction_aux_govt_programs_dim_etl_start_times.data_source_integration_id
			AND transaction_aux_govt_programs_dim_incl_new_records.max_source_etl_end_date_time >=
			    transaction_aux_govt_programs_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
         JOIN mdi.process
              ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;

--
-- EDW | move transaction_dim subject property and borrower_dim borrower residence columns to their own aux dimensions
-- https://app.asana.com/0/0/1202075961150519
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
	VALUES ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'staging', 'history_octane', 'borrower')
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'staging', 'history_octane', 'deal')
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
	LEFT JOIN mdi.edw_table_definition source_table_definition
		ON insert_rows.source_database_name = source_table_definition.database_name
			AND insert_rows.source_schema_name = source_table_definition.schema_name
			AND insert_rows.source_table_name = source_table_definition.table_name;

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
	VALUES ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'borrower_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'street1', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'street2', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'city', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'postal_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'county_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'county_fips', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'state', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'state_fips', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'country_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'country', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'transaction_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'street1', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'street2', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'city', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'tax_id', 'VARCHAR(64)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'postal_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'county_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'county_fips', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'state', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'state_fips', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'country_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'country', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'year_built', 'INTEGER', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'property_category_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'property_category', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'building_status_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'building_status', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'rental_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'property_rights_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'property_rights', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'neighborhood_location_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'neighborhood_location', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
FROM insert_rows
	JOIN mdi.edw_table_definition
		ON insert_rows.database_name = edw_table_definition.database_name
			AND insert_rows.schema_name = edw_table_definition.schema_name
			AND insert_rows.table_name = edw_table_definition.table_name
	LEFT JOIN mdi.edw_table_definition source_table_definition
		ON insert_rows.source_database_name = source_table_definition.database_name
			AND insert_rows.source_schema_name = source_table_definition.schema_name
			AND insert_rows.source_table_name = source_table_definition.table_name
	LEFT JOIN mdi.edw_field_definition source_field_definition
		ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
			AND insert_rows.source_field_name = source_field_definition.field_name;

WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
	VALUES ('staging', 'star_loan', 'borrower_aux_current_residence_dim', 'borrower_pid', 'BIGINT', 'staging', 'history_octane', 'borrower', 'b_pid')
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'deal_pid', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_pid')
		, ('staging', 'star_loan', 'transaction_aux_subject_property_dim', 'active_proposal_pid', 'BIGINT', 'staging', 'history_octane', 'proposal', 'prp_pid')
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
FROM insert_rows
	JOIN mdi.edw_table_definition
		ON insert_rows.database_name = edw_table_definition.database_name
			AND insert_rows.schema_name = edw_table_definition.schema_name
			AND insert_rows.table_name = edw_table_definition.table_name
	LEFT JOIN mdi.edw_table_definition source_table_definition
		ON insert_rows.source_database_name = source_table_definition.database_name
			AND insert_rows.source_schema_name = source_table_definition.schema_name
			AND insert_rows.source_table_name = source_table_definition.table_name
	LEFT JOIN mdi.edw_field_definition source_field_definition
		ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
			AND insert_rows.source_field_name = source_field_definition.field_name;

--process
INSERT
INTO mdi.process (name, description)
VALUES ('ETL-200040', 'ETL to insert_update records into staging.star_loan.borrower_aux_current_residence_dim using staging.history_octane.borrower as the primary source')
	, ('ETL-200041', 'ETL to insert_update records into staging.star_loan.transaction_aux_subject_property_dim using staging.history_octane.deal as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
	VALUES ('ETL-200040', 1, 'WITH borrower_aux_current_residence_dim_incl_new_records AS (
	SELECT ''borrower_pid~data_source_dwid'' AS data_source_integration_columns
		, COALESCE(CAST(borrower.b_pid AS TEXT), ''<NULL>'') || ''~1'' AS data_source_integration_id
		, NOW() AS edw_created_datetime
		, NOW() AS edw_modified_datetime
		, borrower.data_source_updated_datetime AS data_source_modified_datetime
		, borrower_dim.dwid AS borrower_dwid
		, borrower.b_pid AS borrower_pid
		, current_borrower_residence_place.pl_street1 AS street1
		, current_borrower_residence_place.pl_street2 AS street2
		, current_borrower_residence_place.pl_city AS city
		, current_borrower_residence_place.pl_postal_code AS postal_code
		, county.c_name AS county_name
		, current_borrower_residence_place.pl_county_fips AS county_fips
		, current_borrower_residence_place.pl_state AS state
		, current_borrower_residence_place.pl_state_fips AS state_fips
		, current_borrower_residence_place.pl_country AS country_code
		, country_type.value AS country
		, GREATEST(borrower.etl_end_date_time, current_borrower_residence.etl_end_date_time,
				   current_borrower_residence_place.etl_end_date_time, county.etl_end_date_time, country_type
					   .etl_end_date_time) AS max_source_etl_end_date_time
	FROM (
		SELECT <<borrower_partial_load_condition>> AS include_record
			, borrower.*
			, etl_log.etl_end_date_time
		FROM history_octane.borrower
			LEFT JOIN history_octane.borrower AS history_records
				ON borrower.b_pid = history_records.b_pid
					AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
			JOIN star_common.etl_log
				ON borrower.etl_batch_id = etl_log.etl_batch_id
		WHERE history_records.b_pid IS NULL
	) AS borrower
		JOIN (
			SELECT <<borrower_residence_partial_load_condition>> AS include_record
				, borrower_residence.*
				, etl_log.etl_end_date_time
			FROM history_octane.borrower_residence
				LEFT JOIN history_octane.borrower_residence AS history_records
					ON borrower_residence.bres_pid = history_records.bres_pid
						AND borrower_residence.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON borrower_residence.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.bres_pid IS NULL
		) AS current_borrower_residence
			ON borrower.b_pid = current_borrower_residence.bres_borrower_pid
				AND current_borrower_residence.bres_current IS TRUE
		JOIN (
			SELECT <<place_partial_load_condition>> AS include_record
				, place.*
				, etl_log.etl_end_date_time
			FROM history_octane.place
				LEFT JOIN history_octane.place AS history_records
					ON place.pl_pid = history_records.pl_pid
						AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON place.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.pl_pid IS NULL
		) AS current_borrower_residence_place
			ON current_borrower_residence.bres_place_pid = current_borrower_residence_place.pl_pid
		LEFT JOIN (
			SELECT <<county_partial_load_condition>> AS include_record
				, county.*
				, etl_log.etl_end_date_time
			FROM history_octane.county
				LEFT JOIN history_octane.county AS history_records
					ON county.c_pid = history_records.c_pid
						AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON county.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.c_pid IS NULL
		) AS county
			ON current_borrower_residence_place.pl_county_pid = county.c_pid
		JOIN (
			SELECT <<country_type_partial_load_condition>> AS include_record
				, country_type.*
				, etl_log.etl_end_date_time
			FROM history_octane.country_type
				LEFT JOIN history_octane.country_type AS history_records
					ON country_type.code = history_records.code
						AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON country_type.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.code IS NULL
		) AS country_type
			ON current_borrower_residence_place.pl_country = country_type.code
		JOIN (
			SELECT <<borrower_dim_partial_load_condition>> AS include_record
				, borrower_dim.*
				, etl_log.etl_end_date_time
			FROM star_loan.borrower_dim
				JOIN star_common.etl_log ON borrower_dim.etl_batch_id = etl_log.etl_batch_id
		) AS borrower_dim
			ON borrower.b_pid = borrower_dim.borrower_pid
	WHERE GREATEST(borrower.include_record, current_borrower_residence.include_record,
				   current_borrower_residence_place.include_record, county.include_record, country_type.include_record) IS TRUE
)
-- new records that should be inserted
SELECT borrower_aux_current_residence_dim_incl_new_records.*
FROM borrower_aux_current_residence_dim_incl_new_records
	LEFT JOIN star_loan.borrower_aux_current_residence_dim
		ON borrower_aux_current_residence_dim_incl_new_records.data_source_integration_id =
		   borrower_aux_current_residence_dim.data_source_integration_id
WHERE borrower_aux_current_residence_dim.borrower_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT borrower_aux_current_residence_dim_incl_new_records.*
FROM borrower_aux_current_residence_dim_incl_new_records
	JOIN (
		SELECT borrower_aux_current_residence_dim.data_source_integration_id
			, etl_log.etl_start_date_time
		FROM star_loan.borrower_aux_current_residence_dim
			JOIN star_common.etl_log
				ON borrower_aux_current_residence_dim.etl_batch_id = etl_log.etl_batch_id
	) AS borrower_aux_current_residence_dim_etl_start_times
		ON borrower_aux_current_residence_dim_incl_new_records.data_source_integration_id =
		   borrower_aux_current_residence_dim_etl_start_times.data_source_integration_id
			AND borrower_aux_current_residence_dim_incl_new_records.max_source_etl_end_date_time >=
				borrower_aux_current_residence_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200041', 1, 'WITH transaction_aux_subject_property_dim_incl_new_records AS (
	SELECT ''deal_pid~data_source_dwid'' AS data_source_integration_columns
		, COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~1'' AS data_source_integration_id
		, NOW() AS edw_created_datetime
		, NOW() AS edw_modified_datetime
		, deal.data_source_updated_datetime AS data_source_modified_datetime
		, transaction_dim.dwid AS transaction_dwid
		, deal.d_pid AS deal_pid
		, proposal.prp_pid AS active_proposal_pid
		, subject_property.pl_street1 AS street1
		, subject_property.pl_street2 AS street2
		, subject_property.pl_city subject_property_city
		, subject_property.pl_property_tax_id AS tax_id
		, subject_property.pl_postal_code AS postal_code
		, county.c_name AS county_name
		, subject_property.pl_county_fips AS county_fips
		, subject_property.pl_state AS state
		, subject_property.pl_state_fips subject_property_state_fips
		, subject_property.pl_country AS country_code
		, country_type.value AS country
		, subject_property.pl_structure_built_year AS year_built
		, subject_property.pl_property_category_type AS property_category_code
		, property_category_type.value AS property_category
		, subject_property.pl_building_status_type AS building_status_code
		, building_status_type.value AS building_status
		, subject_property.pl_rental AS rental_flag
		, subject_property.pl_property_rights_type AS property_rights_code
		, property_rights_type.value AS property_rights
		, subject_property.pl_neighborhood_location_type AS neighborhood_location_code
		, neighborhood_location_type.value AS neighborhood_location
		, GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, subject_property.etl_end_date_time, county
		.etl_end_date_time, country_type.etl_end_date_time, property_category_type.etl_end_date_time,
				   building_status_type.etl_end_date_time, neighborhood_location_type.etl_end_date_time,
		    transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
	FROM (
		SELECT <<deal_partial_load_condition>> AS include_record
			, deal.*
			, etl_log.etl_end_date_time
		FROM history_octane.deal
			LEFT JOIN history_octane.deal AS history_records
				ON deal.d_pid = history_records.d_pid
					AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
			JOIN star_common.etl_log
				ON deal.etl_batch_id = etl_log.etl_batch_id
		WHERE history_records.d_pid IS NULL
	) AS deal
		JOIN (
			SELECT <<proposal_partial_load_condition>> AS include_record
				, proposal.*
				, etl_log.etl_end_date_time
			FROM history_octane.proposal
				LEFT JOIN history_octane.proposal AS history_records
					ON proposal.prp_pid = history_records.prp_pid
						AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON proposal.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.prp_pid IS NULL
		) AS proposal
			ON deal.d_active_proposal_pid = proposal.prp_pid
		JOIN (
			SELECT <<place_partial_load_condition>> AS include_record
				, place.*
				, etl_log.etl_end_date_time
			FROM history_octane.place
				LEFT JOIN history_octane.place AS history_records
					ON place.pl_pid = history_records.pl_pid
						AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON place.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.pl_pid IS NULL
		) AS subject_property
			ON proposal.prp_pid = subject_property.pl_proposal_pid
				AND subject_property.pl_subject_property IS TRUE
		LEFT JOIN (
			SELECT <<county_partial_load_condition>> AS include_record
				, county.*
				, etl_log.etl_end_date_time
			FROM history_octane.county
				LEFT JOIN history_octane.county AS history_records
					ON county.c_pid = history_records.c_pid
						AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON county.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.c_pid IS NULL
		) AS county ON subject_property.pl_county_pid = county.c_pid
		JOIN (
			SELECT <<country_type_partial_load_condition>> AS include_record
				, country_type.*
				, etl_log.etl_end_date_time
			FROM history_octane.country_type
				LEFT JOIN history_octane.country_type AS history_records
					ON country_type.code = history_records.code
						AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON country_type.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.code IS NULL
		) AS country_type ON subject_property.pl_country = country_type.code
		JOIN (
			SELECT <<property_category_type_partial_load_condition>> AS include_record
				, property_category_type.*
				, etl_log.etl_end_date_time
			FROM history_octane.property_category_type
				LEFT JOIN history_octane.property_category_type AS history_records
					ON property_category_type.code = history_records.code
						AND property_category_type.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON property_category_type.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.code IS NULL
		) AS property_category_type ON subject_property.pl_property_category_type = property_category_type.code
		JOIN (
			SELECT <<building_status_type_partial_load_condition>> AS include_record
				, building_status_type.*
				, etl_log.etl_end_date_time
			FROM history_octane.building_status_type
				LEFT JOIN history_octane.building_status_type AS history_records
					ON building_status_type.code = history_records.code
						AND building_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON building_status_type.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.code IS NULL
		) AS building_status_type ON subject_property.pl_building_status_type = building_status_type.code
		JOIN (
			SELECT <<property_rights_type_partial_load_condition>> AS include_record
				, property_rights_type.*
				, etl_log.etl_end_date_time
			FROM history_octane.property_rights_type
				LEFT JOIN history_octane.property_rights_type AS history_records
					ON property_rights_type.code = history_records.code
						AND property_rights_type.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON property_rights_type.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.code IS NULL
		) AS property_rights_type ON subject_property.pl_property_rights_type = property_rights_type.code
		JOIN (
			SELECT <<neighborhood_location_type_partial_load_condition>> AS include_record
				, neighborhood_location_type.*
				, etl_log.etl_end_date_time
			FROM history_octane.neighborhood_location_type
				LEFT JOIN history_octane.neighborhood_location_type AS history_records
					ON neighborhood_location_type.code = history_records.code
						AND neighborhood_location_type.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log ON neighborhood_location_type.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.code IS NULL
		) AS neighborhood_location_type ON subject_property.pl_neighborhood_location_type = neighborhood_location_type.code
		JOIN (
		    SELECT <<transaction_dim_partial_load_condition>> AS include_record
		    	, transaction_dim.*
		    	, etl_log.etl_end_date_time
		    FROM star_loan.transaction_dim
		    	JOIN star_common.etl_log
		    		ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
			) AS transaction_dim
				ON deal.d_pid = transaction_dim.deal_pid
	WHERE GREATEST(deal.include_record, proposal.include_record, subject_property.include_record, county
		.include_record, country_type.include_record, property_category_type.include_record,
				   building_status_type.include_record, neighborhood_location_type.include_record, transaction_dim
				       .include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_subject_property_dim_incl_new_records.*
FROM transaction_aux_subject_property_dim_incl_new_records
	LEFT JOIN star_loan.transaction_aux_subject_property_dim
		ON transaction_aux_subject_property_dim_incl_new_records.data_source_integration_id =
		   transaction_aux_subject_property_dim.data_source_integration_id
WHERE transaction_aux_subject_property_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_subject_property_dim_incl_new_records.*
FROM transaction_aux_subject_property_dim_incl_new_records
	JOIN (
		SELECT transaction_aux_subject_property_dim.data_source_integration_id
			, etl_log.etl_start_date_time
		FROM star_loan.transaction_aux_subject_property_dim
			JOIN star_common.etl_log
				ON transaction_aux_subject_property_dim.etl_batch_id = etl_log.etl_batch_id
	) AS transaction_aux_subject_property_dim_etl_start_times
		ON transaction_aux_subject_property_dim_incl_new_records.data_source_integration_id =
		   transaction_aux_subject_property_dim_etl_start_times.data_source_integration_id
			AND transaction_aux_subject_property_dim_incl_new_records.max_source_etl_end_date_time >=
				transaction_aux_subject_property_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name;

--insert_update_step
WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (
	VALUES ('ETL-200040', 'Staging DB Connection', 'star_loan', 'borrower_aux_current_residence_dim')
		, ('ETL-200041', 'Staging DB Connection', 'star_loan', 'transaction_aux_subject_property_dim')
)
INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)
SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000, 'N'::mdi.pentaho_y_or_n
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name;

--insert_update_key
WITH insert_rows (process_name, key_lookup) AS (
	VALUES ('ETL-200040', 'data_source_integration_id')
		, ('ETL-200041', 'data_source_integration_id')
)
INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)
SELECT insert_update_step.dwid, insert_rows.key_lookup, insert_rows.key_lookup, NULL, '='
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name
	JOIN mdi.insert_update_step
		ON process.dwid = insert_update_step.process_dwid;

--insert_update_field
WITH insert_rows (process_name, update_lookup, update_flag) AS (
	VALUES ('ETL-200040', 'borrower_dwid', 'Y')
		, ('ETL-200040', 'data_source_dwid', 'Y')
		, ('ETL-200040', 'edw_created_datetime', 'N')
		, ('ETL-200040', 'edw_modified_datetime', 'Y')
		, ('ETL-200040', 'etl_batch_id', 'Y')
		, ('ETL-200040', 'data_source_integration_columns', 'N')
		, ('ETL-200040', 'data_source_integration_id', 'N')
		, ('ETL-200040', 'data_source_modified_datetime', 'Y')
		, ('ETL-200040', 'borrower_pid', 'N')
		, ('ETL-200040', 'street1', 'Y')
		, ('ETL-200040', 'street2', 'Y')
		, ('ETL-200040', 'city', 'Y')
		, ('ETL-200040', 'postal_code', 'Y')
		, ('ETL-200040', 'county_name', 'Y')
		, ('ETL-200040', 'county_fips', 'Y')
		, ('ETL-200040', 'state', 'Y')
		, ('ETL-200040', 'state_fips', 'Y')
		, ('ETL-200040', 'country_code', 'Y')
		, ('ETL-200040', 'country', 'Y')
		, ('ETL-200041', 'transaction_dwid', 'Y')
		, ('ETL-200041', 'data_source_dwid', 'Y')
		, ('ETL-200041', 'edw_created_datetime', 'N')
		, ('ETL-200041', 'edw_modified_datetime', 'Y')
		, ('ETL-200041', 'etl_batch_id', 'Y')
		, ('ETL-200041', 'data_source_integration_columns', 'N')
		, ('ETL-200041', 'data_source_integration_id', 'N')
		, ('ETL-200041', 'data_source_modified_datetime', 'Y')
		, ('ETL-200041', 'deal_pid', 'Y')
		, ('ETL-200041', 'active_proposal_pid', 'Y')
		, ('ETL-200041', 'street1', 'Y')
		, ('ETL-200041', 'street2', 'Y')
		, ('ETL-200041', 'city', 'Y')
		, ('ETL-200041', 'tax_id', 'Y')
		, ('ETL-200041', 'postal_code', 'Y')
		, ('ETL-200041', 'county_name', 'Y')
		, ('ETL-200041', 'county_fips', 'Y')
		, ('ETL-200041', 'state', 'Y')
		, ('ETL-200041', 'state_fips', 'Y')
		, ('ETL-200041', 'country_code', 'Y')
		, ('ETL-200041', 'country', 'Y')
		, ('ETL-200041', 'year_built', 'Y')
		, ('ETL-200041', 'property_category_code', 'Y')
		, ('ETL-200041', 'property_category', 'Y')
		, ('ETL-200041', 'building_status_code', 'Y')
		, ('ETL-200041', 'building_status', 'Y')
		, ('ETL-200041', 'rental_flag', 'Y')
		, ('ETL-200041', 'property_rights_code', 'Y')
		, ('ETL-200041', 'property_rights', 'Y')
		, ('ETL-200041', 'neighborhood_location_code', 'Y')
		, ('ETL-200041', 'neighborhood_location', 'Y')
)
INSERT
INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
SELECT insert_update_step.dwid, insert_rows.update_lookup, insert_rows.update_lookup, insert_rows.update_flag::mdi.pentaho_y_or_n, FALSE
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name
	JOIN mdi.insert_update_step
		ON process.dwid = insert_update_step.process_dwid;


--json_output_field
WITH insert_rows (process_name, json_output_field) AS (
	VALUES ('ETL-200040', 'data_source_integration_id')
		, ('ETL-200041', 'data_source_integration_id')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
	JOIN mdi.process
		ON insert_rows.process_name = process.name;
