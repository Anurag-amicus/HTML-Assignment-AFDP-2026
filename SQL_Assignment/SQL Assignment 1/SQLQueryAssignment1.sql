-------------------------------------------------------------------------
--AFDP 2026
-------------------------------------------------------------------------

--Name - Anurag Chandra
--Path - Tech Path 2

------------------------------------------
--SQL Assignment 1
------------------------------------------

-- Task 1

--------------------------------------------------
-- Use the Existing TrainingDB Database
--------------------------------------------------

-- A separate database is not required.
-- All objects will be created in the TrainingDB database.

----------------------------------------------------------
----------------------------------------------------------

-- Task 2

--------------------------------------------------
-- Create Database Tables
--------------------------------------------------

/*
Table: BusinessUnit_AnuragChandra

Data Type Choices:
- BusinessUnitId: INT PRIMARY KEY IDENTITY because the number of business units is expected to remain well within the INT range. BIGINT would consume more storage without providing practical benefit.
- BusinessUnitName: NVARCHAR(100) to support Unicode characters, allowing names in multiple languages.
- IsActive: BIT because it stores only True/False values.
- CreatedOn: DATETIME2 because it provides better precision and a larger date range than DATETIME.
- CreatedBy: NVARCHAR(100) to support usernames containing Unicode characters.

Using VARCHAR instead of NVARCHAR could prevent storing multilingual names correctly.
Using BIGINT instead of INT would increase storage requirements unnecessarily.
Using DATETIME instead of DATETIME2 would reduce precision and provide a smaller supported date range.
*/

CREATE TABLE BusinessUnit_AnuragChandra(
BusinessUnitId INTEGER IDENTITY(1,1) PRIMARY KEY,
BusinessUnitName NVARCHAR(100),
IsActive BIT,
CreatedOn DATETIME2,
CreatedBy NVARCHAR(100)
);

/*
Table: CustomerLocation_AnuragChandra

Data Type Choices:
- CustomerLocationId: INT IDENTITY for an efficient auto-generated primary key.
- CustomerLocationName: NVARCHAR(100) to support international location names.
- BusinessUnitId: INT because it references BusinessUnit.BusinessUnitId.
- IsActive: BIT for active/inactive status.
- CreatedOn: DATETIME2 for precise timestamp storage.
- CreatedBy: NVARCHAR(100) for Unicode usernames.

The foreign key must use the same data type as the referenced primary key. Using a different numeric type would prevent the foreign key relationship.
*/

CREATE TABLE CustomerLocation_AnuragChandra(
CustomerLocationId INTEGER IDENTITY(1,1) PRIMARY KEY,
CustomerLocationName NVARCHAR(100),
BusinessUnitId INTEGER REFERENCES BusinessUnit_AnuragChandra(BusinessUnitId),
IsActive BIT,
CreatedOn DATETIME2,
CreatedBy NVARCHAR(100)
);

/*
Table: Company_AnuragChandra

Data Type Choices:
- CompanyId: INT IDENTITY for an efficient auto-generated primary key.
- CompanyName: NVARCHAR(100) to support Unicode company names.
- IsActive: BIT for active/inactive status.
- CreatedOn: DATETIME2 for precise timestamp storage.
- CreatedBy: NVARCHAR(100) for Unicode usernames.

The primary key uses INT for efficiency, while NVARCHAR supports multilingual company names.
*/

CREATE TABLE Company_AnuragChandra(
CompanyId INTEGER IDENTITY(1,1) PRIMARY KEY,
CompanyName NVARCHAR(100),
IsActive BIT,
CreatedOn DATETIME2,
CreatedBy NVARCHAR(100)
);

/*
Table: Attribute_AnuragChandra

Data Type Choices:
- AttributeId: INT IDENTITY for an efficient auto-generated primary key.
- AttributeName: NVARCHAR(100) to support Unicode attribute names.
- BusinessUnitId, CustomerLocationId, CompanyId: INT to match their referenced primary keys.
- IsActive: BIT for active/inactive status.
- CreatedOn, UpdatedOn: DATETIME2 for precise timestamp storage.
- CreatedBy, UpdatedBy: NVARCHAR(100) for Unicode usernames.

Foreign keys use INT to match the referenced primary keys, and DATETIME2 provides higher precision for audit fields.
*/

