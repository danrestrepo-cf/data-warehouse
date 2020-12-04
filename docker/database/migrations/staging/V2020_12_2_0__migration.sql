-- create data_source table
CREATE TABLE star_common.data_source
(
    dwid BIGSERIAL NOT NULL
        CONSTRAINT data_source_pk
            PRIMARY KEY,
    name TEXT NOT NULL
);

