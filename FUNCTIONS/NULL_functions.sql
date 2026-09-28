/* NULL Functions in SQL 
NULL functions are used to handle NULL values in SQL. Here are some common NULL functions:
1. IS NULL: This function checks if a value is NULL. It returns TRUE if the value is NULL, and FALSE otherwise.
2. IS NOT NULL: This function checks if a value is NOT NULL. It returns TRUE if the value is NOT NULL, and FALSE otherwise.
3. COALESCE(): This function returns the first non-NULL value from a list of values. It can be used to provide a default value when dealing with NULLs.
4. NULLIF(): This function compares two values and returns NULL if they are equal; otherwise, it returns the first value. 
    It can be used to avoid division by zero errors or to handle specific cases where NULL should be returned.
*/

-- NULLIF()
SELECT NULLIF(10,10); -- Returns NULL because both values are equal
SELECT NULLIF(10,5);  -- Returns 10 because the values are not equal

SELECT 
    NULLIF(salary_year_avg,0),
    NULLIF(salary_hour_avg,0)
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 10;

-- COALESCE()
SELECT COALESCE(NULL, NULL, 'First Non-NULL Value', 'Second Non-NULL Value'); -- Returns 'First Non-NULL Value'
SELECT COALESCE(NULL, NULL, NULL); -- Returns NULL because all values are NULL
SELECT COALESCE(1,2,3); -- Returns 1 because it is the first non-NULL value
SELECT COALESCE(NULL,2,3); -- Returns 2 because it is the first non-NULL value
SELECT COALESCE(NULL,NULL,3); -- Returns 3 because it is the first non-NULL value

SELECT 
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg, 0) AS salary_avg
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 10;



WITH salaries AS 
(
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        salary_hour_avg,
        company_id,
        COALESCE(salary_year_avg, salary_hour_avg * 2000, NULL) AS standardized_salary
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
    )
SELECT 
    *,
    standardized_salary,
    CASE 
        WHEN standardized_salary IS NULL THEN 'Salary Not Available'
        WHEN standardized_salary < 75_000 THEN 'Low Salary'
        WHEN standardized_salary >= 75_000 AND standardized_salary < 150_000 THEN 'Medium Salary'
        WHEN standardized_salary >= 150_000 AND standardized_salary < 250_000 THEN 'High Salary'
        ELSE 'Very High Salary'
    END AS salary_category
FROM
    salaries
LIMIT 20;



SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    company_id,
    COALESCE(salary_year_avg, salary_hour_avg * 2000, NULL) AS standardized_salary,
    CASE 
        WHEN standardized_salary IS NULL THEN 'Salary Not Available'
        WHEN standardized_salary < 75_000 THEN 'Low Salary'
        WHEN standardized_salary >= 75_000 AND standardized_salary < 150_000 THEN 'Medium Salary'
        WHEN standardized_salary >= 150_000 AND standardized_salary < 250_000 THEN 'High Salary'
        ELSE 'Very High Salary'
    END AS salary_category
FROM
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 20;