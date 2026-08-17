-------------------------------------------------------------------------
--AFDP 2026
-------------------------------------------------------------------------

--Name - Anurag Chandra
--Path - Tech Path 2

------------------------------------------
--SQL Assignment 7
------------------------------------------

USE TrainingDB;
GO


-- Creating Tables

-- EmployeeMaster table

CREATE TABLE EnterpriseApprovalUser.EmployeeMaster_AnuragChandra
(
    EmployeeMasterId INT PRIMARY KEY,
    SAPNumber INT NOT NULL,
    EmployeeName NVARCHAR(300) NOT NULL,
    EmployeeEmail NVARCHAR(300) NOT NULL,
    IsActive INT NOT NULL,
    CreatedBy NVARCHAR(300) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    UpdatedBy NVARCHAR(300),
    UpdatedOn DATETIME2
);

-- StatusMaster table

CREATE TABLE EnterpriseApprovalUser.StatusMaster_AnuragChandra
(
    StatusMasterId INT PRIMARY KEY,
    StatusTitle NVARCHAR(50) NOT NULL,
    StatusCode NVARCHAR(50) NOT NULL,
    CreatedBy NVARCHAR(300) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    UpdatedBy NVARCHAR(300),
    UpdatedOn DATETIME2
);

-- CurrencyExchange table

CREATE TABLE EnterpriseApprovalUser.CurrencyExchange_AnuragChandra
(
    CurrencyExchangeId INT PRIMARY KEY,
    FromCurrencyCode NVARCHAR(10) NOT NULL,
    ToCurrencyCode NVARCHAR(10) NOT NULL,
    ExchangeRate DECIMAL(18,4) NOT NULL,
    PlanningYear INT NOT NULL,
    CreatedBy NVARCHAR(300) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    UpdatedBy NVARCHAR(300),
    UpdatedOn DATETIME2
);

-- ApprovalStatusMaster table

CREATE TABLE EnterpriseApprovalUser.ApprovalStatusMaster_AnuragChandra
(
    ApprovalStatusMasterId INT PRIMARY KEY,
    ApprovalStatusTitle NVARCHAR(50) NOT NULL,
    ApprovalStatusCode NVARCHAR(10) NOT NULL,
    CreatedBy NVARCHAR(300) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    UpdatedBy NVARCHAR(300),
    UpdatedOn DATETIME2
);

-- EmployeeSalary table

CREATE TABLE EnterpriseApprovalUser.EmployeeSalary_AnuragChandra
(
    EmployeeSalaryId INT PRIMARY KEY,
    EmployeeMasterId INT 
        REFERENCES EnterpriseApprovalUser.EmployeeMaster_AnuragChandra(EmployeeMasterId),

    ManagerEmployeeMasterId INT 
        REFERENCES EnterpriseApprovalUser.EmployeeMaster_AnuragChandra(EmployeeMasterId),

    LocalHREmployeeMasterId INT 
        REFERENCES EnterpriseApprovalUser.EmployeeMaster_AnuragChandra(EmployeeMasterId),

    PlannerEmployeeMasterId INT 
        REFERENCES EnterpriseApprovalUser.EmployeeMaster_AnuragChandra(EmployeeMasterId),

    PlanningYear INT,
    Status INT 
        REFERENCES EnterpriseApprovalUser.StatusMaster_AnuragChandra(StatusMasterId),

    CurrentSalaryLocalCurrency DECIMAL(18,2) NOT NULL,
    LocalCurrency NVARCHAR(30) NOT NULL,
    ProposedNewSalaryLocalCurrency DECIMAL(18,2) NOT NULL,
    CreatedBy NVARCHAR(300) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    UpdatedBy NVARCHAR(300),
    UpdatedOn DATETIME2
);

-- ApprovalTask table

CREATE TABLE EnterpriseApprovalUser.ApprovalTask_AnuragChandra
(
    ApprovalTaskId INT PRIMARY KEY,
    EmployeeSalaryId INT
        REFERENCES EnterpriseApprovalUser.EmployeeSalary_AnuragChandra(EmployeeSalaryId),

    ApproverEmployeeMasterId INT
        REFERENCES EnterpriseApprovalUser.EmployeeMaster_AnuragChandra(EmployeeMasterId),

    ApprovalStausMasterId INT
        REFERENCES EnterpriseApprovalUser.ApprovalStatusMaster_AnuragChandra(ApprovalStatusMasterId),

    Stage INT,
    IsApproved INT,
    IsRejected INT,
    Comment NVARCHAR(MAX),
    CreatedBy NVARCHAR(300) NOT NULL,
    CreatedOn DATETIME2 NOT NULL,
    UpdatedBy NVARCHAR(300),
    UpdatedOn DATETIME2
);