CREATE TABLE Attribute_AnuragChandra(
AttributeId INTEGER IDENTITY(1,1) PRIMARY KEY,
AttributeName NVARCHAR(100),
BusinessUnitId INTEGER REFERENCES BusinessUnit_AnuragChandra(BusinessUnitId),
CustomerLocationId INTEGER REFERENCES CustomerLocation_AnuragChandra(CustomerLocationId),
CompanyId INTEGER REFERENCES Company_AnuragChandra(CompanyId),
IsActive BIT,
CreatedOn DATETIME2,
UpdatedOn DATETIME2,
CreatedBy NVARCHAR(100),
UpdatedBy NVARCHAR(100)
);

--------------------------------------------------
--------------------------------------------------

--Task 3

--------------------------------------------------
-- Add Table Constraints
--------------------------------------------------

/*
Required Fields:
NOT NULL is used for mandatory business and audit fields.
UpdatedOn and UpdatedBy are optional because they are populated only after a record is updated.
*/

--------------------------------------------------
-- BusinessUnit_AnuragChandra
--------------------------------------------------

ALTER TABLE BusinessUnit_AnuragChandra
ALTER COLUMN BusinessUnitName NVARCHAR(100) NOT NULL;

ALTER TABLE BusinessUnit_AnuragChandra
ALTER COLUMN IsActive BIT NOT NULL;

ALTER TABLE BusinessUnit_AnuragChandra
ALTER COLUMN CreatedOn DATETIME2 NOT NULL;

ALTER TABLE BusinessUnit_AnuragChandra
ALTER COLUMN CreatedBy NVARCHAR(100) NOT NULL;

ALTER TABLE BusinessUnit_AnuragChandra
ADD CONSTRAINT Def_BusinessUnit_IsActive
DEFAULT 1 FOR IsActive;

ALTER TABLE BusinessUnit_AnuragChandra
ADD CONSTRAINT Def_BusinessUnit_CreatedOn
DEFAULT GETDATE() FOR CreatedOn;

ALTER TABLE BusinessUnit_AnuragChandra
ADD CONSTRAINT Check_BusinessUnit_CreatedOn
CHECK (CreatedOn <= GETDATE());

--------------------------------------------------
-- CustomerLocation_AnuragChandra
--------------------------------------------------

ALTER TABLE CustomerLocation_AnuragChandra
ALTER COLUMN CustomerLocationName NVARCHAR(100) NOT NULL;

ALTER TABLE CustomerLocation_AnuragChandra
ALTER COLUMN BusinessUnitId INT NOT NULL;

ALTER TABLE CustomerLocation_AnuragChandra
ALTER COLUMN IsActive BIT NOT NULL;

ALTER TABLE CustomerLocation_AnuragChandra
ALTER COLUMN CreatedOn DATETIME2 NOT NULL;

ALTER TABLE CustomerLocation_AnuragChandra
ALTER COLUMN CreatedBy NVARCHAR(100) NOT NULL;

ALTER TABLE CustomerLocation_AnuragChandra
ADD CONSTRAINT Def_CustomerLocation_IsActive
DEFAULT 1 FOR IsActive;

ALTER TABLE CustomerLocation_AnuragChandra
ADD CONSTRAINT Def_CustomerLocation_CreatedOn
DEFAULT GETDATE() FOR CreatedOn;

ALTER TABLE CustomerLocation_AnuragChandra
ADD CONSTRAINT Check_CustomerLocation_CreatedOn
CHECK (CreatedOn <= GETDATE());

--------------------------------------------------
-- Company_AnuragChandra
--------------------------------------------------

ALTER TABLE Company_AnuragChandra
ALTER COLUMN CompanyName NVARCHAR(100) NOT NULL;

ALTER TABLE Company_AnuragChandra
ALTER COLUMN IsActive BIT NOT NULL;

ALTER TABLE Company_AnuragChandra
ALTER COLUMN CreatedOn DATETIME2 NOT NULL;

ALTER TABLE Company_AnuragChandra
ALTER COLUMN CreatedBy NVARCHAR(100) NOT NULL;

ALTER TABLE Company_AnuragChandra
ADD CONSTRAINT Def_Company_IsActive
DEFAULT 1 FOR IsActive;

