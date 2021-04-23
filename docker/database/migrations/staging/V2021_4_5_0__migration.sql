--
-- EDW - Octane 4.4.3, 4.4.4, 4.4.6 changes (Org Admin) ( https://app.asana.com/0/0/1200221289923026 )
--

-- changes to staging_octane schema
DROP TABLE IF EXISTS staging_octane.org_team_leader;
DROP TABLE IF EXISTS staging_octane.org_unit_leader;
DROP TABLE IF EXISTS staging_octane.org_region_leader;
DROP TABLE IF EXISTS staging_octane.org_group_leader;
DROP TABLE IF EXISTS staging_octane.org_division_leader;
DROP TABLE IF EXISTS staging_octane.org_lender_user_terms;
DROP TABLE IF EXISTS staging_octane.org_team_terms;
DROP TABLE IF EXISTS staging_octane.org_unit_terms;
DROP TABLE IF EXISTS staging_octane.org_region_terms;
DROP TABLE IF EXISTS staging_octane.org_group_terms;
DROP TABLE IF EXISTS staging_octane.org_division_terms;
DROP TABLE IF EXISTS staging_octane.cost_center;
DROP TABLE IF EXISTS staging_octane.org_team;
DROP TABLE IF EXISTS staging_octane.org_unit;
DROP TABLE IF EXISTS staging_octane.org_region;
DROP TABLE IF EXISTS staging_octane.org_group;
DROP TABLE IF EXISTS staging_octane.org_division;
DROP TABLE IF EXISTS staging_octane.org_leader_position_type;


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

CREATE TABLE staging_octane.org_node_tree (
                                              ont_pid bigint,
                                              ont_version integer,
                                              constraint pk_org_node_tree primary key (ont_pid),
                                              ont_account_pid bigint
);

CREATE INDEX idx_org_node_tree__pid_version ON staging_octane.org_node_tree (ont_pid, ont_version);

CREATE TABLE staging_octane.org_node (
                                         on_pid bigint,
                                         on_version integer,
                                         constraint pk_org_node primary key (on_pid),
                                         on_account_pid bigint,
                                         on_org_node_tree_pid bigint,
                                         on_lender_user_pid bigint,
                                         on_org_node_id bigint,
                                         on_org_node_short_id varchar(8),
                                         on_org_node_name_latest varchar(256),
                                         on_org_node_type varchar(128),
                                         on_description varchar(16000),
                                         on_org_node_active bit
);

CREATE INDEX idx_org_node__pid_version ON staging_octane.org_node (on_pid, on_version);

CREATE TABLE staging_octane.org_node_lender_user (
                                                     onlu_pid bigint,
                                                     onlu_version integer,
                                                     constraint pk_org_node_lender_user primary key (onlu_pid),
                                                     onlu_org_node_pid bigint,
                                                     onlu_lender_user_pid bigint,
                                                     onlu_from_date date,
                                                     onlu_through_date date,
                                                     onlu_org_node_lender_user_type varchar(128)
);

CREATE INDEX idx_org_node_lender_user__pid_version ON staging_octane.org_node_lender_user (onlu_pid, onlu_version);

CREATE TABLE staging_octane.org_node_version (
                                                 onv_pid bigint,
                                                 onv_version integer,
                                                 constraint pk_org_node_version primary key (onv_pid),
                                                 onv_org_node_pid bigint,
                                                 onv_parent_org_node_pid bigint,
                                                 onv_from_date date,
                                                 onv_through_date date,
                                                 onv_org_node_name varchar(256)
);

CREATE INDEX idx_org_node_version__pid_version ON staging_octane.org_node_version (onv_pid, onv_version);

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

CREATE TABLE staging_octane.ledger_book (
                                            lbk_pid bigint,
                                            lbk_version integer,
                                            constraint pk_ledger_book primary key (lbk_pid),
                                            lbk_ledger_book_id varchar(16),
                                            lbk_account_pid bigint,
                                            lbk_ledger_book_type varchar(128),
                                            lbk_period_from_date date,
                                            lbk_period_through_date date,
                                            lbk_payroll_pay_date date,
                                            lbk_ledger_book_status_type varchar(128),
                                            lbk_closed_by_lender_user_pid bigint,
                                            lbk_closed_by_unparsed_name varchar(128),
                                            lbk_processed_by_lender_user_pid bigint,
                                            lbk_processed_by_unparsed_name varchar(128)
);

CREATE INDEX idx_ledger_book__pid_version ON staging_octane.ledger_book (lbk_pid, lbk_version);

CREATE TABLE staging_octane.org_lineage (
                                            ol_pid bigint,
                                            ol_version integer,
                                            constraint pk_org_lineage primary key (ol_pid),
                                            ol_lender_user_pid bigint,
                                            ol_org_lineage_pretty_text varchar(16000),
                                            ol_org_node_pid bigint
);

CREATE INDEX idx_org_lineage__pid_version ON staging_octane.org_lineage (ol_pid, ol_version);

CREATE TABLE staging_octane.org_lineage_node (
                                                 oln_pid bigint,
                                                 oln_version integer,
                                                 constraint pk_org_lineage_node primary key (oln_pid),
                                                 oln_org_lineage_pid bigint,
                                                 oln_org_node_pid bigint,
                                                 oln_org_node_ordinal integer
);

CREATE INDEX idx_org_lineage_node__pid_version ON staging_octane.org_lineage_node (oln_pid, oln_version);

CREATE TABLE staging_octane.loan_org_lineage_source_type (
                                                             code varchar(128),
                                                             value varchar(1024),
                                                             constraint pk_loan_org_lineage_source_type primary key (code)
);

CREATE TABLE staging_octane.loan_org_lineage (
                                                 lol_pid bigint,
                                                 lol_version integer,
                                                 constraint pk_loan_org_lineage primary key (lol_pid),
                                                 lol_loan_pid bigint,
                                                 lol_org_lineage_pid bigint,
                                                 lol_loan_org_lineage_source_type varchar(128),
                                                 lol_source_date date
);

CREATE INDEX idx_loan_org_lineage__pid_version ON staging_octane.loan_org_lineage (lol_pid, lol_version);

CREATE TABLE staging_octane.loan_org_lineage_update (
                                                        lolu_pid bigint,
                                                        lolu_version integer,
                                                        constraint pk_loan_org_lineage_update primary key (lolu_pid),
                                                        lolu_loan_pid bigint,
                                                        lolu_scheduled_date date,
                                                        lolu_try_count integer,
                                                        lolu_latest_exception_message varchar(16000)
);

CREATE INDEX idx_loan_org_lineage_update__pid_version ON staging_octane.loan_org_lineage_update (lolu_pid, lolu_version);

ALTER TABLE staging_octane.lock_series
    ADD COLUMN lsr_org_lineage_pid bigint;

ALTER TABLE staging_octane.criteria_pid_operand
    ADD COLUMN crpo_org_node_pid bigint;

CREATE TABLE staging_octane.org_lineage_tracker (
                                                    olt_pid bigint,
                                                    olt_version integer,
                                                    constraint pk_org_lineage_tracker primary key (olt_pid),
                                                    olt_org_node_pid bigint,
                                                    olt_org_lineage_pid bigint,
                                                    olt_from_date date,
                                                    olt_through_date date
);

CREATE INDEX idx_org_lineage_tracker__pid_version ON staging_octane.org_lineage_tracker (olt_pid, olt_version);

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

CREATE TABLE staging_octane.ledger_entry (
                                             le_pid bigint,
                                             le_version integer,
                                             constraint pk_ledger_entry primary key (le_pid),
                                             le_account_pid bigint,
                                             le_ledger_entry_type varchar(128),
                                             le_ledger_entry_source_type varchar(128),
                                             le_estimate bit,
                                             le_ledger_entry_decision_status_type varchar(128),
                                             le_create_datetime timestamp,
                                             le_entry_amount numeric(15,2),
                                             le_source_org_node_pid bigint,
                                             le_payee_org_node_pid bigint,
                                             le_payee_org_lineage_pid bigint,
                                             le_source_org_lineage_pid bigint,
                                             le_org_lineage_source_date date,
                                             le_deal_pid bigint,
                                             le_loan_position_type varchar(128),
                                             le_los_loan_id bigint,
                                             le_notes text,
                                             le_monthly_ledger_book_pid bigint,
                                             le_payroll_ledger_book_pid bigint,
                                             le_ledger_book_datetime timestamp,
                                             le_expense_date date,
                                             le_reversal bit,
                                             le_passthrough bit
);

CREATE INDEX idx_ledger_entry__pid_version ON staging_octane.ledger_entry (le_pid, le_version);

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

CREATE TABLE staging_octane.smart_ledger_plan (
                                                  slp_pid bigint,
                                                  slp_version integer,
                                                  constraint pk_smart_ledger_plan primary key (slp_pid),
                                                  slp_account_pid bigint,
                                                  slp_org_node_pid bigint,
                                                  slp_plan_name varchar(128),
                                                  slp_plan_id bigint
);

CREATE INDEX idx_smart_ledger_plan__pid_version ON staging_octane.smart_ledger_plan (slp_pid, slp_version);

CREATE TABLE staging_octane.smart_ledger_plan_case_group (
                                                             slpcg_pid bigint,
                                                             slpcg_version integer,
                                                             constraint pk_smart_ledger_plan_case_group primary key (slpcg_pid),
                                                             slpcg_account_pid bigint,
                                                             slpcg_smart_ledger_plan_pid bigint,
                                                             slpcg_group_name varchar(128),
                                                             slpcg_group_id bigint,
                                                             slpcg_payer_org_node_pid bigint,
                                                             slpcg_smart_ledger_plan_case_group_calculation_type varchar(128)
);

CREATE INDEX idx_smart_ledger_plan_case_group__pid_version ON staging_octane.smart_ledger_plan_case_group (slpcg_pid, slpcg_version);

CREATE TABLE staging_octane.smart_ledger_plan_case (
                                                       slpc_pid bigint,
                                                       slpc_version integer,
                                                       constraint pk_smart_ledger_plan_case primary key (slpc_pid),
                                                       slpc_account_pid bigint,
                                                       slpc_smart_ledger_plan_case_group_pid bigint,
                                                       slpc_case_id bigint
);

CREATE INDEX idx_smart_ledger_plan_case__pid_version ON staging_octane.smart_ledger_plan_case (slpc_pid, slpc_version);

CREATE TABLE staging_octane.smart_ledger_plan_case_version (
                                                               slpcv_pid bigint,
                                                               slpcv_version integer,
                                                               constraint pk_smart_ledger_plan_case_version primary key (slpcv_pid),
                                                               slpcv_account_pid bigint,
                                                               slpcv_smart_ledger_plan_case_pid bigint,
                                                               slpcv_payer_org_node_pid bigint,
                                                               slpcv_active bit,
                                                               slpcv_synthetic_unique bigint,
                                                               slpcv_case_name varchar(128),
                                                               slpcv_smart_ledger_plan_case_type varchar(128),
                                                               slpcv_smart_ledger_plan_case_level_type varchar(128),
                                                               slpcv_smart_ledger_pay_frequency_type varchar(128),
                                                               slpcv_from_date date,
                                                               slpcv_through_date date,
                                                               slpcv_base_amount numeric(15,2),
                                                               slpcv_basis_points integer,
                                                               slpcv_min_amount numeric(15,2),
                                                               slpcv_max_amount numeric(15,2),
                                                               slpcv_ledger_basis_points_input_type varchar(128),
                                                               slpcv_criteria_pid bigint
);

CREATE INDEX idx_smart_ledger_plan_case_version__pid_version ON staging_octane.smart_ledger_plan_case_version (slpcv_pid, slpcv_version);

ALTER TABLE staging_octane.ledger_entry
    ADD COLUMN le_smart_ledger_plan_case_version_pid bigint;

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

CREATE TABLE staging_octane.ledger_entry_review (
                                                    ler_pid bigint,
                                                    ler_version integer,
                                                    constraint pk_ledger_entry_review primary key (ler_pid),
                                                    ler_account_pid bigint,
                                                    ler_deal_pid bigint,
                                                    ler_org_node_pid bigint,
                                                    ler_ledger_entry_pid bigint,
                                                    ler_ledger_entry_review_reason_type varchar(128),
                                                    ler_ledger_entry_review_status_type varchar(128),
                                                    ler_request_by_lender_user_pid bigint,
                                                    ler_request_datetime timestamp,
                                                    ler_review_by_lender_user_pid bigint,
                                                    ler_review_datetime timestamp,
                                                    ler_ledger_entry_type varchar(128),
                                                    ler_entry_amount numeric(15,2),
                                                    ler_loan_position_type varchar(128)
);

CREATE INDEX idx_ledger_entry_review__pid_version ON staging_octane.ledger_entry_review (ler_pid, ler_version);

CREATE TABLE staging_octane.ledger_entry_review_note (
                                                         lern_pid bigint,
                                                         lern_version integer,
                                                         constraint pk_ledger_entry_review_note primary key (lern_pid),
                                                         lern_ledger_entry_review_pid bigint,
                                                         lern_create_datetime timestamp,
                                                         lern_content varchar(16000),
                                                         lern_author_lender_user_pid bigint,
                                                         lern_author_unparsed_name varchar(128)
);

CREATE INDEX idx_ledger_entry_review_note__pid_version ON staging_octane.ledger_entry_review_note (lern_pid, lern_version);

CREATE TABLE staging_octane.ledger_entry_review_note_comment (
                                                                 lerc_pid bigint,
                                                                 lerc_version integer,
                                                                 constraint pk_ledger_entry_review_note_comment primary key (lerc_pid),
                                                                 lerc_ledger_entry_review_note_pid bigint,
                                                                 lerc_create_datetime timestamp,
                                                                 lerc_content varchar(16000),
                                                                 lerc_author_lender_user_pid bigint,
                                                                 lerc_author_unparsed_name varchar(128)
);

CREATE INDEX idx_ledger_entry_review_note_comment__pid_version ON staging_octane.ledger_entry_review_note_comment (lerc_pid, lerc_version);

CREATE TABLE staging_octane.ledger_entry_review_note_monitor (
                                                                 lerm_pid bigint,
                                                                 lerm_version integer,
                                                                 constraint pk_ledger_entry_review_note_monitor primary key (lerm_pid),
                                                                 lerm_ledger_entry_review_note_pid bigint,
                                                                 lerm_lender_user_pid bigint
);

CREATE INDEX idx_ledger_entry_review_note_monitor__pid_version ON staging_octane.ledger_entry_review_note_monitor (lerm_pid, lerm_version);

CREATE TABLE staging_octane.ledger_entry_import_status_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                constraint pk_ledger_entry_import_status_type primary key (code)
);

