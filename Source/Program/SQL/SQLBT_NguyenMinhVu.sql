SELECT * FROM mental_health

-----------------------------------Data Cleaning-------------------------------------------
------------------------21/11-----------------------------------------

SELECT DISTINCT Age FROM mental_health

UPDATE mental_health
	SET Work_Hours = NULL
	WHERE User_ID BETWEEN 1 AND 5

WITH AvgWHbyAge AS (
    SELECT Age, Gender, Occupation, AVG(Work_Hours) AS AvgWorkHours
    FROM mental_health
    WHERE Work_Hours IS NOT NULL
    GROUP BY Age, Gender, Occupation
)
UPDATE mental_health
SET Work_Hours = (	SELECT TOP 1 AvgWorkHours
						FROM AvgWHbyAge
						INNER JOIN mental_health X ON X.Age = AvgWHbyAge.Age AND X.Gender = AvgWHbyAge.Gender AND X.Occupation = AvgWHbyAge.Occupation
						)
WHERE Work_Hours IS NULL


SELECT mh.User_ID, mh.Age, mh.Gender, mh.Occupation, a.AvgWorkHours AS AvgWK
						FROM mental_health mh
						LEFT JOIN AvgWHbyAge a ON mh.Age = a.Age AND mh.Gender = a.Gender AND mh.Occupation = a.Occupation


SELECT * INTO X
FROM mental_health

SELECT * INTO Y
FROM mental_health

SELECT * INTO Z
FROM mental_health

WITH CTE_X1 AS (
    SELECT '30-39' AS R, AVG(Work_Hours) AS AvgWorkHours
    FROM X
    WHERE Work_Hours BETWEEN 30 AND 39
    UNION ALL
    SELECT '40-49', AVG(Work_Hours)
    FROM X
    WHERE Work_Hours BETWEEN 40 AND 49
    UNION ALL
    SELECT '50-59', AVG(Work_Hours)
    FROM X
    WHERE Work_Hours BETWEEN 50 AND 59
    UNION ALL
    SELECT '60-69', AVG(Work_Hours)
    FROM X
    WHERE Work_Hours BETWEEN 60 AND 69
    UNION ALL
    SELECT '70-80', AVG(Work_Hours)
    FROM X
    WHERE Work_Hours BETWEEN 70 AND 80
)
UPDATE X
SET Work_Hours = 
    CASE 
        WHEN Work_Hours BETWEEN 30 AND 39 THEN (SELECT AVG(Work_Hours) FROM X WHERE Work_Hours BETWEEN 30 AND 39)
        WHEN Work_Hours BETWEEN 40 AND 49 THEN (SELECT AVG(Work_Hours) FROM X WHERE Work_Hours BETWEEN 40 AND 49)
        WHEN Work_Hours BETWEEN 50 AND 59 THEN (SELECT AVG(Work_Hours) FROM X WHERE Work_Hours BETWEEN 50 AND 59)
        WHEN Work_Hours BETWEEN 60 AND 69 THEN (SELECT AVG(Work_Hours) FROM X WHERE Work_Hours BETWEEN 60 AND 69)
        WHEN Work_Hours BETWEEN 70 AND 80 THEN (SELECT AVG(Work_Hours) FROM X WHERE Work_Hours BETWEEN 70 AND 79)
        ELSE Work_Hours
    END;



