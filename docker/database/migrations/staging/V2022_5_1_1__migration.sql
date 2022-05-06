--
-- Main | EDW | Octane schema synchronization for v2022.5.1.1 (2022-05-06)
-- https://app.asana.com/0/0/1202219956022828
--

-- staging_octane
ALTER TABLE staging_octane.proposal
	ADD COLUMN prp_initial_intent_to_proceed_date date;

-- history_octane
ALTER TABLE history_octane.proposal
	ADD COLUMN prp_initial_intent_to_proceed_date date;
