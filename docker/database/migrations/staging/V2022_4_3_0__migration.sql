--
-- EDW | add missing etl_batch_id columns to history_octane tables
-- https://app.asana.com/0/0/1202099796036709
--

ALTER TABLE history_octane.config_note_comment
    ADD COLUMN etl_batch_id text;

ALTER TABLE history_octane.config_note_monitor
    ADD COLUMN etl_batch_id text;

ALTER TABLE history_octane.config_note_scope_type
    ADD COLUMN etl_batch_id text;

ALTER TABLE history_octane.config_note
    ADD COLUMN etl_batch_id text;

CREATE INDEX idx_config_note__etl_batch_id ON history_octane.config_note (etl_batch_id);
CREATE INDEX idx_config_note_comment__etl_batch_id ON history_octane.config_note_monitor (etl_batch_id);
CREATE INDEX idx_config_note_monitor__etl_batch_id ON history_octane.config_note_monitor (etl_batch_id);
CREATE INDEX idx_config_note_scope_type__etl_batch_id ON history_octane.config_note_scope_type (etl_batch_id);