WITH CTE_Y1 AS (
    SELECT '30-39' AS R, CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2 AS AvgWorkHours
    FROM Y
    WHERE Work_Hours BETWEEN 30 AND 39
    UNION ALL
    SELECT '40-49', CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2
    FROM Y
    WHERE Work_Hours BETWEEN 40 AND 49
    UNION ALL
    SELECT '50-59', CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2
    FROM Y
    WHERE Work_Hours BETWEEN 50 AND 59
    UNION ALL
    SELECT '60-69', CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2
    FROM Y
    WHERE Work_Hours BETWEEN 60 AND 69
    UNION ALL
    SELECT '70-80', CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2
    FROM Y
    WHERE Work_Hours BETWEEN 70 AND 80
)
UPDATE Y
SET Work_Hours = 
    CASE 
        WHEN Work_Hours BETWEEN 30 AND 39 THEN (SELECT CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2 FROM Y WHERE Work_Hours BETWEEN 30 AND 39)
        WHEN Work_Hours BETWEEN 40 AND 49 THEN (SELECT CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2 FROM Y WHERE Work_Hours BETWEEN 40 AND 49)
        WHEN Work_Hours BETWEEN 50 AND 59 THEN (SELECT CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2 FROM Y WHERE Work_Hours BETWEEN 50 AND 59)
        WHEN Work_Hours BETWEEN 60 AND 69 THEN (SELECT CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2 FROM Y WHERE Work_Hours BETWEEN 60 AND 69)
        WHEN Work_Hours BETWEEN 70 AND 80 THEN (SELECT CAST(MIN(Work_Hours) + MAX(Work_Hours) AS FLOAT) / 2 FROM Y WHERE Work_Hours BETWEEN 70 AND 79)
        ELSE Work_Hours
    END;

SELECT * FROM Y

WITH CTE_Z1 AS (
    SELECT 
        '30-39' AS B, MIN(Work_Hours) AS MinVal, MAX(Work_Hours) AS MaxVal
    FROM Z
    WHERE Work_Hours BETWEEN 30 AND 39
    UNION ALL
    SELECT 
        '40-49', MIN(Work_Hours), MAX(Work_Hours)
    FROM Z
    WHERE Work_Hours BETWEEN 40 AND 49
    UNION ALL
    SELECT 
        '50-59', MIN(Work_Hours), MAX(Work_Hours)
    FROM Z
    WHERE Work_Hours BETWEEN 50 AND 59
    UNION ALL
    SELECT 
        '60-69', MIN(Work_Hours), MAX(Work_Hours)
    FROM Z
    WHERE Work_Hours BETWEEN 60 AND 69
    UNION ALL
    SELECT 
        '70-80', MIN(Work_Hours), MAX(Work_Hours)
    FROM Z
    WHERE Work_Hours BETWEEN 70 AND 80
)
UPDATE Z
SET Work_Hours = 
    CASE 
        WHEN Work_Hours BETWEEN 30 AND 39 THEN 
            (SELECT IIF(ABS(MaxVal - Work_Hours) > ABS(Work_Hours - MinVal), MinVal, MaxVal) 
             FROM CTE_Z1 WHERE B = '30-39')
        WHEN Work_Hours BETWEEN 40 AND 49 THEN 
            (SELECT IIF(ABS(MaxVal - Work_Hours) > ABS(Work_Hours - MinVal), MinVal, MaxVal) 
             FROM CTE_Z1 WHERE B = '40-49')
        WHEN Work_Hours BETWEEN 50 AND 59 THEN 
            (SELECT IIF(ABS(MaxVal - Work_Hours) > ABS(Work_Hours - MinVal), MinVal, MaxVal) 
             FROM CTE_Z1 WHERE B = '50-59')
        WHEN Work_Hours BETWEEN 60 AND 69 THEN 
            (SELECT IIF(ABS(MaxVal - Work_Hours) > ABS(Work_Hours - MinVal), MinVal, MaxVal) 
             FROM CTE_Z1 WHERE B = '60-69')
        WHEN Work_Hours BETWEEN 70 AND 80 THEN 
            (SELECT IIF(ABS(MaxVal - Work_Hours) > ABS(Work_Hours - MinVal), MinVal, MaxVal) 
             FROM CTE_Z1 WHERE B = '70-80')
        ELSE Work_Hours
    END;

SELECT * FROM Z
SELECT * INTO Test
FROM mental_health

WITH CTE_500_1
AS
(
	SELECT TOP 500 Work_Hours
	FROM mental_health
	ORDER BY Work_Hours 
)
--250
SELECT TOP 1 Work_Hours
FROM CTE_500_1
WHERE Work_Hours IN (SELECT TOP 250 Work_Hours FROM CTE_500_1 ORDER BY Work_Hours DESC)
ORDER BY Work_Hours 


