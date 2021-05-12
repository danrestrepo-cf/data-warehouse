---
--- EDW MDI-2 DB Permission | Update permissions for etl_loan user so it can write to config DB's log schema (https://app.asana.com/0/0/1200316583743203/)
---

GRANT pentaho_logging TO etl_loan;
GRANT pentaho_mdi to etl_loan;
