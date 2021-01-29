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
        VALUES ( sp01_process_dwid, 'Y', ',', '"', 1024, 'N', 'Y', 'N', 'mixed', 'UTF-8', 'N', 'N', '', '', 0 )
        RETURNING dwid INTO sp01_csv_file_input_step_dwid;


        -- csv_file_input_field
        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'imported_filename', 'String', '', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'state', 'String', '', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'item_id', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'servicer_id', 'Integer', '', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'servicer_name', 'String', '', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'pool_no', 'String', '', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'upb', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'loan_count', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'avg_loan_size', 'Integer', '#', -1, -1, '$', '.', ',', 'none', sp01_field_order );

        sp01_field_order = sp01_field_order + 1;

        INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                             , field_length, field_precision, field_currency, field_decimal, field_group
                                             , field_trim_type, field_order )
        VALUES ( sp01_csv_file_input_step_dwid, 'report_quarter', 'String', '', -1, -1, '$', '.', ',', 'none', sp01_field_order );


        -- table_output_step
        INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                          , table_name_field, auto_generated_key_field, partition_data_per
                                          , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                          , connectionname, partition_over_tables, specify_database_fields
                                          , ignore_insert_errors, use_batch_update )
        VALUES ( sp01_process_dwid, 'test', 'sp_01', 1000, '', '', '', '', 'N', '', 'Y', 'Ingress DB Connection', 'N'
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
        VALUES ( sp02_process_dwid, 'POI', '*', '', 'Y', 'N', 'SP-0.1', 0, 0, 0 )
        RETURNING dwid INTO sp02_microsoft_excel_input_step_dwid;


        -- microsoft_excel_input_field
        sp02_field_order = 1;
        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'imported_filename', 'String', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'state', 'String', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'item_id', 'Integer', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'servicer_id', 'Integer', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'servicer_name', 'String', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'pool_no', 'String', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'upb', 'Integer', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'loan_count', 'Integer', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'avg_loan_size', 'Integer', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );

        sp02_field_order = sp02_field_order + 1;

        INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
        VALUES ( sp02_microsoft_excel_input_step_dwid, 'report_quarter', 'String', '', -1, -1, '$', '.', ',', 'none', sp02_field_order );


        -- table_output_step
        INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                          , table_name_field, auto_generated_key_field, partition_data_per
                                          , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                          , connectionname, partition_over_tables, specify_database_fields
                                          , ignore_insert_errors, use_batch_update )
        VALUES ( sp02_process_dwid, 'test', 'sp_02', 1000, '', '', '', '', 'N', '', 'Y', 'Ingress DB Connection', 'N'
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

    END $$;
