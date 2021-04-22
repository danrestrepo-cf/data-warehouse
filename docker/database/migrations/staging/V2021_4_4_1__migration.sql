--
-- EDW - Octane 4.4.3 changes (Org Admin) ( https://app.asana.com/0/0/1200221289923026 )
--

-- changes to staging_octane schema
CREATE TABLE staging_octane.org_node_type (
                                              code varchar(128),
                                              value varchar(1024),
                                              constraint pk_org_node_type primary key (code)
);

CREATE TABLE staging_octane.org_node_lender_user_type (
                                                          code varchar(128),
                                                          value varchar(1024),
                                                          constraint pk_org_node_lender_user_type primary key (code)
);

CREATE TABLE staging_octane.ledger_book_type (
                                                 code varchar(128),
                                                 value varchar(1024),
                                                 constraint pk_ledger_book_type primary key (code)
);

CREATE TABLE staging_octane.ledger_book_status_type (
                                                        code varchar(128),
                                                        value varchar(1024),
                                                        constraint pk_ledger_book_status_type primary key (code)
);

CREATE TABLE staging_octane.loan_org_lineage_source_type (
                                                             code varchar(128),
                                                             value varchar(1024),
                                                             constraint pk_loan_org_lineage_source_type primary key (code)
);

ALTER TABLE staging_octane.lock_series
    ADD COLUMN lsr_org_lineage_pid bigint;

ALTER TABLE staging_octane.criteria_pid_operand
    ADD COLUMN crpo_org_node_pid bigint;

CREATE TABLE staging_octane.ledger_entry_type (
                                                  code varchar(128),
                                                  value varchar(1024),
                                                  constraint pk_ledger_entry_type primary key (code)
);

CREATE TABLE staging_octane.ledger_entry_source_type (
                                                         code varchar(128),
                                                         value varchar(1024),
                                                         constraint pk_ledger_entry_source_type primary key (code)
);

CREATE TABLE staging_octane.ledger_entry_decision_status_type (
                                                                  code varchar(128),
                                                                  value varchar(1024),
                                                                  constraint pk_ledger_entry_decision_status_type primary key (code)
);

CREATE TABLE staging_octane.smart_ledger_plan_case_type (
                                                            code varchar(128),
                                                            value varchar(1024),
                                                            constraint pk_smart_ledger_plan_case_type primary key (code)
);

CREATE TABLE staging_octane.smart_ledger_plan_case_level_type (
                                                                  code varchar(128),
                                                                  value varchar(1024),
                                                                  constraint pk_smart_ledger_plan_case_level_type primary key (code)
);

CREATE TABLE staging_octane.smart_ledger_pay_frequency_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                constraint pk_smart_ledger_pay_frequency_type primary key (code)
);

CREATE TABLE staging_octane.ledger_basis_points_input_type (
                                                               code varchar(128),
                                                               value varchar(1024),
                                                               constraint pk_ledger_basis_points_input_type primary key (code)
);

CREATE TABLE staging_octane.smart_ledger_plan_case_group_calculation_type (
                                                                              code varchar(128),
                                                                              value varchar(1024),
                                                                              constraint pk_smart_ledger_plan_case_group_calculation_type primary key (code)
);

CREATE TABLE staging_octane.ledger_entry_review_status_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                constraint pk_ledger_entry_review_status_type primary key (code)
);

CREATE TABLE staging_octane.ledger_entry_review_reason_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                constraint pk_ledger_entry_review_reason_type primary key (code)
);

CREATE TABLE staging_octane.ledger_entry_import_status_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                constraint pk_ledger_entry_import_status_type primary key (code)
);

ALTER TABLE staging_octane.ledger_entry_type
    ADD COLUMN general_ledger_code varchar(8);


-- changes to history_octane schema
CREATE TABLE history_octane.org_node_type (
                                              code varchar(128),
                                              value varchar(1024),
                                              data_source_updated_datetime timestamptz,
                                              data_source_deleted_flag boolean
);

CREATE INDEX idx_org_node_type__data_source_updated_datetime ON history_octane.org_node_type (data_source_updated_datetime);

CREATE INDEX idx_org_node_type__data_source_deleted_flag ON history_octane.org_node_type (data_source_deleted_flag);

CREATE TABLE history_octane.org_node_lender_user_type (
                                                          code varchar(128),
                                                          value varchar(1024),
                                                          data_source_updated_datetime timestamptz,
                                                          data_source_deleted_flag boolean
);

CREATE INDEX idx_org_node_lender_user_type__data_source_updated_datetime ON history_octane.org_node_lender_user_type (data_source_updated_datetime);