ALTER TABLE Company_AnuragChandra
ADD CONSTRAINT Def_Company_CreatedOn
DEFAULT GETDATE() FOR CreatedOn;

ALTER TABLE Company_AnuragChandra
ADD CONSTRAINT Check_Company_CreatedOn
CHECK (CreatedOn <= GETDATE());

--------------------------------------------------
-- Attribute_AnuragChandra
--------------------------------------------------

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN AttributeName NVARCHAR(100) NOT NULL;

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN BusinessUnitId INT NOT NULL;

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN CustomerLocationId INT NOT NULL;

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN CompanyId INT NOT NULL;

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN IsActive BIT NOT NULL;

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN CreatedOn DATETIME2 NOT NULL;

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN CreatedBy NVARCHAR(100) NOT NULL;

ALTER TABLE Attribute_AnuragChandra
ADD CONSTRAINT Def_Attribute_IsActive
DEFAULT 1 FOR IsActive;

ALTER TABLE Attribute_AnuragChandra
ADD CONSTRAINT Def_Attribute_CreatedOn
DEFAULT GETDATE() FOR CreatedOn;

ALTER TABLE Attribute_AnuragChandra
ADD CONSTRAINT Check_Attribute_CreatedOn
CHECK (CreatedOn <= GETDATE());

ALTER TABLE Attribute_AnuragChandra
ADD CONSTRAINT Unique_Attribute_BusinessUnit_AttributeName
UNIQUE (BusinessUnitId, AttributeName);

--------------------------------------------------
-- Verify Table Constraints
-- COMMENT OUT/UNCOMMENT for Checking
-- After checking truncate the tables
--------------------------------------------------

-- The following INSERT statements intentionally violate
-- different constraints to verify that they are enforced.

--------------------------------------------------
-- Verify NOT NULL Constraint
--------------------------------------------------

-- INSERT INTO BusinessUnit_AnuragChandra
-- (BusinessUnitName, IsActive, CreatedOn)
-- VALUES
-- ('Paper', 1, GETDATE());

-- Expected Result:
-- Cannot insert the value NULL into column 'CreatedBy'.

--------------------------------------------------
-- Verify DEFAULT Constraints
--------------------------------------------------

-- INSERT INTO BusinessUnit_AnuragChandra
-- (BusinessUnitName, CreatedBy)
-- VALUES
-- ('Paper', 'Anurag');

-- Expected Result:
-- Columns with DEFAULT constraints are populated automatically.

--------------------------------------------------
-- Verify CHECK Constraint
--------------------------------------------------

-- INSERT INTO BusinessUnit_AnuragChandra
-- (BusinessUnitName, IsActive, CreatedOn, CreatedBy)
-- VALUES
-- ('Paper', 1, '2099-01-01', 'Anurag');

-- Expected Result:
-- CHECK constraint prevents future dates in CreatedOn.

--------------------------------------------------
-- Insert a Valid Business Unit
--------------------------------------------------

-- INSERT INTO BusinessUnit_AnuragChandra
-- (BusinessUnitName, CreatedBy)
-- VALUES
-- ('IT', 'Anurag');

--------------------------------------------------
-- Verify FOREIGN KEY Constraint
--------------------------------------------------

-- INSERT INTO CustomerLocation_AnuragChandra
-- (CustomerLocationName, BusinessUnitId, CreatedBy)
-- VALUES
-- ('Ahmedabad', 1, 'Anurag');

-- Expected Result:
-- FOREIGN KEY constraint fails if the referenced
-- BusinessUnitId does not exist.

--------------------------------------------------
-- Insert a Valid Customer Location
--------------------------------------------------

-- INSERT INTO CustomerLocation_AnuragChandra
-- (CustomerLocationName, BusinessUnitId, CreatedBy)
-- VALUES
-- ('Ahmedabad', 3, 'Anurag');

--------------------------------------------------
-- Insert a Valid Company
--------------------------------------------------

-- INSERT INTO Company_AnuragChandra
-- (CompanyName, CreatedBy)
-- VALUES
-- ('Amicus', 'Anurag');

--------------------------------------------------
-- Verify UNIQUE Constraint
--------------------------------------------------

