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
