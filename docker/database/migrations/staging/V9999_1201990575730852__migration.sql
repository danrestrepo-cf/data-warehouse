--
-- EDW | Split borrower_demographics_dim and borrower_lending_profile_dim into smaller unique dim tables
-- https://app.asana.com/0/0/1201990575730852
--

-- TODO: seed initial data into new borrower_dim columns

/*
 update loan_fact columns/indexes
 */

ALTER TABLE star_loan.loan_fact
    --drop old unique dim foreign key columns
    DROP COLUMN b1_borrower_demographics_dwid,
    DROP COLUMN b1_borrower_lending_profile_dwid,
    --add new unique dim foreign key columns
    ADD COLUMN b1_borrower_counseling_dwid BIGINT,
    ADD COLUMN b1_borrower_employee_status_dwid BIGINT,
    ADD COLUMN b1_borrower_finances_declarations_dwid BIGINT,
    ADD COLUMN b1_borrower_hmda_ethnicity_dwid BIGINT,
    ADD COLUMN b1_borrower_hmda_race_dwid BIGINT,
    ADD COLUMN b1_borrower_hmda_sex_dwid BIGINT,
    ADD COLUMN b1_borrower_junk_dwid BIGINT,
    ADD COLUMN b1_borrower_pre_umdp_declarations_dwid BIGINT,
    ADD COLUMN b1_borrower_property_declarations_dwid BIGINT,
    ADD COLUMN b1_borrower_relations_dwid BIGINT;

