--
-- EDW | update loan_lender_user_access to use the Octane Username instead of lender_user_pid
-- https://app.asana.com/0/0/1200638045967903
--

--drop existing loan_lender_user_access table, which automatically drops all partitions of that table
DROP TABLE star_loan.loan_lender_user_access;

--re-create loan_lender_user_access with updated structure
CREATE TABLE star_loan.loan_lender_user_access (
    dwid BIGSERIAL NOT NULL,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    octane_username TEXT NOT NULL,
    loan_dwid BIGINT NOT NULL,
    account_pid BIGINT NOT NULL,
    PRIMARY KEY (octane_username, loan_dwid, account_pid)
) PARTITION BY HASH (octane_username, account_pid);

CREATE TABLE star_loan.loan_lender_user_access_0 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 0);

CREATE TABLE star_loan.loan_lender_user_access_1 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 1);

CREATE TABLE star_loan.loan_lender_user_access_2 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 2);

CREATE TABLE star_loan.loan_lender_user_access_3 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 3);

CREATE TABLE star_loan.loan_lender_user_access_4 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 4);

CREATE TABLE star_loan.loan_lender_user_access_5 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 5);

CREATE TABLE star_loan.loan_lender_user_access_6 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 6);

CREATE TABLE star_loan.loan_lender_user_access_7 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 7);

CREATE TABLE star_loan.loan_lender_user_access_8 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 8);

CREATE TABLE star_loan.loan_lender_user_access_9 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 9);

CREATE TABLE star_loan.loan_lender_user_access_10 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 10);

CREATE TABLE star_loan.loan_lender_user_access_11 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 11);

CREATE TABLE star_loan.loan_lender_user_access_12 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 12);

CREATE TABLE star_loan.loan_lender_user_access_13 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 13);

CREATE TABLE star_loan.loan_lender_user_access_14 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 14);

CREATE TABLE star_loan.loan_lender_user_access_15 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 15);

CREATE TABLE star_loan.loan_lender_user_access_16 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 16);

CREATE TABLE star_loan.loan_lender_user_access_17 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 17);

CREATE TABLE star_loan.loan_lender_user_access_18 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 18);

CREATE TABLE star_loan.loan_lender_user_access_19 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 19);

CREATE TABLE star_loan.loan_lender_user_access_20 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 20);

CREATE TABLE star_loan.loan_lender_user_access_21 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 21);

CREATE TABLE star_loan.loan_lender_user_access_22 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 22);

CREATE TABLE star_loan.loan_lender_user_access_23 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 23);

CREATE TABLE star_loan.loan_lender_user_access_24 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 24);

CREATE TABLE star_loan.loan_lender_user_access_25 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 25);

CREATE TABLE star_loan.loan_lender_user_access_26 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 26);

CREATE TABLE star_loan.loan_lender_user_access_27 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 27);

CREATE TABLE star_loan.loan_lender_user_access_28 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 28);

CREATE TABLE star_loan.loan_lender_user_access_29 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 29);

CREATE TABLE star_loan.loan_lender_user_access_30 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 30);

CREATE TABLE star_loan.loan_lender_user_access_31 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 31);

CREATE TABLE star_loan.loan_lender_user_access_32 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 32);

CREATE TABLE star_loan.loan_lender_user_access_33 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 33);

CREATE TABLE star_loan.loan_lender_user_access_34 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 34);

CREATE TABLE star_loan.loan_lender_user_access_35 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 35);

CREATE TABLE star_loan.loan_lender_user_access_36 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 36);

CREATE TABLE star_loan.loan_lender_user_access_37 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 37);

CREATE TABLE star_loan.loan_lender_user_access_38 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 38);

CREATE TABLE star_loan.loan_lender_user_access_39 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 39);

CREATE TABLE star_loan.loan_lender_user_access_40 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 40);

CREATE TABLE star_loan.loan_lender_user_access_41 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 41);

CREATE TABLE star_loan.loan_lender_user_access_42 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 42);

CREATE TABLE star_loan.loan_lender_user_access_43 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 43);

CREATE TABLE star_loan.loan_lender_user_access_44 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 44);

CREATE TABLE star_loan.loan_lender_user_access_45 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 45);

CREATE TABLE star_loan.loan_lender_user_access_46 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 46);

CREATE TABLE star_loan.loan_lender_user_access_47 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 47);

CREATE TABLE star_loan.loan_lender_user_access_48 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 48);

