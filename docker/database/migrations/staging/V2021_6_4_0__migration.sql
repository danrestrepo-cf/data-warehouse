--
-- EDW | star_loan: update zero record data_source_integration_* fields
-- https://app.asana.com/0/0/1200416935542073
--

/*
= Make the following changes to star_loan schema tables’ zero records
Update the data_source_integration_* field values to include data_source_dwid for the below listed tables
application_dim
borrower_dim
interim_funder_dim
investor_dim
lender_user_dim
loan_beneficiary_dim
loan_dim
loan_funding_dim
mortgage_insurance_dim
product_dim
product_terms_dim
transaction_dim
*/
DO $$
    DECLARE prepared_statements RECORD;
    BEGIN
        FOR prepared_statements IN
            SELECT 'UPDATE ' || tables.table_schema || '.' || tables.table_name ||
                   ' SET data_source_integration_columns = CONCAT(data_source_integration_columns, ''~data_source_dwid'')' ||
                   ', data_source_integration_id = CONCAT(data_source_integration_id, ''~0'')' ||
                   ', edw_modified_datetime = NOW()' ||
                   ', data_source_modified_datetime = NOW()' ||
                    /*
                    Below WHERE uses data_source_integration_id to:
                        - ensure only records with invalid data_source_integration_id values are updated
                        - avoid hardcoded dwid usage
                    */
                   ' WHERE data_source_integration_id = ''0''' AS update_statement
            FROM information_schema.tables
            WHERE table_schema = 'star_loan'
              AND table_name IN ('application_dim', 'borrower_dim', 'interim_funder_dim', 'investor_dim', 'lender_user_dim',
                                 'loan_beneficiary_dim', 'loan_dim', 'loan_funding_dim', 'mortgage_insurance_dim',
                                 'product_dim', 'product_terms_dim', 'transaction_dim')
            LOOP
                EXECUTE prepared_statements.update_statement;
            END LOOP;
    END $$;

-- Update the data_source_integration_* field values for the hmda_purchaser_of_loan_dim table to reflect the table’s
-- current structure
UPDATE star_loan.hmda_purchaser_of_loan_dim
    SET data_source_integration_columns = 'code_2017~code_2018'
        , data_source_integration_id = '~'
    /*
    Below WHERE uses data_source_integration_columns and data_source_integration_id to:
        - ensure the only record with invalid values in these fields is updated
        - avoid hardcoded dwid usage
    */
    WHERE data_source_integration_columns = 'code~value~year'
        AND data_source_integration_id = '~~';

-- Update the data_source_integration_columns field value for the star_loan.borrower_lending_profile_dim table to
-- replace the invalid “|” character with a valid “~” character
UPDATE star_loan.borrower_lending_profile_dim
    SET data_source_integration_columns = REPLACE(data_source_integration_columns, '|', '~')
    /*
    Below WHERE uses data_source_integration_columns to:
        - ensure only the record with invalid value in data_source_integration_columns is updated
        - avoid hardcoded dwid usage
    */
    WHERE data_source_integration_columns LIKE '%|%';

--
-- EDW | Build MDI-2 insert/update config for star_loan.loan_fact
-- https://app.asana.com/0/0/1200254151885104

ALTER TABLE star_loan.loan_fact
    RENAME COLUMN loan_funding_dwid TO active_loan_funding_dwid;
ALTER TABLE star_loan.loan_fact
    RENAME COLUMN loan_beneficiary_dwid TO current_loan_beneficiary_dwid;
ALTER TABLE star_loan.loan_fact
    RENAME COLUMN product_choices_dwid TO product_choice_dwid;
ALTER TABLE star_loan.loan_fact
    RENAME COLUMN investor_dwid TO product_investor_dwid;
ALTER TABLE star_loan.loan_fact
    RENAME COLUMN application_dwid TO primary_application_dwid;

--
-- EDW | Reporting row access - add deal_lender_user to the star schema joined to loan_fact
-- (https://app.asana.com/0/0/1200195191806954)
--

CREATE TABLE star_loan.loan_lender_user_access (
    dwid BIGSERIAL NOT NULL,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    lender_user_pid BIGINT NOT NULL,
    loan_dwid BIGINT NOT NULL,
    PRIMARY KEY (lender_user_pid, loan_dwid)
) PARTITION BY HASH (lender_user_pid);

CREATE TABLE loan_lender_user_access_0 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 0);

CREATE TABLE loan_lender_user_access_1 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 1);

CREATE TABLE loan_lender_user_access_2 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 2);

CREATE TABLE loan_lender_user_access_3 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 3);

CREATE TABLE loan_lender_user_access_4 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 4);

CREATE TABLE loan_lender_user_access_5 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 5);

CREATE TABLE loan_lender_user_access_6 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 6);

CREATE TABLE loan_lender_user_access_7 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 7);

CREATE TABLE loan_lender_user_access_8 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 8);

CREATE TABLE loan_lender_user_access_9 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 9);

CREATE TABLE loan_lender_user_access_10 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 10);

CREATE TABLE loan_lender_user_access_11 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 11);

CREATE TABLE loan_lender_user_access_12 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 12);

CREATE TABLE loan_lender_user_access_13 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 13);

CREATE TABLE loan_lender_user_access_14 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 14);

CREATE TABLE loan_lender_user_access_15 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 15);

