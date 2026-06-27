SELECT * FROM Patients_Data

--Cau1
CREATE TABLE State_Table
(
	statecode INT IDENTITY(1, 1),
	statename NVARCHAR(MAX),
)
SELECT * FROM State_Table

INSERT INTO State_Table (statename)
SELECT DISTINCT State
FROM Patients_Data
WHERE State NOT IN (SELECT statename FROM State_Table);

--Cau2
--Kiem tra du lieu khac Male vaf Female hay khong

SELECT Sex
FROM Patients_Data
WHERE Sex <> 'Male' AND Sex <> 'Female'

--Sua ten Field
EXEC SP_RENAME 'Patients_Data.Sex', 'isFemale', 'COLUMN';
SELECT isFemale
FROM Patients_Data

--Female -> true, Male -> false
UPDATE Patients_Data
	SET isFemale = IIF(isFemale = 'Female', 'True', 'False')

--Convert String -> Bool
ALTER TABLE Patients_Data
ALTER COLUMN isFemale BIT;

--Cau3
CREATE TABLE GeneralHealth_Table
(
	general_val INT CHECK(general_val BETWEEN 1 AND 5),
	generalhealth_name NVARCHAR(MAX) CHECK(generalhealth_name IN ('Excellent', 'Very good', 'Good', 'Fair', 'Poor')),
)
INSERT INTO GeneralHealth_Table (general_val, generalhealth_name)
SELECT DISTINCT IIF(GeneralHealth = 'Excellent', 1, IIF(GeneralHealth = 'Very good', 2, IIF(GeneralHealth = 'Good', 3, IIF(GeneralHealth = 'Fair', 4, 5)))) AS num, GeneralHealth
FROM Patients_Data
WHERE GeneralHealth NOT IN (SELECT statename FROM State_Table)

UPDATE Patients_Data
SET GeneralHealth = (SELECT TOP 1 general_val FROM GeneralHealth_Table WHERE GeneralHealth_Table.generalhealth_name = Patients_Data.GeneralHealth)
WHERE GeneralHealth IN (SELECT generalhealth_name FROM GeneralHealth_Table)

SELECT * FROM Patients_Data

ALTER TABLE Patients_Data
ALTER COLUMN GeneralHealth INT;

--Cau4
CREATE TABLE AgeCategory_Table
(
	age_val INT CHECK(age_val BETWEEN 1 AND 13),
	agecategory NVARCHAR(200),
)

INSERT INTO AgeCategory_Table (age_val, agecategory)
SELECT DISTINCT CASE 
        WHEN AgeCategory = 'Age 18 to 24' THEN 1
        WHEN AgeCategory = 'Age 25 to 29' THEN 2
        WHEN AgeCategory = 'Age 30 to 34' THEN 3
        WHEN AgeCategory = 'Age 35 to 39' THEN 4
        WHEN AgeCategory = 'Age 40 to 44' THEN 5
        WHEN AgeCategory = 'Age 45 to 49' THEN 6
        WHEN AgeCategory = 'Age 50 to 54' THEN 7
        WHEN AgeCategory = 'Age 55 to 59' THEN 8
        WHEN AgeCategory = 'Age 60 to 64' THEN 9
        WHEN AgeCategory = 'Age 65 to 69' THEN 10
        WHEN AgeCategory = 'Age 70 to 74' THEN 11
        WHEN AgeCategory = 'Age 74 to 79' THEN 12
        ELSE 13
    END AS AgeGroup, AgeCategory
FROM Patients_Data
WHERE AgeCategory NOT IN (SELECT agecategory FROM AgeCategory_Table)

UPDATE Patients_Data
SET AgeCategory = (SELECT TOP 1 age_val FROM AgeCategory_Table WHERE agecategory = AgeCategory)
WHERE AgeCategory IN (SELECT agecategory FROM AgeCategory_Table)

ALTER TABLE Patients_Data
ALTER COLUMN AgeCategory INT;

--Cau5
ALTER TABLE Patients_Data
	DROP COLUMN BMI
SELECT * FROM Patients_Data

--Cau6
CREATE TABLE RE_Category
(
	re_category NVARCHAR(MAX),
	re_id INT,
)

INSERT INTO RE_Category (re_id, re_category)
SELECT DISTINCT IIF(RaceEthnicityCategory = 'White only, Non-Hispanic', 1, IIF(RaceEthnicityCategory = 'Black only, Non-Hispanic', 2, IIF(RaceEthnicityCategory = 'Other race only, Non-Hispanic', 3, IIF(RaceEthnicityCategory = 'Multiracial, Non-Hispanic', 4, 5)))) AS num, RaceEthnicityCategory
FROM Patients_Data
WHERE RaceEthnicityCategory NOT IN (SELECT re_category FROM RE_Category)

UPDATE Patients_Data
SET RaceEthnicityCategory = (SELECT TOP 1 re_id FROM RE_Category WHERE re_category = RaceEthnicityCategory)
WHERE RaceEthnicityCategory IN (SELECT re_category FROM RE_Category)