--500
SELECT TOP 1 Work_Hours
FROM CTE_500_1
ORDER BY Work_Hours DESC

WITH CTE_500_2
AS
(
	SELECT TOP 501 Work_Hours
	FROM mental_health
	ORDER BY Work_Hours 
)
--501
SELECT TOP 1 Work_Hours
FROM CTE_500_2
ORDER BY Work_Hours DESC

--751
WITH CTE_500_3
AS
(
	SELECT TOP 751 Work_Hours
	FROM mental_health
	ORDER BY Work_Hours 
)
SELECT TOP 1 Work_Hours
FROM CTE_500_3
ORDER BY Work_Hours DESC

--Cac gia tri ngoai le

--Work_Hours
WITH CTE_500_1 AS (
    SELECT TOP 250 Work_Hours
    FROM mental_health
    ORDER BY Work_Hours
),
CTE_500_3 AS (
    SELECT TOP 750 Work_Hours
    FROM mental_health
    ORDER BY Work_Hours
)
SELECT * 
FROM mental_health
WHERE Work_Hours < (
        SELECT MAX(Work_Hours)
        FROM CTE_500_1) - 1.5 * ((SELECT MAX(Work_Hours) FROM CTE_500_3) - (SELECT MAX(Work_Hours) FROM CTE_500_1)
    )
    OR Work_Hours > (
        SELECT MAX(Work_Hours)
        FROM CTE_500_3) + 1.5 * ((SELECT MAX(Work_Hours) FROM CTE_500_3) - (SELECT MAX(Work_Hours) FROM CTE_500_1)
    );
UPDATE Test
	SET Work_Hours = IIF( Work_Hours <	(SELECT MAX(Work_Hours)
										FROM CTE_500_1) - 1.5 * ((SELECT MAX(Work_Hours) FROM CTE_500_3) - (SELECT MAX(Work_Hours) FROM CTE_500_1)
	), ROUND((	
		SELECT MAX(Work_Hours)
		FROM CTE_500_1) - 1.5 * ((SELECT MAX(Work_Hours) FROM CTE_500_3) - (SELECT MAX(Work_Hours) FROM CTE_500_1)
	), 1), IIF( Work_Hours > (
        SELECT MAX(Work_Hours)
        FROM CTE_500_3) + 1.5 * ((SELECT MAX(Work_Hours) FROM CTE_500_3) - (SELECT MAX(Work_Hours) FROM CTE_500_1)
    ), ROUND((
        SELECT MAX(Work_Hours)
        FROM CTE_500_3) + 1.5 * ((SELECT MAX(Work_Hours) FROM CTE_500_3) - (SELECT MAX(Work_Hours) FROM CTE_500_1)
    ), 1), Work_Hours))

--Age
WITH CTE_500_1 AS (
    SELECT TOP 250 Age
    FROM mental_health
    ORDER BY Age
),
CTE_500_3 AS (
    SELECT TOP 750 Age
    FROM mental_health
    ORDER BY Age
)
SELECT * 
FROM mental_health
WHERE Age < (
        SELECT MAX(Age)
        FROM CTE_500_1) - 1.5 * ((SELECT MAX(Age) FROM CTE_500_3) - (SELECT MAX(Age) FROM CTE_500_1)
    )
    OR Age > (
        SELECT MAX(Age)
        FROM CTE_500_3) + 1.5 * ((SELECT MAX(Age) FROM CTE_500_3) - (SELECT MAX(Age) FROM CTE_500_1)
    );