-- Execute the following INSERT twice to verify
-- the composite UNIQUE constraint.

-- INSERT INTO Attribute_AnuragChandra
-- (AttributeName, BusinessUnitId, CustomerLocationId, CompanyId, CreatedBy)
-- VALUES
-- ('Color', 3, 3, 1, 'Anurag');

-- Expected Result:
-- The second INSERT fails because the combination of
-- BusinessUnitId and AttributeName must be unique.

--------------------------------------------------
-- Verify FOREIGN KEY Constraint on Attribute Table
--------------------------------------------------

-- INSERT INTO Attribute_AnuragChandra
-- (AttributeName, BusinessUnitId, CustomerLocationId, CompanyId, CreatedBy)
-- VALUES
-- ('Size', 999, 999, 999, 'Anurag');

-- Expected Result:
-- FOREIGN KEY constraint fails because the referenced
-- BusinessUnitId, CustomerLocationId, and CompanyId do not exist.

--------------------------------------------------
--------------------------------------------------

--Task 4 INSERTING VALUES

--------------------------------------------------
-- Business Units (5)
--------------------------------------------------

INSERT INTO BusinessUnit_AnuragChandra
(BusinessUnitName, IsActive, CreatedBy)
VALUES
('Paper',1,'Anurag'),
('Packaging',1,'Riya'),
('Chemicals',0,'Rahul'),
('Textiles',1,'Admin'),
('Electronics',0,'System');

--------------------------------------------------
-- Customer Locations (10)
--------------------------------------------------

INSERT INTO CustomerLocation_AnuragChandra
(CustomerLocationName, BusinessUnitId, IsActive, CreatedBy)
VALUES
('Ahmedabad',1,1,'Anurag'),
('Surat',1,1,'Riya'),
('Vadodara',2,1,'Rahul'),
('Rajkot',2,0,'Admin'),
('Mumbai',3,1,'System'),
('Pune',3,0,'Anurag'),
('Delhi',4,1,'Riya'),
('Jaipur',4,1,'Rahul'),
('Chennai',1,0,'Admin'),
('Hyderabad',2,1,'System');

--------------------------------------------------
-- Companies (5)
--------------------------------------------------

INSERT INTO Company_AnuragChandra
(CompanyName, IsActive, CreatedBy)
VALUES
('ABC Ltd',1,'Anurag'),
('XYZ Pvt Ltd',1,'Riya'),
('Global Corp',0,'Rahul'),
('Prime Industries',1,'Admin'),
('Vision Tech',1,'System');

--------------------------------------------------
-- Attributes (20)
--------------------------------------------------

INSERT INTO Attribute_AnuragChandra
(AttributeName,BusinessUnitId,CustomerLocationId,CompanyId,IsActive,CreatedOn,CreatedBy)
VALUES
('Color',1,1,1,1,DATEADD(DAY,-20,GETDATE()),'Anurag'),
('Size',1,2,2,1,DATEADD(DAY,-60,GETDATE()),'Riya'),
('Weight',2,3,3,1,DATEADD(DAY,-120,GETDATE()),'Rahul'),
('Material',2,4,4,0,DATEADD(DAY,-180,GETDATE()),'Admin'),
('Grade',3,5,5,1,DATEADD(DAY,-240,GETDATE()),'System'),
('Thickness',3,6,1,1,DATEADD(DAY,-300,GETDATE()),'Anurag'),
('Width',4,7,2,0,DATEADD(DAY,-360,GETDATE()),'Riya'),
('Height',4,8,3,1,DATEADD(DAY,-420,GETDATE()),'Rahul'),
('Length',1,9,4,1,DATEADD(DAY,-480,GETDATE()),'Admin'),
('Density',2,10,5,0,DATEADD(DAY,-540,GETDATE()),'System'),
('Opacity',1,1,2,1,DATEADD(DAY,-600,GETDATE()),'Anurag'),
('Brightness',2,3,3,1,DATEADD(DAY,-660,GETDATE()),'Riya'),
('Texture',3,5,4,0,DATEADD(DAY,-700,GETDATE()),'Rahul'),
('Finish',4,7,5,1,DATEADD(DAY,-50,GETDATE()),'Admin'),
('Moisture',1,2,1,1,DATEADD(DAY,-90,GETDATE()),'System'),
('Strength',2,4,2,1,DATEADD(DAY,-150,GETDATE()),'Anurag'),
('Hardness',3,6,3,0,DATEADD(DAY,-210,GETDATE()),'Riya'),
('Flexibility',4,8,4,1,DATEADD(DAY,-270,GETDATE()),'Rahul'),
('Gloss',1,9,5,1,DATEADD(DAY,-330,GETDATE()),'Admin'),
('FinishType',2,10,1,0,DATEADD(DAY,-390,GETDATE()),'System');

