--
-- Main | EDW - Octane schemas from prod-release to v2021.10.1.0 on uat ( https://app.asana.com/0/0/1201077269203237 )
--

-- staging_octane changes:
-- column drops
ALTER TABLE staging_octane.smart_doc_validity_date_case
    DROP COLUMN sdvdc_criteria_html;

ALTER TABLE staging_octane.smart_mi_rate_case
    DROP COLUMN smrc_criteria_html;

ALTER TABLE staging_octane.smart_mi_rate_adjustment_case
    DROP COLUMN smrac_criteria_html;

ALTER TABLE staging_octane.smart_mi_surcharge_case
    DROP COLUMN smsc_criteria_html;

ALTER TABLE staging_octane.construction_cost
    DROP COLUMN coc_contractor_pid;

ALTER TABLE staging_octane.loan
    DROP COLUMN l_base_loan_amount_ltv_ratio_percent;


-- column adds
ALTER TABLE staging_octane.proposal_doc_set
    ADD COLUMN prpds_docs_last_updated_datetime timestamp;

ALTER TABLE staging_octane.proposal_doc_validity
    ADD COLUMN prpdv_criteria_html varchar(16000);

ALTER TABLE staging_octane.loan
    ADD COLUMN l_buyup_buydown_basis_points numeric(15,2);

-- column renames
ALTER TABLE staging_octane.loan
    ALTER COLUMN l_base_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_percent SET DATA TYPE numeric(15,2);

ALTER TABLE staging_octane.loan
    RENAME COLUMN l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points;

ALTER TABLE staging_octane.loan
    RENAME COLUMN l_guaranty_fee_percent TO l_guaranty_fee_basis_points;

ALTER TABLE staging_octane.loan
    RENAME COLUMN l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points;


-- history_octane changes:
-- column adds
ALTER TABLE history_octane.proposal_doc_validity
    ADD COLUMN prpdv_criteria_html varchar(16000);

ALTER TABLE history_octane.loan
    ADD COLUMN l_buyup_buydown_basis_points numeric(15,2);

ALTER TABLE history_octane.proposal_doc_set
    ADD COLUMN prpds_docs_last_updated_datetime timestamp;

-- column renames
ALTER TABLE history_octane.loan
    ALTER COLUMN l_base_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_percent SET DATA TYPE numeric(15,2);

ALTER TABLE history_octane.loan
    RENAME COLUMN l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points;

ALTER TABLE history_octane.loan
    RENAME COLUMN l_guaranty_fee_percent TO l_guaranty_fee_basis_points;

ALTER TABLE history_octane.loan
    RENAME COLUMN l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points;