UPDATE Test
	SET Age = IIF( Age <	(	SELECT MAX(Age)
								FROM CTE_500_1) - 1.5 * ((SELECT MAX(Age) FROM CTE_500_3) - (SELECT MAX(Age) FROM CTE_500_1)
	), ROUND((	
		SELECT MAX(Age)
		FROM CTE_500_1) - 1.5 * ((	SELECT MAX(Age) FROM CTE_500_3) - (SELECT MAX(Age) FROM CTE_500_1)
	), 1), IIF( Age > (
        SELECT MAX(Age)
        FROM CTE_500_3) + 1.5 * ((	SELECT MAX(Age) FROM CTE_500_3) - (SELECT MAX(Age) FROM CTE_500_1)
    ), ROUND((
        SELECT MAX(Age)
        FROM CTE_500_3) + 1.5 * ((	SELECT MAX(Age) FROM CTE_500_3) - (SELECT MAX(Age) FROM CTE_500_1)
    ), 1), Age))

--Sleep_Hours
WITH CTE_500_1 AS (
    SELECT TOP 250 Sleep_Hours
    FROM mental_health
    ORDER BY Sleep_Hours
),
CTE_500_3 AS (
    SELECT TOP 750 Sleep_Hours
    FROM mental_health
    ORDER BY Sleep_Hours
)
SELECT * 
FROM mental_health
WHERE Sleep_Hours < (
        SELECT MAX(Sleep_Hours)
        FROM CTE_500_1) - 1.5 * ((SELECT MAX(Sleep_Hours) FROM CTE_500_3) - (SELECT MAX(Sleep_Hours) FROM CTE_500_1)
    )
    OR Sleep_Hours > (
        SELECT MAX(Sleep_Hours)
        FROM CTE_500_3) + 1.5 * ((SELECT MAX(Sleep_Hours) FROM CTE_500_3) - (SELECT MAX(Sleep_Hours) FROM CTE_500_1)
    );
UPDATE Test
	SET Sleep_Hours = IIF( Sleep_Hours <	(	SELECT MAX(Sleep_Hours)
												FROM CTE_500_1) - 1.5 * ((SELECT MAX(Sleep_Hours) FROM CTE_500_3) - (SELECT MAX(Sleep_Hours) FROM CTE_500_1)
	), ROUND((	
		SELECT MAX(Sleep_Hours)
		FROM CTE_500_1) - 1.5 * ((	SELECT MAX(Sleep_Hours) FROM CTE_500_3) - (SELECT MAX(Sleep_Hours) FROM CTE_500_1)
	), 1), IIF( Sleep_Hours > (
        SELECT MAX(Sleep_Hours)
        FROM CTE_500_3) + 1.5 * ((	SELECT MAX(Sleep_Hours) FROM CTE_500_3) - (SELECT MAX(Sleep_Hours) FROM CTE_500_1)
    ), ROUND((
        SELECT MAX(Sleep_Hours)
        FROM CTE_500_3) + 1.5 * ((	SELECT MAX(Sleep_Hours) FROM CTE_500_3) - (SELECT MAX(Sleep_Hours) FROM CTE_500_1)
    ), 1), Sleep_Hours))

--Physical_Activity_Hours
WITH CTE_500_1 AS (
    SELECT TOP 250 Physical_Activity_Hours
    FROM mental_health
    ORDER BY Physical_Activity_Hours
),
CTE_500_3 AS (
    SELECT TOP 750 Physical_Activity_Hours
    FROM mental_health
    ORDER BY Physical_Activity_Hours
)
SELECT * 
FROM mental_health
WHERE Physical_Activity_Hours < (
        SELECT MAX(Physical_Activity_Hours)
        FROM CTE_500_1) - 1.5 * ((SELECT MAX(Physical_Activity_Hours) FROM CTE_500_3) - (SELECT MAX(Physical_Activity_Hours) FROM CTE_500_1)
    )
    OR Physical_Activity_Hours > (
        SELECT MAX(Physical_Activity_Hours)
        FROM CTE_500_3) + 1.5 * ((SELECT MAX(Physical_Activity_Hours) FROM CTE_500_3) - (SELECT MAX(Physical_Activity_Hours) FROM CTE_500_1)
    );