--------------------------------------------------
--------------------------------------------------

--Task 5

--------------------------------------------------
-- Update Attributes for a Specific Business Unit
--------------------------------------------------

UPDATE Attribute_AnuragChandra
SET IsActive = 0
WHERE BusinessUnitId = 2;

--------------------------------------------------
-- Verify the Updated Records
--------------------------------------------------

SELECT * FROM Attribute_AnuragChandra
WHERE BusinessUnitId = 2;

--------------------------------------------------
--------------------------------------------------

--Task 6

--------------------------------------------------
-- Insert Unused Customer Locations
--------------------------------------------------

INSERT INTO CustomerLocation_AnuragChandra
(CustomerLocationName, BusinessUnitId, IsActive, CreatedBy)
VALUES
('Indore', 1, 1, 'Anurag'),
('Nagpur', 2, 1, 'Riya'),
('Bhopal', 3, 0, 'Rahul'),
('Lucknow', 4, 1, 'Admin'),
('Kolkata', 1, 1, 'System');

--------------------------------------------------
-- Preview Customer Locations to Be Deleted
--------------------------------------------------

SELECT * FROM CustomerLocation_AnuragChandra AS CL
LEFT JOIN Attribute_AnuragChandra AS A
ON CL.CustomerLocationId = A.CustomerLocationId
WHERE A.CustomerLocationId IS NULL;

--------------------------------------------------
-- Delete Unused Customer Locations
--------------------------------------------------

DELETE CL
FROM CustomerLocation_AnuragChandra AS CL
LEFT JOIN Attribute_AnuragChandra AS A
    ON CL.CustomerLocationId = A.CustomerLocationId
WHERE A.CustomerLocationId IS NULL;

--------------------------------------------------
--------------------------------------------------

--Task 7

--------------------------------------------------
-- Create a Staging Table
--------------------------------------------------

DECLARE @CompanyStaging TABLE
(
    CompanyName NVARCHAR(100),
    IsActive BIT
);

INSERT INTO @CompanyStaging
(CompanyName, IsActive)
VALUES
('ABC Ltd', 0),            -- Existing (UPDATE)
('XYZ Pvt Ltd', 0),        -- Existing (UPDATE)
('Future Solutions', 1),   -- New (INSERT)
('TechNova', 1),           -- New (INSERT)
('Green Energy', 0);       -- New (INSERT)

--------------------------------------------------
-- Create a Merge Audit Table
--------------------------------------------------

DECLARE @MergeAudit TABLE
(
    ActionPerformed NVARCHAR(10),
    CompanyName NVARCHAR(100)
);

--------------------------------------------------
-- Merge Staging Data into Company Table
--------------------------------------------------


MERGE Company_AnuragChandra AS ExistingT
USING @CompanyStaging AS SourceT
ON ExistingT.CompanyName = SourceT.CompanyName

WHEN MATCHED THEN
    UPDATE
    SET ExistingT.IsActive = SourceT.IsActive

WHEN NOT MATCHED BY TARGET THEN
    INSERT
    (
        CompanyName,
        IsActive,
        CreatedBy
    )
    VALUES
    (
        SourceT.CompanyName,
        SourceT.IsActive,
        'Anurag'
    )

OUTPUT
    $action,
    inserted.CompanyName
INTO @MergeAudit
(
    ActionPerformed,
    CompanyName
);

SELECT * FROM @MergeAudit;

SELECT * FROM Company_AnuragChandra;

--------------------------------------------------
--------------------------------------------------

--Task 8

--------------------------------------------------
-- Filter Records Using BETWEEN
--------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
WHERE CreatedOn BETWEEN '2025-01-01' AND '2025-12-31';

