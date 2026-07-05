CREATE OR ALTER PROCEDURE RunValidation
AS
BEGIN

SET NOCOUNT ON;

DROP TABLE IF EXISTS #ValidationData;

SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY TableName,
                 ColumnName
    ) AS RowNum,

    ErrorCode,

    SchemaName,
    TableName,
    ColumnName,

    PKColumn,

    CheckNull,
    CheckEmpty,

    MinLengthValue,
    DomainValues,

    BeforeYearValue,

    MinValue,
    MaxValue,

    CompareColumn,
    Operator,

    ParentTable,
    ParentColumn,

    CheckEmail,
    CheckNumeric,
    CheckFutureDate,
    CheckSpecialChars

INTO #ValidationData
FROM ValidationMetadata;

--select * from #ValidationData

DROP TABLE IF EXISTS #Error_Report;

CREATE TABLE #Error_Report
(
    ErrorCode VARCHAR(30),
    ErrorDescription VARCHAR(200),

    TableName VARCHAR(100),

    PKColumn VARCHAR(100),
    PKValue VARCHAR(100),

    ColumnName VARCHAR(100),
    ActualValue VARCHAR(MAX)
);

DECLARE @i INT = 1;
DECLARE @max INT;
SELECT @max = COUNT(1)
FROM #ValidationData;

DECLARE @ErrorCode VARCHAR(20);
DECLARE @ErrorCodeGenerated VARCHAR(30);

DECLARE @ErrorDescription VARCHAR(200);

DECLARE @sn VARCHAR(50);
DECLARE @tn VARCHAR(50);
DECLARE @cn VARCHAR(50);

DECLARE @PKColumn VARCHAR(50);

DECLARE @CheckNull VARCHAR(3);
DECLARE @CheckEmpty VARCHAR(3);

DECLARE @MinLength INT;
DECLARE @Domain VARCHAR(500);

DECLARE @BeforeYear INT;

DECLARE @MinValue DECIMAL(10,2);
DECLARE @MaxValue DECIMAL(10,2);

DECLARE @CompareColumn VARCHAR(50);
DECLARE @Operator VARCHAR(10);

DECLARE @ParentTable VARCHAR(50);
DECLARE @ParentColumn VARCHAR(50);

DECLARE @CheckEmail VARCHAR(3);
DECLARE @CheckNumeric VARCHAR(3);
DECLARE @CheckFutureDate VARCHAR(3);
DECLARE @CheckSpecialChars VARCHAR(3);

DECLARE @sql NVARCHAR(MAX);

DECLARE @prefix1 NVARCHAR(MAX);
DECLARE @prefix2 NVARCHAR(MAX);