CREATE TABLE star_loan.loan_lender_user_access_49 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 49);

CREATE TABLE star_loan.loan_lender_user_access_50 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 50);

CREATE TABLE star_loan.loan_lender_user_access_51 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 51);

CREATE TABLE star_loan.loan_lender_user_access_52 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 52);

CREATE TABLE star_loan.loan_lender_user_access_53 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 53);

CREATE TABLE star_loan.loan_lender_user_access_54 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 54);

CREATE TABLE star_loan.loan_lender_user_access_55 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 55);

CREATE TABLE star_loan.loan_lender_user_access_56 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 56);

CREATE TABLE star_loan.loan_lender_user_access_57 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 57);

CREATE TABLE star_loan.loan_lender_user_access_58 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 58);

CREATE TABLE star_loan.loan_lender_user_access_59 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 59);

CREATE TABLE star_loan.loan_lender_user_access_60 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 60);

CREATE TABLE star_loan.loan_lender_user_access_61 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 61);

CREATE TABLE star_loan.loan_lender_user_access_62 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 62);

CREATE TABLE star_loan.loan_lender_user_access_63 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 63);

CREATE TABLE star_loan.loan_lender_user_access_64 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 64);

CREATE TABLE star_loan.loan_lender_user_access_65 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 65);

CREATE TABLE star_loan.loan_lender_user_access_66 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 66);

CREATE TABLE star_loan.loan_lender_user_access_67 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 67);

CREATE TABLE star_loan.loan_lender_user_access_68 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 68);

CREATE TABLE star_loan.loan_lender_user_access_69 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 69);

CREATE TABLE star_loan.loan_lender_user_access_70 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 70);

CREATE TABLE star_loan.loan_lender_user_access_71 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 71);

CREATE TABLE star_loan.loan_lender_user_access_72 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 72);

CREATE TABLE star_loan.loan_lender_user_access_73 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 73);

CREATE TABLE star_loan.loan_lender_user_access_74 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 74);

CREATE TABLE star_loan.loan_lender_user_access_75 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 75);

CREATE TABLE star_loan.loan_lender_user_access_76 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 76);

CREATE TABLE star_loan.loan_lender_user_access_77 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 77);

CREATE TABLE star_loan.loan_lender_user_access_78 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 78);

CREATE TABLE star_loan.loan_lender_user_access_79 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 79);

CREATE TABLE star_loan.loan_lender_user_access_80 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 80);

CREATE TABLE star_loan.loan_lender_user_access_81 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 81);

CREATE TABLE star_loan.loan_lender_user_access_82 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 82);

CREATE TABLE star_loan.loan_lender_user_access_83 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 83);

CREATE TABLE star_loan.loan_lender_user_access_84 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 84);

CREATE TABLE star_loan.loan_lender_user_access_85 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 85);

CREATE TABLE star_loan.loan_lender_user_access_86 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 86);

CREATE TABLE star_loan.loan_lender_user_access_87 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 87);

CREATE TABLE star_loan.loan_lender_user_access_88 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 88);

CREATE TABLE star_loan.loan_lender_user_access_89 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 89);

CREATE TABLE star_loan.loan_lender_user_access_90 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 90);

CREATE TABLE star_loan.loan_lender_user_access_91 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 91);

CREATE TABLE star_loan.loan_lender_user_access_92 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 92);

CREATE TABLE star_loan.loan_lender_user_access_93 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 93);

CREATE TABLE star_loan.loan_lender_user_access_94 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 94);

CREATE TABLE star_loan.loan_lender_user_access_95 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 95);

CREATE TABLE star_loan.loan_lender_user_access_96 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 96);

CREATE TABLE star_loan.loan_lender_user_access_97 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 97);

CREATE TABLE star_loan.loan_lender_user_access_98 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 98);

CREATE TABLE star_loan.loan_lender_user_access_99 PARTITION OF star_loan.loan_lender_user_access
    FOR VALUES WITH (MODULUS 100, REMAINDER 99);

--
-- EDW | Add missing tables and fields to mdi schema metadata tables, drop deprecated fields from star_loan schema
-- https://app.asana.com/0/0/1200689348642534
--

ALTER TABLE star_loan.loan_beneficiary_dim
    DROP COLUMN collateral_tracking_number;
ALTER TABLE star_loan.loan_dim
    DROP COLUMN collateral_tracking_number,
    DROP COLUMN loan_file_tracking_number;