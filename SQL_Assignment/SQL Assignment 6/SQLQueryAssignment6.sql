
-------------------------------------------------------------------------
--AFDP 2026
-------------------------------------------------------------------------

--Name - Anurag Chandra
--Path - Tech Path 2

------------------------------------------
--SQL Assignment 6
------------------------------------------


Use TrainingDB
GO

SET DATEFORMAT DMY;
GO

-- Task 1

-- CREATING SCHEMA

CREATE SCHEMA ETL_Anurag;
GO

-- CREATING TABLES

CREATE TABLE ETL_Anurag.EmployeeMasterStaging (
    EmployeeMasterId    NVARCHAR(50),
    EmployeeName        NVARCHAR(200),
    EmailId             NVARCHAR(200),
    PositionMasterId    NVARCHAR(50),
    RegionMasterId      NVARCHAR(50),
    IsActive            NVARCHAR(10),
    ManagerID           NVARCHAR(50),
    JoiningDate         NVARCHAR(100),
    CountryMasterId     NVARCHAR(50),
    OperatingCompany    NVARCHAR(200),
    CreatedBy           NVARCHAR(255),
    CreatedOn           NVARCHAR(100)
);

CREATE TABLE ETL_Anurag.RegionMasterStaging (
    RegionMasterId      NVARCHAR(50),
    RegionName          NVARCHAR(200),
    RegionCode          NVARCHAR(50),
    CreatedOn           NVARCHAR(100),
    CreatedBy           NVARCHAR(255),
    UpdatedOn           NVARCHAR(100),
    UpdatedBy           NVARCHAR(255)
);

CREATE TABLE ETL_Anurag.CountryMasterStaging (
    CountryMasterId     NVARCHAR(50),
    CountryName         NVARCHAR(200),
    CountryCode         NVARCHAR(50),
    CreatedOn           NVARCHAR(100),
    CreatedBy           NVARCHAR(255),
    UpdatedOn           NVARCHAR(100),
    UpdatedBy           NVARCHAR(255)
);

CREATE TABLE ETL_Anurag.PositionMasterStaging (
	PositionMasterId    NVARCHAR(50),
    PositionTitle       NVARCHAR(200),
    PositionCode        NVARCHAR(50),
    CreatedOn           NVARCHAR(100),
    CreatedBy           NVARCHAR(255),
    UpdatedOn           NVARCHAR(100),
    UpdatedBy           NVARCHAR(255)
);


SELECT * FROM ETL_Anurag.EmployeeMasterStaging;
SELECT * FROM ETL_Anurag.CountryMasterStaging;
SELECT * FROM ETL_Anurag.PositionMasterStaging;
SELECT * FROM ETL_Anurag.RegionMasterStaging;

-- CLEANING DATA

DELETE
FROM ETL_Anurag.RegionMasterStaging
WHERE RegionMasterId IS NULL
  AND RegionName IS NULL
  AND RegionCode IS NULL;

--CREATING MASTER TABLES

CREATE TABLE ETL_Anurag.EmployeeMaster
(
    EmployeeMasterId INT PRIMARY KEY,
    EmployeeName NVARCHAR(100) NOT NULL,
    EmailId NVARCHAR(100) NULL,
    PositionMasterId INT NULL,
    RegionMasterId INT NULL,
    IsActive BIT NOT NULL,
    ManagerID INT NULL,
    JoiningDate DATETIME2 NULL,
    CountryMasterId INT NULL,
    OperatingCompany NVARCHAR(100) NULL,
    CreatedBy NVARCHAR(255) NOT NULL,
    CreatedOn DATETIME2 NOT NULL
);
GO

CREATE TABLE ETL_Anurag.CountryMaster
(
    CountryMasterId INT PRIMARY KEY,
    CountryName NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(20) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(255) NOT NULL,
    UpdatedOn DATETIME2 NULL,
    UpdatedBy NVARCHAR(255) NULL
);
GO

