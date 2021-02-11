--
-- EDW - Modify DMI NMLS Call Report processes (SP8/SP9/SP10) to add report_quarter and filename columns (https://app.asana.com/0/0/1199603976631072)
--

DO $$
    DECLARE sp8_1_field_order NUMERIC;
    DECLARE sp8_1_table_output_step_dwid BIGINT;
    DECLARE sp8_1_csv_file_input_step_dwid BIGINT;
    DECLARE sp8_2_process_dwid BIGINT;

    BEGIN

        --
        -- SP8.1
        --

        -- update csv_file_input_step config to reflect updated columns
        DELETE FROM mdi.csv_file_input_field
        WHERE csv_file_input_step_dwid = (SELECT dwid FROM mdi.csv_file_input_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP8.1' ));

        -- replace deleted fields in csv_file_input_field
        sp8_1_field_order = 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( (SELECT dwid FROM mdi.csv_file_input_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP8.1' ))
               , 'mcr_code', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp8_1_field_order )
        RETURNING csv_file_input_step_dwid INTO sp8_1_csv_file_input_step_dwid;

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp8_1_csv_file_input_step_dwid, 'mcr_description', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp8_1_field_order );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp8_1_csv_file_input_step_dwid, 'state_code', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp8_1_field_order );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp8_1_csv_file_input_step_dwid, 'sum_of_upb', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp8_1_field_order );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp8_1_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp8_1_field_order );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp8_1_csv_file_input_step_dwid, 'avg_loan_size', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp8_1_field_order );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp8_1_csv_file_input_step_dwid, 'report_quarter', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp8_1_field_order );


        UPDATE
            mdi.table_output_step
        SET
            target_table='nmls_call_report_state'
        WHERE dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP8.1' ))
        RETURNING dwid INTO sp8_1_table_output_step_dwid;


        DELETE FROM mdi.table_output_field
        WHERE table_output_step_dwid = sp8_1_table_output_step_dwid;


        -- add new fields to table_output_field
        sp8_1_field_order = 1;

        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP8.1' )), 'mcr_code', 'mcr_code', sp8_1_field_order, false )
        RETURNING table_output_step_dwid INTO sp8_1_table_output_step_dwid;

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'mcr_description', 'mcr_description', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'state_code', 'state_code', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'sum_of_upb', 'sum_of_upb', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'loan_count', 'loan_count', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'report_quarter', 'report_quarter', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', sp8_1_field_order, false );

        sp8_1_field_order = sp8_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp8_1_table_output_step_dwid, 'input_filename', 'imported_filename', sp8_1_field_order, false );


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
    , etl_batch_id
    , report_quarter
from
    dmi.nmls_call_report_state
;'
        WHERE process_dwid IN ( SELECT dwid FROM mdi.process WHERE name like 'SP8.2' )

            -- update table name for 8.2
        RETURNING process_dwid INTO sp8_2_process_dwid;

        UPDATE
            mdi.table_output_step
        SET target_table = 'nmls_call_report_state'
        WHERE
                dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid);

        -- map SP8.1 input names to SP8.2 output names
        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'sum_of_upb', database_field_name = 'total_unpaid_balance'
        WHERE
                table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid)
            AND database_stream_name = 'unpaid_balance';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'state_code', database_field_name = 'state_type'
        WHERE
                table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid)
            AND database_stream_name = 'state_type';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'data_source_dwid_value', database_field_name = 'data_source_dwid'
        WHERE
                table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid)
            AND database_stream_name = 'data_source_dwid';

        UPDATE
            mdi.table_output_field
        SET
            database_stream_name = 'mcr_description', database_field_name = 'mcr_description'
        WHERE
                table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid)
            AND database_stream_name = 'mcr_desc';


        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid ), 'report_quarter', 'report_quarter', ( SELECT MAX(field_order) + 1 FROM mdi.table_output_field WHERE table_output_step_dwid IN ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp8_2_process_dwid ) ), false );

END $$;

