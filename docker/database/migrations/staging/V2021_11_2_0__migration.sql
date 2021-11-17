--
-- EDW | history_octane - add etl_batch_id column to all existing tables and update metadata accordingly
-- https://app.asana.com/0/0/1201374340358777
--

/*
 Add new etl_batch_id column and accompanying index to every table in the history_octane schema
 */

--adding etl_batch_id to history_octane.account
ALTER TABLE history_octane.account
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_account__etl_batch_id ON history_octane.account (etl_batch_id);

--adding etl_batch_id to history_octane.account_contact
ALTER TABLE history_octane.account_contact
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_account_contact__etl_batch_id ON history_octane.account_contact (etl_batch_id);

--adding etl_batch_id to history_octane.account_event
ALTER TABLE history_octane.account_event
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_account_event__etl_batch_id ON history_octane.account_event (etl_batch_id);

--adding etl_batch_id to history_octane.account_event_type
ALTER TABLE history_octane.account_event_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_account_event_type__etl_batch_id ON history_octane.account_event_type (etl_batch_id);

--adding etl_batch_id to history_octane.account_grant_program
ALTER TABLE history_octane.account_grant_program
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_account_grant_program__etl_batch_id ON history_octane.account_grant_program (etl_batch_id);

--adding etl_batch_id to history_octane.account_id_sequence
ALTER TABLE history_octane.account_id_sequence
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_account_id_sequence__etl_batch_id ON history_octane.account_id_sequence (etl_batch_id);

--adding etl_batch_id to history_octane.account_status_type
ALTER TABLE history_octane.account_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_account_status_type__etl_batch_id ON history_octane.account_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.admin_user
ALTER TABLE history_octane.admin_user
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_admin_user__etl_batch_id ON history_octane.admin_user (etl_batch_id);

--adding etl_batch_id to history_octane.admin_user_event
ALTER TABLE history_octane.admin_user_event
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_admin_user_event__etl_batch_id ON history_octane.admin_user_event (etl_batch_id);

--adding etl_batch_id to history_octane.admin_user_event_type
ALTER TABLE history_octane.admin_user_event_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_admin_user_event_type__etl_batch_id ON history_octane.admin_user_event_type (etl_batch_id);

--adding etl_batch_id to history_octane.admin_user_status_type
ALTER TABLE history_octane.admin_user_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_admin_user_status_type__etl_batch_id ON history_octane.admin_user_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.agency_type
ALTER TABLE history_octane.agency_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_agency_type__etl_batch_id ON history_octane.agency_type (etl_batch_id);

--adding etl_batch_id to history_octane.agent_type
ALTER TABLE history_octane.agent_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_agent_type__etl_batch_id ON history_octane.agent_type (etl_batch_id);

--adding etl_batch_id to history_octane.announcement
ALTER TABLE history_octane.announcement
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_announcement__etl_batch_id ON history_octane.announcement (etl_batch_id);

--adding etl_batch_id to history_octane.annual_monthly_type
ALTER TABLE history_octane.annual_monthly_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_annual_monthly_type__etl_batch_id ON history_octane.annual_monthly_type (etl_batch_id);

--adding etl_batch_id to history_octane.apor
ALTER TABLE history_octane.apor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_apor__etl_batch_id ON history_octane.apor (etl_batch_id);

--adding etl_batch_id to history_octane.applicant_role_type
ALTER TABLE history_octane.applicant_role_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_applicant_role_type__etl_batch_id ON history_octane.applicant_role_type (etl_batch_id);

--adding etl_batch_id to history_octane.application
ALTER TABLE history_octane.application
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_application__etl_batch_id ON history_octane.application (etl_batch_id);

