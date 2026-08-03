# SQL Assignment 4.

Name - Anurag Chandra
Technical - AFDP 2026 Path 2 

## TASK 1

### Why use nullable parameters instead of separate stored procedures?

Using nullable parameters allows a single stored procedure to handle multiple filtering scenarios. This reduces code duplication, simplifies maintenance, and ensures that any future changes only need to be made in one place instead of multiple procedures.

## TASK 2

### Why return an empty result instead of an error?

Returning an empty result set is appropriate because requesting a non-existent record is a valid scenario and not necessarily an application error. It allows the calling application to determine how to handle the absence of data.

### When would raising an error be appropriate?

Errors should be raised only for exceptional situations such as invalid input, constraint violations, or unexpected database failures.

## TASK 3

### Why validate inside the stored procedure?

Stored procedure validation provides clear, user-friendly error messages before SQL Server constraints are reached. Constraints only enforce database rules and cannot validate business logic such as empty strings or provide customized messages.

Examples include:

* Empty Attribute Name
* Invalid Business Unit selection
* Business-specific validation rules

## TASK 4

### Why use soft delete?

Soft deletion preserves historical data, allows recovery of deleted records, and maintains relationships with other tables.

Trade-offs

* Requires filtering inactive records in queries.
* Database size continues to grow.
* Slightly increases query complexity.

## TASK 5

### Why separate stored procedures?

Each lookup has a different purpose, filtering logic, and future maintenance requirements. Separate procedures improve readability, security, and maintainability while avoiding unnecessary conditional logic inside one large procedure.

## TASK 6

### Why not use Dynamic SQL?

The sorting options are predefined and limited. A CASE expression inside ORDER BY is simpler, safer, and easier to maintain.

### When IS dynamic SQL appropriate?

Dynamic SQL should only be used when object names, optional columns, or query structure must change dynamically.

## TASK 7

### Why is server-side pagination important?

Server-side pagination returns only the required rows, reducing network traffic, memory usage, and query execution time.

### What happens to performance if you return all rows and paginate in the application?

Returning all rows and paging inside the application wastes database resources and becomes increasingly inefficient as the table grows.

## TASK 8

### Could this be done without window functions? How would the query differ?

Yes, but it would require multiple subqueries, self-joins, correlated queries, or temporary tables.

### What are the performance implications?

Window functions are simpler, more readable, and generally provide better performance because SQL Server computes the results in a single pass.

## TASK 9

### Scalar Function vs Inline Table-Valued Function

* A scalar function returns a single value for each row.

* An inline table-valued function returns an entire table and behaves similarly to a parameterized view.

### When would you choose each?

Scalar functions are suitable for calculations, while inline TVFs are preferred when multiple rows or columns are required.

## TASK 10

### CROSS APPLY vs OUTER APPLY

* CROSS APPLY returns only rows where the function produces results.
* OUTER APPLY returns all rows from the outer table, even when the function returns no rows.

### Function vs View

* A view cannot accept parameters.
* A function accepts parameters, making it reusable for different input values.

## TASK 11

### Inline TVF vs Multi-Statement TVF. Why is MSTVF generally slower (no statistics, fixed-row estimate)? 

Inline TVFs contain a single SELECT statement and allow SQL Server to optimize the execution plan efficiently.

Multi-statement TVFs use a table variable internally, have no statistics, and often receive a fixed row estimate, making them slower.

### When is the multi-statement form actually justified vs rewriting as a single SELECT in an inline TVF?

Multi-statement TVFs are justified when multiple INSERT, UPDATE, or procedural steps are required.

## TASK 12

### #Temp Table vs Table Variable. When would you use each?

#Temp Table

Stored in tempdb
Supports indexes and statistics
Better for large datasets
Suitable for complex processing

@Table Variable

Also stored in tempdb internally
Optimized for small datasets
Limited statistics
Better for small temporary results

### What about ##global temp tables?
##Global Temp Table

Visible to every session until the creating session ends and no other session is using it.

## TASK 13

### Cursor
![image](/SQL_Assignment/SQL_Screenshots/Cursor.png)

### Set Based
![image](/SQL_Assignment/SQL_Screenshots/SetBased.png)

### Why are cursors slow?

Cursors process one row at a time, causing repeated context switching, increased locking, logging overhead, and poor scalability.

### What are the rare legitimate uses of cursors

Legitimate cursor use cases
* Calling another stored procedure once per row
* Administrative scripts
* Sequential processing where each row depends on the previous one

### What does LOCAL FAST_FORWARD do differently from a default cursor?

LOCAL FAST_FORWARD

Creates a read-only, forward-only cursor optimized for performance with minimal overhead.

### What is the SQL Server engine's set-based philosophy and why should the cursor always be your last resort?

SQL Server philosophy

SQL Server is designed for set-based operations. Whenever possible, operations should be performed on entire sets of rows instead of processing rows individually. Cursors should be considered only as a last resort.

## TASK 14

### INSERTED and DELETED pseudo-tables. How do they behave for INSERT, UPDATE, and DELETE?
* INSERT: Only INSERTED contains rows.
* DELETE: Only DELETED contains rows.
* UPDATE: DELETED contains old values and INSERTED contains new values.


### What is the difference between AFTER and INSTEAD OF triggers?

AFTER vs INSTEAD OF Trigger

* AFTER Trigger

Executes after the original DML statement successfully completes.

* INSTEAD OF Trigger

Replaces the original operation and allows custom logic before modifying the underlying table.

### Why are triggers powerful but risky?

Triggers automatically enforce business rules and auditing without application changes.

However, they can introduce hidden logic, recursive or cascading execution, additional locking, and performance overhead, making debugging and maintenance more difficult in production systems.