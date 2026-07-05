

USE HospitalManagementDB;
GO

CREATE OR ALTER PROCEDURE RunMetadataValidation
AS
BEGIN

    SET NOCOUNT ON;

    DROP TABLE IF EXISTS Metadata_Validation_Report;

    CREATE TABLE Metadata_Validation_Report
    (
        ErrorType VARCHAR(100),
        ErrorCode VARCHAR(20),
        TableName VARCHAR(100),
        ColumnName VARCHAR(100),
        ErrorDescription VARCHAR(500)
    );

    --------------------------------------------------
    -- 1. Table Exists
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Missing Table',
        m.ErrorCode,
        m.TableName,
        m.ColumnName,
        'Table does not exist'
    FROM ValidationMetadata m
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLES t
        WHERE t.TABLE_SCHEMA = m.SchemaName
        AND t.TABLE_NAME = m.TableName
    );

    --------------------------------------------------
    -- 2. Column Exists
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Missing Column',
        m.ErrorCode,
        m.TableName,
        m.ColumnName,
        'Column does not exist'
    FROM ValidationMetadata m
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE c.TABLE_SCHEMA = m.SchemaName
        AND c.TABLE_NAME = m.TableName
        AND c.COLUMN_NAME = m.ColumnName
    );

    --------------------------------------------------
    -- 3. Primary Key Column Exists
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Missing PK Column',
        m.ErrorCode,
        m.TableName,
        m.PKColumn,
        'PK Column does not exist'
    FROM ValidationMetadata m
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE c.TABLE_SCHEMA = m.SchemaName
        AND c.TABLE_NAME = m.TableName
        AND c.COLUMN_NAME = m.PKColumn
    );

    --------------------------------------------------
    -- 4. Compare Column Exists
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Missing Compare Column',
        m.ErrorCode,
        m.TableName,
        m.CompareColumn,
        'Compare Column does not exist'
    FROM ValidationMetadata m
    WHERE m.CompareColumn IS NOT NULL
      AND NOT EXISTS
    (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE c.TABLE_SCHEMA = m.SchemaName
          AND c.TABLE_NAME = m.TableName
          AND c.COLUMN_NAME = m.CompareColumn
    );

    --------------------------------------------------
    -- 5. Parent Table Exists
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Missing Parent Table',
        m.ErrorCode,
        m.TableName,
        m.ParentTable,
        'Parent Table does not exist'
    FROM ValidationMetadata m
    WHERE m.ParentTable IS NOT NULL
      AND NOT EXISTS
    (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLES t
        WHERE t.TABLE_SCHEMA = m.SchemaName
          AND t.TABLE_NAME = m.ParentTable
    );

    --------------------------------------------------
    -- 6. Parent Column Exists
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Missing Parent Column',
        m.ErrorCode,
        m.ParentTable,
        m.ParentColumn,
        'Parent Column does not exist'
    FROM ValidationMetadata m
    WHERE m.ParentColumn IS NOT NULL
      AND NOT EXISTS
    (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE c.TABLE_SCHEMA = m.SchemaName
          AND c.TABLE_NAME = m.ParentTable
          AND c.COLUMN_NAME = m.ParentColumn
    );

    --------------------------------------------------
    -- 7. Invalid Range
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Invalid Range',
        ErrorCode,
        TableName,
        ColumnName,
        'MinValue cannot be greater than MaxValue'
    FROM ValidationMetadata
    WHERE TRY_CONVERT(DECIMAL(18,2), MinValue)
        > TRY_CONVERT(DECIMAL(18,2), MaxValue)
      AND MinValue IS NOT NULL
      AND MaxValue IS NOT NULL;

    --------------------------------------------------
    -- 8. Invalid Operator
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Invalid Operator',
        ErrorCode,
        TableName,
        ColumnName,
        'Operator must be one of <, <=, >, >=, =, <>'
    FROM ValidationMetadata
    WHERE Operator IS NOT NULL
      AND Operator NOT IN ('<','<=','>','>=','=','<>');

    --------------------------------------------------
    -- 9. Duplicate Metadata Rules
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Duplicate Metadata',
        ErrorCode,
        TableName,
        ColumnName,
        'Duplicate validation rule found'
    FROM ValidationMetadata
    GROUP BY
        ErrorCode,
        TableName,
        ColumnName
    HAVING COUNT(*) > 1;

    --------------------------------------------------
    -- 10. Date Validation Applied to Non-Date Column
    --------------------------------------------------

    INSERT INTO Metadata_Validation_Report
    SELECT
        'Invalid Data Type',
        m.ErrorCode,
        m.TableName,
        m.ColumnName,
        'Date validation applied to non-date column'
    FROM ValidationMetadata m
    INNER JOIN INFORMATION_SCHEMA.COLUMNS c
        ON c.TABLE_SCHEMA = m.SchemaName
       AND c.TABLE_NAME = m.TableName
       AND c.COLUMN_NAME = m.ColumnName
    WHERE
        (
            m.BeforeYearValue IS NOT NULL
            OR m.CheckFutureDate = 'YES'
        )
        AND c.DATA_TYPE NOT IN
        (
            'date',
            'datetime',
            'datetime2',
            'smalldatetime'
        );

    --------------------------------------------------
    -- Final Report
    --------------------------------------------------

    SELECT *
    FROM Metadata_Validation_Report
    ORDER BY ErrorType, ErrorCode;

END;
GO

exec RunMetadataValidation