UPDATE Test
	SET Physical_Activity_Hours = IIF( Physical_Activity_Hours <	(	SELECT MAX(Physical_Activity_Hours)
												FROM CTE_500_1) - 1.5 * ((SELECT MAX(Physical_Activity_Hours) FROM CTE_500_3) - (SELECT MAX(Physical_Activity_Hours) FROM CTE_500_1)
	), ROUND((	
		SELECT MAX(Physical_Activity_Hours)
		FROM CTE_500_1) - 1.5 * ((	SELECT MAX(Physical_Activity_Hours) FROM CTE_500_3) - (SELECT MAX(Physical_Activity_Hours) FROM CTE_500_1)
	), 1), IIF( Physical_Activity_Hours > (
        SELECT MAX(Physical_Activity_Hours)
        FROM CTE_500_3) + 1.5 * ((	SELECT MAX(Physical_Activity_Hours) FROM CTE_500_3) - (SELECT MAX(Physical_Activity_Hours) FROM CTE_500_1)
    ), ROUND((
        SELECT MAX(Physical_Activity_Hours)
        FROM CTE_500_3) + 1.5 * ((	SELECT MAX(Physical_Activity_Hours) FROM CTE_500_3) - (SELECT MAX(Physical_Activity_Hours) FROM CTE_500_1)
    ), 1), Physical_Activity_Hours))

--Xu ly du lieu khong nhat quan
--Occupation
IF EXISTS (SELECT 1 FROM mental_health WHERE Occupation = 'Information Technology' OR Occupation = 'Information-Technology')
BEGIN
	UPDATE mental_health
		SET Occupation = 'IT'
END
IF EXISTS (SELECT 1 FROM mental_health WHERE Stress_Level = 'Sometimes')
BEGIN
	UPDATE mental_health
		SET Stress_Level = 'Low'
END
IF EXISTS (SELECT 1 FROM mental_health WHERE Stress_Level = 'very stressful')
BEGIN
	UPDATE mental_health
		SET Stress_Level = 'High'
END

--Recording_date
WITH CTE_date1
AS
(
	SELECT Recording_date
	FROM mental_health
	WHERE LEN(Recording_date) <> 9 AND Recording_date LIKE '[0-9][0-9][0-9]%'
), CTE_date2 AS (
	SELECT Recording_date
	FROM mental_health
	WHERE LEN(Recording_date) < 9
), CTE_date3 AS (
	SELECT Recording_date
	FROM mental_health
	WHERE Recording_date LIKE '%/_____'
)
UPDATE mental_health
	SET Recording_date = 
	CASE	
		WHEN Recording_date IN (SELECT Recording_date FROM CTE_date1) THEN REPLACE(Recording_date, SUBSTRING(Recording_date, 1, 5), '2023')
		WHEN Recording_date IN (SELECT Recording_date FROM CTE_date2) THEN REPLACE(Recording_date, SUBSTRING(Recording_date, 1, 2), '2023')
		WHEN Recording_date IN (SELECT Recording_date FROM CTE_date3) THEN REPLACE(Recording_date, SUBSTRING(Recording_date, 6, 10), '2023')
		ELSE Recording_date
	END;

UPDATE mental_health
	SET Recording_date = REPLACE(Recording_date, SUBSTRING(Recording_date, 1, 4), SUBSTRING(Recording_date, 8, 2))
	WHERE Recording_date LIKE '2023%'

UPDATE mental_health
	SET Recording_date = REPLACE(Recording_date, SUBSTRING(Recording_date, 5, LEN(Recording_date)), '/2023')
	WHERE SUBSTRING(Recording_date, 1, 2) = SUBSTRING(Recording_date, 6, 2)

UPDATE mental_health
	SET Recording_date = REPLACE(Recording_date, '/3', '/' + SUBSTRING(Recording_date, 1, 2))
	WHERE Recording_date NOT LIKE '3%'

UPDATE mental_health
	SET Recording_date = '3' + SUBSTRING(Recording_date, 3, LEN(Recording_date))
	WHERE SUBSTRING(Recording_date, 1, 2) = SUBSTRING(Recording_date, 4, 2) AND Recording_date NOT LIKE '3%'

