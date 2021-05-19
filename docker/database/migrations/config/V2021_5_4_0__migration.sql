--
-- EDW | Create new MDI-2 process to delete records
-- (https://app.asana.com/0/0/1200314434941492)
--

CREATE TABLE mdi.delete_step (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_delete_step
            PRIMARY KEY,
    process_dwid BIGINT NOT NULL
        CONSTRAINT fk_delete_step_1
            REFERENCES mdi.process
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED,
    connectionname TEXT NOT NULL,
    schema_name TEXT NOT NULL,
    table_name TEXT NOT NULL,
    commit_size INTEGER NOT NULL
);

CREATE TABLE mdi.delete_key (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_delete_key
            PRIMARY KEY,
    delete_step_dwid BIGINT NOT NULL
        CONSTRAINT fk_delete_key_1
            REFERENCES mdi.delete_step
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED,
    table_name_field TEXT NOT NULL,
    stream_fieldname_1 TEXT NOT NULL,
    stream_fieldname_2 TEXT NOT NULL,  -- Pentaho throws an error if this field is null, even if it is not used
    comparator TEXT NOT NULL,
    is_sensitive BOOLEAN NOT NULL
);
