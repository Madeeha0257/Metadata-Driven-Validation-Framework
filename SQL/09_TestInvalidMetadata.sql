USE HospitalManagementDB;
GO

--------------------------------------------------
-- Insert Invalid Metadata Rules
--------------------------------------------------

INSERT INTO ValidationMetadata
VALUES
(
'TEST01',
'hospital',
'FakeTable',
'Patient_ID',
'Patient_ID',
'NO','NO',
NULL,NULL,
NULL,
NULL,NULL,
NULL,NULL,
NULL,NULL,
'NO','NO','NO','NO'
);

INSERT INTO ValidationMetadata
VALUES
(
'TEST02',
'hospital',
'Patient',
'FakeColumn',
'Patient_ID',
'NO','NO',
NULL,NULL,
NULL,
NULL,NULL,
NULL,NULL,
NULL,NULL,
'NO','NO','NO','NO'
);

--------------------------------------------------
-- Execute Metadata Validation
--------------------------------------------------

EXEC RunMetadataValidation;
GO

--------------------------------------------------
-- Display Report
--------------------------------------------------

SELECT *
FROM Metadata_Validation_Report;
GO

--------------------------------------------------
-- Cleanup Test Data
--------------------------------------------------

DELETE
FROM ValidationMetadata
WHERE ErrorCode LIKE 'TEST%';
GO