CREATE INDEX idx_loan_fact__b1_borrower_counseling_dwid ON star_loan.loan_fact (b1_borrower_counseling_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_employee_status_dwid ON star_loan.loan_fact (b1_borrower_employee_status_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_finances_declarations_dwid ON star_loan.loan_fact (b1_borrower_finances_declarations_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_hmda_ethnicity_dwid ON star_loan.loan_fact (b1_borrower_hmda_ethnicity_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_hmda_race_dwid ON star_loan.loan_fact (b1_borrower_hmda_race_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_hmda_sex_dwid ON star_loan.loan_fact (b1_borrower_hmda_sex_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_junk_dwid ON star_loan.loan_fact (b1_borrower_junk_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_pre_umdp_declarations_dwid ON star_loan.loan_fact (b1_borrower_pre_umdp_declarations_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_property_declarations_dwid ON star_loan.loan_fact (b1_borrower_property_declarations_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_relations_dwid ON star_loan.loan_fact (b1_borrower_relations_dwid);

UPDATE star_loan.loan_fact
SET b1_borrower_counseling_dwid = 0
  , b1_borrower_employee_status_dwid = 0
  , b1_borrower_finances_declarations_dwid = 0
  , b1_borrower_hmda_ethnicity_dwid = 0
  , b1_borrower_hmda_race_dwid = 0
  , b1_borrower_hmda_sex_dwid = 0
  , b1_borrower_junk_dwid = 0
  , b1_borrower_pre_umdp_declarations_dwid = 0
  , b1_borrower_property_declarations_dwid = 0
  , b1_borrower_relations_dwid = 0
--add non-restrictive condition to silence IDE warnings about unqualified UPDATE statement
WHERE TRUE;

/*
 update borrower_dim columns/indexes
 */

ALTER TABLE star_loan.borrower_dim
    --drop columns which will be incorporated into new unique dims
    DROP COLUMN housing_counseling,
    DROP COLUMN housing_counseling_code,
    DROP COLUMN housing_counseling_agency_code,
    DROP COLUMN housing_counseling_agency,
    DROP COLUMN prior_property_title,
    DROP COLUMN prior_property_usage_code,
    DROP COLUMN prior_property_title_code,
    DROP COLUMN prior_property_usage,
    --add schooling_years column
    ADD COLUMN schooling_years INT,
    ADD COLUMN homeownership_education_complete_date DATE;

/*
 drop old borrower unique dimensions
 */

DROP TABLE star_loan.borrower_demographics_dim;
DROP TABLE star_loan.borrower_lending_profile_dim;

/*
 create new unique borrower dimensions and insert "zero" rows
 */

--borrower_counseling_dim
CREATE TABLE star_loan.borrower_counseling_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_counseling_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    first_time_homebuyer_auto_compute_flag BOOLEAN,
    first_time_homebuyer_flag BOOLEAN,
    homeownership_education VARCHAR(1024),
    homeownership_education_code VARCHAR(128),
    homeownership_education_agency VARCHAR(1024),
    homeownership_education_agency_code VARCHAR(128),
    housing_counseling VARCHAR(1024),
    housing_counseling_code VARCHAR(128),
    housing_counseling_agency VARCHAR(1024),
    housing_counseling_agency_code VARCHAR(128)
);

CREATE INDEX idx_borrower_counseling_dim__etl_batch_id ON star_loan.borrower_counseling_dim (etl_batch_id);
CREATE INDEX idx_borrower_counseling_dim__data_source_integration_id ON star_loan.borrower_counseling_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_counseling_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, first_time_homebuyer_auto_compute_flag, first_time_homebuyer_flag, homeownership_education, homeownership_education_code, homeownership_education_agency, homeownership_education_agency_code, housing_counseling, housing_counseling_code, housing_counseling_agency, housing_counseling_agency_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'first_time_homebuyer_auto_compute_flag~first_time_homebuyer_flag~homeownership_education_code~homeownership_education_agency_code~housing_counseling_code~housing_counseling_agency_code~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--borrower_employee_status_dim
CREATE TABLE star_loan.borrower_employee_status_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_employee_status_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    hud_employee_flag BOOLEAN,
    lender_employee VARCHAR(1024),
    lender_employee_code VARCHAR(128),
    lender_employee_status_confirmed_flag BOOLEAN
);

CREATE INDEX idx_borrower_employee_status_dim__etl_batch_id ON star_loan.borrower_employee_status_dim (etl_batch_id);
CREATE INDEX idx_borrower_employee_status_dim__data_source_integration_id ON star_loan.borrower_employee_status_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_employee_status_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, hud_employee_flag, lender_employee, lender_employee_code, lender_employee_status_confirmed_flag)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'hud_employee_flag~lender_employee_code~lender_employee_status_confirmed_flag~data_source_dwid', '<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL);

--borrower_finances_declarations_dim
CREATE TABLE star_loan.borrower_finances_declarations_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_finances_declarations_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    bankruptcy VARCHAR(1024),
    bankruptcy_code VARCHAR(128),
    outstanding_judgements VARCHAR(1024),
    outstanding_judgements_code VARCHAR(128),
    bankruptcy_chapter_7 VARCHAR(1024),
    bankruptcy_chapter_7_code VARCHAR(128),
    bankruptcy_chapter_11 VARCHAR(1024),
    bankruptcy_chapter_11_code VARCHAR(128),
    bankruptcy_chapter_12 VARCHAR(1024),
    bankruptcy_chapter_12_code VARCHAR(128),
    bankruptcy_chapter_13 VARCHAR(1024),
    bankruptcy_chapter_13_code VARCHAR(128),
    completed_pre_foreclosure_short_sale VARCHAR(1024),
    completed_pre_foreclosure_short_sale_code VARCHAR(128),
    conveyed_title_in_lieu_of_foreclosure VARCHAR(1024),
    conveyed_title_in_lieu_of_foreclosure_code VARCHAR(128),
    cosigner_undisclosed VARCHAR(1024),
    cosigner_undisclosed_code VARCHAR(128),
    currently_delinquent_federal_debt VARCHAR(1024),
    currently_delinquent_federal_debt_code VARCHAR(128),
    party_to_lawsuit VARCHAR(1024),
    party_to_lawsuit_code VARCHAR(128),
    property_foreclosure VARCHAR(1024),
    property_foreclosure_code VARCHAR(128)
);

CREATE INDEX idx_borrower_finances_declarations_dim__etl_batch_id ON star_loan.borrower_finances_declarations_dim (etl_batch_id);
CREATE INDEX idx_a924558105603ba33130b825269a41e8 ON star_loan.borrower_finances_declarations_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_finances_declarations_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, bankruptcy, bankruptcy_code, outstanding_judgements, outstanding_judgements_code, bankruptcy_chapter_7, bankruptcy_chapter_7_code, bankruptcy_chapter_11, bankruptcy_chapter_11_code, bankruptcy_chapter_12, bankruptcy_chapter_12_code, bankruptcy_chapter_13, bankruptcy_chapter_13_code, completed_pre_foreclosure_short_sale, completed_pre_foreclosure_short_sale_code, conveyed_title_in_lieu_of_foreclosure, conveyed_title_in_lieu_of_foreclosure_code, cosigner_undisclosed, cosigner_undisclosed_code, currently_delinquent_federal_debt, currently_delinquent_federal_debt_code, party_to_lawsuit, party_to_lawsuit_code, property_foreclosure, property_foreclosure_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'bankruptcy_code~outstanding_judgements_code~bankruptcy_chapter_7_code~bankruptcy_chapter_11_code~bankruptcy_chapter_12_code~bankruptcy_chapter_13_code~completed_pre_foreclosure_short_sale_code~conveyed_title_in_lieu_of_foreclosure_code~cosigner_undisclosed_code~currently_delinquent_federal_debt_code~party_to_lawsuit_code~property_foreclosure_code~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--borrower_hmda_ethnicity_dim
CREATE TABLE star_loan.borrower_hmda_ethnicity_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_hmda_ethnicity_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    ethnicity_cuban_flag BOOLEAN,
    ethnicity_hispanic_or_latino_flag BOOLEAN,
    ethnicity_mexican_flag BOOLEAN,
    ethnicity_not_hispanic_or_latino_flag BOOLEAN,
    ethnicity_other_hispanic_or_latino_description_flag BOOLEAN,
    ethnicity_other_hispanic_or_latino_flag BOOLEAN,
    ethnicity_puerto_rican_flag BOOLEAN
);

CREATE INDEX idx_borrower_hmda_ethnicity_dim__etl_batch_id ON star_loan.borrower_hmda_ethnicity_dim (etl_batch_id);
CREATE INDEX idx_borrower_hmda_ethnicity_dim__data_source_integration_id ON star_loan.borrower_hmda_ethnicity_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_hmda_ethnicity_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, ethnicity_cuban_flag, ethnicity_hispanic_or_latino_flag, ethnicity_mexican_flag, ethnicity_not_hispanic_or_latino_flag, ethnicity_other_hispanic_or_latino_description_flag, ethnicity_other_hispanic_or_latino_flag, ethnicity_puerto_rican_flag)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'ethnicity_cuban_flag~ethnicity_hispanic_or_latino_flag~ethnicity_mexican_flag~ethnicity_not_hispanic_or_latino_flag~ethnicity_other_hispanic_or_latino_description_flag~ethnicity_other_hispanic_or_latino_flag~ethnicity_puerto_rican_flag~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--borrower_hmda_race_dim
CREATE TABLE star_loan.borrower_hmda_race_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_hmda_race_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    other_race_national_origin_description_flag BOOLEAN,
    race_american_indian_or_alaska_native_flag BOOLEAN,
    race_asian_flag BOOLEAN,
    race_asian_indian_flag BOOLEAN,
    race_black_or_african_american_flag BOOLEAN,
    race_chinese_flag BOOLEAN,
    race_filipino_flag BOOLEAN,
    race_guamanian_or_chamorro_flag BOOLEAN,
    race_japanese_flag BOOLEAN,
    race_korean_flag BOOLEAN,
    race_native_hawaiian_flag BOOLEAN,
    race_native_hawaiian_or_other_pacific_islander_flag BOOLEAN,
    race_not_applicable_flag BOOLEAN,
    race_other_american_indian_or_alaska_native_description_flag BOOLEAN,
    race_other_asian_description_flag BOOLEAN,
    race_other_asian_flag BOOLEAN,
    race_other_pacific_islander_description_flag BOOLEAN,
    race_other_pacific_islander_flag BOOLEAN,
    race_samoan_flag BOOLEAN,
    race_vietnamese_flag BOOLEAN,
    race_white_flag BOOLEAN
);

CREATE INDEX idx_borrower_hmda_race_dim__etl_batch_id ON star_loan.borrower_hmda_race_dim (etl_batch_id);
CREATE INDEX idx_borrower_hmda_race_dim__data_source_integration_id ON star_loan.borrower_hmda_race_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_hmda_race_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, other_race_national_origin_description_flag, race_american_indian_or_alaska_native_flag, race_asian_flag, race_asian_indian_flag, race_black_or_african_american_flag, race_chinese_flag, race_filipino_flag, race_guamanian_or_chamorro_flag, race_japanese_flag, race_korean_flag, race_native_hawaiian_flag, race_native_hawaiian_or_other_pacific_islander_flag, race_not_applicable_flag, race_other_american_indian_or_alaska_native_description_flag, race_other_asian_description_flag, race_other_asian_flag, race_other_pacific_islander_description_flag, race_other_pacific_islander_flag, race_samoan_flag, race_vietnamese_flag, race_white_flag)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'other_race_national_origin_description_flag~race_american_indian_or_alaska_native_flag~race_asian_flag~race_asian_indian_flag~race_black_or_african_american_flag~race_chinese_flag~race_filipino_flag~race_guamanian_or_chamorro_flag~race_japanese_flag~race_korean_flag~race_native_hawaiian_flag~race_native_hawaiian_or_other_pacific_islander_flag~race_not_applicable_flag~race_other_american_indian_or_alaska_native_description_flag~race_other_asian_description_flag~race_other_asian_flag~race_other_pacific_islander_description_flag~race_other_pacific_islander_flag~race_samoan_flag~race_vietnamese_flag~race_white_flag~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--borrower_hmda_sex_dim
CREATE TABLE star_loan.borrower_hmda_sex_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_hmda_sex_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    sex_female_flag BOOLEAN,
    sex_male_flag BOOLEAN
);