CREATE TABLE staging_octane.ledger_entry_import_status (
                                                           leis_pid bigint,
                                                           leis_version integer,
                                                           constraint pk_ledger_entry_import_status primary key (leis_pid),
                                                           leis_account_pid bigint,
                                                           leis_batch_id varchar(128),
                                                           leis_batch_name varchar(128),
                                                           leis_requester_lender_user_pid bigint,
                                                           leis_submit_datetime timestamp,
                                                           leis_complete_datetime timestamp,
                                                           leis_entry_count integer,
                                                           leis_ledger_entry_import_status_type varchar(128),
                                                           leis_failure_info varchar(16000),
                                                           leis_raw_header_row varchar(16000)
);

CREATE INDEX idx_ledger_entry_import_status__pid_version ON staging_octane.ledger_entry_import_status (leis_pid, leis_version);

CREATE TABLE staging_octane.ledger_entry_import_loan_status (
                                                                leils_pid bigint,
                                                                leils_version integer,
                                                                constraint pk_ledger_entry_import_loan_status primary key (leils_pid),
                                                                leils_ledger_entry_import_status_pid bigint,
                                                                leils_ledger_entry_pid bigint,
                                                                leils_los_loan_id varchar(32),
                                                                leils_payee_unparsed_name varchar(128),
                                                                leils_entry_amount numeric(15,2),
                                                                leils_entry_description varchar(1024),
                                                                leils_start_datetime timestamp,
                                                                leils_complete_datetime timestamp,
                                                                leils_ledger_entry_import_status_type varchar(128),
                                                                leils_failure_info varchar(16000),
                                                                leils_raw_row varchar(16000)
);

