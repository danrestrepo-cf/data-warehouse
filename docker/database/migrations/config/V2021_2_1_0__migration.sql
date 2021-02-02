-- remove filename columns from CSV and Excel input step configuration tables
ALTER TABLE mdi.csv_file_input_step DROP COLUMN filename;
ALTER TABLE mdi.microsoft_excel_input_step DROP COLUMN filename;

DO $$
    DECLARE sp01_process_dwid BIGINT;
        DECLARE sp01_csv_file_input_step_dwid BIGINT;
        DECLARE sp01_table_output_step_dwid BIGINT;
        DECLARE sp01_field_order NUMERIC = 1;
        DECLARE sp02_process_dwid BIGINT;
        DECLARE sp02_microsoft_excel_input_step_dwid BIGINT;
        DECLARE sp02_table_output_step_dwid BIGINT;
        DECLARE sp02_field_order INTEGER = 1;

    BEGIN
        --
        -- SP-0.1
        --

        -- process
        INSERT INTO mdi.process ( name, description )
        VALUES ( 'SP-0.1', 'Test CSV File Input -> Table Output' )
        RETURNING dwid INTO sp01_process_dwid;


        -- csv_file_input_step
        INSERT INTO mdi.csv_file_input_step ( process_dwid, header_present, delimiter, enclosure, buffersize
                                            , lazy_conversion, newline_possible, add_filename_result, file_format
                                            , file_encoding, include_filename
                                            , process_in_parallel, filename_field, row_num_field, data_source_dwid )
        VALUES ( sp01_process_dwid, 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 0 )
        RETURNING dwid INTO sp01_csv_file_input_step_dwid;


        -- csv_file_input_field
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'item_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'servicer_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'servicer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'pool_no', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'upb', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'avg_loan_size', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'report_quarter', 'String', '', -1, -1, '$', '.', ',', 'none'
               , sp01_field_order );


        -- table_output_step
        INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                          , table_name_field, auto_generated_key_field, partition_data_per
                                          , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                          , connectionname, partition_over_tables, specify_database_fields
                                          , ignore_insert_errors, use_batch_update )
        VALUES ( sp01_process_dwid, 'test', 'sp_01', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y'
               , 'Ingress DB Connection', 'N'
               , 'Y', 'N', 'N' )
        RETURNING dwid INTO sp01_table_output_step_dwid;


        -- table_output_field
        sp01_field_order = 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'imported_filename', 'imported_filename', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'state', 'state', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'item_id', 'item_id', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'servicer_id', 'servicer_id', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'servicer_name', 'servicer_name', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'pool_no', 'pool_no', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'upb', 'upb', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'loan_count', 'loan_count', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'report_quarter', 'report_quarter', sp01_field_order, false );

        sp01_field_order = sp01_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp01_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', sp01_field_order, false );


        --
        -- SP-0.2
        --

        -- process
        INSERT INTO mdi.process ( name, description )
        VALUES ( 'SP-0.2', 'Test Microsoft Excel Input -> Table Output' )
        RETURNING dwid INTO sp02_process_dwid;


        -- microsoft_excel_input_step
        INSERT INTO mdi.microsoft_excel_input_step ( process_dwid, spreadsheet_type, filemask, exclude_filemask
                                                   , file_required, include_subfolders, sheet_name, sheet_start_row
                                                   , sheet_start_col, data_source_dwid )
        VALUES ( sp02_process_dwid, 'POI', '*', NULL, 'Y', 'N', 'SP-0.2', 1, 0, 0 )
        RETURNING dwid INTO sp02_microsoft_excel_input_step_dwid;


        -- microsoft_excel_input_field
        sp02_field_order = 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'item_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'servicer_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'servicer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'pool_no', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'upb', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'avg_loan_size', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type
                                                    , field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'report_quarter', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp02_field_order );


        -- table_output_step
        INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                          , table_name_field, auto_generated_key_field, partition_data_per
                                          , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                          , connectionname, partition_over_tables, specify_database_fields
                                          , ignore_insert_errors, use_batch_update )
        VALUES ( sp02_process_dwid, 'test', 'sp_02', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y', 'Ingress DB Connection', 'N'
               , 'Y', 'N', 'N' )
        RETURNING dwid INTO sp02_table_output_step_dwid;


        -- table_output_field
        sp02_field_order = 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'imported_filename', 'imported_filename', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'state', 'state', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'item_id', 'item_id', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'servicer_id', 'servicer_id', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'servicer_name', 'servicer_name', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'pool_no', 'pool_no', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'upb', 'upb', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'loan_count', 'loan_count', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'avg_loan_size', 'avg_loan_size', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'report_quarter', 'report_quarter', sp02_field_order, false );

        sp02_field_order = sp02_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( sp02_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', sp02_field_order, false );

    END $$;

DO $$
    DECLARE sp10_1_csv_file_input_step_dwid BIGINT;
    DECLARE sp10_1_table_output_step_dwid BIGINT;
    DECLARE sp10_1_field_order NUMERIC = (select max(field_order) + 1 from mdi.table_output_field where table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP10.1')));

    DECLARE sp9_1_field_order NUMERIC = (select max(field_order) + 1 from mdi.table_output_field where table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP9.1')));
    DECLARE sp9_1_table_output_step_dwid BIGINT;

    DECLARE sp8_1_field_order NUMERIC = (select max(field_order) + 1 from mdi.table_output_field where table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP8.1')));
    DECLARE sp8_1_table_output_step_dwid BIGINT;

    BEGIN
        --
        -- SP10.1
        --

        -- create new csv_file_input_step record to replace old microsoft_excel_input_step record
        INSERT INTO mdi.csv_file_input_step ( process_dwid, header_present, delimiter, enclosure, buffersize
                                            , lazy_conversion, newline_possible, add_filename_result, file_format
                                            , file_encoding, include_filename
                                            , process_in_parallel, filename_field, row_num_field, data_source_dwid )
        VALUES ( (SELECT dwid FROM mdi.process WHERE name = 'SP10.1'), 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 0 )
        RETURNING dwid INTO sp10_1_csv_file_input_step_dwid;

        -- delete old microsoft_excel_input_step record
        DELETE FROM mdi.microsoft_excel_input_step WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP10.1');

        -- create new csv_file_input_field records to replace old microsoft_excel_input_field records
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'item_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'servicer_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'servicer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'pool_no', 'String', NULL, -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'upb', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'loan_count ', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'avg_loan_size', 'Integer', '#', -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp10_1_csv_file_input_step_dwid, 'report_quarter', 'String', '', -1, -1, '$', '.', ',', 'none'
               , sp10_1_field_order );

        -- delete old microsoft_excel_input_field records
        DELETE FROM
            mdi.microsoft_excel_input_field
        WHERE
            microsoft_excel_input_step_dwid IN (SELECT
                                                    dwid
                                                FROM
                                                    mdi.microsoft_excel_input_step
                                                WHERE process_dwid IN (SELECT
                                                                           dwid
                                                                        FROM mdi.process
                                                                        WHERE name = 'SP10.1'));


        -- create new table_output_field records for added columns: report_quarter and imported_filename
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP10.1')), 'report_quarter', 'report_quarter', sp10_1_field_order, false );

        sp10_1_field_order = sp10_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP10.1')), 'imported_filename', 'imported_filename', sp10_1_field_order, false );

        -- update table_output_field_records for renamed fields
        UPDATE mdi.table_output_field
        SET
            database_stream_name='state'
                AND database_field_name='state'
        WHERE table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step
                                         WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP10.1' ))
            AND database_stream_name = 'state_type' and database_field_name = 'state_type'
        RETURNING table_output_step_dwid INTO sp10_1_table_output_step_dwid;


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name='pool_no'
                AND database_field_name='pool_no'
        WHERE table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step
                                         WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP10.1' ))
            AND database_stream_name = 'pool_number' and database_field_name = 'pool_number';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name='upb'
                AND database_field_name='upb'
        WHERE table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step
                                         WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP10.1' ))
            AND database_stream_name = 'unpaid_balance' and database_field_name = 'unpaid_balance';

        -- 
        -- SP9.1
        -- 

        -- update table_output_field records for renamed fields
        UPDATE
            mdi.table_output_field
        SET
            database_stream_name='sum_of_upb'
                AND database_field_name='sum_of_upb'
        WHERE table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step
                                         WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP9.1' ))
            AND database_stream_name = 'unpaid_balance' and database_field_name = 'unpaid_balance'
        RETURNING table_output_step_dwid INTO sp9_1_table_output_step_dwid;


        UPDATE mdi.table_output_field
        SET
            database_stream_name='mcr_description'
                AND database_field_name='mcr_description'
        WHERE table_output_step_dwid = sp9_1_table_output_step_dwid
            AND database_stream_name = 'mcr_desc'
            AND database_field_name = 'mcr_desc';


        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP9.1')), 'report_quarter', 'report_quarter', sp9_1_field_order, false );


        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP9.1')), 'input_filename', 'imported_filename', sp9_1_field_order, false );


        --
        -- SP8.1
        --

        -- update table_output_field_records for renamed fields
        UPDATE
            mdi.table_output_field
        SET
            database_stream_name='state_code'
            AND database_field_name='state_code'
        WHERE table_output_step_dwid IN (SELECT dwid FROM mdi.table_output_step
                                         WHERE process_dwid IN (SELECT dwid FROM mdi.process WHERE name = 'SP8.1' ))
            AND database_stream_name = 'state_type'
            AND database_field_name = 'state_type'
        RETURNING table_output_step_dwid INTO sp8_1_table_output_step_dwid;


        UPDATE mdi.table_output_field
        SET
            database_stream_name='mcr_description'
            AND database_field_name='mcr_description'
        WHERE table_output_step_dwid = sp8_1_table_output_step_dwid
          AND database_stream_name = 'mcr_desc'
          AND database_field_name = 'mcr_desc';


        UPDATE
            mdi.table_output_field
        SET
            database_stream_name='sum_of_upb'
            AND database_field_name='sum_of_upb'
        WHERE table_output_step_dwid = sp8_1_table_output_step_dwid
            AND database_stream_name = 'unpaid_balance'
            AND database_field_name = 'unpaid_balance';


        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP8.1')), 'report_quarter', 'report_quarter', sp8_1_field_order, false );


        sp9_1_field_order = sp9_1_field_order + 1;
        INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name
                                           , field_order, is_sensitive )
        VALUES ( (SELECT dwid FROM mdi.table_output_step WHERE process_dwid IN (SELECT dwid from mdi.process WHERE name = 'SP8.1')), 'input_filename', 'imported_filename', sp8_1_field_order, false );

    END $$;
