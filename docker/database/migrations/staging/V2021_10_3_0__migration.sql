--
-- Main | EDW - Octane schemas from prod-release to v2021.10.4.2 on uat
-- https://app.asana.com/0/0/1201270648418743
--

-- staging_octane changes
ALTER TABLE staging_octane.loan_hedge
    ADD COLUMN lh_charges_enabled_date date,
    ADD COLUMN lh_application_date date;

ALTER TABLE staging_octane.deal_key_roles
    ADD COLUMN dkrs_review_requester_1_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_1_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_2_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_2_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_3_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_3_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_4_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_4_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_5_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_5_fmls varchar(128);

ALTER TABLE staging_octane.proposal_doc
    ADD COLUMN prpd_proposal_review_pid bigint;

ALTER TABLE staging_octane.proposal_req
    ADD COLUMN prpr_proposal_review_pid bigint;


-- history_octane changes
ALTER TABLE history_octane.loan_hedge
    ADD COLUMN lh_charges_enabled_date date,
    ADD COLUMN lh_application_date date;

ALTER TABLE history_octane.deal_key_roles
    ADD COLUMN dkrs_review_requester_1_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_1_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_2_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_2_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_3_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_3_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_4_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_4_fmls varchar(128),
    ADD COLUMN dkrs_review_requester_5_lender_user_pid bigint,
    ADD COLUMN dkrs_review_requester_5_fmls varchar(128);

CREATE INDEX fk_deal_key_roles_36 ON history_octane.deal_key_roles (dkrs_review_requester_1_lender_user_pid);

CREATE INDEX fk_deal_key_roles_37 ON history_octane.deal_key_roles (dkrs_review_requester_2_lender_user_pid);

CREATE INDEX fk_deal_key_roles_38 ON history_octane.deal_key_roles (dkrs_review_requester_3_lender_user_pid);

CREATE INDEX fk_deal_key_roles_39 ON history_octane.deal_key_roles (dkrs_review_requester_4_lender_user_pid);

CREATE INDEX fk_deal_key_roles_40 ON history_octane.deal_key_roles (dkrs_review_requester_5_lender_user_pid);

ALTER TABLE history_octane.proposal_doc
    ADD COLUMN prpd_proposal_review_pid bigint;

CREATE INDEX fk_proposal_doc_29 ON history_octane.proposal_doc (prpd_proposal_review_pid);

ALTER TABLE history_octane.proposal_req
    ADD COLUMN prpr_proposal_review_pid bigint;

CREATE INDEX fk_proposal_req_29 ON history_octane.proposal_req (prpr_proposal_review_pid);

--
-- EDW | Remove redundant org admin hierarchy tables from history octane
-- https://app.asana.com/0/0/1201235415555624
--

DROP TABLE history_octane.org_division;
DROP TABLE history_octane.org_division_leader;
DROP TABLE history_octane.org_division_terms;
DROP TABLE history_octane.org_group;
DROP TABLE history_octane.org_group_leader;
DROP TABLE history_octane.org_group_terms;
DROP TABLE history_octane.org_leader_position_type;
DROP TABLE history_octane.org_lender_user_terms;
DROP TABLE history_octane.org_region;
DROP TABLE history_octane.org_region_leader;
DROP TABLE history_octane.org_region_terms;
DROP TABLE history_octane.org_team;
DROP TABLE history_octane.org_team_leader;
DROP TABLE history_octane.org_team_terms;
DROP TABLE history_octane.org_unit;
DROP TABLE history_octane.org_unit_leader;
DROP TABLE history_octane.org_unit_terms;
