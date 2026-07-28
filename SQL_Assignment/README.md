## SQL Assignment.

Name - Anurag Chandra
Technical - AFDP 2026 Path 2 

## TABLES CREATED

* TABLE: BusinessUnit_AnuragChandra
* TABLE: CustomerLocation_AnuragChandra
* TABLE: Company_AnuragChandra
* TABLE: Attribute_AnuragChandra

## TASK 1

We will not create a separate Database for the assignments but we will create tables inside TrainingDB only.

## TASK 2

### Tables we have created and reasons for selecting the specific datatype

### Table: BusinessUnit_AnuragChandra

Data Type Choices:
- BusinessUnitId: INT PRIMARY KEY IDENTITY because the number of business units is expected to remain well within the INT range. BIGINT would consume more storage without providing practical benefit.
- BusinessUnitName: NVARCHAR(100) to support Unicode characters, allowing names in multiple languages.
- IsActive: BIT because it stores only True/False values.
- CreatedOn: DATETIME2 because it provides better precision and a larger date range than DATETIME.
- CreatedBy: NVARCHAR(100) to support usernames containing Unicode characters.

* Using VARCHAR instead of NVARCHAR could prevent storing multilingual names correctly.
* Using BIGINT instead of INT would increase storage requirements unnecessarily.
* Using DATETIME instead of DATETIME2 would reduce precision and provide a smaller supported date range.

### Table: CustomerLocation_AnuragChandra

Data Type Choices:
- CustomerLocationId: INT IDENTITY for an efficient auto-generated primary key.
- CustomerLocationName: NVARCHAR(100) to support international location names.
- BusinessUnitId: INT because it references BusinessUnit.BusinessUnitId.
- IsActive: BIT for active/inactive status.
- CreatedOn: DATETIME2 for precise timestamp storage.
- CreatedBy: NVARCHAR(100) for Unicode usernames.

* The foreign key must use the same data type as the referenced primary key. Using a different numeric type would prevent the foreign key relationship.

### Table: Company_AnuragChandra

Data Type Choices:
- CompanyId: INT IDENTITY for an efficient auto-generated primary key.
- CompanyName: NVARCHAR(100) to support Unicode company names.
- IsActive: BIT for active/inactive status.
- CreatedOn: DATETIME2 for precise timestamp storage.
- CreatedBy: NVARCHAR(100) for Unicode usernames.

* The primary key uses INT for efficiency, while NVARCHAR supports multilingual company names.

### Table: Attribute_AnuragChandra

Data Type Choices:
- AttributeId: INT IDENTITY for an efficient auto-generated primary key.
- AttributeName: NVARCHAR(100) to support Unicode attribute names.
- BusinessUnitId, CustomerLocationId, CompanyId: INT to match their referenced primary keys.
- IsActive: BIT for active/inactive status.
- CreatedOn, UpdatedOn: DATETIME2 for precise timestamp storage.
- CreatedBy, UpdatedBy: NVARCHAR(100) for Unicode usernames.

* Foreign keys use INT to match the referenced primary keys, and DATETIME2 provides higher precision for audit fields.

## TASK 3 : Adding Constraints

Required Fields:
NOT NULL is used for mandatory business and audit fields.
UpdatedOn and UpdatedBy are optional because they are populated only after a record is updated.

### BusinessUnit
* BusinessUnitName, IsActive, CreatedOn, and CreatedBy are marked as NOT NULL because they are required to create a valid business unit record.
* IsActive defaults to 1 so new business units are active by default.
* CreatedOn defaults to GETDATE() to automatically store the record creation time.
* A CHECK constraint ensures CreatedOn cannot be a future date.

### CustomerLocation
* CustomerLocationName, BusinessUnitId, IsActive, CreatedOn, and CreatedBy are marked as NOT NULL because they are required for a valid customer location.
* IsActive defaults to 1 for newly created records.
* CreatedOn defaults to GETDATE() to record the creation timestamp automatically.
* A CHECK constraint ensures CreatedOn is not greater than the current date.

