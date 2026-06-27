-----------------------------------------------------------------------Cleaning Data-------------------------------------------------------------------------------------

--------------------------------------------Kiem tra du lieu 

SELECT * FROM Youtube_Table
ORDER BY Youtube_Table.[index] ASC
--------------------------------------------Kiem tra cac du lieu bi thieu

SELECT * FROM Youtube_Table
WHERE video_id IS NULL OR trending_date IS NULL OR title IS NULL OR channel_title IS NULL 
OR category_id IS NULL OR publish_date IS NULL OR time_frame IS NULL OR published_day_of_week IS NULL
OR publish_country IS NULL OR tags IS NULL OR views IS NULL OR likes IS NULL OR dislikes IS NULL 
OR comment_count IS NULL OR comments_disabled IS NULL OR ratings_disabled IS NULL OR video_error_or_removed IS NULL

--------------------------------------------Tao bang tạm
SELECT * INTO Youtube_Test
FROM Youtube_Table
--------------------------------------------Chu dong xoa, chinh sua tat ca cac fields 5 gia tri ngoai tru cac fields ID

--Trending date

UPDATE Youtube_Test
	SET trending_date = '2017-13-11'
	WHERE Youtube_Test.[index] BETWEEN 25 AND 29

--Publish date

UPDATE Youtube_Test
	SET publish_date = '17-11-13'
	WHERE Youtube_Test.[index] BETWEEN 5 AND 9

--Views

UPDATE Youtube_Test
	SET views = NULL
	WHERE Youtube_Test.[index] BETWEEN 25 AND 29

--Likes

UPDATE Youtube_Test
	SET likes = NULL
	WHERE Youtube_Test.[index] BETWEEN 30 AND 34

--Dislikes

UPDATE Youtube_Test
	SET dislikes = NULL
	WHERE Youtube_Test.[index] BETWEEN 35 AND 39

--Comment count

UPDATE Youtube_Test
	SET comment_count = NULL
	WHERE Youtube_Test.[index] BETWEEN 40 AND 44

--Comments disable

UPDATE Youtube_Test
	SET comments_disabled = NULL
	WHERE Youtube_Test.[index] BETWEEN 45 AND 49

--Ratings disable

UPDATE Youtube_Test
	SET ratings_disabled = NULL
	WHERE Youtube_Test.[index] BETWEEN 50 AND 54

--Video error or removed

UPDATE Youtube_Test
	SET video_error_or_removed = NULL
	WHERE Youtube_Test.[index] BETWEEN 55 AND 59

--Tags

UPDATE Youtube_Test
	SET tags = NULL
	WHERE Youtube_Test.[index] BETWEEN 65 AND 69



-------------------------------------------------Dien cac gia tri vao cac fields NULL

--Trending date, Publish date
	SELECT * FROM Youtube_Test
	ORDER BY Youtube_Test.[index] ASC
	
	--Convert Date to String
	SELECT CONVERT(NVARCHAR, trending_date, 120) AS ConvertedString
	FROM Youtube_Table;
	SELECT CONVERT(NVARCHAR, publish_date, 120) AS ConvertedString
	FROM Youtube_Table;
	
	ALTER TABLE Youtube_Test
	ALTER COLUMN publish_date NVARCHAR(MAX);
	
	--Kiem tra kieu du lieu
	SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'Youtube_Test';

	--20177-11-14 -> 2017-11-14
	SELECT trending_date
	FROM Youtube_Test 
	WHERE trending_date NOT LIKE '%-__-%'

	UPDATE a
	SET a.trending_date = REPLACE(a.trending_date, SUBSTRING(a.trending_date, 1, 5), '2017')
	FROM Youtube_Test a
	WHERE a.trending_date NOT LIKE '____-%';

	--2017-111-14 -> 2017-11-14
	UPDATE a
	SET a.trending_date = REPLACE(a.trending_date, SUBSTRING(a.trending_date, 6, 3), '11')
	FROM Youtube_Test a
	WHERE a.trending_date NOT LIKE '%-__-%';

	--2017-11-144 -> 2017-11-14
	UPDATE a
	SET a.trending_date = REPLACE(a.trending_date, SUBSTRING(a.trending_date, 9, 3), '14')
	FROM Youtube_Test a
	WHERE a.trending_date NOT LIKE '%-__';

	--2017-13-11 -> 2017-11-13
	UPDATE a
	SET a.publish_date = (	SELECT SUBSTRING(CONCAT(publish_date, '-' + SUBSTRING(publish_date, 6, 2)), 1, 4) + SUBSTRING(CONCAT(publish_date, '-' + SUBSTRING(publish_date, 6, 2)), 8, 6)   
							FROM Youtube_Test
							WHERE publish_date LIKE '____-[1][3-9]-__' AND a.[index] = Youtube_Test.[index])
	FROM Youtube_Test a
	WHERE publish_date LIKE '____-[1][3-9]-__';

	--11-13-2017 -> 2017-11-13
	UPDATE a
	SET a.publish_date = (	SELECT SUBSTRING(CONCAT(publish_date, '-' + SUBSTRING(publish_date, 1, 2) + '-' + SUBSTRING(publish_date, 4, 2)), 7, 17)  
							FROM Youtube_Test
							WHERE publish_date LIKE '__-[1][3-9]-____' AND a.[index] = Youtube_Test.[index])
	FROM Youtube_Test a
	WHERE publish_date LIKE '__-[1][3-9]-____';

	--13-11-2017 -> 2017-11-13
	UPDATE a
	SET a.publish_date = (	SELECT SUBSTRING(CONCAT(publish_date, '-' + SUBSTRING(publish_date, 4, 2) + '-' + SUBSTRING(publish_date, 1, 2)), 7, 17)  
							FROM Youtube_Test
							WHERE publish_date LIKE '%-2017' AND a.[index] = Youtube_Test.[index])
	FROM Youtube_Test a
	WHERE publish_date LIKE '%-2017';

	--17-11-13 -> 2017-11-13
	UPDATE a
	SET a.publish_date = (	SELECT SUBSTRING(CONCAT(publish_date, '20' + SUBSTRING(publish_date, 1, 2) + '-' + SUBSTRING(publish_date, 4, 2)) + '-' + SUBSTRING(publish_date, 7, 2), 9, 19)  
							FROM Youtube_Test
							WHERE publish_date LIKE '__-__-__' AND a.[index] = Youtube_Test.[index])
	FROM Youtube_Test a
	WHERE publish_date LIKE '__-__-__';

	ALTER TABLE Youtube_Test
	ALTER COLUMN trending_date DATE;

