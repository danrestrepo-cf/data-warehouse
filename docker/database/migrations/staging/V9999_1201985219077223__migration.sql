--
-- EDW | Create borrower_hmda_collection_dim and add its dwid to borrower_dim
-- https://app.asana.com/0/0/1201985219077223
--

CREATE TABLE star_loan.borrower_hmda_collection_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_hmda_collection_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    ethnicity_collected_visual_or_surname VARCHAR(1024),
    ethnicity_collected_visual_or_surname_code VARCHAR(128),
    ethnicity_not_obtainable_flag BOOLEAN,
    ethnicity_refused VARCHAR(1024),
    ethnicity_refused_code VARCHAR(128),
    race_collected_visual_or_surname VARCHAR(1024),
    race_collected_visual_or_surname_code VARCHAR(128),
    race_information_not_provided_flag BOOLEAN,
    race_national_origin_refusal_flag BOOLEAN,
    race_not_obtainable_flag BOOLEAN,
    race_refused VARCHAR(1024),
    race_refused_code VARCHAR(128),
    sex_collected_visual_or_surname VARCHAR(1024),
    sex_collected_visual_or_surname_code VARCHAR(128),
    sex_not_obtainable_flag BOOLEAN,
    sex_refused VARCHAR(1024),
    sex_refused_code VARCHAR(128)
);

CREATE INDEX idx_borrower_hmda_collection_dim__etl_batch_id ON star_loan.borrower_hmda_collection_dim (etl_batch_id);
CREATE INDEX idx_borrower_hmda_collection_dim__data_source_integration_id ON star_loan.borrower_hmda_collection_dim (data_source_integration_id);

--insert borrower_hmda_collection_dim "zero" row
INSERT
INTO star_loan.borrower_hmda_collection_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, ethnicity_collected_visual_or_surname, ethnicity_collected_visual_or_surname_code, ethnicity_not_obtainable_flag, ethnicity_refused, ethnicity_refused_code, race_collected_visual_or_surname, race_collected_visual_or_surname_code, race_information_not_provided_flag, race_national_origin_refusal_flag, race_not_obtainable_flag, race_refused, race_refused_code, sex_collected_visual_or_surname, sex_collected_visual_or_surname_code, sex_not_obtainable_flag, sex_refused, sex_refused_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'ethnicity_collected_visual_or_surname_code~ethnicity_not_obtainable_flag~ethnicity_refused_code~race_collected_visual_or_surname_code~race_information_not_provided_flag~race_national_origin_refusal_flag~race_not_obtainable_flag~race_refused_code~sex_collected_visual_or_surname_code~sex_not_obtainable_flag~sex_refused_code~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
