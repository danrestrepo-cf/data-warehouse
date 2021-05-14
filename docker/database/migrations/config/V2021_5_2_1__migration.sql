--
-- EDW | DML changes - Octane Schema changes for 2021.5.2.0 (5/14/21)
-- https://app.asana.com/0/0/1200332934791469
--

DO $$
    -- Variables for inserting new records into edw_field_definition
    DECLARE edw_table_definition_staging_place_dwid BIGINT;
    DECLARE edw_table_definition_history_place_dwid BIGINT;
    DECLARE staging_pl_additional_building_area_square_feet_dwid BIGINT;

    -- Variables for inserting new records into table_output_field
    DECLARE place_config_table_output_step_dwid BIGINT;
    DECLARE place_config_table_output_field_field_order BIGINT;

    BEGIN
        edw_table_definition_staging_place_dwid = (
            SELECT dwid
            FROM mdi.edw_table_definition
            WHERE schema_name = 'staging_octane'
                AND table_name = 'place'
        );
        edw_table_definition_history_place_dwid = (
            SELECT dwid
            FROM mdi.edw_table_definition
            WHERE schema_name = 'history_octane'
                AND table_name = 'place'
        );

        INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
            VALUES (edw_table_definition_staging_place_dwid, 'pl_additional_building_area_square_feet', FALSE)
                RETURNING dwid INTO staging_pl_additional_building_area_square_feet_dwid;

        INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                              source_edw_field_definition_dwid)
            VALUES (edw_table_definition_history_place_dwid, 'pl_additional_building_area_square_feet', FALSE,
                    staging_pl_additional_building_area_square_feet_dwid);


        place_config_table_output_step_dwid = (
            SELECT table_output_step.dwid
            FROM mdi.process
                JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            WHERE process.name = 'SP-100012'
        );

        place_config_table_output_field_field_order = (
            SELECT MAX(table_output_field.field_order)
            FROM mdi.table_output_field
            WHERE table_output_field.table_output_step_dwid = place_config_table_output_step_dwid
        );

        INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name,
                                            field_order, is_sensitive)
            VALUES (place_config_table_output_step_dwid, 'pl_additional_building_area_square_feet',
                    'pl_additional_building_area_square_feet', place_config_table_output_field_field_order + 1, FALSE);
    END $$
