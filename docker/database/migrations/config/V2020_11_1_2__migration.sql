-- fix for release v2020.11.1.0's incorrect filename/path for SP10.1
UPDATE mdi.microsoft_excel_input_step
SET
    filename='\input\dmi-V35.xls'
WHERE
    microsoft_excel_input_step.dwid = 1 -- dwid 1 is for SP10.1