--
-- Main | EDW | Octane schema synchronization for v2022.4.1.0 (2022-04-01)
-- https://app.asana.com/0/0/1202049009611960
--

--staging_octane
CREATE TABLE staging_octane.org_node_doc (
    ond_pid BIGINT,
    ond_version INTEGER,
    CONSTRAINT pk_org_node_doc
        PRIMARY KEY (ond_pid),
    ond_account_pid BIGINT,
    ond_org_node_pid BIGINT,
    ond_name VARCHAR(128),
    ond_description VARCHAR(256),
    ond_url VARCHAR(2048)
);

CREATE INDEX idx_org_node_doc__ond_pid_ond_version ON staging_octane.org_node_doc (ond_pid, ond_version);

ALTER TABLE staging_octane.company_settings
    ADD COLUMN cs_fha_origination_sponsored BOOLEAN;

ALTER TABLE staging_octane.proposal_construction
    ADD COLUMN prpc_certificate_of_occupancy_date DATE;

ALTER TABLE staging_octane.lender_user
    RENAME COLUMN lu_esign_only TO lu_esign_by_email;

--history_octane
CREATE TABLE history_octane.org_node_doc (
    ond_pid BIGINT,
    ond_version INTEGER,
    ond_account_pid BIGINT,
    ond_org_node_pid BIGINT,
    ond_name VARCHAR(128),
    ond_description VARCHAR(256),
    ond_url VARCHAR(2048),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_org_node_doc__ond_pid ON history_octane.org_node_doc (ond_pid);

CREATE INDEX idx_org_node_doc__data_source_updated_datetime ON history_octane.org_node_doc (data_source_updated_datetime);

CREATE INDEX idx_org_node_doc__data_source_deleted_flag ON history_octane.org_node_doc (data_source_deleted_flag);

CREATE INDEX idx_org_node_doc__etl_batch_id ON history_octane.org_node_doc (etl_batch_id);

CREATE INDEX idx_org_node_doc__ond_pid_ond_version ON history_octane.org_node_doc (ond_pid, ond_version);

CREATE INDEX fk_org_node_doc_2 ON history_octane.org_node_doc (ond_org_node_pid);

CREATE INDEX fk_org_node_doc_1 ON history_octane.org_node_doc (ond_account_pid);

ALTER TABLE history_octane.company_settings
    ADD COLUMN cs_fha_origination_sponsored BOOLEAN;

ALTER TABLE history_octane.proposal_construction
    ADD COLUMN prpc_certificate_of_occupancy_date DATE;

ALTER TABLE history_octane.lender_user
    RENAME COLUMN lu_esign_only TO lu_esign_by_email;

--star_loan
ALTER TABLE star_loan.lender_user_dim
    RENAME COLUMN esign_only_flag TO esign_by_email_flag;
