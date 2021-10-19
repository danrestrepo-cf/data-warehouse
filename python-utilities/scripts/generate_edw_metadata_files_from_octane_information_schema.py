import sys
import os

from lib.db_connections import OctaneDBConnection, LocalEDWConnection
from lib.metadata_core.metadata_filter import ExclusiveMetadataFilterer
from lib.metadata_core.metadata_object_path import TablePath, ColumnPath
from lib.metadata_core.metadata_yaml_translator import write_data_warehouse_metadata_to_yaml
from lib.lura_information_schema_to_yaml.sql_queries import (get_octane_column_metadata,
                                                             get_octane_foreign_key_metadata,
                                                             get_etl_process_metadata,
                                                             get_history_octane_metadata_for_deleted_columns)
from lib.lura_information_schema_to_yaml.metadata_builders import (build_staging_octane_metadata,
                                                                   generate_history_octane_metadata,
                                                                   add_deleted_tables_and_columns_to_history_octane_metadata)


def main():
    # validate and parse command line arguments
    if len(sys.argv) != 2:
        print('usage: python generate_edw_metadata_files.py [ssl_ca_filepath]')
        print()
        print('A valid AWS ssl certificate can be downloaded at the following link, ' +
              'provided you are already authenticated with AWS:')
        print('https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem')
        exit(1)
    ssl_ca_filepath = sys.argv[1]
    if not os.path.isfile(ssl_ca_filepath):
        print(f'Error: invalid ssl_ca_filepath "{ssl_ca_filepath}"')
        exit(1)

    output_parent_dir = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'metadata'))

    # establish database connections
    octane_db_connection = OctaneDBConnection(
        host="cert-lura-db.cluster-ro-c67hguplwubq.us-east-1.rds.amazonaws.com",
        dbname="lura_qa",
        region="us-east-1",
        user="engineer.readonly",
        port="3306",
        profile_name="octane-database-readonly",
        ssl_ca_filepath=ssl_ca_filepath
    )
    config_edw_connection = LocalEDWConnection(
        host='localhost',
        dbname='config',
        user='postgres',
        password='testonly'
    )
    staging_edw_connection = LocalEDWConnection(
        host='localhost',
        dbname='staging',
        user='postgres',
        password='testonly'
    )

    # pull source data
    octane_column_metadata = get_octane_column_metadata(octane_db_connection)
    octane_foreign_key_metadata = get_octane_foreign_key_metadata(octane_db_connection)
    etl_process_metadata = get_etl_process_metadata(config_edw_connection)
    deleted_columns_metadata = get_history_octane_metadata_for_deleted_columns(staging_edw_connection)

    # build metadata filterer
    metadata_filterer = build_octane_metadata_filterer()

    # generate metadata
    metadata = add_deleted_tables_and_columns_to_history_octane_metadata(
        generate_history_octane_metadata(
            metadata_filterer.filter(
                build_staging_octane_metadata(
                    octane_column_metadata,
                    octane_foreign_key_metadata
                )
            ),
            etl_process_metadata
        ),
        deleted_columns_metadata
    )

    # write metadata to YAML
    write_data_warehouse_metadata_to_yaml(output_parent_dir, metadata, rebuild_table_files=True)


def build_octane_metadata_filterer() -> ExclusiveMetadataFilterer:
    metadata_filterer = ExclusiveMetadataFilterer()
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'QRTZ*'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'schema_version'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'schema_version_post_data'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'schema_version_pre_data'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'borrower_user_reset_password'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'lender_user_reset_password'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'company_service_credentials'))
    metadata_filterer.add_table_criteria(TablePath('staging', 'staging_octane', 'lender_user_service_credentials'))
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
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'du_request_credit', 'durc_borrower_1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'du_request_credit', 'durc_borrower_2_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_reimbursement_wire_routing_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_reimbursement_wire_account_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_return_wire_routing_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'interim_funder', 'if_return_wire_account_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lead', 'ld_borrower_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lead', 'ld_coborrower_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_mobile_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_password'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_previous_password_1'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_previous_password_2'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_previous_password_3'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_backup_phone'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_secret_key'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_challenge_question_type'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'lender_user', 'lu_challenge_question_answer'))
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
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'settlement_agent_wire', 'saw_beneficiary_account_number'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'tax_transcript_request', 'ttr_borrower1_ssn'))
    metadata_filterer.add_column_criteria(ColumnPath('staging', 'staging_octane', 'tax_transcript_request', 'ttr_borrower2_ssn'))
    return metadata_filterer


if __name__ == '__main__':
    main()