### Company
* CompanyName, IsActive, CreatedOn, and CreatedBy are marked as NOT NULL because they are mandatory fields.
* IsActive defaults to 1 so companies are active by default.
* CreatedOn defaults to GETDATE() to capture the creation timestamp.
* A CHECK constraint prevents future dates from being stored in CreatedOn.

### Attribute
* AttributeName, BusinessUnitId, CustomerLocationId, CompanyId, IsActive, CreatedOn, and CreatedBy are marked as NOT NULL because they are required to uniquely identify and track an attribute.
* UpdatedOn and UpdatedBy are kept nullable since they are populated only after a record is updated.
* IsActive defaults to 1 and CreatedOn defaults to GETDATE().
* A CHECK constraint ensures CreatedOn is not a future date.
* A composite UNIQUE constraint on (BusinessUnitId, AttributeName) prevents duplicate attribute names within the same business unit while allowing the same attribute name in different business units.

### Checking constraints

    INSERT INTO BusinessUnit_AnuragChandra
    (BusinessUnitName, IsActive, CreatedOn)
    VALUES
    ('Paper', 1, GETDATE());

Cannot insert the value NULL into column 'CreatedBy', table 'TrainingDB.EnterpriseApprovalUser.BusinessUnit_AnuragChandra'; column does not allow nulls. INSERT fails.

    INSERT INTO BusinessUnit_AnuragChandra
    (BusinessUnitName, CreatedBy)
    VALUES
    ('Paper', 'Anurag');

All other data gets filled with default values.

    INSERT INTO BusinessUnit_AnuragChandra
    (BusinessUnitName, IsActive, CreatedOn, CreatedBy)
    VALUES
    ('Paper', 1, '2099-01-01', 'Anurag');

The INSERT statement conflicted with the CHECK constraint "Check_BusinessUnit_CreatedOn". The conflict occurred in database "TrainingDB", table "EnterpriseApprovalUser.BusinessUnit_AnuragChandra", column 'CreatedOn'.

    INSERT INTO BusinessUnit_AnuragChandra
    (BusinessUnitName, CreatedBy)
    VALUES
    ('IT', 'Anurag');

    INSERT INTO CustomerLocation_AnuragChandra
    (CustomerLocationName, BusinessUnitId, CreatedBy)
    VALUES
    ('Ahmedabad', 1, 'Anurag');

The INSERT statement conflicted with the FOREIGN KEY constraint "FK__CustomerL__Busin__1CC8C9BC". The conflict occurred in database "TrainingDB", table "EnterpriseApprovalUser.BusinessUnit_AnuragChandra", column 'BusinessUnitId'.

    INSERT INTO CustomerLocation_AnuragChandra
    (CustomerLocationName, BusinessUnitId, CreatedBy)
    VALUES
    ('Ahmedabad', 3, 'Anurag');

    INSERT INTO Company_AnuragChandra
    (CompanyName, CreatedBy)
    VALUES
    ('Amicus', 'Anurag');

Insert below row two times to check unique constraints

    INSERT INTO Attribute_AnuragChandra
    (AttributeName, BusinessUnitId, CustomerLocationId, CompanyId, CreatedBy)
    VALUES
    ('Color', 3, 3, 1, 'Anurag');

Violation of UNIQUE KEY constraint 'Unique_Attribute_BusinessUnit_AttributeName'. Cannot insert duplicate key in object 'EnterpriseApprovalUser.Attribute_AnuragChandra'. The duplicate key value is (3, Color).

    INSERT INTO Attribute_AnuragChandra
    (AttributeName, BusinessUnitId, CustomerLocationId, CompanyId, CreatedBy)
    VALUES
    ('Size', 999, 999, 999, 'Anurag');

The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Attribute__Busin__377CBFF8". The conflict occurred in database "TrainingDB", table "EnterpriseApprovalUser.BusinessUnit_AnuragChandra", column 'BusinessUnitId'.

