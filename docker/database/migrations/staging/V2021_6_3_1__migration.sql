--
-- Main | EDW | Octane Schema changes for 2021.6.3.1 (6/18/2021) (https://app.asana.com/0/0/1200488131634566 )
--

-- staging_octane changes
CREATE TABLE staging_octane.loan_charge_payer_item_source_type (
                                                                   code varchar(128),
                                                                   value varchar(1024),
                                                                   constraint pk_loan_charge_payer_item_source_type primary key (code)
);

CREATE TABLE staging_octane.loan_charge_payer_item (
                                                       lcpi_pid bigint,
                                                       lcpi_version integer,
                                                       constraint pk_loan_charge_payer_item primary key (lcpi_pid),
                                                       lcpi_item_amount numeric(15,2),
                                                       lcpi_loan_charge_payer_item_source_type varchar(128),
                                                       lcpi_loan_charge_pid bigint,
                                                       lcpi_charge_payer_type varchar(128),
                                                       lcpi_paid_by varchar(128),
                                                       lcpi_poc boolean,
                                                       lcpi_charge_wire_action_auto_compute boolean,
                                                       lcpi_charge_wire_action_type varchar(128)
);

CREATE INDEX idx_loan_charge_payer_item__pid_version ON staging_octane.loan_charge_payer_item (lcpi_pid, lcpi_version);

ALTER TABLE staging_octane.loan_charge
    DROP COLUMN lc_charge_payer_type,
    DROP COLUMN lc_paid_by,
    DROP COLUMN lc_poc,
    DROP COLUMN lc_charge_wire_action_auto_compute,
    DROP COLUMN lc_charge_wire_action_type;

CREATE TABLE staging_octane.wf_prereq_set (
                                              wps_pid bigint,
                                              wps_version integer,
                                              constraint pk_wf_prereq_set primary key (wps_pid),
                                              wps_account_pid bigint,
                                              wps_wf_prereq_set_name varchar(256)
);

CREATE INDEX idx_wf_prereq_set__pid_version ON staging_octane.wf_prereq_set (wps_pid, wps_version);

CREATE TABLE staging_octane.wf_prereq (
                                          wp_pid bigint,
                                          wp_version integer,
                                          constraint pk_wf_prereq primary key (wp_pid),
                                          wp_wf_prereq_set_pid bigint,
                                          wp_wf_step_pid bigint
);

CREATE INDEX idx_wf_prereq__pid_version ON staging_octane.wf_prereq (wp_pid, wp_version);

ALTER TABLE staging_octane.wf_step
    ADD COLUMN ws_wf_prereq_set_pid bigint;

ALTER TABLE staging_octane.appraisal
    ADD COLUMN apr_appraisal_invoice_amount decimal(17,2);

ALTER TABLE staging_octane.appraisal_order_request
    DROP COLUMN aprq_appraisal_fee_amount;

ALTER TABLE staging_octane.mcr_loan
    ADD COLUMN mcrl_servicing_transfer_type varchar(128);

ALTER TABLE staging_octane.place
    DROP COLUMN pl_refinance_improvements_type,
    DROP COLUMN pl_refinance_proposed_improvements_description,
    DROP COLUMN pl_refinance_total_improvement_costs_amount,
    DROP COLUMN pl_construction_improvement_costs_amount,
    DROP COLUMN pl_energy_improvement_replacement_major_system,
    DROP COLUMN pl_energy_improvement_insulation_sealant,
    DROP COLUMN pl_energy_improvement_installation_solar,
    DROP COLUMN pl_energy_improvement_addition_new_feature,
    DROP COLUMN pl_energy_improvement_other,
    DROP COLUMN pl_energy_related_repairs_or_improvements_amount,
    DROP COLUMN pl_refinance_general_improvements_amount;

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_financed_property_improvements boolean,
    ADD COLUMN prp_estimated_hard_construction_cost_amount bigint;

ALTER TABLE staging_octane.construction_cost
    ADD COLUMN coc_calculated_construction_cost_percent numeric(11,9),
    ADD COLUMN coc_overridden_construction_cost_percent numeric(11,9),
    ALTER COLUMN coc_calculation_percentage SET DATA TYPE numeric(11,9),
    ADD COLUMN coc_construction_cost_calculation_percent_override_reason varchar(1024),
    ADD COLUMN coc_calculated_construction_cost_months integer,
    ADD COLUMN coc_overridden_construction_cost_months integer,
    ADD COLUMN coc_effective_construction_cost_months integer,
    ADD COLUMN coc_construction_cost_months_override_reason varchar(1024);

ALTER TABLE staging_octane.construction_cost RENAME COLUMN coc_calculation_percentage TO coc_effective_construction_cost_calculation_percent;

ALTER TABLE staging_octane.construction_cost
    ADD COLUMN coc_charge_type varchar(128),
    ADD COLUMN coc_draw_discrepancy_text varchar(1024),
    ADD COLUMN coc_impeding_draw_discrepancy boolean;


-- history_octane changes
ALTER TABLE history_octane.construction_cost
    ADD COLUMN coc_charge_type varchar(128),
    ADD COLUMN coc_draw_discrepancy_text varchar(1024),
    ADD COLUMN coc_impeding_draw_discrepancy boolean;

CREATE INDEX fkt_coc_charge_type ON history_octane.construction_cost (coc_charge_type);

CREATE TABLE history_octane.loan_charge_payer_item_source_type (
                                                                   code varchar(128),
                                                                   value varchar(1024),
                                                                   data_source_updated_datetime timestamptz,
                                                                   data_source_deleted_flag boolean
);

CREATE INDEX idx_bc194054388b1c9625f6ecb10bca4534 ON history_octane.loan_charge_payer_item_source_type (data_source_updated_datetime);

CREATE INDEX idx_37051d2e2fb575e9017a57d045ff2e3f ON history_octane.loan_charge_payer_item_source_type (data_source_deleted_flag);

CREATE TABLE history_octane.loan_charge_payer_item (
                                                       lcpi_pid bigint,
                                                       lcpi_version integer,
                                                       lcpi_item_amount numeric(15,2),
                                                       lcpi_loan_charge_payer_item_source_type varchar(128),
                                                       lcpi_loan_charge_pid bigint,
                                                       lcpi_charge_payer_type varchar(128),
                                                       lcpi_paid_by varchar(128),
                                                       lcpi_poc boolean,
                                                       lcpi_charge_wire_action_auto_compute boolean,
                                                       lcpi_charge_wire_action_type varchar(128),
                                                       data_source_updated_datetime timestamptz,
                                                       data_source_deleted_flag boolean
);

CREATE INDEX idx_loan_charge_payer_item__pid ON history_octane.loan_charge_payer_item (lcpi_pid);

CREATE INDEX idx_loan_charge_payer_item__data_source_updated_datetime ON history_octane.loan_charge_payer_item (data_source_updated_datetime);

CREATE INDEX idx_loan_charge_payer_item__data_source_deleted_flag ON history_octane.loan_charge_payer_item (data_source_deleted_flag);

CREATE INDEX idx_loan_charge_payer_item__pid_version ON history_octane.loan_charge_payer_item (lcpi_pid, lcpi_version);

CREATE INDEX fk_loan_charge_payer_item_1 ON history_octane.loan_charge_payer_item (lcpi_loan_charge_pid);

CREATE INDEX fkt_lcpi_loan_charge_payer_item_source_type ON history_octane.loan_charge_payer_item (lcpi_loan_charge_payer_item_source_type);

CREATE INDEX fkt_lcpi_charge_payer_type ON history_octane.loan_charge_payer_item (lcpi_charge_payer_type);

CREATE INDEX fkt_lcpi_charge_wire_action_type ON history_octane.loan_charge_payer_item (lcpi_charge_wire_action_type);

CREATE TABLE history_octane.wf_prereq_set (
                                              wps_pid bigint,
                                              wps_version integer,
                                              wps_account_pid bigint,
                                              wps_wf_prereq_set_name varchar(256),
                                              data_source_updated_datetime timestamptz,
                                              data_source_deleted_flag boolean
);

CREATE INDEX idx_wf_prereq_set__pid ON history_octane.wf_prereq_set (wps_pid);

CREATE INDEX idx_wf_prereq_set__data_source_updated_datetime ON history_octane.wf_prereq_set (data_source_updated_datetime);

CREATE INDEX idx_wf_prereq_set__data_source_deleted_flag ON history_octane.wf_prereq_set (data_source_deleted_flag);

CREATE INDEX idx_wf_prereq_set__pid_version ON history_octane.wf_prereq_set (wps_pid, wps_version);

CREATE INDEX fk_wf_prereq_set_1 ON history_octane.wf_prereq_set (wps_account_pid);

CREATE TABLE history_octane.wf_prereq (
                                          wp_pid bigint,
                                          wp_version integer,
                                          wp_wf_prereq_set_pid bigint,
                                          wp_wf_step_pid bigint,
                                          data_source_updated_datetime timestamptz,
                                          data_source_deleted_flag boolean
);

CREATE INDEX idx_wf_prereq__pid ON history_octane.wf_prereq (wp_pid);

CREATE INDEX idx_wf_prereq__data_source_updated_datetime ON history_octane.wf_prereq (data_source_updated_datetime);

CREATE INDEX idx_wf_prereq__data_source_deleted_flag ON history_octane.wf_prereq (data_source_deleted_flag);

CREATE INDEX idx_wf_prereq__pid_version ON history_octane.wf_prereq (wp_pid, wp_version);

CREATE INDEX fk_wf_prereq_1 ON history_octane.wf_prereq (wp_wf_prereq_set_pid);

CREATE INDEX fk_wf_prereq_2 ON history_octane.wf_prereq (wp_wf_step_pid);

ALTER TABLE history_octane.wf_step
    ADD COLUMN ws_wf_prereq_set_pid bigint;

CREATE INDEX fk_wf_step_7 ON history_octane.wf_step (ws_wf_prereq_set_pid);

ALTER TABLE history_octane.appraisal
    ADD COLUMN apr_appraisal_invoice_amount decimal(17,2);

ALTER TABLE history_octane.mcr_loan
    ADD COLUMN mcrl_servicing_transfer_type varchar(128);

CREATE INDEX fkt_mcrl_servicing_transfer_type ON history_octane.mcr_loan (mcrl_servicing_transfer_type);

ALTER TABLE history_octane.proposal
    ADD COLUMN prp_financed_property_improvements boolean,
    ADD COLUMN prp_estimated_hard_construction_cost_amount bigint;

ALTER TABLE history_octane.construction_cost
    ADD COLUMN coc_calculated_construction_cost_percent numeric(11,9),
    ADD COLUMN coc_overridden_construction_cost_percent numeric(11,9),
    ALTER COLUMN coc_calculation_percentage SET DATA TYPE numeric(11,9),
    ADD COLUMN coc_construction_cost_calculation_percent_override_reason varchar(1024),
    ADD COLUMN coc_calculated_construction_cost_months integer,
    ADD COLUMN coc_overridden_construction_cost_months integer,
    ADD COLUMN coc_effective_construction_cost_months integer,
    ADD COLUMN coc_construction_cost_months_override_reason varchar(1024);

ALTER TABLE history_octane.construction_cost RENAME COLUMN coc_calculation_percentage TO coc_effective_construction_cost_calculation_percent;
