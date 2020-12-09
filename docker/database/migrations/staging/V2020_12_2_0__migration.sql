-- create data_source table
CREATE TABLE star_common.data_source
(
    dwid BIGSERIAL NOT NULL
        CONSTRAINT data_source_pk
            PRIMARY KEY,
    name TEXT NOT NULL
);

-- populate data_source table with values
INSERT INTO star_common.data_source ( dwid, name )
VALUES ( 0, 'Unspecified' )
     , ( 1, 'Octane' )
     , ( 2, 'Encompass' )
     , ( 3, 'DMI' )
;
