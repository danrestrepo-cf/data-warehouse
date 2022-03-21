--
-- EDW | Implement fix for SP-200005 (borrower_dim) performance issues: add index to borrower_residence.bres_current field used in join
-- https://app.asana.com/0/0/1201998540426854
--

CREATE INDEX idx_borrower_residence__bres_current ON history_octane.borrower_residence (bres_current);