--Views
	WITH CTE
	AS
	(	--mean
		SELECT CAST(AVG(CAST(views AS BIGINT)) AS BIGINT) AS AvgViews
		FROM Youtube_Test
		WHERE views IS NOT NULL
		UNION 
		--mode
		SELECT TOP 1 views 
		FROM Youtube_Test
		WHERE views IS NOT NULL
		GROUP BY views
		ORDER BY COUNT(*) DESC
		UNION
		--median
		SELECT AVG(views)
		FROM Youtube_Test
		WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test) AND views IS NOT NULL
		)
	UPDATE Youtube_Test
		SET views = (SELECT MIN(AvgViews) FROM CTE)
		WHERE views IS NULL

--Likes
	WITH CTE 
	AS
	(
		--mean
		SELECT CAST(AVG(CAST(likes AS BIGINT)) AS BIGINT) AS AvgLikes
		FROM Youtube_Test
		WHERE likes IS NOT NULL
		UNION
		--mode
		SELECT TOP 1 likes
		FROM Youtube_Test
		WHERE likes IS NOT NULL
		GROUP BY likes
		ORDER BY COUNT(likes) DESC
		UNION
		--median
		SELECT AVG(likes)
		FROM Youtube_Test
		WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test) AND likes IS NOT NULL
	)
	UPDATE Youtube_Test 
		SET likes = (SELECT MIN(AvgLikes) FROM CTE)
		WHERE likes IS NULL

--Dislikes
	WITH CTE 
	AS
	(
		--mean
		SELECT CAST(AVG(CAST(dislikes AS BIGINT)) AS BIGINT) AS AvgDislikes
		FROM Youtube_Test
		WHERE dislikes IS NOT NULL
		UNION
		--mode
		SELECT TOP 1 dislikes
		FROM Youtube_Test
		WHERE dislikes IS NOT NULL
		GROUP BY dislikes
		ORDER BY (COUNT(dislikes)) DESC
		UNION
		--median
		SELECT AVG(dislikes)
		FROM Youtube_Test
		WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test) AND dislikes IS NOT NULL
	)
	UPDATE Youtube_Test
		SET dislikes = (SELECT MIN(Avgdislikes) FROM CTE)
		WHERE dislikes IS NULL

--Comment count
	WITH CTE 
	AS
	(
		--mean
		SELECT CAST(AVG(CAST(comment_count AS BIGINT)) AS BIGINT) AS AvgCommentcount
		FROM Youtube_Test
		WHERE comment_count IS NOT NULL
		UNION
		--mode
		SELECT TOP 1 comment_count
		FROM Youtube_Test
		WHERE comment_count IS NOT NULL
		GROUP BY comment_count
		ORDER BY (COUNT(comment_count)) DESC
		UNION
		--median
		SELECT AVG(comment_count)
		FROM Youtube_Test
		WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test) AND comment_count IS NOT NULL
	)
	UPDATE Youtube_Test
		SET comment_count = (SELECT MIN(AvgCommentcount) FROM CTE)
		WHERE comment_count IS NULL

	SELECT * FROM Youtube_Table_2
	ORDER BY Youtube_Table_2.[index] ASC

--Comments Disabled
--Update theo xac suat
DECLARE @PercentageZero FLOAT;
SET @PercentageZero = (SELECT CAST(COUNT(*) AS FLOAT) / ((SELECT COUNT(*) FROM Youtube_Test) - (SELECT COUNT(*) FROM Youtube_Test WHERE comments_disabled IS NULL))
                       FROM Youtube_Test 
                       WHERE comments_disabled = '0');
DECLARE @Index INT; 
DECLARE @comments_disabled INT; 
DECLARE YT_cursor CURSOR FOR
SELECT [index] FROM Youtube_Test WHERE comments_disabled IS NULL;

OPEN YT_cursor;

FETCH NEXT FROM YT_cursor INTO @Index;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF RAND(CHECKSUM(NEWID())) <= @PercentageZero
    BEGIN
        SET @comments_disabled = 0;
    END
    ELSE
    BEGIN
        SET @comments_disabled = 1;
    END

    UPDATE Youtube_Test
    SET comments_disabled = @comments_disabled
    WHERE [index] = @Index;

    FETCH NEXT FROM YT_cursor INTO @Index;
