/* It applies conditional logic in SQl transformation in order to categorize, clean and standardize data. */ 
                                                -- Engineering Use Case

-- Bucketing Data: It group values into ranges 
/* Categorize the 'salary_hour_avg' column value as:
    < 25: Low salary
    - 25 - 50: Medium salary
    - 50 - 75: High salary
*/

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    company_id,
    CASE 
        WHEN salary_hour_avg < 25 THEN 'Low Salary'
        WHEN salary_hour_avg >= 25 AND salary_hour_avg < 50 THEN 'Medium Salary'
        WHEN salary_hour_avg >= 50 AND salary_hour_avg < 75 THEN 'High Salary'
        ELSE 'Very High Salary'
    END AS salary_category
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
LIMIT 20;


-- Handling NULL values: handles NULL explicitly

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    company_id,
    CASE 
        WHEN salary_hour_avg IS NULL THEN 'Salary Not Available'
        WHEN salary_hour_avg < 25 THEN 'Low Salary'
        WHEN salary_hour_avg >= 25 AND salary_hour_avg < 50 THEN 'Medium Salary'
        WHEN salary_hour_avg >= 50 AND salary_hour_avg < 75 THEN 'High Salary'
        ELSE 'Very High Salary'
    END AS salary_category
FROM
    job_postings_fact
LIMIT 20;

-- Categorizing Data: It categorizes data based on specific conditions and normalize inconsistent text
/* Classify the 'job_title' column value as:
    - Data Analyst
    - Data Engineer
    - Data Scientist
*/

SELECT 
    job_title,
    CASE
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM 
    job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

-- Conditional Aggregation: It aggregate subsets in one query
/* Calculate the median Salaries for different buckets
    - < $100k
    - > $100k
*/

SELECT 
    job_title_short,
    COUNT(*) AS total_postings,
    MEDIAN (
        CASE 
            WHEN salary_year_avg < 100_000 THEN salary_year_avg
        END 
        ) AS median_low_salary,
        MEDIAN (
        CASE 
            WHEN salary_year_avg >= 100_000 THEN  salary_year_avg
        END
    ) AS median_high_salary
FROM 
    job_postings_fact 
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY 
    job_title_short;

--  Conditional Calculation
/* Compute a standardized salary using yearly salary and adjusted hourly salary(eg. 2000 hours/year)
- <75k: Low Salary
- 75k - 150k: Medium Salary
- 150k - 250k: High Salary
- > 250k: Very High Salary
*/

WITH salaries AS 
(
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        salary_hour_avg,
        company_id,
        CASE 
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2080
        END AS standardized_salary
    FROM 
        job_postings_fact
    -- WHERE 
    --     salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
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