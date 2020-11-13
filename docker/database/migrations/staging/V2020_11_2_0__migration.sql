
alter table loan.encompass_loan add el_closing_disclosure_sent_date timestamp;
alter table loan.encompass_loan add el_closing_disclosure_received_date timestamp;
alter table loan.encompass_loan add el_revised_closing_disclosure_sent_date timestamp;
alter table loan.encompass_loan add el_revised_closing_disclosure_received_date timestamp;
alter table loan.encompass_loan add el_total_broker_fees_collected_amount numeric(17,2);
alter table loan.encompass_loan add el_total_lender_fees_collected numeric(17,2);
alter table loan.encompass_loan add el_purchasing_beneficiary_investor_name text;