END;

CLOSE YT_cursor;
DEALLOCATE YT_cursor;

--Ratings Disabled
DECLARE @PercentageZero FLOAT;
SET @PercentageZero = (SELECT CAST(COUNT(*) AS FLOAT) / ((SELECT COUNT(*) FROM Youtube_Test) - (SELECT COUNT(*) FROM Youtube_Test WHERE ratings_disabled IS NULL))
                       FROM Youtube_Test 
                       WHERE ratings_disabled = '0');
DECLARE @Index INT; 
DECLARE @ratings_disabled INT; 
DECLARE YT_cursor CURSOR FOR
SELECT [index] FROM Youtube_Test WHERE ratings_disabled IS NULL;

OPEN YT_cursor;

FETCH NEXT FROM YT_cursor INTO @Index;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF RAND(CHECKSUM(NEWID())) <= @PercentageZero
    BEGIN
        SET @ratings_disabled = 0;
    END
    ELSE
    BEGIN
        SET @ratings_disabled = 1;
    END

    UPDATE Youtube_Test
    SET ratings_disabled = @ratings_disabled
    WHERE [index] = @Index;

    FETCH NEXT FROM YT_cursor INTO @Index;
END;

CLOSE YT_cursor;
DEALLOCATE YT_cursor;

--Video Error Or Removed
DECLARE @PercentageZero FLOAT;
SET @PercentageZero = (SELECT CAST(COUNT(*) AS FLOAT) / ((SELECT COUNT(*) FROM Youtube_Test) - (SELECT COUNT(*) FROM Youtube_Test WHERE video_error_or_removed IS NULL))
                       FROM Youtube_Test 
                       WHERE video_error_or_removed = '0');
DECLARE @Index INT; 
DECLARE @video_error_or_removed INT; 
DECLARE YT_cursor CURSOR FOR
SELECT [index] FROM Youtube_Test WHERE video_error_or_removed IS NULL;

OPEN YT_cursor;

FETCH NEXT FROM YT_cursor INTO @Index;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF RAND(CHECKSUM(NEWID())) <= @PercentageZero
    BEGIN
        SET @video_error_or_removed = 0;
    END
    ELSE
    BEGIN
        SET @video_error_or_removed = 1;
    END

    UPDATE Youtube_Test
    SET video_error_or_removed = @video_error_or_removed
    WHERE [index] = @Index;

    FETCH NEXT FROM YT_cursor INTO @Index;
END;

CLOSE YT_cursor;
DEALLOCATE YT_cursor;

SELECT * FROM Youtube_Test
ORDER BY Youtube_Test.[index] ASC

--Tags
	UPDATE Youtube_Test
		SET tags = (SELECT CONCAT(SUBSTRING(title, 1, 6), '|"', SUBSTRING(title, 9, 6), '""|""', SUBSTRING(title, 19, 7), '""|""', SUBSTRING(title, 30, 17), '""|""', '2018', '""|""', 'Movie', '""|""', (SELECT channel_title FROM Youtube_Test WHERE [index] = 65), '"""')
					FROM Youtube_Test
					WHERE [index] =	65)
		WHERE [index] = 65
	
	UPDATE Youtube_Test
		SET tags = (SELECT CONCAT(SUBSTRING(title, 1, 7), '|"', SUBSTRING(title, 9, 21), '""|""', SUBSTRING(title, 23, 12), '""|""', SUBSTRING(title, 40, 6), '""|""', (SELECT channel_title FROM Youtube_Test WHERE [index] = 66), '"""')
					FROM Youtube_Test
					WHERE [index] =	66)
		WHERE [index] = 66
	
	UPDATE Youtube_Test
		SET tags = (SELECT CONCAT(SUBSTRING(title, 1, 7), '|"', SUBSTRING(title, 9, 19), '""|""', SUBSTRING(title, 12, 6), '""|""', SUBSTRING(title, 12, 16), '""|""', SUBSTRING(title, 21, 7), '""|""', (SELECT channel_title FROM Youtube_Test WHERE [index] = 67), '"""')
					FROM Youtube_Test
					WHERE [index] =	67)
		WHERE [index] = 67
	
	UPDATE Youtube_Test
		SET tags = (SELECT CONCAT(SUBSTRING(title, 1, 5), '|"', SUBSTRING(title, 7, 6), '""|""', SUBSTRING(title, 14, 6), '""|""', SUBSTRING(title, 7, 13), '""|""', SUBSTRING(title, 26, 36), '""|""', SUBSTRING(title, 49, 12), '""|""', SUBSTRING(title, 63, 6), '""|""', (SELECT channel_title FROM Youtube_Test WHERE [index] = 68), '"""')
					FROM Youtube_Test
					WHERE [index] =	68)
		WHERE [index] = 68
	
	UPDATE Youtube_Test
		SET tags = (SELECT CONCAT(SUBSTRING(title, 1, 10), '|"', SUBSTRING(title, 12, 9), '""|""', SUBSTRING(title, 25, 4), '""|""', SUBSTRING(title, 33, 14), '"""')
					FROM Youtube_Test
					WHERE [index] =	69)
		WHERE [index] = 69
	

-------------------------------------------------Lam min du lieu

