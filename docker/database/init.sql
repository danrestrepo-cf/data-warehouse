-- CREATE USER IF NOT EXISTS deployer;
CREATE DATABASE ingress;
-- GRANT ALL PRIVILEGES ON DATABASE ingress TO postgres;
CREATE DATABASE config;
-- GRANT ALL PRIVILEGES ON DATABASE config TO postgres;
CREATE DATABASE staging;
-- GRANT ALL PRIVILEGES ON DATABASE staging TO postgres;

CREATE ROLE deployer;
CREATE USER admin PASSWORD 'testonly';
GRANT deployer TO admin;

GRANT ALL PRIVILEGES ON DATABASE ingress, config, staging to deployer;