SELECT Recording_date FROM mental_health

--Gender
UPDATE mental_health
	SET Gender = (	SELECT TOP 1 Gender
					FROM mental_health
					GROUP BY Gender
					ORDER BY COUNT(*) DESC)
	WHERE Gender IS NULL

--Occupation

UPDATE mental_health
	SET Occupation = (	SELECT TOP 1 Occupation
						FROM mental_health
						GROUP BY Occupation
						ORDER BY COUNT(*) DESC)
	WHERE Occupation is NULL

--Mental Health Condition

UPDATE mental_health
	SET Severity = (
				SELECT TOP 1 Severity
				FROM 
				    mental_health
				GROUP BY 
				    Severity
				ORDER BY 
				    CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM mental_health) DESC)
	WHERE Severity IS NULL

WITH CTE
AS
(	--mean
	SELECT AVG(sleep_hours) sleep
	FROM mental_health
	UNION 
	--mode
	select Top 1 Sleep_Hours 
	from mental_health
	group by Sleep_Hours
	Order by count(*) desc
	UNION
	--median
	SELECT AVG(Sleep_Hours)
	FROM mental_health
	WHERE User_ID IN (500,501)
	)
	SELECT MIN(sleep) FROM CTE


DECLARE @PercentageZero FLOAT;
SET @PercentageZero = (SELECT CAST(COUNT(*) AS FLOAT) / 
                             ((SELECT COUNT(*) FROM mental_health) - (SELECT COUNT(*) FROM mental_health WHERE Mental_Health_Condition IS NULL))
                       FROM mental_health 
                       WHERE Mental_Health_Condition = '0');

UPDATE mental_health
SET Mental_Health_Condition = 
    CASE 
        WHEN RAND(CHECKSUM(NEWID())) <= @PercentageZero THEN 0
        ELSE 1
    END
WHERE Mental_Health_Condition IS NULL;




DECLARE @EmployeeID INT; 
DECLARE @MentalHealthCondition INT; 
DECLARE employee_cursor CURSOR FOR
SELECT User_ID FROM mental_health WHERE Mental_Health_Condition IS NULL;

OPEN employee_cursor;

FETCH NEXT FROM employee_cursor INTO @EmployeeID;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF RAND(CHECKSUM(NEWID())) <= @PercentageZero
    BEGIN
        SET @MentalHealthCondition = 0;
    END
    ELSE
    BEGIN
        SET @MentalHealthCondition = 1;
    END

    UPDATE mental_health
    SET Mental_Health_Condition = @MentalHealthCondition
    WHERE User_ID = @EmployeeID;

    FETCH NEXT FROM employee_cursor INTO @EmployeeID;
END;

CLOSE employee_cursor;
DEALLOCATE employee_cursor;

--Sleep_Hours
UPDATE mental_health
	SET Sleep_Hours = (SELECT CAST(AVG(Sleep_Hours) AS FLOAT) FROM mental_health)
	WHERE Sleep_Hours IS NULL

--Mode
UPDATE mental_health
	SET Sleep_Hours = (SELECT TOP 1 Sleep_Hours FROM mental_health GROUP BY Sleep_Hours ORDER BY COUNT(*) DESC)
	WHERE Sleep_Hours IS NULL

--Median
UPDATE mental_health
	SET Sleep_Hours = (SELECT AVG(Sleep_Hours) FROM mental_health WHERE User_ID IN (500, 501))
	WHERE Sleep_Hours IS NULL

WITH CTE
AS
(	--mean
	SELECT AVG(sleep_hours) sleep
	FROM mental_health
	UNION 
	--mode
	select Top 1 Sleep_Hours 
	from mental_health
	group by Sleep_Hours
	Order by count(*) desc
	UNION
	--median
	SELECT AVG(Sleep_Hours)
	FROM mental_health
	WHERE User_ID IN (500,501)
	)
