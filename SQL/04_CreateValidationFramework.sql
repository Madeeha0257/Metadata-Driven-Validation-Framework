

USE HospitalManagementDB;
GO


-- Remove Existing Validation Framework Tables


DROP TABLE IF EXISTS Error_Master;
DROP TABLE IF EXISTS ValidationMetadata;
GO


-- Error Master


CREATE TABLE Error_Master
(
    ErrorCode VARCHAR(10) PRIMARY KEY,
    ErrorDescription VARCHAR(200)
);
GO

INSERT INTO Error_Master
(ErrorCode, ErrorDescription)
VALUES
('A', 'Null Value Found'),
('B', 'Empty Value Found'),
('C', 'Minimum Length Violation'),
('D', 'Invalid Domain Value'),
('E', 'Date Before Allowed Year'),
('F', 'Minimum Value Violation'),
('G', 'Maximum Value Violation'),
('H', 'Range Violation'),
('I', 'Column Comparison Violation'),
('J', 'Foreign Key Violation'),
('K', 'Invalid Email Format'),
('L', 'Non Numeric Value Found'),
('M', 'Future Date Found'),
('N', 'Special Character Violation');
GO


-- Validation Metadata Table


CREATE TABLE ValidationMetadata
(
    ErrorCode VARCHAR(20),

    SchemaName VARCHAR(50),
    TableName VARCHAR(50),
    ColumnName VARCHAR(50),

    PKColumn VARCHAR(50),

    CheckNull VARCHAR(3),
    CheckEmpty VARCHAR(3),

    MinLengthValue INT,
    DomainValues VARCHAR(500),

    BeforeYearValue INT,

    MinValue VARCHAR(50),
    MaxValue VARCHAR(50),

    CompareColumn VARCHAR(50),
    Operator VARCHAR(10),

    ParentTable VARCHAR(50),
    ParentColumn VARCHAR(50),

    CheckEmail VARCHAR(3),
    CheckNumeric VARCHAR(3),
    CheckFutureDate VARCHAR(3),
    CheckSpecialChars VARCHAR(3)
);



