-------------------------------------------------------------------------
--AFDP 2026
-------------------------------------------------------------------------

--Name - Anurag Chandra
--Path - Tech Path 2

------------------------------------------
--SQL Assignment 2
------------------------------------------

-- Task 1:-

-- Multi-level GROUP BY
SELECT   B.BusinessUnitName,
         COUNT(CASE WHEN A.IsActive = 1 THEN 1 END) AS ActiveCount,
         COUNT(CASE WHEN A.IsActive = 0 THEN 1 END) AS InactiveCount
FROM     Attribute_AnuragChandra AS A
         INNER JOIN
         BusinessUnit_AnuragChandra AS B
         ON A.BusinessUnitId = B.BusinessUnitId
GROUP BY B.BusinessUnitName, A.IsActive
ORDER BY B.BusinessUnitName;

-- Adding company in group by

SELECT   B.BusinessUnitName,
         C.CompanyName,
         COUNT(CASE WHEN A.IsActive = 1 THEN 1 END) AS ActiveCount,
         COUNT(CASE WHEN A.IsActive = 0 THEN 1 END) AS InactiveCount
FROM     Attribute_AnuragChandra AS A
         INNER JOIN
         BusinessUnit_AnuragChandra AS B
         ON A.BusinessUnitId = B.BusinessUnitId
         INNER JOIN
         Company_AnuragChandra AS C
         ON A.CompanyId = C.CompanyId
GROUP BY B.BusinessUnitName, C.CompanyName, A.IsActive
ORDER BY B.BusinessUnitName, C.CompanyName;


-- GROUP BY with ROLLUP

SELECT   CASE 
            WHEN Grouping(B.BusinessUnitName) = 1 THEN 'Grand Total' 
            ELSE B.BusinessUnitName 
         END AS BusinessUnitName,
         CASE 
            WHEN Grouping(B.BusinessUnitName) = 1 THEN 'Grand Total' 
            WHEN GROUPING(A.IsActive) = 1 THEN 'Subtotal' 
            WHEN A.IsActive = 1 THEN 'Active' 
            ELSE 'InActive' 
         END AS STATUS,
         count(A.AttributeId) AS AttributeCount
FROM     Attribute_AnuragChandra AS A
         INNER JOIN
         BusinessUnit_AnuragChandra AS B
         ON A.BusinessUnitId = B.BusinessUnitId
GROUP BY ROLLUP(B.BusinessUnitName, A.IsActive);

-- GROUP BY with CUBE

SELECT   CASE 
            WHEN Grouping(B.BusinessUnitName) = 1 THEN 'Allbusinessunit' 
            ELSE B.BusinessUnitName 
         END AS BusinessUnitName,
         CASE 
            WHEN GROUPING(B.BusinessUnitName) = 1
             AND GROUPING(A.IsActive) = 1 THEN 'Grand Total'
            WHEN GROUPING(A.IsActive) = 1 THEN 'Subtotal' 
            WHEN A.IsActive = 1 THEN 'Active' 
            ELSE 'InActive' 
         END AS STATUS,
         count(A.AttributeId) AS AttributeCount
FROM     Attribute_AnuragChandra AS A
         INNER JOIN
         BusinessUnit_AnuragChandra AS B
         ON A.BusinessUnitId = B.BusinessUnitId
GROUP BY CUBE(B.BusinessUnitName, A.IsActive)
ORDER BY
    B.BusinessUnitName desc,
    A.IsActive desc;

-- GROUP BY with GROUPING SETS

SELECT
    B.BusinessUnitName,
    C.CompanyName,

    CASE
        WHEN GROUPING(B.BusinessUnitName) = 0 THEN 'By BU'
        WHEN GROUPING(C.CompanyName) = 0 THEN 'By Company'
        ELSE 'Grand Total'
    END AS RowType,

    COUNT(A.AttributeId) AS AttributeCount

FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
JOIN Company_AnuragChandra C
    ON A.CompanyId = C.CompanyId

GROUP BY GROUPING SETS
(
    (B.BusinessUnitName),
    (C.CompanyName),
    ()
)
ORDER BY
    RowType;

