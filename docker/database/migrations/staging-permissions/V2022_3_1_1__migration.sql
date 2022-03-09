--
-- EDW | Business Applications data mart- build a data mart and provide Octane user hierarchy data (patch PR)
-- https://app.asana.com/0/1199645410972911/1201859471430286
--

GRANT USAGE ON SCHEMA data_mart_business_applications TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA data_mart_business_applications TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA data_mart_business_applications GRANT SELECT ON TABLES TO readonly;