--Chia thanh 10 nhom views
--Lam min theo mean
	WITH RankedData 
	AS 
	(
		SELECT views, NTILE(10) OVER (ORDER BY views ASC) AS range_group 
		FROM Youtube_Test
	), 
	RangeAverages 
	AS 
	(
	    SELECT range_group, CAST(AVG(CAST(views AS BIGINT)) AS BIGINT) AS avg_views
	    FROM RankedData
	    GROUP BY range_group
	)
	UPDATE yt
	SET yt.views = ra.avg_views
	FROM Youtube_Test yt
	JOIN RankedData rd ON yt.views = rd.views
	JOIN RangeAverages ra ON rd.range_group = ra.range_group;

--Lam min theo median
	SELECT views INTO view_median
	FROM Youtube_Test
	
	WITH RankedData2 
	AS 
	(
		SELECT views, NTILE(10) OVER (ORDER BY views ASC) AS range_group 
		FROM view_median
	), 
	RangeMedian 
	AS 
	(
	    SELECT range_group, (CAST(MIN(views) AS BIGINT) + CAST(MAX(views) AS BIGINT)) / 2 AS median_views
	    FROM RankedData2
	    GROUP BY range_group
	)
	UPDATE yt
	SET yt.views = rm.median_views
	FROM view_median yt
	JOIN RankedData2 rd ON yt.views = rd.views
	JOIN RangeMedian rm ON rd.range_group = rm.range_group;

	SELECT * FROM view_median ORDER BY views

--Lam min theo boundaries

	SELECT views INTO view_boundaries
	FROM Youtube_Table

	WITH RankedData3 AS (
    SELECT 
        views, 
        NTILE(10) OVER (ORDER BY views ASC) AS range_group 
    FROM view_boundaries
	), 
	RangeBoundaries AS (
	    SELECT 
	        range_group, 
	        CASE 
	            WHEN ABS(CAST(MAX(views) AS BIGINT) - MAX(views)) > ABS(MAX(views) - CAST(MIN(views) AS BIGINT)) 
	                THEN CAST(MIN(views) AS BIGINT) 
	            ELSE CAST(MAX(views) AS BIGINT) 
	        END AS boundaries_views
	    FROM RankedData3
	    GROUP BY range_group
	)
	UPDATE yt
	SET yt.views = rb.boundaries_views
	FROM view_boundaries yt
	JOIN RankedData3 rd ON yt.views = rd.views
	JOIN RangeBoundaries rb ON rd.range_group = rb.range_group;

	SELECT * FROM view_boundaries ORDER BY views

--Tim field co do lech chuan lon nhat trong du lieu
	SELECT * INTO Youtube_Table_2 FROM Youtube_Table
	
	SELECT * FROM Youtube_Table_2

	WITH CTE1 AS 
	(
		SELECT ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS ColIndex, 
	           COLUMN_NAME AS ColName
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'Youtube_Table_2' AND ORDINAL_POSITION BETWEEN 12 AND 15
	),
	CTE2 AS 
	(
		SELECT 1 AS ColIndex, CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(views AS FLOAT), 2)) - POWER(AVG(CAST(views AS FLOAT)), 2)) AS BIGINT) AS dlc
		FROM Youtube_Table_2
		UNION ALL
		SELECT 2 AS ColIndex, CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(likes AS FLOAT), 2)) - POWER(AVG(CAST(likes AS FLOAT)), 2)) AS BIGINT)
		FROM Youtube_Table_2
		UNION ALL
		SELECT 3 AS ColIndex, CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(dislikes AS FLOAT), 2)) - POWER(AVG(CAST(dislikes AS FLOAT)), 2)) AS BIGINT)
		FROM Youtube_Table_2
		UNION ALL
		SELECT 4 AS ColIndex, CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(comment_count AS FLOAT), 2)) - POWER(AVG(CAST(comment_count AS FLOAT)), 2)) AS BIGINT)
		FROM Youtube_Table_2
	)
	SELECT c1.ColName, c2.dlc
	FROM CTE1 c1
	JOIN CTE2 c2 ON c1.ColIndex = c2.ColIndex;


--Tim va thay doi 5 giá trị nhỏ nhất trong views
	UPDATE Youtube_Test
		SET views = views * 1.1
		WHERE [index] IN (SELECT TOP 5 [index] FROM Youtube_Test ORDER BY views ASC)
--Tìm va thay doi 5 giá trị lớn nhất trong views
	UPDATE Youtube_Test
		SET views = views * 0.9
		WHERE [index] IN (SELECT TOP 5 [index] FROM Youtube_Test ORDER BY views DESC)

--Xac dinh gia tri ngoai le
--Views
	WITH CTE1
	AS 
	(
		--Q1
		SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Table_2) views AS views_q1
		FROM Youtube_Table_2 
		ORDER BY views ASC
	), CTE2
	AS
	(
		--Q2
		SELECT TOP ( SELECT COUNT(*) / 2 FROM Youtube_Table_2) views AS views_q2
		FROM Youtube_Table_2 
		ORDER BY views ASC
	), CTE3
	AS
	(
		--Q3
		SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Table_2) views AS views_q3
		FROM Youtube_Table_2 
		ORDER BY views ASC
	)
	SELECT *
	FROM Youtube_Table_2
	WHERE views < ((SELECT MAX(views_q1) FROM CTE1) - 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1))) OR views > ((SELECT MAX(views_q3) FROM CTE3) + 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1)))
	ORDER BY views ASC

