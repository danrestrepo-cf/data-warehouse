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
    WHERE dwid = 0;

-- Update the data_source_integration_columns field value for the star_loan.borrower_lending_profile_dim table to
-- replace the invalid “|” character with a valid “~” character
UPDATE star_loan.borrower_lending_profile_dim
    SET data_source_integration_columns = REPLACE(data_source_integration_columns, '|', '~')
    WHERE dwid = 0;