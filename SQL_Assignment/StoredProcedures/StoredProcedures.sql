-- StoredProcedures.sql
-- Contains all stored procedures from the assignment files

CREATE PROCEDURE uspGetAttributeList_AnuargChandra
    @IsActiveFilter BIT = NULL,
    @SearchTerm NVARCHAR(100) = NULL
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
END;
GO

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
GO

ALTER PROCEDURE uspSaveAttribute_AnuragChandra
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
        SET @ResultAttributeId = -1;
        SET @ResultMessage =
              'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10))
            + ' | Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A')
            + ' | Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10))
            + ' | Message: ' + ERROR_MESSAGE();
    END CATCH;
END;
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
    END;
END;
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
END;
GO

CREATE PROCEDURE uspCustomerLocationByBusinessUnit_AnuragChandra
    @BusinessUnitId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
         CustomerLocationName
    FROM CustomerLocation_AnuragChandra
    WHERE BusinessUnitId = @BusinessUnitId;
END;
GO

CREATE PROCEDURE uspGetCompanies_AnuragChandra
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
         CompanyId,
         CompanyName
    FROM Company_AnuragChandra
    WHERE IsActive = 1;
END;
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
GO

CREATE PROCEDURE uspSearchAttributes_AnuragChandra
    @SearchTerm NVARCHAR(100),
    @PageNumber INT = 1,
    @PageSize INT = 20,
    @TotalCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
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
        ROW_NUMBER() OVER (PARTITION BY B.BusinessUnitId ORDER BY A.CreatedOn DESC) AS ROWNUMinBU,
        RANK() OVER (PARTITION BY B.BusinessUnitId ORDER BY A.AttributeName) AS RANKOFNAMEinBU,
        NTILE(4) OVER (ORDER BY A.CreatedOn) AS Quartile,
        LAG(A.AttributeName) OVER (ORDER BY A.CreatedOn) AS PreviousAttributeName,
        DATEDIFF(DAY, LAG(A.CreatedOn) OVER (ORDER BY A.CreatedOn), A.CreatedOn) AS DaysSincePrevious,
        COUNT(*) OVER (PARTITION BY B.BusinessUnitId ORDER BY A.CreatedOn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningCountInBU
    FROM BusinessUnit_AnuragChandra B
    JOIN Attribute_AnuragChandra A
        ON B.BusinessUnitId = A.BusinessUnitId
    WHERE
        (
            @BusinessUnitId IS NULL
            OR A.BusinessUnitId = @BusinessUnitId
        );
END;
GO

CREATE PROCEDURE uspTransferAttributes_AnuragChandra
(
    @FromBusinessUnitId INT,
    @ToBusinessUnitId INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS
        (
            SELECT 1
            FROM BusinessUnit_AnuragChandra
            WHERE BusinessUnitId = @ToBusinessUnitId
        )
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Destination Business Unit does not exist.',16,1);
            RETURN;
        END;
        UPDATE Attribute_AnuragChandra
        SET BusinessUnitId = @ToBusinessUnitId
        WHERE BusinessUnitId = @FromBusinessUnitId;
        UPDATE Attribute_AnuragChandra
        SET CustomerLocationId = NULL
        WHERE BusinessUnitId = @ToBusinessUnitId;
        COMMIT TRANSACTION;
        PRINT 'Attribute transfer completed successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

CREATE PROCEDURE uspBulkUpdateAttributes_AnuragChandra
(
    @BusinessUnitId1 INT,
    @BusinessUnitId2 INT,
    @BusinessUnitId3 INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION SP_BU1;
        UPDATE Attribute_AnuragChandra
        SET UpdatedBy = 'BULK_UPDATE_1',
            UpdatedOn = GETDATE()
        WHERE BusinessUnitId = @BusinessUnitId1;
        SAVE TRANSACTION SP_BU2;
        IF NOT EXISTS
        (
            SELECT 1
            FROM Attribute_AnuragChandra
            WHERE BusinessUnitId = @BusinessUnitId2
        )
        BEGIN
            PRINT 'Business Unit 2 has no attributes.';
            ROLLBACK TRANSACTION SP_BU2;
        END
        ELSE
        BEGIN
            UPDATE Attribute_AnuragChandra
            SET UpdatedBy = 'BULK_UPDATE_2',
                UpdatedOn = GETDATE()
            WHERE BusinessUnitId = @BusinessUnitId2;
        END;
        SAVE TRANSACTION SP_BU3;
        UPDATE Attribute_AnuragChandra
        SET UpdatedBy = 'BULK_UPDATE_3',
            UpdatedOn = GETDATE()
        WHERE BusinessUnitId = @BusinessUnitId3;
        COMMIT TRANSACTION;
        PRINT 'Transaction Completed Successfully';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

CREATE PROCEDURE uspXactAbortDemo_AnuragChandra
    @UseXactAbort BIT
AS
BEGIN
    SET NOCOUNT ON;
    IF @UseXactAbort = 1
        SET XACT_ABORT ON;
    ELSE
        SET XACT_ABORT OFF;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO ChildDemo(ParentId)
        VALUES (1);
        INSERT INTO ChildDemo(ParentId)
        VALUES (999);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

CREATE PROCEDURE uspDynamicSearch_Wrong_AnuragChandra
(
    @TableName NVARCHAR(100),
    @ColumnName NVARCHAR(100),
    @SearchValue NVARCHAR(200)
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL =
    'SELECT *
     FROM ' + @TableName + '
     WHERE ' + @ColumnName +
     ' LIKE ''%' + @SearchValue + '%''';
    PRINT @SQL;
    EXEC(@SQL);
END;
GO

CREATE PROCEDURE uspDynamicSearch_AnuragChandra
(
    @TableName NVARCHAR(100),
    @ColumnName NVARCHAR(100),
    @SearchValue NVARCHAR(200)
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Value NVARCHAR(202);

    SET @SQL =
    N'SELECT *
    FROM ' + QUOTENAME(@TableName) + '
    WHERE ' + QUOTENAME(@ColumnName) + ' LIKE @Value';
    SET @Value = '%' + @SearchValue + '%';
    EXEC sp_executesql
        @SQL,
        N'@Value NVARCHAR(202)',
        @Value = @Value;
END;
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