## TASK 4 : Inserting values into the table

### Why is diverse test data important?

Using diverse test data helps verify different scenarios such as active and inactive records, multiple locations per business unit, business units with no locations, different companies, creators, and dates. Uniform data may hide bugs related to filtering, joins, sorting, grouping, null handling, and business rules, leading to issues that only appear in real-world usage.

## TASK 5 : Update and verify

### Before update query
![image](/SQL_Assignment/SQL_Screenshots/BeforeUpdateQuery.png)


### update and verification query

        UPDATE Attribute_AnuragChandra
        SET IsActive = 0
        WHERE BusinessUnitId = 2;


        SELECT * FROM Attribute_AnuragChandra
        WHERE BusinessUnitId = 2;

### After update
![image](/SQL_Assignment/SQL_Screenshots/Afterupdate.png)

### Why is the WHERE clause important?

The `WHERE` clause limits the update to the intended records. Without it, every row in the table would be updated, potentially causing data loss and affecting all attributes instead of only the selected Business Unit.

## TASK 6

### Preview of the rows that will be deleted 

    SELECT * FROM CustomerLocation_AnuragChandra AS CL
    LEFT JOIN Attribute_AnuragChandra AS A
    ON CL.CustomerLocationId = A.CustomerLocationId
    WHERE A.CustomerLocationId IS NULL;

![image](/SQL_Assignment/SQL_Screenshots/Delete_preview.png)

### Delete Query

        DELETE CL
        FROM CustomerLocation_AnuragChandra AS CL
        LEFT JOIN Attribute_AnuragChandra AS A
            ON CL.CustomerLocationId = A.CustomerLocationId
        WHERE A.CustomerLocationId IS NULL;

result after delete query
![image](/SQL_Assignment/SQL_Screenshots/Delete_result.png)

## TASK 7

### Declaring and inserting into staging table

    --Create a staging table

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

    -- declare a mergeaudit table to display what actions have been performed during merging

    DECLARE @MergeAudit TABLE
    (
        ActionPerformed NVARCHAR(10),
        CompanyName NVARCHAR(100)
    );

### Declaring mergeaudit table

    DECLARE @MergeAudit TABLE
    (
        ActionPerformed NVARCHAR(10),
        CompanyName NVARCHAR(100)
    );

### merge audit table and after merging reslut

![image](/SQL_Assignment/SQL_Screenshots/merge.png)

### Why is MERGE useful compared to writing separate INSERT and UPDATE statements? What are common pitfalls of MERGE (e.g., the HALLOWEEN problem, missing semicolon)?

MERGE simplifies data synchronization by combining INSERT and UPDATE operations into a single statement. This reduces code duplication and improves maintainability. 

Common pitfalls include requiring a semicolon before MERGE in some contexts, ensuring the matching condition uniquely identifies rows, and being aware of historical SQL Server issues such as the Halloween problem and concurrency-related bugs in complex MERGE operations.

## TASK 8 : Filter Queries

### BETWEEN

    SELECT *
    FROM Attribute_AnuragChandra
    WHERE CreatedOn BETWEEN '2025-01-01' AND '2025-12-31';

![image](/SQL_Assignment/SQL_Screenshots/BETWEEN.png)

### IN 

    SELECT *
    FROM Attribute_AnuragChandra
    WHERE BusinessUnitId IN (1, 2, 3);
![image](/SQL_Assignment/SQL_Screenshots/IN.png)

### NOT IN

    SELECT *
    FROM Attribute_AnuragChandra
    WHERE BusinessUnitId NOT IN (1, 2, 3);
![image](/SQL_Assignment/SQL_Screenshots/NOTIN.png)

### Using left join + is null

    SELECT A.*
    FROM Attribute_AnuragChandra A
    LEFT JOIN
    (
        VALUES (1), (2), (3)
    ) AS B(BusinessUnitId)
    ON A.BusinessUnitId = B.BusinessUnitId
    WHERE B.BusinessUnitId IS NULL;
