--
-- EDW | metadata - update YAMLs and python-utilities scripts to accommodate "per partition" ETLs
-- https://app.asana.com/0/0/1201843492068511
--

/*
 This update statement was manually written to avoid the *massive* auto-generated
 config migration file that would have resulted otherwise. The python-utilities
 metadata maintenance process treats process name as the process table's natural
 key, and would have been able to update process names in place in this way. This
 would result it *new* process records being inserted for *all* EDW ETLs, and because
 process name is part of the natural key of pretty much all ETL-related tables, this
 would cascade into an unnecessary near-total data replacement for the entire config.mdi
 schema.

 This statement only targets processes with a six-digit process number (i.e. EDW ETLs).
 Test ETLs and others (like warehouse banks) are unaffected.
 */
UPDATE mdi.process
SET name = REPLACE( name, 'SP-', 'ETL-' )
WHERE process.name LIKE 'SP-______%';

-- auto-generated config.mdi changes listed below

/*
UPDATES
*/

--process
WITH update_rows (process_name, process_description) AS (
    VALUES ('ETL-200001-delete-0', 'ETL to delete records from staging.star_loan.loan_lender_user_access_0 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-1', 'ETL to delete records from staging.star_loan.loan_lender_user_access_1 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-2', 'ETL to delete records from staging.star_loan.loan_lender_user_access_2 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-3', 'ETL to delete records from staging.star_loan.loan_lender_user_access_3 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-4', 'ETL to delete records from staging.star_loan.loan_lender_user_access_4 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-5', 'ETL to delete records from staging.star_loan.loan_lender_user_access_5 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-6', 'ETL to delete records from staging.star_loan.loan_lender_user_access_6 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-7', 'ETL to delete records from staging.star_loan.loan_lender_user_access_7 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-8', 'ETL to delete records from staging.star_loan.loan_lender_user_access_8 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-9', 'ETL to delete records from staging.star_loan.loan_lender_user_access_9 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-10', 'ETL to delete records from staging.star_loan.loan_lender_user_access_10 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-11', 'ETL to delete records from staging.star_loan.loan_lender_user_access_11 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-12', 'ETL to delete records from staging.star_loan.loan_lender_user_access_12 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-13', 'ETL to delete records from staging.star_loan.loan_lender_user_access_13 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-14', 'ETL to delete records from staging.star_loan.loan_lender_user_access_14 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-15', 'ETL to delete records from staging.star_loan.loan_lender_user_access_15 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-16', 'ETL to delete records from staging.star_loan.loan_lender_user_access_16 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-17', 'ETL to delete records from staging.star_loan.loan_lender_user_access_17 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-18', 'ETL to delete records from staging.star_loan.loan_lender_user_access_18 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-19', 'ETL to delete records from staging.star_loan.loan_lender_user_access_19 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-20', 'ETL to delete records from staging.star_loan.loan_lender_user_access_20 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-21', 'ETL to delete records from staging.star_loan.loan_lender_user_access_21 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-22', 'ETL to delete records from staging.star_loan.loan_lender_user_access_22 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-23', 'ETL to delete records from staging.star_loan.loan_lender_user_access_23 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-24', 'ETL to delete records from staging.star_loan.loan_lender_user_access_24 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-25', 'ETL to delete records from staging.star_loan.loan_lender_user_access_25 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-26', 'ETL to delete records from staging.star_loan.loan_lender_user_access_26 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-27', 'ETL to delete records from staging.star_loan.loan_lender_user_access_27 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-28', 'ETL to delete records from staging.star_loan.loan_lender_user_access_28 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-29', 'ETL to delete records from staging.star_loan.loan_lender_user_access_29 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-30', 'ETL to delete records from staging.star_loan.loan_lender_user_access_30 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-31', 'ETL to delete records from staging.star_loan.loan_lender_user_access_31 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-32', 'ETL to delete records from staging.star_loan.loan_lender_user_access_32 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-33', 'ETL to delete records from staging.star_loan.loan_lender_user_access_33 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-34', 'ETL to delete records from staging.star_loan.loan_lender_user_access_34 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-35', 'ETL to delete records from staging.star_loan.loan_lender_user_access_35 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-36', 'ETL to delete records from staging.star_loan.loan_lender_user_access_36 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-37', 'ETL to delete records from staging.star_loan.loan_lender_user_access_37 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-38', 'ETL to delete records from staging.star_loan.loan_lender_user_access_38 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-39', 'ETL to delete records from staging.star_loan.loan_lender_user_access_39 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-40', 'ETL to delete records from staging.star_loan.loan_lender_user_access_40 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-41', 'ETL to delete records from staging.star_loan.loan_lender_user_access_41 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-42', 'ETL to delete records from staging.star_loan.loan_lender_user_access_42 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-43', 'ETL to delete records from staging.star_loan.loan_lender_user_access_43 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-44', 'ETL to delete records from staging.star_loan.loan_lender_user_access_44 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-45', 'ETL to delete records from staging.star_loan.loan_lender_user_access_45 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-46', 'ETL to delete records from staging.star_loan.loan_lender_user_access_46 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-47', 'ETL to delete records from staging.star_loan.loan_lender_user_access_47 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-48', 'ETL to delete records from staging.star_loan.loan_lender_user_access_48 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-49', 'ETL to delete records from staging.star_loan.loan_lender_user_access_49 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-50', 'ETL to delete records from staging.star_loan.loan_lender_user_access_50 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-51', 'ETL to delete records from staging.star_loan.loan_lender_user_access_51 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-52', 'ETL to delete records from staging.star_loan.loan_lender_user_access_52 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-53', 'ETL to delete records from staging.star_loan.loan_lender_user_access_53 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-54', 'ETL to delete records from staging.star_loan.loan_lender_user_access_54 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-55', 'ETL to delete records from staging.star_loan.loan_lender_user_access_55 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-56', 'ETL to delete records from staging.star_loan.loan_lender_user_access_56 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-57', 'ETL to delete records from staging.star_loan.loan_lender_user_access_57 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-58', 'ETL to delete records from staging.star_loan.loan_lender_user_access_58 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-59', 'ETL to delete records from staging.star_loan.loan_lender_user_access_59 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-60', 'ETL to delete records from staging.star_loan.loan_lender_user_access_60 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-61', 'ETL to delete records from staging.star_loan.loan_lender_user_access_61 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-62', 'ETL to delete records from staging.star_loan.loan_lender_user_access_62 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-63', 'ETL to delete records from staging.star_loan.loan_lender_user_access_63 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-64', 'ETL to delete records from staging.star_loan.loan_lender_user_access_64 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-65', 'ETL to delete records from staging.star_loan.loan_lender_user_access_65 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-66', 'ETL to delete records from staging.star_loan.loan_lender_user_access_66 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-67', 'ETL to delete records from staging.star_loan.loan_lender_user_access_67 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-68', 'ETL to delete records from staging.star_loan.loan_lender_user_access_68 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-69', 'ETL to delete records from staging.star_loan.loan_lender_user_access_69 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-70', 'ETL to delete records from staging.star_loan.loan_lender_user_access_70 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-71', 'ETL to delete records from staging.star_loan.loan_lender_user_access_71 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-72', 'ETL to delete records from staging.star_loan.loan_lender_user_access_72 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-73', 'ETL to delete records from staging.star_loan.loan_lender_user_access_73 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-74', 'ETL to delete records from staging.star_loan.loan_lender_user_access_74 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-75', 'ETL to delete records from staging.star_loan.loan_lender_user_access_75 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-76', 'ETL to delete records from staging.star_loan.loan_lender_user_access_76 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-77', 'ETL to delete records from staging.star_loan.loan_lender_user_access_77 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-78', 'ETL to delete records from staging.star_loan.loan_lender_user_access_78 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-79', 'ETL to delete records from staging.star_loan.loan_lender_user_access_79 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-80', 'ETL to delete records from staging.star_loan.loan_lender_user_access_80 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-81', 'ETL to delete records from staging.star_loan.loan_lender_user_access_81 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-82', 'ETL to delete records from staging.star_loan.loan_lender_user_access_82 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-83', 'ETL to delete records from staging.star_loan.loan_lender_user_access_83 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-84', 'ETL to delete records from staging.star_loan.loan_lender_user_access_84 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-85', 'ETL to delete records from staging.star_loan.loan_lender_user_access_85 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-86', 'ETL to delete records from staging.star_loan.loan_lender_user_access_86 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-87', 'ETL to delete records from staging.star_loan.loan_lender_user_access_87 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-88', 'ETL to delete records from staging.star_loan.loan_lender_user_access_88 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-89', 'ETL to delete records from staging.star_loan.loan_lender_user_access_89 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-90', 'ETL to delete records from staging.star_loan.loan_lender_user_access_90 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-91', 'ETL to delete records from staging.star_loan.loan_lender_user_access_91 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-92', 'ETL to delete records from staging.star_loan.loan_lender_user_access_92 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-93', 'ETL to delete records from staging.star_loan.loan_lender_user_access_93 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-94', 'ETL to delete records from staging.star_loan.loan_lender_user_access_94 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-95', 'ETL to delete records from staging.star_loan.loan_lender_user_access_95 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-96', 'ETL to delete records from staging.star_loan.loan_lender_user_access_96 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-97', 'ETL to delete records from staging.star_loan.loan_lender_user_access_97 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-98', 'ETL to delete records from staging.star_loan.loan_lender_user_access_98 using staging.history_octane.deal_lender_user as the primary source')
         , ('ETL-200001-delete-99', 'ETL to delete records from staging.star_loan.loan_lender_user_access_99 using staging.history_octane.deal_lender_user as the primary source')
)
UPDATE mdi.process
SET description = update_rows.process_description
FROM update_rows
WHERE update_rows.process_name = process.name;