--Likes
	WITH CTE1
	AS 
	(
		--Q1
		SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Table_2) likes AS likes_q1
		FROM Youtube_Table_2 
		ORDER BY likes ASC
	), CTE3
	AS
	(
		--Q3
		SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Table_2) likes AS likes_q3
		FROM Youtube_Table_2 
		ORDER BY likes ASC
	)
	SELECT *
	FROM Youtube_Table_2
	WHERE likes < ((SELECT MAX(likes_q1) FROM CTE1) - 1.5 * ((SELECT MAX(likes_q3) FROM CTE3) - (SELECT MAX(likes_q1) FROM CTE1))) OR likes > ((SELECT MAX(likes_q3) FROM CTE3) + 1.5 * ((SELECT MAX(likes_q3) FROM CTE3) - (SELECT MAX(likes_q1) FROM CTE1)))
	ORDER BY likes ASC

--Dislikes
	WITH CTE1
	AS 
	(
		--Q1
		SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Table_2) dislikes AS dislikes_q1
		FROM Youtube_Table_2 
		ORDER BY dislikes ASC
	), CTE3
	AS
	(
		--Q3
		SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Table_2) dislikes AS dislikes_q3
		FROM Youtube_Table_2 
		ORDER BY dislikes ASC
	)
	SELECT *
	FROM Youtube_Table_2
	WHERE dislikes < ((SELECT MAX(dislikes_q1) FROM CTE1) - 1.5 * ((SELECT MAX(dislikes_q3) FROM CTE3) - (SELECT MAX(dislikes_q1) FROM CTE1))) OR dislikes > ((SELECT MAX(dislikes_q3) FROM CTE3) + 1.5 * ((SELECT MAX(dislikes_q3) FROM CTE3) - (SELECT MAX(dislikes_q1) FROM CTE1)))
	ORDER BY dislikes ASC

--Comment Count
	WITH CTE1
	AS 
	(
		--Q1
		SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Table_2) comment_count AS comment_q1
		FROM Youtube_Table_2 
		ORDER BY comment_count ASC
	), CTE3
	AS
	(
		--Q3
		SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Table_2) comment_count AS comment_q3
		FROM Youtube_Table_2 
		ORDER BY comment_count ASC
	)
	SELECT *
	FROM Youtube_Table_2
	WHERE comment_count < ((SELECT MAX(comment_q1) FROM CTE1) - 1.5 * ((SELECT MAX(comment_q3) FROM CTE3) - (SELECT MAX(comment_q1) FROM CTE1))) OR comment_count > ((SELECT MAX(comment_q3) FROM CTE3) + 1.5 * ((SELECT MAX(comment_q3) FROM CTE3) - (SELECT MAX(comment_q1) FROM CTE1)))
	ORDER BY comment_count ASC

-----------------------------------------------------------------------Cleaning Data-------------------------------------------------------------------------------------

-----------------------------------------------------Data Transformation and Data Discretization-------------------------------------------------------------------------------------
--publish_country
CREATE TABLE Country_Table (
	country_name NVARCHAR(20),
	id INT IDENTITY(1,1)
)

INSERT INTO Country_Table(country_name)
SELECT DISTINCT publish_country
FROM Youtube_Test
ORDER BY publish_country ASC

UPDATE Youtube_Test
	SET publish_country = (SELECT id FROM Country_Table WHERE Country_Table.country_name = Youtube_Test.publish_country)
	WHERE publish_country IN (SELECT country_name FROM Country_Table)

ALTER TABLE Youtube_Test
ALTER COLUMN publish_country INT;

SELECT * 
FROM Youtube_Test
ORDER BY [index] ASC

--published_day_of_week
CREATE TABLE DOW_Table (
	day_name NVARCHAR(20),
	id INT 
)
INSERT INTO DOW_Table (id, day_name)
SELECT DISTINCT IIF(published_day_of_week = 'Monday', 2, IIF(published_day_of_week = 'Tuesday', 3, IIF(published_day_of_week = 'Wednesday', 4, IIF(published_day_of_week = 'Thursday', 5, IIF(published_day_of_week = 'Friday', 6, IIF(published_day_of_week = 'Saturday', 7, 1)))))) AS num, published_day_of_week
FROM Youtube_Test
WHERE published_day_of_week NOT IN (SELECT day_name FROM DOW_Table)

SELECT * 
FROM DOW_Table

UPDATE Youtube_Test
	SET published_day_of_week = (SELECT id FROM DOW_Table WHERE DOW_Table.day_name = Youtube_Test.published_day_of_week)
	WHERE published_day_of_week IN (SELECT day_name FROM DOW_Table)

ALTER TABLE Youtube_Test
ALTER COLUMN published_day_of_week INT;

--time_frame
CREATE TABLE TF_Table
(
	id INT,
	time_frame NVARCHAR(200),
)

