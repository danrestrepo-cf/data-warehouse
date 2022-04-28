--
-- EDW | move transaction_dim subject property and borrower_dim borrower residence columns to their own aux dimensions
-- https://app.asana.com/0/0/1202075961150519
--

CREATE TABLE star_loan.borrower_aux_current_residence_dim (
    borrower_dwid BIGINT NOT NULL
		CONSTRAINT pk_borrower_aux_current_residence_dim
			PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
	, borrower_pid BIGINT NOT NULL
	, street1 VARCHAR(128)
	, street2 VARCHAR(128)
	, city VARCHAR(128)
	, postal_code VARCHAR(128)
	, county_name VARCHAR(128)
	, county_fips VARCHAR(16)
	, state VARCHAR(128)
	, state_fips VARCHAR(32)
	, country_code VARCHAR(128)
	, country VARCHAR(1024)
);

CREATE INDEX idx_borrower_aux_current_residence_dim__etl_batch_id ON star_loan.borrower_aux_current_residence_dim (etl_batch_id);
CREATE INDEX idx_a7fd843edae9b0283f5080c736a579cd ON star_loan.borrower_aux_current_residence_dim (data_source_integration_id);
CREATE INDEX idx_borrower_aux_current_residence_dim__borrower_pid ON star_loan.borrower_aux_current_residence_dim (borrower_pid);

INSERT INTO star_loan.borrower_aux_current_residence_dim (borrower_dwid, data_source_dwid, edw_created_datetime
														 , edw_modified_datetime, etl_batch_id
														 , data_source_integration_columns, data_source_integration_id
														 , data_source_modified_datetime, borrower_pid, street1
														 , street2, city, postal_code, county_name, county_fips, state
														 , state_fips, country_code, country)
	VALUES (0, 0, NOW(), NOW(), NULL, 'borrower_pid~data_source_dwid', '0~0', NOW(), 0, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL);


CREATE TABLE star_loan.transaction_aux_subject_property_dim (
    transaction_dwid BIGINT NOT NULL
		CONSTRAINT pk_transaction_aux_subject_property_dim
			PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
	, deal_pid BIGINT NOT NULL
	, active_proposal_pid BIGINT NOT NULL
	, street1 VARCHAR(128)
	, street2 VARCHAR(128)
	, city VARCHAR(128)
	, tax_id VARCHAR(64)
	, postal_code VARCHAR(128)
	, county_name VARCHAR(128)
	, county_fips VARCHAR(16)
	, state VARCHAR(128)
	, state_fips VARCHAR(32)
	, country_code VARCHAR(128)
	, country VARCHAR(1024)
	, year_built INT
	, property_category_code VARCHAR(128)
	, property_category VARCHAR(1024)
	, building_status_code VARCHAR(128)
	, building_status VARCHAR(1024)
	, rental_flag BOOLEAN
	, property_rights_code VARCHAR(128)
	, property_rights VARCHAR(1024)
	, neighborhood_location_code VARCHAR(128)
	, neighborhood_location VARCHAR(1024)
);

CREATE INDEX idx_transaction_aux_subject_property_dim__etl_batch_id ON star_loan.transaction_aux_subject_property_dim (etl_batch_id);
CREATE INDEX idx_a7f9335219213095ba4a535bc3ed3566 ON star_loan.transaction_aux_subject_property_dim (data_source_integration_id);
CREATE INDEX idx_transaction_aux_subject_property_dim__deal_pid ON star_loan.transaction_aux_subject_property_dim (deal_pid);
CREATE INDEX idx_transaction_aux_subject_property_dim__active_proposal_pid ON star_loan.transaction_aux_subject_property_dim (active_proposal_pid);

INSERT INTO star_loan.transaction_aux_subject_property_dim ( transaction_dwid, data_source_dwid, edw_created_datetime
														   , edw_modified_datetime, etl_batch_id
														   , data_source_integration_columns, data_source_integration_id
														   , data_source_modified_datetime, deal_pid
														   , active_proposal_pid, street1, street2, city, tax_id
														   , postal_code, county_name, county_fips, state, state_fips
														   , country_code, country, year_built, property_category_code
														   , property_category, building_status_code, building_status
														   , rental_flag, property_rights_code, property_rights
														   , neighborhood_location_code, neighborhood_location)
	VALUES (0, 0, NOW(), NOW(), NULL, 'deal_pid~data_source_dwid', '0~0', NOW(), 0, 0, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
