---
--- Add Encompass MCR related fields to EDW: https://app.asana.com/0/0/1193468447043569
---

-- add fields to encompass_loan_raw
alter table encompass.encompass_loan_raw add elr_closing_disclosure_sent_date timestamp;
alter table encompass.encompass_loan_raw add elr_closing_disclosure_received_date timestamp;
alter table encompass.encompass_loan_raw add elr_revised_closing_disclosure_sent_date timestamp;
alter table encompass.encompass_loan_raw add elr_revised_closing_disclosure_received_date timestamp;
alter table encompass.encompass_loan_raw add elr_total_broker_fees_collected_amount numeric(17,2);
alter table encompass.encompass_loan_raw add elr_total_lender_fees_collected numeric(17,2);
alter table encompass.encompass_loan_raw add elr_purchasing_beneficiary_investor_name text;
-- add fields to encompass_loan_raw_error
alter table encompass.encompass_loan_raw_error add elr_closing_disclosure_sent_date text;
alter table encompass.encompass_loan_raw_error add elr_closing_disclosure_received_date text;
alter table encompass.encompass_loan_raw_error add elr_revised_closing_disclosure_sent_date text;
alter table encompass.encompass_loan_raw_error add elr_revised_closing_disclosure_received_date text;
alter table encompass.encompass_loan_raw_error add elr_total_broker_fees_collected_amount text;
alter table encompass.encompass_loan_raw_error add elr_total_lender_fees_collected text;
alter table encompass.encompass_loan_raw_error add elr_purchasing_beneficiary_investor_name text;