-- Inserting values into tables

-- Inserting into EmployeeMaster_AnuragChandra

INSERT INTO EnterpriseApprovalUser.EmployeeMaster_AnuragChandra
(
    EmployeeMasterId,
    SAPNumber,
    EmployeeName,
    EmployeeEmail,
    IsActive,
    CreatedBy,
    CreatedOn,
    UpdatedBy,
    UpdatedOn
)
VALUES
(1, 453627, 'Chetan Verma',     'chetan_verma@amicusglobal.com',     1, 'system', '2026-08-13T08:09:04.110', 'system', '2026-08-13T08:09:04.110'),
(2, 453678, 'Ankita Chourasia', 'ankita_chourasia@amicusglobal.com', 1, 'system', '2026-08-13T09:09:04.110', 'system', '2026-08-13T09:09:04.110'),
(3, 453679, 'Srishti Kumari',   'srishti_kumari@amicusglobal.com',   1, 'system', '2026-08-13T10:09:04.110', 'system', '2026-08-13T10:09:04.110'),
(4, 453680, 'Vaibhav Mishra',   'vaibhav_mishra@amicusglobal.com',   1, 'system', '2026-08-13T11:09:04.110', 'system', '2026-08-13T11:09:04.110'),
(5, 453681, 'Rohan Sinha',      'rohan_sinha@amicusglobal.com',      1, 'system', '2026-08-14T00:00:00.000', 'system', '2026-08-14T00:00:00.000'),
(6, 453682, 'Niyaz Khan',       'niyaz_khan@amicusglobal.com',       1, 'system', '2026-08-15T00:00:00.000', 'system', '2026-08-15T00:00:00.000');
GO

-- Inserting into StatusMaster_AnuragChandra

INSERT INTO EnterpriseApprovalUser.StatusMaster_AnuragChandra
(
    StatusMasterId,
    StatusTitle,
    StatusCode,
    CreatedBy,
    CreatedOn,
    UpdatedBy,
    UpdatedOn
)
VALUES
(1, 'Completed',   'CMPL', 'system', '2026-08-13T08:09:04.110', 'system', '2026-08-13T08:09:04.110'),
(2, 'In Progress', 'INPG', 'system', '2026-08-13T09:09:04.110', 'system', '2026-08-13T09:09:04.110'),
(3, 'Draft',       'DRFT', 'system', '2026-08-13T10:09:04.110', 'system', '2026-08-13T10:09:04.110'),
(4, 'Rejected',    'RJCT', 'system', '2026-08-13T11:09:04.110', 'system', '2026-08-13T11:09:04.110');
GO

-- Inserting into CurrencyExchange_AnuragChandra

INSERT INTO EnterpriseApprovalUser.CurrencyExchange_AnuragChandra
(
    CurrencyExchangeId,
    FromCurrencyCode,
    ToCurrencyCode,
    ExchangeRate,
    PlanningYear,
    CreatedBy,
    CreatedOn,
    UpdatedBy,
    UpdatedOn
)
VALUES
(1, 'USD', 'USD', 1.0000, 2026, 'system', '2026-08-13T08:09:04.110', 'system', '2026-08-13T08:09:04.110'),
(2, 'INR', 'USD', 0.0104, 2026, 'system', '2026-08-13T09:09:04.110', 'system', '2026-08-13T09:09:04.110');
GO

-- Inserting into ApprovalStatusMaster_AnuragChandra

INSERT INTO EnterpriseApprovalUser.ApprovalStatusMaster_AnuragChandra
(
    ApprovalStatusMasterId,
    ApprovalStatusTitle,
    ApprovalStatusCode,
    CreatedBy,
    CreatedOn,
    UpdatedBy,
    UpdatedOn
)
VALUES
(1, 'Approved',  'APR', 'system', '2026-08-13T08:09:04.110', 'system', '2026-08-13T08:09:04.110'),
(2, 'Pending',   'PEN', 'system', '2026-08-13T08:09:04.110', 'system', '2026-08-13T08:09:04.110'),
(3, 'Send Back', 'SNB', 'system', '2026-08-13T09:09:04.110', 'system', '2026-08-13T09:09:04.110');
GO

-- Inserting into EmployeeSalary_AnuragChandra

