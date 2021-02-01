-- create user MDI unit tests (SP-0.*)
CREATE USER mditest PASSWORD 'testonly';

CREATE ROLE unittest;

GRANT unittest TO mditest;
