-- SchemaObjects.sql
-- Contains CREATE TABLE, ALTER TABLE, constraints, and CREATE SCHEMA statements

-- Tables
CREATE TABLE BusinessUnit_AnuragChandra(
    BusinessUnitId INTEGER IDENTITY(1,1) PRIMARY KEY,
    BusinessUnitName NVARCHAR(100),
    IsActive BIT,
    CreatedOn DATETIME2,
    CreatedBy NVARCHAR(100)
);

CREATE TABLE CustomerLocation_AnuragChandra(
    CustomerLocationId INTEGER IDENTITY(1,1) PRIMARY KEY,
    CustomerLocationName NVARCHAR(100),
    BusinessUnitId INTEGER REFERENCES BusinessUnit_AnuragChandra(BusinessUnitId),
    IsActive BIT,
    CreatedOn DATETIME2,
    CreatedBy NVARCHAR(100)
);

CREATE TABLE Company_AnuragChandra(
    CompanyId INTEGER IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(100),
    IsActive BIT,
    CreatedOn DATETIME2,
    CreatedBy NVARCHAR(100)
);

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

CREATE TABLE ParentDemo
(
    ParentId INT PRIMARY KEY
);

CREATE TABLE ChildDemo
(
    ChildId INT IDENTITY(1,1) PRIMARY KEY,
    ParentId INT REFERENCES ParentDemo(ParentId)
);

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
    ChangedOn DATETIME2 DEFAULT GETDATE()
);

-- Constraints and defaults
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

ALTER TABLE Attribute_AnuragChandra
ALTER COLUMN CustomerLocationId INT NULL;

-- Schemas
CREATE SCHEMA Reporting_AnuragChandra;

CREATE SCHEMA Audit_AnuragChandra;
