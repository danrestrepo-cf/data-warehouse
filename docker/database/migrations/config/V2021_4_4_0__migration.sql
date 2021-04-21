--
-- EDW | ETL Metadata - Create state machine mdi config tables
-- (https://app.asana.com/0/0/1200167362277975)
--


CREATE TABLE mdi.state_machine_step (
      dwid BIGSERIAL NOT NULL
            CONSTRAINT pk_state_machine_step
                PRIMARY KEY
    , process_dwid BIGINT NOT NULL
            CONSTRAINT fk_state_machine_step_1
                REFERENCES mdi.process (dwid)
                ON UPDATE RESTRICT
                ON DELETE RESTRICT
                DEFERRABLE INITIALLY DEFERRED
    , next_process_dwid BIGINT NULL
            CONSTRAINT fk_state_machine_step_2
                REFERENCES mdi.process (dwid)
                ON UPDATE RESTRICT
                ON DELETE RESTRICT
                DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE mdi.state_machine_definition  (
      dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_state_machine_step
            PRIMARY KEY
    , process_dwid BIGINT NOT NULL
        CONSTRAINT fk_state_machine_step_1
            REFERENCES mdi.process (dwid)
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED
    , name text NOT NULL
    , comment text NOT NULL
);

CREATE TABLE mdi.state_machine_definition  (
      dwid BIGSERIAL NOT NULL
       CONSTRAINT pk_state_machine_step
           PRIMARY KEY
    , process_dwid BIGINT NOT NULL
       CONSTRAINT fk_state_machine_step_1
           REFERENCES mdi.process (dwid)
           ON UPDATE RESTRICT
           ON DELETE RESTRICT
           DEFERRABLE INITIALLY DEFERRED
    , field_name text NOT NULL
);


