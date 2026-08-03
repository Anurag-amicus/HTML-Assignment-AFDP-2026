-------------------------------------------------------------------------
--AFDP 2026
-------------------------------------------------------------------------

--Name - Anurag Chandra
--Path - Tech Path 2

------------------------------------------
--SQL Assignment 5
------------------------------------------

-- Task 1:-

-- Alter SAVE ATTRIBUTE FOR TRY CATCH
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
        SET @ResultAttributeId = -1
        SET @ResultMessage =
              'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10))
            + ' | Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A')
            + ' | Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10))
            + ' | Message: ' + ERROR_MESSAGE();
    END CATCH;
END;

-- Triggering Catch to Capture the error
go
DECLARE
    @ResultAttributeId INT,
    @ResultMessage NVARCHAR(500);

EXEC uspSaveAttribute_AnuragChandra
    @AttributeId = NULL,
    @AttributeName = 'Size',   -- Replace with an existing name
    @BusinessUnitId = 1,                          -- Same BU as the existing attribute
    @CustomerLocationId = 1,
    @CompanyId = 1,
    @IsActive = 1,
    @UpdatedBy = 'Anurag',
    @ResultAttributeId = @ResultAttributeId OUTPUT,
    @ResultMessage = @ResultMessage OUTPUT;

SELECT
    @ResultAttributeId AS ResultAttributeId,
    @ResultMessage AS ResultMessage;

--Task 2:-

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
        -- Check whether destination Business Unit exists
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
    END CATCH
END;
GO

--Alter table Attribute_AnuragChandr to allown null in customerLocationId
ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN CustomerLocationId INT NULL;

EXEC uspTransferAttributes_AnuragChandra
    @FromBusinessUnitId = 5,
    @ToBusinessUnitId = 2;

SELECT
    AttributeId,
    AttributeName,
    BusinessUnitId,
    CustomerLocationId
FROM Attribute_AnuragChandra
WHERE BusinessUnitId = 2;


--Task 3:-

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

        -- First Update

        SAVE TRANSACTION SP_BU1;

        UPDATE Attribute_AnuragChandra
        SET UpdatedBy = 'BULK_UPDATE_1',
            UpdatedOn = GETDATE()
        WHERE BusinessUnitId = @BusinessUnitId1;

        -- Second Update
    
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
        END
        -- Third Update

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
    END CATCH
END;
GO

--Test 1

EXEC uspBulkUpdateAttributes_AnuragChandra
    @BusinessUnitId1 = 1,
    @BusinessUnitId2 = 2,
    @BusinessUnitId3 = 3;

SELECT
    AttributeId,
    BusinessUnitId,
    UpdatedBy
FROM Attribute_AnuragChandra
WHERE BusinessUnitId IN (1,2,3);

--Test 2

EXEC uspBulkUpdateAttributes_AnuragChandra
    @BusinessUnitId1 = 1,
    @BusinessUnitId2 = 999,
    @BusinessUnitId3 = 3;

SELECT
    AttributeId,
    BusinessUnitId,
    UpdatedBy
FROM Attribute_AnuragChandra
WHERE BusinessUnitId IN (1,3);


--Task 4:-

-- READ Uncommited
BEGIN TRANSACTION;
UPDATE Attribute_AnuragChandra
SET AttributeName = 'Dirty Read Test'
WHERE AttributeId = 15;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT
    AttributeId,
    AttributeName
FROM Attribute_AnuragChandra
WHERE AttributeId = 15;

-- READ Commited

BEGIN TRANSACTION;

UPDATE Attribute_AnuragChandra
SET AttributeName = 'Read Committed Test'
WHERE AttributeId = 1;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT
    AttributeId,
    AttributeName
FROM Attribute_AnuragChandra
WHERE AttributeId = 1;

ROLLBACK TRANSACTION;

--REPEATABLE READ

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRANSACTION;

SELECT AttributeName
FROM Attribute_AnuragChandra
WHERE AttributeId = 1;

