
alter table encompass.encompass_loan_raw add elr_closing_disclosure_sent_date timestamp;
alter table encompass.encompass_loan_raw add elr_closing_disclosure_received_date timestamp;
alter table encompass.encompass_loan_raw add elr_revised_closing_disclosure_sent_date timestamp;
alter table encompass.encompass_loan_raw add elr_revised_closing_disclosure_received_date timestamp;
alter table encompass.encompass_loan_raw add elr_total_broker_fees_collected_amount numeric(17,2);
alter table encompass.encompass_loan_raw add elr_total_lender_fees_collected numeric(17,2);
alter table encompass.encompass_loan_raw add elr_purchasing_beneficiary_investor_name text;

alter table encompass.encompass_loan_raw_error add elr_closing_disclosure_sent_date text;
alter table encompass.encompass_loan_raw_error add elr_closing_disclosure_received_date text;
alter table encompass.encompass_loan_raw_error add elr_revised_closing_disclosure_sent_date text;
alter table encompass.encompass_loan_raw_error add elr_revised_closing_disclosure_received_date text;
alter table encompass.encompass_loan_raw_error add elr_total_broker_fees_collected_amount text;
alter table encompass.encompass_loan_raw_error add elr_total_lender_fees_collected text;
alter table encompass.encompass_loan_raw_error add elr_purchasing_beneficiary_investor_name text;