-- Filtered Aggregation

SELECT
    B.BusinessUnitName,
    COUNT(CASE WHEN A.IsActive = 1 THEN 1 END) AS ActiveCount
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
GROUP BY B.BusinessUnitName, B.BusinessUnitId
HAVING
    COUNT(CASE WHEN A.IsActive = 1 THEN 1 END) > 2
    AND EXISTS
    (
        SELECT 1
        FROM Attribute_AnuragChandra A2
        WHERE A2.BusinessUnitId = B.BusinessUnitId
          AND A2.CreatedOn >= DATEADD(MONTH, -3, GETDATE())
    );



-- Task 2:-

-- BusinessUnitName as rows, CompanyName as columns, and the COUNT of Attributes as values

SELECT *
FROM
(
    SELECT
        B.BusinessUnitName,
        C.CompanyName,
        A.AttributeId
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
    JOIN Company_AnuragChandra C
        ON A.CompanyId = C.CompanyId
) AS SourceTable

PIVOT
(
    COUNT(AttributeId)
    FOR CompanyName IN
    (
        [ABC Ltd],
        [XYZ Pvt Ltd],
        [Global Corp],
        [Prime Industries],
        [Vision Tech],
        [Future Solutions],
        [TechNova],
        [Green Energy]
    )
) AS PivotTable;

-- monthly summary pivot: rows = BusinessUnitName, columns = month names (Jan, Feb, Mar, etc.), values = count of Attributes created in that month

SELECT *
FROM
(
    SELECT
        B.BusinessUnitName,
        FORMAT(A.CreatedOn,'MMM') AS MonthName,
        A.AttributeId
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
) AS SourceTable

PIVOT
(
    COUNT(AttributeId)
    FOR MonthName IN
    (
        [Jan],
        [Feb],
        [Mar],
        [Apr],
        [May],
        [Jun],
        [Jul],
        [Aug],
        [Sep],
        [Oct],
        [Nov],
        [Dec]
    )
) AS PivotTable;

-- status pivot: rows = BusinessUnitName, columns = "Active" and "Inactive", values = count

SELECT *
FROM
(
    SELECT
        B.BusinessUnitName,
        CASE
            WHEN A.IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END AS Status,
        A.AttributeId
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
) AS SourceTable

PIVOT
(
    COUNT(AttributeId)
    FOR Status IN
    (
        [Active],
        [Inactive]
    )
) AS PivotTable;



-- Task 3:-