INSERT INTO TF_Table (id, time_frame)
SELECT DISTINCT CASE 
        WHEN time_frame = '0:00 to 0:59' THEN 1
        WHEN time_frame = '1:00 to 1:59' THEN 2
        WHEN time_frame = '2:00 to 2:59' THEN 3
        WHEN time_frame = '3:00 to 3:59' THEN 4
        WHEN time_frame = '4:00 to 4:59' THEN 5
        WHEN time_frame = '5:00 to 5:59' THEN 6
        WHEN time_frame = '6:00 to 6:59' THEN 7
        WHEN time_frame = '7:00 to 7:59' THEN 8
        WHEN time_frame = '8:00 to 8:59' THEN 9
        WHEN time_frame = '9:00 to 9:59' THEN 10
        WHEN time_frame = '10:00 to 10:59' THEN 11
        WHEN time_frame = '11:00 to 11:59' THEN 12
        WHEN time_frame = '12:00 to 12:59' THEN 13
        WHEN time_frame = '13:00 to 13:59' THEN 14
        WHEN time_frame = '14:00 to 14:59' THEN 15
        WHEN time_frame = '15:00 to 15:59' THEN 16
        WHEN time_frame = '16:00 to 16:59' THEN 17
        WHEN time_frame = '17:00 to 17:59' THEN 18
        WHEN time_frame = '18:00 to 18:59' THEN 19
        WHEN time_frame = '19:00 to 19:59' THEN 20
        WHEN time_frame = '20:00 to 20:59' THEN 21
        WHEN time_frame = '21:00 to 21:59' THEN 22
        WHEN time_frame = '22:00 to 22:59' THEN 23
        ELSE 24
    END AS idtime, time_frame
FROM Youtube_Test
WHERE time_frame NOT IN (SELECT time_frame FROM TF_Table)

SELECT DISTINCT time_frame
FROM Youtube_Test

UPDATE Youtube_Test
	SET time_frame = (SELECT id FROM TF_Table WHERE TF_Table.time_frame = Youtube_Test.time_frame)
	WHERE time_frame IN (SELECT time_frame FROM TF_Table)

ALTER TABLE Youtube_Test
ALTER COLUMN time_frame INT;

SELECT * 
FROM Youtube_Test
ORDER BY [index] ASC

--Kieu boolean
ALTER TABLE Youtube_Test
ADD field_bool INT
UPDATE m
SET m.field_bool = (SELECT CONCAT(CAST(comments_disabled AS NVARCHAR(1)), CAST(ratings_disabled AS NVARCHAR(1)), CAST(video_error_or_removed AS NVARCHAR(1))) FROM Youtube_Test WHERE Youtube_Test.[index] = m.[index])
FROM Youtube_Test m;

CREATE TABLE CRVF (
	comments_disabled BIT,
	ratings_disabled BIT,
	video_error_or_removed BIT,
	field_bool INT
)
INSERT INTO CRVF(comments_disabled, ratings_disabled, video_error_or_removed, field_bool)
SELECT DISTINCT comments_disabled, ratings_disabled, video_error_or_removed, field_bool
FROM Youtube_Test

ALTER TABLE Youtube_Test
DROP COLUMN comments_disabled, ratings_disabled, video_error_or_removed

SELECT DISTINCT trending_date, publish_date
FROM Youtube_Test
ORDER BY trending_date

--Trong quá trình chuyển đổi có yêu cầu tạo ra các table làm trung gian, SV cần tìm cách gộp các table vừa phát sinh có cùng cấu trúc, ý nghĩa để giảm bớt số lượng table thực tế sẽ dùng.
CREATE TABLE Total_Table (
	col1 INT,
	col2 BIT,
	col3 BIT,
	col4 BIT,
	col5 INT,
	col6 NVARCHAR(100)
)
INSERT INTO Total_Table(col1, col2, col3, col4, col5, col6)
SELECT id, NULL, NULL, NULL, NULL, CAST(country_name AS nvarchar(50)) FROM Country_Table
UNION ALL
SELECT NULL, comments_disabled, ratings_disabled, video_error_or_removed, field_bool, NULL FROM CRVF
UNION ALL 
SELECT id, NULL, NULL, NULL, NULL, day_name FROM DOW_Table
UNION ALL
SELECT id, NULL, NULL, NULL, NULL, time_frame FROM TF_Table

SELECT * FROM Total_Table

DROP TABLE Country_Table
DROP TABLE CRVF
DROP TABLE DOW_Table
DROP TABLE TF_Table



--Sau khi hoàn tất tiền xử lý dữ liệu, đối với từng field trong dữ liệu, tùy thuộc kiểu dữ liệu của mỗi field, SV cần thống kê được các giá trị sau
CREATE TABLE ThongKe (
	FieldName NVARCHAR(200),
	Mean NVARCHAR(200),
	Mode NTEXT,
	Median NVARCHAR(200),
	Deviation NVARCHAR(200),
	QTMIN NVARCHAR(200),
	QT25 NVARCHAR(200),
	QT50 NVARCHAR(200),
	QT75 NVARCHAR(200),
	QTMAX NVARCHAR(200),
)
--Trending Date - Mode
WITH CTE AS (
    SELECT trending_date, COUNT(*) AS cnt
    FROM Youtube_Test
    GROUP BY trending_date
)
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'Trending Date', CAST((	SELECT STRING_AGG(trending_date, ' ; ') AS CombinedResult
							FROM CTE
							WHERE cnt = (SELECT MAX(cnt) FROM CTE)) AS NTEXT)
FROM Youtube_Test

SELECT * FROM ThongKe

--Channel Title - Mode
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'Channel Title', (SELECT TOP 1 channel_title
FROM Youtube_Test
GROUP BY channel_title
ORDER BY COUNT(*) DESC)

--Category Id - Mode
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'Category Id', CAST((SELECT TOP 1 category_id
FROM Youtube_Test
GROUP BY category_id
ORDER BY COUNT(*) DESC) AS NVARCHAR(200))

