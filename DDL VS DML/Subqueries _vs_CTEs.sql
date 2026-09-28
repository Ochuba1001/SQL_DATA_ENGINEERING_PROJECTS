/*                                  SUBQUERIES VS CTES
They are used for organizing and structuring SQL queries. They are used to break down complex queries into smaller, more manageable parts. 
They can also be used to improve query performance by allowing the database engine to optimize the execution plan for each part of the query separately.
Subqueries are queries that are nested inside another query. They can be used in the SELECT, FROM, and WHERE clauses of a SQL statement. 
Subqueries can be used to filter data, calculate aggregates, and perform other operations on the data.
CTEs (Common Table Expressions) are temporary result sets that can be referenced within a SQL statement. 
They are defined using the WITH clause and can be used to simplify complex queries, improve readability, and enable recursive queries. 
CTEs can also be used to break down a query into smaller, more manageable parts, making it easier to understand and maintain.
Subqueries and CTEs can be used together to create more complex queries. For example, a subquery can be used to filter data in a CTE, or a CTE can be used to simplify a subquery. 
By using both techniques together, you can create more efficient and effective queries that are easier to read and maintain.Subqueries 
and CTEs can also be used to improve query performance. By breaking down a complex query into smaller parts, the database engine can optimize the execution plan for 
each part of the query separately, resulting in faster query execution times.
In summary, subqueries and CTEs are powerful tools for organizing and structuring SQL queries. They can be used to simplify complex queries, improve readability, 
and enable recursive queries. By using both techniques together, you can create more efficient and effective queries that are easier to read and maintain.
*/

                                                    -- SUBQUERY

USE data_jobs;

SELECT * 
FROM (
    SELECT * 
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
    OR 
        salary_hour_avg IS NOT NULL
) AS valid_salaries
LIMIT 10;

-- Scenario 1: Show each job's salary next to the overall market median [Subquery in 'SELECT' clause]

SELECT 
    job_title_short,
    salary_year_avg,
    (
        SELECT 
            MEDIAN(salary_year_avg)
        FROM
            job_postings_fact
        WHERE 
            salary_year_avg IS NOT NULL
    ) AS market_median_salary
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
LIMIT 20;


-- Scenario 2: Stage only jobs that are remote before aggregating to determine the remote job median salary per job [Subquery in 'FROM' clause]

SELECT 
    job_title_short,
    salary_year_avg,
    (
        SELECT 
            MEDIAN(salary_year_avg)
        FROM
            job_postings_fact
        WHERE 
            salary_year_avg IS NOT NULL
        AND 
            job_work_from_home = TRUE
    ) AS remote_market_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE 
        job_work_from_home = TRUE
) AS remote_jobs
WHERE 
    salary_year_avg IS NOT NULL
LIMIT 20;


-- Scenario 3: Keep only job titles whose median salary is above the overall market median [Subquery in 'HAVING' clause]

SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS job_median_salary,
    (
        SELECT 
            MEDIAN(salary_year_avg)
        FROM
            job_postings_fact
        WHERE 
            job_work_from_home = TRUE
    ) AS remote_market_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE 
        job_work_from_home = TRUE
) AS remote_jobs
GROUP BY 
    job_title_short
HAVING 
    MEDIAN(salary_year_avg) > (
        SELECT 
            MEDIAN(salary_year_avg)
        FROM
            job_postings_fact
        WHERE 
            job_work_from_home = TRUE
            )
LIMIT 20;


                                                    -- CTEs

WITH valid_salary AS (
    SELECT * 
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
    OR 
        salary_hour_avg IS NOT NULL
)
SELECT *
FROM 
    valid_salary
LIMIT 10;                               


-- Compare how much more or less remote roles pay compared to onsite roles for each job titles
-- Use a CTE to calculate the median salary by title and work arrangement then compare those medians.

WITH median_salary AS (
    SELECT 
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg):: INT AS market_median_salary
    FROM 
        job_postings_fact
    WHERE 
        (job_country = 'Nigeria'
    OR 
        job_country = 'Anywhere')
    AND 
        salary_year_avg IS NOT NULL
    GROUP BY 
        job_title_short,
        job_work_from_home
)
SELECT
    remote_job.job_title_short,
    remote_job.market_median_salary AS remote_median_salary,
    onsite_job.market_median_salary AS onsite_median_salary,
    (remote_job.market_median_salary - onsite_job.market_median_salary) AS salary_difference
FROM 
    median_salary AS remote_job
INNER JOIN 
    median_salary AS onsite_job
ON 
    remote_job.job_title_short = onsite_job.job_title_short
WHERE
    remote_job.job_work_from_home = TRUE
AND 
    onsite_job.job_work_from_home = FALSE;

/*
                        --   WHERE EXISTS [KEEP ROWS IN MATCH IN TARGET] & WHERE NOT EXISTS [NO ROWS IN  MATCH WITH TARGET]

SELECT * 
FROM 
    range(5) AS src(key);

SELECT * 
FROM 
    range(3) AS trgt(key);

--                          WHERE EXISTS

SELECT *
FROM    
    range(5) AS src(key)
WHERE EXISTS (
    SELECT * 
    FROM 
        range(3) AS trgt(key)
    WHERE trgt.key = src.key
);

--                          WHERE NOT EXISTS

SELECT *
FROM    
    range(5) AS src(key)
WHERE NOT EXISTS (
    SELECT 1
    FROM 
        range(3) AS trgt(key)
    WHERE trgt.key = src.key
);

*/

-- FInal Example 
-- identify job postings that have no associated skills before loading them into the data mart 

SELECT * 
FROM 
    job_postings_fact
ORDER BY 
    job_id
LIMIT 40;

SELECT * 
FROM 
    skills_job_dim
ORDER BY 
    job_id 
LIMIT 40;


SELECT * 
FROM   
    job_postings_fact AS jpf
WHERE NOT EXISTS (
    SELECT 1
    FROM 
        skills_job_dim AS sjd
    WHERE 
        sjd.job_id = jpf.job_id
)
ORDER BY 
    job_id
LIMIT 30;


SELECT * 
FROM   
    job_postings_fact AS jpf
WHERE EXISTS (
    SELECT 1
    FROM 
        skills_job_dim AS sjd
    WHERE 
        sjd.job_id = jpf.job_id
)
ORDER BY 
    job_id
LIMIT 30;