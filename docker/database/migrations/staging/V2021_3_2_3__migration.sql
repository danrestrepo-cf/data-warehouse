--
-- EDW - add missed domain types (https://app.asana.com/0/0/1200119922255221)
--

-- Octane 2021.1.4.0
CREATE TABLE staging_octane.doc_provider_group_type (
    code  varchar(128),
    value varchar(1024),
    PRIMARY KEY (code)
);

CREATE TABLE staging_octane.doc_req_fulfill_status_type (
    code  varchar(128),
    value varchar(1024),
    PRIMARY KEY (code)
);

-- Octane 2021.2.3.0
CREATE TABLE staging_octane.trust_classification_type (
    code  varchar(128),
    value varchar(1024),
    PRIMARY KEY (code)
);

-- Octane 2021.3.3.0
CREATE TABLE staging_octane.financed_property_improvements_category_type (
    code  varchar(128),
    value varchar(1024),
    PRIMARY KEY (code)
);