--Publish Date - Mode
WITH CTE AS (
    SELECT publish_date, COUNT(*) AS cnt
    FROM Youtube_Test
    GROUP BY publish_date
)
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'Publish Date', CAST((	SELECT STRING_AGG(publish_date, ' ; ') AS CombinedResult
							FROM CTE
							WHERE cnt = (SELECT MAX(cnt) FROM CTE)) AS NTEXT)
FROM Youtube_Test

--Time Frame - Mode
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'Time Frame', CAST((SELECT TOP 1 time_frame
FROM Youtube_Test
GROUP BY time_frame
ORDER BY COUNT(*) DESC) AS NVARCHAR(200))

--published_day_of_week - Mode
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'published_day_of_week', CAST((SELECT TOP 1 published_day_of_week
FROM Youtube_Test
GROUP BY published_day_of_week
ORDER BY COUNT(*) DESC) AS NVARCHAR(200))

--Publish Country - Mode
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'Publish Country', CAST((SELECT TOP 1 publish_country
FROM Youtube_Test
GROUP BY publish_country
ORDER BY COUNT(*) DESC) AS NVARCHAR(200))

--Views - Mean - Mode - Median - Deviation - MIN - 25 - 50 - 75 - MAX
WITH CTE AS (
    SELECT views, COUNT(*) AS cnt
    FROM Youtube_Test
    GROUP BY views
), CTE1
AS 
(
	--Q1
	SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Test) views AS views_q1
	FROM Youtube_Test 
	ORDER BY views ASC
), CTE2
AS
(
	--Q2
	SELECT TOP ( SELECT COUNT(*) / 2 FROM Youtube_Test) views AS views_q2
	FROM Youtube_Test 
	ORDER BY views ASC
), CTE3
AS
(
	--Q3
	SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Test) views AS views_q3
	FROM Youtube_Test 
	ORDER BY views ASC
)
INSERT INTO ThongKe(FieldName, Mean, Mode, Median, Deviation, QTMIN, QT25, QT50, QT75, QTMAX)
SELECT TOP 1 'Views', CAST((SELECT CAST(AVG(CAST(views AS BIGINT)) AS BIGINT) FROM Youtube_Test) AS NVARCHAR(200)), 
CAST((SELECT STRING_AGG(views, ' ; ') AS CombinedResult FROM CTE WHERE cnt = (SELECT MAX(cnt) FROM CTE)) AS NTEXT),
(SELECT views FROM Youtube_Test WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test)),
(SELECT CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(views AS FLOAT), 2)) - POWER(AVG(CAST(views AS FLOAT)), 2)) AS BIGINT) AS dlc FROM Youtube_Test),
(SELECT ((SELECT MAX(views_q1) FROM CTE1) - 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1)))),
(SELECT MAX(views_q1) FROM CTE1), (SELECT MAX(views_q2) FROM CTE2), (SELECT MAX(views_q3) FROM CTE3),
(SELECT ((SELECT MAX(views_q3) FROM CTE3) + 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1))))

--Likes - Mean - Mode - Median - Deviation - MIN - 25 - 50 - 75 - MAX
WITH CTE AS (
    SELECT likes, COUNT(*) AS cnt
    FROM Youtube_Test
    GROUP BY likes
), CTE1
AS 
(
	--Q1
	SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Test) likes AS views_q1
	FROM Youtube_Test 
	ORDER BY likes ASC
), CTE2
AS
(
	--Q2
	SELECT TOP ( SELECT COUNT(*) / 2 FROM Youtube_Test) likes AS views_q2
	FROM Youtube_Test 
	ORDER BY likes ASC
), CTE3
AS
(
	--Q3
	SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Test) likes AS views_q3
	FROM Youtube_Test 
	ORDER BY likes ASC
)
INSERT INTO ThongKe(FieldName, Mean, Mode, Median, Deviation, QTMIN, QT25, QT50, QT75, QTMAX)
SELECT TOP 1 'Likes', CAST((SELECT CAST(AVG(CAST(likes AS BIGINT)) AS BIGINT) FROM Youtube_Test) AS NVARCHAR(200)), 
CAST((SELECT STRING_AGG(likes, ' ; ') AS CombinedResult FROM CTE WHERE cnt = (SELECT MAX(cnt) FROM CTE)) AS NTEXT),
(SELECT likes FROM Youtube_Test WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test)),
(SELECT CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(likes AS FLOAT), 2)) - POWER(AVG(CAST(likes AS FLOAT)), 2)) AS BIGINT) AS dlc FROM Youtube_Test),
(SELECT ((SELECT MAX(views_q1) FROM CTE1) - 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1)))),
(SELECT MAX(views_q1) FROM CTE1), (SELECT MAX(views_q2) FROM CTE2), (SELECT MAX(views_q3) FROM CTE3),
(SELECT ((SELECT MAX(views_q3) FROM CTE3) + 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1))))

