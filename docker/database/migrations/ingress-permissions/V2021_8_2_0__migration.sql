--
-- EDW - DMI Passport data load (SP-7) (https://app.asana.com/0/0/1182841661698329 )
--

GRANT SELECT ON dmi.passport TO readonly;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON dmi.passport TO dmi;
