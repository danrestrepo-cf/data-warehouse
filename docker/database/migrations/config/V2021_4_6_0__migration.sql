--
-- Create table_metadata config tables
-- (https://app.asana.com/0/0/1200245179995891)
--


CREATE TABLE mdi.edw_table_definition (
									dwid BIGSERIAL NOT NULL
										CONSTRAINT pk_edw_table_definition
											PRIMARY KEY,
									database_name TEXT NOT NULL,
									schema_name TEXT NOT NULL,
									table_name TEXT NOT NULL,
									primary_source_edw_table_definition_dwid BIGINT NOT NULL
										CONSTRAINT fk_edw_table_definition_1
											REFERENCES mdi.edw_table_definition (dwid)
											ON UPDATE RESTRICT
											ON DELETE RESTRICT
											DEFERRABLE INITIALLY DEFERRED
								);

CREATE TABLE mdi.edw_join_definition (
								   dwid BIGSERIAL NOT NULL
									   CONSTRAINT pk_edw_join_definition
										   PRIMARY KEY,
								   primary_edw_table_definition_dwid BIGINT NOT NULL
									   CONSTRAINT fk_edw_join_definition_1
										   REFERENCES mdi.edw_table_definition (dwid)
										   ON UPDATE RESTRICT
										   ON DELETE RESTRICT
										   DEFERRABLE INITIALLY DEFERRED,
								   target_edw_table_definition_dwid BIGINT NOT NULL
									   CONSTRAINT fk_edw_join_definition_2
										   REFERENCES mdi.edw_table_definition (dwid)
										   ON UPDATE RESTRICT
										   ON DELETE RESTRICT
										   DEFERRABLE INITIALLY DEFERRED,
								   join_type TEXT NOT NULL,
								   join_condition TEXT
							   );

CREATE TABLE mdi.edw_field_definition (
									dwid BIGSERIAL NOT NULL
										CONSTRAINT pk_edw_field_definition
											PRIMARY KEY,
									edw_table_definition_dwid BIGINT NOT NULL
										CONSTRAINT fk_edw_field_definition_1
											REFERENCES mdi.edw_table_definition (dwid)
											ON UPDATE RESTRICT
											ON DELETE RESTRICT
											DEFERRABLE INITIALLY DEFERRED,
									field_name TEXT NOT NULL,
									key_field_flag BOOLEAN NOT NULL,
									source_edw_field_definition_dwid BIGINT NOT NULL
										CONSTRAINT fk_edw_field_definition_2
											REFERENCES mdi.edw_field_definition (dwid)
											ON UPDATE RESTRICT
											ON DELETE RESTRICT
											DEFERRABLE INITIALLY DEFERRED,
									source_edw_join_definition_dwid BIGINT
										CONSTRAINT fk_edw_field_definition_3
											REFERENCES mdi.edw_join_definition (dwid)
											ON UPDATE RESTRICT
											ON DELETE RESTRICT
											DEFERRABLE INITIALLY DEFERRED
								);