CREATE INDEX idx_borrower_hmda_sex_dim__etl_batch_id ON star_loan.borrower_hmda_sex_dim (etl_batch_id);
CREATE INDEX idx_borrower_hmda_sex_dim__data_source_integration_id ON star_loan.borrower_hmda_sex_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_hmda_sex_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, sex_female_flag, sex_male_flag)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'sex_female_flag~sex_male_flag~data_source_dwid', '<NULL>~<NULL>~0', NOW( ), NULL, NULL);

--borrower_junk_dim
CREATE TABLE star_loan.borrower_junk_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_junk_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    citizenship_residency VARCHAR(1024),
    citizenship_residency_code VARCHAR(128),
    disabled VARCHAR(1024),
    disabled_code VARCHAR(128),
    on_gsa_list VARCHAR(1024),
    on_gsa_list_code VARCHAR(128),
    on_ldp_list VARCHAR(1024),
    on_ldp_list_code VARCHAR(128),
    titleholder VARCHAR(1024),
    titleholder_code VARCHAR(128)
);

CREATE INDEX idx_borrower_junk_dim__etl_batch_id ON star_loan.borrower_junk_dim (etl_batch_id);
CREATE INDEX idx_borrower_junk_dim__data_source_integration_id ON star_loan.borrower_junk_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_junk_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, citizenship_residency, citizenship_residency_code, disabled, disabled_code, on_gsa_list, on_gsa_list_code, on_ldp_list, on_ldp_list_code, titleholder, titleholder_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'citizenship_residency_code~disabled_code~on_gsa_list_code~on_ldp_list_code~titleholder_code~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--borrower_pre_umdp_declarations_dim
CREATE TABLE star_loan.borrower_pre_umdp_declarations_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_pre_umdp_declarations_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    alimony_child_support VARCHAR(1024),
    alimony_child_support_code VARCHAR(128),
    borrowed_down_payment VARCHAR(1024),
    borrowed_down_payment_code VARCHAR(128),
    note_endorser VARCHAR(1024),
    note_endorser_code VARCHAR(128),
    obligated_loan_foreclosure VARCHAR(1024),
    obligated_loan_foreclosure_code VARCHAR(128),
    party_to_lawsuit VARCHAR(1024),
    party_to_lawsuit_code VARCHAR(128),
    presently_delinquent VARCHAR(1024),
    presently_delinquent_code VARCHAR(128),
    property_foreclosure VARCHAR(1024),
    property_foreclosure_code VARCHAR(128)
);

