-------------------------------------------------------------------------
--AFDP 2026
-------------------------------------------------------------------------

--Name - Anurag Chandra
--Path - Tech Path 2

------------------------------------------
--SQL Assignment 4
------------------------------------------

-- Task 1:-
-- GetAttribute list

CREATE PROCEDURE uspGetAttributeList_AnuargChandra

@IsActiveFilter BIT = NULL , @SearchTerm NVARCHAR(100) = NULL

AS 
BEGIN 
    SET NOCOUNT ON;
    SELECT TOP (500)
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
    FROM Attribute_AnuragChandra AS A
    JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
    JOIN Company_AnuragChandra AS C
        ON A.CompanyId = C.CompanyId
    JOIN CustomerLocation_AnuragChandra AS CL
        ON A.CustomerLocationId = CL.CustomerLocationId
    WHERE
        (@IsActiveFilter IS NULL OR A.IsActive = @IsActiveFilter)
    AND (@SearchTerm IS NULL OR A.AttributeName LIKE '%' + @SearchTerm + '%' OR B.BusinessUnitName LIKE '%' + @SearchTerm + '%')
    ORDER BY A.AttributeName;
END


-- Task 2:-
-- GetAttributeById

go

CREATE PROCEDURE uspGetAttributeById_AnuargChandra

@AttributeId INT 

AS 
BEGIN 
    SET NOCOUNT ON;
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
    FROM Attribute_AnuragChandra AS A
    JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
    JOIN Company_AnuragChandra AS C
        ON A.CompanyId = C.CompanyId
    JOIN CustomerLocation_AnuragChandra AS CL
        ON A.CustomerLocationId = CL.CustomerLocationId
    WHERE A.AttributeId = @AttributeId;
END;


-- Task 3:-

-- SAVE ATTRIBUTE
GO

