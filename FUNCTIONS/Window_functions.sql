/*                                                          Window Functions in SQL 
They are very important to data engineers because they allow to keep data modelling intact while performing and adding in advanced analysis.
They allow data engineers add context without destroying rows. pipelines need row-level data. 
They are three major types of window functions: Aggregate [COUNT(), SUM(), AVG(), MIN(), MAX()], 
Ranking [ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()] 
and Analytic [LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()].
SYNTAX: 
    SELECT 
        column1, 
        column2
        window_function() OVER                          
        (
            PARTITION BY column1 
            ORDER BY column2
        ) AS new_column
    FROM 
        table_name;
OVER(): 
    - It is a clause that defines a window or set of rows for the window function to operate on.
    - It allows you to perform calculations across a specified range of rows related to the current row.
    - It can be used with aggregate functions, ranking functions, and analytic functions.
PARTITION BY: 
    - It is an optional clause that divides the result set into partitions or groups based on one or more columns.
    - The window function is applied separately to each partition, and the results are calculated independently for each group.
    - If omitted, the entire result set is treated as a single partition.
*/

-- Count Rows with Aggregate only 

SELECT 
    COUNT(*)
FROM 
    job_postings_fact;

-- Count Rows with Window function

SELECT 
    job_id,
    job_title_short,
    company_id,
    COUNT(*) OVER() AS total_rows
FROM 
    job_postings_fact;

--                                       Rows with Window function and Partitioning

SELECT 
    job_id,
    job_title_short,
    company_id,
    COUNT(*) OVER(
        PARTITION BY company_id
        ) AS total_rows_per_company
FROM 
    job_postings_fact
LIMIT 20;

-- Find hourly salary 

SELECT 
    job_id,
    job_title_short,
    company_id,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
        ) AS avg_salary_per_job_title
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 20;

--                                          ORDER BY with Window Functions

SELECT 
    job_id,
    job_title_short,
    company_id,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
        ORDER BY salary_hour_avg DESC
        ) AS avg_salary_per_job_title
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 20;

-- Find hourly salary 

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
        ) AS rank_salary_per_job_title
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC,
    job_title_short
LIMIT 20;

-- Data engineer running average hoorly salary

SELECT 
    job_id,
    job_title_short,
    job_posted_date,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
        ) AS running_avg_salary_per_job_title
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL 
    AND 
    job_title_short = 'Data Engineer'
ORDER BY
    job_posted_date
LIMIT 20;


                                    --  ROW AND RANK WINDOW FUNCTIONS 

/* RANK() function assigns a unique rank to each row within a partition of a result set, based on the specified ORDER BY clause. 
If there are ties (i.e., rows with the same value in the ORDER BY column), they receive the same rank, and the next rank(s) will be skipped.   */

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
        ) AS rank_salary_per_hour
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
LIMIT 40;

-- ROW_NUMBER() function assigns a unique sequential integer to each row within a partition of a result set, based on the specified ORDER BY clause.

SELECT 
    *,
    ROW_NUMBER() OVER(
        ORDER BY job_posted_date
        ) AS row_number
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Engineer'
ORDER BY 
    job_posted_date
LIMIT 30;

/* DENSE_RANK() function is similar to RANK(), but it does not skip ranks in the case of ties. 
 Instead, it assigns the same rank to tied rows and continues with the next rank without gaps.*/

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER(
        ORDER BY salary_hour_avg DESC
        ) AS rank_salary_per_hour
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
LIMIT 40;


                                                --  ANALYTIC/NAVIGATION WINDOW FUNCTIONS
-- LAG() function allows you to access data from a previous row in the result set, based on the specified ORDER BY clause. 
-- It is often used for comparing values between consecutive rows.      
--  Time Based comparison of Company Salary with LAG() function

SELECT 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
        ) AS previous_salary_per_company,
    salary_year_avg - LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
        ) AS salary_difference_per_company
FROM
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
ORDER BY 
    company_id,
    job_posted_date
LIMIT 30;

-- LEAD() function allows you to access data from a subsequent row in the result set, based on the specified ORDER BY clause. 
-- It is often used for comparing values between consecutive rows.   
--  Time Based comparison of Company Salary with LEAD() function

SELECT 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
        ) AS next_salary_per_company,
    salary_year_avg - LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
        ) AS salary_difference_per_company
FROM
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
ORDER BY 
    company_id,
    job_posted_date
LIMIT 30;

-- FIRST_VALUE() function returns the first value in an ordered set of values, based on the specified ORDER BY clause.
--  It is useful for retrieving the initial value in a partition or window.  

-- LAST_VALUE() function returns the last value in an ordered set of values, based on the specified ORDER BY clause. 
-- It is useful for retrieving the final value in a partition or window.  

-- NTH_VALUE() function returns the value of the nth row in an ordered set of values, based on the specified ORDER BY clause. 
-- It allows you to retrieve a specific value from a partition or window.    
