/*
This allows queries to execute set operations (UNION, INTERSECT, EXCEPT) on the results of two or more queries. 
The queries must have the same number of columns and compatible data types in each column.
It allows queries to be combined according to set operation schematics
It consist of union, union all, intersect, intersect all, except, except all
*/

--                      UNION AND UNION ALL
-- UNION returns all rows from A and B with duplicates removed while UNION ALL returns all rows with duplicates preerved
SELECT [1,2,3];

SELECT UNNEST ([1,1,1,3,4])
UNION
SELECT UNNEST ([1,1,2,3,4]);

SELECT UNNEST ([1,1,1,3,4])
UNION ALL
SELECT UNNEST ([1,1,2,3,4]);

--                     INTERSECT AND INTERSECT ALL  
-- Intersect returns only the rows that are present in both A and B with duplicates removed. Intersect all returns rows common to both A and B with duplicates preserved.

SELECT UNNEST ([1,1,1,3,4])
INTERSECT
SELECT UNNEST ([1,1,2,3,4]);

SELECT UNNEST ([1,1,1,3,4])
INTERSECT ALL
SELECT UNNEST ([1,1,2,3,4]);

--                     EXCEPT AND EXCEPT ALL
-- Except returns only the rows that are present in A but not in B with duplicates removed. Except all returns rows in A but not in B with duplicates preserved.

SELECT UNNEST ([1,1,1,3,4,6])
EXCEPT
SELECT UNNEST ([1,1,2,3,4]);

SELECT UNNEST ([1,1,1,3,4,6])
EXCEPT ALL
SELECT UNNEST ([1,1,2,3,4]);

                                                            -- FINAL EXAMPLE

CREATE OR REPLACE TEMP TABLE job_2023 AS
SELECT 
    * EXCLUDE(job_id, job_posted_date)
FROM 
    job_postings_fact
WHERE 
    EXTRACT(YEAR FROM job_posted_date) = 2023;

-- SELECT * FROM job_2023;

CREATE OR REPLACE TEMP TABLE job_2024 AS
SELECT 
    * EXCLUDE(job_id, job_posted_date)
FROM 
    job_postings_fact
WHERE 
    EXTRACT(YEAR FROM job_posted_date) = 2024;
    
-- SELECT * FROM job_2024;

--           Which unique job postings appeared in either 2023 or 2024?

SELECT 
    'job_2023' AS table_name,
    COUNT(*) AS row_count
FROM 
    job_2023
UNION
SELECT 
    'job_2024' AS table_name,
    COUNT(*) AS row_count
FROM 
    job_2024;

SELECT * FROM job_2023
UNION
SELECT * FROM job_2024;


--           Which job postings appeared across both years, counting duplicates?

SELECT * FROM job_2023
UNION ALL
SELECT * FROM job_2024;


--             Which job postings appeared in both 2023 and 2024?

SELECT * FROM job_2023
INTERSECT
SELECT * FROM job_2024;


--             Which job postings appeared in both years preserving duplicate counts?

SELECT * FROM job_2023
INTERSECT ALL
SELECT * FROM job_2024;


--             Which job postings appeared in 2023 but not in 2024?

SELECT * FROM job_2023
EXCEPT 
SELECT * FROM job_2024;


--               Which job postings appeared more times in 2023 than in 2024, one-for-one?

SELECT * FROM job_2023
EXCEPT ALL 
SELECT * FROM job_2024;