CREATE TABLE ETL_Anurag.PositionMaster
(
    PositionMasterId INT PRIMARY KEY,
    PositionTitle NVARCHAR(100) NOT NULL,
    PositionCode NVARCHAR(20) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(255) NOT NULL,
    UpdatedOn DATETIME2 NULL,
    UpdatedBy NVARCHAR(255) NULL
);
GO

CREATE TABLE ETL_Anurag.RegionMaster
(
    RegionMasterId INT PRIMARY KEY,
    RegionName NVARCHAR(100) NOT NULL,
    RegionCode NVARCHAR(20) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    CreatedBy NVARCHAR(255) NOT NULL,
    UpdatedOn DATETIME2 NULL,
    UpdatedBy NVARCHAR(255) NULL
);
GO

-- FOREIGN KEYS

ALTER TABLE ETL_Anurag.EmployeeMaster
ADD CONSTRAINT FK_Employee_Position
FOREIGN KEY (PositionMasterId)
REFERENCES ETL_Anurag.PositionMaster(PositionMasterId);
GO

ALTER TABLE ETL_Anurag.EmployeeMaster
ADD CONSTRAINT FK_Employee_Region
FOREIGN KEY (RegionMasterId)
REFERENCES ETL_Anurag.RegionMaster(RegionMasterId);
GO

ALTER TABLE ETL_Anurag.EmployeeMaster
ADD CONSTRAINT FK_Employee_Country
FOREIGN KEY (CountryMasterId)
REFERENCES ETL_Anurag.CountryMaster(CountryMasterId);
GO

-- Task 2

-- Moving Data From Staging Tables to Master Tables

-- INTO Postion Master

INSERT INTO ETL_Anurag.PositionMaster
(
    PositionMasterId,
    PositionTitle,
    PositionCode,
    CreatedOn,
    CreatedBy,
    UpdatedOn,
    UpdatedBy
)
SELECT
    TRY_CAST(PositionMasterId AS INT),
    PositionTitle,
    PositionCode,
    TRY_CAST(CreatedOn AS DATETIME2),
    CreatedBy,
    TRY_CAST(UpdatedOn AS DATETIME2),
    UpdatedBy
FROM ETL_Anurag.PositionMasterStaging;
GO

SELECT *
FROM ETL_Anurag.PositionMaster;

-- INTO Country Master

INSERT INTO ETL_Anurag.CountryMaster
(
    CountryMasterId,
    CountryName,
    CountryCode,
    CreatedOn,
    CreatedBy,
    UpdatedOn,
    UpdatedBy
)
SELECT
    TRY_CAST(CountryMasterId AS INT),
    CountryName,
    CountryCode,
    TRY_CAST(CreatedOn AS DATETIME2),
    CreatedBy,
    TRY_CAST(UpdatedOn AS DATETIME2),
    UpdatedBy
FROM ETL_Anurag.CountryMasterStaging;
GO

SELECT *
FROM ETL_Anurag.CountryMaster;

-- INTO Region Master

INSERT INTO ETL_Anurag.RegionMaster
(
    RegionMasterId,
    RegionName,
    RegionCode,
    CreatedOn,
    CreatedBy,
    UpdatedOn,
    UpdatedBy
)
SELECT
    TRY_CAST(RegionMasterId AS INT),
    RegionName,
    RegionCode,
    TRY_CAST(CreatedOn AS DATETIME2),
    CreatedBy,
    TRY_CAST(UpdatedOn AS DATETIME2),
    UpdatedBy
FROM ETL_Anurag.RegionMasterStaging;
GO

SELECT *
FROM ETL_Anurag.RegionMaster;

-- INTO Employee Master

