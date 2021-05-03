--
-- EDW User Permissions | Create PostgreSQL user to run MDI configs for loan data
-- https://app.asana.com/0/0/1200279714721251
--

CREATE USER etl_loan PASSWORD 'testonly';
GRANT pentaho_logging TO etl_loan;
GRANT pentaho_mdi to etl_loan;
