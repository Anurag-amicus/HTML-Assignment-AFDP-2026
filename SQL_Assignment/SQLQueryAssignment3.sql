-------------------------------------------------------------------------
--AFDP 2026
-------------------------------------------------------------------------

--Name - Anurag Chandra
--Path - Tech Path 2

------------------------------------------
--SQL Assignment 3
------------------------------------------

-- Task 1:-

--Assign a row number within each Business Unit, ordered by newest first.

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    A.CreatedOn,
    ROW_NUMBER() OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn DESC
    ) AS RowNum
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId;

--Find the most recently created Attribute per BU

WITH NewestAttribute AS
(
    SELECT
        A.AttributeName,
        B.BusinessUnitName,
        A.CreatedOn,
        ROW_NUMBER() OVER
        (
            PARTITION BY A.BusinessUnitId
            ORDER BY A.CreatedOn DESC
        ) AS RowNum
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
)

SELECT
    AttributeName,
    BusinessUnitName,
    CreatedOn
FROM NewestAttribute
WHERE RowNum = 1;


--ROW_NUMBER() vs RANK() vs DENSE_RANK()

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    A.CreatedOn,

    ROW_NUMBER() OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS RowNumber,

    RANK() OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS RankNumber,

    DENSE_RANK() OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS DenseRank
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId;


-- NTILE()

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    A.CreatedOn,

    NTILE(4) OVER
    (
        ORDER BY A.CreatedOn
    ) AS Quartile
FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId;


-- LAG() AND LEAD()

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    A.CreatedOn,

    LAG(A.AttributeName) OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS PreviousAttribute,

    LEAD(A.AttributeName) OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS NextAttribute

FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId;

-- Task 2

--Running Total

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    A.CreatedOn,

    COUNT(*) OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS RunningCount

FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId;

-- Running Percentage

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    A.CreatedOn,

    COUNT(*) OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS RunningCount,

    COUNT(*) OVER
    (
        PARTITION BY A.BusinessUnitId
    ) AS TotalCount,

    CAST
    (
        COUNT(*) OVER
        (
            PARTITION BY A.BusinessUnitId
            ORDER BY A.CreatedOn
        ) * 100.0
        /
        COUNT(*) OVER
        (
            PARTITION BY A.BusinessUnitId
        )
        AS DECIMAL(5,2)
    ) AS RunningPercentage

FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId;

--Moving Average

WITH MonthlyCount AS
(
    SELECT
        YEAR(CreatedOn) AS YearNo,
        MONTH(CreatedOn) AS MonthNo,
        COUNT(*) AS AttributeCount
    FROM Attribute_AnuragChandra
    GROUP BY
        YEAR(CreatedOn),
        MONTH(CreatedOn)
)
SELECT
    YearNo,
    MonthNo,
    AttributeCount,

    AVG(AttributeCount * 1.0) OVER
    (
        ORDER BY YearNo, MonthNo
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverage

FROM MonthlyCount;

--Difference From Previous Attribute

SELECT
    A.AttributeName,
    B.BusinessUnitName,
    A.CreatedOn,

    LAG(A.CreatedOn) OVER
    (
        PARTITION BY A.BusinessUnitId
        ORDER BY A.CreatedOn
    ) AS PreviousCreatedOn,

    DATEDIFF
    (
        DAY,

        LAG(A.CreatedOn) OVER
        (
            PARTITION BY A.BusinessUnitId
            ORDER BY A.CreatedOn
        ),

        A.CreatedOn
    ) AS DaysDifference

FROM Attribute_AnuragChandra A
JOIN BusinessUnit_AnuragChandra B
    ON A.BusinessUnitId = B.BusinessUnitId;

-- Task 3

WITH RecentAttributes AS
(
    SELECT
        B.BusinessUnitName,
        A.AttributeName,
        ROW_NUMBER() OVER
        (
            PARTITION BY A.BusinessUnitId
            ORDER BY A.CreatedOn DESC
        ) AS RowNum
    FROM Attribute_AnuragChandra A
    JOIN BusinessUnit_AnuragChandra B
        ON A.BusinessUnitId = B.BusinessUnitId
)

SELECT
    BusinessUnitName,
    [1] AS MostRecent_1,
    [2] AS MostRecent_2,
    [3] AS MostRecent_3
FROM
(
    SELECT
        BusinessUnitName,
        AttributeName,
        RowNum
    FROM RecentAttributes
    WHERE RowNum <= 3
) AS SourceTable
PIVOT
(
    MAX(AttributeName)
    FOR RowNum IN ([1], [2], [3])
) AS PivotTable
ORDER BY BusinessUnitName;