--------------------------------------------------
-- Filter Records Using IN
--------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
WHERE BusinessUnitId IN (1, 2, 3);

--------------------------------------------------
-- Filter Records Using NOT IN
--------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
WHERE BusinessUnitId NOT IN (1, 2, 3);

--------------------------------------------------
-- Filter Records Using LEFT JOIN and IS NULL
--------------------------------------------------

SELECT A.*
FROM Attribute_AnuragChandra A
LEFT JOIN
(
    VALUES (1), (2), (3)
) AS B(BusinessUnitId)
ON A.BusinessUnitId = B.BusinessUnitId
WHERE B.BusinessUnitId IS NULL;


--------------------------------------------------
-- Note on NOT IN vs NOT EXISTS
--------------------------------------------------

-- NOT IN can return unexpected results if the list contains NULL values.
-- NOT EXISTS is safer because it is not affected by NULL values.

--------------------------------------------------
-- Filter Records Using LIKE
--------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
WHERE AttributeName LIKE 'F%';

SELECT *
FROM Attribute_AnuragChandra
WHERE AttributeName LIKE '%ness';

SELECT *
FROM Attribute_AnuragChandra
WHERE AttributeName LIKE '%Type%';

SELECT *
FROM Attribute_AnuragChandra
WHERE AttributeName LIKE '__o__';

--------------------------------------------------
-- Filter Records Using AND, OR, and NOT
--------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
WHERE
(
    BusinessUnitId = 1
    OR BusinessUnitId = 2
)
AND IsActive = 1
AND NOT CreatedBy = 'Admin';

--------------------------------------------------
--------------------------------------------------

--Task 9

----------------------------------------------------
-- Retrieve the Top 10 Most Recently Created Records
----------------------------------------------------

SELECT TOP 10 *
FROM Attribute_AnuragChandra
ORDER BY CreatedOn DESC;

--------------------------------------------------
-- Prepare Data for TOP WITH TIES Demonstration
--------------------------------------------------

-- Update multiple records to have the same CreatedOn value
-- so they qualify as ties in the TOP query.

UPDATE Attribute_AnuragChandra
SET CreatedOn = '2026-03-29 11:33:20.5100000'
WHERE AttributeId in (7,8,9);

--------------------------------------------------
-- Retrieve the Top 5 Records Including Ties
--------------------------------------------------

SELECT TOP 5 WITH TIES *
FROM Attribute_AnuragChandra
ORDER BY CreatedOn DESC;

--------------------------------------------------
-- Retrieve Records Using OFFSET-FETCH Pagination
--------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
ORDER BY AttributeName
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

----------------------------------------------------------------------------------------
-- Declare Variables for Parameterized Pagination & Retrieve a Specific Page of Records
----------------------------------------------------------------------------------------


DECLARE @PageNumber INT = 2;
DECLARE @PageSize INT = 10;

SELECT *
FROM Attribute_AnuragChandra
ORDER BY AttributeName
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;

--------------------------------------------------
--------------------------------------------------

--Task 10

--------------------------------------------------
-- Count Total Attributes per Business Unit
--------------------------------------------------

SELECT
    BusinessUnitId,
    COUNT(*) AS TotalAttributes
FROM Attribute_AnuragChandra
GROUP BY BusinessUnitId;

---------------------------------------------------------
-- Calculate the Average Number of Attributes per Company
---------------------------------------------------------

SELECT AVG(TotalAttributes) AS AverageAttributesPerCompany
FROM
(
    SELECT
        CompanyId,
        COUNT(*) AS TotalAttributes
    FROM Attribute_AnuragChandra
    GROUP BY CompanyId
) AS CompanyAttributeCount;

----------------------------------------------------------
-- Find Business Units with More Than 3 Active Attributes
----------------------------------------------------------

SELECT
    BusinessUnitId,
    COUNT(*) AS ActiveAttributes
FROM Attribute_AnuragChandra
WHERE IsActive = 1
GROUP BY BusinessUnitId
HAVING COUNT(*) > 3;

---------------------------------------------------------
-- Find the Company with the Maximum Number of Attributes
---------------------------------------------------------

SELECT TOP 1
    CompanyId,
    COUNT(*) AS TotalAttributes
