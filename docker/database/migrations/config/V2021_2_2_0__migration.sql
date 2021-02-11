--
-- EDW - Modify DMI NMLS Call Report processes (SP8/SP9/SP10) to add report_quarter and filename columns (https://app.asana.com/0/0/1199603976631072)
--

DO $$
    DECLARE sp8_1_process_dwid BIGINT;
    DECLARE sp8_1_table_output_step_dwid BIGINT;
    DECLARE sp8_1_csv_file_input_step_dwid BIGINT;

    DECLARE sp8_2_process_dwid BIGINT;
    DECLARE sp8_2_table_output_step_dwid BIGINT;

    BEGIN
        -- gather IDs needed further down in the script
        sp8_1_process_dwid = (SELECT dwid FROM mdi.process WHERE name = 'SP8.1' );
        sp8_1_csv_file_input_step_dwid = (SELECT dwid FROM mdi.csv_file_input_step WHERE process_dwid = sp8_1_process_dwid);
        sp8_1_table_output_step_dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_1_process_dwid);

        sp8_2_process_dwid = ( SELECT dwid FROM mdi.process WHERE name like 'SP8.2' );
        sp8_2_table_output_step_dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid);

        --
        -- SP8.1
        --

        -- update csv_file_input_step config to reflect updated columns
        DELETE FROM mdi.csv_file_input_field
        WHERE csv_file_input_step_dwid = sp8_1_csv_file_input_step_dwid;

        -- replace deleted fields in csv_file_input_field
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES
            ( sp8_1_csv_file_input_step_dwid, 'mcr_code', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 1 )
            , ( sp8_1_csv_file_input_step_dwid, 'mcr_description', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 2 )
            ,( sp8_1_csv_file_input_step_dwid, 'state_code', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 3 )
            ,( sp8_1_csv_file_input_step_dwid, 'sum_of_upb', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 4 )
            ,( sp8_1_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 5 )
            ,( sp8_1_csv_file_input_step_dwid, 'avg_loan_size', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 6 )
            ,( sp8_1_csv_file_input_step_dwid, 'report_quarter', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 7 );


        UPDATE
            mdi.table_output_step
        SET
            target_table='nmls_call_report_state'
        WHERE dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP8.1' ))
        RETURNING dwid INTO sp8_1_table_output_step_dwid;

        -- remove all current output fields for SP8.1 so we can readd them
        DELETE FROM
            mdi.table_output_field
        WHERE
            table_output_step_dwid = sp8_1_table_output_step_dwid;


        -- add new fields to table_output_field
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
        VALUES
            ( sp8_1_table_output_step_dwid, 'mcr_code', 'mcr_code', 1, false )
            , ( sp8_1_table_output_step_dwid, 'mcr_description', 'mcr_description', 2, false )
            , ( sp8_1_table_output_step_dwid, 'state_code', 'state_code', 3, false )
            , ( sp8_1_table_output_step_dwid, 'sum_of_upb', 'sum_of_upb', 4, false )
            , ( sp8_1_table_output_step_dwid, 'loan_count', 'loan_count', 5, false )
            , ( sp8_1_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', 6, false )
            , ( sp8_1_table_output_step_dwid, 'report_quarter', 'report_quarter', 7, false )
            , ( sp8_1_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 8, false )
            , ( sp8_1_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 9, false )
            , ( sp8_1_table_output_step_dwid, 'input_filename', 'imported_filename', 10, false );


        --
        -- SP8.2
        --

        -- update table_input_step sql to remove _raw
        UPDATE
            mdi.table_input_step
        SET
            -- matches SP8.1 output column names
            sql='select
    data_source_dwid AS data_source_dwid_value
    , mcr_code
    , mcr_description
    , state_code
    , sum_of_upb
    , loan_count
    , avg_loan_size
    , report_quarter
from
    dmi.nmls_call_report_state
;'
        WHERE
            process_dwid = sp8_2_process_dwid;


        UPDATE
            mdi.table_output_step
        SET
            target_table = 'nmls_call_report_state'
        WHERE
                dwid = sp8_2_table_output_step_dwid;

        -- map SP8.1 input names to SP8.2 output names
        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'sum_of_upb', database_field_name = 'total_unpaid_balance'
        WHERE
                table_output_step_dwid = sp8_2_table_output_step_dwid
            AND database_stream_name = 'unpaid_balance';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'state_code', database_field_name = 'state_type'
        WHERE
                table_output_step_dwid = sp8_2_table_output_step_dwid
            AND database_stream_name = 'state_type';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'data_source_dwid_value', database_field_name = 'data_source_dwid'
        WHERE
                table_output_step_dwid = sp8_2_table_output_step_dwid
            AND database_stream_name = 'data_source_dwid';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'mcr_description', database_field_name = 'mcr_description'
        WHERE
                table_output_step_dwid = sp8_2_table_output_step_dwid
            AND database_stream_name = 'mcr_desc';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'mcr_code', database_field_name = 'mcr_field_id'
        WHERE
                table_output_step_dwid = sp8_2_table_output_step_dwid
            AND database_stream_name = 'mcr_code';


        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_2_table_output_step_dwid, 'report_quarter', 'report_quarter', 9, false );

