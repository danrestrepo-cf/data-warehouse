--
-- Main | EDW | Octane schemas from prod-release to v2022.2.4.3 on uat
-- https://app.asana.com/0/0/1201869048849952
--

-- staging_octane
ALTER TABLE staging_octane.deal
    ADD COLUMN d_ecoa_notice_of_incomplete_date date,
    ADD COLUMN d_ecoa_notice_of_incomplete_due_date date;

ALTER TABLE staging_octane.wf_step_function_parameters
    ADD COLUMN wsfp_number_business_days integer;


-- history_octane
ALTER TABLE history_octane.deal
    ADD COLUMN d_ecoa_notice_of_incomplete_date date,
    ADD COLUMN d_ecoa_notice_of_incomplete_due_date date;

ALTER TABLE history_octane.wf_step_function_parameters
    ADD COLUMN wsfp_number_business_days integer;