INSERT INTO EnterpriseApprovalUser.EmployeeSalary_AnuragChandra
(
    EmployeeSalaryId,
    EmployeeMasterId,
    ManagerEmployeeMasterId,
    LocalHREmployeeMasterId,
    PlannerEmployeeMasterId,
    PlanningYear,
    Status,
    CurrentSalaryLocalCurrency,
    LocalCurrency,
    ProposedNewSalaryLocalCurrency,
    CreatedBy,
    CreatedOn,
    UpdatedBy,
    UpdatedOn
)
VALUES
(1, 1, 4, 5, 6, 2026, 1, 500.00, 'INR', 535.00, 'system', '2026-08-13T08:09:04.110', 'system', '2026-08-13T08:09:04.110'),
(2, 2, 4, 5, 6, 2026, 2, 600.00, 'INR', 700.00, 'system', '2026-08-13T09:09:04.110', 'system', '2026-08-13T09:09:04.110'),
(3, 3, 4, 5, 6, 2026, 3, 700.00, 'INR', 900.00, 'system', '2026-08-14T00:00:00.000', 'system', '2026-08-14T00:00:00.000');
GO

-- Inserting into ApprovalTask_AnuragChandra

INSERT INTO EnterpriseApprovalUser.ApprovalTask_AnuragChandra
(
    ApprovalTaskId,
    EmployeeSalaryId,
    ApproverEmployeeMasterId,
    ApprovalStausMasterId,
    Stage,
    IsApproved,
    IsRejected,
    Comment,
    CreatedBy,
    CreatedOn,
    UpdatedBy,
    UpdatedOn
)
VALUES
(1, 1, 4, 1, 1, 1, 0, 'Approved Comment 1', 'system', '2026-08-13T08:09:04.110', 'vaibhav_mishra@amicusglobal.com', '2026-08-13T08:09:04.110'),
(2, 1, 5, 1, 2, 1, 0, 'Approved Comment 2', 'system', '2026-08-13T09:09:04.110', 'rohan_sinha@amicusglobal.com', '2026-08-13T09:09:04.110'),
(3, 1, 6, 2, 3, 0, 0, NULL, 'system', '2026-08-14T00:00:00.000', NULL, NULL),
(4, 2, 4, 3, 1, 0, 1, NULL, 'system', '2026-08-13T08:09:04.110', NULL, NULL),
(5, 3, 4, 2, 1, 0, 0, NULL, 'system', '2026-08-13T09:09:04.110', NULL, NULL);
GO


-----------------------------------------------------------------------------------------------------------


-- TASK 1 
-- EmployeeSummary - Stored Procedure

CREATE OR ALTER PROCEDURE EnterpriseApprovalUser.uspGetEmployeeSummary_AnuragChandra
AS
BEGIN
    SET NOCOUNT ON;
    WITH ApprovalTaskCTE AS
    (
        SELECT
            AT.*,
            ROW_NUMBER() OVER
            (
                PARTITION BY AT.EmployeeSalaryId
                ORDER BY AT.Stage DESC
            ) AS RowNum
        FROM EnterpriseApprovalUser.ApprovalTask_AnuragChandra AT
    )

    SELECT 
        E.SAPNumber AS EmployeeSAPNumber,
        E.EmployeeName,
        M.EmployeeName AS EmployeeManagerName,
        ES.CurrentSalaryLocalCurrency,
        ES.CurrentSalaryLocalCurrency * CE.ExchangeRate AS CurrentSalaryUSD,
        ES.ProposedNewSalaryLocalCurrency,
        ES.ProposedNewSalaryLocalCurrency * CE.ExchangeRate AS ProposedSalaryUSD,
        ES.PlanningYear,
        CASE
            WHEN SM.StatusTitle = 'In Progress'
                THEN 'In Progress : ' + AN.EmployeeName
                     + ' (Stage ' + CAST(AT.Stage AS VARCHAR(10)) + ')'
            ELSE SM.StatusTitle
        END AS StatusTitle,
        HR.EmployeeName AS LocalHRName
    FROM EnterpriseApprovalUser.EmployeeMaster_AnuragChandra E
    LEFT JOIN EnterpriseApprovalUser.EmployeeSalary_AnuragChandra ES
        ON ES.EmployeeMasterId = E.EmployeeMasterId
    LEFT JOIN EnterpriseApprovalUser.EmployeeMaster_AnuragChandra M
        ON ES.ManagerEmployeeMasterId = M.EmployeeMasterId
    LEFT JOIN EnterpriseApprovalUser.EmployeeMaster_AnuragChandra HR
        ON ES.LocalHREmployeeMasterId = HR.EmployeeMasterId
    LEFT JOIN EnterpriseApprovalUser.StatusMaster_AnuragChandra SM
        ON ES.Status = SM.StatusMasterId
    LEFT JOIN EnterpriseApprovalUser.CurrencyExchange_AnuragChandra CE
        ON ES.LocalCurrency = CE.FromCurrencyCode
        AND CE.ToCurrencyCode = 'USD'
        AND CE.PlanningYear = ES.PlanningYear
    LEFT JOIN ApprovalTaskCTE AT
        ON ES.EmployeeSalaryId = AT.EmployeeSalaryId
        AND AT.RowNum = 1
    LEFT JOIN EnterpriseApprovalUser.EmployeeMaster_AnuragChandra AN
        ON AT.ApproverEmployeeMasterId = AN.EmployeeMasterId;