-- unpivot using cte
WITH StatusSummary AS
(
    SELECT
        B.BusinessUnitName,
        SUM(CASE WHEN A.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveCount,
        SUM(CASE WHEN A.IsActive = 0 THEN 1 ELSE 0 END) AS InactiveCount
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
    GROUP BY B.BusinessUnitName
)
SELECT
    BusinessUnitName,
    StatusType,
    StatusValue
FROM StatusSummary

UNPIVOT
(
    StatusValue
    FOR StatusType IN
    (
        ActiveCount,
        InactiveCount
    )
) AS UnpivotTable;

-- using cross apply

WITH StatusSummary AS
(
    SELECT
        B.BusinessUnitName,
        SUM(CASE WHEN A.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveCount,
        SUM(CASE WHEN A.IsActive = 0 THEN 1 ELSE 0 END) AS InactiveCount
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
    GROUP BY B.BusinessUnitName
)

SELECT
    S.BusinessUnitName,
    V.StatusType,
    V.StatusValue
FROM StatusSummary S
CROSS APPLY
(
    VALUES
        ('ActiveCount', S.ActiveCount),
        ('InactiveCount', S.InactiveCount)
) AS V(StatusType, StatusValue);

-- Task 4:-

-- INNER JOIN

SELECT  
      A.AttributeName,
      B.BusinessUnitName,
      CL.CustomerLocationName,
      C.CompanyName
    FROM Attribute_AnuragChandra A 
    join BusinessUnit_AnuragChandra B 
    on A.BusinessUnitId = B.BusinessUnitId
    join Company_AnuragChandra C 
    on C.CompanyId = A.CompanyId
    join CustomerLocation_AnuragChandra CL
    on A.CustomerLocationId = CL.CustomerLocationId

-- LEFT JOIN

SELECT 
      B.BusinessUnitName,
      count(A.AttributeId) as AttributeCount
    From BusinessUnit_AnuragChandra B Left join Attribute_AnuragChandra A
    on B.BusinessUnitId = A.BusinessUnitId
    Group By B.BusinessUnitId, B.BusinessUnitName

-- RIGHT JOIN

SELECT 
      B.BusinessUnitName,
      count(A.AttributeId) as AttributeCount
    From Attribute_AnuragChandra A RIGHT JOIN BusinessUnit_AnuragChandra B
    on B.BusinessUnitId = A.BusinessUnitId
    Group By B.BusinessUnitId, B.BusinessUnitName

-- Full outer JOIN

SELECT 
        B.BusinessUnitName,
        A.AttributeName,
        C.CompanyName
    From BusinessUnit_AnuragChandra B Full JOIN Attribute_AnuragChandra A
    on B.BusinessUnitId =  a.BusinessUnitId 
    FuLL JOIN Company_AnuragChandra C
    on C.CompanyId = A.CompanyId

-- CROSS JOIN

SELECT B.BusinessUnitName, C.CompanyName FROM 
    BusinessUnit_AnuragChandra B Cross join Company_AnuragChandra C


-- Task 5:-

-- using joins

SELECT  
      A.AttributeName,
      B.BusinessUnitName,
      CL.CustomerLocationName,
      C.CompanyName
    FROM Attribute_AnuragChandra A 
    join BusinessUnit_AnuragChandra B 
    on A.BusinessUnitId = B.BusinessUnitId
    join Company_AnuragChandra C 
    on C.CompanyId = A.CompanyId
    join CustomerLocation_AnuragChandra CL
    on A.CustomerLocationId = CL.CustomerLocationId

-- using correlated subqueries

SELECT
    A.AttributeName,
    (
      SELECT B.BusinessUnitName
      FROM BusinessUnit_AnuragChandra B
      WHERE B.BusinessUnitId = A.BusinessUnitId
    ) AS BusinessUnitName,
    (
       SELECT CL.CustomerLocationName
       FROM CustomerLocation_AnuragChandra CL
       WHERE CL.CustomerLocationId = A.CustomerLocationId
    ) AS CustomerLocationName,
    (
      SELECT C.CompanyName
      FROM Company_AnuragChandra C
      WHERE C.CompanyId = A.CompanyId
    ) AS CompanyName
FROM Attribute_AnuragChandra A;

-- using CTEs

WITH FULLTABLE as (
SELECT  
      A.AttributeName,
      B.BusinessUnitName,
      CL.CustomerLocationName,
      C.CompanyName
    FROM Attribute_AnuragChandra A 
    join BusinessUnit_AnuragChandra B 
    on A.BusinessUnitId = B.BusinessUnitId
    join Company_AnuragChandra C 
    on C.CompanyId = A.CompanyId
    join CustomerLocation_AnuragChandra CL
    on A.CustomerLocationId = CL.CustomerLocationId

)
SELECT 
    AttributeName,
    BusinessUnitName,
    CustomerLocationName,
    CompanyName
  From FULLTABLE


-- Task 6:-

-- All Attributes belonging to the Business Unit that has the most Attributes

SELECT
    AttributeName
FROM Attribute_AnuragChandra
WHERE BusinessUnitId =
(
    SELECT TOP (1)
        BusinessUnitId
    FROM Attribute_AnuragChandra
    GROUP BY BusinessUnitId
    ORDER BY COUNT(AttributeId) DESC
);

-- Business Units where at least one Attribute was created by "Admin"

SELECT 
    Distinct BusinessUnitName
    FROM BusinessUnit_AnuragChandra B 
    Where Exists
            (
            SELECT 1
            FROM Attribute_AnuragChandra A
            WHERE A.BusinessUnitId = B.BusinessUnitId
            AND A.CreatedBy = 'Admin'
            )


-- Business Units where NO Attributes exist using subqueries

SELECT
    B.BusinessUnitName
  FROM BusinessUnit_AnuragChandra B
  WHERE NOT EXISTS
        (
        SELECT 1
        FROM Attribute_AnuragChandra A
        WHERE A.BusinessUnitId = B.BusinessUnitId
        );

-- Business Units where NO Attributes exist using LEFT JOIN + IS NULL

SELECT
    B.BusinessUnitName
  FROM BusinessUnit_AnuragChandra B
  LEFT JOIN Attribute_AnuragChandra A
  ON B.BusinessUnitId = A.BusinessUnitId
WHERE A.BusinessUnitId IS NULL;

-- Most recently craeted attribute name and date per business unit

SELECT
    B.BusinessUnitId,
    B.BusinessUnitName,
    A.AttributeName,
    A.CreatedOn
FROM BusinessUnit_AnuragChandra AS B
JOIN Attribute_AnuragChandra AS A
    ON B.BusinessUnitId = A.BusinessUnitId
WHERE A.CreatedOn =
(
    SELECT MAX(A2.CreatedOn)
    FROM Attribute_AnuragChandra AS A2 
    WHERE A2.BusinessUnitId = B.BusinessUnitId
);


-- Task 7

-- CTE that ranks Attributes within each Business Unit by CreatedOn (most recent first) using ROW_NUMBER()

With RANKED as 
(   
    SELECT 
    B.BusinessUnitName,
    A.AttributeName,
    ROW_NUMBER() OVer (Partition by B.BusinessUnitId order by A.CreatedOn Desc) as AttributeRank
    FROM BusinessUnit_AnuragChandra B
    JOIN Attribute_AnuragChandra A
    ON B.BusinessUnitId = A.BusinessUnitId
)
SELECT 
    BusinessUnitName,
    AttributeName,
    AttributeRank
  FROM RANKED;

-- CTE to select only the top 2 most recent Attributes per Business Unit

With RANKED as 
(   
    SELECT 
    B.BusinessUnitName,
    A.AttributeName,
    DENSE_RANK() OVer (Partition by B.BusinessUnitId order by A.CreatedOn Desc) as AttributeRank
    FROM BusinessUnit_AnuragChandra B
    JOIN Attribute_AnuragChandra A
    ON B.BusinessUnitId = A.BusinessUnitId
)
SELECT 
    BusinessUnitName,
    AttributeName,
    AttributeRank
  FROM RANKED
  Where AttributeRank <=2

-- CTE that calculates running total of Attributes created per month

WITH MonthlyCount AS
(
    SELECT
        YEAR(CreatedOn) AS Year,
        MONTH(CreatedOn) AS Month,
        COUNT(*) AS AttributeCount
    FROM Attribute_AnuragChandra
    GROUP BY
        YEAR(CreatedOn),
        MONTH(CreatedOn)
)

SELECT
    Year,
    Month,
    AttributeCount,
    SUM(AttributeCount) OVER
    (   
        ORDER BY Year, Month
    ) AS RunningTotal
FROM MonthlyCount;

-- query with two CTEs — cteBUStats (count per BU) and cteCompanyStats (count per Company)

WITH cteBUStats AS
(
    SELECT
        B.BusinessUnitName,
        COUNT(A.AttributeId) AS TotalAttributes
    FROM BusinessUnit_AnuragChandra AS B
    LEFT JOIN Attribute_AnuragChandra AS A
        ON B.BusinessUnitId = A.BusinessUnitId
    GROUP BY
        B.BusinessUnitName
),
cteCompanyStats AS
(
    SELECT
        C.CompanyName,
        COUNT(A.AttributeId) AS TotalAttributes
    FROM Company_AnuragChandra AS C
    LEFT JOIN Attribute_AnuragChandra AS A
        ON C.CompanyId = A.CompanyId
    GROUP BY
        C.CompanyName
)

SELECT
    B.BusinessUnitName,
    B.TotalAttributes AS BusinessUnitAttributeCount,
    C.CompanyName,
    C.TotalAttributes AS CompanyAttributeCount
FROM cteBUStats AS B
CROSS JOIN cteCompanyStats AS C
ORDER BY
    B.BusinessUnitName,
    C.CompanyName;


-- Task 8:-

-- recursive CTE that generates a number sequence from 1 to 100

WITH NumberCTE AS
(
    -- Anchor
    SELECT 1 AS Number

    UNION ALL

    -- Recursive
    SELECT Number + 1
    FROM NumberCTE
    WHERE Number < 100
)
SELECT *
FROM NumberCTE;

-- recursive CTE that generates all dates between the earliest and latest Attribute CreatedOn

WITH DateRange AS
(
    SELECT
        MIN(CAST(CreatedOn AS DATE)) AS StartDate,
        MAX(CAST(CreatedOn AS DATE)) AS EndDate
    FROM Attribute_AnuragChandra
),
DateCTE AS
(
    -- Anchor
    SELECT StartDate AS ReportDate, EndDate
    FROM DateRange

    UNION ALL

    -- Recursive
    SELECT
        DATEADD(DAY, 1, ReportDate),
        EndDate
    FROM DateCTE
    WHERE ReportDate < EndDate
)
SELECT ReportDate
FROM DateCTE
OPTION (MAXRECURSION 0);

-- Organisational Hierarchy in BusinessUnit

-- Task 9:-

-- BusinessUnit + IsActive

SELECT
    BusinessUnitName,
    ActiveCount,
    InactiveCount
FROM
(
    SELECT
        B.BusinessUnitName,
        SUM(CASE WHEN A.IsActive = 1 THEN 1 ELSE 0 END) AS ActiveCount,
        SUM(CASE WHEN A.IsActive = 0 THEN 1 ELSE 0 END) AS InactiveCount
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
    GROUP BY B.BusinessUnitName
) AS StatusTable;

-- Joining the Attribute table to a derived table containing per-BU averages

SELECT
    Distinct B.BusinessUnitName,
    BUStats.AttributeCount
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
JOIN
(
    SELECT
        BusinessUnitId,
        COUNT(*) AS AttributeCount
    FROM Attribute_AnuragChandra
    GROUP BY BusinessUnitId
) AS BUStats
    ON A.BusinessUnitId = BUStats.BusinessUnitId
WHERE BUStats.AttributeCount >
(
    SELECT AVG(AttributeCount * 1.0)
    FROM
    (
        SELECT
            COUNT(*) AS AttributeCount
        FROM Attribute_AnuragChandra
        GROUP BY BusinessUnitId
    ) AS AvgTable
);

-- Task 10:-

--Create view for attribute Detail
go
CREATE VIEW EnterpriseApprovalUser.vw_AttributeDetail_AnuragChandra
AS
SELECT
    A.AttributeId,
    A.AttributeName,
    B.BusinessUnitName,
    CL.CustomerLocationName,
    C.CompanyName,
    A.IsActive,
    A.CreatedOn,
    A.CreatedBy,
    A.UpdatedOn,
    A.UpdatedBy
FROM EnterpriseApprovalUser.Attribute_AnuragChandra AS A
JOIN EnterpriseApprovalUser.BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId
JOIN EnterpriseApprovalUser.CustomerLocation_AnuragChandra AS CL
    ON A.CustomerLocationId = CL.CustomerLocationId
JOIN EnterpriseApprovalUser.Company_AnuragChandra AS C
    ON A.CompanyId = C.CompanyId;
GO

-- Create view for business unit details
CREATE VIEW EnterpriseApprovalUser.vw_BusinessUnitSummary_AnuragChandra
AS
SELECT
    B.BusinessUnitId,
    B.BusinessUnitName,

    COUNT(A.AttributeId) AS TotalAttributes,

    SUM(CASE
            WHEN A.IsActive = 1 THEN 1
            ELSE 0
        END) AS ActiveCount,

    SUM(CASE
            WHEN A.IsActive = 0 THEN 1
            ELSE 0
        END) AS InactiveCount,

    MAX(A.CreatedOn) AS MostRecentAttributeDate

FROM EnterpriseApprovalUser.BusinessUnit_AnuragChandra AS B
LEFT JOIN EnterpriseApprovalUser.Attribute_AnuragChandra AS A
    ON B.BusinessUnitId = A.BusinessUnitId

GROUP BY
    B.BusinessUnitId,
    B.BusinessUnitName;
GO
-- viewing them 
SELECT *
FROM vw_AttributeDetail_AnuragChandra;

SELECT *
FROM vw_BusinessUnitSummary_AnuragChandra;
go
-- Task 11:-

-- Creating Schema
CREATE SCHEMA Reporting_AnuragChandra;
GO

CREATE SCHEMA Audit_AnuragChandra;
GO

--Transfering views
ALTER SCHEMA Reporting_AnuragChandra
TRANSFER EnterpriseApprovalUser.vw_AttributeDetail_AnuragChandra;
GO

ALTER SCHEMA Reporting_AnuragChandra
TRANSFER EnterpriseApprovalUser.vw_BusinessUnitSummary_AnuragChandra;
GO

-- GRANT SELECT on Reporting_AnuragChandra to a test user/role
GRANT SELECT
ON SCHEMA::Reporting_AnuragChandra
TO SomeRole;

-- Task 12:-

--UNION / UNIONALL

--UNION
SELECT
    A.AttributeName,
    B.BusinessUnitName,
    'Active' AS Status
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.IsActive = 1

UNION

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    'Inactive' AS Status
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.IsActive = 0;

--UNION ALL
SELECT
    A.AttributeName,
    B.BusinessUnitName,
    'Active' AS Status
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.IsActive = 1

UNION ALL

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    'Inactive' AS Status
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.IsActive = 0;

-- INTERSECT
SELECT BusinessUnitId
FROM Attribute_AnuragChandra
WHERE IsActive = 1

INTERSECT

SELECT BusinessUnitId
FROM Attribute_AnuragChandra
WHERE CreatedOn >= DATEADD(MONTH, -6, GETDATE());

-- INTERSECT USING EXIST
SELECT DISTINCT
    A.BusinessUnitId
FROM Attribute_AnuragChandra A
WHERE A.IsActive = 1
AND EXISTS
(
    SELECT 1
    FROM Attribute_AnuragChandra B
    WHERE B.BusinessUnitId = A.BusinessUnitId
      AND B.CreatedOn >= DATEADD(MONTH, -6, GETDATE())
);

-- INTERSECT USING INNER JOINS

SELECT DISTINCT
    A.BusinessUnitId
FROM Attribute_AnuragChandra A
INNER JOIN Attribute_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.IsActive = 1
  AND B.CreatedOn >= DATEADD(MONTH, -6, GETDATE());

-- EXCEPT

SELECT DISTINCT
    BusinessUnitId
FROM Attribute_AnuragChandra

EXCEPT

SELECT DISTINCT
    BusinessUnitId
FROM Attribute_AnuragChandra
WHERE IsActive = 1;

-- using not exist

SELECT DISTINCT
    A.BusinessUnitId
FROM Attribute_AnuragChandra A
WHERE NOT EXISTS
(
    SELECT 1
    FROM Attribute_AnuragChandra B
    WHERE B.BusinessUnitId = A.BusinessUnitId
      AND B.IsActive = 1
);

--using left join

SELECT DISTINCT
    A.BusinessUnitId
FROM Attribute_AnuragChandra A
LEFT JOIN Attribute_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId
   AND B.IsActive = 1
WHERE B.BusinessUnitId IS NULL;

-- Task 13

--All Attributes where UpdatedBy is NULL

SELECT *
FROM Attribute_AnuragChandra
WHERE UpdatedBy IS NULL;

--COALESCE to display "Never Updated" when UpdatedBy is NULL

SELECT
    AttributeName,
    COALESCE(UpdatedBy, 'Never Updated') AS UpdatedBy
FROM Attribute_AnuragChandra;

--ISNULL to display UpdatedOn as CreatedOn when UpdatedOn is NULL

SELECT
    AttributeName,
    CreatedOn,
    ISNULL(UpdatedOn, CreatedOn) AS LastModifiedOn
FROM Attribute_AnuragChandra;

--Deliberately writing an incorrect NULL comparison

SELECT *
FROM Attribute_AnuragChandra
WHERE UpdatedBy = NULL;