SELECT * FROM Patients_Data

ALTER TABLE Patients_Data
ALTER COLUMN RaceEthnicityCategory INT;

--Cau7
CREATE TABLE HadDiabetes_Table
(
	haddiabetes NVARCHAR(MAX),
	haddiabetes_id INT,
)
INSERT INTO HadDiabetes_Table (haddiabetes_id, haddiabetes)
SELECT DISTINCT IIF(HadDiabetes = 'Yes', 1, IIF(HadDiabetes = 'No', 2, IIF(HadDiabetes = 'No, pre-diabetes or borderline diabetes', 3, 4))) AS num, HadDiabetes
FROM Patients_Data
WHERE HadDiabetes NOT IN (SELECT haddiabetes FROM HadDiabetes_Table)

UPDATE Patients_Data
SET HadDiabetes = (SELECT TOP 1 haddiabetes_id FROM HadDiabetes_Table WHERE haddiabetes = HadDiabetes)
WHERE HadDiabetes IN (SELECT haddiabetes FROM HadDiabetes_Table)

SELECT * FROM Patients_Data

ALTER TABLE Patients_Data
ALTER COLUMN HadDiabetes INT;

--Cau8
SELECT * FROM Medicalhistory_Table

ALTER TABLE Patients_Data
	ADD Medicalhistory INT;

SELECT * FROM Patients_Data

UPDATE m
SET m.Medicalhistory = 
    CAST(
        CAST(m.HadHeartAttack AS INT) * POWER(2, 14) + 
        CAST(m.HadAngina AS INT) * POWER(2, 13) +
        CAST(m.HadStroke AS INT) * POWER(2, 12) +
        CAST(m.HadAsthma AS INT) * POWER(2, 11) +
        CAST(m.HadSkinCancer AS INT) * POWER(2, 10) +
        CAST(m.HadCOPD AS INT) * POWER(2, 9) +
        CAST(m.HadDepressiveDisorder AS INT) * POWER(2, 8) +
        CAST(m.HadKidneyDisease AS INT) * POWER(2, 7) +
        CAST(m.HadArthritis AS INT) * POWER(2, 6) +
        CAST(m.DeafOrHardOfHearing AS INT) * POWER(2, 5) +
        CAST(m.BlindOrVisionDifficulty AS INT) * POWER(2, 4) +
        CAST(m.DifficultyConcentrating AS INT) * POWER(2, 3) +
        CAST(m.DifficultyWalking AS INT) * POWER(2, 2) +
        CAST(m.DifficultyDressingBathing AS INT) * POWER(2, 1) +
        CAST(m.DifficultyErrands AS INT) * POWER(2, 0) AS INT
    )
FROM Patients_Data m;

CREATE TABLE Medicalhistory_Table
(
	HadHeartAttack BIT,
	HadAngina BIT,
	HadStroke BIT,
	HadAsthma BIT,
	HadSkinCancer BIT,
	HadCOPD BIT,
	HadDepressiveDisorder BIT,
	HadKidneyDisease BIT,
	HadArthritis BIT,
	DeafOrHardOfHearing BIT,
	BlindOrVisionDifficulty BIT,
	DifficultyConcentrating BIT,
	DifficultyWalking BIT,
	DifficultyDressingBathing BIT,
	DifficultyErrands BIT,
)

INSERT INTO Medicalhistory_Table (HadHeartAttack, HadAngina, HadStroke, HadAsthma, HadSkinCancer, HadCOPD, HadDepressiveDisorder, HadKidneyDisease, HadArthritis, DeafOrHardOfHearing, BlindOrVisionDifficulty, DifficultyConcentrating, DifficultyWalking, DifficultyDressingBathing, DifficultyErrands)
SELECT HadHeartAttack, HadAngina, HadStroke, HadAsthma, HadSkinCancer, HadCOPD, HadDepressiveDisorder, HadKidneyDisease, HadArthritis, DeafOrHardOfHearing, BlindOrVisionDifficulty, DifficultyConcentrating, DifficultyWalking, DifficultyDressingBathing, DifficultyErrands
FROM Patients_Data

ALTER TABLE Patients_Data
	DROP COLUMN HadHeartAttack, HadAngina, HadStroke, HadAsthma, HadSkinCancer, HadCOPD, HadDepressiveDisorder, HadKidneyDisease, HadArthritis, DeafOrHardOfHearing, BlindOrVisionDifficulty, DifficultyConcentrating, DifficultyWalking, DifficultyDressingBathing, DifficultyErrands

SELECT * FROM Medicalhistory_Table

ALTER TABLE Medicalhistory_Table 
DROP COLUMN Medicalhistory;

--Cau9
ALTER TABLE Patients_Data
	ADD Testsperformed INT;

SELECT * FROM Patients_Data

