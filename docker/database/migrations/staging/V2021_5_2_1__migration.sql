--
-- EDW | Octane schemas for 5.2.0 (5/14/21)
-- https://app.asana.com/0/0/1200313438340765
--

-- Octane 2021.5.2.0: staging_octane update
ALTER TABLE staging_octane.place
    ADD COLUMN pl_additional_building_area_square_feet integer;

-- Octane 2021.5.2.0: history_octane update
ALTER TABLE history_octane.place
    ADD COLUMN pl_additional_building_area_square_feet integer;
