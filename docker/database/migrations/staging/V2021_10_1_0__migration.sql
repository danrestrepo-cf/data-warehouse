/*
EDW | loan_fact and transaction_dim - multiple fixes (add more investors and key roles; include test loans; fix joins
for B3 borrower_dim, transaction_junk_dim, borrower_demographics_dim, loan_junk_dim, borrower_lending_profile_dim,
product_choice_dim, hmda_purchaser_of_loan; fix transaction_dim grain)
https://app.asana.com/0/0/1201078773927539
*/

ALTER TABLE star_loan.loan_fact
    ADD COLUMN account_executive_lender_user_dwid BIGINT
    , ADD COLUMN closing_doc_specialist_lender_user_dwid BIGINT
    , ADD COLUMN closing_scheduler_lender_user_dwid BIGINT
    , ADD COLUMN collateral_to_investor_lender_user_dwid BIGINT
    , ADD COLUMN collateral_underwriter_lender_user_dwid BIGINT
    , ADD COLUMN correspondent_client_advocate_lender_user_dwid BIGINT
    , ADD COLUMN final_documents_to_investor_lender_user_dwid BIGINT
    , ADD COLUMN flood_insurance_specialist_lender_user_dwid BIGINT
    , ADD COLUMN funder_lender_user_dwid BIGINT
    , ADD COLUMN government_insurance_lender_user_dwid BIGINT
    , ADD COLUMN ho6_specialist_lender_user_dwid BIGINT
    , ADD COLUMN hoa_specialist_lender_user_dwid BIGINT
    , ADD COLUMN hoi_specialist_lender_user_dwid BIGINT
    , ADD COLUMN hud_va_lender_officer_lender_user_dwid BIGINT
    , ADD COLUMN internal_construction_manager_lender_user_dwid BIGINT
    , ADD COLUMN investor_conditions_lender_user_dwid BIGINT
    , ADD COLUMN investor_stack_to_investor_lender_user_dwid BIGINT
    , ADD COLUMN loan_officer_assistant_lender_user_dwid BIGINT
    , ADD COLUMN loan_payoff_specialist_lender_user_dwid BIGINT
    , ADD COLUMN originator_lender_user_dwid BIGINT
    , ADD COLUMN processor_lender_user_dwid BIGINT
    , ADD COLUMN project_underwriter_lender_user_dwid BIGINT
    , ADD COLUMN subordination_specialist_lender_user_dwid BIGINT
    , ADD COLUMN supplemental_originator_lender_user_dwid BIGINT
    , ADD COLUMN title_specialist_lender_user_dwid BIGINT
    , ADD COLUMN transaction_assistant_lender_user_dwid BIGINT
    , ADD COLUMN underwriter_lender_user_dwid BIGINT
    , ADD COLUMN underwriting_manager_lender_user_dwid BIGINT
    , ADD COLUMN va_specialist_lender_user_dwid BIGINT
    , ADD COLUMN verbal_voe_specialist_lender_user_dwid BIGINT
    , ADD COLUMN voe_specialist_lender_user_dwid BIGINT
    , ADD COLUMN wholesale_client_advocate_lender_user_dwid BIGINT
    , ADD COLUMN wire_specialist_lender_user_dwid BIGINT
    , ADD COLUMN initial_beneficiary_investor_dwid BIGINT
    , ADD COLUMN first_beneficiary_after_initial_investor_dwid BIGINT
    , ADD COLUMN most_recent_purchasing_beneficiary_investor_dwid BIGINT
    , ADD COLUMN current_beneficiary_investor_dwid BIGINT;
