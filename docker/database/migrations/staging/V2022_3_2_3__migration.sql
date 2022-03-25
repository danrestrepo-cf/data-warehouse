--
-- EDW | star_loan ETLs: Switch JOINs to county table to LEFT JOINs, backfill missing data
-- https://app.asana.com/0/0/1202015403592063
--

UPDATE star_loan.borrower_dim
SET current_residence_street1 = current_borrower_residence_place.pl_street1
	, current_residence_street2 = current_borrower_residence_place.pl_street2
	, current_residence_city = current_borrower_residence_place.pl_city
	, current_residence_postal_code = current_borrower_residence_place.pl_postal_code
	, current_residence_county_name = county.c_name
	, current_residence_county_fips = current_borrower_residence_place.pl_county_fips
	, current_residence_state = current_borrower_residence_place.pl_state
	, current_residence_state_fips = current_borrower_residence_place.pl_state_fips
	, current_residence_country_code = current_borrower_residence_place.pl_country
	, current_residence_country = current_borrower_residence_country_type.value
FROM (
	SELECT borrower.*
	FROM history_octane.borrower
		LEFT JOIN history_octane.borrower AS history_records
			ON borrower.b_pid = history_records.b_pid
				AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
	WHERE history_records.b_pid IS NULL
	) AS borrower
	JOIN (
	    SELECT applicant_role_type.*
	    FROM history_octane.applicant_role_type
	    	LEFT JOIN history_octane.applicant_role_type AS history_records
	    		ON applicant_role_type.code = history_records.code
	    			AND applicant_role_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	    ) AS applicant_role_type
			ON borrower.b_applicant_role_type = applicant_role_type.code
	JOIN (
	    SELECT application_taken_method_type.*
	    FROM history_octane.application_taken_method_type
	    	LEFT JOIN history_octane.application_taken_method_type AS history_records
	    		ON application_taken_method_type.code = history_records.code
					AND application_taken_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	    ) AS application_taken_method_type
			ON borrower.b_application_taken_method_type = application_taken_method_type.code
	JOIN (
	    SELECT borrower_relationship_type.*
	    FROM history_octane.borrower_relationship_type
	    	LEFT JOIN history_octane.borrower_relationship_type AS history_records
	    		ON borrower_relationship_type.code = history_records.code
	    			AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	    ) AS borrower_relationship_to_primary_borrower_type
    		ON borrower.b_relationship_to_primary_borrower_type = borrower_relationship_to_primary_borrower_type.code
	JOIN (
	    SELECT borrower_relationship_type.*
	    FROM history_octane.borrower_relationship_type
	    	LEFT JOIN history_octane.borrower_relationship_type AS history_records
	    		ON borrower_relationship_type.code = history_records.code
	    			AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	    ) AS borrower_relationship_to_seller_type
			ON borrower.b_relationship_to_seller_type = borrower_relationship_to_seller_type.code
	JOIN (
	    SELECT borrower_tiny_id_type.*
	    FROM history_octane.borrower_tiny_id_type
	    	LEFT JOIN history_octane.borrower_tiny_id_type AS history_records
	    		ON borrower_tiny_id_type.code = history_records.code
	    			AND borrower_tiny_id_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS borrower_tiny_id_type
			ON borrower.b_borrower_tiny_id_type = borrower_tiny_id_type.code
	JOIN (
	    SELECT country_type.*
	    FROM history_octane.country_type
	    	LEFT JOIN history_octane.country_type AS history_records
	    		ON country_type.code = history_records.code
	    			AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS power_of_attorney_country_type
			ON borrower.b_power_of_attorney_country = power_of_attorney_country_type.code
	JOIN (
	    SELECT credit_authorization_method_type.*
	    FROM history_octane.credit_authorization_method_type
	    	LEFT JOIN history_octane.credit_authorization_method_type AS history_records
	    		ON credit_authorization_method_type.code = history_records.code
	    			AND credit_authorization_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS credit_authorization_method_type
			ON borrower.b_credit_report_authorization_method = credit_authorization_method_type.code
	JOIN (
	    SELECT housing_counseling_agency_type.*
	    FROM history_octane.housing_counseling_agency_type
	    	LEFT JOIN history_octane.housing_counseling_agency_type AS history_records
	    		ON housing_counseling_agency_type.code = history_records.code
	    			AND housing_counseling_agency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS housing_counseling_agency_type
			ON borrower.b_housing_counseling_agency_type = housing_counseling_agency_type.code
	JOIN (
	    SELECT housing_counseling_type.*
	    FROM history_octane.housing_counseling_type
	    	LEFT JOIN history_octane.housing_counseling_type AS history_records
	    		ON housing_counseling_type.code = history_records.code
	    			AND housing_counseling_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS housing_counseling_type
    		ON borrower.b_housing_counseling_type = housing_counseling_type.code
	JOIN (
	    SELECT legal_entity_type.*
	    FROM history_octane.legal_entity_type
	    	LEFT JOIN history_octane.legal_entity_type AS history_records
	    		ON legal_entity_type.code = history_records.code
	    			AND legal_entity_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	    ) AS legal_entity_type
			ON borrower.b_legal_entity_type = legal_entity_type.code
	JOIN (
	    SELECT prior_property_title_type.*
	    FROM history_octane.prior_property_title_type
	    	LEFT JOIN history_octane.prior_property_title_type AS history_records
	    		ON prior_property_title_type.code = history_records.code
	    			AND prior_property_title_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS prior_property_title_type
    		ON borrower.b_prior_property_title_type = prior_property_title_type.code
	JOIN (
	    SELECT property_usage_type.*
	    FROM history_octane.property_usage_type
	    	LEFT JOIN history_octane.property_usage_type AS history_records
	    		ON property_usage_type.code = history_records.code
	    			AND property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS property_usage_type
			ON borrower.b_prior_property_usage_type = property_usage_type.code
	JOIN (
	    SELECT yes_no_unknown_type.*
	    FROM history_octane.yes_no_unknown_type
	    	LEFT JOIN history_octane.yes_no_unknown_type AS history_records
	    		ON yes_no_unknown_type.code = history_records.code
	    			AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS yes_no_unknown_type
			ON borrower.b_power_of_attorney = yes_no_unknown_type.code
	JOIN (
	    SELECT borrower_residence.*
	    FROM history_octane.borrower_residence
	    	LEFT JOIN history_octane.borrower_residence AS history_records
	    		ON borrower_residence.bres_pid = history_records.bres_pid
	    			AND borrower_residence.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.bres_pid IS NULL
		) AS current_borrower_residence
			ON borrower.b_pid = current_borrower_residence.bres_borrower_pid
				AND current_borrower_residence.bres_current IS TRUE
	JOIN (
	    SELECT place.*
	    FROM history_octane.place
	    	LEFT JOIN history_octane.place AS history_records
	    		ON place.pl_pid = history_records.pl_pid
	    			AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.pl_pid IS NULL
		) AS current_borrower_residence_place
			ON current_borrower_residence.bres_place_pid = current_borrower_residence_place.pl_pid
	LEFT JOIN (
	    SELECT county.*
	    FROM history_octane.county
	    	LEFT JOIN history_octane.county AS history_records
	    		ON county.c_pid = history_records.c_pid
	    			AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.c_pid IS NULL
		) AS county ON current_borrower_residence_place.pl_county_pid = county.c_pid
	JOIN (
	    SELECT country_type.*
	    FROM history_octane.country_type
	    	LEFT JOIN history_octane.country_type AS history_records
	    		ON country_type.code = history_records.code
	    			AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS current_borrower_residence_country_type
			ON current_borrower_residence_place.pl_country = current_borrower_residence_country_type.code
WHERE borrower_dim.borrower_pid = borrower.b_pid
	AND borrower_dim.dwid != 0
	AND COALESCE(
	borrower_dim.current_residence_street1
	, borrower_dim.current_residence_street2
	, borrower_dim.current_residence_city
	, borrower_dim.current_residence_postal_code
	, borrower_dim.current_residence_county_name
	, borrower_dim.current_residence_county_fips
	, borrower_dim.current_residence_state
	, borrower_dim.current_residence_state_fips
	, borrower_dim.current_residence_country_code
	, borrower_dim.current_residence_country
	) IS NULL
;


UPDATE star_loan.transaction_dim
SET subject_property_street1 = subject_property.pl_street1
	, subject_property_street2 = subject_property.pl_street2
	, subject_property_city = subject_property.pl_city
	, subject_property_tax_id = subject_property.pl_property_tax_id
  	, subject_property_postal_code = subject_property.pl_postal_code
	, subject_property_county_name = county.c_name
	, subject_property_county_fips = subject_property.pl_county_fips
	, subject_property_state = subject_property.pl_state
	, subject_property_state_fips = subject_property.pl_state_fips
	, subject_property_country_code = subject_property.pl_country
	, subject_property_country = country_type.value
	, subject_property_year_built = subject_property.pl_structure_built_year
	, subject_property_category_code = subject_property.pl_property_category_type
	, subject_property_category = property_category_type.value
	, subject_property_building_status_code = subject_property.pl_building_status_type
	, subject_property_building_status = building_status_type.value
	, subject_property_rental_flag = subject_property.pl_rental
	, subject_property_rights_code = subject_property.pl_property_rights_type
	, subject_property_rights = property_rights_type.value
	, subject_property_neighborhood_location_code = subject_property.pl_neighborhood_location_type
	, subject_property_neighborhood_location = neighborhood_location_type.value
FROM (
    SELECT proposal.*
    FROM history_octane.proposal
    	LEFT JOIN history_octane.proposal AS history_records
    		ON proposal.prp_pid = history_records.prp_pid
    			AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.prp_pid IS NULL
	) AS proposal
    JOIN (
        SELECT deal.*
        FROM history_octane.deal
        	LEFT JOIN history_octane.deal AS history_records
        		ON deal.d_pid = history_records.d_pid
        			AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.d_pid IS NULL
        ) AS deal
			ON proposal.prp_pid = deal.d_active_proposal_pid
	JOIN (
	    SELECT deal_stage.*
	    FROM history_octane.deal_stage
	    	LEFT JOIN history_octane.deal_stage AS history_records
	    		ON deal_stage.dst_pid = history_records.dst_pid
	    			AND deal_stage.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.dst_pid IS NULL
	    	AND deal_stage.dst_through_date IS NULL
		) AS current_deal_stage
			ON deal.d_pid = current_deal_stage.dst_deal_pid
	JOIN (
	    SELECT deal_stage_type.*
	    FROM history_octane.deal_stage_type
	    	LEFT JOIN history_octane.deal_stage_type AS history_records
	    		ON deal_stage_type.code = history_records.code
	    			AND deal_stage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS current_deal_stage_type
			ON current_deal_stage.dst_deal_stage_type = current_deal_stage_type.code
	JOIN (
	    SELECT place.*
	    FROM history_octane.place
	    	LEFT JOIN history_octane.place AS history_records
	    		ON place.pl_pid = history_records.pl_pid
	    			AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.pl_pid IS NULL
		) AS subject_property ON proposal.prp_pid = subject_property.pl_proposal_pid
    		AND subject_property.pl_subject_property IS TRUE
	LEFT JOIN (
	    SELECT county.*
	    FROM history_octane.county
	    	LEFT JOIN history_octane.county AS history_records
	    		ON county.c_pid = history_records.c_pid
	    			AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.c_pid IS NULL
		) AS county
			ON subject_property.pl_county_pid = county.c_pid
	JOIN (
	    SELECT country_type.*
	    FROM history_octane.country_type
	    	LEFT JOIN history_octane.country_type AS history_records
	    		ON country_type.code = history_records.code
	    			AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS country_type
			ON subject_property.pl_country = country_type.code
	JOIN (
	    SELECT property_category_type.*
	    FROM history_octane.property_category_type
	    	LEFT JOIN history_octane.property_category_type AS history_records
	    		ON property_category_type.code = history_records.code
	    			AND property_category_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS property_category_type
			ON subject_property.pl_property_category_type = property_category_type.code
	JOIN (
	    SELECT building_status_type.*
	    FROM history_octane.building_status_type
	    	LEFT JOIN history_octane.building_status_type AS history_records
	    		ON building_status_type.code = history_records.code
	    			AND building_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS building_status_type
			ON subject_property.pl_building_status_type = building_status_type.code
	JOIN (
	    SELECT property_rights_type.*
	    FROM history_octane.property_rights_type
	    	LEFT JOIN history_octane.property_rights_type AS history_records
	    		ON property_rights_type.code = history_records.code
	    			AND property_rights_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS property_rights_type
			ON subject_property.pl_property_rights_type = property_rights_type.code
	JOIN (
	    SELECT neighborhood_location_type.*
	    FROM history_octane.neighborhood_location_type
	    	LEFT JOIN history_octane.neighborhood_location_type AS history_records
	    		ON neighborhood_location_type.code = history_records.code
	    			AND neighborhood_location_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	    WHERE history_records.code IS NULL
		) AS neighborhood_location_type
			ON subject_property.pl_neighborhood_location_type = neighborhood_location_type.code
WHERE transaction_dim.deal_pid = deal.d_pid
	AND transaction_dim.dwid != 0
	AND COALESCE(
	    transaction_dim.subject_property_street1
	    , transaction_dim.subject_property_street2
		, transaction_dim.subject_property_city
		, transaction_dim.subject_property_tax_id
		, transaction_dim.subject_property_postal_code
		, transaction_dim.subject_property_county_name
		, transaction_dim.subject_property_county_fips
		, transaction_dim.subject_property_state
		, transaction_dim.subject_property_state_fips
		, transaction_dim.subject_property_country_code
		, transaction_dim.subject_property_country
		, transaction_dim.subject_property_year_built::VARCHAR
		, transaction_dim.subject_property_category_code
		, transaction_dim.subject_property_category
		, transaction_dim.subject_property_building_status_code
		, transaction_dim.subject_property_building_status
		, transaction_dim.subject_property_rental_flag::VARCHAR
		, transaction_dim.subject_property_rights_code
		, transaction_dim.subject_property_rights
		, transaction_dim.subject_property_neighborhood_location_code
		, transaction_dim.subject_property_neighborhood_location
	) IS NULL
;


DELETE
FROM star_loan.transaction_junk_dim
WHERE transaction_junk_dim.property_usage_code IS NULL
	AND transaction_junk_dim.dwid != 0
  	AND transaction_junk_dim.property_usage IS NULL
	AND transaction_junk_dim.dwid NOT IN (
	    SELECT loan_fact.transaction_junk_dwid
	    FROM star_loan.loan_fact
	);