CREATE TABLE loan_lender_user_access_16 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 16);

CREATE TABLE loan_lender_user_access_17 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 17);

CREATE TABLE loan_lender_user_access_18 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 18);

CREATE TABLE loan_lender_user_access_19 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 19);

CREATE TABLE loan_lender_user_access_20 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 20);

CREATE TABLE loan_lender_user_access_21 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 21);

CREATE TABLE loan_lender_user_access_22 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 22);

CREATE TABLE loan_lender_user_access_23 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 23);

CREATE TABLE loan_lender_user_access_24 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 24);

CREATE TABLE loan_lender_user_access_25 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 25);

CREATE TABLE loan_lender_user_access_26 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 26);

CREATE TABLE loan_lender_user_access_27 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 27);

CREATE TABLE loan_lender_user_access_28 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 28);

CREATE TABLE loan_lender_user_access_29 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 29);

CREATE TABLE loan_lender_user_access_30 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 30);

CREATE TABLE loan_lender_user_access_31 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 31);

CREATE TABLE loan_lender_user_access_32 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 32);

CREATE TABLE loan_lender_user_access_33 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 33);

CREATE TABLE loan_lender_user_access_34 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 34);

CREATE TABLE loan_lender_user_access_35 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 35);

CREATE TABLE loan_lender_user_access_36 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 36);

CREATE TABLE loan_lender_user_access_37 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 37);

CREATE TABLE loan_lender_user_access_38 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 38);

CREATE TABLE loan_lender_user_access_39 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 39);

CREATE TABLE loan_lender_user_access_40 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 40);

CREATE TABLE loan_lender_user_access_41 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 41);

CREATE TABLE loan_lender_user_access_42 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 42);

CREATE TABLE loan_lender_user_access_43 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 43);

CREATE TABLE loan_lender_user_access_44 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 44);

CREATE TABLE loan_lender_user_access_45 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 45);

CREATE TABLE loan_lender_user_access_46 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 46);

CREATE TABLE loan_lender_user_access_47 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 47);

CREATE TABLE loan_lender_user_access_48 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 48);

CREATE TABLE loan_lender_user_access_49 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 49);

CREATE TABLE loan_lender_user_access_50 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 50);

CREATE TABLE loan_lender_user_access_51 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 51);

CREATE TABLE loan_lender_user_access_52 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 52);

CREATE TABLE loan_lender_user_access_53 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 53);

CREATE TABLE loan_lender_user_access_54 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 54);

CREATE TABLE loan_lender_user_access_55 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 55);

CREATE TABLE loan_lender_user_access_56 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 56);

CREATE TABLE loan_lender_user_access_57 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 57);

CREATE TABLE loan_lender_user_access_58 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 58);

CREATE TABLE loan_lender_user_access_59 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 59);

CREATE TABLE loan_lender_user_access_60 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 60);

CREATE TABLE loan_lender_user_access_61 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 61);

CREATE TABLE loan_lender_user_access_62 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 62);

CREATE TABLE loan_lender_user_access_63 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 63);

CREATE TABLE loan_lender_user_access_64 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 64);

CREATE TABLE loan_lender_user_access_65 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 65);

CREATE TABLE loan_lender_user_access_66 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 66);

CREATE TABLE loan_lender_user_access_67 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 67);

CREATE TABLE loan_lender_user_access_68 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 68);

CREATE TABLE loan_lender_user_access_69 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 69);

CREATE TABLE loan_lender_user_access_70 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 70);

CREATE TABLE loan_lender_user_access_71 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 71);

CREATE TABLE loan_lender_user_access_72 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 72);

CREATE TABLE loan_lender_user_access_73 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 73);

CREATE TABLE loan_lender_user_access_74 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 74);

CREATE TABLE loan_lender_user_access_75 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 75);

CREATE TABLE loan_lender_user_access_76 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 76);

CREATE TABLE loan_lender_user_access_77 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 77);

CREATE TABLE loan_lender_user_access_78 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 78);

CREATE TABLE loan_lender_user_access_79 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 79);

CREATE TABLE loan_lender_user_access_80 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 80);

CREATE TABLE loan_lender_user_access_81 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 81);

CREATE TABLE loan_lender_user_access_82 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 82);

CREATE TABLE loan_lender_user_access_83 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 83);

CREATE TABLE loan_lender_user_access_84 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 84);

CREATE TABLE loan_lender_user_access_85 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 85);

CREATE TABLE loan_lender_user_access_86 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 86);

CREATE TABLE loan_lender_user_access_87 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 87);

CREATE TABLE loan_lender_user_access_88 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 88);

CREATE TABLE loan_lender_user_access_89 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 89);

CREATE TABLE loan_lender_user_access_90 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 90);

CREATE TABLE loan_lender_user_access_91 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 91);

CREATE TABLE loan_lender_user_access_92 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 92);

CREATE TABLE loan_lender_user_access_93 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 93);

CREATE TABLE loan_lender_user_access_94 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 94);

CREATE TABLE loan_lender_user_access_95 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 95);

CREATE TABLE loan_lender_user_access_96 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 96);

CREATE TABLE loan_lender_user_access_97 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 97);

CREATE TABLE loan_lender_user_access_98 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 98);

CREATE TABLE loan_lender_user_access_99 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 99);
