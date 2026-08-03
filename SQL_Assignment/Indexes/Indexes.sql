-- Indexes.sql
-- Contains index creation and query comparisons for index plan evaluation

-- Query before indexes
SELECT
    A.AttributeName,
    B.BusinessUnitName
FROM Attribute_AnuragChandra AS A
INNER JOIN BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.AttributeName LIKE '%Global%';

-- Creating indexes
CREATE NONCLUSTERED INDEX IX_Attribute_AttributeName
ON Attribute_AnuragChandra(AttributeName);
GO

CREATE NONCLUSTERED INDEX IX_Attribute_BusinessUnitId
ON Attribute_AnuragChandra(BusinessUnitId)
INCLUDE(AttributeName);
GO

CREATE NONCLUSTERED INDEX IX_Attribute_BusinessUnitId_IsActive
ON Attribute_AnuragChandra(BusinessUnitId, IsActive);
GO

-- Query after indexes
SELECT
    A.AttributeName,
    B.BusinessUnitName
FROM Attribute_AnuragChandra AS A
INNER JOIN BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.AttributeName LIKE '%Global%';

-- Optimized query for plan comparison
SELECT
    A.AttributeName,
    B.BusinessUnitName,
    C.CompanyName,
    CL.CustomerLocationName,
    A.CreatedOn
FROM Attribute_AnuragChandra AS A
INNER JOIN BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId
INNER JOIN Company_AnuragChandra AS C
    ON A.CompanyId = C.CompanyId
INNER JOIN CustomerLocation_AnuragChandra AS CL
    ON A.CustomerLocationId = CL.CustomerLocationId
WHERE
    A.CreatedOn >= '2025-01-01'
    AND A.CreatedOn < '2026-01-01'
    AND A.AttributeName LIKE 'Global%'
ORDER BY A.CreatedOn DESC;