![image](/SQL_Assignment/SQL_Screenshots/Leftnull.png)


### Why can NOT IN behave incorrectly when the inner list contains NULLs?

* NOT IN can return unexpected results if the list contains NULL because comparisons with NULL evaluate to UNKNOWN. 
* NOT EXISTS is generally safer as it is not affected by NULL values.

### LIKE

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

![image](/SQL_Assignment/SQL_Screenshots/LIKE.png)


### AND/OR/NOT

    SELECT *
    FROM Attribute_AnuragChandra
    WHERE
    (
        BusinessUnitId = 1
        OR BusinessUnitId = 2
    )
    AND IsActive = 1
    AND NOT CreatedBy = 'Admin';

![image](/SQL_Assignment/SQL_Screenshots/ANDORNOT.png)

### Why are parentheses important when mixing AND/OR?

Parentheses control the order of evaluation when combining AND and OR conditions. Without them, SQL follows operator precedence, which can produce unintended results and return incorrect records.

## TASK 9

### Top 10

    SELECT TOP 10 *
    FROM Attribute_AnuragChandra
    ORDER BY CreatedOn DESC;

![image](/SQL_Assignment/SQL_Screenshots/TOP10.png)

### Top 5 with ties

first update createdon time of other rows to match

    UPDATE Attribute_AnuragChandra
    SET CreatedOn = '2026-03-29 11:33:20.5100000'
    WHERE AttributeId in (7,8,9);

then query for top 5 with ties

    SELECT TOP 5 WITH TIES *
    FROM Attribute_AnuragChandra
    ORDER BY CreatedOn DESC;

![image](/SQL_Assignment/SQL_Screenshots/TOP5TIES.png)

### OFFSET 10 rows FETCH NEXT 10 rows

    SELECT *
    FROM Attribute_AnuragChandra
    ORDER BY AttributeName
    OFFSET 10 ROWS
    FETCH NEXT 10 ROWS ONLY;

![image](/SQL_Assignment/SQL_Screenshots/offset_fetch.png)

### Parameterized Paging

    DECLARE @PageNumber INT = 2;
    DECLARE @PageSize INT = 10;

    SELECT *
    FROM Attribute_AnuragChandra
    ORDER BY AttributeName
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

![image](/SQL_Assignment/SQL_Screenshots/offset_fetch.png)

### TOP vs OFFSET-FETCH

- `TOP` returns the first specified number of rows from the result set.
- `OFFSET-FETCH` skips a specified number of rows and then returns the next set of rows, making it suitable for paging through large result sets.
- `OFFSET-FETCH` is required for true pagination because it allows retrieving any page of data without returning all previous rows.

## TASK 10

### Total Number of Attributes per Business Unit
![image](/SQL_Assignment/SQL_Screenshots/Task10.png)

### Average Number of Attributes per Company
![image](/SQL_Assignment/SQL_Screenshots/TAsk102.png)

### Business Units with More Than 3 Active Attributes
![image](/SQL_Assignment/SQL_Screenshots/Task103.png)

### Company with the Maximum Number of Attributes
![image](/SQL_Assignment/SQL_Screenshots/Task104.png)

### Company with the Minimum Number of Attributes
![image](/SQL_Assignment/SQL_Screenshots/Task105.png)

### WHERE vs HAVING

- `WHERE` filters individual rows before grouping.
- `HAVING` filters groups after the `GROUP BY` operation.
- Aggregate functions such as `COUNT()`, `SUM()`, and `AVG()` cannot be used in `WHERE` because the groups and aggregate values have not been calculated yet. They can only be used in `HAVING`.

## Task 11

### Using LIKE
![image](/SQL_Assignment/SQL_Screenshots/Task111.png)

