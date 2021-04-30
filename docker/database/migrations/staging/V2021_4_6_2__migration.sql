--
-- EDW - Octane schemas for 4.5.0 (4/30/21) (https://app.asana.com/0/0/1200265768902114)
--

ALTER TABLE staging_octane.contractor
    ADD COLUMN ctr_has_employees varchar(128);

ALTER TABLE history_octane.contractor
    ADD COLUMN ctr_has_employees varchar(128);

CREATE INDEX fkt_ctr_has_employees ON history_octane.contractor (ctr_has_employees);
