--
-- EDW | Integrate fields from the 'place' table in Octane to the star_loan schema
-- https://app.asana.com/0/0/1201928616867107
--

ALTER TABLE star_loan.borrower_dim
    ADD COLUMN current_residence_street1 VARCHAR(128)
	, ADD COLUMN current_residence_street2 VARCHAR(128)
	, ADD COLUMN current_residence_city VARCHAR(128)
	, ADD COLUMN current_residence_postal_code VARCHAR(128)
	, ADD COLUMN current_residence_county_name VARCHAR(128)
	, ADD COLUMN current_residence_county_fips VARCHAR(16)
	, ADD COLUMN current_residence_state VARCHAR(128)
	, ADD COLUMN current_residence_state_fips VARCHAR(32)
	, ADD COLUMN current_residence_country_code VARCHAR(128)
	, ADD COLUMN current_residence_country VARCHAR(1024);


ALTER TABLE star_loan.transaction_dim
	ADD COLUMN subject_property_street1 VARCHAR(128)
	, ADD COLUMN subject_property_street2 VARCHAR(128)
	, ADD COLUMN subject_property_city VARCHAR(128)
	, ADD COLUMN subject_property_tax_id VARCHAR(64)
	, ADD COLUMN subject_property_postal_code VARCHAR(128)
	, ADD COLUMN subject_property_county_name VARCHAR(128)
	, ADD COLUMN subject_property_county_fips VARCHAR(16)
	, ADD COLUMN subject_property_state VARCHAR(128)
	, ADD COLUMN subject_property_state_fips VARCHAR(32)
	, ADD COLUMN subject_property_country_code VARCHAR(128)
	, ADD COLUMN subject_property_country VARCHAR(1024)
	, ADD COLUMN subject_property_year_built INT
	, ADD COLUMN subject_property_category_code VARCHAR(128)
	, ADD COLUMN subject_property_category VARCHAR(1024)
	, ADD COLUMN subject_property_building_status_code VARCHAR(128)
	, ADD COLUMN subject_property_building_status VARCHAR(1024)
	, ADD COLUMN subject_property_rental_flag BOOLEAN
	, ADD COLUMN subject_property_rights_code VARCHAR(128)
	, ADD COLUMN subject_property_rights VARCHAR(1024)
	, ADD COLUMN subject_property_neighborhood_location_code VARCHAR(128)
	, ADD COLUMN subject_property_neighborhood_location VARCHAR(1024);


ALTER TABLE star_loan.transaction_junk_dim
	ADD COLUMN property_usage_code VARCHAR(128)
	, ADD COLUMN property_usage VARCHAR(1024);

UPDATE star_loan.transaction_junk_dim
	SET data_source_integration_columns = 'is_test_loan_flag~structure_code~mi_required_flag~loan_purpose_code~data_source_dwid~piggyback_flag~property_usage_code'
	, data_source_integration_id = '<NULL>~<NULL>~<NULL>~<NULL>~0~<NULL>~<NULL>'
	, edw_modified_datetime = NOW()
WHERE dwid = 0;