--adding etl_batch_id to history_octane.application_taken_method_type
ALTER TABLE history_octane.application_taken_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_application_taken_method_type__etl_batch_id ON history_octane.application_taken_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.application_type
ALTER TABLE history_octane.application_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_application_type__etl_batch_id ON history_octane.application_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal
ALTER TABLE history_octane.appraisal
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal__etl_batch_id ON history_octane.appraisal (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_condition_type
ALTER TABLE history_octane.appraisal_condition_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_condition_type__etl_batch_id ON history_octane.appraisal_condition_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_entry_contact_type
ALTER TABLE history_octane.appraisal_entry_contact_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_entry_contact_type__etl_batch_id ON history_octane.appraisal_entry_contact_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_file
ALTER TABLE history_octane.appraisal_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_file__etl_batch_id ON history_octane.appraisal_file (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_file_type
ALTER TABLE history_octane.appraisal_file_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_file_type__etl_batch_id ON history_octane.appraisal_file_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_form
ALTER TABLE history_octane.appraisal_form
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_form__etl_batch_id ON history_octane.appraisal_form (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_form_type
ALTER TABLE history_octane.appraisal_form_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_form_type__etl_batch_id ON history_octane.appraisal_form_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_hold_reason_type
ALTER TABLE history_octane.appraisal_hold_reason_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_hold_reason_type__etl_batch_id ON history_octane.appraisal_hold_reason_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_hold_type
ALTER TABLE history_octane.appraisal_hold_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_hold_type__etl_batch_id ON history_octane.appraisal_hold_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_id_ticker
ALTER TABLE history_octane.appraisal_id_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_id_ticker__etl_batch_id ON history_octane.appraisal_id_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_management_company_type
ALTER TABLE history_octane.appraisal_management_company_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_management_company_type__etl_batch_id ON history_octane.appraisal_management_company_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_order_coarse_status_type
ALTER TABLE history_octane.appraisal_order_coarse_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_order_coarse_status_type__etl_batch_id ON history_octane.appraisal_order_coarse_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_order_request
ALTER TABLE history_octane.appraisal_order_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_order_request__etl_batch_id ON history_octane.appraisal_order_request (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_order_request_file
ALTER TABLE history_octane.appraisal_order_request_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_order_request_file__etl_batch_id ON history_octane.appraisal_order_request_file (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_order_request_file_type
ALTER TABLE history_octane.appraisal_order_request_file_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_order_request_file_type__etl_batch_id ON history_octane.appraisal_order_request_file_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_order_request_type
ALTER TABLE history_octane.appraisal_order_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_order_request_type__etl_batch_id ON history_octane.appraisal_order_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_order_status_type
ALTER TABLE history_octane.appraisal_order_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_order_status_type__etl_batch_id ON history_octane.appraisal_order_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_purpose_type
ALTER TABLE history_octane.appraisal_purpose_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_purpose_type__etl_batch_id ON history_octane.appraisal_purpose_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_source_type
ALTER TABLE history_octane.appraisal_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_source_type__etl_batch_id ON history_octane.appraisal_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.appraisal_underwriter_type
ALTER TABLE history_octane.appraisal_underwriter_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_appraisal_underwriter_type__etl_batch_id ON history_octane.appraisal_underwriter_type (etl_batch_id);

--adding etl_batch_id to history_octane.area_median_income_row
ALTER TABLE history_octane.area_median_income_row
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_area_median_income_row__etl_batch_id ON history_octane.area_median_income_row (etl_batch_id);

--adding etl_batch_id to history_octane.area_median_income_table
ALTER TABLE history_octane.area_median_income_table
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_area_median_income_table__etl_batch_id ON history_octane.area_median_income_table (etl_batch_id);

--adding etl_batch_id to history_octane.arm_index_rate
ALTER TABLE history_octane.arm_index_rate
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_arm_index_rate__etl_batch_id ON history_octane.arm_index_rate (etl_batch_id);

--adding etl_batch_id to history_octane.arm_index_type
ALTER TABLE history_octane.arm_index_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_arm_index_type__etl_batch_id ON history_octane.arm_index_type (etl_batch_id);

--adding etl_batch_id to history_octane.asset
ALTER TABLE history_octane.asset
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_asset__etl_batch_id ON history_octane.asset (etl_batch_id);

--adding etl_batch_id to history_octane.asset_account_holder_type
ALTER TABLE history_octane.asset_account_holder_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_asset_account_holder_type__etl_batch_id ON history_octane.asset_account_holder_type (etl_batch_id);

--adding etl_batch_id to history_octane.asset_large_deposit
ALTER TABLE history_octane.asset_large_deposit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_asset_large_deposit__etl_batch_id ON history_octane.asset_large_deposit (etl_batch_id);

--adding etl_batch_id to history_octane.asset_type
ALTER TABLE history_octane.asset_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_asset_type__etl_batch_id ON history_octane.asset_type (etl_batch_id);

--adding etl_batch_id to history_octane.aus_credit_service_type
ALTER TABLE history_octane.aus_credit_service_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_aus_credit_service_type__etl_batch_id ON history_octane.aus_credit_service_type (etl_batch_id);

--adding etl_batch_id to history_octane.aus_request_number_ticker
ALTER TABLE history_octane.aus_request_number_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_aus_request_number_ticker__etl_batch_id ON history_octane.aus_request_number_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.aus_type
ALTER TABLE history_octane.aus_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_aus_type__etl_batch_id ON history_octane.aus_type (etl_batch_id);

--adding etl_batch_id to history_octane.backfill_loan_status
ALTER TABLE history_octane.backfill_loan_status
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_backfill_loan_status__etl_batch_id ON history_octane.backfill_loan_status (etl_batch_id);

--adding etl_batch_id to history_octane.backfill_status
ALTER TABLE history_octane.backfill_status
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_backfill_status__etl_batch_id ON history_octane.backfill_status (etl_batch_id);

--adding etl_batch_id to history_octane.backfill_status_type
ALTER TABLE history_octane.backfill_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_backfill_status_type__etl_batch_id ON history_octane.backfill_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.bankruptcy_exception_type
ALTER TABLE history_octane.bankruptcy_exception_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bankruptcy_exception_type__etl_batch_id ON history_octane.bankruptcy_exception_type (etl_batch_id);

--adding etl_batch_id to history_octane.bid_pool
ALTER TABLE history_octane.bid_pool
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bid_pool__etl_batch_id ON history_octane.bid_pool (etl_batch_id);

--adding etl_batch_id to history_octane.bid_pool_file
ALTER TABLE history_octane.bid_pool_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bid_pool_file__etl_batch_id ON history_octane.bid_pool_file (etl_batch_id);

--adding etl_batch_id to history_octane.bid_pool_lender_lock
ALTER TABLE history_octane.bid_pool_lender_lock
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bid_pool_lender_lock__etl_batch_id ON history_octane.bid_pool_lender_lock (etl_batch_id);

--adding etl_batch_id to history_octane.bid_pool_note
ALTER TABLE history_octane.bid_pool_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bid_pool_note__etl_batch_id ON history_octane.bid_pool_note (etl_batch_id);

--adding etl_batch_id to history_octane.bid_pool_note_comment
ALTER TABLE history_octane.bid_pool_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bid_pool_note_comment__etl_batch_id ON history_octane.bid_pool_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.bid_pool_note_monitor
ALTER TABLE history_octane.bid_pool_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bid_pool_note_monitor__etl_batch_id ON history_octane.bid_pool_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.bid_pool_status_type
ALTER TABLE history_octane.bid_pool_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_bid_pool_status_type__etl_batch_id ON history_octane.bid_pool_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower
ALTER TABLE history_octane.borrower
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower__etl_batch_id ON history_octane.borrower (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_alias
ALTER TABLE history_octane.borrower_alias
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_alias__etl_batch_id ON history_octane.borrower_alias (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_asset
ALTER TABLE history_octane.borrower_asset
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_asset__etl_batch_id ON history_octane.borrower_asset (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_associated_address
ALTER TABLE history_octane.borrower_associated_address
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_associated_address__etl_batch_id ON history_octane.borrower_associated_address (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_associated_address_explanation_type
ALTER TABLE history_octane.borrower_associated_address_explanation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_associated_address_explanation_type__etl_batch_id ON history_octane.borrower_associated_address_explanation_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_associated_address_source_type
ALTER TABLE history_octane.borrower_associated_address_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_associated_address_source_type__etl_batch_id ON history_octane.borrower_associated_address_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_credit_inquiry
ALTER TABLE history_octane.borrower_credit_inquiry
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_credit_inquiry__etl_batch_id ON history_octane.borrower_credit_inquiry (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_declarations
ALTER TABLE history_octane.borrower_declarations
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_declarations__etl_batch_id ON history_octane.borrower_declarations (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_dependent
ALTER TABLE history_octane.borrower_dependent
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_dependent__etl_batch_id ON history_octane.borrower_dependent (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_income
ALTER TABLE history_octane.borrower_income
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_income__etl_batch_id ON history_octane.borrower_income (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_income_category_type
ALTER TABLE history_octane.borrower_income_category_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_income_category_type__etl_batch_id ON history_octane.borrower_income_category_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_job_gap
ALTER TABLE history_octane.borrower_job_gap
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_job_gap__etl_batch_id ON history_octane.borrower_job_gap (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_liability
ALTER TABLE history_octane.borrower_liability
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_liability__etl_batch_id ON history_octane.borrower_liability (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_public_record
ALTER TABLE history_octane.borrower_public_record
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_public_record__etl_batch_id ON history_octane.borrower_public_record (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_relationship_type
ALTER TABLE history_octane.borrower_relationship_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_relationship_type__etl_batch_id ON history_octane.borrower_relationship_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_reo
ALTER TABLE history_octane.borrower_reo
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_reo__etl_batch_id ON history_octane.borrower_reo (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_residence
ALTER TABLE history_octane.borrower_residence
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_residence__etl_batch_id ON history_octane.borrower_residence (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_residency_basis_type
ALTER TABLE history_octane.borrower_residency_basis_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_residency_basis_type__etl_batch_id ON history_octane.borrower_residency_basis_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_tax_filing
ALTER TABLE history_octane.borrower_tax_filing
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_tax_filing__etl_batch_id ON history_octane.borrower_tax_filing (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_tiny_id_type
ALTER TABLE history_octane.borrower_tiny_id_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_tiny_id_type__etl_batch_id ON history_octane.borrower_tiny_id_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_user
ALTER TABLE history_octane.borrower_user
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_user__etl_batch_id ON history_octane.borrower_user (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_user_account_status_type
ALTER TABLE history_octane.borrower_user_account_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_user_account_status_type__etl_batch_id ON history_octane.borrower_user_account_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_user_change_email
ALTER TABLE history_octane.borrower_user_change_email
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_user_change_email__etl_batch_id ON history_octane.borrower_user_change_email (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_user_deal
ALTER TABLE history_octane.borrower_user_deal
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_user_deal__etl_batch_id ON history_octane.borrower_user_deal (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_user_deal_access_type
ALTER TABLE history_octane.borrower_user_deal_access_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_user_deal_access_type__etl_batch_id ON history_octane.borrower_user_deal_access_type (etl_batch_id);

--adding etl_batch_id to history_octane.borrower_va
ALTER TABLE history_octane.borrower_va
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_borrower_va__etl_batch_id ON history_octane.borrower_va (etl_batch_id);

--adding etl_batch_id to history_octane.branch
ALTER TABLE history_octane.branch
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_branch__etl_batch_id ON history_octane.branch (etl_batch_id);

--adding etl_batch_id to history_octane.branch_account_executive
ALTER TABLE history_octane.branch_account_executive
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_branch_account_executive__etl_batch_id ON history_octane.branch_account_executive (etl_batch_id);

--adding etl_batch_id to history_octane.branch_license
ALTER TABLE history_octane.branch_license
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_branch_license__etl_batch_id ON history_octane.branch_license (etl_batch_id);

--adding etl_batch_id to history_octane.branch_status_type
ALTER TABLE history_octane.branch_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_branch_status_type__etl_batch_id ON history_octane.branch_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.building_status_type
ALTER TABLE history_octane.building_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_building_status_type__etl_batch_id ON history_octane.building_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.business_disposition_type
ALTER TABLE history_octane.business_disposition_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_business_disposition_type__etl_batch_id ON history_octane.business_disposition_type (etl_batch_id);

--adding etl_batch_id to history_octane.business_income
ALTER TABLE history_octane.business_income
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_business_income__etl_batch_id ON history_octane.business_income (etl_batch_id);

--adding etl_batch_id to history_octane.business_income_type
ALTER TABLE history_octane.business_income_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_business_income_type__etl_batch_id ON history_octane.business_income_type (etl_batch_id);

--adding etl_batch_id to history_octane.business_ownership_type
ALTER TABLE history_octane.business_ownership_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_business_ownership_type__etl_batch_id ON history_octane.business_ownership_type (etl_batch_id);

--adding etl_batch_id to history_octane.buydown_base_date_type
ALTER TABLE history_octane.buydown_base_date_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_buydown_base_date_type__etl_batch_id ON history_octane.buydown_base_date_type (etl_batch_id);

--adding etl_batch_id to history_octane.buydown_contributor_type
ALTER TABLE history_octane.buydown_contributor_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_buydown_contributor_type__etl_batch_id ON history_octane.buydown_contributor_type (etl_batch_id);

--adding etl_batch_id to history_octane.buydown_schedule_type
ALTER TABLE history_octane.buydown_schedule_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_buydown_schedule_type__etl_batch_id ON history_octane.buydown_schedule_type (etl_batch_id);

--adding etl_batch_id to history_octane.buydown_subsidy_calculation_type
ALTER TABLE history_octane.buydown_subsidy_calculation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_buydown_subsidy_calculation_type__etl_batch_id ON history_octane.buydown_subsidy_calculation_type (etl_batch_id);

--adding etl_batch_id to history_octane.calendar_rule_type
ALTER TABLE history_octane.calendar_rule_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_calendar_rule_type__etl_batch_id ON history_octane.calendar_rule_type (etl_batch_id);

--adding etl_batch_id to history_octane.challenge_question_type
ALTER TABLE history_octane.challenge_question_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_challenge_question_type__etl_batch_id ON history_octane.challenge_question_type (etl_batch_id);

--adding etl_batch_id to history_octane.channel
ALTER TABLE history_octane.channel
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_channel__etl_batch_id ON history_octane.channel (etl_batch_id);

--adding etl_batch_id to history_octane.channel_type
ALTER TABLE history_octane.channel_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_channel_type__etl_batch_id ON history_octane.channel_type (etl_batch_id);

--adding etl_batch_id to history_octane.charge_input_type
ALTER TABLE history_octane.charge_input_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_charge_input_type__etl_batch_id ON history_octane.charge_input_type (etl_batch_id);

--adding etl_batch_id to history_octane.charge_payee_type
ALTER TABLE history_octane.charge_payee_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_charge_payee_type__etl_batch_id ON history_octane.charge_payee_type (etl_batch_id);

--adding etl_batch_id to history_octane.charge_payer_type
ALTER TABLE history_octane.charge_payer_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_charge_payer_type__etl_batch_id ON history_octane.charge_payer_type (etl_batch_id);

--adding etl_batch_id to history_octane.charge_source_type
ALTER TABLE history_octane.charge_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_charge_source_type__etl_batch_id ON history_octane.charge_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.charge_type
ALTER TABLE history_octane.charge_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_charge_type__etl_batch_id ON history_octane.charge_type (etl_batch_id);

--adding etl_batch_id to history_octane.charge_wire_action_type
ALTER TABLE history_octane.charge_wire_action_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_charge_wire_action_type__etl_batch_id ON history_octane.charge_wire_action_type (etl_batch_id);

--adding etl_batch_id to history_octane.circumstance_change
ALTER TABLE history_octane.circumstance_change
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_circumstance_change__etl_batch_id ON history_octane.circumstance_change (etl_batch_id);

--adding etl_batch_id to history_octane.circumstance_change_type
ALTER TABLE history_octane.circumstance_change_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_circumstance_change_type__etl_batch_id ON history_octane.circumstance_change_type (etl_batch_id);

--adding etl_batch_id to history_octane.citizenship_residency_type
ALTER TABLE history_octane.citizenship_residency_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_citizenship_residency_type__etl_batch_id ON history_octane.citizenship_residency_type (etl_batch_id);

--adding etl_batch_id to history_octane.clg_flood_cert_status_type
ALTER TABLE history_octane.clg_flood_cert_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_clg_flood_cert_status_type__etl_batch_id ON history_octane.clg_flood_cert_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.closing_document_status_type
ALTER TABLE history_octane.closing_document_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_closing_document_status_type__etl_batch_id ON history_octane.closing_document_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.coarse_event_type
ALTER TABLE history_octane.coarse_event_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_coarse_event_type__etl_batch_id ON history_octane.coarse_event_type (etl_batch_id);

--adding etl_batch_id to history_octane.community_lending_type
ALTER TABLE history_octane.community_lending_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_community_lending_type__etl_batch_id ON history_octane.community_lending_type (etl_batch_id);

--adding etl_batch_id to history_octane.company
ALTER TABLE history_octane.company
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company__etl_batch_id ON history_octane.company (etl_batch_id);

--adding etl_batch_id to history_octane.company_admin_event
ALTER TABLE history_octane.company_admin_event
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company_admin_event__etl_batch_id ON history_octane.company_admin_event (etl_batch_id);

--adding etl_batch_id to history_octane.company_admin_event_entity_type
ALTER TABLE history_octane.company_admin_event_entity_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company_admin_event_entity_type__etl_batch_id ON history_octane.company_admin_event_entity_type (etl_batch_id);

--adding etl_batch_id to history_octane.company_license
ALTER TABLE history_octane.company_license
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company_license__etl_batch_id ON history_octane.company_license (etl_batch_id);

--adding etl_batch_id to history_octane.company_license_contact
ALTER TABLE history_octane.company_license_contact
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company_license_contact__etl_batch_id ON history_octane.company_license_contact (etl_batch_id);

--adding etl_batch_id to history_octane.company_location
ALTER TABLE history_octane.company_location
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company_location__etl_batch_id ON history_octane.company_location (etl_batch_id);

--adding etl_batch_id to history_octane.company_location_type
ALTER TABLE history_octane.company_location_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company_location_type__etl_batch_id ON history_octane.company_location_type (etl_batch_id);

--adding etl_batch_id to history_octane.company_state_license_type
ALTER TABLE history_octane.company_state_license_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_company_state_license_type__etl_batch_id ON history_octane.company_state_license_type (etl_batch_id);

--adding etl_batch_id to history_octane.compass_analytics_report_request
ALTER TABLE history_octane.compass_analytics_report_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_compass_analytics_report_request__etl_batch_id ON history_octane.compass_analytics_report_request (etl_batch_id);

--adding etl_batch_id to history_octane.config_export_permission_type
ALTER TABLE history_octane.config_export_permission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_config_export_permission_type__etl_batch_id ON history_octane.config_export_permission_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_cost
ALTER TABLE history_octane.construction_cost
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_cost__etl_batch_id ON history_octane.construction_cost (etl_batch_id);

--adding etl_batch_id to history_octane.construction_cost_calculation_type
ALTER TABLE history_octane.construction_cost_calculation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_cost_calculation_type__etl_batch_id ON history_octane.construction_cost_calculation_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_cost_category_type
ALTER TABLE history_octane.construction_cost_category_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_cost_category_type__etl_batch_id ON history_octane.construction_cost_category_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_cost_funding_type
ALTER TABLE history_octane.construction_cost_funding_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_cost_funding_type__etl_batch_id ON history_octane.construction_cost_funding_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_cost_payee_type
ALTER TABLE history_octane.construction_cost_payee_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_cost_payee_type__etl_batch_id ON history_octane.construction_cost_payee_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_cost_status_type
ALTER TABLE history_octane.construction_cost_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_cost_status_type__etl_batch_id ON history_octane.construction_cost_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_draw
ALTER TABLE history_octane.construction_draw
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_draw__etl_batch_id ON history_octane.construction_draw (etl_batch_id);

--adding etl_batch_id to history_octane.construction_draw_item
ALTER TABLE history_octane.construction_draw_item
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_draw_item__etl_batch_id ON history_octane.construction_draw_item (etl_batch_id);

--adding etl_batch_id to history_octane.construction_draw_number_ticker
ALTER TABLE history_octane.construction_draw_number_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_draw_number_ticker__etl_batch_id ON history_octane.construction_draw_number_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.construction_draw_status_type
ALTER TABLE history_octane.construction_draw_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_draw_status_type__etl_batch_id ON history_octane.construction_draw_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_draw_type
ALTER TABLE history_octane.construction_draw_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_draw_type__etl_batch_id ON history_octane.construction_draw_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_lot_ownership_status_type
ALTER TABLE history_octane.construction_lot_ownership_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_lot_ownership_status_type__etl_batch_id ON history_octane.construction_lot_ownership_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_permit
ALTER TABLE history_octane.construction_permit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_permit__etl_batch_id ON history_octane.construction_permit (etl_batch_id);

--adding etl_batch_id to history_octane.construction_permit_requested_by_type
ALTER TABLE history_octane.construction_permit_requested_by_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_permit_requested_by_type__etl_batch_id ON history_octane.construction_permit_requested_by_type (etl_batch_id);

--adding etl_batch_id to history_octane.construction_permit_type
ALTER TABLE history_octane.construction_permit_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_construction_permit_type__etl_batch_id ON history_octane.construction_permit_type (etl_batch_id);

--adding etl_batch_id to history_octane.consumer_privacy_affected_borrower
ALTER TABLE history_octane.consumer_privacy_affected_borrower
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_consumer_privacy_affected_borrower__etl_batch_id ON history_octane.consumer_privacy_affected_borrower (etl_batch_id);

--adding etl_batch_id to history_octane.consumer_privacy_request
ALTER TABLE history_octane.consumer_privacy_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_consumer_privacy_request__etl_batch_id ON history_octane.consumer_privacy_request (etl_batch_id);

--adding etl_batch_id to history_octane.consumer_privacy_request_type
ALTER TABLE history_octane.consumer_privacy_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_consumer_privacy_request_type__etl_batch_id ON history_octane.consumer_privacy_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.contractor
ALTER TABLE history_octane.contractor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_contractor__etl_batch_id ON history_octane.contractor (etl_batch_id);

--adding etl_batch_id to history_octane.contractor_license
ALTER TABLE history_octane.contractor_license
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_contractor_license__etl_batch_id ON history_octane.contractor_license (etl_batch_id);

--adding etl_batch_id to history_octane.contractor_validation_status_type
ALTER TABLE history_octane.contractor_validation_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_contractor_validation_status_type__etl_batch_id ON history_octane.contractor_validation_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.cost_center
ALTER TABLE history_octane.cost_center
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_cost_center__etl_batch_id ON history_octane.cost_center (etl_batch_id);

--adding etl_batch_id to history_octane.country_type
ALTER TABLE history_octane.country_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_country_type__etl_batch_id ON history_octane.country_type (etl_batch_id);

--adding etl_batch_id to history_octane.county
ALTER TABLE history_octane.county
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_county__etl_batch_id ON history_octane.county (etl_batch_id);

--adding etl_batch_id to history_octane.county_city
ALTER TABLE history_octane.county_city
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_county_city__etl_batch_id ON history_octane.county_city (etl_batch_id);

--adding etl_batch_id to history_octane.county_recording_district
ALTER TABLE history_octane.county_recording_district
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_county_recording_district__etl_batch_id ON history_octane.county_recording_district (etl_batch_id);

--adding etl_batch_id to history_octane.county_sub_jurisdiction
ALTER TABLE history_octane.county_sub_jurisdiction
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_county_sub_jurisdiction__etl_batch_id ON history_octane.county_sub_jurisdiction (etl_batch_id);

--adding etl_batch_id to history_octane.county_zip_code
ALTER TABLE history_octane.county_zip_code
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_county_zip_code__etl_batch_id ON history_octane.county_zip_code (etl_batch_id);

--adding etl_batch_id to history_octane.courier_type
ALTER TABLE history_octane.courier_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_courier_type__etl_batch_id ON history_octane.courier_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_authorization_method_type
ALTER TABLE history_octane.credit_authorization_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_authorization_method_type__etl_batch_id ON history_octane.credit_authorization_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_bureau_type
ALTER TABLE history_octane.credit_bureau_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_bureau_type__etl_batch_id ON history_octane.credit_bureau_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_business_type
ALTER TABLE history_octane.credit_business_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_business_type__etl_batch_id ON history_octane.credit_business_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_inquiry
ALTER TABLE history_octane.credit_inquiry
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_inquiry__etl_batch_id ON history_octane.credit_inquiry (etl_batch_id);

--adding etl_batch_id to history_octane.credit_inquiry_explanation_type
ALTER TABLE history_octane.credit_inquiry_explanation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_inquiry_explanation_type__etl_batch_id ON history_octane.credit_inquiry_explanation_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_inquiry_result_type
ALTER TABLE history_octane.credit_inquiry_result_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_inquiry_result_type__etl_batch_id ON history_octane.credit_inquiry_result_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_limit
ALTER TABLE history_octane.credit_limit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_limit__etl_batch_id ON history_octane.credit_limit (etl_batch_id);

--adding etl_batch_id to history_octane.credit_limit_type
ALTER TABLE history_octane.credit_limit_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_limit_type__etl_batch_id ON history_octane.credit_limit_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_loan_type
ALTER TABLE history_octane.credit_loan_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_loan_type__etl_batch_id ON history_octane.credit_loan_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_report_request_action_type
ALTER TABLE history_octane.credit_report_request_action_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_report_request_action_type__etl_batch_id ON history_octane.credit_report_request_action_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_report_type
ALTER TABLE history_octane.credit_report_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_report_type__etl_batch_id ON history_octane.credit_report_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_request
ALTER TABLE history_octane.credit_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_request__etl_batch_id ON history_octane.credit_request (etl_batch_id);

--adding etl_batch_id to history_octane.credit_request_liability
ALTER TABLE history_octane.credit_request_liability
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_request_liability__etl_batch_id ON history_octane.credit_request_liability (etl_batch_id);

--adding etl_batch_id to history_octane.credit_request_status_type
ALTER TABLE history_octane.credit_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_request_status_type__etl_batch_id ON history_octane.credit_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_request_type
ALTER TABLE history_octane.credit_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_request_type__etl_batch_id ON history_octane.credit_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_request_via_type
ALTER TABLE history_octane.credit_request_via_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_request_via_type__etl_batch_id ON history_octane.credit_request_via_type (etl_batch_id);

--adding etl_batch_id to history_octane.credit_score_model_type
ALTER TABLE history_octane.credit_score_model_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_credit_score_model_type__etl_batch_id ON history_octane.credit_score_model_type (etl_batch_id);

--adding etl_batch_id to history_octane.creditor
ALTER TABLE history_octane.creditor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_creditor__etl_batch_id ON history_octane.creditor (etl_batch_id);

--adding etl_batch_id to history_octane.creditor_lookup_name
ALTER TABLE history_octane.creditor_lookup_name
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_creditor_lookup_name__etl_batch_id ON history_octane.creditor_lookup_name (etl_batch_id);

--adding etl_batch_id to history_octane.criteria
ALTER TABLE history_octane.criteria
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_criteria__etl_batch_id ON history_octane.criteria (etl_batch_id);

--adding etl_batch_id to history_octane.criteria_owner_type
ALTER TABLE history_octane.criteria_owner_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_criteria_owner_type__etl_batch_id ON history_octane.criteria_owner_type (etl_batch_id);

--adding etl_batch_id to history_octane.criteria_pid_operand
ALTER TABLE history_octane.criteria_pid_operand
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_criteria_pid_operand__etl_batch_id ON history_octane.criteria_pid_operand (etl_batch_id);

--adding etl_batch_id to history_octane.criteria_pid_operand_type
ALTER TABLE history_octane.criteria_pid_operand_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_criteria_pid_operand_type__etl_batch_id ON history_octane.criteria_pid_operand_type (etl_batch_id);

--adding etl_batch_id to history_octane.criteria_snippet
ALTER TABLE history_octane.criteria_snippet
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_criteria_snippet__etl_batch_id ON history_octane.criteria_snippet (etl_batch_id);

--adding etl_batch_id to history_octane.custodian
ALTER TABLE history_octane.custodian
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_custodian__etl_batch_id ON history_octane.custodian (etl_batch_id);

--adding etl_batch_id to history_octane.custom_form
ALTER TABLE history_octane.custom_form
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_custom_form__etl_batch_id ON history_octane.custom_form (etl_batch_id);

--adding etl_batch_id to history_octane.custom_form_merge_field
ALTER TABLE history_octane.custom_form_merge_field
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_custom_form_merge_field__etl_batch_id ON history_octane.custom_form_merge_field (etl_batch_id);

--adding etl_batch_id to history_octane.days_per_year_type
ALTER TABLE history_octane.days_per_year_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_days_per_year_type__etl_batch_id ON history_octane.days_per_year_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal
ALTER TABLE history_octane.deal
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal__etl_batch_id ON history_octane.deal (etl_batch_id);

--adding etl_batch_id to history_octane.deal_appraisal
ALTER TABLE history_octane.deal_appraisal
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_appraisal__etl_batch_id ON history_octane.deal_appraisal (etl_batch_id);

--adding etl_batch_id to history_octane.deal_cancel_reason_type
ALTER TABLE history_octane.deal_cancel_reason_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_cancel_reason_type__etl_batch_id ON history_octane.deal_cancel_reason_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_change_updater_time
ALTER TABLE history_octane.deal_change_updater_time
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_change_updater_time__etl_batch_id ON history_octane.deal_change_updater_time (etl_batch_id);

--adding etl_batch_id to history_octane.deal_check_severity_type
ALTER TABLE history_octane.deal_check_severity_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_check_severity_type__etl_batch_id ON history_octane.deal_check_severity_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_check_type
ALTER TABLE history_octane.deal_check_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_check_type__etl_batch_id ON history_octane.deal_check_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_child_relationship_type
ALTER TABLE history_octane.deal_child_relationship_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_child_relationship_type__etl_batch_id ON history_octane.deal_child_relationship_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_child_type
ALTER TABLE history_octane.deal_child_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_child_type__etl_batch_id ON history_octane.deal_child_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_contact
ALTER TABLE history_octane.deal_contact
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_contact__etl_batch_id ON history_octane.deal_contact (etl_batch_id);

--adding etl_batch_id to history_octane.deal_contact_role_type
ALTER TABLE history_octane.deal_contact_role_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_contact_role_type__etl_batch_id ON history_octane.deal_contact_role_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_context_permission_type
ALTER TABLE history_octane.deal_context_permission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_context_permission_type__etl_batch_id ON history_octane.deal_context_permission_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_create_type
ALTER TABLE history_octane.deal_create_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_create_type__etl_batch_id ON history_octane.deal_create_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_data_vendor_document_import
ALTER TABLE history_octane.deal_data_vendor_document_import
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_data_vendor_document_import__etl_batch_id ON history_octane.deal_data_vendor_document_import (etl_batch_id);

--adding etl_batch_id to history_octane.deal_disaster_declaration
ALTER TABLE history_octane.deal_disaster_declaration
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_disaster_declaration__etl_batch_id ON history_octane.deal_disaster_declaration (etl_batch_id);

--adding etl_batch_id to history_octane.deal_dropbox_file
ALTER TABLE history_octane.deal_dropbox_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_dropbox_file__etl_batch_id ON history_octane.deal_dropbox_file (etl_batch_id);

--adding etl_batch_id to history_octane.deal_du
ALTER TABLE history_octane.deal_du
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_du__etl_batch_id ON history_octane.deal_du (etl_batch_id);

--adding etl_batch_id to history_octane.deal_event
ALTER TABLE history_octane.deal_event
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_event__etl_batch_id ON history_octane.deal_event (etl_batch_id);

--adding etl_batch_id to history_octane.deal_event_type
ALTER TABLE history_octane.deal_event_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_event_type__etl_batch_id ON history_octane.deal_event_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_file
ALTER TABLE history_octane.deal_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_file__etl_batch_id ON history_octane.deal_file (etl_batch_id);

--adding etl_batch_id to history_octane.deal_file_signature
ALTER TABLE history_octane.deal_file_signature
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_file_signature__etl_batch_id ON history_octane.deal_file_signature (etl_batch_id);

--adding etl_batch_id to history_octane.deal_file_thumbnail
ALTER TABLE history_octane.deal_file_thumbnail
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_file_thumbnail__etl_batch_id ON history_octane.deal_file_thumbnail (etl_batch_id);

--adding etl_batch_id to history_octane.deal_fraud_risk
ALTER TABLE history_octane.deal_fraud_risk
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_fraud_risk__etl_batch_id ON history_octane.deal_fraud_risk (etl_batch_id);

--adding etl_batch_id to history_octane.deal_housing_counselor_candidate
ALTER TABLE history_octane.deal_housing_counselor_candidate
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_housing_counselor_candidate__etl_batch_id ON history_octane.deal_housing_counselor_candidate (etl_batch_id);

--adding etl_batch_id to history_octane.deal_housing_counselors_request
ALTER TABLE history_octane.deal_housing_counselors_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_housing_counselors_request__etl_batch_id ON history_octane.deal_housing_counselors_request (etl_batch_id);

--adding etl_batch_id to history_octane.deal_id_sequence
ALTER TABLE history_octane.deal_id_sequence
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_id_sequence__etl_batch_id ON history_octane.deal_id_sequence (etl_batch_id);

--adding etl_batch_id to history_octane.deal_invoice
ALTER TABLE history_octane.deal_invoice
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_invoice__etl_batch_id ON history_octane.deal_invoice (etl_batch_id);

--adding etl_batch_id to history_octane.deal_invoice_file
ALTER TABLE history_octane.deal_invoice_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_invoice_file__etl_batch_id ON history_octane.deal_invoice_file (etl_batch_id);

--adding etl_batch_id to history_octane.deal_invoice_file_type
ALTER TABLE history_octane.deal_invoice_file_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_invoice_file_type__etl_batch_id ON history_octane.deal_invoice_file_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_invoice_item
ALTER TABLE history_octane.deal_invoice_item
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_invoice_item__etl_batch_id ON history_octane.deal_invoice_item (etl_batch_id);

--adding etl_batch_id to history_octane.deal_invoice_payment_method
ALTER TABLE history_octane.deal_invoice_payment_method
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_invoice_payment_method__etl_batch_id ON history_octane.deal_invoice_payment_method (etl_batch_id);

--adding etl_batch_id to history_octane.deal_invoice_status_type
ALTER TABLE history_octane.deal_invoice_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_invoice_status_type__etl_batch_id ON history_octane.deal_invoice_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_key_roles
ALTER TABLE history_octane.deal_key_roles
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_key_roles__etl_batch_id ON history_octane.deal_key_roles (etl_batch_id);

--adding etl_batch_id to history_octane.deal_lender_user
ALTER TABLE history_octane.deal_lender_user
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_lender_user__etl_batch_id ON history_octane.deal_lender_user (etl_batch_id);

--adding etl_batch_id to history_octane.deal_lender_user_event
ALTER TABLE history_octane.deal_lender_user_event
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_lender_user_event__etl_batch_id ON history_octane.deal_lender_user_event (etl_batch_id);

--adding etl_batch_id to history_octane.deal_lp
ALTER TABLE history_octane.deal_lp
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_lp__etl_batch_id ON history_octane.deal_lp (etl_batch_id);

--adding etl_batch_id to history_octane.deal_message_log
ALTER TABLE history_octane.deal_message_log
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_message_log__etl_batch_id ON history_octane.deal_message_log (etl_batch_id);

--adding etl_batch_id to history_octane.deal_note
ALTER TABLE history_octane.deal_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_note__etl_batch_id ON history_octane.deal_note (etl_batch_id);

--adding etl_batch_id to history_octane.deal_note_category_type
ALTER TABLE history_octane.deal_note_category_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_note_category_type__etl_batch_id ON history_octane.deal_note_category_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_note_comment
ALTER TABLE history_octane.deal_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_note_comment__etl_batch_id ON history_octane.deal_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.deal_note_monitor
ALTER TABLE history_octane.deal_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_note_monitor__etl_batch_id ON history_octane.deal_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.deal_note_role_tag
ALTER TABLE history_octane.deal_note_role_tag
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_note_role_tag__etl_batch_id ON history_octane.deal_note_role_tag (etl_batch_id);

--adding etl_batch_id to history_octane.deal_note_scope_type
ALTER TABLE history_octane.deal_note_scope_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_note_scope_type__etl_batch_id ON history_octane.deal_note_scope_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_orphan_status_type
ALTER TABLE history_octane.deal_orphan_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_orphan_status_type__etl_batch_id ON history_octane.deal_orphan_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_performer_team
ALTER TABLE history_octane.deal_performer_team
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_performer_team__etl_batch_id ON history_octane.deal_performer_team (etl_batch_id);

--adding etl_batch_id to history_octane.deal_performer_team_user
ALTER TABLE history_octane.deal_performer_team_user
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_performer_team_user__etl_batch_id ON history_octane.deal_performer_team_user (etl_batch_id);

--adding etl_batch_id to history_octane.deal_real_estate_agent
ALTER TABLE history_octane.deal_real_estate_agent
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_real_estate_agent__etl_batch_id ON history_octane.deal_real_estate_agent (etl_batch_id);

--adding etl_batch_id to history_octane.deal_sap
ALTER TABLE history_octane.deal_sap
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_sap__etl_batch_id ON history_octane.deal_sap (etl_batch_id);

--adding etl_batch_id to history_octane.deal_settlement
ALTER TABLE history_octane.deal_settlement
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_settlement__etl_batch_id ON history_octane.deal_settlement (etl_batch_id);

--adding etl_batch_id to history_octane.deal_signer
ALTER TABLE history_octane.deal_signer
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_signer__etl_batch_id ON history_octane.deal_signer (etl_batch_id);

--adding etl_batch_id to history_octane.deal_snapshot
ALTER TABLE history_octane.deal_snapshot
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_snapshot__etl_batch_id ON history_octane.deal_snapshot (etl_batch_id);

--adding etl_batch_id to history_octane.deal_stage
ALTER TABLE history_octane.deal_stage
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_stage__etl_batch_id ON history_octane.deal_stage (etl_batch_id);

--adding etl_batch_id to history_octane.deal_stage_type
ALTER TABLE history_octane.deal_stage_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_stage_type__etl_batch_id ON history_octane.deal_stage_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_status_type
ALTER TABLE history_octane.deal_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_status_type__etl_batch_id ON history_octane.deal_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_summary
ALTER TABLE history_octane.deal_summary
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_summary__etl_batch_id ON history_octane.deal_summary (etl_batch_id);

--adding etl_batch_id to history_octane.deal_system_file
ALTER TABLE history_octane.deal_system_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_system_file__etl_batch_id ON history_octane.deal_system_file (etl_batch_id);

--adding etl_batch_id to history_octane.deal_tag
ALTER TABLE history_octane.deal_tag
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_tag__etl_batch_id ON history_octane.deal_tag (etl_batch_id);

--adding etl_batch_id to history_octane.deal_tag_access_type
ALTER TABLE history_octane.deal_tag_access_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_tag_access_type__etl_batch_id ON history_octane.deal_tag_access_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_tag_definition
ALTER TABLE history_octane.deal_tag_definition
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_tag_definition__etl_batch_id ON history_octane.deal_tag_definition (etl_batch_id);

--adding etl_batch_id to history_octane.deal_tag_level_type
ALTER TABLE history_octane.deal_tag_level_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_tag_level_type__etl_batch_id ON history_octane.deal_tag_level_type (etl_batch_id);

--adding etl_batch_id to history_octane.deal_task
ALTER TABLE history_octane.deal_task
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_task__etl_batch_id ON history_octane.deal_task (etl_batch_id);

--adding etl_batch_id to history_octane.deal_task_status_type
ALTER TABLE history_octane.deal_task_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_deal_task_status_type__etl_batch_id ON history_octane.deal_task_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.decision_credit_score_calc_type
ALTER TABLE history_octane.decision_credit_score_calc_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_decision_credit_score_calc_type__etl_batch_id ON history_octane.decision_credit_score_calc_type (etl_batch_id);

--adding etl_batch_id to history_octane.delivery_aus_type
ALTER TABLE history_octane.delivery_aus_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_delivery_aus_type__etl_batch_id ON history_octane.delivery_aus_type (etl_batch_id);

--adding etl_batch_id to history_octane.disaster_declaration
ALTER TABLE history_octane.disaster_declaration
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_disaster_declaration__etl_batch_id ON history_octane.disaster_declaration (etl_batch_id);

--adding etl_batch_id to history_octane.disaster_declaration_check_date_type
ALTER TABLE history_octane.disaster_declaration_check_date_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_disaster_declaration_check_date_type__etl_batch_id ON history_octane.disaster_declaration_check_date_type (etl_batch_id);

--adding etl_batch_id to history_octane.disclosure_action_type
ALTER TABLE history_octane.disclosure_action_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_disclosure_action_type__etl_batch_id ON history_octane.disclosure_action_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_action_type
ALTER TABLE history_octane.doc_action_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_action_type__etl_batch_id ON history_octane.doc_action_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_approval_type
ALTER TABLE history_octane.doc_approval_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_approval_type__etl_batch_id ON history_octane.doc_approval_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_borrower_access_mode_type
ALTER TABLE history_octane.doc_borrower_access_mode_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_borrower_access_mode_type__etl_batch_id ON history_octane.doc_borrower_access_mode_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_category_type
ALTER TABLE history_octane.doc_category_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_category_type__etl_batch_id ON history_octane.doc_category_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_external_provider_type
ALTER TABLE history_octane.doc_external_provider_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_external_provider_type__etl_batch_id ON history_octane.doc_external_provider_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_file_source_type
ALTER TABLE history_octane.doc_file_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_file_source_type__etl_batch_id ON history_octane.doc_file_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_fulfill_status_type
ALTER TABLE history_octane.doc_fulfill_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_fulfill_status_type__etl_batch_id ON history_octane.doc_fulfill_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_key_date_type
ALTER TABLE history_octane.doc_key_date_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_key_date_type__etl_batch_id ON history_octane.doc_key_date_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_level_type
ALTER TABLE history_octane.doc_level_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_level_type__etl_batch_id ON history_octane.doc_level_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_package_canceled_reason_type
ALTER TABLE history_octane.doc_package_canceled_reason_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_package_canceled_reason_type__etl_batch_id ON history_octane.doc_package_canceled_reason_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_package_delivery_method_type
ALTER TABLE history_octane.doc_package_delivery_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_package_delivery_method_type__etl_batch_id ON history_octane.doc_package_delivery_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_package_status_type
ALTER TABLE history_octane.doc_package_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_package_status_type__etl_batch_id ON history_octane.doc_package_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_permission_type
ALTER TABLE history_octane.doc_permission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_permission_type__etl_batch_id ON history_octane.doc_permission_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_provider_group_type
ALTER TABLE history_octane.doc_provider_group_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_provider_group_type__etl_batch_id ON history_octane.doc_provider_group_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_req_fulfill_status_type
ALTER TABLE history_octane.doc_req_fulfill_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_req_fulfill_status_type__etl_batch_id ON history_octane.doc_req_fulfill_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_set_type
ALTER TABLE history_octane.doc_set_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_set_type__etl_batch_id ON history_octane.doc_set_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_status_type
ALTER TABLE history_octane.doc_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_status_type__etl_batch_id ON history_octane.doc_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.doc_validity_type
ALTER TABLE history_octane.doc_validity_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_doc_validity_type__etl_batch_id ON history_octane.doc_validity_type (etl_batch_id);

--adding etl_batch_id to history_octane.document_import_status_type
ALTER TABLE history_octane.document_import_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_document_import_status_type__etl_batch_id ON history_octane.document_import_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.document_import_vendor_type
ALTER TABLE history_octane.document_import_vendor_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_document_import_vendor_type__etl_batch_id ON history_octane.document_import_vendor_type (etl_batch_id);

--adding etl_batch_id to history_octane.docusign_package
ALTER TABLE history_octane.docusign_package
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_docusign_package__etl_batch_id ON history_octane.docusign_package (etl_batch_id);

--adding etl_batch_id to history_octane.du_finding
ALTER TABLE history_octane.du_finding
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_finding__etl_batch_id ON history_octane.du_finding (etl_batch_id);

--adding etl_batch_id to history_octane.du_finding_message_type
ALTER TABLE history_octane.du_finding_message_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_finding_message_type__etl_batch_id ON history_octane.du_finding_message_type (etl_batch_id);

--adding etl_batch_id to history_octane.du_key_finding
ALTER TABLE history_octane.du_key_finding
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_key_finding__etl_batch_id ON history_octane.du_key_finding (etl_batch_id);

--adding etl_batch_id to history_octane.du_key_finding_type
ALTER TABLE history_octane.du_key_finding_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_key_finding_type__etl_batch_id ON history_octane.du_key_finding_type (etl_batch_id);

--adding etl_batch_id to history_octane.du_recommendation_type
ALTER TABLE history_octane.du_recommendation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_recommendation_type__etl_batch_id ON history_octane.du_recommendation_type (etl_batch_id);

--adding etl_batch_id to history_octane.du_refi_plus_finding
ALTER TABLE history_octane.du_refi_plus_finding
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_refi_plus_finding__etl_batch_id ON history_octane.du_refi_plus_finding (etl_batch_id);

--adding etl_batch_id to history_octane.du_request
ALTER TABLE history_octane.du_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_request__etl_batch_id ON history_octane.du_request (etl_batch_id);

--adding etl_batch_id to history_octane.du_request_credit
ALTER TABLE history_octane.du_request_credit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_request_credit__etl_batch_id ON history_octane.du_request_credit (etl_batch_id);

--adding etl_batch_id to history_octane.du_request_status_type
ALTER TABLE history_octane.du_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_request_status_type__etl_batch_id ON history_octane.du_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.du_special_feature_code
ALTER TABLE history_octane.du_special_feature_code
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_du_special_feature_code__etl_batch_id ON history_octane.du_special_feature_code (etl_batch_id);

--adding etl_batch_id to history_octane.dw_export_request
ALTER TABLE history_octane.dw_export_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_dw_export_request__etl_batch_id ON history_octane.dw_export_request (etl_batch_id);

--adding etl_batch_id to history_octane.dw_export_request_status_type
ALTER TABLE history_octane.dw_export_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_dw_export_request_status_type__etl_batch_id ON history_octane.dw_export_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.ecoa_denial_reason_type
ALTER TABLE history_octane.ecoa_denial_reason_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ecoa_denial_reason_type__etl_batch_id ON history_octane.ecoa_denial_reason_type (etl_batch_id);

--adding etl_batch_id to history_octane.effective_property_value_explanation_type
ALTER TABLE history_octane.effective_property_value_explanation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_effective_property_value_explanation_type__etl_batch_id ON history_octane.effective_property_value_explanation_type (etl_batch_id);

--adding etl_batch_id to history_octane.effective_property_value_type
ALTER TABLE history_octane.effective_property_value_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_effective_property_value_type__etl_batch_id ON history_octane.effective_property_value_type (etl_batch_id);

--adding etl_batch_id to history_octane.email_closing_type
ALTER TABLE history_octane.email_closing_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_email_closing_type__etl_batch_id ON history_octane.email_closing_type (etl_batch_id);

--adding etl_batch_id to history_octane.ernst_deed_request_type
ALTER TABLE history_octane.ernst_deed_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ernst_deed_request_type__etl_batch_id ON history_octane.ernst_deed_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.ernst_page_rec_type
ALTER TABLE history_octane.ernst_page_rec_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ernst_page_rec_type__etl_batch_id ON history_octane.ernst_page_rec_type (etl_batch_id);

--adding etl_batch_id to history_octane.ernst_request
ALTER TABLE history_octane.ernst_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ernst_request__etl_batch_id ON history_octane.ernst_request (etl_batch_id);

--adding etl_batch_id to history_octane.ernst_request_question
ALTER TABLE history_octane.ernst_request_question
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ernst_request_question__etl_batch_id ON history_octane.ernst_request_question (etl_batch_id);

--adding etl_batch_id to history_octane.ernst_request_status_type
ALTER TABLE history_octane.ernst_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ernst_request_status_type__etl_batch_id ON history_octane.ernst_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.ernst_security_instrument_request_type
ALTER TABLE history_octane.ernst_security_instrument_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ernst_security_instrument_request_type__etl_batch_id ON history_octane.ernst_security_instrument_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.esign_package_status_type
ALTER TABLE history_octane.esign_package_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_esign_package_status_type__etl_batch_id ON history_octane.esign_package_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.esign_vendor_type
ALTER TABLE history_octane.esign_vendor_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_esign_vendor_type__etl_batch_id ON history_octane.esign_vendor_type (etl_batch_id);

--adding etl_batch_id to history_octane.exclusive_assignment
ALTER TABLE history_octane.exclusive_assignment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_exclusive_assignment__etl_batch_id ON history_octane.exclusive_assignment (etl_batch_id);

--adding etl_batch_id to history_octane.export_permission_type
ALTER TABLE history_octane.export_permission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_export_permission_type__etl_batch_id ON history_octane.export_permission_type (etl_batch_id);

--adding etl_batch_id to history_octane.export_type
ALTER TABLE history_octane.export_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_export_type__etl_batch_id ON history_octane.export_type (etl_batch_id);

--adding etl_batch_id to history_octane.external_entity_type
ALTER TABLE history_octane.external_entity_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_external_entity_type__etl_batch_id ON history_octane.external_entity_type (etl_batch_id);

--adding etl_batch_id to history_octane.fault_tolerant_event_registration
ALTER TABLE history_octane.fault_tolerant_event_registration
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fault_tolerant_event_registration__etl_batch_id ON history_octane.fault_tolerant_event_registration (etl_batch_id);

--adding etl_batch_id to history_octane.fema_flood_zone_designation_type
ALTER TABLE history_octane.fema_flood_zone_designation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fema_flood_zone_designation_type__etl_batch_id ON history_octane.fema_flood_zone_designation_type (etl_batch_id);

--adding etl_batch_id to history_octane.fha_non_arms_length_ltv_limit_exception_type
ALTER TABLE history_octane.fha_non_arms_length_ltv_limit_exception_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fha_non_arms_length_ltv_limit_exception_type__etl_batch_id ON history_octane.fha_non_arms_length_ltv_limit_exception_type (etl_batch_id);

--adding etl_batch_id to history_octane.fha_program_code_type
ALTER TABLE history_octane.fha_program_code_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fha_program_code_type__etl_batch_id ON history_octane.fha_program_code_type (etl_batch_id);

--adding etl_batch_id to history_octane.fha_rehab_program_type
ALTER TABLE history_octane.fha_rehab_program_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fha_rehab_program_type__etl_batch_id ON history_octane.fha_rehab_program_type (etl_batch_id);

--adding etl_batch_id to history_octane.fha_special_program_type
ALTER TABLE history_octane.fha_special_program_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fha_special_program_type__etl_batch_id ON history_octane.fha_special_program_type (etl_batch_id);

--adding etl_batch_id to history_octane.fha_va_bor_cert_sales_price_exceeds_type
ALTER TABLE history_octane.fha_va_bor_cert_sales_price_exceeds_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fha_va_bor_cert_sales_price_exceeds_type__etl_batch_id ON history_octane.fha_va_bor_cert_sales_price_exceeds_type (etl_batch_id);

--adding etl_batch_id to history_octane.field_type
ALTER TABLE history_octane.field_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_field_type__etl_batch_id ON history_octane.field_type (etl_batch_id);

--adding etl_batch_id to history_octane.financed_property_improvements_category_type
ALTER TABLE history_octane.financed_property_improvements_category_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_financed_property_improvements_category_type__etl_batch_id ON history_octane.financed_property_improvements_category_type (etl_batch_id);

--adding etl_batch_id to history_octane.flood_cert
ALTER TABLE history_octane.flood_cert
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_flood_cert__etl_batch_id ON history_octane.flood_cert (etl_batch_id);

--adding etl_batch_id to history_octane.flood_cert_vendor_type
ALTER TABLE history_octane.flood_cert_vendor_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_flood_cert_vendor_type__etl_batch_id ON history_octane.flood_cert_vendor_type (etl_batch_id);

--adding etl_batch_id to history_octane.flood_certificate_type
ALTER TABLE history_octane.flood_certificate_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_flood_certificate_type__etl_batch_id ON history_octane.flood_certificate_type (etl_batch_id);

--adding etl_batch_id to history_octane.fnm_arm_plan_type
ALTER TABLE history_octane.fnm_arm_plan_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fnm_arm_plan_type__etl_batch_id ON history_octane.fnm_arm_plan_type (etl_batch_id);

--adding etl_batch_id to history_octane.fnm_community_lending_product_type
ALTER TABLE history_octane.fnm_community_lending_product_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fnm_community_lending_product_type__etl_batch_id ON history_octane.fnm_community_lending_product_type (etl_batch_id);

--adding etl_batch_id to history_octane.fnm_community_seconds_repayment_structure_type
ALTER TABLE history_octane.fnm_community_seconds_repayment_structure_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_b1752270aec35006da31b8ffd5a3d196 ON history_octane.fnm_community_seconds_repayment_structure_type (etl_batch_id);

--adding etl_batch_id to history_octane.fnm_investor_remittance_type
ALTER TABLE history_octane.fnm_investor_remittance_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fnm_investor_remittance_type__etl_batch_id ON history_octane.fnm_investor_remittance_type (etl_batch_id);

--adding etl_batch_id to history_octane.fnm_mbs_loan_default_loss_party_type
ALTER TABLE history_octane.fnm_mbs_loan_default_loss_party_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fnm_mbs_loan_default_loss_party_type__etl_batch_id ON history_octane.fnm_mbs_loan_default_loss_party_type (etl_batch_id);

--adding etl_batch_id to history_octane.fnm_mbs_reo_marketing_party_type
ALTER TABLE history_octane.fnm_mbs_reo_marketing_party_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fnm_mbs_reo_marketing_party_type__etl_batch_id ON history_octane.fnm_mbs_reo_marketing_party_type (etl_batch_id);

--adding etl_batch_id to history_octane.for_further_credit_type
ALTER TABLE history_octane.for_further_credit_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_for_further_credit_type__etl_batch_id ON history_octane.for_further_credit_type (etl_batch_id);

--adding etl_batch_id to history_octane.formula_report_column
ALTER TABLE history_octane.formula_report_column
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_formula_report_column__etl_batch_id ON history_octane.formula_report_column (etl_batch_id);

--adding etl_batch_id to history_octane.fre_community_program_type
ALTER TABLE history_octane.fre_community_program_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fre_community_program_type__etl_batch_id ON history_octane.fre_community_program_type (etl_batch_id);

--adding etl_batch_id to history_octane.fre_ctp_closing_feature_type
ALTER TABLE history_octane.fre_ctp_closing_feature_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fre_ctp_closing_feature_type__etl_batch_id ON history_octane.fre_ctp_closing_feature_type (etl_batch_id);

--adding etl_batch_id to history_octane.fre_ctp_closing_type
ALTER TABLE history_octane.fre_ctp_closing_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fre_ctp_closing_type__etl_batch_id ON history_octane.fre_ctp_closing_type (etl_batch_id);

--adding etl_batch_id to history_octane.fre_doc_level_description_type
ALTER TABLE history_octane.fre_doc_level_description_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fre_doc_level_description_type__etl_batch_id ON history_octane.fre_doc_level_description_type (etl_batch_id);

--adding etl_batch_id to history_octane.fre_purchase_eligibility_type
ALTER TABLE history_octane.fre_purchase_eligibility_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fre_purchase_eligibility_type__etl_batch_id ON history_octane.fre_purchase_eligibility_type (etl_batch_id);

--adding etl_batch_id to history_octane.fund_source_type
ALTER TABLE history_octane.fund_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_fund_source_type__etl_batch_id ON history_octane.fund_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.funding_status_type
ALTER TABLE history_octane.funding_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_funding_status_type__etl_batch_id ON history_octane.funding_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.gender_type
ALTER TABLE history_octane.gender_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_gender_type__etl_batch_id ON history_octane.gender_type (etl_batch_id);

--adding etl_batch_id to history_octane.gift_funds_type
ALTER TABLE history_octane.gift_funds_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_gift_funds_type__etl_batch_id ON history_octane.gift_funds_type (etl_batch_id);

--adding etl_batch_id to history_octane.google_sheet_export
ALTER TABLE history_octane.google_sheet_export
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_google_sheet_export__etl_batch_id ON history_octane.google_sheet_export (etl_batch_id);

--adding etl_batch_id to history_octane.gse_version_type
ALTER TABLE history_octane.gse_version_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_gse_version_type__etl_batch_id ON history_octane.gse_version_type (etl_batch_id);

--adding etl_batch_id to history_octane.heloc_cancel_fee_applicable_type
ALTER TABLE history_octane.heloc_cancel_fee_applicable_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_heloc_cancel_fee_applicable_type__etl_batch_id ON history_octane.heloc_cancel_fee_applicable_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_action_type
ALTER TABLE history_octane.hmda_action_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_action_type__etl_batch_id ON history_octane.hmda_action_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_agency_id_type
ALTER TABLE history_octane.hmda_agency_id_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_agency_id_type__etl_batch_id ON history_octane.hmda_agency_id_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_denial_reason_type
ALTER TABLE history_octane.hmda_denial_reason_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_denial_reason_type__etl_batch_id ON history_octane.hmda_denial_reason_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_ethnicity_2017_type
ALTER TABLE history_octane.hmda_ethnicity_2017_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_ethnicity_2017_type__etl_batch_id ON history_octane.hmda_ethnicity_2017_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_hoepa_status_type
ALTER TABLE history_octane.hmda_hoepa_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_hoepa_status_type__etl_batch_id ON history_octane.hmda_hoepa_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_purchaser_of_loan_2017_type
ALTER TABLE history_octane.hmda_purchaser_of_loan_2017_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_purchaser_of_loan_2017_type__etl_batch_id ON history_octane.hmda_purchaser_of_loan_2017_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_purchaser_of_loan_2018_type
ALTER TABLE history_octane.hmda_purchaser_of_loan_2018_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_purchaser_of_loan_2018_type__etl_batch_id ON history_octane.hmda_purchaser_of_loan_2018_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_race_2017_type
ALTER TABLE history_octane.hmda_race_2017_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_race_2017_type__etl_batch_id ON history_octane.hmda_race_2017_type (etl_batch_id);

--adding etl_batch_id to history_octane.hmda_report_request
ALTER TABLE history_octane.hmda_report_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hmda_report_request__etl_batch_id ON history_octane.hmda_report_request (etl_batch_id);

--adding etl_batch_id to history_octane.hoepa_thresholds
ALTER TABLE history_octane.hoepa_thresholds
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hoepa_thresholds__etl_batch_id ON history_octane.hoepa_thresholds (etl_batch_id);

--adding etl_batch_id to history_octane.homeownership_education_type
ALTER TABLE history_octane.homeownership_education_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_homeownership_education_type__etl_batch_id ON history_octane.homeownership_education_type (etl_batch_id);

--adding etl_batch_id to history_octane.housing_counseling_agency_type
ALTER TABLE history_octane.housing_counseling_agency_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_housing_counseling_agency_type__etl_batch_id ON history_octane.housing_counseling_agency_type (etl_batch_id);

--adding etl_batch_id to history_octane.housing_counseling_type
ALTER TABLE history_octane.housing_counseling_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_housing_counseling_type__etl_batch_id ON history_octane.housing_counseling_type (etl_batch_id);

--adding etl_batch_id to history_octane.hud_fha_de_approval_type
ALTER TABLE history_octane.hud_fha_de_approval_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hud_fha_de_approval_type__etl_batch_id ON history_octane.hud_fha_de_approval_type (etl_batch_id);

--adding etl_batch_id to history_octane.hve_confidence_level_type
ALTER TABLE history_octane.hve_confidence_level_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_hve_confidence_level_type__etl_batch_id ON history_octane.hve_confidence_level_type (etl_batch_id);

--adding etl_batch_id to history_octane.income_history_calc_method_type
ALTER TABLE history_octane.income_history_calc_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_income_history_calc_method_type__etl_batch_id ON history_octane.income_history_calc_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.intent_to_proceed_type
ALTER TABLE history_octane.intent_to_proceed_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_intent_to_proceed_type__etl_batch_id ON history_octane.intent_to_proceed_type (etl_batch_id);

--adding etl_batch_id to history_octane.interest_only_type
ALTER TABLE history_octane.interest_only_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_interest_only_type__etl_batch_id ON history_octane.interest_only_type (etl_batch_id);

--adding etl_batch_id to history_octane.interim_funder
ALTER TABLE history_octane.interim_funder
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_interim_funder__etl_batch_id ON history_octane.interim_funder (etl_batch_id);

--adding etl_batch_id to history_octane.interim_funder_mers_registration_type
ALTER TABLE history_octane.interim_funder_mers_registration_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_interim_funder_mers_registration_type__etl_batch_id ON history_octane.interim_funder_mers_registration_type (etl_batch_id);

--adding etl_batch_id to history_octane.investor
ALTER TABLE history_octane.investor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor__etl_batch_id ON history_octane.investor (etl_batch_id);

--adding etl_batch_id to history_octane.investor_group
ALTER TABLE history_octane.investor_group
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor_group__etl_batch_id ON history_octane.investor_group (etl_batch_id);

--adding etl_batch_id to history_octane.investor_hmda_purchaser_of_loan_type
ALTER TABLE history_octane.investor_hmda_purchaser_of_loan_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor_hmda_purchaser_of_loan_type__etl_batch_id ON history_octane.investor_hmda_purchaser_of_loan_type (etl_batch_id);

--adding etl_batch_id to history_octane.investor_lock
ALTER TABLE history_octane.investor_lock
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor_lock__etl_batch_id ON history_octane.investor_lock (etl_batch_id);

--adding etl_batch_id to history_octane.investor_lock_add_on
ALTER TABLE history_octane.investor_lock_add_on
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor_lock_add_on__etl_batch_id ON history_octane.investor_lock_add_on (etl_batch_id);

--adding etl_batch_id to history_octane.investor_lock_extension
ALTER TABLE history_octane.investor_lock_extension
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor_lock_extension__etl_batch_id ON history_octane.investor_lock_extension (etl_batch_id);

--adding etl_batch_id to history_octane.investor_lock_extension_setting
ALTER TABLE history_octane.investor_lock_extension_setting
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor_lock_extension_setting__etl_batch_id ON history_octane.investor_lock_extension_setting (etl_batch_id);

--adding etl_batch_id to history_octane.investor_lock_status_type
ALTER TABLE history_octane.investor_lock_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_investor_lock_status_type__etl_batch_id ON history_octane.investor_lock_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.invoice_item_category_type
ALTER TABLE history_octane.invoice_item_category_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_invoice_item_category_type__etl_batch_id ON history_octane.invoice_item_category_type (etl_batch_id);

--adding etl_batch_id to history_octane.invoice_payer_type
ALTER TABLE history_octane.invoice_payer_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_invoice_payer_type__etl_batch_id ON history_octane.invoice_payer_type (etl_batch_id);

--adding etl_batch_id to history_octane.invoice_payment_submission_type
ALTER TABLE history_octane.invoice_payment_submission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_invoice_payment_submission_type__etl_batch_id ON history_octane.invoice_payment_submission_type (etl_batch_id);

--adding etl_batch_id to history_octane.ipc_calc_type
ALTER TABLE history_octane.ipc_calc_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ipc_calc_type__etl_batch_id ON history_octane.ipc_calc_type (etl_batch_id);

--adding etl_batch_id to history_octane.ipc_comparison_operator_type
ALTER TABLE history_octane.ipc_comparison_operator_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ipc_comparison_operator_type__etl_batch_id ON history_octane.ipc_comparison_operator_type (etl_batch_id);

--adding etl_batch_id to history_octane.ipc_property_usage_type
ALTER TABLE history_octane.ipc_property_usage_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ipc_property_usage_type__etl_batch_id ON history_octane.ipc_property_usage_type (etl_batch_id);

--adding etl_batch_id to history_octane.job_gap_reason_type
ALTER TABLE history_octane.job_gap_reason_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_job_gap_reason_type__etl_batch_id ON history_octane.job_gap_reason_type (etl_batch_id);

--adding etl_batch_id to history_octane.job_income
ALTER TABLE history_octane.job_income
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_job_income__etl_batch_id ON history_octane.job_income (etl_batch_id);

--adding etl_batch_id to history_octane.key_creditor_type
ALTER TABLE history_octane.key_creditor_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_key_creditor_type__etl_batch_id ON history_octane.key_creditor_type (etl_batch_id);

--adding etl_batch_id to history_octane.key_doc_type
ALTER TABLE history_octane.key_doc_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_key_doc_type__etl_batch_id ON history_octane.key_doc_type (etl_batch_id);

--adding etl_batch_id to history_octane.key_package
ALTER TABLE history_octane.key_package
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_key_package__etl_batch_id ON history_octane.key_package (etl_batch_id);

--adding etl_batch_id to history_octane.key_package_type
ALTER TABLE history_octane.key_package_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_key_package_type__etl_batch_id ON history_octane.key_package_type (etl_batch_id);

--adding etl_batch_id to history_octane.key_role
ALTER TABLE history_octane.key_role
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_key_role__etl_batch_id ON history_octane.key_role (etl_batch_id);

--adding etl_batch_id to history_octane.key_role_type
ALTER TABLE history_octane.key_role_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_key_role_type__etl_batch_id ON history_octane.key_role_type (etl_batch_id);

--adding etl_batch_id to history_octane.lava_zone_type
ALTER TABLE history_octane.lava_zone_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lava_zone_type__etl_batch_id ON history_octane.lava_zone_type (etl_batch_id);

--adding etl_batch_id to history_octane.lead
ALTER TABLE history_octane.lead
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lead__etl_batch_id ON history_octane.lead (etl_batch_id);

--adding etl_batch_id to history_octane.lead_campaign
ALTER TABLE history_octane.lead_campaign
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lead_campaign__etl_batch_id ON history_octane.lead_campaign (etl_batch_id);

--adding etl_batch_id to history_octane.lead_source
ALTER TABLE history_octane.lead_source
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lead_source__etl_batch_id ON history_octane.lead_source (etl_batch_id);

--adding etl_batch_id to history_octane.lead_supplemental_margin_row
ALTER TABLE history_octane.lead_supplemental_margin_row
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lead_supplemental_margin_row__etl_batch_id ON history_octane.lead_supplemental_margin_row (etl_batch_id);

--adding etl_batch_id to history_octane.lead_supplemental_margin_table
ALTER TABLE history_octane.lead_supplemental_margin_table
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lead_supplemental_margin_table__etl_batch_id ON history_octane.lead_supplemental_margin_table (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_basis_points_input_type
ALTER TABLE history_octane.ledger_basis_points_input_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_basis_points_input_type__etl_batch_id ON history_octane.ledger_basis_points_input_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_book
ALTER TABLE history_octane.ledger_book
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_book__etl_batch_id ON history_octane.ledger_book (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_book_status_type
ALTER TABLE history_octane.ledger_book_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_book_status_type__etl_batch_id ON history_octane.ledger_book_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_book_type
ALTER TABLE history_octane.ledger_book_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_book_type__etl_batch_id ON history_octane.ledger_book_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry
ALTER TABLE history_octane.ledger_entry
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry__etl_batch_id ON history_octane.ledger_entry (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_decision_status_type
ALTER TABLE history_octane.ledger_entry_decision_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_decision_status_type__etl_batch_id ON history_octane.ledger_entry_decision_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_import_loan_status
ALTER TABLE history_octane.ledger_entry_import_loan_status
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_import_loan_status__etl_batch_id ON history_octane.ledger_entry_import_loan_status (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_import_status
ALTER TABLE history_octane.ledger_entry_import_status
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_import_status__etl_batch_id ON history_octane.ledger_entry_import_status (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_import_status_type
ALTER TABLE history_octane.ledger_entry_import_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_import_status_type__etl_batch_id ON history_octane.ledger_entry_import_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_review
ALTER TABLE history_octane.ledger_entry_review
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_review__etl_batch_id ON history_octane.ledger_entry_review (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_review_note
ALTER TABLE history_octane.ledger_entry_review_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_review_note__etl_batch_id ON history_octane.ledger_entry_review_note (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_review_note_comment
ALTER TABLE history_octane.ledger_entry_review_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_review_note_comment__etl_batch_id ON history_octane.ledger_entry_review_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_review_note_monitor
ALTER TABLE history_octane.ledger_entry_review_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_review_note_monitor__etl_batch_id ON history_octane.ledger_entry_review_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_review_reason_type
ALTER TABLE history_octane.ledger_entry_review_reason_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_review_reason_type__etl_batch_id ON history_octane.ledger_entry_review_reason_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_review_status_type
ALTER TABLE history_octane.ledger_entry_review_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_review_status_type__etl_batch_id ON history_octane.ledger_entry_review_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_source_type
ALTER TABLE history_octane.ledger_entry_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_source_type__etl_batch_id ON history_octane.ledger_entry_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.ledger_entry_type
ALTER TABLE history_octane.ledger_entry_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_ledger_entry_type__etl_batch_id ON history_octane.ledger_entry_type (etl_batch_id);

--adding etl_batch_id to history_octane.legacy_role_assignment_type
ALTER TABLE history_octane.legacy_role_assignment_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_legacy_role_assignment_type__etl_batch_id ON history_octane.legacy_role_assignment_type (etl_batch_id);

--adding etl_batch_id to history_octane.legal_description_type
ALTER TABLE history_octane.legal_description_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_legal_description_type__etl_batch_id ON history_octane.legal_description_type (etl_batch_id);

--adding etl_batch_id to history_octane.legal_entity_type
ALTER TABLE history_octane.legal_entity_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_legal_entity_type__etl_batch_id ON history_octane.legal_entity_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_concession_item
ALTER TABLE history_octane.lender_concession_item
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_concession_item__etl_batch_id ON history_octane.lender_concession_item (etl_batch_id);

--adding etl_batch_id to history_octane.lender_concession_request
ALTER TABLE history_octane.lender_concession_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_concession_request__etl_batch_id ON history_octane.lender_concession_request (etl_batch_id);

--adding etl_batch_id to history_octane.lender_concession_request_number_ticker
ALTER TABLE history_octane.lender_concession_request_number_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_concession_request_number_ticker__etl_batch_id ON history_octane.lender_concession_request_number_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.lender_concession_request_status_type
ALTER TABLE history_octane.lender_concession_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_concession_request_status_type__etl_batch_id ON history_octane.lender_concession_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_concession_request_type
ALTER TABLE history_octane.lender_concession_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_concession_request_type__etl_batch_id ON history_octane.lender_concession_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_lock_add_on
ALTER TABLE history_octane.lender_lock_add_on
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_lock_add_on__etl_batch_id ON history_octane.lender_lock_add_on (etl_batch_id);

--adding etl_batch_id to history_octane.lender_lock_extension
ALTER TABLE history_octane.lender_lock_extension
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_lock_extension__etl_batch_id ON history_octane.lender_lock_extension (etl_batch_id);

--adding etl_batch_id to history_octane.lender_lock_id_ticker
ALTER TABLE history_octane.lender_lock_id_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_lock_id_ticker__etl_batch_id ON history_octane.lender_lock_id_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.lender_lock_major
ALTER TABLE history_octane.lender_lock_major
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_lock_major__etl_batch_id ON history_octane.lender_lock_major (etl_batch_id);

--adding etl_batch_id to history_octane.lender_lock_minor
ALTER TABLE history_octane.lender_lock_minor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_lock_minor__etl_batch_id ON history_octane.lender_lock_minor (etl_batch_id);

--adding etl_batch_id to history_octane.lender_lock_status_type
ALTER TABLE history_octane.lender_lock_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_lock_status_type__etl_batch_id ON history_octane.lender_lock_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_settings
ALTER TABLE history_octane.lender_settings
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_settings__etl_batch_id ON history_octane.lender_settings (etl_batch_id);

--adding etl_batch_id to history_octane.lender_toolbox_permission_type
ALTER TABLE history_octane.lender_toolbox_permission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_toolbox_permission_type__etl_batch_id ON history_octane.lender_toolbox_permission_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_trade_id_ticker
ALTER TABLE history_octane.lender_trade_id_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_trade_id_ticker__etl_batch_id ON history_octane.lender_trade_id_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user
ALTER TABLE history_octane.lender_user
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user__etl_batch_id ON history_octane.lender_user (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_allowed_ip
ALTER TABLE history_octane.lender_user_allowed_ip
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_allowed_ip__etl_batch_id ON history_octane.lender_user_allowed_ip (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_allowed_ip_status_type
ALTER TABLE history_octane.lender_user_allowed_ip_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_allowed_ip_status_type__etl_batch_id ON history_octane.lender_user_allowed_ip_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_deal_visit
ALTER TABLE history_octane.lender_user_deal_visit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_deal_visit__etl_batch_id ON history_octane.lender_user_deal_visit (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_interest
ALTER TABLE history_octane.lender_user_interest
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_interest__etl_batch_id ON history_octane.lender_user_interest (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_interest_type
ALTER TABLE history_octane.lender_user_interest_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_interest_type__etl_batch_id ON history_octane.lender_user_interest_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_language
ALTER TABLE history_octane.lender_user_language
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_language__etl_batch_id ON history_octane.lender_user_language (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_language_type
ALTER TABLE history_octane.lender_user_language_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_language_type__etl_batch_id ON history_octane.lender_user_language_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_lead_source
ALTER TABLE history_octane.lender_user_lead_source
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_lead_source__etl_batch_id ON history_octane.lender_user_lead_source (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_license
ALTER TABLE history_octane.lender_user_license
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_license__etl_batch_id ON history_octane.lender_user_license (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_location
ALTER TABLE history_octane.lender_user_location
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_location__etl_batch_id ON history_octane.lender_user_location (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_location_type
ALTER TABLE history_octane.lender_user_location_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_location_type__etl_batch_id ON history_octane.lender_user_location_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_notice
ALTER TABLE history_octane.lender_user_notice
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_notice__etl_batch_id ON history_octane.lender_user_notice (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_notice_type
ALTER TABLE history_octane.lender_user_notice_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_notice_type__etl_batch_id ON history_octane.lender_user_notice_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_photo
ALTER TABLE history_octane.lender_user_photo
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_photo__etl_batch_id ON history_octane.lender_user_photo (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_reset_type
ALTER TABLE history_octane.lender_user_reset_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_reset_type__etl_batch_id ON history_octane.lender_user_reset_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_role
ALTER TABLE history_octane.lender_user_role
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_role__etl_batch_id ON history_octane.lender_user_role (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_role_addendum
ALTER TABLE history_octane.lender_user_role_addendum
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_role_addendum__etl_batch_id ON history_octane.lender_user_role_addendum (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_role_queue_type
ALTER TABLE history_octane.lender_user_role_queue_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_role_queue_type__etl_batch_id ON history_octane.lender_user_role_queue_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_sign_on
ALTER TABLE history_octane.lender_user_sign_on
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_sign_on__etl_batch_id ON history_octane.lender_user_sign_on (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_status_type
ALTER TABLE history_octane.lender_user_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_status_type__etl_batch_id ON history_octane.lender_user_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_type
ALTER TABLE history_octane.lender_user_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_type__etl_batch_id ON history_octane.lender_user_type (etl_batch_id);

--adding etl_batch_id to history_octane.lender_user_unavailable
ALTER TABLE history_octane.lender_user_unavailable
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lender_user_unavailable__etl_batch_id ON history_octane.lender_user_unavailable (etl_batch_id);

--adding etl_batch_id to history_octane.liability
ALTER TABLE history_octane.liability
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability__etl_batch_id ON history_octane.liability (etl_batch_id);

--adding etl_batch_id to history_octane.liability_account_ownership_type
ALTER TABLE history_octane.liability_account_ownership_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_account_ownership_type__etl_batch_id ON history_octane.liability_account_ownership_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_account_status_type
ALTER TABLE history_octane.liability_account_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_account_status_type__etl_batch_id ON history_octane.liability_account_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_current_rating_type
ALTER TABLE history_octane.liability_current_rating_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_current_rating_type__etl_batch_id ON history_octane.liability_current_rating_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_disposition_type
ALTER TABLE history_octane.liability_disposition_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_disposition_type__etl_batch_id ON history_octane.liability_disposition_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_energy_related_type
ALTER TABLE history_octane.liability_energy_related_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_energy_related_type__etl_batch_id ON history_octane.liability_energy_related_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_financing_type
ALTER TABLE history_octane.liability_financing_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_financing_type__etl_batch_id ON history_octane.liability_financing_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_foreclosure_exception_type
ALTER TABLE history_octane.liability_foreclosure_exception_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_foreclosure_exception_type__etl_batch_id ON history_octane.liability_foreclosure_exception_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_mi_type
ALTER TABLE history_octane.liability_mi_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_mi_type__etl_batch_id ON history_octane.liability_mi_type (etl_batch_id);

--adding etl_batch_id to history_octane.liability_mortgage_payoff
ALTER TABLE history_octane.liability_mortgage_payoff
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_mortgage_payoff__etl_batch_id ON history_octane.liability_mortgage_payoff (etl_batch_id);

--adding etl_batch_id to history_octane.liability_new
ALTER TABLE history_octane.liability_new
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_new__etl_batch_id ON history_octane.liability_new (etl_batch_id);

--adding etl_batch_id to history_octane.liability_place
ALTER TABLE history_octane.liability_place
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_place__etl_batch_id ON history_octane.liability_place (etl_batch_id);

--adding etl_batch_id to history_octane.liability_type
ALTER TABLE history_octane.liability_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_liability_type__etl_batch_id ON history_octane.liability_type (etl_batch_id);

--adding etl_batch_id to history_octane.license_req
ALTER TABLE history_octane.license_req
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_license_req__etl_batch_id ON history_octane.license_req (etl_batch_id);

--adding etl_batch_id to history_octane.license_type
ALTER TABLE history_octane.license_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_license_type__etl_batch_id ON history_octane.license_type (etl_batch_id);

--adding etl_batch_id to history_octane.lien_priority_type
ALTER TABLE history_octane.lien_priority_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lien_priority_type__etl_batch_id ON history_octane.lien_priority_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan
ALTER TABLE history_octane.loan
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan__etl_batch_id ON history_octane.loan (etl_batch_id);

--adding etl_batch_id to history_octane.loan_access_type
ALTER TABLE history_octane.loan_access_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_access_type__etl_batch_id ON history_octane.loan_access_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_amortization_type
ALTER TABLE history_octane.loan_amortization_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_amortization_type__etl_batch_id ON history_octane.loan_amortization_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_benef_transfer_status_type
ALTER TABLE history_octane.loan_benef_transfer_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_benef_transfer_status_type__etl_batch_id ON history_octane.loan_benef_transfer_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_beneficiary
ALTER TABLE history_octane.loan_beneficiary
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_beneficiary__etl_batch_id ON history_octane.loan_beneficiary (etl_batch_id);

--adding etl_batch_id to history_octane.loan_charge
ALTER TABLE history_octane.loan_charge
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_charge__etl_batch_id ON history_octane.loan_charge (etl_batch_id);

--adding etl_batch_id to history_octane.loan_charge_payer_item
ALTER TABLE history_octane.loan_charge_payer_item
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_charge_payer_item__etl_batch_id ON history_octane.loan_charge_payer_item (etl_batch_id);

--adding etl_batch_id to history_octane.loan_charge_payer_item_source_type
ALTER TABLE history_octane.loan_charge_payer_item_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_charge_payer_item_source_type__etl_batch_id ON history_octane.loan_charge_payer_item_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_closing_doc
ALTER TABLE history_octane.loan_closing_doc
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_closing_doc__etl_batch_id ON history_octane.loan_closing_doc (etl_batch_id);

--adding etl_batch_id to history_octane.loan_eligible_investor
ALTER TABLE history_octane.loan_eligible_investor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_eligible_investor__etl_batch_id ON history_octane.loan_eligible_investor (etl_batch_id);

--adding etl_batch_id to history_octane.loan_file_delivery_method_type
ALTER TABLE history_octane.loan_file_delivery_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_file_delivery_method_type__etl_batch_id ON history_octane.loan_file_delivery_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_funding
ALTER TABLE history_octane.loan_funding
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_funding__etl_batch_id ON history_octane.loan_funding (etl_batch_id);

--adding etl_batch_id to history_octane.loan_hedge
ALTER TABLE history_octane.loan_hedge
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_hedge__etl_batch_id ON history_octane.loan_hedge (etl_batch_id);

--adding etl_batch_id to history_octane.loan_limit_row
ALTER TABLE history_octane.loan_limit_row
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_limit_row__etl_batch_id ON history_octane.loan_limit_row (etl_batch_id);

--adding etl_batch_id to history_octane.loan_limit_table
ALTER TABLE history_octane.loan_limit_table
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_limit_table__etl_batch_id ON history_octane.loan_limit_table (etl_batch_id);

--adding etl_batch_id to history_octane.loan_limit_table_type
ALTER TABLE history_octane.loan_limit_table_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_limit_table_type__etl_batch_id ON history_octane.loan_limit_table_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_limit_type
ALTER TABLE history_octane.loan_limit_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_limit_type__etl_batch_id ON history_octane.loan_limit_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_mi_rate_adjustment
ALTER TABLE history_octane.loan_mi_rate_adjustment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_mi_rate_adjustment__etl_batch_id ON history_octane.loan_mi_rate_adjustment (etl_batch_id);

--adding etl_batch_id to history_octane.loan_mi_surcharge
ALTER TABLE history_octane.loan_mi_surcharge
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_mi_surcharge__etl_batch_id ON history_octane.loan_mi_surcharge (etl_batch_id);

--adding etl_batch_id to history_octane.loan_org_lineage
ALTER TABLE history_octane.loan_org_lineage
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_org_lineage__etl_batch_id ON history_octane.loan_org_lineage (etl_batch_id);

--adding etl_batch_id to history_octane.loan_org_lineage_source_type
ALTER TABLE history_octane.loan_org_lineage_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_org_lineage_source_type__etl_batch_id ON history_octane.loan_org_lineage_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_org_lineage_update
ALTER TABLE history_octane.loan_org_lineage_update
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_org_lineage_update__etl_batch_id ON history_octane.loan_org_lineage_update (etl_batch_id);

--adding etl_batch_id to history_octane.loan_position_type
ALTER TABLE history_octane.loan_position_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_position_type__etl_batch_id ON history_octane.loan_position_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_price_add_on
ALTER TABLE history_octane.loan_price_add_on
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_price_add_on__etl_batch_id ON history_octane.loan_price_add_on (etl_batch_id);

--adding etl_batch_id to history_octane.loan_purpose_type
ALTER TABLE history_octane.loan_purpose_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_purpose_type__etl_batch_id ON history_octane.loan_purpose_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_recording
ALTER TABLE history_octane.loan_recording
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_recording__etl_batch_id ON history_octane.loan_recording (etl_batch_id);

--adding etl_batch_id to history_octane.loan_safe_product_type
ALTER TABLE history_octane.loan_safe_product_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_safe_product_type__etl_batch_id ON history_octane.loan_safe_product_type (etl_batch_id);

--adding etl_batch_id to history_octane.loan_servicer
ALTER TABLE history_octane.loan_servicer
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loan_servicer__etl_batch_id ON history_octane.loan_servicer (etl_batch_id);

--adding etl_batch_id to history_octane.loans_toolbox_permission_type
ALTER TABLE history_octane.loans_toolbox_permission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_loans_toolbox_permission_type__etl_batch_id ON history_octane.loans_toolbox_permission_type (etl_batch_id);

--adding etl_batch_id to history_octane.location
ALTER TABLE history_octane.location
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_location__etl_batch_id ON history_octane.location (etl_batch_id);

--adding etl_batch_id to history_octane.location_id_ticker
ALTER TABLE history_octane.location_id_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_location_id_ticker__etl_batch_id ON history_octane.location_id_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.location_lease
ALTER TABLE history_octane.location_lease
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_location_lease__etl_batch_id ON history_octane.location_lease (etl_batch_id);

--adding etl_batch_id to history_octane.location_note
ALTER TABLE history_octane.location_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_location_note__etl_batch_id ON history_octane.location_note (etl_batch_id);

--adding etl_batch_id to history_octane.location_note_comment
ALTER TABLE history_octane.location_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_location_note_comment__etl_batch_id ON history_octane.location_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.location_note_monitor
ALTER TABLE history_octane.location_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_location_note_monitor__etl_batch_id ON history_octane.location_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.location_status_type
ALTER TABLE history_octane.location_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_location_status_type__etl_batch_id ON history_octane.location_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lock_add_on_type
ALTER TABLE history_octane.lock_add_on_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lock_add_on_type__etl_batch_id ON history_octane.lock_add_on_type (etl_batch_id);

--adding etl_batch_id to history_octane.lock_commitment_type
ALTER TABLE history_octane.lock_commitment_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lock_commitment_type__etl_batch_id ON history_octane.lock_commitment_type (etl_batch_id);

--adding etl_batch_id to history_octane.lock_extension_status_type
ALTER TABLE history_octane.lock_extension_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lock_extension_status_type__etl_batch_id ON history_octane.lock_extension_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lock_series
ALTER TABLE history_octane.lock_series
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lock_series__etl_batch_id ON history_octane.lock_series (etl_batch_id);

--adding etl_batch_id to history_octane.lock_term_setting
ALTER TABLE history_octane.lock_term_setting
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lock_term_setting__etl_batch_id ON history_octane.lock_term_setting (etl_batch_id);

--adding etl_batch_id to history_octane.los_loan_id_ticker
ALTER TABLE history_octane.los_loan_id_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_los_loan_id_ticker__etl_batch_id ON history_octane.los_loan_id_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.lp_case_state_type
ALTER TABLE history_octane.lp_case_state_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_case_state_type__etl_batch_id ON history_octane.lp_case_state_type (etl_batch_id);

--adding etl_batch_id to history_octane.lp_credit_risk_classification_type
ALTER TABLE history_octane.lp_credit_risk_classification_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_credit_risk_classification_type__etl_batch_id ON history_octane.lp_credit_risk_classification_type (etl_batch_id);

--adding etl_batch_id to history_octane.lp_dtd_version_type
ALTER TABLE history_octane.lp_dtd_version_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_dtd_version_type__etl_batch_id ON history_octane.lp_dtd_version_type (etl_batch_id);

--adding etl_batch_id to history_octane.lp_evaluation_status_type
ALTER TABLE history_octane.lp_evaluation_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_evaluation_status_type__etl_batch_id ON history_octane.lp_evaluation_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lp_finding
ALTER TABLE history_octane.lp_finding
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_finding__etl_batch_id ON history_octane.lp_finding (etl_batch_id);

--adding etl_batch_id to history_octane.lp_finding_message_type
ALTER TABLE history_octane.lp_finding_message_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_finding_message_type__etl_batch_id ON history_octane.lp_finding_message_type (etl_batch_id);

--adding etl_batch_id to history_octane.lp_interface_version_type
ALTER TABLE history_octane.lp_interface_version_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_interface_version_type__etl_batch_id ON history_octane.lp_interface_version_type (etl_batch_id);

--adding etl_batch_id to history_octane.lp_request
ALTER TABLE history_octane.lp_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_request__etl_batch_id ON history_octane.lp_request (etl_batch_id);

--adding etl_batch_id to history_octane.lp_request_credit
ALTER TABLE history_octane.lp_request_credit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_request_credit__etl_batch_id ON history_octane.lp_request_credit (etl_batch_id);

--adding etl_batch_id to history_octane.lp_request_status_type
ALTER TABLE history_octane.lp_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_request_status_type__etl_batch_id ON history_octane.lp_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.lp_submission_type
ALTER TABLE history_octane.lp_submission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lp_submission_type__etl_batch_id ON history_octane.lp_submission_type (etl_batch_id);

--adding etl_batch_id to history_octane.lqa_purchase_eligibility_type
ALTER TABLE history_octane.lqa_purchase_eligibility_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lqa_purchase_eligibility_type__etl_batch_id ON history_octane.lqa_purchase_eligibility_type (etl_batch_id);

--adding etl_batch_id to history_octane.lura_file_repository_type
ALTER TABLE history_octane.lura_file_repository_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lura_file_repository_type__etl_batch_id ON history_octane.lura_file_repository_type (etl_batch_id);

--adding etl_batch_id to history_octane.lura_setting_type
ALTER TABLE history_octane.lura_setting_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_lura_setting_type__etl_batch_id ON history_octane.lura_setting_type (etl_batch_id);

--adding etl_batch_id to history_octane.manufactured_home_certificate_of_title_type
ALTER TABLE history_octane.manufactured_home_certificate_of_title_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_manufactured_home_certificate_of_title_type__etl_batch_id ON history_octane.manufactured_home_certificate_of_title_type (etl_batch_id);

--adding etl_batch_id to history_octane.manufactured_home_leasehold_property_interest_type
ALTER TABLE history_octane.manufactured_home_leasehold_property_interest_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_c9af8f33996aa148e493ad8be9da53be ON history_octane.manufactured_home_leasehold_property_interest_type (etl_batch_id);

--adding etl_batch_id to history_octane.manufactured_home_loan_purpose_type
ALTER TABLE history_octane.manufactured_home_loan_purpose_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_manufactured_home_loan_purpose_type__etl_batch_id ON history_octane.manufactured_home_loan_purpose_type (etl_batch_id);

--adding etl_batch_id to history_octane.marital_status_type
ALTER TABLE history_octane.marital_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_marital_status_type__etl_batch_id ON history_octane.marital_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.master_property_insurance
ALTER TABLE history_octane.master_property_insurance
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_master_property_insurance__etl_batch_id ON history_octane.master_property_insurance (etl_batch_id);

--adding etl_batch_id to history_octane.master_property_insurance_type
ALTER TABLE history_octane.master_property_insurance_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_master_property_insurance_type__etl_batch_id ON history_octane.master_property_insurance_type (etl_batch_id);

--adding etl_batch_id to history_octane.mcr_error_status_type
ALTER TABLE history_octane.mcr_error_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mcr_error_status_type__etl_batch_id ON history_octane.mcr_error_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mcr_loan
ALTER TABLE history_octane.mcr_loan
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mcr_loan__etl_batch_id ON history_octane.mcr_loan (etl_batch_id);

--adding etl_batch_id to history_octane.mcr_loan_status_type
ALTER TABLE history_octane.mcr_loan_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mcr_loan_status_type__etl_batch_id ON history_octane.mcr_loan_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mcr_request
ALTER TABLE history_octane.mcr_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mcr_request__etl_batch_id ON history_octane.mcr_request (etl_batch_id);

--adding etl_batch_id to history_octane.mcr_snapshot
ALTER TABLE history_octane.mcr_snapshot
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mcr_snapshot__etl_batch_id ON history_octane.mcr_snapshot (etl_batch_id);

--adding etl_batch_id to history_octane.mcr_status_type
ALTER TABLE history_octane.mcr_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mcr_status_type__etl_batch_id ON history_octane.mcr_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mercury_client_group
ALTER TABLE history_octane.mercury_client_group
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mercury_client_group__etl_batch_id ON history_octane.mercury_client_group (etl_batch_id);

--adding etl_batch_id to history_octane.mercury_network_status_request
ALTER TABLE history_octane.mercury_network_status_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mercury_network_status_request__etl_batch_id ON history_octane.mercury_network_status_request (etl_batch_id);

--adding etl_batch_id to history_octane.mercury_network_status_type
ALTER TABLE history_octane.mercury_network_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mercury_network_status_type__etl_batch_id ON history_octane.mercury_network_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mers_daily_report
ALTER TABLE history_octane.mers_daily_report
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mers_daily_report__etl_batch_id ON history_octane.mers_daily_report (etl_batch_id);

--adding etl_batch_id to history_octane.mers_daily_report_import_status_type
ALTER TABLE history_octane.mers_daily_report_import_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mers_daily_report_import_status_type__etl_batch_id ON history_octane.mers_daily_report_import_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mers_registration_status_type
ALTER TABLE history_octane.mers_registration_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mers_registration_status_type__etl_batch_id ON history_octane.mers_registration_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mers_transfer_batch
ALTER TABLE history_octane.mers_transfer_batch
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mers_transfer_batch__etl_batch_id ON history_octane.mers_transfer_batch (etl_batch_id);

--adding etl_batch_id to history_octane.mers_transfer_status_type
ALTER TABLE history_octane.mers_transfer_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mers_transfer_status_type__etl_batch_id ON history_octane.mers_transfer_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_calculated_rate_type
ALTER TABLE history_octane.mi_calculated_rate_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_calculated_rate_type__etl_batch_id ON history_octane.mi_calculated_rate_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_company_name_type
ALTER TABLE history_octane.mi_company_name_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_company_name_type__etl_batch_id ON history_octane.mi_company_name_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_initial_calculation_type
ALTER TABLE history_octane.mi_initial_calculation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_initial_calculation_type__etl_batch_id ON history_octane.mi_initial_calculation_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_input_type
ALTER TABLE history_octane.mi_input_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_input_type__etl_batch_id ON history_octane.mi_input_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_integration_request_type
ALTER TABLE history_octane.mi_integration_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_integration_request_type__etl_batch_id ON history_octane.mi_integration_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_integration_vendor_request
ALTER TABLE history_octane.mi_integration_vendor_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_integration_vendor_request__etl_batch_id ON history_octane.mi_integration_vendor_request (etl_batch_id);

--adding etl_batch_id to history_octane.mi_integration_vendor_request_status_type
ALTER TABLE history_octane.mi_integration_vendor_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_integration_vendor_request_status_type__etl_batch_id ON history_octane.mi_integration_vendor_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_payer_type
ALTER TABLE history_octane.mi_payer_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_payer_type__etl_batch_id ON history_octane.mi_payer_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_payment_type
ALTER TABLE history_octane.mi_payment_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_payment_type__etl_batch_id ON history_octane.mi_payment_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_premium_refundable_type
ALTER TABLE history_octane.mi_premium_refundable_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_premium_refundable_type__etl_batch_id ON history_octane.mi_premium_refundable_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_renewal_calculation_type
ALTER TABLE history_octane.mi_renewal_calculation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_renewal_calculation_type__etl_batch_id ON history_octane.mi_renewal_calculation_type (etl_batch_id);

--adding etl_batch_id to history_octane.mi_submission_type
ALTER TABLE history_octane.mi_submission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mi_submission_type__etl_batch_id ON history_octane.mi_submission_type (etl_batch_id);

--adding etl_batch_id to history_octane.military_branch_type
ALTER TABLE history_octane.military_branch_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_military_branch_type__etl_batch_id ON history_octane.military_branch_type (etl_batch_id);

--adding etl_batch_id to history_octane.military_service
ALTER TABLE history_octane.military_service
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_military_service__etl_batch_id ON history_octane.military_service (etl_batch_id);

--adding etl_batch_id to history_octane.military_service_type
ALTER TABLE history_octane.military_service_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_military_service_type__etl_batch_id ON history_octane.military_service_type (etl_batch_id);

--adding etl_batch_id to history_octane.military_status_type
ALTER TABLE history_octane.military_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_military_status_type__etl_batch_id ON history_octane.military_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.minimum_required_residual_income_row
ALTER TABLE history_octane.minimum_required_residual_income_row
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_minimum_required_residual_income_row__etl_batch_id ON history_octane.minimum_required_residual_income_row (etl_batch_id);

--adding etl_batch_id to history_octane.minimum_required_residual_income_table
ALTER TABLE history_octane.minimum_required_residual_income_table
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_minimum_required_residual_income_table__etl_batch_id ON history_octane.minimum_required_residual_income_table (etl_batch_id);

--adding etl_batch_id to history_octane.mismo_version_type
ALTER TABLE history_octane.mismo_version_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mismo_version_type__etl_batch_id ON history_octane.mismo_version_type (etl_batch_id);

--adding etl_batch_id to history_octane.mortech_account
ALTER TABLE history_octane.mortech_account
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mortech_account__etl_batch_id ON history_octane.mortech_account (etl_batch_id);

--adding etl_batch_id to history_octane.mortgage_credit_certificate_issuer
ALTER TABLE history_octane.mortgage_credit_certificate_issuer
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mortgage_credit_certificate_issuer__etl_batch_id ON history_octane.mortgage_credit_certificate_issuer (etl_batch_id);

--adding etl_batch_id to history_octane.mortgage_delinquency_exception_type
ALTER TABLE history_octane.mortgage_delinquency_exception_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mortgage_delinquency_exception_type__etl_batch_id ON history_octane.mortgage_delinquency_exception_type (etl_batch_id);

--adding etl_batch_id to history_octane.mortgage_type
ALTER TABLE history_octane.mortgage_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_mortgage_type__etl_batch_id ON history_octane.mortgage_type (etl_batch_id);

--adding etl_batch_id to history_octane.native_american_lands_type
ALTER TABLE history_octane.native_american_lands_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_native_american_lands_type__etl_batch_id ON history_octane.native_american_lands_type (etl_batch_id);

--adding etl_batch_id to history_octane.negative_amortization_type
ALTER TABLE history_octane.negative_amortization_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_negative_amortization_type__etl_batch_id ON history_octane.negative_amortization_type (etl_batch_id);

--adding etl_batch_id to history_octane.neighborhood_location_type
ALTER TABLE history_octane.neighborhood_location_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_neighborhood_location_type__etl_batch_id ON history_octane.neighborhood_location_type (etl_batch_id);

--adding etl_batch_id to history_octane.net_tangible_benefit
ALTER TABLE history_octane.net_tangible_benefit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_net_tangible_benefit__etl_batch_id ON history_octane.net_tangible_benefit (etl_batch_id);

--adding etl_batch_id to history_octane.net_tangible_benefit_type
ALTER TABLE history_octane.net_tangible_benefit_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_net_tangible_benefit_type__etl_batch_id ON history_octane.net_tangible_benefit_type (etl_batch_id);

--adding etl_batch_id to history_octane.new_lock_only_add_on
ALTER TABLE history_octane.new_lock_only_add_on
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_new_lock_only_add_on__etl_batch_id ON history_octane.new_lock_only_add_on (etl_batch_id);

--adding etl_batch_id to history_octane.nfip_community_participation_status_type
ALTER TABLE history_octane.nfip_community_participation_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_nfip_community_participation_status_type__etl_batch_id ON history_octane.nfip_community_participation_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.obligation
ALTER TABLE history_octane.obligation
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_obligation__etl_batch_id ON history_octane.obligation (etl_batch_id);

--adding etl_batch_id to history_octane.obligation_amount_input_type
ALTER TABLE history_octane.obligation_amount_input_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_obligation_amount_input_type__etl_batch_id ON history_octane.obligation_amount_input_type (etl_batch_id);

--adding etl_batch_id to history_octane.obligation_charge_input_type
ALTER TABLE history_octane.obligation_charge_input_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_obligation_charge_input_type__etl_batch_id ON history_octane.obligation_charge_input_type (etl_batch_id);

--adding etl_batch_id to history_octane.obligation_type
ALTER TABLE history_octane.obligation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_obligation_type__etl_batch_id ON history_octane.obligation_type (etl_batch_id);

--adding etl_batch_id to history_octane.offering
ALTER TABLE history_octane.offering
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_offering__etl_batch_id ON history_octane.offering (etl_batch_id);

--adding etl_batch_id to history_octane.offering_group
ALTER TABLE history_octane.offering_group
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_offering_group__etl_batch_id ON history_octane.offering_group (etl_batch_id);

--adding etl_batch_id to history_octane.offering_product
ALTER TABLE history_octane.offering_product
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_offering_product__etl_batch_id ON history_octane.offering_product (etl_batch_id);

--adding etl_batch_id to history_octane.org_division
ALTER TABLE history_octane.org_division
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_division__etl_batch_id ON history_octane.org_division (etl_batch_id);

--adding etl_batch_id to history_octane.org_division_leader
ALTER TABLE history_octane.org_division_leader
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_division_leader__etl_batch_id ON history_octane.org_division_leader (etl_batch_id);

--adding etl_batch_id to history_octane.org_division_terms
ALTER TABLE history_octane.org_division_terms
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_division_terms__etl_batch_id ON history_octane.org_division_terms (etl_batch_id);

--adding etl_batch_id to history_octane.org_group
ALTER TABLE history_octane.org_group
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_group__etl_batch_id ON history_octane.org_group (etl_batch_id);

--adding etl_batch_id to history_octane.org_group_leader
ALTER TABLE history_octane.org_group_leader
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_group_leader__etl_batch_id ON history_octane.org_group_leader (etl_batch_id);

--adding etl_batch_id to history_octane.org_group_terms
ALTER TABLE history_octane.org_group_terms
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_group_terms__etl_batch_id ON history_octane.org_group_terms (etl_batch_id);

--adding etl_batch_id to history_octane.org_leader_position_type
ALTER TABLE history_octane.org_leader_position_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_leader_position_type__etl_batch_id ON history_octane.org_leader_position_type (etl_batch_id);

--adding etl_batch_id to history_octane.org_lender_user_terms
ALTER TABLE history_octane.org_lender_user_terms
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_lender_user_terms__etl_batch_id ON history_octane.org_lender_user_terms (etl_batch_id);

--adding etl_batch_id to history_octane.org_lineage
ALTER TABLE history_octane.org_lineage
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_lineage__etl_batch_id ON history_octane.org_lineage (etl_batch_id);

--adding etl_batch_id to history_octane.org_lineage_node
ALTER TABLE history_octane.org_lineage_node
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_lineage_node__etl_batch_id ON history_octane.org_lineage_node (etl_batch_id);

--adding etl_batch_id to history_octane.org_lineage_tracker
ALTER TABLE history_octane.org_lineage_tracker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_lineage_tracker__etl_batch_id ON history_octane.org_lineage_tracker (etl_batch_id);

--adding etl_batch_id to history_octane.org_node
ALTER TABLE history_octane.org_node
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_node__etl_batch_id ON history_octane.org_node (etl_batch_id);

--adding etl_batch_id to history_octane.org_node_lender_user
ALTER TABLE history_octane.org_node_lender_user
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_node_lender_user__etl_batch_id ON history_octane.org_node_lender_user (etl_batch_id);

--adding etl_batch_id to history_octane.org_node_lender_user_type
ALTER TABLE history_octane.org_node_lender_user_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_node_lender_user_type__etl_batch_id ON history_octane.org_node_lender_user_type (etl_batch_id);

--adding etl_batch_id to history_octane.org_node_tree
ALTER TABLE history_octane.org_node_tree
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_node_tree__etl_batch_id ON history_octane.org_node_tree (etl_batch_id);

--adding etl_batch_id to history_octane.org_node_type
ALTER TABLE history_octane.org_node_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_node_type__etl_batch_id ON history_octane.org_node_type (etl_batch_id);

--adding etl_batch_id to history_octane.org_node_version
ALTER TABLE history_octane.org_node_version
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_node_version__etl_batch_id ON history_octane.org_node_version (etl_batch_id);

--adding etl_batch_id to history_octane.org_region
ALTER TABLE history_octane.org_region
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_region__etl_batch_id ON history_octane.org_region (etl_batch_id);

--adding etl_batch_id to history_octane.org_region_leader
ALTER TABLE history_octane.org_region_leader
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_region_leader__etl_batch_id ON history_octane.org_region_leader (etl_batch_id);

--adding etl_batch_id to history_octane.org_region_terms
ALTER TABLE history_octane.org_region_terms
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_region_terms__etl_batch_id ON history_octane.org_region_terms (etl_batch_id);

--adding etl_batch_id to history_octane.org_team
ALTER TABLE history_octane.org_team
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_team__etl_batch_id ON history_octane.org_team (etl_batch_id);

--adding etl_batch_id to history_octane.org_team_leader
ALTER TABLE history_octane.org_team_leader
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_team_leader__etl_batch_id ON history_octane.org_team_leader (etl_batch_id);

--adding etl_batch_id to history_octane.org_team_terms
ALTER TABLE history_octane.org_team_terms
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_team_terms__etl_batch_id ON history_octane.org_team_terms (etl_batch_id);

--adding etl_batch_id to history_octane.org_unit
ALTER TABLE history_octane.org_unit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_unit__etl_batch_id ON history_octane.org_unit (etl_batch_id);

--adding etl_batch_id to history_octane.org_unit_leader
ALTER TABLE history_octane.org_unit_leader
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_unit_leader__etl_batch_id ON history_octane.org_unit_leader (etl_batch_id);

--adding etl_batch_id to history_octane.org_unit_terms
ALTER TABLE history_octane.org_unit_terms
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_org_unit_terms__etl_batch_id ON history_octane.org_unit_terms (etl_batch_id);

--adding etl_batch_id to history_octane.origination_source_type
ALTER TABLE history_octane.origination_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_origination_source_type__etl_batch_id ON history_octane.origination_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.other_income
ALTER TABLE history_octane.other_income
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_other_income__etl_batch_id ON history_octane.other_income (etl_batch_id);

--adding etl_batch_id to history_octane.other_income_type
ALTER TABLE history_octane.other_income_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_other_income_type__etl_batch_id ON history_octane.other_income_type (etl_batch_id);

--adding etl_batch_id to history_octane.partial_payment_policy_type
ALTER TABLE history_octane.partial_payment_policy_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_partial_payment_policy_type__etl_batch_id ON history_octane.partial_payment_policy_type (etl_batch_id);

--adding etl_batch_id to history_octane.password_settings
ALTER TABLE history_octane.password_settings
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_password_settings__etl_batch_id ON history_octane.password_settings (etl_batch_id);

--adding etl_batch_id to history_octane.payment_adjustment_calculation_type
ALTER TABLE history_octane.payment_adjustment_calculation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payment_adjustment_calculation_type__etl_batch_id ON history_octane.payment_adjustment_calculation_type (etl_batch_id);

--adding etl_batch_id to history_octane.payment_frequency_type
ALTER TABLE history_octane.payment_frequency_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payment_frequency_type__etl_batch_id ON history_octane.payment_frequency_type (etl_batch_id);

--adding etl_batch_id to history_octane.payment_fulfill_type
ALTER TABLE history_octane.payment_fulfill_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payment_fulfill_type__etl_batch_id ON history_octane.payment_fulfill_type (etl_batch_id);

--adding etl_batch_id to history_octane.payment_processing_company_type
ALTER TABLE history_octane.payment_processing_company_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payment_processing_company_type__etl_batch_id ON history_octane.payment_processing_company_type (etl_batch_id);

--adding etl_batch_id to history_octane.payment_request_type
ALTER TABLE history_octane.payment_request_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payment_request_type__etl_batch_id ON history_octane.payment_request_type (etl_batch_id);

--adding etl_batch_id to history_octane.payment_structure_type
ALTER TABLE history_octane.payment_structure_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payment_structure_type__etl_batch_id ON history_octane.payment_structure_type (etl_batch_id);

--adding etl_batch_id to history_octane.payment_type
ALTER TABLE history_octane.payment_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payment_type__etl_batch_id ON history_octane.payment_type (etl_batch_id);

--adding etl_batch_id to history_octane.payoff_request_delivery_type
ALTER TABLE history_octane.payoff_request_delivery_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payoff_request_delivery_type__etl_batch_id ON history_octane.payoff_request_delivery_type (etl_batch_id);

--adding etl_batch_id to history_octane.payroll_ledger_book_id_ticker
ALTER TABLE history_octane.payroll_ledger_book_id_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_payroll_ledger_book_id_ticker__etl_batch_id ON history_octane.payroll_ledger_book_id_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.performer_assignment
ALTER TABLE history_octane.performer_assignment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_performer_assignment__etl_batch_id ON history_octane.performer_assignment (etl_batch_id);

--adding etl_batch_id to history_octane.performer_team
ALTER TABLE history_octane.performer_team
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_performer_team__etl_batch_id ON history_octane.performer_team (etl_batch_id);

--adding etl_batch_id to history_octane.place
ALTER TABLE history_octane.place
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_place__etl_batch_id ON history_octane.place (etl_batch_id);

--adding etl_batch_id to history_octane.polling_interval_type
ALTER TABLE history_octane.polling_interval_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_polling_interval_type__etl_batch_id ON history_octane.polling_interval_type (etl_batch_id);

--adding etl_batch_id to history_octane.preferred_settlement
ALTER TABLE history_octane.preferred_settlement
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_preferred_settlement__etl_batch_id ON history_octane.preferred_settlement (etl_batch_id);

--adding etl_batch_id to history_octane.prepaid_interest_rate_type
ALTER TABLE history_octane.prepaid_interest_rate_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_prepaid_interest_rate_type__etl_batch_id ON history_octane.prepaid_interest_rate_type (etl_batch_id);

--adding etl_batch_id to history_octane.prepay_penalty_schedule_type
ALTER TABLE history_octane.prepay_penalty_schedule_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_prepay_penalty_schedule_type__etl_batch_id ON history_octane.prepay_penalty_schedule_type (etl_batch_id);

--adding etl_batch_id to history_octane.prepay_penalty_type
ALTER TABLE history_octane.prepay_penalty_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_prepay_penalty_type__etl_batch_id ON history_octane.prepay_penalty_type (etl_batch_id);

--adding etl_batch_id to history_octane.price_processing_time
ALTER TABLE history_octane.price_processing_time
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_price_processing_time__etl_batch_id ON history_octane.price_processing_time (etl_batch_id);

--adding etl_batch_id to history_octane.pricing_engine_type
ALTER TABLE history_octane.pricing_engine_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_pricing_engine_type__etl_batch_id ON history_octane.pricing_engine_type (etl_batch_id);

--adding etl_batch_id to history_octane.prior_property_title_type
ALTER TABLE history_octane.prior_property_title_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_prior_property_title_type__etl_batch_id ON history_octane.prior_property_title_type (etl_batch_id);

--adding etl_batch_id to history_octane.prior_to_type
ALTER TABLE history_octane.prior_to_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_prior_to_type__etl_batch_id ON history_octane.prior_to_type (etl_batch_id);

--adding etl_batch_id to history_octane.product
ALTER TABLE history_octane.product
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product__etl_batch_id ON history_octane.product (etl_batch_id);

--adding etl_batch_id to history_octane.product_add_on
ALTER TABLE history_octane.product_add_on
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_add_on__etl_batch_id ON history_octane.product_add_on (etl_batch_id);

--adding etl_batch_id to history_octane.product_add_on_rule
ALTER TABLE history_octane.product_add_on_rule
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_add_on_rule__etl_batch_id ON history_octane.product_add_on_rule (etl_batch_id);

--adding etl_batch_id to history_octane.product_appraisal_requirement_type
ALTER TABLE history_octane.product_appraisal_requirement_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_appraisal_requirement_type__etl_batch_id ON history_octane.product_appraisal_requirement_type (etl_batch_id);

--adding etl_batch_id to history_octane.product_branch
ALTER TABLE history_octane.product_branch
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_branch__etl_batch_id ON history_octane.product_branch (etl_batch_id);

--adding etl_batch_id to history_octane.product_buydown
ALTER TABLE history_octane.product_buydown
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_buydown__etl_batch_id ON history_octane.product_buydown (etl_batch_id);

--adding etl_batch_id to history_octane.product_deal_check_exclusion
ALTER TABLE history_octane.product_deal_check_exclusion
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_deal_check_exclusion__etl_batch_id ON history_octane.product_deal_check_exclusion (etl_batch_id);

--adding etl_batch_id to history_octane.product_eligibility
ALTER TABLE history_octane.product_eligibility
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_eligibility__etl_batch_id ON history_octane.product_eligibility (etl_batch_id);

--adding etl_batch_id to history_octane.product_eligibility_rule
ALTER TABLE history_octane.product_eligibility_rule
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_eligibility_rule__etl_batch_id ON history_octane.product_eligibility_rule (etl_batch_id);

--adding etl_batch_id to history_octane.product_interest_only
ALTER TABLE history_octane.product_interest_only
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_interest_only__etl_batch_id ON history_octane.product_interest_only (etl_batch_id);

--adding etl_batch_id to history_octane.product_lock_term
ALTER TABLE history_octane.product_lock_term
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_lock_term__etl_batch_id ON history_octane.product_lock_term (etl_batch_id);

--adding etl_batch_id to history_octane.product_maximum_investor_price
ALTER TABLE history_octane.product_maximum_investor_price
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_maximum_investor_price__etl_batch_id ON history_octane.product_maximum_investor_price (etl_batch_id);

--adding etl_batch_id to history_octane.product_maximum_rebate
ALTER TABLE history_octane.product_maximum_rebate
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_maximum_rebate__etl_batch_id ON history_octane.product_maximum_rebate (etl_batch_id);

--adding etl_batch_id to history_octane.product_minimum_investor_price
ALTER TABLE history_octane.product_minimum_investor_price
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_minimum_investor_price__etl_batch_id ON history_octane.product_minimum_investor_price (etl_batch_id);

--adding etl_batch_id to history_octane.product_originator
ALTER TABLE history_octane.product_originator
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_originator__etl_batch_id ON history_octane.product_originator (etl_batch_id);

--adding etl_batch_id to history_octane.product_prepay_penalty
ALTER TABLE history_octane.product_prepay_penalty
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_prepay_penalty__etl_batch_id ON history_octane.product_prepay_penalty (etl_batch_id);

--adding etl_batch_id to history_octane.product_rule_domain_input_type
ALTER TABLE history_octane.product_rule_domain_input_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_rule_domain_input_type__etl_batch_id ON history_octane.product_rule_domain_input_type (etl_batch_id);

--adding etl_batch_id to history_octane.product_side_type
ALTER TABLE history_octane.product_side_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_side_type__etl_batch_id ON history_octane.product_side_type (etl_batch_id);

--adding etl_batch_id to history_octane.product_special_program_type
ALTER TABLE history_octane.product_special_program_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_special_program_type__etl_batch_id ON history_octane.product_special_program_type (etl_batch_id);

--adding etl_batch_id to history_octane.product_terms
ALTER TABLE history_octane.product_terms
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_terms__etl_batch_id ON history_octane.product_terms (etl_batch_id);

--adding etl_batch_id to history_octane.product_third_party_community_second_program
ALTER TABLE history_octane.product_third_party_community_second_program
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_product_third_party_community_second_program__etl_batch_id ON history_octane.product_third_party_community_second_program (etl_batch_id);

--adding etl_batch_id to history_octane.profit_margin_detail
ALTER TABLE history_octane.profit_margin_detail
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_profit_margin_detail__etl_batch_id ON history_octane.profit_margin_detail (etl_batch_id);

--adding etl_batch_id to history_octane.profit_margin_type
ALTER TABLE history_octane.profit_margin_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_profit_margin_type__etl_batch_id ON history_octane.profit_margin_type (etl_batch_id);

--adding etl_batch_id to history_octane.project_classification_type
ALTER TABLE history_octane.project_classification_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_project_classification_type__etl_batch_id ON history_octane.project_classification_type (etl_batch_id);

--adding etl_batch_id to history_octane.project_design_type
ALTER TABLE history_octane.project_design_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_project_design_type__etl_batch_id ON history_octane.project_design_type (etl_batch_id);

--adding etl_batch_id to history_octane.property_category_type
ALTER TABLE history_octane.property_category_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_property_category_type__etl_batch_id ON history_octane.property_category_type (etl_batch_id);

--adding etl_batch_id to history_octane.property_repairs_holdback_calc_type
ALTER TABLE history_octane.property_repairs_holdback_calc_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_property_repairs_holdback_calc_type__etl_batch_id ON history_octane.property_repairs_holdback_calc_type (etl_batch_id);

--adding etl_batch_id to history_octane.property_repairs_holdback_payer_type
ALTER TABLE history_octane.property_repairs_holdback_payer_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_property_repairs_holdback_payer_type__etl_batch_id ON history_octane.property_repairs_holdback_payer_type (etl_batch_id);

--adding etl_batch_id to history_octane.property_repairs_required_type
ALTER TABLE history_octane.property_repairs_required_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_property_repairs_required_type__etl_batch_id ON history_octane.property_repairs_required_type (etl_batch_id);

--adding etl_batch_id to history_octane.property_rights_type
ALTER TABLE history_octane.property_rights_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_property_rights_type__etl_batch_id ON history_octane.property_rights_type (etl_batch_id);

--adding etl_batch_id to history_octane.property_usage_type
ALTER TABLE history_octane.property_usage_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_property_usage_type__etl_batch_id ON history_octane.property_usage_type (etl_batch_id);

--adding etl_batch_id to history_octane.proposal
ALTER TABLE history_octane.proposal
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal__etl_batch_id ON history_octane.proposal (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_construction
ALTER TABLE history_octane.proposal_construction
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_construction__etl_batch_id ON history_octane.proposal_construction (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_contractor
ALTER TABLE history_octane.proposal_contractor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_contractor__etl_batch_id ON history_octane.proposal_contractor (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc
ALTER TABLE history_octane.proposal_doc
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc__etl_batch_id ON history_octane.proposal_doc (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_borrower_access
ALTER TABLE history_octane.proposal_doc_borrower_access
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_borrower_access__etl_batch_id ON history_octane.proposal_doc_borrower_access (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_file
ALTER TABLE history_octane.proposal_doc_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_file__etl_batch_id ON history_octane.proposal_doc_file (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_file_type
ALTER TABLE history_octane.proposal_doc_file_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_file_type__etl_batch_id ON history_octane.proposal_doc_file_type (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_set
ALTER TABLE history_octane.proposal_doc_set
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_set__etl_batch_id ON history_octane.proposal_doc_set (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_set_id_ticker
ALTER TABLE history_octane.proposal_doc_set_id_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_set_id_ticker__etl_batch_id ON history_octane.proposal_doc_set_id_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_set_signer
ALTER TABLE history_octane.proposal_doc_set_signer
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_set_signer__etl_batch_id ON history_octane.proposal_doc_set_signer (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_set_snapshot
ALTER TABLE history_octane.proposal_doc_set_snapshot
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_set_snapshot__etl_batch_id ON history_octane.proposal_doc_set_snapshot (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_doc_validity
ALTER TABLE history_octane.proposal_doc_validity
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_doc_validity__etl_batch_id ON history_octane.proposal_doc_validity (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_engagement
ALTER TABLE history_octane.proposal_engagement
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_engagement__etl_batch_id ON history_octane.proposal_engagement (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_grant_program
ALTER TABLE history_octane.proposal_grant_program
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_grant_program__etl_batch_id ON history_octane.proposal_grant_program (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_hud_consultant
ALTER TABLE history_octane.proposal_hud_consultant
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_hud_consultant__etl_batch_id ON history_octane.proposal_hud_consultant (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_req
ALTER TABLE history_octane.proposal_req
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_req__etl_batch_id ON history_octane.proposal_req (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_review
ALTER TABLE history_octane.proposal_review
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_review__etl_batch_id ON history_octane.proposal_review (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_review_status_type
ALTER TABLE history_octane.proposal_review_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_review_status_type__etl_batch_id ON history_octane.proposal_review_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_review_ticker
ALTER TABLE history_octane.proposal_review_ticker
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_review_ticker__etl_batch_id ON history_octane.proposal_review_ticker (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_structure_type
ALTER TABLE history_octane.proposal_structure_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_structure_type__etl_batch_id ON history_octane.proposal_structure_type (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_summary
ALTER TABLE history_octane.proposal_summary
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_summary__etl_batch_id ON history_octane.proposal_summary (etl_batch_id);

--adding etl_batch_id to history_octane.proposal_type
ALTER TABLE history_octane.proposal_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_proposal_type__etl_batch_id ON history_octane.proposal_type (etl_batch_id);

--adding etl_batch_id to history_octane.pte_request
ALTER TABLE history_octane.pte_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_pte_request__etl_batch_id ON history_octane.pte_request (etl_batch_id);

--adding etl_batch_id to history_octane.pte_request_status_type
ALTER TABLE history_octane.pte_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_pte_request_status_type__etl_batch_id ON history_octane.pte_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.pte_response_status_type
ALTER TABLE history_octane.pte_response_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_pte_response_status_type__etl_batch_id ON history_octane.pte_response_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.public_record
ALTER TABLE history_octane.public_record
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_public_record__etl_batch_id ON history_octane.public_record (etl_batch_id);

--adding etl_batch_id to history_octane.public_record_disposition_type
ALTER TABLE history_octane.public_record_disposition_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_public_record_disposition_type__etl_batch_id ON history_octane.public_record_disposition_type (etl_batch_id);

--adding etl_batch_id to history_octane.public_record_type
ALTER TABLE history_octane.public_record_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_public_record_type__etl_batch_id ON history_octane.public_record_type (etl_batch_id);

--adding etl_batch_id to history_octane.qualified_mortgage_rule_version_type
ALTER TABLE history_octane.qualified_mortgage_rule_version_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_qualified_mortgage_rule_version_type__etl_batch_id ON history_octane.qualified_mortgage_rule_version_type (etl_batch_id);

--adding etl_batch_id to history_octane.qualified_mortgage_status_type
ALTER TABLE history_octane.qualified_mortgage_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_qualified_mortgage_status_type__etl_batch_id ON history_octane.qualified_mortgage_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.qualified_mortgage_thresholds
ALTER TABLE history_octane.qualified_mortgage_thresholds
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_qualified_mortgage_thresholds__etl_batch_id ON history_octane.qualified_mortgage_thresholds (etl_batch_id);

--adding etl_batch_id to history_octane.qualifying_monthly_payment_type
ALTER TABLE history_octane.qualifying_monthly_payment_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_qualifying_monthly_payment_type__etl_batch_id ON history_octane.qualifying_monthly_payment_type (etl_batch_id);

--adding etl_batch_id to history_octane.qualifying_rate_type
ALTER TABLE history_octane.qualifying_rate_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_qualifying_rate_type__etl_batch_id ON history_octane.qualifying_rate_type (etl_batch_id);

--adding etl_batch_id to history_octane.quarter_type
ALTER TABLE history_octane.quarter_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_quarter_type__etl_batch_id ON history_octane.quarter_type (etl_batch_id);

--adding etl_batch_id to history_octane.quote_filter_pivot_type
ALTER TABLE history_octane.quote_filter_pivot_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_quote_filter_pivot_type__etl_batch_id ON history_octane.quote_filter_pivot_type (etl_batch_id);

--adding etl_batch_id to history_octane.rate_sheet
ALTER TABLE history_octane.rate_sheet
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_rate_sheet__etl_batch_id ON history_octane.rate_sheet (etl_batch_id);

--adding etl_batch_id to history_octane.rate_sheet_price
ALTER TABLE history_octane.rate_sheet_price
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_rate_sheet_price__etl_batch_id ON history_octane.rate_sheet_price (etl_batch_id);

--adding etl_batch_id to history_octane.rate_sheet_rate
ALTER TABLE history_octane.rate_sheet_rate
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_rate_sheet_rate__etl_batch_id ON history_octane.rate_sheet_rate (etl_batch_id);

--adding etl_batch_id to history_octane.realty_agent_scenario_type
ALTER TABLE history_octane.realty_agent_scenario_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_realty_agent_scenario_type__etl_batch_id ON history_octane.realty_agent_scenario_type (etl_batch_id);

--adding etl_batch_id to history_octane.recording_city
ALTER TABLE history_octane.recording_city
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_recording_city__etl_batch_id ON history_octane.recording_city (etl_batch_id);

--adding etl_batch_id to history_octane.recording_district
ALTER TABLE history_octane.recording_district
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_recording_district__etl_batch_id ON history_octane.recording_district (etl_batch_id);

--adding etl_batch_id to history_octane.recording_district_type
ALTER TABLE history_octane.recording_district_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_recording_district_type__etl_batch_id ON history_octane.recording_district_type (etl_batch_id);

--adding etl_batch_id to history_octane.refinance_improvements_type
ALTER TABLE history_octane.refinance_improvements_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_refinance_improvements_type__etl_batch_id ON history_octane.refinance_improvements_type (etl_batch_id);

--adding etl_batch_id to history_octane.region_ernst_page_rec
ALTER TABLE history_octane.region_ernst_page_rec
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_region_ernst_page_rec__etl_batch_id ON history_octane.region_ernst_page_rec (etl_batch_id);

--adding etl_batch_id to history_octane.relock_fee_setting
ALTER TABLE history_octane.relock_fee_setting
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_relock_fee_setting__etl_batch_id ON history_octane.relock_fee_setting (etl_batch_id);

--adding etl_batch_id to history_octane.rental_income
ALTER TABLE history_octane.rental_income
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_rental_income__etl_batch_id ON history_octane.rental_income (etl_batch_id);

--adding etl_batch_id to history_octane.reo_disposition_status_type
ALTER TABLE history_octane.reo_disposition_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_reo_disposition_status_type__etl_batch_id ON history_octane.reo_disposition_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.report
ALTER TABLE history_octane.report
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_report__etl_batch_id ON history_octane.report (etl_batch_id);

--adding etl_batch_id to history_octane.report_column
ALTER TABLE history_octane.report_column
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_report_column__etl_batch_id ON history_octane.report_column (etl_batch_id);

--adding etl_batch_id to history_octane.report_request_status_type
ALTER TABLE history_octane.report_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_report_request_status_type__etl_batch_id ON history_octane.report_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.report_row
ALTER TABLE history_octane.report_row
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_report_row__etl_batch_id ON history_octane.report_row (etl_batch_id);

--adding etl_batch_id to history_octane.report_type
ALTER TABLE history_octane.report_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_report_type__etl_batch_id ON history_octane.report_type (etl_batch_id);

--adding etl_batch_id to history_octane.repository_file
ALTER TABLE history_octane.repository_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_repository_file__etl_batch_id ON history_octane.repository_file (etl_batch_id);

--adding etl_batch_id to history_octane.req_decision_status_type
ALTER TABLE history_octane.req_decision_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_req_decision_status_type__etl_batch_id ON history_octane.req_decision_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.req_fulfill_status_type
ALTER TABLE history_octane.req_fulfill_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_req_fulfill_status_type__etl_batch_id ON history_octane.req_fulfill_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.rescission_notification_type
ALTER TABLE history_octane.rescission_notification_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_rescission_notification_type__etl_batch_id ON history_octane.rescission_notification_type (etl_batch_id);

--adding etl_batch_id to history_octane.respa_section_type
ALTER TABLE history_octane.respa_section_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_respa_section_type__etl_batch_id ON history_octane.respa_section_type (etl_batch_id);

--adding etl_batch_id to history_octane.road_type
ALTER TABLE history_octane.road_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_road_type__etl_batch_id ON history_octane.road_type (etl_batch_id);

--adding etl_batch_id to history_octane.role
ALTER TABLE history_octane.role
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role__etl_batch_id ON history_octane.role (etl_batch_id);

--adding etl_batch_id to history_octane.role_charge_permissions
ALTER TABLE history_octane.role_charge_permissions
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_charge_permissions__etl_batch_id ON history_octane.role_charge_permissions (etl_batch_id);

--adding etl_batch_id to history_octane.role_config_export_permission
ALTER TABLE history_octane.role_config_export_permission
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_config_export_permission__etl_batch_id ON history_octane.role_config_export_permission (etl_batch_id);

--adding etl_batch_id to history_octane.role_deal_context
ALTER TABLE history_octane.role_deal_context
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_deal_context__etl_batch_id ON history_octane.role_deal_context (etl_batch_id);

--adding etl_batch_id to history_octane.role_export_permission
ALTER TABLE history_octane.role_export_permission
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_export_permission__etl_batch_id ON history_octane.role_export_permission (etl_batch_id);

--adding etl_batch_id to history_octane.role_lender_toolbox
ALTER TABLE history_octane.role_lender_toolbox
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_lender_toolbox__etl_batch_id ON history_octane.role_lender_toolbox (etl_batch_id);

--adding etl_batch_id to history_octane.role_loans_toolbox
ALTER TABLE history_octane.role_loans_toolbox
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_loans_toolbox__etl_batch_id ON history_octane.role_loans_toolbox (etl_batch_id);

--adding etl_batch_id to history_octane.role_performer_assign
ALTER TABLE history_octane.role_performer_assign
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_performer_assign__etl_batch_id ON history_octane.role_performer_assign (etl_batch_id);

--adding etl_batch_id to history_octane.role_report
ALTER TABLE history_octane.role_report
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_role_report__etl_batch_id ON history_octane.role_report (etl_batch_id);

--adding etl_batch_id to history_octane.sanitation_type
ALTER TABLE history_octane.sanitation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_sanitation_type__etl_batch_id ON history_octane.sanitation_type (etl_batch_id);

--adding etl_batch_id to history_octane.sap_deal_step
ALTER TABLE history_octane.sap_deal_step
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_sap_deal_step__etl_batch_id ON history_octane.sap_deal_step (etl_batch_id);

--adding etl_batch_id to history_octane.sap_quote_request
ALTER TABLE history_octane.sap_quote_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_sap_quote_request__etl_batch_id ON history_octane.sap_quote_request (etl_batch_id);

--adding etl_batch_id to history_octane.sap_status_type
ALTER TABLE history_octane.sap_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_sap_status_type__etl_batch_id ON history_octane.sap_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.sap_step_type
ALTER TABLE history_octane.sap_step_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_sap_step_type__etl_batch_id ON history_octane.sap_step_type (etl_batch_id);

--adding etl_batch_id to history_octane.secondary_admin_event
ALTER TABLE history_octane.secondary_admin_event
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_secondary_admin_event__etl_batch_id ON history_octane.secondary_admin_event (etl_batch_id);

--adding etl_batch_id to history_octane.secondary_admin_event_entity_type
ALTER TABLE history_octane.secondary_admin_event_entity_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_secondary_admin_event_entity_type__etl_batch_id ON history_octane.secondary_admin_event_entity_type (etl_batch_id);

--adding etl_batch_id to history_octane.secondary_settings
ALTER TABLE history_octane.secondary_settings
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_secondary_settings__etl_batch_id ON history_octane.secondary_settings (etl_batch_id);

--adding etl_batch_id to history_octane.section_of_act_coarse_type
ALTER TABLE history_octane.section_of_act_coarse_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_section_of_act_coarse_type__etl_batch_id ON history_octane.section_of_act_coarse_type (etl_batch_id);

--adding etl_batch_id to history_octane.security_instrument_type
ALTER TABLE history_octane.security_instrument_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_security_instrument_type__etl_batch_id ON history_octane.security_instrument_type (etl_batch_id);

--adding etl_batch_id to history_octane.senior_lien_restriction_type
ALTER TABLE history_octane.senior_lien_restriction_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_senior_lien_restriction_type__etl_batch_id ON history_octane.senior_lien_restriction_type (etl_batch_id);

--adding etl_batch_id to history_octane.servicer_loan_id_assign_type
ALTER TABLE history_octane.servicer_loan_id_assign_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_servicer_loan_id_assign_type__etl_batch_id ON history_octane.servicer_loan_id_assign_type (etl_batch_id);

--adding etl_batch_id to history_octane.servicer_loan_id_assignment
ALTER TABLE history_octane.servicer_loan_id_assignment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_servicer_loan_id_assignment__etl_batch_id ON history_octane.servicer_loan_id_assignment (etl_batch_id);

--adding etl_batch_id to history_octane.servicer_loan_id_import_request
ALTER TABLE history_octane.servicer_loan_id_import_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_servicer_loan_id_import_request__etl_batch_id ON history_octane.servicer_loan_id_import_request (etl_batch_id);

--adding etl_batch_id to history_octane.servicer_loan_id_import_request_status_type
ALTER TABLE history_octane.servicer_loan_id_import_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_servicer_loan_id_import_request_status_type__etl_batch_id ON history_octane.servicer_loan_id_import_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.servicing_transfer_type
ALTER TABLE history_octane.servicing_transfer_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_servicing_transfer_type__etl_batch_id ON history_octane.servicing_transfer_type (etl_batch_id);

--adding etl_batch_id to history_octane.settlement_agent
ALTER TABLE history_octane.settlement_agent
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_settlement_agent__etl_batch_id ON history_octane.settlement_agent (etl_batch_id);

--adding etl_batch_id to history_octane.settlement_agent_office
ALTER TABLE history_octane.settlement_agent_office
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_settlement_agent_office__etl_batch_id ON history_octane.settlement_agent_office (etl_batch_id);

--adding etl_batch_id to history_octane.settlement_agent_wire
ALTER TABLE history_octane.settlement_agent_wire
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_settlement_agent_wire__etl_batch_id ON history_octane.settlement_agent_wire (etl_batch_id);

--adding etl_batch_id to history_octane.sheet_format_type
ALTER TABLE history_octane.sheet_format_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_sheet_format_type__etl_batch_id ON history_octane.sheet_format_type (etl_batch_id);

--adding etl_batch_id to history_octane.signature_part_type
ALTER TABLE history_octane.signature_part_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_signature_part_type__etl_batch_id ON history_octane.signature_part_type (etl_batch_id);

--adding etl_batch_id to history_octane.site_allowed_ip
ALTER TABLE history_octane.site_allowed_ip
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_site_allowed_ip__etl_batch_id ON history_octane.site_allowed_ip (etl_batch_id);

--adding etl_batch_id to history_octane.smart_charge
ALTER TABLE history_octane.smart_charge
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_charge__etl_batch_id ON history_octane.smart_charge (etl_batch_id);

--adding etl_batch_id to history_octane.smart_charge_apr_type
ALTER TABLE history_octane.smart_charge_apr_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_charge_apr_type__etl_batch_id ON history_octane.smart_charge_apr_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_charge_case
ALTER TABLE history_octane.smart_charge_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_charge_case__etl_batch_id ON history_octane.smart_charge_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_charge_group
ALTER TABLE history_octane.smart_charge_group
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_charge_group__etl_batch_id ON history_octane.smart_charge_group (etl_batch_id);

--adding etl_batch_id to history_octane.smart_charge_group_case
ALTER TABLE history_octane.smart_charge_group_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_charge_group_case__etl_batch_id ON history_octane.smart_charge_group_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc
ALTER TABLE history_octane.smart_doc
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc__etl_batch_id ON history_octane.smart_doc (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc_criteria
ALTER TABLE history_octane.smart_doc_criteria
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc_criteria__etl_batch_id ON history_octane.smart_doc_criteria (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc_note
ALTER TABLE history_octane.smart_doc_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc_note__etl_batch_id ON history_octane.smart_doc_note (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc_note_comment
ALTER TABLE history_octane.smart_doc_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc_note_comment__etl_batch_id ON history_octane.smart_doc_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc_note_monitor
ALTER TABLE history_octane.smart_doc_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc_note_monitor__etl_batch_id ON history_octane.smart_doc_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc_role
ALTER TABLE history_octane.smart_doc_role
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc_role__etl_batch_id ON history_octane.smart_doc_role (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc_set
ALTER TABLE history_octane.smart_doc_set
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc_set__etl_batch_id ON history_octane.smart_doc_set (etl_batch_id);

--adding etl_batch_id to history_octane.smart_doc_validity_date_case
ALTER TABLE history_octane.smart_doc_validity_date_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_doc_validity_date_case__etl_batch_id ON history_octane.smart_doc_validity_date_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_pay_frequency_type
ALTER TABLE history_octane.smart_ledger_pay_frequency_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_pay_frequency_type__etl_batch_id ON history_octane.smart_ledger_pay_frequency_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_plan
ALTER TABLE history_octane.smart_ledger_plan
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_plan__etl_batch_id ON history_octane.smart_ledger_plan (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_plan_case
ALTER TABLE history_octane.smart_ledger_plan_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_plan_case__etl_batch_id ON history_octane.smart_ledger_plan_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_plan_case_group
ALTER TABLE history_octane.smart_ledger_plan_case_group
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_plan_case_group__etl_batch_id ON history_octane.smart_ledger_plan_case_group (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_plan_case_group_calculation_type
ALTER TABLE history_octane.smart_ledger_plan_case_group_calculation_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_plan_case_group_calculation_type__etl_batch_id ON history_octane.smart_ledger_plan_case_group_calculation_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_plan_case_level_type
ALTER TABLE history_octane.smart_ledger_plan_case_level_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_plan_case_level_type__etl_batch_id ON history_octane.smart_ledger_plan_case_level_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_plan_case_type
ALTER TABLE history_octane.smart_ledger_plan_case_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_plan_case_type__etl_batch_id ON history_octane.smart_ledger_plan_case_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_ledger_plan_case_version
ALTER TABLE history_octane.smart_ledger_plan_case_version
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_ledger_plan_case_version__etl_batch_id ON history_octane.smart_ledger_plan_case_version (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message
ALTER TABLE history_octane.smart_message
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message__etl_batch_id ON history_octane.smart_message (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message_delivery_type
ALTER TABLE history_octane.smart_message_delivery_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message_delivery_type__etl_batch_id ON history_octane.smart_message_delivery_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message_email_recipient_type
ALTER TABLE history_octane.smart_message_email_recipient_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message_email_recipient_type__etl_batch_id ON history_octane.smart_message_email_recipient_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message_permission
ALTER TABLE history_octane.smart_message_permission
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message_permission__etl_batch_id ON history_octane.smart_message_permission (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message_permission_type
ALTER TABLE history_octane.smart_message_permission_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message_permission_type__etl_batch_id ON history_octane.smart_message_permission_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message_recipient
ALTER TABLE history_octane.smart_message_recipient
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message_recipient__etl_batch_id ON history_octane.smart_message_recipient (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message_recipient_type
ALTER TABLE history_octane.smart_message_recipient_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message_recipient_type__etl_batch_id ON history_octane.smart_message_recipient_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_message_source_type
ALTER TABLE history_octane.smart_message_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_message_source_type__etl_batch_id ON history_octane.smart_message_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_mi
ALTER TABLE history_octane.smart_mi
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_mi__etl_batch_id ON history_octane.smart_mi (etl_batch_id);

--adding etl_batch_id to history_octane.smart_mi_eligibility_case
ALTER TABLE history_octane.smart_mi_eligibility_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_mi_eligibility_case__etl_batch_id ON history_octane.smart_mi_eligibility_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_mi_rate_adjustment_case
ALTER TABLE history_octane.smart_mi_rate_adjustment_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_mi_rate_adjustment_case__etl_batch_id ON history_octane.smart_mi_rate_adjustment_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_mi_rate_card
ALTER TABLE history_octane.smart_mi_rate_card
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_mi_rate_card__etl_batch_id ON history_octane.smart_mi_rate_card (etl_batch_id);

--adding etl_batch_id to history_octane.smart_mi_rate_case
ALTER TABLE history_octane.smart_mi_rate_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_mi_rate_case__etl_batch_id ON history_octane.smart_mi_rate_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_mi_surcharge
ALTER TABLE history_octane.smart_mi_surcharge
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_mi_surcharge__etl_batch_id ON history_octane.smart_mi_surcharge (etl_batch_id);

--adding etl_batch_id to history_octane.smart_mi_surcharge_case
ALTER TABLE history_octane.smart_mi_surcharge_case
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_mi_surcharge_case__etl_batch_id ON history_octane.smart_mi_surcharge_case (etl_batch_id);

--adding etl_batch_id to history_octane.smart_req
ALTER TABLE history_octane.smart_req
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_req__etl_batch_id ON history_octane.smart_req (etl_batch_id);

--adding etl_batch_id to history_octane.smart_separator
ALTER TABLE history_octane.smart_separator
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_separator__etl_batch_id ON history_octane.smart_separator (etl_batch_id);

--adding etl_batch_id to history_octane.smart_set_doc
ALTER TABLE history_octane.smart_set_doc
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_set_doc__etl_batch_id ON history_octane.smart_set_doc (etl_batch_id);

--adding etl_batch_id to history_octane.smart_stack
ALTER TABLE history_octane.smart_stack
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_stack__etl_batch_id ON history_octane.smart_stack (etl_batch_id);

--adding etl_batch_id to history_octane.smart_stack_doc
ALTER TABLE history_octane.smart_stack_doc
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_stack_doc__etl_batch_id ON history_octane.smart_stack_doc (etl_batch_id);

--adding etl_batch_id to history_octane.smart_stack_doc_set_include_option_type
ALTER TABLE history_octane.smart_stack_doc_set_include_option_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_stack_doc_set_include_option_type__etl_batch_id ON history_octane.smart_stack_doc_set_include_option_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_stack_doc_set_include_type
ALTER TABLE history_octane.smart_stack_doc_set_include_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_stack_doc_set_include_type__etl_batch_id ON history_octane.smart_stack_doc_set_include_type (etl_batch_id);

--adding etl_batch_id to history_octane.smart_task
ALTER TABLE history_octane.smart_task
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_task__etl_batch_id ON history_octane.smart_task (etl_batch_id);

--adding etl_batch_id to history_octane.smart_task_tag_modifier
ALTER TABLE history_octane.smart_task_tag_modifier
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_smart_task_tag_modifier__etl_batch_id ON history_octane.smart_task_tag_modifier (etl_batch_id);

--adding etl_batch_id to history_octane.solar_panel_type
ALTER TABLE history_octane.solar_panel_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_solar_panel_type__etl_batch_id ON history_octane.solar_panel_type (etl_batch_id);

--adding etl_batch_id to history_octane.stack_doc_type
ALTER TABLE history_octane.stack_doc_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_doc_type__etl_batch_id ON history_octane.stack_doc_type (etl_batch_id);

--adding etl_batch_id to history_octane.stack_export_file
ALTER TABLE history_octane.stack_export_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_export_file__etl_batch_id ON history_octane.stack_export_file (etl_batch_id);

--adding etl_batch_id to history_octane.stack_export_file_name_format_type
ALTER TABLE history_octane.stack_export_file_name_format_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_export_file_name_format_type__etl_batch_id ON history_octane.stack_export_file_name_format_type (etl_batch_id);

--adding etl_batch_id to history_octane.stack_export_file_type
ALTER TABLE history_octane.stack_export_file_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_export_file_type__etl_batch_id ON history_octane.stack_export_file_type (etl_batch_id);

--adding etl_batch_id to history_octane.stack_export_loan_name_format_type
ALTER TABLE history_octane.stack_export_loan_name_format_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_export_loan_name_format_type__etl_batch_id ON history_octane.stack_export_loan_name_format_type (etl_batch_id);

--adding etl_batch_id to history_octane.stack_export_request
ALTER TABLE history_octane.stack_export_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_export_request__etl_batch_id ON history_octane.stack_export_request (etl_batch_id);

--adding etl_batch_id to history_octane.stack_export_request_loan_export_type
ALTER TABLE history_octane.stack_export_request_loan_export_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_export_request_loan_export_type__etl_batch_id ON history_octane.stack_export_request_loan_export_type (etl_batch_id);

--adding etl_batch_id to history_octane.stack_export_request_status_type
ALTER TABLE history_octane.stack_export_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stack_export_request_status_type__etl_batch_id ON history_octane.stack_export_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.state_type
ALTER TABLE history_octane.state_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_state_type__etl_batch_id ON history_octane.state_type (etl_batch_id);

--adding etl_batch_id to history_octane.street_links_product_type
ALTER TABLE history_octane.street_links_product_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_street_links_product_type__etl_batch_id ON history_octane.street_links_product_type (etl_batch_id);

--adding etl_batch_id to history_octane.stripe_payment
ALTER TABLE history_octane.stripe_payment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stripe_payment__etl_batch_id ON history_octane.stripe_payment (etl_batch_id);

--adding etl_batch_id to history_octane.stripe_payment_status_type
ALTER TABLE history_octane.stripe_payment_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_stripe_payment_status_type__etl_batch_id ON history_octane.stripe_payment_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.tax_filing_status_type
ALTER TABLE history_octane.tax_filing_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_tax_filing_status_type__etl_batch_id ON history_octane.tax_filing_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.tax_transcript_request
ALTER TABLE history_octane.tax_transcript_request
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_tax_transcript_request__etl_batch_id ON history_octane.tax_transcript_request (etl_batch_id);

--adding etl_batch_id to history_octane.tax_transcript_request_status_type
ALTER TABLE history_octane.tax_transcript_request_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_tax_transcript_request_status_type__etl_batch_id ON history_octane.tax_transcript_request_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.taxpayer_identifier_type
ALTER TABLE history_octane.taxpayer_identifier_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_taxpayer_identifier_type__etl_batch_id ON history_octane.taxpayer_identifier_type (etl_batch_id);

--adding etl_batch_id to history_octane.third_party_community_second_program
ALTER TABLE history_octane.third_party_community_second_program
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_third_party_community_second_program__etl_batch_id ON history_octane.third_party_community_second_program (etl_batch_id);

--adding etl_batch_id to history_octane.third_party_community_second_program_eligibility_type
ALTER TABLE history_octane.third_party_community_second_program_eligibility_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_30277e36726606e5305b04f806830229 ON history_octane.third_party_community_second_program_eligibility_type (etl_batch_id);

--adding etl_batch_id to history_octane.time_zone_type
ALTER TABLE history_octane.time_zone_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_time_zone_type__etl_batch_id ON history_octane.time_zone_type (etl_batch_id);

--adding etl_batch_id to history_octane.timeout_time_zone_type
ALTER TABLE history_octane.timeout_time_zone_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_timeout_time_zone_type__etl_batch_id ON history_octane.timeout_time_zone_type (etl_batch_id);

--adding etl_batch_id to history_octane.title_company
ALTER TABLE history_octane.title_company
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_title_company__etl_batch_id ON history_octane.title_company (etl_batch_id);

--adding etl_batch_id to history_octane.title_company_office
ALTER TABLE history_octane.title_company_office
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_title_company_office__etl_batch_id ON history_octane.title_company_office (etl_batch_id);

--adding etl_batch_id to history_octane.title_manner_held_type
ALTER TABLE history_octane.title_manner_held_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_title_manner_held_type__etl_batch_id ON history_octane.title_manner_held_type (etl_batch_id);

--adding etl_batch_id to history_octane.total_expert_account_type
ALTER TABLE history_octane.total_expert_account_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_total_expert_account_type__etl_batch_id ON history_octane.total_expert_account_type (etl_batch_id);

--adding etl_batch_id to history_octane.trade
ALTER TABLE history_octane.trade
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade__etl_batch_id ON history_octane.trade (etl_batch_id);

--adding etl_batch_id to history_octane.trade_audit
ALTER TABLE history_octane.trade_audit
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_audit__etl_batch_id ON history_octane.trade_audit (etl_batch_id);

--adding etl_batch_id to history_octane.trade_audit_type
ALTER TABLE history_octane.trade_audit_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_audit_type__etl_batch_id ON history_octane.trade_audit_type (etl_batch_id);

--adding etl_batch_id to history_octane.trade_fee
ALTER TABLE history_octane.trade_fee
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_fee__etl_batch_id ON history_octane.trade_fee (etl_batch_id);

--adding etl_batch_id to history_octane.trade_fee_type
ALTER TABLE history_octane.trade_fee_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_fee_type__etl_batch_id ON history_octane.trade_fee_type (etl_batch_id);

--adding etl_batch_id to history_octane.trade_file
ALTER TABLE history_octane.trade_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_file__etl_batch_id ON history_octane.trade_file (etl_batch_id);

--adding etl_batch_id to history_octane.trade_lock_filter
ALTER TABLE history_octane.trade_lock_filter
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_lock_filter__etl_batch_id ON history_octane.trade_lock_filter (etl_batch_id);

--adding etl_batch_id to history_octane.trade_note
ALTER TABLE history_octane.trade_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_note__etl_batch_id ON history_octane.trade_note (etl_batch_id);

--adding etl_batch_id to history_octane.trade_note_comment
ALTER TABLE history_octane.trade_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_note_comment__etl_batch_id ON history_octane.trade_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.trade_note_monitor
ALTER TABLE history_octane.trade_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_note_monitor__etl_batch_id ON history_octane.trade_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.trade_pricing_type
ALTER TABLE history_octane.trade_pricing_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_pricing_type__etl_batch_id ON history_octane.trade_pricing_type (etl_batch_id);

--adding etl_batch_id to history_octane.trade_product
ALTER TABLE history_octane.trade_product
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_product__etl_batch_id ON history_octane.trade_product (etl_batch_id);

--adding etl_batch_id to history_octane.trade_status_type
ALTER TABLE history_octane.trade_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trade_status_type__etl_batch_id ON history_octane.trade_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.trust_classification_type
ALTER TABLE history_octane.trust_classification_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trust_classification_type__etl_batch_id ON history_octane.trust_classification_type (etl_batch_id);

--adding etl_batch_id to history_octane.trustee
ALTER TABLE history_octane.trustee
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_trustee__etl_batch_id ON history_octane.trustee (etl_batch_id);

--adding etl_batch_id to history_octane.underwrite_disposition_type
ALTER TABLE history_octane.underwrite_disposition_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_underwrite_disposition_type__etl_batch_id ON history_octane.underwrite_disposition_type (etl_batch_id);

--adding etl_batch_id to history_octane.underwrite_method_type
ALTER TABLE history_octane.underwrite_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_underwrite_method_type__etl_batch_id ON history_octane.underwrite_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.underwrite_risk_assessment_type
ALTER TABLE history_octane.underwrite_risk_assessment_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_underwrite_risk_assessment_type__etl_batch_id ON history_octane.underwrite_risk_assessment_type (etl_batch_id);

--adding etl_batch_id to history_octane.unique_dwelling_type
ALTER TABLE history_octane.unique_dwelling_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_unique_dwelling_type__etl_batch_id ON history_octane.unique_dwelling_type (etl_batch_id);

--adding etl_batch_id to history_octane.unpaid_balance_adjustment
ALTER TABLE history_octane.unpaid_balance_adjustment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_unpaid_balance_adjustment__etl_batch_id ON history_octane.unpaid_balance_adjustment (etl_batch_id);

--adding etl_batch_id to history_octane.usda_rd_single_family_housing_type
ALTER TABLE history_octane.usda_rd_single_family_housing_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_usda_rd_single_family_housing_type__etl_batch_id ON history_octane.usda_rd_single_family_housing_type (etl_batch_id);

--adding etl_batch_id to history_octane.uuts_loan_originator_type
ALTER TABLE history_octane.uuts_loan_originator_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_uuts_loan_originator_type__etl_batch_id ON history_octane.uuts_loan_originator_type (etl_batch_id);

--adding etl_batch_id to history_octane.va_borrower_certification_occupancy_type
ALTER TABLE history_octane.va_borrower_certification_occupancy_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_va_borrower_certification_occupancy_type__etl_batch_id ON history_octane.va_borrower_certification_occupancy_type (etl_batch_id);

--adding etl_batch_id to history_octane.va_entitlement_code_type
ALTER TABLE history_octane.va_entitlement_code_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_va_entitlement_code_type__etl_batch_id ON history_octane.va_entitlement_code_type (etl_batch_id);

--adding etl_batch_id to history_octane.va_entitlement_restoration_type
ALTER TABLE history_octane.va_entitlement_restoration_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_va_entitlement_restoration_type__etl_batch_id ON history_octane.va_entitlement_restoration_type (etl_batch_id);

--adding etl_batch_id to history_octane.va_notice_of_value_source_type
ALTER TABLE history_octane.va_notice_of_value_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_va_notice_of_value_source_type__etl_batch_id ON history_octane.va_notice_of_value_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.va_past_credit_record_type
ALTER TABLE history_octane.va_past_credit_record_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_va_past_credit_record_type__etl_batch_id ON history_octane.va_past_credit_record_type (etl_batch_id);

--adding etl_batch_id to history_octane.va_regional_loan_center_type
ALTER TABLE history_octane.va_regional_loan_center_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_va_regional_loan_center_type__etl_batch_id ON history_octane.va_regional_loan_center_type (etl_batch_id);

--adding etl_batch_id to history_octane.va_relative_relationship_type
ALTER TABLE history_octane.va_relative_relationship_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_va_relative_relationship_type__etl_batch_id ON history_octane.va_relative_relationship_type (etl_batch_id);

--adding etl_batch_id to history_octane.vendor_credential_source_type
ALTER TABLE history_octane.vendor_credential_source_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_vendor_credential_source_type__etl_batch_id ON history_octane.vendor_credential_source_type (etl_batch_id);

--adding etl_batch_id to history_octane.vendor_document_event
ALTER TABLE history_octane.vendor_document_event
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_vendor_document_event__etl_batch_id ON history_octane.vendor_document_event (etl_batch_id);

--adding etl_batch_id to history_octane.vendor_document_event_type
ALTER TABLE history_octane.vendor_document_event_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_vendor_document_event_type__etl_batch_id ON history_octane.vendor_document_event_type (etl_batch_id);

--adding etl_batch_id to history_octane.vendor_document_repository_file
ALTER TABLE history_octane.vendor_document_repository_file
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_vendor_document_repository_file__etl_batch_id ON history_octane.vendor_document_repository_file (etl_batch_id);

--adding etl_batch_id to history_octane.vendor_import_document_type
ALTER TABLE history_octane.vendor_import_document_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_vendor_import_document_type__etl_batch_id ON history_octane.vendor_import_document_type (etl_batch_id);

--adding etl_batch_id to history_octane.veteran_status_type
ALTER TABLE history_octane.veteran_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_veteran_status_type__etl_batch_id ON history_octane.veteran_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.view_wf_deal_step_started
ALTER TABLE history_octane.view_wf_deal_step_started
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_view_wf_deal_step_started__etl_batch_id ON history_octane.view_wf_deal_step_started (etl_batch_id);

--adding etl_batch_id to history_octane.voe_third_party_verifier_type
ALTER TABLE history_octane.voe_third_party_verifier_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_voe_third_party_verifier_type__etl_batch_id ON history_octane.voe_third_party_verifier_type (etl_batch_id);

--adding etl_batch_id to history_octane.voe_verbal_verify_method_type
ALTER TABLE history_octane.voe_verbal_verify_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_voe_verbal_verify_method_type__etl_batch_id ON history_octane.voe_verbal_verify_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.voe_verify_method_type
ALTER TABLE history_octane.voe_verify_method_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_voe_verify_method_type__etl_batch_id ON history_octane.voe_verify_method_type (etl_batch_id);

--adding etl_batch_id to history_octane.water_type
ALTER TABLE history_octane.water_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_water_type__etl_batch_id ON history_octane.water_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_fork_process
ALTER TABLE history_octane.wf_deal_fork_process
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_fork_process__etl_batch_id ON history_octane.wf_deal_fork_process (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_function_queue
ALTER TABLE history_octane.wf_deal_function_queue
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_function_queue__etl_batch_id ON history_octane.wf_deal_function_queue (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_outcome
ALTER TABLE history_octane.wf_deal_outcome
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_outcome__etl_batch_id ON history_octane.wf_deal_outcome (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_process
ALTER TABLE history_octane.wf_deal_process
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_process__etl_batch_id ON history_octane.wf_deal_process (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_process_status_type
ALTER TABLE history_octane.wf_deal_process_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_process_status_type__etl_batch_id ON history_octane.wf_deal_process_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_step
ALTER TABLE history_octane.wf_deal_step
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_step__etl_batch_id ON history_octane.wf_deal_step (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_step_performer_unavailable
ALTER TABLE history_octane.wf_deal_step_performer_unavailable
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_step_performer_unavailable__etl_batch_id ON history_octane.wf_deal_step_performer_unavailable (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_step_status_type
ALTER TABLE history_octane.wf_deal_step_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_step_status_type__etl_batch_id ON history_octane.wf_deal_step_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_deal_step_timeout
ALTER TABLE history_octane.wf_deal_step_timeout
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_deal_step_timeout__etl_batch_id ON history_octane.wf_deal_step_timeout (etl_batch_id);

--adding etl_batch_id to history_octane.wf_fork_process
ALTER TABLE history_octane.wf_fork_process
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_fork_process__etl_batch_id ON history_octane.wf_fork_process (etl_batch_id);

--adding etl_batch_id to history_octane.wf_outcome
ALTER TABLE history_octane.wf_outcome
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_outcome__etl_batch_id ON history_octane.wf_outcome (etl_batch_id);

--adding etl_batch_id to history_octane.wf_outcome_type
ALTER TABLE history_octane.wf_outcome_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_outcome_type__etl_batch_id ON history_octane.wf_outcome_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_phase
ALTER TABLE history_octane.wf_phase
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_phase__etl_batch_id ON history_octane.wf_phase (etl_batch_id);

--adding etl_batch_id to history_octane.wf_polling_time_slice
ALTER TABLE history_octane.wf_polling_time_slice
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_polling_time_slice__etl_batch_id ON history_octane.wf_polling_time_slice (etl_batch_id);

--adding etl_batch_id to history_octane.wf_prereq
ALTER TABLE history_octane.wf_prereq
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_prereq__etl_batch_id ON history_octane.wf_prereq (etl_batch_id);

--adding etl_batch_id to history_octane.wf_prereq_set
ALTER TABLE history_octane.wf_prereq_set
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_prereq_set__etl_batch_id ON history_octane.wf_prereq_set (etl_batch_id);

--adding etl_batch_id to history_octane.wf_process
ALTER TABLE history_octane.wf_process
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_process__etl_batch_id ON history_octane.wf_process (etl_batch_id);

--adding etl_batch_id to history_octane.wf_process_note
ALTER TABLE history_octane.wf_process_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_process_note__etl_batch_id ON history_octane.wf_process_note (etl_batch_id);

--adding etl_batch_id to history_octane.wf_process_note_comment
ALTER TABLE history_octane.wf_process_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_process_note_comment__etl_batch_id ON history_octane.wf_process_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.wf_process_note_monitor
ALTER TABLE history_octane.wf_process_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_process_note_monitor__etl_batch_id ON history_octane.wf_process_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.wf_process_status_type
ALTER TABLE history_octane.wf_process_status_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_process_status_type__etl_batch_id ON history_octane.wf_process_status_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_process_type
ALTER TABLE history_octane.wf_process_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_process_type__etl_batch_id ON history_octane.wf_process_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step
ALTER TABLE history_octane.wf_step
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step__etl_batch_id ON history_octane.wf_step (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_deal_check
ALTER TABLE history_octane.wf_step_deal_check
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_deal_check__etl_batch_id ON history_octane.wf_step_deal_check (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_deal_check_definition
ALTER TABLE history_octane.wf_step_deal_check_definition
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_deal_check_definition__etl_batch_id ON history_octane.wf_step_deal_check_definition (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_deal_check_dependency
ALTER TABLE history_octane.wf_step_deal_check_dependency
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_deal_check_dependency__etl_batch_id ON history_octane.wf_step_deal_check_dependency (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_deal_tag_modifier
ALTER TABLE history_octane.wf_step_deal_tag_modifier
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_deal_tag_modifier__etl_batch_id ON history_octane.wf_step_deal_tag_modifier (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_function_type
ALTER TABLE history_octane.wf_step_function_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_function_type__etl_batch_id ON history_octane.wf_step_function_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_note
ALTER TABLE history_octane.wf_step_note
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_note__etl_batch_id ON history_octane.wf_step_note (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_note_comment
ALTER TABLE history_octane.wf_step_note_comment
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_note_comment__etl_batch_id ON history_octane.wf_step_note_comment (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_note_monitor
ALTER TABLE history_octane.wf_step_note_monitor
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_note_monitor__etl_batch_id ON history_octane.wf_step_note_monitor (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_performer_assign_type
ALTER TABLE history_octane.wf_step_performer_assign_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_performer_assign_type__etl_batch_id ON history_octane.wf_step_performer_assign_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_reassign_type
ALTER TABLE history_octane.wf_step_reassign_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_reassign_type__etl_batch_id ON history_octane.wf_step_reassign_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_timeout_type
ALTER TABLE history_octane.wf_step_timeout_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_timeout_type__etl_batch_id ON history_octane.wf_step_timeout_type (etl_batch_id);

--adding etl_batch_id to history_octane.wf_step_type
ALTER TABLE history_octane.wf_step_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_wf_step_type__etl_batch_id ON history_octane.wf_step_type (etl_batch_id);

--adding etl_batch_id to history_octane.workspace_type
ALTER TABLE history_octane.workspace_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_workspace_type__etl_batch_id ON history_octane.workspace_type (etl_batch_id);

--adding etl_batch_id to history_octane.yes_no_na_type
ALTER TABLE history_octane.yes_no_na_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_yes_no_na_type__etl_batch_id ON history_octane.yes_no_na_type (etl_batch_id);

--adding etl_batch_id to history_octane.yes_no_na_unknown_type
ALTER TABLE history_octane.yes_no_na_unknown_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_yes_no_na_unknown_type__etl_batch_id ON history_octane.yes_no_na_unknown_type (etl_batch_id);

--adding etl_batch_id to history_octane.yes_no_unknown_type
ALTER TABLE history_octane.yes_no_unknown_type
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_yes_no_unknown_type__etl_batch_id ON history_octane.yes_no_unknown_type (etl_batch_id);

--adding etl_batch_id to history_octane.zip_code_info
ALTER TABLE history_octane.zip_code_info
    ADD COLUMN etl_batch_id TEXT;

CREATE INDEX idx_zip_code_info__etl_batch_id ON history_octane.zip_code_info (etl_batch_id);
