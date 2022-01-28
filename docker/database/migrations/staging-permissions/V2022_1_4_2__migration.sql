--
-- EDW | Permissions - grant readonly user access to DMS logging tables
-- https://app.asana.com/0/0/1201735758687638
--

GRANT SELECT ON ALL TABLES IN SCHEMA octane_dms_control TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA octane_dms_control GRANT SELECT ON TABLES TO readonly;
