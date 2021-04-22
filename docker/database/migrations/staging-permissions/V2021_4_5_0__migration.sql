--
-- EDW - define looker database user and access permissions
-- (https://app.asana.com/0/0/1200143939898023)
--
GRANT USAGE ON SCHEMA star_common TO svc_looker;
GRANT SELECT ON ALL TABLES IN SCHEMA star_common TO svc_looker;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA star_common GRANT SELECT ON TABLES TO svc_looker;

GRANT USAGE ON SCHEMA star_loan TO svc_looker;
GRANT SELECT ON ALL TABLES IN SCHEMA star_loan TO svc_looker;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA star_loan GRANT SELECT ON TABLES TO svc_looker;