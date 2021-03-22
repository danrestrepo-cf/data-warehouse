--
-- EDW - Octane data mart - NMLS Call Report table - fix data types (https://app.asana.com/0/0/1200087257796917)
--

-- recreate permissions on views that were dropped/created
GRANT SELECT ON octane_data_mart.nmls_call_report_national TO readonly;
GRANT SELECT ON octane_data_mart.nmls_call_report_s540a TO readonly;
GRANT SELECT ON octane_data_mart.nmls_call_report_state TO readonly;

GRANT SELECT ON octane_data_mart.nmls_call_report_national TO svc_octane;
GRANT SELECT ON octane_data_mart.nmls_call_report_s540a TO svc_octane;
GRANT SELECT ON octane_data_mart.nmls_call_report_state TO svc_octane;