INSERT INTO ETL_Anurag.EmployeeMaster
(
    EmployeeMasterId,
    EmployeeName,
    EmailId,
    PositionMasterId,
    RegionMasterId,
    IsActive,
    ManagerID,
    JoiningDate,
    CountryMasterId,
    OperatingCompany,
    CreatedBy,
    CreatedOn
)
SELECT
    TRY_CAST(EmployeeMasterId AS INT),
    EmployeeName,
    EmailId,
    TRY_CAST(PositionMasterId AS INT),
    TRY_CAST(RegionMasterId AS INT),
    TRY_CAST(IsActive AS BIT),
    TRY_CAST(ManagerID AS INT),
    TRY_CAST(JoiningDate AS DATETIME2),
    TRY_CAST(CountryMasterId AS INT),
    NULLIF(OperatingCompany, 'null'),
    CreatedBy,
    TRY_CAST(CreatedOn AS DATETIME2)
FROM ETL_Anurag.EmployeeMasterStaging;
GO

SELECT * 
FROM ETL_Anurag.EmployeeMaster

-- Task 3

-- STORED PROCEDURE

GO

CREATE OR ALTER PROCEDURE ETL_Anurag.uspGetEmployeeDetails
(
    @EmailId NVARCHAR(MAX) = NULL,
    @RegionCode NVARCHAR(20) = NULL,
    @CountryCode NVARCHAR(20) = NULL,
    @PositionCode NVARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
	SELECT
    E.EmployeeMasterId,
    CASE
        WHEN CHARINDEX(' ', E.EmployeeName) > 0
        THEN SUBSTRING(E.EmployeeName, 1, CHARINDEX(' ', E.EmployeeName) - 1)
        ELSE E.EmployeeName
    END AS EmployeeFirstName,
    CASE
        WHEN CHARINDEX(' ', E.EmployeeName) > 0
        THEN SUBSTRING(
                E.EmployeeName,
                CHARINDEX(' ', E.EmployeeName) + 1,
                LEN(E.EmployeeName)
             )
        ELSE ''
    END AS EmployeeLastName,
    COALESCE(E.EmailId, '') AS EmailId,
    COALESCE(P.PositionTitle, '') AS PositionName,
    COALESCE(R.RegionName, '') AS RegionName,
    CASE
        WHEN E.IsActive = 1 THEN 'Yes'
        ELSE 'No'
    END AS IsActive,
    COALESCE(CAST(E.ManagerID AS NVARCHAR(20)), '') AS ManagerId,
    COALESCE(M.EmployeeName, '') AS ManagerName,
    CONVERT(VARCHAR(11), E.JoiningDate, 106) AS JoiningDate,
    COALESCE(C.CountryName, '') AS CountryName,
    CASE
    WHEN CHARINDEX(':', E.CreatedBy) > 0
    THEN SUBSTRING(E.CreatedBy, 1, CHARINDEX(':', E.CreatedBy) - 1)
    ELSE E.CreatedBy
	END AS CreatedByName,
    CASE
    WHEN CHARINDEX(':', E.CreatedBy) > 0
    THEN SUBSTRING
    (
        E.CreatedBy,
        CHARINDEX(':', E.CreatedBy) + 1,
        LEN(E.CreatedBy)
    )
    ELSE ''
	END AS CreatedByEmailId,
    CONVERT(VARCHAR(11), E.CreatedOn, 106) AS CreatedOn
	FROM ETL_Anurag.EmployeeMaster AS E
	LEFT JOIN ETL_Anurag.PositionMaster AS P
    ON E.PositionMasterId = P.PositionMasterId
	LEFT JOIN ETL_Anurag.RegionMaster AS R
    ON E.RegionMasterId = R.RegionMasterId
	LEFT JOIN ETL_Anurag.CountryMaster AS C
    ON E.CountryMasterId = C.CountryMasterId
	LEFT JOIN ETL_Anurag.EmployeeMaster AS M
    ON E.ManagerID = M.EmployeeMasterId
WHERE
    (@EmailId IS NULL OR E.EmailId = @EmailId)
AND (@RegionCode IS NULL OR R.RegionCode = @RegionCode)
AND (@CountryCode IS NULL OR C.CountryCode = @CountryCode)
AND (@PositionCode IS NULL OR P.PositionCode = @PositionCode)
ORDER BY E.JoiningDate ASC;
END;
GO

--Executing Stored Position

EXEC ETL_Anurag.uspGetEmployeeDetails;
