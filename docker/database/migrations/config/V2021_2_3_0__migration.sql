-------------------------------------------------------------------------------
--  NAME
--      Add MDI Config tables for Pentaho Insert / update step support
--
--  ASANA
--      https://app.asana.com/0/0/1199565206309934
--
--  DESCRIPTION/PURPOSE
--      This script adds the config tables that are needed to support MDI into
--      Pentaho's Insert / update step
--
-- PROGRAMMING NOTES
--     None
--
-------------------------------------------------------------------------------

CREATE TABLE mdi.insert_update_step (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_insert_update_step
            PRIMARY KEY
    , process_dwid BIGINT NOT NULL
        CONSTRAINT fk_insert_update_step_1
            REFERENCES mdi.process
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED
    , connectionname TEXT NOT NULL
    , schema_name TEXT NOT NULL
    , table_name TEXT NOT NULL
    , commit_size INTEGER NOT NULL
    , do_not mdi.PENTAHO_Y_OR_N NOT NULL
);

CREATE TABLE mdi.insert_update_key (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_insert_update_key
            PRIMARY KEY
    , insert_update_step_dwid BIGINT NOT NULL
        CONSTRAINT fk_insert_update_key_1
            REFERENCES mdi.insert_update_step
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED
    , key_lookup TEXT NOT NULL
    , key_stream1 TEXT NOT NULL
    , key_stream2 TEXT NOT NULL
    , key_condition TEXT NOT NULL
);

CREATE TABLE mdi.insert_update_field (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_insert_update_field
            PRIMARY KEY
    , insert_update_step_dwid BIGINT NOT NULL
        CONSTRAINT fk_insert_update_field_1
            REFERENCES mdi.insert_update_step
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED
    , update_lookup TEXT NOT NULL
    , update_stream TEXT NOT NULL
    , update_flag mdi.PENTAHO_Y_OR_N NOT NULL
    , is_sensitive BOOLEAN NOT NULL
);