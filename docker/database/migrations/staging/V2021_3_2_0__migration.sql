--
-- EDW - Octane data mart - NMLS Call Report table - fix data types (https://app.asana.com/0/0/1200087257796917)
--

-- drop views that need the columns
drop view octane_data_mart.nmls_call_report_national;
drop view octane_data_mart.nmls_call_report_s540a;
drop view octane_data_mart.nmls_call_report_state;

-- modify nmls_call_report_national
alter table staging_compliance.nmls_call_report_national alter column total_unpaid_balance type numeric(17,2) using total_unpaid_balance::numeric(17,2);
alter table staging_compliance.nmls_call_report_national alter column average_unpaid_balance type numeric(17,2) using average_unpaid_balance::numeric(17,2);

-- modify nmls_call_report_s540a
alter table staging_compliance.nmls_call_report_s540a alter column total_unpaid_balance type numeric(17,2) using total_unpaid_balance::numeric(17,2);
alter table staging_compliance.nmls_call_report_s540a alter column average_unpaid_balance type numeric(17,2) using average_unpaid_balance::numeric(17,2);

-- modify nmls_call_report_state
alter table staging_compliance.nmls_call_report_state alter column total_unpaid_balance type numeric(17,2) using total_unpaid_balance::numeric(17,2);
alter table staging_compliance.nmls_call_report_state alter column average_loan_size type numeric(17,2) using average_loan_size::numeric(17,2);

-- recreate views that needed the columns we modified
CREATE VIEW octane_data_mart.nmls_call_report_national AS
    SELECT
        mcr_field_id
        , mcr_description
        , average_unpaid_balance as average_unpaid_balance_amount
        , loan_count
        , total_unpaid_balance as total_unpaid_balance_amount
        , report_quarter
    FROM
        staging_compliance.nmls_call_report_national;

CREATE VIEW octane_data_mart.nmls_call_report_s540a AS
    SELECT
        state_type
        , item_id
        , servicer_nmls_id
        , servicer_name
        , pool_number
        , total_unpaid_balance as total_unpaid_balance_amount
        , loan_count
        , average_unpaid_balance as average_unpaid_balance_amount
        , report_quarter
    FROM
        staging_compliance.nmls_call_report_s540a;

CREATE VIEW octane_data_mart.nmls_call_report_state AS
    SELECT
        mcr_field_id
        , mcr_description
        , state_type
        , total_unpaid_balance as total_unpaid_balance_amount
        , loan_count
        , average_loan_size as average_unpaid_balance_amount
        , report_quarter
    FROM
        staging_compliance.nmls_call_report_state;