UPDATE mental_health
	SET Sleep_Hours = (SELECT MIN(sleep) FROM CTE)
	WHERE Sleep_Hours IS NULL


--Work hours

DECLARE @dem INT = 1;
DECLARE @total INT = (SELECT COUNT(*) FROM mental_health WHERE Work_Hours IS NULL) + 1;

SELECT Age AS age, Gender AS gender, Occupation AS occ, User_ID AS usid, ROW_NUMBER() OVER(ORDER BY User_ID) AS row_number_
INTO #CTE5
FROM mental_health
WHERE Work_Hours IS NULL;

WHILE @dem < @total
BEGIN
	SELECT AVG(Work_Hours)
							FROM mental_health c
							WHERE c.Age = (	SELECT age 
											FROM #CTE5
											WHERE row_number_ = @dem
											) AND Work_Hours IS NOT NULL AND c.Gender = (	SELECT gender 
																							FROM #CTE5
																							WHERE row_number_ = @dem
																							) AND c.Occupation = (	SELECT occ 
																													FROM #CTE5
																													WHERE row_number_ = @dem
																													)
    SET @dem = @dem + 1;
END;

DROP TABLE #CTE5;

------------------------------------------------------------------------------------------------------------------------------------------------

--Age
UPDATE mental_health
	SET Age = (SELECT AVG(Age) FROM mental_health)
	WHERE Age is NULL

--DECLARE @dem INT = 1

--WHILE @dem < 6
--BEGIN 
--	UPDATE mental_health
--		SET Work_Hours = (SELECT AVG(Work_Hours) FROM mental_health WHERE Age IN (	SELECT Age
--																					FROM mental_health
--																					WHERE Work_Hours IS NOT NULL))
--		WHERE Work_Hours IS NULL
--	SET @dem = @dem + 1
--END


--UPDATE mental_health
--SET Work_Hours = NULL
--WHERE User_ID = 1

-- Để điền vào những chỗ trống trong field theo giá trị 0 và 1. Dựa trên số liệu là 1(số người mắc bệnh),
-- 0(Số người không mắc bệnh) và số khoảng trống chưa điền.
-- Em sẽ tính lấy ngẫu nhiên theo phần trăm để điền vào những ô còn thiếu.

DECLARE @PercentageZero FLOAT;
SET @PercentageZero = (SELECT CAST(COUNT(*) AS FLOAT) / 
                             ((SELECT COUNT(*) FROM mental_health) - (SELECT COUNT(*) FROM mental_health WHERE Mental_Health_Condition IS NULL))
                       FROM mental_health 
                       WHERE Mental_Health_Condition = '0');

UPDATE mental_health
SET Mental_Health_Condition = 
    CASE 
        WHEN RAND(CHECKSUM(NEWID())) <= @PercentageZero THEN 0
        ELSE 1
    END
WHERE Mental_Health_Condition IS NULL;

DECLARE @EmployeeID INT; 
DECLARE @MentalHealthCondition INT; 
DECLARE employee_cursor CURSOR FOR
SELECT User_ID FROM mental_health WHERE Mental_Health_Condition IS NULL;

OPEN employee_cursor;

FETCH NEXT FROM employee_cursor INTO @EmployeeID;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF RAND(CHECKSUM(NEWID())) <= @PercentageZero
    BEGIN
        SET @MentalHealthCondition = 0;
    END
    ELSE
    BEGIN
        SET @MentalHealthCondition = 1;
    END

    UPDATE mental_health
    SET Mental_Health_Condition = @MentalHealthCondition
    WHERE User_ID = @EmployeeID;

    FETCH NEXT FROM employee_cursor INTO @EmployeeID;
END;

CLOSE employee_cursor;
DEALLOCATE employee_cursor;

--Sleep_Hours
UPDATE mental_health
	SET Sleep_Hours = (SELECT CAST(AVG(Sleep_Hours) AS FLOAT) FROM mental_health)
	WHERE Sleep_Hours IS NULL