UPDATE Attribute_AnuragChandra
SET AttributeName = 'Changed Name'
WHERE AttributeId = 1;

SELECT AttributeName
FROM Attribute_AnuragChandra
WHERE AttributeId = 1;
RollBACK TRANSACTION

COMMIT TRANSACTION;

--SERIALIZABLE


SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRANSACTION;

SELECT COUNT(*)
FROM Attribute_AnuragChandra
WHERE BusinessUnitId = 1;

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
    'Serializable Test',
    1,
    1,
    1,
    1,
    GETDATE(),
    'Anurag'
);

ROLLBACK TRANSACTION;

--XACT ABORT

--DEMO TABLE
CREATE TABLE ParentDemo
(
    ParentId INT PRIMARY KEY
);

CREATE TABLE ChildDemo
(
    ChildId INT IDENTITY(1,1) PRIMARY KEY,
    ParentId INT
        REFERENCES ParentDemo(ParentId)
);

INSERT INTO ParentDemo
VALUES (1);

-- Stored Procedure

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
        -- Valid Insert
        INSERT INTO ChildDemo(ParentId)
        VALUES (1);
        -- Invalid Insert (FK Violation)
        INSERT INTO ChildDemo(ParentId)
        VALUES (999);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END;
GO

-- TESTING Xact Abort

EXEC uspXactAbortDemo_AnuragChandra
    @UseXactAbort = 0;

SELECT *
FROM ChildDemo;

EXEC uspXactAbortDemo_AnuragChandra
    @UseXactAbort = 1;

SELECT *
FROM ChildDemo;

--Task 5:-

-- BUG A
-- update without where

UPDATE Company_AnuragChandra
SET IsActive = 0;

SELECT
    CompanyId,
    CompanyName,
    IsActive
FROM Company_AnuragChandra;

-- PREVENTION

--use where
UPDATE Company_AnuragChandra
SET IsActive = 1
WHERE CompanyId in (1,2,3,4,5);
SELECT
    CompanyId,
    CompanyName,
    IsActive
FROM Company_AnuragChandra;

-- USE Transaction

BEGIN TRANSACTION;

UPDATE Company_AnuragChandra
SET IsActive = 0
WHERE CompanyId = 5;

SELECT *
FROM Company_AnuragChandra
WHERE CompanyId = 5;

ROLLBACK;
-- or
COMMIT;

--BUG B

--Introduce BUG

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
    'FK Test',
    999,
    1,
    1,
    1,
    GETDATE(),
    'Anurag'
);

--Handle with TRY CATCH

BEGIN TRY
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
        'FK Test',
        999,
        1,
        1,
        1,
        GETDATE(),
        'Anurag'
    );
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine,
        ERROR_PROCEDURE() AS ErrorProcedure;
END CATCH;

-- Task 6:-

--Before INDEXES
SELECT
    A.AttributeName,
    B.BusinessUnitName
FROM Attribute_AnuragChandra AS A
INNER JOIN BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.AttributeName LIKE '%Global%';

--Creating indexes

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

-- Running Query after Indexes

SELECT
    A.AttributeName,
    B.BusinessUnitName
FROM Attribute_AnuragChandra AS A
INNER JOIN BusinessUnit_AnuragChandra AS B
    ON A.BusinessUnitId = B.BusinessUnitId
WHERE A.AttributeName LIKE '%Global%';

-- Task 8
--Without optimization
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
    YEAR(A.CreatedOn) = 2025
    AND A.AttributeName LIKE '%Global%'
ORDER BY A.CreatedOn DESC;

-- With Optimization

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

--Task 9:-

--Using String Concatenation

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
--Testing
EXEC uspDynamicSearch_Wrong_AnuragChandra
    @TableName = 'Attribute_AnuragChandra',
    @ColumnName = 'AttributeName',
    @SearchValue = 'Global';

--Using sp_executesql
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

--Testing

EXEC uspDynamicSearch_AnuragChandra
    @TableName = 'Attribute_AnuragChandra',
    @ColumnName = 'AttributeName',
    @SearchValue = 'Global';