WHILE @i <= @max
BEGIN

    SELECT
        @ErrorCode = ErrorCode,

        @sn = SchemaName,
        @tn = TableName,
        @cn = ColumnName,

        @PKColumn = PKColumn,

        @CheckNull = CheckNull,
        @CheckEmpty = CheckEmpty,

        @MinLength = MinLengthValue,
        @Domain = DomainValues,

        @BeforeYear = BeforeYearValue,

        @MinValue = TRY_CONVERT(DECIMAL(10,2), MinValue),
        @MaxValue = TRY_CONVERT(DECIMAL(10,2), MaxValue),

        @CompareColumn = CompareColumn,
        @Operator = Operator,

        @ParentTable = ParentTable,
        @ParentColumn = ParentColumn,

        @CheckEmail = CheckEmail,
        @CheckNumeric = CheckNumeric,
        @CheckFutureDate = CheckFutureDate,
        @CheckSpecialChars = CheckSpecialChars

    FROM #ValidationData
    WHERE RowNum = @i;


    SET @prefix1 =
    '
    INSERT INTO #Error_Report
    SELECT
    ';

    SET @prefix2 =
    ',
    ''' + @tn + ''',
    ''' + @PKColumn + ''',
    CAST(' + @PKColumn + ' AS VARCHAR(100)),
    ''' + @cn + ''',
    CAST(' + @cn + ' AS VARCHAR(MAX))
    FROM ' + @sn + '.' + @tn +
    ' WHERE ';

        IF @CheckNull = 'YES'
    BEGIN

        SET @ErrorCodeGenerated = @ErrorCode + 'A';

        SELECT
            @ErrorDescription = ErrorDescription
        FROM Error_Master
        WHERE ErrorCode = 'A';

        SET @sql =
        @prefix1 +
        '''' + @ErrorCodeGenerated + ''',
        ''' + @ErrorDescription + '''' +
        @prefix2 +
        @cn + ' IS NULL';

        PRINT 'Row=' + CAST(@i AS VARCHAR(10));
        PRINT 'Code=' + @ErrorCodeGenerated;
        PRINT @sql;

        EXEC sp_executesql @sql;

    END

        IF @CheckEmpty = 'YES'
    BEGIN

        SET @ErrorCodeGenerated = @ErrorCode + 'B';

        SELECT
            @ErrorDescription = ErrorDescription
        FROM Error_Master
        WHERE ErrorCode = 'B';

        SET @sql =
        @prefix1 +
        '''' + @ErrorCodeGenerated + ''',
        ''' + @ErrorDescription + '''' +
        @prefix2 +
        'LTRIM(RTRIM(' + @cn + ')) = ''''';

        PRINT 'Row=' + CAST(@i AS VARCHAR(10));
        PRINT 'Code=' + @ErrorCodeGenerated;
        PRINT @sql;

        EXEC sp_executesql @sql;

    END

    IF @MinLength IS NOT NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'C';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'C';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            'LEN(' + @cn + ') < ' +
            CAST(@MinLength AS VARCHAR(10));

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @Domain IS NOT NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'D';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'D';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn +
            ' NOT IN (''' +
            REPLACE(@Domain, ',', ''',''') +
            ''')';

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @BeforeYear IS NOT NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'E';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'E';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            'YEAR(' + @cn + ') < ' +
            CAST(@BeforeYear AS VARCHAR(10));

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @MinValue IS NOT NULL
   AND @MaxValue IS NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'F';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'F';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn + ' < ' +
            CAST(@MinValue AS VARCHAR(20));

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @MaxValue IS NOT NULL
   AND @MinValue IS NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'G';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'G';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn + ' > ' +
            CAST(@MaxValue AS VARCHAR(20));

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @MinValue IS NOT NULL
   AND @MaxValue IS NOT NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'H';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'H';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn + ' < ' +
            CAST(@MinValue AS VARCHAR(20))
            + ' OR ' +
            @cn + ' > ' +
            CAST(@MaxValue AS VARCHAR(20));

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @CompareColumn IS NOT NULL
   AND @Operator IS NOT NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'I';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'I';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn + ' ' +
            @Operator + ' ' +
            @CompareColumn;

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @ParentTable IS NOT NULL
   AND @ParentColumn IS NOT NULL
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'J';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'J';

            SET @sql =
            '
            INSERT INTO #Error_Report
            SELECT
            ''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + ''',
            ''' + @tn + ''',
            ''' + @PKColumn + ''',
            CAST(a.' + @PKColumn + ' AS VARCHAR(100)),
            ''' + @cn + ''',
            CAST(a.' + @cn + ' AS VARCHAR(MAX))

            FROM ' + @sn + '.' + @tn + ' a

            LEFT JOIN ' + @sn + '.' + @ParentTable + ' p
            ON a.' + @cn + ' = p.' + @ParentColumn + '

            WHERE a.' + @cn + ' IS NOT NULL
            AND p.' + @ParentColumn + ' IS NULL';

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @CheckEmail = 'YES'
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'K';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'K';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn +
            ' NOT LIKE ''%_@_%._%''';

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;
        END

    IF @CheckNumeric = 'YES'
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'L';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'L';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn +
            ' LIKE ''%[^0-9]%''';

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @CheckFutureDate = 'YES'
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'M';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'M';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn + ' > GETDATE()';

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

    IF @CheckSpecialChars = 'YES'
        BEGIN

            SET @ErrorCodeGenerated = @ErrorCode + 'N';

            SELECT
                @ErrorDescription = ErrorDescription
            FROM Error_Master
            WHERE ErrorCode = 'N';

            SET @sql =
            @prefix1 +
            '''' + @ErrorCodeGenerated + ''',
            ''' + @ErrorDescription + '''' +
            @prefix2 +
            @cn +
            ' LIKE ''%[^A-Za-z ]%''';

            PRINT 'Row=' + CAST(@i AS VARCHAR(10));
            PRINT 'Code=' + @ErrorCodeGenerated;
            PRINT @sql;

            EXEC sp_executesql @sql;

        END

        
    SET @i = @i + 1;

END 

SELECT *
FROM #Error_Report
ORDER BY
ErrorCode,
TableName,
PKValue; 

END

GO

execute RunValidation