END;
GO

-- TASK 2
-- PlannerSummary - Stored Procedure

CREATE OR ALTER PROCEDURE EnterpriseApprovalUser.uspGetPlannerSummary_AnuragChandra
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        PN.EmployeeName AS PlannerName,
        ES.PlanningYear,
        COUNT(ES.EmployeeSalaryId) AS TotalAssociates,
        SUM(
            CASE
                WHEN SM.StatusTitle = 'Draft' THEN 1
                ELSE 0
            END
        ) AS Draft,
        SUM(
            CASE
                WHEN SM.StatusTitle = 'In Progress' THEN 1
                ELSE 0
            END
        ) AS Inprogress,
        SUM(
            CASE
                WHEN SM.StatusTitle = 'Completed' THEN 1
                ELSE 0
            END
        ) AS Completed,
        SUM(
            CASE
                WHEN SM.StatusTitle = 'Rejected' THEN 1
                ELSE 0
            END
        ) AS Rejected
    FROM EnterpriseApprovalUser.EmployeeSalary_AnuragChandra ES
    INNER JOIN EnterpriseApprovalUser.EmployeeMaster_AnuragChandra PN
        ON ES.PlannerEmployeeMasterId = PN.EmployeeMasterId
    INNER JOIN EnterpriseApprovalUser.StatusMaster_AnuragChandra SM
        ON ES.Status = SM.StatusMasterId
    GROUP BY
        PN.EmployeeName,
        ES.PlanningYear;
END;
GO

-- TASK 3
-- ApproverSummary - Stored Procedure

CREATE OR ALTER PROCEDURE EnterpriseApprovalUser.uspGetApproverSummary_AnuragChandra
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        AN.EmployeeName AS ApproverName,
        COUNT(*) AS TotalCount,
        SUM(
            CASE
                WHEN AT.IsApproved = 0 AND AT.IsRejected = 0
                THEN 1
                ELSE 0
            END
        ) AS PendingCount,
        SUM(
            CASE
                WHEN AT.IsApproved = 1 OR AT.IsRejected = 1
                THEN 1
                ELSE 0
            END
        ) AS RespondedCount
    FROM EnterpriseApprovalUser.ApprovalTask_AnuragChandra AT
    INNER JOIN EnterpriseApprovalUser.EmployeeMaster_AnuragChandra AN
        ON AT.ApproverEmployeeMasterId = AN.EmployeeMasterId
    GROUP BY
        AN.EmployeeName;
END;
GO

-- TASK 4
-- List of Roles filter by planning year - Stored Procedure

CREATE OR ALTER PROCEDURE EnterpriseApprovalUser.uspGetUserRoles_AnuragChandra
    @PlanningYear INT
AS
BEGIN
    SET NOCOUNT ON;
    WITH ActiveAssociates AS
    (
        SELECT
            ES.EmployeeMasterId,
            ES.PlanningYear,
            ES.ManagerEmployeeMasterId,
            ES.LocalHREmployeeMasterId,
            ES.PlannerEmployeeMasterId
        FROM EnterpriseApprovalUser.EmployeeSalary_AnuragChandra ES
        INNER JOIN EnterpriseApprovalUser.EmployeeMaster_AnuragChandra EA
            ON ES.EmployeeMasterId = EA.EmployeeMasterId
        WHERE EA.IsActive = 1
          AND ES.PlanningYear = @PlanningYear
    ),

    RoleAssignments AS
    (
        SELECT
            AA.ManagerEmployeeMasterId AS EmployeeMasterId,
            AA.PlanningYear,
            'Manager' AS Role
        FROM ActiveAssociates AA

        UNION

        SELECT
            AA.LocalHREmployeeMasterId,
            AA.PlanningYear,
            'LocalHR'
        FROM ActiveAssociates AA

        UNION

        SELECT
            AA.PlannerEmployeeMasterId,
            AA.PlanningYear,
            'Planner'
        FROM ActiveAssociates AA
    )
    SELECT
        U.EmployeeName AS UserName,
        R.PlanningYear,
        R.Role
    FROM RoleAssignments R
    INNER JOIN EnterpriseApprovalUser.EmployeeMaster_AnuragChandra U
        ON R.EmployeeMasterId = U.EmployeeMasterId;
END;
GO