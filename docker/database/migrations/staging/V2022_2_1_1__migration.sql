--
-- EDW | star_loan: Remove column lender_user_dim.work_step_start_notices_enabled_flag
-- https://app.asana.com/0/0/1201753612968906
--

ALTER TABLE star_loan.lender_user_dim
    DROP COLUMN work_step_start_notices_enabled_flag;