CREATE INDEX idx_borrower_pre_umdp_declarations_dim__etl_batch_id ON star_loan.borrower_pre_umdp_declarations_dim (etl_batch_id);
CREATE INDEX idx_b4aecef00805d646d8fdcb541d520c04 ON star_loan.borrower_pre_umdp_declarations_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_pre_umdp_declarations_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, alimony_child_support, alimony_child_support_code, borrowed_down_payment, borrowed_down_payment_code, note_endorser, note_endorser_code, obligated_loan_foreclosure, obligated_loan_foreclosure_code, party_to_lawsuit, party_to_lawsuit_code, presently_delinquent, presently_delinquent_code, property_foreclosure, property_foreclosure_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'alimony_child_support_code~borrowed_down_payment_code~note_endorser_code~obligated_loan_foreclosure_code~party_to_lawsuit_code~presently_delinquent_code~property_foreclosure_code~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--borrower_property_declarations_dim
CREATE TABLE star_loan.borrower_property_declarations_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_property_declarations_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    applying_for_credit_before_closing VARCHAR(1024),
    applying_for_credit_before_closing_code VARCHAR(128),
    borrowed_funds_undisclosed VARCHAR(1024),
    borrowed_funds_undisclosed_code VARCHAR(128),
    fha_secondary_residence VARCHAR(1024),
    fha_secondary_residence_code VARCHAR(128),
    homeowner_past_three_years VARCHAR(1024),
    homeowner_past_three_years_code VARCHAR(128),
    intend_to_occupy VARCHAR(1024),
    intend_to_occupy_code VARCHAR(128),
    intend_to_occupy_more_than_14_days VARCHAR(1024),
    intend_to_occupy_more_than_14_days_code VARCHAR(128),
    other_mortgage_in_progress_before_closing VARCHAR(1024),
    other_mortgage_in_progress_before_closing_code VARCHAR(128),
    prior_property_title VARCHAR(1024),
    prior_property_title_code VARCHAR(128),
    prior_property_usage VARCHAR(1024),
    prior_property_usage_code VARCHAR(128),
    priority_given_to_another_lien VARCHAR(1024),
    priority_given_to_another_lien_code VARCHAR(128),
    relationship_with_seller VARCHAR(1024),
    relationship_with_seller_code VARCHAR(128)
);