END $$;

DO $$
    DECLARE sp9_1_process_dwid BIGINT;
    DECLARE sp9_field_order NUMERIC;
    DECLARE sp9_1_table_output_step_dwid BIGINT;
    DECLARE sp9_1_csv_file_input_step_dwid BIGINT;

    DECLARE sp9_2_process_dwid BIGINT;
    DECLARE sp9_2_table_output_step_dwid NUMERIC;

    BEGIN
        sp9_1_process_dwid = (SELECT dwid FROM mdi.process WHERE name = 'SP9.1' );
        sp9_1_csv_file_input_step_dwid = (SELECT dwid FROM mdi.csv_file_input_step WHERE process_dwid = sp9_1_process_dwid );
        sp9_1_table_output_step_dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_1_process_dwid);

        sp9_2_process_dwid = ( SELECT dwid from mdi.process WHERE name = 'SP9.2' );
        sp9_2_table_output_step_dwid = ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid );

        --
        -- SP9.1
        --

        -- update csv_file_input_step config to reflect updated columns
        DELETE FROM mdi.csv_file_input_field
        WHERE csv_file_input_step_dwid = sp9_1_csv_file_input_step_dwid;

        -- replace deleted fields in csv_file_input_field
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES
            ( sp9_1_csv_file_input_step_dwid, 'mcr_code', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 1 )
            , ( sp9_1_csv_file_input_step_dwid, 'mcr_description', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 2 )
            , ( sp9_1_csv_file_input_step_dwid, 'sum_of_upb', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 3 )
            , ( sp9_1_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 4 )
            , ( sp9_1_csv_file_input_step_dwid, 'avg_loan_size', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 5 )
            , ( sp9_1_csv_file_input_step_dwid, 'report_quarter', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', 6 );


        -- update csv_file_input_step config to reflect updated columns
        DELETE FROM mdi.table_output_field
        WHERE table_output_step_dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP9.1' ));

        -- add new fields to table_output_field
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES
            ( sp9_1_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false )
            , ( sp9_1_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false )
            , ( sp9_1_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false )
            , ( sp9_1_table_output_step_dwid, 'mcr_code', 'mcr_code', 4, false )
            , ( sp9_1_table_output_step_dwid, 'mcr_description', 'mcr_description', 5, false )
            , ( sp9_1_table_output_step_dwid, 'sum_of_upb', 'sum_of_upb', 6, false )
            , ( sp9_1_table_output_step_dwid, 'loan_count', 'loan_count', 7, false )
            , ( sp9_1_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', 8, false )
            , ( sp9_1_table_output_step_dwid, 'report_quarter', 'report_quarter', 9, false );

        -- update table name to remove _raw
        UPDATE
            mdi.table_output_step
        SET
            target_table='nmls_call_report_national'
        WHERE dwid = sp9_1_table_output_step_dwid;



        --
        -- SP9.2
        --
        UPDATE
            mdi.table_input_step
        SET
            sql = 'select
   data_source_dwid as data_source_dwid_value
   , mcr_code
   , mcr_description
   , sum_of_upb
   , loan_count
   , avg_loan_size
   , report_quarter
from
   dmi.nmls_call_report_national
;'
        WHERE process_dwid = sp9_2_process_dwid;

        -- update table name for 9.2
        UPDATE
            mdi.table_output_step
        SET target_table = 'nmls_call_report_national'
        WHERE
                process_dwid = sp9_2_process_dwid;

        -- map SP9.1 input names to SP9.2 output names
        DELETE
        FROM
            mdi.table_output_field
        WHERE
                table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid);

        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES
            ( sp9_2_table_output_step_dwid, 'mcr_field_id', 'mcr_code', 1, false )
            , ( sp9_2_table_output_step_dwid, 'mcr_description', 'mcr_description', 2, false )
            , ( sp9_2_table_output_step_dwid, 'total_unpaid_balance', 'sum_of_upb', 3, false )
            , ( sp9_2_table_output_step_dwid, 'loan_count', 'loan_count', 4, false )
            , ( sp9_2_table_output_step_dwid, 'average_unpaid_balance', 'avg_loan_size', 5, false )
            , ( sp9_2_table_output_step_dwid, 'report_quarter', 'report_quarter', 6, false )
            , ( sp9_2_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid_value', 7, false )
            , ( sp9_2_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 8, false );

END $$;

DO $$
    DECLARE sp10_field_order NUMERIC;
    DECLARE sp10_1_process_dwid BIGINT;
    DECLARE sp10_1_microsoft_excel_input_step_dwid BIGINT;
    DECLARE sp10_1_csv_file_input_step_dwid BIGINT;
    DECLARE sp10_1_table_output_step_dwid BIGINT;

    DECLARE sp10_2_process_dwid BIGINT;
    DECLARE sp10_2_table_output_step_dwid BIGINT;
        
    BEGIN
        -- gather IDs needed further down in the script
        sp10_1_process_dwid = (SELECT dwid FROM mdi.process WHERE name = 'SP10.1');
        sp10_1_microsoft_excel_input_step_dwid = (SELECT dwid FROM mdi.microsoft_excel_input_step WHERE process_dwid = sp10_1_process_dwid);
        sp10_1_table_output_step_dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp10_1_process_dwid);

        sp10_2_process_dwid = ( SELECT dwid from mdi.process WHERE name = 'SP10.2' );
        sp10_2_table_output_step_dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp10_2_process_dwid);

        --
        -- SP10.1
        --

        -- delete old microsoft_excel_input_field records
        DELETE FROM
            mdi.microsoft_excel_input_field
        WHERE
            microsoft_excel_input_step_dwid = sp10_1_microsoft_excel_input_step_dwid;

        -- delete old microsoft_excel_input_step record
        DELETE FROM
            mdi.microsoft_excel_input_step
        WHERE
            process_dwid = sp10_1_process_dwid;

        -- create new csv_file_input_step record to replace old microsoft_excel_input_step record
        INSERT INTO mdi.csv_file_input_step ( process_dwid, header_present, delimiter, enclosure, buffersize
                                            , lazy_conversion, newline_possible, add_filename_result, file_format
                                            , file_encoding, include_filename
                                            , process_in_parallel, filename_field, row_num_field, data_source_dwid )
        VALUES ( sp10_1_process_dwid, 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'Y', NULL, NULL, 3 )
        RETURNING dwid INTO sp10_1_csv_file_input_step_dwid;
        RETURNING dwid INTO sp10_1_csv_file_input_step_dwid;


        -- create new csv_file_input_field records to replace old microsoft_excel_input_field records
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format, field_length,
                                               field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES
            ( sp10_1_csv_file_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'item_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none', 2 )
            , ( sp10_1_csv_file_input_step_dwid, 'servicer_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none', 3 )
            , ( sp10_1_csv_file_input_step_dwid, 'servicer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4 )
            , ( sp10_1_csv_file_input_step_dwid, 'pool_no', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 )
            , ( sp10_1_csv_file_input_step_dwid, 'upb', 'Integer', '#', -1, -1, '$', '.', ',', 'none', 6 )
            , ( sp10_1_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, '$', '.', ',', 'none', 7 )
            , ( sp10_1_csv_file_input_step_dwid, 'avg_loan_size', 'Integer', '#', -1, -1, '$', '.', ',', 'none', 8 )
            , ( sp10_1_csv_file_input_step_dwid, 'report_quarter', 'String', '', -1, -1, '$', '.', ',', 'none', 9 );


        -- update table name to remove _raw
        UPDATE
            mdi.table_output_step
        SET
            target_table = 'nmls_call_report_s540a'
        WHERE
                process_dwid = sp10_1_process_dwid;

        -- delete table_output_field records
        DELETE FROM
            mdi.table_output_field
        WHERE
                table_output_step_dwid = sp10_1_table_output_step_dwid;

        -- create new table_output_field records for all columns
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES
             ( sp10_1_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false )
             , ( sp10_1_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false )
             , ( sp10_1_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false )
             , ( sp10_1_table_output_step_dwid, 'state', 'state', 4, false )
             , ( sp10_1_table_output_step_dwid, 'item_id', 'item_id', 5, false )
             , ( sp10_1_table_output_step_dwid, 'servicer_id', 'servicer_id', 6, false )
             , ( sp10_1_table_output_step_dwid, 'servicer_name', 'servicer_name', 7, false )
             , ( sp10_1_table_output_step_dwid, 'pool_no', 'pool_no', 8, false )
             , ( sp10_1_table_output_step_dwid, 'upb', 'upb', 9, false )
             , ( sp10_1_table_output_step_dwid, 'loan_count', 'loan_count', 10, false )
             , ( sp10_1_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', 11, false )
             , ( sp10_1_table_output_step_dwid, 'report_quarter', 'report_quarter', 12, false );


        --
        -- SP10.2
        --
        UPDATE
            mdi.table_input_step
        SET
            sql = 'select
   data_source_dwid as data_source_dwid_value
   , state
   , item_id
   , servicer_id
   , servicer_name
   , pool_no
   , upb
   , loan_count
   , avg_loan_size
   , report_quarter
from
   dmi.nmls_call_report_s540a
;'
        WHERE process_dwid = sp10_2_process_dwid;

        -- delete table_output_field records
        DELETE FROM
            mdi.table_output_field
        WHERE
                table_output_step_dwid = sp10_2_table_output_step_dwid;

        -- create new table_output_field records for all columns
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES
            ( sp10_2_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false )
            , ( sp10_2_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid_value', 2, false )
            , ( sp10_2_table_output_step_dwid, 'state_type', 'state', 3, false )
            , ( sp10_2_table_output_step_dwid, 'item_id', 'item_id', 4, false )
            , ( sp10_2_table_output_step_dwid, 'servicer_nmls_id', 'servicer_id', 5, false )
            , ( sp10_2_table_output_step_dwid, 'servicer_name', 'servicer_name', 6, false )
            , ( sp10_2_table_output_step_dwid, 'pool_number', 'pool_no', 7, false )
            , ( sp10_2_table_output_step_dwid, 'total_unpaid_balance', 'upb', 8, false )
            , ( sp10_2_table_output_step_dwid, 'loan_count', 'loan_count', 9, false )
            , ( sp10_2_table_output_step_dwid, 'average_unpaid_balance', 'avg_loan_size', 10, false )
            , ( sp10_2_table_output_step_dwid, 'report_quarter', 'report_quarter', 11, false );

END $$;