CREATE INDEX idx_org_node_lender_user_type__data_source_deleted_flag ON history_octane.org_node_lender_user_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_book_type (
                                                 code varchar(128),
                                                 value varchar(1024),
                                                 data_source_updated_datetime timestamptz,
                                                 data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_book_type__data_source_updated_datetime ON history_octane.ledger_book_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_book_type__data_source_deleted_flag ON history_octane.ledger_book_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_book_status_type (
                                                        code varchar(128),
                                                        value varchar(1024),
                                                        data_source_updated_datetime timestamptz,
                                                        data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_book_status_type__data_source_updated_datetime ON history_octane.ledger_book_status_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_book_status_type__data_source_deleted_flag ON history_octane.ledger_book_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.loan_org_lineage_source_type (
                                                             code varchar(128),
                                                             value varchar(1024),
                                                             data_source_updated_datetime timestamptz,
                                                             data_source_deleted_flag boolean
);

CREATE INDEX idx_loan_org_lineage_source_type__data_source_updated_datetime ON history_octane.loan_org_lineage_source_type (data_source_updated_datetime);

CREATE INDEX idx_loan_org_lineage_source_type__data_source_deleted_flag ON history_octane.loan_org_lineage_source_type (data_source_deleted_flag);

ALTER TABLE history_octane.lock_series
    ADD COLUMN lsr_org_lineage_pid bigint;

CREATE INDEX fk_lock_series_2 ON history_octane.lock_series (lsr_org_lineage_pid);

ALTER TABLE history_octane.criteria_pid_operand
    ADD COLUMN crpo_org_node_pid bigint;

CREATE INDEX fk_criteria_pid_operand_24 ON history_octane.criteria_pid_operand (crpo_org_node_pid);

CREATE TABLE history_octane.ledger_entry_type (
                                                  code varchar(128),
                                                  value varchar(1024),
                                                  data_source_updated_datetime timestamptz,
                                                  data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_type__data_source_updated_datetime ON history_octane.ledger_entry_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_type__data_source_deleted_flag ON history_octane.ledger_entry_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_entry_source_type (
                                                         code varchar(128),
                                                         value varchar(1024),
                                                         data_source_updated_datetime timestamptz,
                                                         data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_source_type__data_source_updated_datetime ON history_octane.ledger_entry_source_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_source_type__data_source_deleted_flag ON history_octane.ledger_entry_source_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_entry_decision_status_type (
                                                                  code varchar(128),
                                                                  value varchar(1024),
                                                                  data_source_updated_datetime timestamptz,
                                                                  data_source_deleted_flag boolean
);

CREATE INDEX idx_3d9e96ccd54e9093244f074bdd4a13ca ON history_octane.ledger_entry_decision_status_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_decision_status_type__data_source_deleted_flag ON history_octane.ledger_entry_decision_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.smart_ledger_plan_case_type (
                                                            code varchar(128),
                                                            value varchar(1024),
                                                            data_source_updated_datetime timestamptz,
                                                            data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_ledger_plan_case_type__data_source_updated_datetime ON history_octane.smart_ledger_plan_case_type (data_source_updated_datetime);

CREATE INDEX idx_smart_ledger_plan_case_type__data_source_deleted_flag ON history_octane.smart_ledger_plan_case_type (data_source_deleted_flag);

CREATE TABLE history_octane.smart_ledger_plan_case_level_type (
                                                                  code varchar(128),
                                                                  value varchar(1024),
                                                                  data_source_updated_datetime timestamptz,
                                                                  data_source_deleted_flag boolean
);

CREATE INDEX idx_a34c005547324f8b20c957db1ad3c470 ON history_octane.smart_ledger_plan_case_level_type (data_source_updated_datetime);

CREATE INDEX idx_smart_ledger_plan_case_level_type__data_source_deleted_flag ON history_octane.smart_ledger_plan_case_level_type (data_source_deleted_flag);

CREATE TABLE history_octane.smart_ledger_pay_frequency_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                data_source_updated_datetime timestamptz,
                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_9a46752fc13b75a1353a74c27c86c0d2 ON history_octane.smart_ledger_pay_frequency_type (data_source_updated_datetime);

CREATE INDEX idx_smart_ledger_pay_frequency_type__data_source_deleted_flag ON history_octane.smart_ledger_pay_frequency_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_basis_points_input_type (
                                                               code varchar(128),
                                                               value varchar(1024),
                                                               data_source_updated_datetime timestamptz,
                                                               data_source_deleted_flag boolean
);

CREATE INDEX idx_71d0f333b990d74f533d8c4b6d9892a3 ON history_octane.ledger_basis_points_input_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_basis_points_input_type__data_source_deleted_flag ON history_octane.ledger_basis_points_input_type (data_source_deleted_flag);

CREATE TABLE history_octane.smart_ledger_plan_case_group_calculation_type (
                                                                              code varchar(128),
                                                                              value varchar(1024),
                                                                              data_source_updated_datetime timestamptz,
                                                                              data_source_deleted_flag boolean
);

CREATE INDEX idx_02662e83c74fe22ebcf1ecc06082f958 ON history_octane.smart_ledger_plan_case_group_calculation_type (data_source_updated_datetime);

CREATE INDEX idx_8e4429a53cae2c3208b0f52d65355501 ON history_octane.smart_ledger_plan_case_group_calculation_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_entry_review_status_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                data_source_updated_datetime timestamptz,
                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_27d9b17a99a0c2403ff9452b2d69d606 ON history_octane.ledger_entry_review_status_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_review_status_type__data_source_deleted_flag ON history_octane.ledger_entry_review_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_entry_review_reason_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                data_source_updated_datetime timestamptz,
                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_6d61308402d86b4d633d7973c1efe648 ON history_octane.ledger_entry_review_reason_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_review_reason_type__data_source_deleted_flag ON history_octane.ledger_entry_review_reason_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_entry_import_status_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                data_source_updated_datetime timestamptz,
                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_ecfc4e98ffd28a6326417fdef1c09fe1 ON history_octane.ledger_entry_import_status_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_import_status_type__data_source_deleted_flag ON history_octane.ledger_entry_import_status_type (data_source_deleted_flag);

ALTER TABLE history_octane.ledger_entry_type
    ADD COLUMN general_ledger_code varchar(8);

