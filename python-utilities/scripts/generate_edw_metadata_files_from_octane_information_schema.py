"""Generate and store YAML files containing metadata related to staging_octane and history_octane schemas.

This script reads table, column, and foreign key information from both Octane
and EDW information_schemas and synthesizes it into a series of YAML files, which
are then saved in the /metadata directory in the data-warehouse repo.
"""
import sys
import os
import argparse

import constants

# this line allows the script to import directly from lib when run from the command line
sys.path.append(constants.PROJECT_DIR_PATH)

from lib.db_connections import DBConnectionFactory
from lib.metadata_core.metadata_filter import ExclusiveMetadataFilterer
from lib.metadata_core.metadata_object_path import TablePath, ColumnPath
from lib.metadata_core.metadata_yaml_translator import write_data_warehouse_metadata_to_yaml
from lib.lura_information_schema_to_yaml.sql_queries import (get_octane_column_metadata,
                                                             get_octane_foreign_key_metadata,
                                                             get_history_octane_etl_process_metadata,
                                                             get_history_octane_metadata_for_deleted_columns,
                                                             get_max_staging_to_history_server_process_number)
from lib.lura_information_schema_to_yaml.metadata_builders import (build_staging_octane_metadata,
                                                                   generate_history_octane_metadata,
                                                                   add_deleted_tables_and_columns_to_history_octane_metadata)


def main():
    # parse command line arguments
    argparser = argparse.ArgumentParser(description='Generate EDW metadata YAML files from Octane information schema')
    argparser.add_argument(
        '--output_dir',
        type=str,
        default=os.path.abspath(os.path.join(constants.PROJECT_DIR_PATH, '..', 'metadata')),
        help='the directory in which to output the generated YAML files. Defaults to data-warehouse/metadata.'
    )
    args = argparser.parse_args()

    try:
        # establish database connections
        connection_factory = DBConnectionFactory()
        octane_db_connection = connection_factory.get_connection('octane-local')
        config_edw_connection = connection_factory.get_connection('edw-local-config')
        staging_edw_connection = connection_factory.get_connection('edw-local-staging')

        # pull source data
        octane_column_metadata = get_octane_column_metadata(octane_db_connection)
        octane_foreign_key_metadata = get_octane_foreign_key_metadata(octane_db_connection)
        etl_process_metadata = get_history_octane_etl_process_metadata(config_edw_connection)
        current_max_process_number = get_max_staging_to_history_server_process_number(config_edw_connection)
        deleted_columns_metadata = get_history_octane_metadata_for_deleted_columns(staging_edw_connection) # this isn't deleted columns, this is all columns from history_octane in information_schema

        # build metadata filterer
        metadata_filterer = build_octane_metadata_filterer()

        # generate metadata
        metadata = add_deleted_tables_and_columns_to_history_octane_metadata(
            generate_history_octane_metadata( # this generates what will be the new history_octane metadata from octane's metadata
                metadata_filterer.filter(
                    build_staging_octane_metadata(
                        octane_column_metadata,
                        octane_foreign_key_metadata
                    )
                ),
                etl_process_metadata,
                current_max_process_number
            ),
            deleted_columns_metadata
        )

        # write metadata to YAML
        write_data_warehouse_metadata_to_yaml(args.output_dir, metadata, rebuild_table_files=True)

        print(f'"{metadata.name}" data warehouse metadata YAML files written successfully in {args.output_dir}')

    except DBConnectionFactory.InvalidConnectionNameError as e:
        print(f'Error: {e}')
        exit(1)


def build_octane_metadata_filterer() -> ExclusiveMetadataFilterer:
    """Construct a MetadataFilterer that *excludes* any sensitive tables/columns from this script's output."""
    metadata_filterer = ExclusiveMetadataFilterer()
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'QRTZ*'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', '*_old'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', '*_new'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'schema_version'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'lura_setting'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'schema_version_post_data'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'schema_version_pre_data'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'borrower_user_reset_password'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'lender_user_reset_password'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'company_service_credentials'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'lender_user_service_credentials'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'restricted_password'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'admin_user', 'au_password'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'admin_user', 'au_previous_password_1'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'admin_user', 'au_previous_password_2'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'admin_user', 'au_previous_password_3'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'admin_user', 'au_mobile_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'admin_user', 'au_backup_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'admin_user', 'au_secret_key'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'asset', 'as_account_id'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'asset', 'as_gift_funds_source_account_id'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'borrower', 'b_borrower_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'borrower_tax_filing', 'btf_joint_filer_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'borrower_user', 'bu_password'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'borrower_user', 'bu_backup_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'borrower_user', 'bu_mobile_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'borrower_user', 'bu_secret_key'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'borrower_va', 'bva_deceased_spouse_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'credit_request', 'crdr_borrower1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'credit_request', 'crdr_borrower2_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'credit_request_liability', 'crl_report_account_id'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'du_request_credit', 'durc_borrower_1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'du_request_credit', 'durc_borrower_2_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_reimbursement_wire_routing_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_reimbursement_wire_account_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_return_wire_routing_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_return_wire_account_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lead', 'ld_borrower_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lead', 'ld_coborrower_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_challenge_question_answer'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_mobile_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_password'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_previous_password_1'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_previous_password_2'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_previous_password_3'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_backup_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_secret_key'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'liability', 'lia_account_id'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'liability', 'lia_report_account_id'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lp_request_credit', 'lprc_borrower_1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lp_request_credit', 'lprc_borrower_2_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'proposal_summary', 'ps_b1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'proposal_summary', 'ps_c1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'proposal_summary', 'ps_b2_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'settlement_agent_wire', 'saw_bank_aba'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'settlement_agent_wire', 'saw_bank_account_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'settlement_agent_wire', 'saw_beneficiary_bank_aba'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'settlement_agent_wire', 'saw_beneficiary_bank_account_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'tax_transcript_request', 'ttr_borrower1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'tax_transcript_request', 'ttr_borrower2_ssn'))
    return metadata_filterer


if __name__ == '__main__':
    main()
