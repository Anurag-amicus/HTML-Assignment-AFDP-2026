# SQL Assignment 3.

Name - Anurag Chandra
Technical - AFDP 2026 Path 2 

## TASK 1

### When does the difference between RANK() and DENSE_RANK() matter? Give a real-world example.
* RANK() skips the next rank after ties, while DENSE_RANK() does not.
* Use RANK() for competition rankings (e.g., sports).
* Use DENSE_RANK() when continuous ranking is needed (e.g., employee performance rankings).

### How does NTILE handle uneven division? What is this useful for?
* NTILE divides rows into nearly equal groups.
* If the rows cannot be divided equally, the first groups get one extra row.
* It is useful for quartiles, percentiles, customer segmentation, and reporting.

### What happens when LAG()/LEAD() reaches the first/last row? 
* LAG() returns NULL for the first row because there is no previous row.
* LEAD() returns NULL for the last row because there is no next row.

### How do you handle the resulting NULL?
* Use ISNULL() or COALESCE() to replace NULL with a default value if needed.

## TASK 2

### What is the difference between ROWS BETWEEN and RANGE BETWEEN? 
* ROWS BETWEEN uses a fixed number of physical rows.
* RANGE BETWEEN groups rows with the same ORDER BY value.

### When does it matter?
* ROWS is commonly used for running totals and moving averages.
* RANGE is useful when duplicate ORDER BY values should be treated together.

## TASK 3

### Why is ROW_NUMBER() + PIVOT a common pattern? 
* ROW_NUMBER() identifies the top N rows within each group.
* PIVOT converts those rows into columns for easy reporting.
* This pattern is commonly used for dashboard and summary reports.

### What alternative approaches exist?
* An alternative is using CASE expressions with GROUP BY instead of PIVOT.
