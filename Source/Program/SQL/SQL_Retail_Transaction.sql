SELECT * FROM Retail_Transactions

--Tạo 1 cột mới khi tách []
ALTER TABLE Retail_Transactions
	ADD Product2 NVARCHAR(MAX)

--Tạo bảng Test

SELECT * INTO Retail_Transactions_Test
FROM Retail_Transactions

--Cập nhật lại cột Product2
UPDATE RTT
	SET RTT.Product2 = (	SELECT SUBSTRING(Product, 2, LEN(Product)-2) 
							FROM Retail_Transactions_Test
							WHERE RTT.Transaction_ID = Retail_Transactions_Test.Transaction_ID)
FROM Retail_Transactions_Test RTT

--Add column
DECLARE @Product NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);

DECLARE Add_Column CURSOR FOR
SELECT DISTINCT SUBSTRING(TRIM(s.value), 2, LEN(TRIM(s.value)) - 2) AS Product
FROM Retail_Transactions_Test t
CROSS APPLY STRING_SPLIT(t.Product2, ',') s;

OPEN Add_Column;

FETCH NEXT FROM Add_Column INTO @Product;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @query = 'ALTER TABLE Retail_Transactions_Test ADD [' + @Product + '] BIT;';
    EXEC sp_executesql @query;

    FETCH NEXT FROM Add_Column INTO @Product;
END;

CLOSE Add_Column;
DEALLOCATE Add_Column;

SELECT * FROM Retail_Transactions_Test ORDER BY Transaction_ID ASC

--SELECT ID và Product sau tách
SELECT Transaction_ID, SUBSTRING(TRIM(s.value), 2, LEN(TRIM(s.value)) - 2) AS Product
FROM Retail_Transactions_Test t
CROSS APPLY STRING_SPLIT(t.Product2, ',') s
ORDER BY Transaction_ID ASC


--Add data

DECLARE @SQL NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);
DECLARE @column_name NVARCHAR(MAX);

DECLARE Add_Data CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Transactions_Test'
AND ORDINAL_POSITION BETWEEN 15 AND 95;

OPEN Add_Data;

FETCH NEXT FROM Add_Data INTO @column_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @query = '
        UPDATE RTT
        SET RTT.[' + @column_name + '] = 
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM (
                        SELECT Transaction_ID, SUBSTRING(TRIM(s.value), 2, LEN(TRIM(s.value)) - 2) AS Product
                        FROM Retail_Transactions_Test t
                        CROSS APPLY STRING_SPLIT(t.Product2, '','')
                    ) AS SplitData
                    WHERE SplitData.Product = ''' + @column_name + ''' 
                          AND SplitData.Transaction_ID = RTT.Transaction_ID
                ) THEN 1
                ELSE 0
            END
        FROM Retail_Transactions_Test RTT;';

    EXEC sp_executesql @query;

    FETCH NEXT FROM Add_Data INTO @column_name;
END;

CLOSE Add_Data;
DEALLOCATE Add_Data;



SELECT * FROM Retail_Transactions_Test ORDER BY Transaction_ID ASC

--Cau2
ALTER TABLE Retail_Transactions_Test 
ADD Details NVARCHAR(MAX);

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Transactions_Test' AND ORDINAL_POSITION BETWEEN 15 AND 95
ORDER BY ORDINAL_POSITION;

DECLARE @ColumnName NVARCHAR(MAX);
DECLARE @ConcatString NVARCHAR(MAX) = '';
DECLARE @UpdateQuery NVARCHAR(MAX);
DECLARE ColumnCursor CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Transactions_Test' 
      AND ORDINAL_POSITION BETWEEN 15 AND 95
ORDER BY ORDINAL_POSITION;

OPEN ColumnCursor;

FETCH NEXT FROM ColumnCursor INTO @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @ConcatString = @ConcatString + 'CAST([' + @ColumnName + '] AS NVARCHAR(1)), '; 
    FETCH NEXT FROM ColumnCursor INTO @ColumnName;
END;

CLOSE ColumnCursor;
DEALLOCATE ColumnCursor;

SET @ConcatString = LEFT(@ConcatString, LEN(@ConcatString) - 2);

SET @UpdateQuery = '
UPDATE Retail_Transactions_Test
SET Details = CONCAT(' + @ConcatString + '));';

PRINT @UpdateQuery;

EXEC sp_executesql @UpdateQuery;

SELECT * FROM Retail_Transactions_Test

--Add column

DECLARE @ColumnName NVARCHAR(MAX);
DECLARE @CreateTableQuery NVARCHAR(MAX);
SET @CreateTableQuery = 'CREATE TABLE Retail_Transactions_Table (';
DECLARE ColumnCursor CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Transactions_Test' 
      AND ORDINAL_POSITION BETWEEN 15 AND 96
ORDER BY ORDINAL_POSITION;
OPEN ColumnCursor;
FETCH NEXT FROM ColumnCursor INTO @ColumnName;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @CreateTableQuery = @CreateTableQuery + '[' + @ColumnName + '] NVARCHAR(MAX), ';
    FETCH NEXT FROM ColumnCursor INTO @ColumnName;
END;
CLOSE ColumnCursor;
DEALLOCATE ColumnCursor;
SET @CreateTableQuery = LEFT(@CreateTableQuery, LEN(@CreateTableQuery) - 2) + '));';
PRINT @CreateTableQuery;
EXEC sp_executesql @CreateTableQuery;

SELECT * FROM Retail_Transactions_Table


DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @Columns NVARCHAR(MAX) = '';

SELECT @Columns = @Columns + '[' + COLUMN_NAME + '], '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Transactions_Table'
      AND ORDINAL_POSITION BETWEEN 1 AND 95;

SET @Columns = LEFT(@Columns, LEN(@Columns) - 2);

SET @SQL = '
INSERT INTO Retail_Transactions_Table (' + @Columns + '])
SELECT DISTINCT ' + @Columns + ']
FROM Retail_Transactions_Test
ORDER BY Details;';

PRINT @SQL;

EXEC sp_executesql @SQL;

SELECT * FROM Retail_Transactions_Table

--Drop column

DECLARE @Product NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);

DECLARE DEL_Col CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Transactions_Table' 
      AND ORDINAL_POSITION BETWEEN 1 AND 81
ORDER BY ORDINAL_POSITION;

OPEN DEL_Col;

FETCH NEXT FROM DEL_Col INTO @Product;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @query = 'ALTER TABLE Retail_Transactions_Test DROP COLUMN [' + @Product + '];';
    EXEC sp_executesql @query;

    FETCH NEXT FROM DEL_Col INTO @Product;
END;

CLOSE DEL_Col;
DEALLOCATE DEL_Col;

SELECT * FROM Retail_Transactions_Table

SELECT * FROM Retail_Transactions_Test

ALTER TABLE Retail_Transactions_Table
ADD CONSTRAINT ConstraintN PRIMARY KEY (Details);

--chuyen cac col con lai -> int 
DECLARE @Product NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);

DECLARE Up_Col CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Transactions_Table' 
      AND ORDINAL_POSITION BETWEEN 1 AND 81
ORDER BY ORDINAL_POSITION;

OPEN Up_Col;

FETCH NEXT FROM Up_Col INTO @Product;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @query = 'ALTER TABLE Retail_Transactions_Table ALTER COLUMN [' + @Product + '] INT;';
    EXEC sp_executesql @query;

    FETCH NEXT FROM Up_Col INTO @Product;
END;

CLOSE Up_Col;
DEALLOCATE Up_Col;

