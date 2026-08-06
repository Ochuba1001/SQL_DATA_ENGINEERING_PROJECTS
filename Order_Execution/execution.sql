/* 
Find the top 10 companies for posting jobs
They must have >3000 postings 
*/


SELECT 
    cd.name AS company_name,
    COUNT(jpf.*) AS posting_count,
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC
LIMIT 10;

EXPLAIN 
SELECT 
    cd.name AS company_name,
    COUNT(jpf.*) AS posting_count,
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT 
    cd.name AS company_name,
    COUNT(jpf.*) AS posting_count,
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC
LIMIT 10;

SELECT
    job_posted_date,
    job_work_from_home,
    job_schedule_type,
    job_country,
    salary_hour_avg,
    job_title_short
FROM
    job_postings_fact
WHERE
        (job_title_short = 'Data Engineer' or job_title_short = 'Data Analyst')
    AND 
        (job_work_from_home = 'TRUE')
    AND 
        (job_schedule_type = 'Full-time')
    AND 
        (salary_hour_avg IS NOT NULL)
ORDER BY job_posted_date DESC
LIMIT 40;