### Display AttributeName in UPPER case and first 10 characters
![image](/SQL_Assignment/SQL_Screenshots/Task112.png)

### AttributeName with Hyphen

![image](/SQL_Assignment/SQL_Screenshots/Task113.png)

### Show only longer than 10 characters
![image](/SQL_Assignment/SQL_Screenshots/Task114.png)

### String Functions

- `LIKE` and `CHARINDEX` are used to search for text within a string.
- `UPPER` converts text to uppercase.
- `SUBSTRING` extracts a specified portion of a string.
- `REPLACE` substitutes one string with another.
- `LEN` returns the number of characters in a string and can be used for filtering based on string length.

## TASK 12

### Last 6 months
![image](/SQL_Assignment/SQL_Screenshots/Task121.png)

### Days since created
![image](/SQL_Assignment/SQL_Screenshots/Task122.png)

### Formatted Date
![image](/SQL_Assignment/SQL_Screenshots/Task123.png)

### Group Attributes by the month they were created
![image](/SQL_Assignment/SQL_Screenshots/Task124.png)

### FORMAT vs CONVERT

- `FORMAT` provides flexible, custom date formats and is easier to read, but it is slower because it uses the .NET formatting engine.
- `CONVERT` is faster and uses predefined SQL Server style codes, making it a better choice for large queries and production environments.
- Use `FORMAT` when custom formatting is required, and `CONVERT` when performance is more important.

## TASK 13

### Display Status (Active / Inactive)

![image](/SQL_Assignment/SQL_Screenshots/Task131.png)

### Display Age Category

![image](/SQL_Assignment/SQL_Screenshots/Task132.png)

### Display Data Completeness
![image](/SQL_Assignment/SQL_Screenshots/Task133.png)

### CASE Expression

The `CASE` expression is used to apply conditional logic in SQL queries. It evaluates conditions and returns different values based on the result, making it useful for categorizing, labeling, and formatting query output without modifying the underlying data.

## TASK 14

### Pivot query to achieve the desired result using count(AttributeId) and IsActive cast to set of known values

![image](/SQL_Assignment/SQL_Screenshots//Pivot.png)

### PIVOT

The `PIVOT` operator rotates row values into columns and applies an aggregate function such as `COUNT`, `SUM`, or `AVG`. In this query, the values of `IsActive` (`1` and `0`) become the `Active` and `Inactive` columns.

The same result can be achieved using `CASE` expressions with `GROUP BY`. 
        
        Without Pivot

        select 
            BusinessUnitName, 
            SUM(CASE WHEN A.IsActive = 1 THEN 1 ELSE 0 END) AS Active,
            SUM(CASE WHEN A.IsActive = 0 THEN 1 ELSE 0 END) AS Inactive
            from Attribute_AnuragChandra A 
            join BusinessUnit_AnuragChandra B 
            on A.BusinessUnitId = B.BusinessUnitId 
        group by B.BusinessUnitId,BusinessUnitName
        order by BusinessUnitName;

For a small number of columns, `CASE + GROUP BY` is often simpler and easier to understand, while `PIVOT` becomes more useful when transforming multiple row values into columns.

## TASK 15

### Unpivot

![image](/SQL_Assignment/SQL_Screenshots/Unpivot.png)

### When is UNPIVOT useful?

The `UNPIVOT` operator converts columns into rows. It is useful when wide data needs to be reshaped into a normalized format for reporting, charting, importing into other systems, or further analysis. It makes it easier to work with tools that expect data in row-based rather than column-based format.

## TASK 16

### Cross apply with values
![image](/SQL_Assignment/SQL_Screenshots/Crossapply.png)

### CROSS APPLY with VALUES

`CROSS APPLY` with `VALUES` converts multiple values from a single row into multiple output rows, making it similar to `UNPIVOT`. It is useful when you want to create custom rows or calculated values (such as `Total`) without using the `UNPIVOT` operator. It is often preferred because it is simpler, more flexible, and allows expressions in the generated rows.