FROM Attribute_AnuragChandra
GROUP BY CompanyId
ORDER BY COUNT(*) DESC;

---------------------------------------------------------
-- Find the Company with the Minimum Number of Attributes
---------------------------------------------------------

SELECT TOP 1
    CompanyId,
    COUNT(*) AS TotalAttributes
FROM Attribute_AnuragChandra
GROUP BY CompanyId
ORDER BY COUNT(*) ASC;

--------------------------------------------------
--------------------------------------------------

--Task 11

--------------------------------------------------------
-- Insert Sample Attributes with "Global" in Their Names
--------------------------------------------------------

INSERT INTO Attribute_AnuragChandra
(AttributeName, BusinessUnitId, CustomerLocationId, CompanyId, IsActive, CreatedOn, CreatedBy)
VALUES
('Global Color', 1, 1, 1, 1, DATEADD(DAY, -10, GETDATE()), 'Anurag'),
('Global Size', 2, 3, 2, 1, DATEADD(DAY, -25, GETDATE()), 'Riya'),
('Global Weight', 3, 5, 3, 1, DATEADD(DAY, -40, GETDATE()), 'Rahul'),
('Global Material', 4, 7, 4, 0, DATEADD(DAY, -55, GETDATE()), 'Admin'),
('Global Grade', 5, 9, 5, 1, DATEADD(DAY, -70, GETDATE()), 'System');

--------------------------------------------------
-- Find Attributes Containing "Global"
--------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
WHERE AttributeName LIKE '%Global%';

---------------------------------------------------------------
-- Display Attribute Name in Uppercase and First 10 Characters
---------------------------------------------------------------

SELECT
    AttributeName,
    UPPER(AttributeName) AS UpperCaseName,
    SUBSTRING(AttributeName, 1, 10) AS First10Characters
FROM Attribute_AnuragChandra;

--------------------------------------------------
-- Replace Spaces with Hyphens in Attribute Names
--------------------------------------------------

SELECT
    AttributeName,
    REPLACE(AttributeName, ' ', '-') AS AttributeNameWithHyphens
FROM Attribute_AnuragChandra;

--------------------------------------------------
-- Display Attributes Longer Than 10 Characters
--------------------------------------------------

SELECT
    AttributeName,
    LEN(AttributeName) AS NameLength
FROM Attribute_AnuragChandra
WHERE LEN(AttributeName) > 10;

--------------------------------------------------
--------------------------------------------------

--Task 12

----------------------------------------------------
-- Retrieve Attributes Created in the Last 6 Months
----------------------------------------------------

SELECT *
FROM Attribute_AnuragChandra
WHERE CreatedOn >= DATEADD(MONTH, -6, GETDATE());

---------------------------------------------------
-- Calculate Days Since Each Attribute Was Created
---------------------------------------------------

SELECT
    AttributeName,
    CreatedOn,
    DATEDIFF(DAY, CreatedOn, GETDATE()) AS DaysSinceCreated
FROM Attribute_AnuragChandra;

--------------------------------------------------
-- Display Created Date in dd-MMM-yyyy Format
--------------------------------------------------

SELECT
    AttributeName,
    FORMAT(CreatedOn, 'dd-MMM-yyyy') AS FormattedDate
FROM Attribute_AnuragChandra;

--------------------------------------------------
-- Group Attributes by Their Creation Month
--------------------------------------------------

SELECT
    DATENAME(MONTH, CreatedOn) AS MonthName,
    MONTH(CreatedOn) AS MonthNumber,
    COUNT(*) AS TotalAttributes
FROM Attribute_AnuragChandra
GROUP BY
    MONTH(CreatedOn),
    DATENAME(MONTH, CreatedOn)
ORDER BY MonthNumber;

--------------------------------------------------
--------------------------------------------------

--Task 13

--------------------------------------------------
-- Display Attribute Status (Active / Inactive)
--------------------------------------------------

SELECT
    AttributeId,
    AttributeName,
    IsActive,
    CASE
        WHEN IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS Status
FROM Attribute_AnuragChandra;

--------------------------------------------------
-- Categorize Attributes by Age
--------------------------------------------------