--Mode
UPDATE mental_health
	SET Sleep_Hours = (SELECT TOP 1 Sleep_Hours FROM mental_health GROUP BY Sleep_Hours ORDER BY COUNT(*) DESC)
	WHERE Sleep_Hours IS NULL

--Median
UPDATE mental_health
	SET Sleep_Hours = (SELECT AVG(Sleep_Hours) FROM mental_health WHERE User_ID IN (500, 501))
	WHERE Sleep_Hours IS NULL



WITH CTE
AS
(	--mean
	SELECT AVG(sleep_hours) sleep
	FROM mental_health
	UNION 
	--mode
	select Top 1 Sleep_Hours 
	from mental_health
	group by Sleep_Hours
	Order by count(*) desc
	UNION
	--median
	SELECT AVG(Sleep_Hours)
	FROM mental_health
	WHERE User_ID IN (500,501)
	)
	SELECT MIN(sleep) FROM CTE


--Age
SELECT *
FROM mental_health
WHERE Age IN (	SELECT MIN(Age) FROM mental_health) OR Age IN (	SELECT MAX(Age) FROM mental_health)
ORDER BY Age

--Gender
SELECT * 
FROM mental_health
WHERE Gender NOT IN ('Male', 'Female', 'Non-binary', 'Prefer not to say')

--Occupation
SELECT * 
FROM mental_health
WHERE Occupation NOT IN ('IT', 'Finance', 'Healthcare', 'Education', 'Engineering', 'Sales', 'Other')

--Country
SELECT * 
FROM mental_health
WHERE Country NOT IN ('USA', 'India', 'UK', 'Canada', 'Australia', 'Germany', 'Other')

--Mental_Health_Condition
SELECT * 
FROM mental_health
WHERE Mental_Health_Condition NOT IN (0, 1)

--Severity
SELECT * 
FROM mental_health
WHERE Severity NOT IN ('Low', 'Medium', 'High', 'None')

--Consultation_History
SELECT * 
FROM mental_health
WHERE Consultation_History NOT IN (0, 1)

--Stress_Level
SELECT * 
FROM mental_health
WHERE Severity NOT IN ('Low', 'Medium', 'High')

--Sleep_Hours
SELECT *
FROM mental_health
WHERE Sleep_Hours IN (	SELECT MIN(Sleep_Hours) FROM mental_health) OR Sleep_Hours IN (	SELECT MAX(Sleep_Hours) FROM mental_health)
ORDER BY Sleep_Hours

--Work_Hours
SELECT *
FROM mental_health
WHERE Work_Hours IN (	SELECT MIN(Work_Hours) FROM mental_health) OR Work_Hours IN (	SELECT MAX(Work_Hours) FROM mental_health)
ORDER BY Work_Hours


UPDATE mental_health
SET Sleep_Hours = ROUND(Sleep_Hours, 2);

--Work hours
DECLARE @dem INT = 1;
DECLARE @total INT = (SELECT COUNT(*) FROM mental_health WHERE Work_Hours IS NULL) + 1;

SELECT Age AS age, Gender AS gender, Occupation AS occ, User_ID AS usid, ROW_NUMBER() OVER(ORDER BY User_ID) AS row_number_
INTO #CTE5
FROM mental_health
WHERE Work_Hours IS NULL;

WHILE @dem < @total
BEGIN
	UPDATE mental_health 
		SET Work_Hours = (	SELECT AVG(Work_Hours)
							FROM mental_health c
							WHERE c.Age = (	SELECT age 
											FROM #CTE5
											WHERE row_number_ = @dem
											) AND Work_Hours IS NOT NULL AND c.Gender = (	SELECT gender 
																							FROM #CTE5
																							WHERE row_number_ = @dem
																							) AND c.Occupation = (	SELECT occ 
																													FROM #CTE5
																													WHERE row_number_ = @dem
																													))
		WHERE Work_Hours IS NULL
    SET @dem = @dem + 1;
END;

DROP TABLE #CTE5;

