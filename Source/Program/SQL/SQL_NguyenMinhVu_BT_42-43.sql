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

SELECT CONVERT(DATE, Recording_date, 101) AS ConvertedDate
FROM mental_health;

SELECT Recording_date FROM mental_health