CREATE INDEX idx_borrower_property_declarations_dim__etl_batch_id ON star_loan.borrower_property_declarations_dim (etl_batch_id);
CREATE INDEX idx_5ed7738771f3a95d0549be162e6fea54 ON star_loan.borrower_property_declarations_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_property_declarations_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, applying_for_credit_before_closing, applying_for_credit_before_closing_code, borrowed_funds_undisclosed, borrowed_funds_undisclosed_code, fha_secondary_residence, fha_secondary_residence_code, homeowner_past_three_years, homeowner_past_three_years_code, intend_to_occupy, intend_to_occupy_code, intend_to_occupy_more_than_14_days, intend_to_occupy_more_than_14_days_code, other_mortgage_in_progress_before_closing, other_mortgage_in_progress_before_closing_code, prior_property_title, prior_property_title_code, prior_property_usage, prior_property_usage_code, priority_given_to_another_lien, priority_given_to_another_lien_code, relationship_with_seller, relationship_with_seller_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'applying_for_credit_before_closing_code~borrowed_funds_undisclosed_code~fha_secondary_residence_code~homeowner_past_three_years_code~intend_to_occupy_code~intend_to_occupy_more_than_14_days_code~other_mortgage_in_progress_before_closing_code~prior_property_title_code~prior_property_usage_code~priority_given_to_another_lien_code~relationship_with_seller_code~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--borrower_relations_dim
CREATE TABLE star_loan.borrower_relations_dim (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_borrower_relations_dim
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    dependents VARCHAR(1024),
    dependents_code VARCHAR(128),
    domestic_relationship_state VARCHAR(1024),
    domestic_relationship_state_code VARCHAR(128),
    marital_status VARCHAR(1024),
    marital_status_code VARCHAR(128),
    spousal_homestead VARCHAR(1024),
    spousal_homestead_code VARCHAR(128)
);

CREATE INDEX idx_borrower_relations_dim__etl_batch_id ON star_loan.borrower_relations_dim (etl_batch_id);
CREATE INDEX idx_borrower_relations_dim__data_source_integration_id ON star_loan.borrower_relations_dim (data_source_integration_id);

INSERT
INTO star_loan.borrower_relations_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, dependents, dependents_code, domestic_relationship_state, domestic_relationship_state_code, marital_status, marital_status_code, spousal_homestead, spousal_homestead_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'dependents_code~domestic_relationship_state_code~marital_status_code~spousal_homestead_code~data_source_dwid', '<NULL>~<NULL>~<NULL>~<NULL>~0', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