CREATE PROCEDURE uspSaveAttribute_AnuragChandra
(
    @AttributeId INT = NULL,
    @AttributeName NVARCHAR(100),
    @BusinessUnitId INT,
    @CustomerLocationId INT,
    @CompanyId INT,
    @IsActive BIT,
    @UpdatedBy NVARCHAR(100),

    @ResultAttributeId INT OUTPUT,
    @ResultMessage NVARCHAR(500) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        IF LTRIM(RTRIM(@AttributeName)) = ''
        BEGIN
            SET @ResultMessage = 'Attribute Name cannot be empty.';
            RETURN;
        END;
        IF NOT EXISTS
        (
            SELECT 1
            FROM BusinessUnit_AnuragChandra
            WHERE BusinessUnitId = @BusinessUnitId
        )
        BEGIN
            SET @ResultMessage = 'Business Unit does not exist.';
            RETURN;
        END;
        -- Insert
        IF @AttributeId IS NULL
        BEGIN
            INSERT INTO Attribute_AnuragChandra
            (
                AttributeName,
                BusinessUnitId,
                CustomerLocationId,
                CompanyId,
                IsActive,
                CreatedOn,
                CreatedBy
            )
            VALUES
            (
                @AttributeName,
                @BusinessUnitId,
                @CustomerLocationId,
                @CompanyId,
                @IsActive,
                GETDATE(),
                @UpdatedBy
            );
            SET @ResultAttributeId = SCOPE_IDENTITY();
            SET @ResultMessage = 'Insert Successful';
        END
        --update
        ELSE
        BEGIN
            UPDATE Attribute_AnuragChandra
            SET
                AttributeName = @AttributeName,
                BusinessUnitId = @BusinessUnitId,
                CustomerLocationId = @CustomerLocationId,
                CompanyId = @CompanyId,
                IsActive = @IsActive,
                UpdatedOn = GETDATE(),
                UpdatedBy = @UpdatedBy
            WHERE AttributeId = @AttributeId;
            SET @ResultAttributeId = @AttributeId;
            SET @ResultMessage = 'Update Successful';
        END;
    END TRY
    BEGIN CATCH
        SET @ResultMessage = ERROR_MESSAGE();
    END CATCH;
END;
go

--Task 4:-
-- DELETE Attribute
GO

CREATE PROCEDURE uspDeleteAttribute_AnuragChandra
    @AttributeId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS
    (
        SELECT 1
        FROM Attribute_AnuragChandra
        WHERE AttributeId = @AttributeId
    )
    BEGIN
        UPDATE Attribute_AnuragChandra
        SET IsActive = 0,
            UpdatedOn = GETDATE(),
            UpdatedBy = 'SYSTEM'
        WHERE AttributeId = @AttributeId;

        RETURN 1;
    END
    ELSE
    BEGIN
        RETURN 0;
    END
END;


--Task 5:-
--GetBusinessUnits
GO

CREATE PROCEDURE uspGetBusinessUnits_AnuragChandra
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        BusinessUnitId,
        BusinessUnitName
    FROM BusinessUnit_AnuragChandra
    WHERE IsActive = 1
    ORDER BY BusinessUnitName;
END

--GetCustomerLocationsByBusinessUnit
go
CREATE PROCEDURE uspCustomerLocationByBusinessUnit_AnuragChandra
@BusinessUnitId INT 
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
         CustomerLocationName
    FROM CustomerLocation_AnuragChandra
    WHERE BusinessUnitId = @BusinessUnitId;
END

--GetCompanies
go
CREATE PROCEDURE uspGetCompanies_AnuragChandra
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
         CompanyId,
         CompanyName
    FROM Company_AnuragChandra
    WHERE IsActive = 1;
END

--Task 6:-
--GET Businessunit summary

GO

CREATE PROCEDURE uspGetBusinessUnitSummary_AnuragChandra
    @SortBy NVARCHAR(20) = 'Name'
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        B.BusinessUnitId,
        B.BusinessUnitName,
        COUNT(A.AttributeId) AS TotalAttributes,
        COUNT(CASE WHEN A.IsActive = 1 THEN 1 END) AS ActiveCount,
        COUNT(CASE WHEN A.IsActive = 0 THEN 1 END) AS InactiveCount,
        MAX(A.CreatedOn) AS MostRecentAttributeDate,
        MIN(A.CreatedOn) AS OldestAttributeDate
    FROM BusinessUnit_AnuragChandra AS B
    LEFT JOIN Attribute_AnuragChandra AS A
        ON B.BusinessUnitId = A.BusinessUnitId
    GROUP BY
        B.BusinessUnitId,
        B.BusinessUnitName
    ORDER BY
        CASE
            WHEN @SortBy = 'Name' THEN B.BusinessUnitName
        END ASC,
        CASE
            WHEN @SortBy = 'TotalAttributes' THEN COUNT(A.AttributeId)
        END DESC,
        CASE
            WHEN @SortBy = 'RecentDate' THEN MAX(A.CreatedOn)
        END DESC;
END;


--Task 7
--Search Attributes
GO

CREATE PROCEDURE uspSearchAttributes_AnuragChandra
    @SearchTerm NVARCHAR(100),
    @PageNumber INT = 1,
    @PageSize INT = 20,
    @TotalCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    -- Total matching records
    SELECT
        @TotalCount = COUNT(A.AttributeId)
    FROM Attribute_AnuragChandra AS A
    INNER JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
    INNER JOIN Company_AnuragChandra AS C
        ON A.CompanyId = C.CompanyId
    WHERE
        A.AttributeName LIKE '%' + @SearchTerm + '%'
        OR B.BusinessUnitName LIKE '%' + @SearchTerm + '%'
        OR C.CompanyName LIKE '%' + @SearchTerm + '%';
    -- Paginated Result
    SELECT
        A.AttributeId,
        A.AttributeName,
        B.BusinessUnitName,
        C.CompanyName,
        A.IsActive,
        A.CreatedOn,
        A.CreatedBy
    FROM Attribute_AnuragChandra AS A
    INNER JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
    INNER JOIN Company_AnuragChandra AS C
        ON A.CompanyId = C.CompanyId
    WHERE
        A.AttributeName LIKE '%' + @SearchTerm + '%'
        OR B.BusinessUnitName LIKE '%' + @SearchTerm + '%'
        OR C.CompanyName LIKE '%' + @SearchTerm + '%'
    ORDER BY
        A.AttributeName
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;

--Task 8:-
GO

CREATE PROCEDURE uspGetAttributeRankings_AnuragChandra
@BusinessUnitId INT = NULL
AS
BEGIN
SET NOCOUNT ON;
SELECT 
    A.AttributeId,
    B.BusinessUnitName,
    A.AttributeName,
    ROW_NUMBER() OVer (Partition by B.BusinessUnitId order by A.CreatedOn Desc) as ROWNUMinBU,
    RANK() Over (Partition by B.BusinessUnitId order by A.AttributeName) AS RANKOFNAMEinBU,
    NTILE(4) OVER (order by A.CreatedOn) AS Quartile,
    Lag(A.AttributeName) over(Order by A.CreatedOn) As PreviousAttributeName,
    DATEDIFF(DAY,LAG(A.CreatedOn) OVER (ORDER BY A.CreatedOn), A.CreatedOn) as DaysSincePrevious,
    COUNT(*) OVER(PARTITION BY B.BusinessUnitId ORDER BY A.CreatedOn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningCountInBU
    FROM BusinessUnit_AnuragChandra B
    JOIN Attribute_AnuragChandra A
    ON B.BusinessUnitId = A.BusinessUnitId
    WHERE
    (
        @BusinessUnitId IS NULL
        OR
        A.BusinessUnitId = @BusinessUnitId
    );
END;

--Task 9:-
--Function Get Attribute age
GO

CREATE FUNCTION fnGetAttributeAge_AnuragChandra (@CreatedOn DATETIME2)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Result NVARCHAR(50);
    DECLARE @Years INT;
    DECLARE @Months INT;
    DECLARE @Days INT;
    SET @Years = DATEDIFF(YEAR, @CreatedOn, GETDATE());
    IF DATEADD(YEAR, @Years, @CreatedOn) > GETDATE()
        SET @Years = @Years - 1;
    SET @Months = DATEDIFF(MONTH, DATEADD(YEAR, @Years, @CreatedOn), GETDATE());
    IF DATEADD
    (
        MONTH,
        @Months,
        DATEADD(YEAR, @Years, @CreatedOn)
    ) > GETDATE()
        SET @Months = @Months - 1;
    SET @Days = DATEDIFF
    (
        DAY,
        DATEADD
        (
            MONTH,
            @Months,
            DATEADD(YEAR, @Years, @CreatedOn)
        ),
        GETDATE()
    );
    IF @Years > 0
        SET @Result = CONCAT(@Years, ' years ', @Months, ' months',@Days ,'days');
    ELSE IF @Months > 0
        SET @Result = CONCAT(@Months, ' months ', @Days, ' days');
    ELSE IF @Days > 0
        SET @Result = CONCAT(@Days, ' days');
    ELSE
        SET @Result = '< 1 day';
    RETURN @Result;
END;
GO

--Using the function

SELECT
    AttributeName,
    EnterpriseApprovalUser.fnGetAttributeAge_AnuragChandra(CreatedOn) AS AttributeAge
FROM Attribute_AnuragChandra;


--Task 10

--function Get Attributes by company

GO

CREATE FUNCTION fnGetAttributesByCompany_AnuragChandra (@CompanyId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        A.AttributeId,
        A.AttributeName,
        B.BusinessUnitName,
        CL.CustomerLocationName,
        A.IsActive,
        A.CreatedOn,
        A.CreatedBy
    FROM Attribute_AnuragChandra AS A
    INNER JOIN BusinessUnit_AnuragChandra AS B
        ON A.BusinessUnitId = B.BusinessUnitId
    INNER JOIN CustomerLocation_AnuragChandra AS CL
        ON A.CustomerLocationId = CL.CustomerLocationId
    WHERE A.CompanyId = @CompanyId
);

GO  
--using the functio

SELECT
    C.CompanyId,
    C.CompanyName,
    F.AttributeId,
    F.AttributeName,
    F.BusinessUnitName,
    F.CustomerLocationName,
    F.IsActive,
    F.CreatedOn
FROM Company_AnuragChandra AS C
CROSS APPLY fnGetAttributesByCompany_AnuragChandra(C.CompanyId) AS F
ORDER BY
    C.CompanyName,
    F.AttributeName;


--Task 11:-

-- Get BusinessUnit Report
GO

CREATE FUNCTION fnGetBusinessUnitReport_AnuragChandra (@BusinessUnitId INT)
RETURNS @Result TABLE
(
    AttributeId INT,
    AttributeName NVARCHAR(100),
    AgeCategory NVARCHAR(20),
    DaysOld INT,
    CompanyName NVARCHAR(100),
    LocationName NVARCHAR(100),
    Status NVARCHAR(10),
    IsActive BIT
)
AS
BEGIN
    INSERT INTO @Result
    (
        AttributeId,
        AttributeName,
        AgeCategory,
        DaysOld,
        CompanyName,
        LocationName,
        Status,
        IsActive
    )
    SELECT
        A.AttributeId,
        A.AttributeName,
        NULL,
        DATEDIFF(DAY, A.CreatedOn, GETDATE()),
        C.CompanyName,
        CL.CustomerLocationName,
        NULL,
        A.IsActive
    FROM Attribute_AnuragChandra AS A
    INNER JOIN Company_AnuragChandra AS C
        ON A.CompanyId = C.CompanyId
    INNER JOIN CustomerLocation_AnuragChandra AS CL
        ON A.CustomerLocationId = CL.CustomerLocationId
    WHERE A.BusinessUnitId = @BusinessUnitId;
    -- Update AgeCategory
    UPDATE @Result
    SET AgeCategory =
        CASE
            WHEN DaysOld < 90 THEN 'New'
            WHEN DaysOld < 180 THEN 'Recent'
            WHEN DaysOld < 365 THEN 'Established'
            ELSE 'Old'
        END;
    -- Update Status
    UPDATE @Result
    SET Status =
        CASE
            WHEN IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END;
    RETURN;
END;
GO

--Testing
SELECT *
FROM fnGetBusinessUnitReport_AnuragChandra(2);


--Task 12
--Using #TEMP Table

CREATE TABLE #AttributeSummary
(
    AttributeId INT,
    AttributeName NVARCHAR(100),
    BusinessUnitName NVARCHAR(100),
    AgeCategory NVARCHAR(20)
);
INSERT INTO #AttributeSummary
(
    AttributeId,
    AttributeName,
    BusinessUnitName,
    AgeCategory
)
SELECT
    A.AttributeId,
    A.AttributeName,
    B.BusinessUnitName,
    CASE
        WHEN A.CreatedOn >= DATEADD(MONTH, -3, GETDATE()) THEN 'New'
        WHEN A.CreatedOn >= DATEADD(MONTH, -6, GETDATE()) THEN 'Recent'
        WHEN A.CreatedOn >= DATEADD(MONTH, -12, GETDATE()) THEN 'Established'
        ELSE 'Old'
    END AS AgeCategory
FROM Attribute_AnuragChandra AS A
INNER JOIN BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId;

--Summary Query

SELECT
    AgeCategory,
    COUNT(*) AS TotalAttributes
FROM #AttributeSummary
GROUP BY AgeCategory

SELECT *
FROM #AttributeSummary;

--Using @table Variable

DECLARE @AttributeSummary TABLE
(
    AttributeId INT,
    AttributeName NVARCHAR(100),
    BusinessUnitName NVARCHAR(100),
    AgeCategory NVARCHAR(20)
);
INSERT INTO @AttributeSummary
(
    AttributeId,
    AttributeName,
    BusinessUnitName,
    AgeCategory
)
SELECT
    A.AttributeId,
    A.AttributeName,
    B.BusinessUnitName,
    CASE
        WHEN A.CreatedOn >= DATEADD(MONTH, -3, GETDATE()) THEN 'New'
        WHEN A.CreatedOn >= DATEADD(MONTH, -6, GETDATE()) THEN 'Recent'
        WHEN A.CreatedOn >= DATEADD(MONTH, -12, GETDATE()) THEN 'Established'
        ELSE 'Old'
    END
FROM Attribute_AnuragChandra AS A
INNER JOIN BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId;

--Summary Query
SELECT
    AgeCategory,
    COUNT(*) AS TotalAttributes
FROM @AttributeSummary
GROUP BY AgeCategory
ORDER BY AgeCategory;

SELECT *
FROM @AttributeSummary;


--Task 13:-

-- Cursor Based Stored Procedure

GO

CREATE PROCEDURE uspMarkStaleAttributes_Cursor_AnuragChandra
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @AttributeId INT,
        @CreatedOn DATETIME2,
        @UpdatedOn DATETIME2;
    DECLARE AttributeCursor CURSOR
    LOCAL FAST_FORWARD
    FOR
        SELECT
            AttributeId,
            CreatedOn,
            UpdatedOn
        FROM Attribute_AnuragChandra;
    OPEN AttributeCursor;
    FETCH NEXT
    FROM AttributeCursor
    INTO
        @AttributeId,
        @CreatedOn,
        @UpdatedOn;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @CreatedOn < DATEADD(YEAR,-1,GETDATE())
           AND @UpdatedOn IS NULL
        BEGIN
            UPDATE Attribute_AnuragChandra
            SET
                IsActive = 0,
                UpdatedBy = 'SYSTEM_STALE'
            WHERE AttributeId = @AttributeId;
        END;
        FETCH NEXT
        FROM AttributeCursor
        INTO
            @AttributeId,
            @CreatedOn,
            @UpdatedOn;
    END;
    CLOSE AttributeCursor;
    DEALLOCATE AttributeCursor;
END;
GO

--Set Based Stored Procedure
GO

CREATE PROCEDURE uspMarkStaleAttributes_SetBased_AnuragChandra
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Attribute_AnuragChandra
    SET
        IsActive = 0,
        UpdatedBy = 'SYSTEM_STALE'
    WHERE
        CreatedOn < DATEADD(YEAR,-1,GETDATE())
        AND UpdatedOn IS NULL;
END;
GO


GO
--Task 14
-- Audit Table

CREATE TABLE AttributeAudit_AnuragChandra
(
    AuditId INT IDENTITY(1,1) PRIMARY KEY,
    AttributeId INT NOT NULL,
    Action NVARCHAR(10) NOT NULL,
    OldAttributeName NVARCHAR(100),
    NewAttributeName NVARCHAR(100),
    OldIsActive BIT,
    NewIsActive BIT,
    ChangedBy NVARCHAR(100),
    ChangedOn DATETIME2
        DEFAULT GETDATE()
);
GO

--After Insert Trigger


CREATE TRIGGER trgAttribute_AfterInsert_AnuragChandra
ON Attribute_AnuragChandra
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AttributeAudit_AnuragChandra
    (
        AttributeId,
        Action,
        OldAttributeName,
        NewAttributeName,
        OldIsActive,
        NewIsActive,
        ChangedBy,
        ChangedOn
    )
    SELECT
        I.AttributeId,
        'INSERT',
        NULL,
        I.AttributeName,
        NULL,
        I.IsActive,
        I.CreatedBy,
        GETDATE()
    FROM INSERTED AS I;
END;
GO

-- After Update Trigger

GO

CREATE TRIGGER trgAttribute_AfterUpdate_AnuragChandra
ON Attribute_AnuragChandra
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AttributeAudit_AnuragChandra
    (
        AttributeId,
        Action,
        OldAttributeName,
        NewAttributeName,
        OldIsActive,
        NewIsActive,
        ChangedBy,
        ChangedOn
    )
    SELECT
        I.AttributeId,
        'UPDATE',
        D.AttributeName,
        I.AttributeName,
        D.IsActive,
        I.IsActive,
        I.UpdatedBy,
        GETDATE()
    FROM INSERTED I
    INNER JOIN DELETED D
        ON I.AttributeId = D.AttributeId
    WHERE
        I.AttributeName <> D.AttributeName
        OR I.IsActive <> D.IsActive;
END;
GO

--After Delete Trigger

GO

CREATE TRIGGER trgAttribute_AfterDelete_AnuragChandra
ON Attribute_AnuragChandra
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AttributeAudit_AnuragChandra
    (
        AttributeId,
        Action,
        OldAttributeName,
        NewAttributeName,
        OldIsActive,
        NewIsActive,
        ChangedBy,
        ChangedOn
    )
    SELECT
        D.AttributeId,
        'DELETE',
        D.AttributeName,
        NULL,
        D.IsActive,
        NULL,
        D.UpdatedBy,
        GETDATE()
    FROM DELETED D;
END;
GO

--Create a view for instead of Trigger

GO

CREATE VIEW vw_ActiveAttributes_AnuragChandra
AS
SELECT *
FROM Attribute_AnuragChandra
WHERE IsActive = 1;
GO

--Instead of Delete Trigger on the view

GO

CREATE TRIGGER trgAttribute_InsteadOfDelete_AnuragChandra
ON vw_ActiveAttributes_AnuragChandra
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE A
    SET
        IsActive = 0,
        UpdatedBy = 'SYSTEM',
        UpdatedOn = GETDATE()
    FROM Attribute_AnuragChandra A
    INNER JOIN DELETED D
        ON A.AttributeId = D.AttributeId;
END;
GO

-- Testing Insert Trigger
INSERT INTO Attribute_AnuragChandra
(
    AttributeName,
    BusinessUnitId,
    CustomerLocationId,
    CompanyId,
    IsActive,
    CreatedOn,
    CreatedBy
)
VALUES
(
    'Trigger Test Insert',
    1,
    1,
    1,
    1,
    GETDATE(),
    'Anurag'
);

SELECT TOP 1 *
FROM AttributeAudit_AnuragChandra
ORDER BY AuditId DESC;

-- Testing after update Trigger

UPDATE Attribute_AnuragChandra
SET
    AttributeName = 'Trigger Test Updated',
    UpdatedBy = 'Anurag',
    UpdatedOn = GETDATE()
WHERE AttributeName = 'Trigger Test Insert';

SELECT TOP 1 *
FROM AttributeAudit_AnuragChandra
ORDER BY AuditId DESC;

-- only change createdon and it should not log

UPDATE Attribute_AnuragChandra
SET CreatedOn = DATEADD(DAY,1,CreatedOn)
WHERE AttributeName='Trigger Test Updated';

SELECT TOP 5 *
FROM AttributeAudit_AnuragChandra
ORDER BY AuditId DESC;

--Testing After Delete Trigger

DELETE
FROM Attribute_AnuragChandra
WHERE AttributeName='Trigger Test Updated';

SELECT TOP 1 *
FROM AttributeAudit_AnuragChandra
ORDER BY AuditId DESC;

-- Testing Instead of Delete Trigger

-- Insert another record

INSERT INTO Attribute_AnuragChandra
(
    AttributeName,
    BusinessUnitId,
    CustomerLocationId,
    CompanyId,
    IsActive,
    CreatedOn,
    CreatedBy
)
VALUES
(
    'View Delete Test',
    1,
    1,
    1,
    1,
    GETDATE(),
    'Anurag'
);

-- Delete Through View

DELETE
FROM vw_ActiveAttributes_AnuragChandra
WHERE AttributeName='View Delete Test';

--Checking Whether it was deleted or not

SELECT
    AttributeId,
    AttributeName,
    IsActive,
    UpdatedBy,
    UpdatedOn
FROM Attribute_AnuragChandra
WHERE AttributeName='View Delete Test';

--View Complete Audit History

SELECT *
FROM AttributeAudit_AnuragChandra
ORDER BY AuditId;