DO $$
    DECLARE sp9_1_field_order NUMERIC;
    DECLARE sp9_1_table_output_step_dwid BIGINT;
    DECLARE sp9_1_csv_file_input_step_dwid BIGINT;
    DECLARE sp9_2_process_dwid BIGINT;
    DECLARE sp9_2_field_order NUMERIC;

    BEGIN

        --
        -- SP9.1
        --

        -- update csv_file_input_step config to reflect updated columns
        DELETE FROM mdi.csv_file_input_field
        WHERE csv_file_input_step_dwid = (SELECT dwid FROM mdi.csv_file_input_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP9.1' ));

        -- replace deleted fields in csv_file_input_field
        sp9_1_field_order = 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( (SELECT dwid FROM mdi.csv_file_input_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP9.1' ))
               , 'mcr_code', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp9_1_field_order )
        RETURNING csv_file_input_step_dwid INTO sp9_1_csv_file_input_step_dwid;

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp9_1_csv_file_input_step_dwid, 'mcr_description', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp9_1_field_order );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp9_1_csv_file_input_step_dwid, 'sum_of_upb', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp9_1_field_order );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp9_1_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp9_1_field_order );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp9_1_csv_file_input_step_dwid, 'avg_loan_size', 'Number', '#.#', -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp9_1_field_order );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order)
        VALUES ( sp9_1_csv_file_input_step_dwid, 'report_quarter', 'String', NULL, -1, -1, DEFAULT, DEFAULT, DEFAULT, 'none', sp9_1_field_order );


        -- update csv_file_input_step config to reflect updated columns
        DELETE FROM mdi.table_output_field
        WHERE table_output_step_dwid = (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP9.1' ));

        -- add new fields to table_output_field
        sp9_1_field_order = 1;

        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP9.1' )), 'etl_batch_id', 'etl_batch_id', sp9_1_field_order, false )
        RETURNING table_output_step_dwid INTO sp9_1_table_output_step_dwid;

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', sp9_1_field_order, false );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'input_filename', 'imported_filename', sp9_1_field_order, false );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'mcr_code', 'mcr_code', sp9_1_field_order, false );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'mcr_description', 'mcr_description', sp9_1_field_order, false );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'sum_of_upb', 'sum_of_upb', sp9_1_field_order, false );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'loan_count', 'loan_count', sp9_1_field_order, false );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', sp9_1_field_order, false );

        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp9_1_table_output_step_dwid, 'report_quarter', 'report_quarter', sp9_1_field_order, false );

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
        WHERE process_dwid IN ( SELECT dwid from mdi.process WHERE name = 'SP9.2' )
        RETURNING process_dwid INTO sp9_2_process_dwid;

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

        sp9_2_field_order = 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'mcr_code', 'mcr_code', sp9_2_field_order, false );

        sp9_2_field_order = sp9_2_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'mcr_description', 'mcr_description', sp9_2_field_order, false );

        sp9_2_field_order = sp9_2_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'total_unpaid_balance', 'sum_of_upb', sp9_2_field_order, false );

        sp9_2_field_order = sp9_2_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'loan_count', 'loan_count', sp9_2_field_order, false );

        sp9_2_field_order = sp9_2_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'average_unpaid_balance', 'avg_loan_size', sp9_2_field_order, false );

        sp9_2_field_order = sp9_2_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'report_quarter', 'report_quarter', sp9_2_field_order, false );

        sp9_2_field_order = sp9_2_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'data_source_dwid', 'data_source_dwid_value', sp9_2_field_order, false );

        sp9_2_field_order = sp9_2_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( ( SELECT dwid FROM mdi.table_output_step WHERE process_dwid = sp9_2_process_dwid ), 'etl_batch_id', 'etl_batch_id', sp9_2_field_order, false );

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
        VALUES ( sp10_1_process_dwid, 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 3 )
        RETURNING dwid INTO sp10_1_csv_file_input_step_dwid;


        -- create new csv_file_input_field records to replace old microsoft_excel_input_field records
        sp10_field_order = 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format, field_length,
                                               field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES
            ( sp10_1_csv_file_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none', sp10_field_order )
            , ( sp10_1_csv_file_input_step_dwid, 'item_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'servicer_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'servicer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'pool_no', 'String', NULL, -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'upb', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'avg_loan_size', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 )
            , ( sp10_1_csv_file_input_step_dwid, 'report_quarter', 'String', '', -1, -1, '$', '.', ',', 'none', sp10_field_order + 1 );


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
        sp10_field_order = 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES
             ( sp10_1_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', sp10_field_order, false )
             , ( sp10_1_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'input_filename', 'imported_filename', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'state', 'state', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'item_id', 'item_id', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'servicer_id', 'servicer_id', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'servicer_name', 'servicer_name', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'pool_no', 'pool_no', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'upb', 'upb', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'loan_count', 'loan_count', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', sp10_field_order + 1, false )
             , ( sp10_1_table_output_step_dwid, 'report_quarter', 'report_quarter', sp10_field_order + 1, false );


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
        sp10_field_order = 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES
            ( sp10_2_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid_value', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'state_type', 'state', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'item_id', 'item_id', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'servicer_nmls_id', 'servicer_id', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'servicer_name', 'servicer_name', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'pool_number', 'pool_no', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'total_unpaid_balance', 'upb', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'loan_count', 'loan_count', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'average_unpaid_balance', 'avg_loan_size', sp10_field_order, false )
            , ( sp10_2_table_output_step_dwid, 'report_quarter', 'report_quarter', sp10_field_order, false );

END $$;