CREATE INDEX idx_ledger_entry_import_loan_status__pid_version ON staging_octane.ledger_entry_import_loan_status (leils_pid, leils_version);

ALTER TABLE staging_octane.ledger_entry_type
    ADD COLUMN general_ledger_code varchar(8);

CREATE TABLE staging_octane.payroll_ledger_book_id_ticker (
                                                              plbit_pid bigint,
                                                              plbit_version integer,
                                                              constraint pk_payroll_ledger_book_id_ticker primary key (plbit_pid),
                                                              plbit_account_pid bigint,
                                                              plbit_year integer,
                                                              plbit_month integer,
                                                              plbit_period_id integer,
                                                              plbit_revision_id integer,
                                                              plbit_user_friendly_value varchar(16)
);

CREATE INDEX idx_payroll_ledger_book_id_ticker__pid_version ON staging_octane.payroll_ledger_book_id_ticker (plbit_pid, plbit_version);

CREATE TABLE staging_octane.mcr_error_status_type (
                                                      code varchar(128),
                                                      value varchar(1024),
                                                      constraint pk_mcr_error_status_type primary key (code)
);

CREATE TABLE staging_octane.mcr_status_type (
                                                code varchar(128),
                                                value varchar(1024),
                                                constraint pk_mcr_status_type primary key (code)
);

CREATE TABLE staging_octane.mcr_request (
                                            mcrr_pid bigint,
                                            mcrr_version integer,
                                            constraint pk_mcr_request primary key (mcrr_pid),
                                            mcrr_account_pid bigint,
                                            mcrr_create_datetime timestamp,
                                            mcrr_start_datetime timestamp,
                                            mcrr_end_datetime timestamp,
                                            mcrr_request_status_type varchar(128),
                                            mcrr_request_status_messages text,
                                            mcrr_mcr_error_status_type varchar(128),
                                            mcrr_mcr_status_type varchar(128),
                                            mcrr_requester_unparsed_name varchar(128),
                                            mcrr_year integer,
                                            mcrr_quarter_type varchar(128),
                                            mcrr_mcr_xml_file_pid bigint,
                                            mcrr_error_csv_file_pid bigint,
                                            mcrr_mcr_loan_data_csv_file_pid bigint,
                                            mcrr_csv_input_files_zip_pid bigint
);

CREATE INDEX idx_mcr_request__pid_version ON staging_octane.mcr_request (mcrr_pid, mcrr_version);

ALTER TABLE staging_octane.mcr_snapshot
    ADD COLUMN mcrs_mcr_request_pid bigint;

ALTER TABLE staging_octane.ledger_entry
    ALTER COLUMN le_org_lineage_source_date SET DATA TYPE date;


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

CREATE TABLE history_octane.org_node_tree (
                                              ont_pid bigint,
                                              ont_version integer,
                                              ont_account_pid bigint,
                                              data_source_updated_datetime timestamptz,
                                              data_source_deleted_flag boolean
);

CREATE INDEX idx_org_node_tree__pid ON history_octane.org_node_tree (ont_pid);

CREATE INDEX idx_org_node_tree__data_source_updated_datetime ON history_octane.org_node_tree (data_source_updated_datetime);

CREATE INDEX idx_org_node_tree__data_source_deleted_flag ON history_octane.org_node_tree (data_source_deleted_flag);

CREATE INDEX idx_org_node_tree__pid_version ON history_octane.org_node_tree (ont_pid, ont_version);

CREATE INDEX fk_org_node_tree_1 ON history_octane.org_node_tree (ont_account_pid);

CREATE TABLE history_octane.org_node (
                                         on_pid bigint,
                                         on_version integer,
                                         on_account_pid bigint,
                                         on_org_node_tree_pid bigint,
                                         on_lender_user_pid bigint,
                                         on_org_node_id bigint,
                                         on_org_node_short_id varchar(8),
                                         on_org_node_name_latest varchar(256),
                                         on_org_node_type varchar(128),
                                         on_description varchar(16000),
                                         on_org_node_active bit,
                                         data_source_updated_datetime timestamptz,
                                         data_source_deleted_flag boolean
);

CREATE INDEX idx_org_node__pid ON history_octane.org_node (on_pid);

CREATE INDEX idx_org_node__data_source_updated_datetime ON history_octane.org_node (data_source_updated_datetime);

CREATE INDEX idx_org_node__data_source_deleted_flag ON history_octane.org_node (data_source_deleted_flag);

CREATE INDEX idx_org_node__pid_version ON history_octane.org_node (on_pid, on_version);

CREATE INDEX fk_org_node_1 ON history_octane.org_node (on_account_pid);

CREATE INDEX fk_org_node_2 ON history_octane.org_node (on_org_node_tree_pid);

CREATE INDEX fk_org_node_3 ON history_octane.org_node (on_lender_user_pid);

CREATE INDEX fkt_on_org_node_type ON history_octane.org_node (on_org_node_type);

CREATE TABLE history_octane.org_node_lender_user (
                                                     onlu_pid bigint,
                                                     onlu_version integer,
                                                     onlu_org_node_pid bigint,
                                                     onlu_lender_user_pid bigint,
                                                     onlu_from_date date,
                                                     onlu_through_date date,
                                                     onlu_org_node_lender_user_type varchar(128),
                                                     data_source_updated_datetime timestamptz,
                                                     data_source_deleted_flag boolean
);

CREATE INDEX idx_org_node_lender_user__pid ON history_octane.org_node_lender_user (onlu_pid);

