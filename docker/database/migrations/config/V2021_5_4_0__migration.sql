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

--
-- EDW | Modify hmda_purchaser_of_loan_dim to include separate columns for each year and build ETL to populate this dimension
-- https://app.asana.com/0/0/1200259416383677
--

WITH loan_table_definition AS (
    SELECT dwid
    FROM mdi.edw_table_definition
    WHERE schema_name = 'history_octane'
      AND table_name = 'loan'
)
   , hmda_2017_table_definition AS (
    SELECT dwid
    FROM mdi.edw_table_definition
    WHERE schema_name = 'history_octane'
      AND table_name = 'hmda_purchaser_of_loan_2017_type'
)
   , hmda_2018_table_definition AS (
    SELECT dwid
    FROM mdi.edw_table_definition
    WHERE schema_name = 'history_octane'
      AND table_name = 'hmda_purchaser_of_loan_2018_type'
)
   -- insert edw_table_definition record for hmda_purchaser_of_loan_dim
   , hmda_dim_table_definition AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        SELECT 'staging', 'star_loan', 'hmda_purchaser_of_loan_dim', loan_table_definition.dwid
        FROM loan_table_definition
        RETURNING dwid
)
   -- insert edw_join_tree_definition records to be referenced by hmda_purchaser_of_loan_dim field definitions
   , hmda_2017_join_tree_definition AS (
    INSERT INTO mdi.edw_join_tree_definition (root_join_dwid, sibling_join_tree_dwid, child_join_tree_dwid)
        SELECT edw_join_definition.dwid, NULL, NULL
        FROM mdi.edw_join_definition
        JOIN hmda_2017_table_definition
             ON edw_join_definition.target_edw_table_definition_dwid = hmda_2017_table_definition.dwid
        JOIN loan_table_definition
             ON edw_join_definition.primary_edw_table_definition_dwid = loan_table_definition.dwid
        RETURNING dwid
)
   , hmda_2018_join_tree_definition AS (
    INSERT INTO mdi.edw_join_tree_definition (root_join_dwid, sibling_join_tree_dwid, child_join_tree_dwid)
        SELECT edw_join_definition.dwid, NULL, NULL
        FROM mdi.edw_join_definition
        JOIN hmda_2018_table_definition
             ON edw_join_definition.target_edw_table_definition_dwid = hmda_2018_table_definition.dwid
        JOIN loan_table_definition
             ON edw_join_definition.primary_edw_table_definition_dwid = loan_table_definition.dwid
        RETURNING dwid
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.dwid
   , dwid_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'dwid'
             , FALSE
             , NULL
             , NULL
             , 'BIGSERIAL'
             , NULL
             , TRUE
             , TRUE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.data_source_dwid
   , data_source_dwid_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'data_source_dwid'
             , TRUE
             , NULL
             , NULL
             , 'BIGINT'
             , NULL
             , TRUE
             , FALSE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.edw_created_datetime
   , edw_created_datetime_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'edw_created_datetime'
             , FALSE
             , NULL
             , NULL
             , 'TIMESTAMPTZ'
             , NULL
             , TRUE
             , FALSE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.edw_modified_datetime
   , edw_modified_datetime_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'edw_modified_datetime'
             , FALSE
             , NULL
             , NULL
             , 'TIMESTAMPTZ'
             , NULL
             , TRUE
             , FALSE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.etl_batch_id
   , etl_batch_id_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'etl_batch_id'
             , FALSE
             , NULL
             , NULL
             , 'TEXT'
             , NULL
             , TRUE
             , FALSE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.data_source_integration_columns
   , data_source_integration_columns_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'data_source_integration_columns'
             , FALSE
             , NULL
             , NULL
             , 'TEXT'
             , NULL
             , TRUE
             , FALSE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.data_source_integration_id
   , data_source_integration_id_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'data_source_integration_id'
             , FALSE
             , NULL
             , NULL
             , 'TEXT'
             , NULL
             , TRUE
             , FALSE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.data_source_modified_datetime
   , data_source_modified_datetime_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'data_source_modified_datetime'
             , FALSE
             , NULL
             , NULL
             , 'TIMESTAMPTZ'
             , NULL
             , TRUE
             , FALSE
        FROM hmda_dim_table_definition
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.code_2017
   , code_2017_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'code_2017'
             , TRUE
             , edw_field_definition.dwid
             , (SELECT dwid FROM hmda_2017_join_tree_definition)
             , 'VARCHAR(128)'
             , '2017 HMDA Purchaser of Loan Code'
             , FALSE
             , FALSE
        FROM hmda_dim_table_definition
        JOIN mdi.edw_field_definition
             ON edw_table_definition_dwid = (SELECT dwid FROM hmda_2017_table_definition)
                 AND field_name = 'code'
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.value_2017
   , value_2017_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'value_2017'
             , TRUE
             , edw_field_definition.dwid
             , (SELECT dwid FROM hmda_2017_join_tree_definition)
             , 'VARCHAR(1024)'
             , '2017 HMDA Purchaser of Loan'
             , FALSE
             , FALSE
        FROM hmda_dim_table_definition
        JOIN mdi.edw_field_definition
             ON edw_table_definition_dwid = (SELECT dwid FROM hmda_2017_table_definition)
                 AND field_name = 'value'
)
   -- insert edw_field_definition record for hmda_purchaser_of_loan_dim.code_2018
   , code_2018_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid,
                                          source_edw_join_tree_definition_dwid,
                                          data_type,
                                          reporting_label,
                                          reporting_hidden,
                                          reporting_key_flag)
        SELECT hmda_dim_table_definition.dwid
             , 'code_2018'
             , TRUE
             , edw_field_definition.dwid
             , (SELECT dwid FROM hmda_2018_join_tree_definition)
             , 'VARCHAR(128)'
             , '2018 HMDA Purchaser of Loan Code'
             , FALSE
             , FALSE
        FROM hmda_dim_table_definition
        JOIN mdi.edw_field_definition
             ON edw_table_definition_dwid = (SELECT dwid FROM hmda_2018_table_definition)
                 AND field_name = 'code'
)
-- insert edw_field_definition record for hmda_purchaser_of_loan_dim.code_2018
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid,
                               field_name,
                               key_field_flag,
                               source_edw_field_definition_dwid,
                               source_edw_join_tree_definition_dwid,
                               data_type,
                               reporting_label,
                               reporting_hidden,
                               reporting_key_flag)
SELECT hmda_dim_table_definition.dwid
     , 'value_2018'
     , TRUE
     , edw_field_definition.dwid
     , (SELECT dwid FROM hmda_2018_join_tree_definition)
     , 'VARCHAR(1024)'
     , '2018 HMDA Purchaser of Loan'
     , FALSE
     , FALSE
FROM hmda_dim_table_definition
JOIN mdi.edw_field_definition
     ON edw_table_definition_dwid = (SELECT dwid FROM hmda_2018_table_definition)
         AND field_name = 'value';
