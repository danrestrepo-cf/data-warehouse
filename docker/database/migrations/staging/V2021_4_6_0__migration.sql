--
-- EDW | alter all BIT columns in staging_octane and history_octane to data type boolean
-- (https://app.asana.com/0/0/1200241170329568)
--

DO $$
    DECLARE
        bits RECORD;
    BEGIN
        FOR bits IN
            SELECT table_schema
                 , table_name
                 , column_name
            FROM information_schema.columns
            WHERE table_schema IN ('staging_octane', 'history_octane')
              AND data_type = 'bit'
            LOOP
                EXECUTE 'ALTER TABLE ' || bits.table_schema || '.' || bits.table_name || ' ALTER COLUMN ' || bits.column_name ||
                        ' TYPE BOOLEAN USING ' || bits.column_name || '::INT::BOOLEAN';
            END LOOP;
    END $$;