SELECT
    AttributeId,
    AttributeName,
    CreatedOn,
    CASE
        WHEN CreatedOn >= DATEADD(MONTH, -3, GETDATE()) THEN 'New'
        WHEN CreatedOn >= DATEADD(MONTH, -6, GETDATE()) THEN 'Recent'
        WHEN CreatedOn >= DATEADD(MONTH, -12, GETDATE()) THEN 'Established'
        ELSE 'Old'
    END AS AgeCategory
FROM Attribute_AnuragChandra;

--------------------------------------------------
-- Display Data Completeness Status
--------------------------------------------------

SELECT
    AttributeId,
    AttributeName,
    UpdatedOn,
    UpdatedBy,
    CASE
        WHEN UpdatedOn IS NOT NULL
         AND UpdatedBy IS NOT NULL
        THEN 'Complete'
        ELSE 'Needs Update'
    END AS DataCompleteness
FROM Attribute_AnuragChandra;

--------------------------------------------------
--------------------------------------------------

--Task 14

--------------------------------------------------
-- Display Active and Inactive Attribute Counts
-- Using Conditional Aggregation (Without PIVOT)
--------------------------------------------------

select 
    BusinessUnitName, 
    SUM(CASE WHEN A.IsActive = 1 THEN 1 ELSE 0 END) AS Active,
    SUM(CASE WHEN A.IsActive = 0 THEN 1 ELSE 0 END) AS Inactive
    from Attribute_AnuragChandra A 
    join BusinessUnit_AnuragChandra B 
    on A.BusinessUnitId = B.BusinessUnitId 
   group by B.BusinessUnitId,BusinessUnitName
   order by BusinessUnitName;

--------------------------------------------------
-- Display Active and Inactive Attribute Counts
-- Using the PIVOT Operator
--------------------------------------------------

SELECT
    BusinessUnitName,
    ISNULL([1], 0) AS Active,
    ISNULL([0], 0) AS Inactive
FROM
(
    SELECT
        B.BusinessUnitName,
        A.AttributeId,
        A.IsActive
    FROM Attribute_AnuragChandra AS A
    JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
) AS SourceTable
PIVOT
(
    COUNT(AttributeId)
    FOR IsActive IN ([1], [0])
) AS PivotTable;

--------------------------------------------------
--------------------------------------------------

--Task 15

--------------------------------------------------
-- Convert Active and Inactive Counts into Rows
-- Using the UNPIVOT Operator
--------------------------------------------------

WITH AttributeCount AS
(
    SELECT
        B.BusinessUnitName,
        COUNT(CASE WHEN A.IsActive = 1 THEN 1 END) AS ActiveCount,
        COUNT(CASE WHEN A.IsActive = 0 THEN 1 END) AS InactiveCount
    FROM Attribute_AnuragChandra AS A
    INNER JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
    GROUP BY B.BusinessUnitName
)

SELECT
    BusinessUnitName,
    StatusType,
    StatusValue
FROM AttributeCount
UNPIVOT
(
    StatusValue
    FOR StatusType IN
    (
        ActiveCount,
        InactiveCount
    )
) AS UnpivotTable;

--------------------------------------------------
--------------------------------------------------

-- Task 16

--------------------------------------------------
-- Convert Counts into Rows Using CROSS APPLY
--------------------------------------------------

WITH AttributeCount AS
(
    SELECT
        B.BusinessUnitName,
        COUNT(CASE WHEN A.IsActive = 1 THEN 1 END) AS ActiveCount,
        COUNT(CASE WHEN A.IsActive = 0 THEN 1 END) AS InactiveCount
    FROM Attribute_AnuragChandra AS A
    INNER JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
    GROUP BY B.BusinessUnitName
)

SELECT
    AC.BusinessUnitName,
    X.StatusType,
    X.StatusValue
FROM AttributeCount AS AC
CROSS APPLY
(
    VALUES
        ('Active', AC.ActiveCount),
        ('Inactive', AC.InactiveCount),
        ('Total', AC.ActiveCount + AC.InactiveCount)
) AS X(StatusType, StatusValue);


SELECT *
FROM   Attribute_AnuragChandra;
SELECT *
FROM   BusinessUnit_AnuragChandra;
SELECT * FROM Company_AnuragChandra;
SELECT * FROM CustomerLocation_AnuragChandra;