--
-- EDW | Permissions - give etl_loan user INSERT permissions on the star_common.etl_log table
-- https://app.asana.com/0/0/1201367615312267
--

-- since etl_loan is a member of pentaho_logging, this will indirectly grant the necessary
-- permission to etl_loan and be more flexible for other etl_* users in the future
GRANT INSERT ON star_common.etl_log TO pentaho_logging;
GRANT USAGE, SELECT ON star_common.etl_log_dwid_seq TO pentaho_logging;
