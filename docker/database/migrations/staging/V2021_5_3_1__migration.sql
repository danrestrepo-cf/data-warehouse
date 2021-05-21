--
-- EDW | DDL changes - Octane Schema changes for 2021.5.3.0 (5/21/21)
-- https://app.asana.com/0/0/1200353301584119
--

-- Octane 2021.5.3.0: staging_octane update
ALTER TABLE staging_octane.proposal_summary
    ADD COLUMN ps_any_hoa_certification_fee BOOLEAN;

-- Octane 2021.5.3.0: history_octane update
ALTER TABLE history_octane.proposal_summary
    ADD COLUMN ps_any_hoa_certification_fee BOOLEAN;