CREATE INDEX idx_org_node_lender_user__data_source_updated_datetime ON history_octane.org_node_lender_user (data_source_updated_datetime);

CREATE INDEX idx_org_node_lender_user__data_source_deleted_flag ON history_octane.org_node_lender_user (data_source_deleted_flag);

CREATE INDEX idx_org_node_lender_user__pid_version ON history_octane.org_node_lender_user (onlu_pid, onlu_version);

CREATE INDEX fk_org_node_lender_user_1 ON history_octane.org_node_lender_user (onlu_org_node_pid);

CREATE INDEX fk_org_node_lender_user_2 ON history_octane.org_node_lender_user (onlu_lender_user_pid);

CREATE INDEX fkt_onlu_org_node_lender_user_type ON history_octane.org_node_lender_user (onlu_org_node_lender_user_type);

CREATE TABLE history_octane.org_node_version (
                                                 onv_pid bigint,
                                                 onv_version integer,
                                                 onv_org_node_pid bigint,
                                                 onv_parent_org_node_pid bigint,
                                                 onv_from_date date,
                                                 onv_through_date date,
                                                 onv_org_node_name varchar(256),
                                                 data_source_updated_datetime timestamptz,
                                                 data_source_deleted_flag boolean
);

CREATE INDEX idx_org_node_version__pid ON history_octane.org_node_version (onv_pid);

CREATE INDEX idx_org_node_version__data_source_updated_datetime ON history_octane.org_node_version (data_source_updated_datetime);

CREATE INDEX idx_org_node_version__data_source_deleted_flag ON history_octane.org_node_version (data_source_deleted_flag);

CREATE INDEX idx_org_node_version__pid_version ON history_octane.org_node_version (onv_pid, onv_version);

CREATE INDEX fk_org_node_version_1 ON history_octane.org_node_version (onv_org_node_pid);

CREATE INDEX fk_org_node_version_2 ON history_octane.org_node_version (onv_parent_org_node_pid);

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