--Dislikes - Mean - Mode - Median - Deviation - MIN - 25 - 50 - 75 - MAX
WITH CTE AS (
    SELECT dislikes, COUNT(*) AS cnt
    FROM Youtube_Test
    GROUP BY dislikes
), CTE1
AS 
(
	--Q1
	SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Test) dislikes AS views_q1
	FROM Youtube_Test 
	ORDER BY dislikes ASC
), CTE2
AS
(
	--Q2
	SELECT TOP ( SELECT COUNT(*) / 2 FROM Youtube_Test) dislikes AS views_q2
	FROM Youtube_Test 
	ORDER BY dislikes ASC
), CTE3
AS
(
	--Q3
	SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Test) dislikes AS views_q3
	FROM Youtube_Test 
	ORDER BY dislikes ASC
)
INSERT INTO ThongKe(FieldName, Mean, Mode, Median, Deviation, QTMIN, QT25, QT50, QT75, QTMAX)
SELECT TOP 1 'Dislikes', CAST((SELECT CAST(AVG(CAST(dislikes AS BIGINT)) AS BIGINT) FROM Youtube_Test) AS NVARCHAR(200)), 
CAST((SELECT STRING_AGG(dislikes, ' ; ') AS CombinedResult FROM CTE WHERE cnt = (SELECT MAX(cnt) FROM CTE)) AS NTEXT),
(SELECT dislikes FROM Youtube_Test WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test)),
(SELECT CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(dislikes AS FLOAT), 2)) - POWER(AVG(CAST(dislikes AS FLOAT)), 2)) AS BIGINT) AS dlc FROM Youtube_Test),
(SELECT ((SELECT MAX(views_q1) FROM CTE1) - 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1)))),
(SELECT MAX(views_q1) FROM CTE1), (SELECT MAX(views_q2) FROM CTE2), (SELECT MAX(views_q3) FROM CTE3),
(SELECT ((SELECT MAX(views_q3) FROM CTE3) + 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1))))

--Commentscount - Mean - Mode - Median - Deviation - MIN - 25 - 50 - 75 - MAX
WITH CTE AS (
    SELECT comment_count, COUNT(*) AS cnt
    FROM Youtube_Test
    GROUP BY comment_count
), CTE1
AS 
(
	--Q1
	SELECT TOP ( SELECT COUNT(*) / 4 FROM Youtube_Test) comment_count AS views_q1
	FROM Youtube_Test 
	ORDER BY comment_count ASC
), CTE2
AS
(
	--Q2
	SELECT TOP ( SELECT COUNT(*) / 2 FROM Youtube_Test) comment_count AS views_q2
	FROM Youtube_Test 
	ORDER BY comment_count ASC
), CTE3
AS
(
	--Q3
	SELECT TOP ( SELECT CAST(ROUND((COUNT(*) * 0.75), 0) AS INT) FROM Youtube_Test) comment_count AS views_q3
	FROM Youtube_Test 
	ORDER BY comment_count ASC
)
INSERT INTO ThongKe(FieldName, Mean, Mode, Median, Deviation, QTMIN, QT25, QT50, QT75, QTMAX)
SELECT TOP 1 'Comment Count', CAST((SELECT CAST(AVG(CAST(comment_count AS BIGINT)) AS BIGINT) FROM Youtube_Test) AS NVARCHAR(200)), 
CAST((SELECT STRING_AGG(comment_count, ' ; ') AS CombinedResult FROM CTE WHERE cnt = (SELECT MAX(cnt) FROM CTE)) AS NTEXT),
(SELECT comment_count FROM Youtube_Test WHERE [index] IN (SELECT COUNT(*) / 2 FROM Youtube_Test)),
(SELECT CAST(SQRT((1.0 / COUNT(*)) * SUM(POWER(CAST(comment_count AS FLOAT), 2)) - POWER(AVG(CAST(comment_count AS FLOAT)), 2)) AS BIGINT) AS dlc FROM Youtube_Test),
(SELECT ((SELECT MAX(views_q1) FROM CTE1) - 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1)))),
(SELECT MAX(views_q1) FROM CTE1), (SELECT MAX(views_q2) FROM CTE2), (SELECT MAX(views_q3) FROM CTE3),
(SELECT ((SELECT MAX(views_q3) FROM CTE3) + 1.5 * ((SELECT MAX(views_q3) FROM CTE3) - (SELECT MAX(views_q1) FROM CTE1))))

--Field Bool - Mode
INSERT INTO ThongKe(FieldName, Mode)
SELECT TOP 1 'Field Bool', CAST((SELECT TOP 1 field_bool
FROM Youtube_Test
GROUP BY field_bool
ORDER BY COUNT(*) DESC) AS NVARCHAR(200))


SELECT *
FROM Youtube_Test
ORDER BY [index] ASC

SELECT * FROM ThongKe

-----------------------------------------------------Data Transformation and Data Discretization-------------------------------------------------------------------------------------

-----------------------------------------------------Data Reduction------------------------------------------------------------------------------------------------------------------
--Phan cum dua theo the loai videos va views(category_id, views)
WITH CTE AS (
    SELECT category_id, SUM(CAST(views AS BIGINT)) AS Views_PC
    FROM Youtube_Test
    GROUP BY category_id
)
SELECT category_id, 
       Views_PC,
       CASE 
           WHEN Views_PC >= 100000000 THEN 'High Value'
           WHEN Views_PC >= 1000000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS ValueGroup
FROM CTE;

--Chon lua mau
SELECT * 
FROM Youtube_Test
ORDER BY NEWID()
LIMIT 1000;

--Tong hop du lieu views theo published_day_of_week
SELECT published_day_of_week, SUM(CAST(views AS BIGINT)) AS total_views
FROM Youtube_Test
GROUP BY published_day_of_week;
-----------------------------------------------------Data Reduction------------------------------------------------------------------------------------------------------------------
