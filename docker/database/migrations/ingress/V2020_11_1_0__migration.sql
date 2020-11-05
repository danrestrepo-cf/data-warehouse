

create table dmi.nmls_call_report_s540a_raw
(
	state_type text,
	item_id bigint,
	servicer_id bigint,
	servicer_name text,
	pool_number text,
	unpaid_balance numeric,
	loan_count integer,
	etl_batch_id text
);

create table dmi.nmls_call_report_state_raw
(
	mcr_code text not null,
	mcr_desc text,
	state_type text not null,
	unpaid_balance numeric,
	loan_count integer,
	avg_loan_size numeric,
	etl_batch_id text
);

create table dmi.nmls_call_report_national_raw
(
	mcr_code text not null,
	mcr_desc text,
	unpaid_balance numeric,
	loan_count integer,
	avg_loan_size numeric,
	etl_batch_id text
);