CREATE TABLE history_octane.ledger_book (
                                            lbk_pid bigint,
                                            lbk_version integer,
                                            lbk_ledger_book_id varchar(16),
                                            lbk_account_pid bigint,
                                            lbk_ledger_book_type varchar(128),
                                            lbk_period_from_date date,
                                            lbk_period_through_date date,
                                            lbk_payroll_pay_date date,
                                            lbk_ledger_book_status_type varchar(128),
                                            lbk_closed_by_lender_user_pid bigint,
                                            lbk_closed_by_unparsed_name varchar(128),
                                            lbk_processed_by_lender_user_pid bigint,
                                            lbk_processed_by_unparsed_name varchar(128),
                                            data_source_updated_datetime timestamptz,
                                            data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_book__pid ON history_octane.ledger_book (lbk_pid);

CREATE INDEX idx_ledger_book__data_source_updated_datetime ON history_octane.ledger_book (data_source_updated_datetime);

CREATE INDEX idx_ledger_book__data_source_deleted_flag ON history_octane.ledger_book (data_source_deleted_flag);

CREATE INDEX idx_ledger_book__pid_version ON history_octane.ledger_book (lbk_pid, lbk_version);

CREATE INDEX fk_ledger_book_1 ON history_octane.ledger_book (lbk_account_pid);

CREATE INDEX fkt_lbk_ledger_book_type ON history_octane.ledger_book (lbk_ledger_book_type);

CREATE INDEX fkt_lbk_ledger_book_status_type ON history_octane.ledger_book (lbk_ledger_book_status_type);

CREATE INDEX fk_ledger_book_2 ON history_octane.ledger_book (lbk_closed_by_lender_user_pid);

CREATE INDEX fk_ledger_book_3 ON history_octane.ledger_book (lbk_processed_by_lender_user_pid);

CREATE INDEX idx_ledger_book_1 ON history_octane.ledger_book (lbk_period_from_date);

CREATE INDEX idx_ledger_book_2 ON history_octane.ledger_book (lbk_period_through_date);

CREATE TABLE history_octane.org_lineage (
                                            ol_pid bigint,
                                            ol_version integer,
                                            ol_lender_user_pid bigint,
                                            ol_org_lineage_pretty_text varchar(16000),
                                            ol_org_node_pid bigint,
                                            data_source_updated_datetime timestamptz,
                                            data_source_deleted_flag boolean
);

CREATE INDEX idx_org_lineage__pid ON history_octane.org_lineage (ol_pid);

CREATE INDEX idx_org_lineage__data_source_updated_datetime ON history_octane.org_lineage (data_source_updated_datetime);

CREATE INDEX idx_org_lineage__data_source_deleted_flag ON history_octane.org_lineage (data_source_deleted_flag);

CREATE INDEX idx_org_lineage__pid_version ON history_octane.org_lineage (ol_pid, ol_version);

CREATE INDEX fk_org_lineage_1 ON history_octane.org_lineage (ol_lender_user_pid);

CREATE INDEX fk_org_lineage_2 ON history_octane.org_lineage (ol_org_node_pid);

CREATE TABLE history_octane.org_lineage_node (
                                                 oln_pid bigint,
                                                 oln_version integer,
                                                 oln_org_lineage_pid bigint,
                                                 oln_org_node_pid bigint,
                                                 oln_org_node_ordinal integer,
                                                 data_source_updated_datetime timestamptz,
                                                 data_source_deleted_flag boolean
);

CREATE INDEX idx_org_lineage_node__pid ON history_octane.org_lineage_node (oln_pid);

CREATE INDEX idx_org_lineage_node__data_source_updated_datetime ON history_octane.org_lineage_node (data_source_updated_datetime);

CREATE INDEX idx_org_lineage_node__data_source_deleted_flag ON history_octane.org_lineage_node (data_source_deleted_flag);

CREATE INDEX idx_org_lineage_node__pid_version ON history_octane.org_lineage_node (oln_pid, oln_version);

CREATE INDEX fk_org_lineage_node_1 ON history_octane.org_lineage_node (oln_org_lineage_pid);

CREATE INDEX fk_org_lineage_node_2 ON history_octane.org_lineage_node (oln_org_node_pid);

CREATE TABLE history_octane.loan_org_lineage_source_type (
                                                             code varchar(128),
                                                             value varchar(1024),
                                                             data_source_updated_datetime timestamptz,
                                                             data_source_deleted_flag boolean
);

CREATE INDEX idx_loan_org_lineage_source_type__data_source_updated_datetime ON history_octane.loan_org_lineage_source_type (data_source_updated_datetime);

CREATE INDEX idx_loan_org_lineage_source_type__data_source_deleted_flag ON history_octane.loan_org_lineage_source_type (data_source_deleted_flag);

CREATE TABLE history_octane.loan_org_lineage (
                                                 lol_pid bigint,
                                                 lol_version integer,
                                                 lol_loan_pid bigint,
                                                 lol_org_lineage_pid bigint,
                                                 lol_loan_org_lineage_source_type varchar(128),
                                                 lol_source_date date,
                                                 data_source_updated_datetime timestamptz,
                                                 data_source_deleted_flag boolean
);

CREATE INDEX idx_loan_org_lineage__pid ON history_octane.loan_org_lineage (lol_pid);

CREATE INDEX idx_loan_org_lineage__data_source_updated_datetime ON history_octane.loan_org_lineage (data_source_updated_datetime);

CREATE INDEX idx_loan_org_lineage__data_source_deleted_flag ON history_octane.loan_org_lineage (data_source_deleted_flag);

CREATE INDEX idx_loan_org_lineage__pid_version ON history_octane.loan_org_lineage (lol_pid, lol_version);

CREATE INDEX fk_loan_org_lineage_1 ON history_octane.loan_org_lineage (lol_loan_pid);

CREATE INDEX fk_loan_org_lineage_2 ON history_octane.loan_org_lineage (lol_org_lineage_pid);

CREATE INDEX fkt_lol_loan_org_lineage_source_type ON history_octane.loan_org_lineage (lol_loan_org_lineage_source_type);

CREATE TABLE history_octane.loan_org_lineage_update (
                                                        lolu_pid bigint,
                                                        lolu_version integer,
                                                        lolu_loan_pid bigint,
                                                        lolu_scheduled_date date,
                                                        lolu_try_count integer,
                                                        lolu_latest_exception_message varchar(16000),
                                                        data_source_updated_datetime timestamptz,
                                                        data_source_deleted_flag boolean
);

CREATE INDEX idx_loan_org_lineage_update__pid ON history_octane.loan_org_lineage_update (lolu_pid);

CREATE INDEX idx_loan_org_lineage_update__data_source_updated_datetime ON history_octane.loan_org_lineage_update (data_source_updated_datetime);

CREATE INDEX idx_loan_org_lineage_update__data_source_deleted_flag ON history_octane.loan_org_lineage_update (data_source_deleted_flag);

CREATE INDEX idx_loan_org_lineage_update__pid_version ON history_octane.loan_org_lineage_update (lolu_pid, lolu_version);

CREATE INDEX fk_loan_org_lineage_update_1 ON history_octane.loan_org_lineage_update (lolu_loan_pid);

ALTER TABLE history_octane.lock_series
    ADD COLUMN lsr_org_lineage_pid bigint;

CREATE INDEX fk_lock_series_2 ON history_octane.lock_series (lsr_org_lineage_pid);

ALTER TABLE history_octane.criteria_pid_operand
    ADD COLUMN crpo_org_node_pid bigint;

CREATE INDEX fk_criteria_pid_operand_24 ON history_octane.criteria_pid_operand (crpo_org_node_pid);

CREATE TABLE history_octane.org_lineage_tracker (
                                                    olt_pid bigint,
                                                    olt_version integer,
                                                    olt_org_node_pid bigint,
                                                    olt_org_lineage_pid bigint,
                                                    olt_from_date date,
                                                    olt_through_date date,
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_org_lineage_tracker__pid ON history_octane.org_lineage_tracker (olt_pid);

CREATE INDEX idx_org_lineage_tracker__data_source_updated_datetime ON history_octane.org_lineage_tracker (data_source_updated_datetime);

CREATE INDEX idx_org_lineage_tracker__data_source_deleted_flag ON history_octane.org_lineage_tracker (data_source_deleted_flag);

CREATE INDEX idx_org_lineage_tracker__pid_version ON history_octane.org_lineage_tracker (olt_pid, olt_version);

CREATE INDEX fk_org_lineage_tracker_1 ON history_octane.org_lineage_tracker (olt_org_node_pid);

CREATE INDEX fk_org_lineage_tracker_2 ON history_octane.org_lineage_tracker (olt_org_lineage_pid);

CREATE INDEX idx_org_lineage_tracker_1 ON history_octane.org_lineage_tracker (olt_through_date);

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

CREATE TABLE history_octane.ledger_entry (
                                             le_pid bigint,
                                             le_version integer,
                                             le_account_pid bigint,
                                             le_ledger_entry_type varchar(128),
                                             le_ledger_entry_source_type varchar(128),
                                             le_estimate bit,
                                             le_ledger_entry_decision_status_type varchar(128),
                                             le_create_datetime timestamp,
                                             le_entry_amount numeric(15,2),
                                             le_source_org_node_pid bigint,
                                             le_payee_org_node_pid bigint,
                                             le_payee_org_lineage_pid bigint,
                                             le_source_org_lineage_pid bigint,
                                             le_org_lineage_source_date date,
                                             le_deal_pid bigint,
                                             le_loan_position_type varchar(128),
                                             le_los_loan_id bigint,
                                             le_notes text,
                                             le_monthly_ledger_book_pid bigint,
                                             le_payroll_ledger_book_pid bigint,
                                             le_ledger_book_datetime timestamp,
                                             le_expense_date date,
                                             le_reversal bit,
                                             le_passthrough bit,
                                             data_source_updated_datetime timestamptz,
                                             data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry__pid ON history_octane.ledger_entry (le_pid);

CREATE INDEX idx_ledger_entry__data_source_updated_datetime ON history_octane.ledger_entry (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry__data_source_deleted_flag ON history_octane.ledger_entry (data_source_deleted_flag);

CREATE INDEX idx_ledger_entry__pid_version ON history_octane.ledger_entry (le_pid, le_version);

CREATE INDEX fk_ledger_entry_1 ON history_octane.ledger_entry (le_account_pid);

CREATE INDEX fk_ledger_entry_2 ON history_octane.ledger_entry (le_source_org_node_pid);

CREATE INDEX fk_ledger_entry_3 ON history_octane.ledger_entry (le_payee_org_node_pid);

CREATE INDEX fk_ledger_entry_4 ON history_octane.ledger_entry (le_deal_pid);

CREATE INDEX fk_ledger_entry_5 ON history_octane.ledger_entry (le_monthly_ledger_book_pid);

CREATE INDEX fk_ledger_entry_6 ON history_octane.ledger_entry (le_payroll_ledger_book_pid);

CREATE INDEX fk_ledger_entry_7 ON history_octane.ledger_entry (le_payee_org_lineage_pid);

CREATE INDEX fk_ledger_entry_8 ON history_octane.ledger_entry (le_source_org_lineage_pid);

CREATE INDEX fkt_le_ledger_entry_type ON history_octane.ledger_entry (le_ledger_entry_type);

CREATE INDEX fkt_le_ledger_entry_source_type ON history_octane.ledger_entry (le_ledger_entry_source_type);

CREATE INDEX fkt_le_ledger_entry_decision_status_type ON history_octane.ledger_entry (le_ledger_entry_decision_status_type);

CREATE INDEX fkt_le_loan_position_type ON history_octane.ledger_entry (le_loan_position_type);

CREATE INDEX idx_ledger_entry_1 ON history_octane.ledger_entry (le_los_loan_id);

CREATE INDEX idx_ledger_entry_2 ON history_octane.ledger_entry (le_expense_date);

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

CREATE TABLE history_octane.smart_ledger_plan (
                                                  slp_pid bigint,
                                                  slp_version integer,
                                                  slp_account_pid bigint,
                                                  slp_org_node_pid bigint,
                                                  slp_plan_name varchar(128),
                                                  slp_plan_id bigint,
                                                  data_source_updated_datetime timestamptz,
                                                  data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_ledger_plan__pid ON history_octane.smart_ledger_plan (slp_pid);

CREATE INDEX idx_smart_ledger_plan__data_source_updated_datetime ON history_octane.smart_ledger_plan (data_source_updated_datetime);

CREATE INDEX idx_smart_ledger_plan__data_source_deleted_flag ON history_octane.smart_ledger_plan (data_source_deleted_flag);

CREATE INDEX idx_smart_ledger_plan__pid_version ON history_octane.smart_ledger_plan (slp_pid, slp_version);

CREATE INDEX fk_smart_ledger_plan_1 ON history_octane.smart_ledger_plan (slp_account_pid);

CREATE INDEX fk_smart_ledger_plan_2 ON history_octane.smart_ledger_plan (slp_org_node_pid);

CREATE TABLE history_octane.smart_ledger_plan_case_group (
                                                             slpcg_pid bigint,
                                                             slpcg_version integer,
                                                             slpcg_account_pid bigint,
                                                             slpcg_smart_ledger_plan_pid bigint,
                                                             slpcg_group_name varchar(128),
                                                             slpcg_group_id bigint,
                                                             slpcg_payer_org_node_pid bigint,
                                                             slpcg_smart_ledger_plan_case_group_calculation_type varchar(128),
                                                             data_source_updated_datetime timestamptz,
                                                             data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_ledger_plan_case_group__pid ON history_octane.smart_ledger_plan_case_group (slpcg_pid);

CREATE INDEX idx_smart_ledger_plan_case_group__data_source_updated_datetime ON history_octane.smart_ledger_plan_case_group (data_source_updated_datetime);

CREATE INDEX idx_smart_ledger_plan_case_group__data_source_deleted_flag ON history_octane.smart_ledger_plan_case_group (data_source_deleted_flag);

CREATE INDEX idx_smart_ledger_plan_case_group__pid_version ON history_octane.smart_ledger_plan_case_group (slpcg_pid, slpcg_version);

CREATE INDEX fk_smart_ledger_plan_case_group_1 ON history_octane.smart_ledger_plan_case_group (slpcg_account_pid);

CREATE INDEX fk_smart_ledger_plan_case_group_2 ON history_octane.smart_ledger_plan_case_group (slpcg_smart_ledger_plan_pid);

CREATE INDEX fk_smart_ledger_plan_case_group_3 ON history_octane.smart_ledger_plan_case_group (slpcg_payer_org_node_pid);

CREATE INDEX fkt_slpcg_smart_ledger_plan_case_group_calculation_type ON history_octane.smart_ledger_plan_case_group (slpcg_smart_ledger_plan_case_group_calculation_type);

CREATE TABLE history_octane.smart_ledger_plan_case (
                                                       slpc_pid bigint,
                                                       slpc_version integer,
                                                       slpc_account_pid bigint,
                                                       slpc_smart_ledger_plan_case_group_pid bigint,
                                                       slpc_case_id bigint,
                                                       data_source_updated_datetime timestamptz,
                                                       data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_ledger_plan_case__pid ON history_octane.smart_ledger_plan_case (slpc_pid);

CREATE INDEX idx_smart_ledger_plan_case__data_source_updated_datetime ON history_octane.smart_ledger_plan_case (data_source_updated_datetime);

CREATE INDEX idx_smart_ledger_plan_case__data_source_deleted_flag ON history_octane.smart_ledger_plan_case (data_source_deleted_flag);

CREATE INDEX idx_smart_ledger_plan_case__pid_version ON history_octane.smart_ledger_plan_case (slpc_pid, slpc_version);

CREATE INDEX fk_smart_ledger_plan_case_1 ON history_octane.smart_ledger_plan_case (slpc_account_pid);

CREATE INDEX fk_smart_ledger_plan_case_2 ON history_octane.smart_ledger_plan_case (slpc_smart_ledger_plan_case_group_pid);

CREATE TABLE history_octane.smart_ledger_plan_case_version (
                                                               slpcv_pid bigint,
                                                               slpcv_version integer,
                                                               slpcv_account_pid bigint,
                                                               slpcv_smart_ledger_plan_case_pid bigint,
                                                               slpcv_payer_org_node_pid bigint,
                                                               slpcv_active bit,
                                                               slpcv_synthetic_unique bigint,
                                                               slpcv_case_name varchar(128),
                                                               slpcv_smart_ledger_plan_case_type varchar(128),
                                                               slpcv_smart_ledger_plan_case_level_type varchar(128),
                                                               slpcv_smart_ledger_pay_frequency_type varchar(128),
                                                               slpcv_from_date date,
                                                               slpcv_through_date date,
                                                               slpcv_base_amount numeric(15,2),
                                                               slpcv_basis_points integer,
                                                               slpcv_min_amount numeric(15,2),
                                                               slpcv_max_amount numeric(15,2),
                                                               slpcv_ledger_basis_points_input_type varchar(128),
                                                               slpcv_criteria_pid bigint,
                                                               data_source_updated_datetime timestamptz,
                                                               data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_ledger_plan_case_version__pid ON history_octane.smart_ledger_plan_case_version (slpcv_pid);

CREATE INDEX idx_951450892b51c83b1f0c3254d5593a50 ON history_octane.smart_ledger_plan_case_version (data_source_updated_datetime);

CREATE INDEX idx_smart_ledger_plan_case_version__data_source_deleted_flag ON history_octane.smart_ledger_plan_case_version (data_source_deleted_flag);

CREATE INDEX idx_smart_ledger_plan_case_version__pid_version ON history_octane.smart_ledger_plan_case_version (slpcv_pid, slpcv_version);

CREATE INDEX fk_smart_ledger_plan_case_version_1 ON history_octane.smart_ledger_plan_case_version (slpcv_account_pid);

CREATE INDEX fk_smart_ledger_plan_case_version_2 ON history_octane.smart_ledger_plan_case_version (slpcv_smart_ledger_plan_case_pid);

CREATE INDEX fk_smart_ledger_plan_case_version_3 ON history_octane.smart_ledger_plan_case_version (slpcv_payer_org_node_pid);

CREATE INDEX fk_smart_ledger_plan_case_version_4 ON history_octane.smart_ledger_plan_case_version (slpcv_criteria_pid);

CREATE INDEX fkt_slpcv_smart_ledger_plan_case_type ON history_octane.smart_ledger_plan_case_version (slpcv_smart_ledger_plan_case_type);

CREATE INDEX fkt_slpcv_smart_ledger_plan_case_level_type ON history_octane.smart_ledger_plan_case_version (slpcv_smart_ledger_plan_case_level_type);

CREATE INDEX fkt_slpcv_smart_ledger_pay_frequency_type ON history_octane.smart_ledger_plan_case_version (slpcv_smart_ledger_pay_frequency_type);

CREATE INDEX fkt_slpcv_ledger_basis_points_input_type ON history_octane.smart_ledger_plan_case_version (slpcv_ledger_basis_points_input_type);

CREATE INDEX idx_smart_ledger_plan_case_version_1 ON history_octane.smart_ledger_plan_case_version (slpcv_from_date);

CREATE INDEX idx_smart_ledger_plan_case_version_2 ON history_octane.smart_ledger_plan_case_version (slpcv_through_date);

ALTER TABLE history_octane.ledger_entry
    ADD COLUMN le_smart_ledger_plan_case_version_pid bigint;

CREATE INDEX fk_ledger_entry_9 ON history_octane.ledger_entry (le_smart_ledger_plan_case_version_pid);

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

CREATE TABLE history_octane.ledger_entry_review (
                                                    ler_pid bigint,
                                                    ler_version integer,
                                                    ler_account_pid bigint,
                                                    ler_deal_pid bigint,
                                                    ler_org_node_pid bigint,
                                                    ler_ledger_entry_pid bigint,
                                                    ler_ledger_entry_review_reason_type varchar(128),
                                                    ler_ledger_entry_review_status_type varchar(128),
                                                    ler_request_by_lender_user_pid bigint,
                                                    ler_request_datetime timestamp,
                                                    ler_review_by_lender_user_pid bigint,
                                                    ler_review_datetime timestamp,
                                                    ler_ledger_entry_type varchar(128),
                                                    ler_entry_amount numeric(15,2),
                                                    ler_loan_position_type varchar(128),
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_review__pid ON history_octane.ledger_entry_review (ler_pid);

CREATE INDEX idx_ledger_entry_review__data_source_updated_datetime ON history_octane.ledger_entry_review (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_review__data_source_deleted_flag ON history_octane.ledger_entry_review (data_source_deleted_flag);

CREATE INDEX idx_ledger_entry_review__pid_version ON history_octane.ledger_entry_review (ler_pid, ler_version);

CREATE INDEX fk_ledger_entry_review_1 ON history_octane.ledger_entry_review (ler_account_pid);

CREATE INDEX fk_ledger_entry_review_2 ON history_octane.ledger_entry_review (ler_deal_pid);

CREATE INDEX fk_ledger_entry_review_3 ON history_octane.ledger_entry_review (ler_org_node_pid);

CREATE INDEX fk_ledger_entry_review_4 ON history_octane.ledger_entry_review (ler_ledger_entry_pid);

CREATE INDEX fk_ledger_entry_review_5 ON history_octane.ledger_entry_review (ler_request_by_lender_user_pid);

CREATE INDEX fk_ledger_entry_review_6 ON history_octane.ledger_entry_review (ler_review_by_lender_user_pid);

CREATE INDEX fkt_ler_ledger_entry_review_reason_type ON history_octane.ledger_entry_review (ler_ledger_entry_review_reason_type);

CREATE INDEX fkt_ler_ledger_entry_review_status_type ON history_octane.ledger_entry_review (ler_ledger_entry_review_status_type);

CREATE INDEX fkt_ler_ledger_entry_type ON history_octane.ledger_entry_review (ler_ledger_entry_type);

CREATE INDEX fkt_ler_loan_position_type ON history_octane.ledger_entry_review (ler_loan_position_type);

CREATE TABLE history_octane.ledger_entry_review_note (
                                                         lern_pid bigint,
                                                         lern_version integer,
                                                         lern_ledger_entry_review_pid bigint,
                                                         lern_create_datetime timestamp,
                                                         lern_content varchar(16000),
                                                         lern_author_lender_user_pid bigint,
                                                         lern_author_unparsed_name varchar(128),
                                                         data_source_updated_datetime timestamptz,
                                                         data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_review_note__pid ON history_octane.ledger_entry_review_note (lern_pid);

CREATE INDEX idx_ledger_entry_review_note__data_source_updated_datetime ON history_octane.ledger_entry_review_note (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_review_note__data_source_deleted_flag ON history_octane.ledger_entry_review_note (data_source_deleted_flag);

CREATE INDEX idx_ledger_entry_review_note__pid_version ON history_octane.ledger_entry_review_note (lern_pid, lern_version);

CREATE INDEX fk_ledger_entry_review_note_1 ON history_octane.ledger_entry_review_note (lern_ledger_entry_review_pid);

CREATE INDEX fk_ledger_entry_review_note_2 ON history_octane.ledger_entry_review_note (lern_author_lender_user_pid);

CREATE TABLE history_octane.ledger_entry_review_note_comment (
                                                                 lerc_pid bigint,
                                                                 lerc_version integer,
                                                                 lerc_ledger_entry_review_note_pid bigint,
                                                                 lerc_create_datetime timestamp,
                                                                 lerc_content varchar(16000),
                                                                 lerc_author_lender_user_pid bigint,
                                                                 lerc_author_unparsed_name varchar(128),
                                                                 data_source_updated_datetime timestamptz,
                                                                 data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_review_note_comment__pid ON history_octane.ledger_entry_review_note_comment (lerc_pid);

CREATE INDEX idx_f0c9d2f5b59733b0123d31f9dcdf36e7 ON history_octane.ledger_entry_review_note_comment (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_review_note_comment__data_source_deleted_flag ON history_octane.ledger_entry_review_note_comment (data_source_deleted_flag);

CREATE INDEX idx_ledger_entry_review_note_comment__pid_version ON history_octane.ledger_entry_review_note_comment (lerc_pid, lerc_version);

CREATE INDEX fk_ledger_entry_review_note_comment_1 ON history_octane.ledger_entry_review_note_comment (lerc_ledger_entry_review_note_pid);

CREATE INDEX fk_ledger_entry_review_note_comment_2 ON history_octane.ledger_entry_review_note_comment (lerc_author_lender_user_pid);

CREATE TABLE history_octane.ledger_entry_review_note_monitor (
                                                                 lerm_pid bigint,
                                                                 lerm_version integer,
                                                                 lerm_ledger_entry_review_note_pid bigint,
                                                                 lerm_lender_user_pid bigint,
                                                                 data_source_updated_datetime timestamptz,
                                                                 data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_review_note_monitor__pid ON history_octane.ledger_entry_review_note_monitor (lerm_pid);

CREATE INDEX idx_be5ae612199a1a8f8d08138db0066475 ON history_octane.ledger_entry_review_note_monitor (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_review_note_monitor__data_source_deleted_flag ON history_octane.ledger_entry_review_note_monitor (data_source_deleted_flag);

CREATE INDEX idx_ledger_entry_review_note_monitor__pid_version ON history_octane.ledger_entry_review_note_monitor (lerm_pid, lerm_version);

CREATE INDEX fk_ledger_entry_review_note_monitor_1 ON history_octane.ledger_entry_review_note_monitor (lerm_ledger_entry_review_note_pid);

CREATE INDEX fk_ledger_entry_review_note_monitor_2 ON history_octane.ledger_entry_review_note_monitor (lerm_lender_user_pid);

CREATE TABLE history_octane.ledger_entry_import_status_type (
                                                                code varchar(128),
                                                                value varchar(1024),
                                                                data_source_updated_datetime timestamptz,
                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_ecfc4e98ffd28a6326417fdef1c09fe1 ON history_octane.ledger_entry_import_status_type (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_import_status_type__data_source_deleted_flag ON history_octane.ledger_entry_import_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.ledger_entry_import_status (
                                                           leis_pid bigint,
                                                           leis_version integer,
                                                           leis_account_pid bigint,
                                                           leis_batch_id varchar(128),
                                                           leis_batch_name varchar(128),
                                                           leis_requester_lender_user_pid bigint,
                                                           leis_submit_datetime timestamp,
                                                           leis_complete_datetime timestamp,
                                                           leis_entry_count integer,
                                                           leis_ledger_entry_import_status_type varchar(128),
                                                           leis_failure_info varchar(16000),
                                                           leis_raw_header_row varchar(16000),
                                                           data_source_updated_datetime timestamptz,
                                                           data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_import_status__pid ON history_octane.ledger_entry_import_status (leis_pid);

CREATE INDEX idx_ledger_entry_import_status__data_source_updated_datetime ON history_octane.ledger_entry_import_status (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_import_status__data_source_deleted_flag ON history_octane.ledger_entry_import_status (data_source_deleted_flag);

CREATE INDEX idx_ledger_entry_import_status__pid_version ON history_octane.ledger_entry_import_status (leis_pid, leis_version);

CREATE INDEX fk_ledger_entry_import_status_1 ON history_octane.ledger_entry_import_status (leis_account_pid);

CREATE INDEX fk_ledger_entry_import_status_2 ON history_octane.ledger_entry_import_status (leis_requester_lender_user_pid);

CREATE INDEX fkt_leis_ledger_entry_import_status_type ON history_octane.ledger_entry_import_status (leis_ledger_entry_import_status_type);

CREATE TABLE history_octane.ledger_entry_import_loan_status (
                                                                leils_pid bigint,
                                                                leils_version integer,
                                                                leils_ledger_entry_import_status_pid bigint,
                                                                leils_ledger_entry_pid bigint,
                                                                leils_los_loan_id varchar(32),
                                                                leils_payee_unparsed_name varchar(128),
                                                                leils_entry_amount numeric(15,2),
                                                                leils_entry_description varchar(1024),
                                                                leils_start_datetime timestamp,
                                                                leils_complete_datetime timestamp,
                                                                leils_ledger_entry_import_status_type varchar(128),
                                                                leils_failure_info varchar(16000),
                                                                leils_raw_row varchar(16000),
                                                                data_source_updated_datetime timestamptz,
                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_ledger_entry_import_loan_status__pid ON history_octane.ledger_entry_import_loan_status (leils_pid);

CREATE INDEX idx_e1c9b9f41c9f76cb0e26d8138c1d6a71 ON history_octane.ledger_entry_import_loan_status (data_source_updated_datetime);

CREATE INDEX idx_ledger_entry_import_loan_status__data_source_deleted_flag ON history_octane.ledger_entry_import_loan_status (data_source_deleted_flag);

CREATE INDEX idx_ledger_entry_import_loan_status__pid_version ON history_octane.ledger_entry_import_loan_status (leils_pid, leils_version);

CREATE INDEX fk_ledger_entry_import_loan_status_1 ON history_octane.ledger_entry_import_loan_status (leils_ledger_entry_import_status_pid);

CREATE INDEX fk_ledger_entry_import_loan_status_2 ON history_octane.ledger_entry_import_loan_status (leils_ledger_entry_pid);

CREATE INDEX fkt_leils_ledger_entry_import_status_type ON history_octane.ledger_entry_import_loan_status (leils_ledger_entry_import_status_type);

ALTER TABLE history_octane.ledger_entry_type
    ADD COLUMN general_ledger_code varchar(8);

CREATE TABLE history_octane.payroll_ledger_book_id_ticker (
                                                              plbit_pid bigint,
                                                              plbit_version integer,
                                                              plbit_account_pid bigint,
                                                              plbit_year integer,
                                                              plbit_month integer,
                                                              plbit_period_id integer,
                                                              plbit_revision_id integer,
                                                              plbit_user_friendly_value varchar(16),
                                                              data_source_updated_datetime timestamptz,
                                                              data_source_deleted_flag boolean
);

CREATE INDEX idx_payroll_ledger_book_id_ticker__pid ON history_octane.payroll_ledger_book_id_ticker (plbit_pid);

CREATE INDEX idx_payroll_ledger_book_id_ticker__data_source_updated_datetime ON history_octane.payroll_ledger_book_id_ticker (data_source_updated_datetime);

CREATE INDEX idx_payroll_ledger_book_id_ticker__data_source_deleted_flag ON history_octane.payroll_ledger_book_id_ticker (data_source_deleted_flag);

CREATE INDEX idx_payroll_ledger_book_id_ticker__pid_version ON history_octane.payroll_ledger_book_id_ticker (plbit_pid, plbit_version);

CREATE INDEX fk_payroll_ledger_book_id_ticker_1 ON history_octane.payroll_ledger_book_id_ticker (plbit_account_pid);

CREATE TABLE history_octane.mcr_error_status_type (
                                                      code varchar(128),
                                                      value varchar(1024),
                                                      data_source_updated_datetime timestamptz,
                                                      data_source_deleted_flag boolean
);

CREATE INDEX idx_mcr_error_status_type__data_source_updated_datetime ON history_octane.mcr_error_status_type (data_source_updated_datetime);

CREATE INDEX idx_mcr_error_status_type__data_source_deleted_flag ON history_octane.mcr_error_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.mcr_status_type (
                                                code varchar(128),
                                                value varchar(1024),
                                                data_source_updated_datetime timestamptz,
                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_mcr_status_type__data_source_updated_datetime ON history_octane.mcr_status_type (data_source_updated_datetime);

CREATE INDEX idx_mcr_status_type__data_source_deleted_flag ON history_octane.mcr_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.mcr_request (
                                            mcrr_pid bigint,
                                            mcrr_version integer,
                                            mcrr_account_pid bigint,
                                            mcrr_create_datetime timestamp,
                                            mcrr_start_datetime timestamp,
                                            mcrr_end_datetime timestamp,
                                            mcrr_request_status_type varchar(128),
                                            mcrr_request_status_messages text,
                                            mcrr_mcr_error_status_type varchar(128),
                                            mcrr_mcr_status_type varchar(128),
                                            mcrr_requester_unparsed_name varchar(128),
                                            mcrr_year integer,
                                            mcrr_quarter_type varchar(128),
                                            mcrr_mcr_xml_file_pid bigint,
                                            mcrr_error_csv_file_pid bigint,
                                            mcrr_mcr_loan_data_csv_file_pid bigint,
                                            mcrr_csv_input_files_zip_pid bigint,
                                            data_source_updated_datetime timestamptz,
                                            data_source_deleted_flag boolean
);

CREATE INDEX idx_mcr_request__pid ON history_octane.mcr_request (mcrr_pid);

CREATE INDEX idx_mcr_request__data_source_updated_datetime ON history_octane.mcr_request (data_source_updated_datetime);

CREATE INDEX idx_mcr_request__data_source_deleted_flag ON history_octane.mcr_request (data_source_deleted_flag);

CREATE INDEX idx_mcr_request__pid_version ON history_octane.mcr_request (mcrr_pid, mcrr_version);

CREATE INDEX fk_mcr_request_1 ON history_octane.mcr_request (mcrr_account_pid);

CREATE INDEX fkt_mcrr_request_status_type ON history_octane.mcr_request (mcrr_request_status_type);

CREATE INDEX fkt_mcrr_mcr_error_status_type ON history_octane.mcr_request (mcrr_mcr_error_status_type);

CREATE INDEX fkt_mcrr_mcr_status_type ON history_octane.mcr_request (mcrr_mcr_status_type);

CREATE INDEX fkt_mcrr_quarter_type ON history_octane.mcr_request (mcrr_quarter_type);

ALTER TABLE history_octane.mcr_snapshot
    ADD COLUMN mcrs_mcr_request_pid bigint;

CREATE INDEX fk_mcr_snapshot_2 ON history_octane.mcr_snapshot (mcrs_mcr_request_pid);

ALTER TABLE history_octane.ledger_entry
    ALTER COLUMN le_org_lineage_source_date SET DATA TYPE date;