UPDATE m
SET m.Testsperformed = 
    CAST(
        CAST(m.ChestScan AS INT) * POWER(2, 5) +
        CAST(m.HIVTesting AS INT) * POWER(2, 4) +
        CAST(m.FluVaxLast12 AS INT) * POWER(2, 3) +
        CAST(m.PneumoVaxEver AS INT) * POWER(2, 2) +
        CAST(m.TetanusLast10Tdap AS INT) * POWER(2, 1) +
        CAST(m.CovidPos AS INT) * POWER(2, 0) AS INT
    )
FROM Patients_Data m;

CREATE TABLE Testsperformed_Table
(
	ChestScan BIT,
	HIVTesting BIT,
	FluVaxLast12 BIT,
	PneumoVaxEver BIT,
	TetanusLast10Tdap BIT,
	CovidPos BIT,
)

INSERT INTO Testsperformed_Table (ChestScan, HIVTesting, FluVaxLast12, PneumoVaxEver, TetanusLast10Tdap, CovidPos)
SELECT ChestScan, HIVTesting, FluVaxLast12, PneumoVaxEver, TetanusLast10Tdap, CovidPos
FROM Patients_Data

ALTER TABLE Patients_Data
	DROP COLUMN ChestScan, HIVTesting, FluVaxLast12, PneumoVaxEver, TetanusLast10Tdap, CovidPos

SELECT * FROM Testsperformed_Table

--Cau10
CREATE TABLE SmokerStatus_Table
(
	smokerstatus NVARCHAR(MAX),
	smokerstatus_id INT,
)
INSERT INTO SmokerStatus_Table (smokerstatus_id, smokerstatus)
SELECT DISTINCT IIF(SmokerStatus = 'Former smoker', 1, IIF(SmokerStatus = 'Never smoked', 2, IIF(SmokerStatus = 'Current smoker - now smokes every day', 3, 4))) AS num, SmokerStatus
FROM Patients_Data
WHERE SmokerStatus NOT IN (SELECT smokerstatus FROM SmokerStatus_Table)

UPDATE Patients_Data
SET SmokerStatus = (SELECT TOP 1 smokerstatus_id FROM SmokerStatus_Table WHERE smokerstatus = SmokerStatus)
WHERE SmokerStatus IN (SELECT smokerstatus FROM SmokerStatus_Table)

ALTER TABLE Patients_Data
ALTER COLUMN SmokerStatus INT;

SELECT * FROM Patients_Data

--Cau11	
CREATE TABLE EcigaretteUsage_Table
(
	ecigaretteusage NVARCHAR(MAX),
	ecigaretteusage_id INT,
)
INSERT INTO EcigaretteUsage_Table (ecigaretteusage_id, ecigaretteusage)
SELECT DISTINCT IIF(EcigaretteUsage = 'Former smoker', 1, IIF(EcigaretteUsage = 'Never smoked', 2, IIF(EcigaretteUsage = 'Current smoker - now smokes every day', 3, 4))) AS num, EcigaretteUsage
FROM Patients_Data
WHERE EcigaretteUsage NOT IN (SELECT ecigaretteusage FROM EcigaretteUsage_Table)

UPDATE Patients_Data
SET EcigaretteUsage = (SELECT TOP 1 ecigaretteusage_id FROM EcigaretteUsage_Table WHERE ecigaretteusage = EcigaretteUsage)
WHERE EcigaretteUsage IN (SELECT ecigaretteusage FROM EcigaretteUsage_Table)

ALTER TABLE Patients_Data
ALTER COLUMN EcigaretteUsage INT;

SELECT * FROM Patients_Data

--Cau12
CREATE TABLE TetanusLast10Tdap_Table
(
	tetanuslast10tdap NVARCHAR(MAX),
	tetanuslast10tdap_id INT,
)
INSERT INTO TetanusLast10Tdap_Table (tetanuslast10tdap_id, tetanuslast10tdap)
SELECT DISTINCT IIF(TetanusLast10Tdap = 'Yes', 1, IIF(TetanusLast10Tdap = 'No', 2, IIF(TetanusLast10Tdap = 'No, pre-diabetes or borderline diabetes', 3, 4))) AS num, TetanusLast10Tdap
FROM Patients_Data
WHERE TetanusLast10Tdap NOT IN (SELECT tetanuslast10tdap FROM TetanusLast10Tdap_Table)

UPDATE Patients_Data
SET TetanusLast10Tdap = (SELECT TOP 1 tetanuslast10tdap_id FROM TetanusLast10Tdap_Table WHERE tetanuslast10tdap = TetanusLast10Tdap)
WHERE TetanusLast10Tdap IN (SELECT tetanuslast10tdap FROM TetanusLast10Tdap_Table)

ALTER TABLE Patients_Data
ALTER COLUMN TetanusLast10Tdap INT;

SELECT * FROM Patients_Data

SELECT * FROM TetanusLast10Tdap_Table