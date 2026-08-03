-- Functions.sql
-- Contains all user-defined functions from the assignment files

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

    UPDATE @Result
    SET AgeCategory =
        CASE
            WHEN DaysOld < 90 THEN 'New'
            WHEN DaysOld < 180 THEN 'Recent'
            WHEN DaysOld < 365 THEN 'Established'
            ELSE 'Old'
        END;

    UPDATE @Result
    SET Status =
        CASE
            WHEN IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END;

    RETURN;
END;
GO
