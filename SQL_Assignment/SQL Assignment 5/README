# SQL Assignment 5.

Name - Anurag Chandra
Technical - AFDP 2026 Path 2 

## TASK 1

### Error Test
![iamge](/SQL_Assignment/SQL_Screenshots/ErrorCatch.png)

A duplicate AttributeName was inserted within the same BusinessUnit, intentionally violating the unique constraint. The CATCH block successfully captured the SQL Server error information and returned it through the output parameters.

## TASK 2

### Why must both UPDATE statements be in the same transaction?What would happen if the server crashed between them without a transaction?

Both updates represent one logical business operation. If the server crashed after changing the BusinessUnitId but before resetting the CustomerLocationId, the database would contain inconsistent data where Attributes belong to the new Business Unit but still reference Customer Locations from the previous one. A transaction guarantees that either both updates succeed or both are rolled back.

## TASK 3

### SAVEPOINT vs Full ROLLBACK

A full ROLLBACK TRANSACTION cancels the entire transaction and resets @@TRANCOUNT to zero.

ROLLBACK TRANSACTION SavePointName rolls back only to the specified savepoint without ending the transaction, allowing subsequent statements to continue.

### Limitations

* Savepoints cannot be committed independently.
* They do not survive distributed transactions.
* They exist only within the current transaction.

## TASK 4

### ACID PROPERTIES

1. Atomicity

Atomicity means a transaction is treated as a single unit of work.
Either every statement succeeds, or all changes are rolled back.

Example:
Suppose we transfer Attributes from Business Unit 1 to Business Unit 2.

Step 1:
UPDATE Attribute_AnuragChandra
SET BusinessUnitId = 2

Step 2:
UPDATE Attribute_AnuragChandra
SET CustomerLocationId = NULL

If the second UPDATE fails, SQL Server rolls back the first UPDATE as well.
No partial transfer occurs.

2. Consistency

Consistency means every transaction leaves the database in a valid state.

Example:
BusinessUnitId must always reference an existing Business Unit.

Trying to insert

BusinessUnitId = 999

fails because of the Foreign Key constraint.

The database remains consistent.

3. Isolation

Isolation means one transaction should not interfere with another transaction.

Example:

User A updates an Attribute but has not committed.

User B should not see the uncommitted value (except under READ UNCOMMITTED).

Different isolation levels control this behaviour.

4. Durability

Durability means once a transaction is committed, the data is permanently saved.
Example:
If
UPDATE Attribute_AnuragChandra
SET IsActive = 0
is committed,
even if SQL Server crashes immediately afterwards,
the committed data is recovered from the transaction log.

### Dirty Read, Non-Repeatable Read and Phantom Read
Dirty Read – Reading uncommitted data from another transaction.
Non-Repeatable Read – Reading the same row twice and receiving different values because another transaction modified it.
Phantom Read – Re-executing the same query and seeing additional rows inserted by another transaction.

### Isolation Level Comparison

| Isolation Level | Dirty Reads | Non-Repeatable Reads | Phantom Reads |
| :--- | :--- | :--- | :--- |
| **Read Uncommitted** | Allowed | Allowed | Allowed |
| **Read Committed** | Prevented | Allowed | Allowed |
| **Repeatable Read** | Prevented | Prevented | Allowed |
| **Serializable** | Prevented | Prevented | Prevented |
| **Snapshot** | Prevented | Prevented | Prevented *(using row versioning)* |

### Why is SERIALIZABLE the strictest?

SERIALIZABLE locks both rows and key ranges, preventing inserts, updates, and phantom rows. While it provides the highest consistency, it also increases locking, blocking, and reduces concurrency, making it the slowest isolation level.

### Practical default for OLTP systems

Most SQL Server OLTP applications use READ COMMITTED. Many production databases also enable READ COMMITTED SNAPSHOT (RCSI) to reduce blocking while still preventing dirty reads.

### Why use XACT_ABORT ON?

SET XACT_ABORT ON ensures that if any runtime error occurs inside a transaction, SQL Server automatically rolls back the entire transaction. This helps prevent partially committed data and works well together with TRY...CATCH for reliable error handling.

## TASK 5

### Bug A – UPDATE without WHERE

An UPDATE statement was intentionally executed without a WHERE clause.

* Result

Every row in the Attribute table was updated, demonstrating one of the most common SQL mistakes.

#### Prevention
* Execute a SELECT first to verify affected rows.
* Use transactions while testing.
* Review execution plans and affected row counts before committing.
* Always verify the WHERE clause before execution.

### Bug B – Foreign Key Violation

An INSERT statement was executed using an invalid BusinessUnitId, violating the foreign key constraint.

* Result

SQL Server raised a foreign key constraint error.

The INSERT was then wrapped inside a TRY...CATCH block, successfully capturing the error number, message, procedure, and line number for reporting.

## TASK 6

### Observation

### Without indexes
![image](/SQL_Assignment/SQL_Screenshots/Woindex.png)

### With indexes
![image](/SQL_Assignment/SQL_Screenshots/windex.png)

The execution plan showed a scan on the Attribute table because the predicate LIKE '%Global%' is not searchable using an index seek. SQL Server scanned the available rows before joining with the BusinessUnit table.

## TASK 7

### Why didn't the clustered index help?

The clustered index is built on AttributeId, while the query filters on AttributeName. Since the search condition is unrelated to the clustered key and begins with a leading wildcard, SQL Server cannot efficiently seek into the clustered index.

### What is a Covering Index?

A covering index contains every column required by a query, allowing SQL Server to satisfy the query directly from the index without performing additional lookups to the base table.

## TASK 8

### Without Optmization
![image](/SQL_Assignment/SQL_Screenshots/withoutopt.png)

### With Optimization
![image](/SQL_Assignment/SQL_Screenshots/withopt.png)

### Why are functions in WHERE clauses bad?

Applying functions directly to indexed columns prevents SQL Server from using index seeks because every row must first be processed by the function before comparison.

### What does SARGable mean?

A SARGable predicate is one that allows SQL Server to efficiently search an index.

## TASK 9

### Using sp_executesql
![image](/SQL_Assignment/SQL_Screenshots/spexecsql.png)

### What is SQL Injection?

SQL Injection is an attack where malicious SQL code is supplied as input and executed by the database.

### Why is the first version vulnerable?

String concatenation directly inserts user input into the SQL statement, allowing attackers to modify the query.

### Why is sp_executesql safer?

sp_executesql separates user data from SQL code by passing values as parameters. SQL Server treats parameter values as data instead of executable SQL.

### Can sp_executesql fully prevent SQL Injection?

No.
Parameterization protects only data values. Table names and column names cannot be parameterized and therefore should be validated or safely wrapped using QUOTENAME() before constructing the dynamic SQL statement.