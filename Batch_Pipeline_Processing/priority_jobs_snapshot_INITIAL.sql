
CREATE OR REPLACE TABLE main.priority_jobs_snapshot (
    job_id INT PRIMARY KEY,
    job_title_short VARCHAR(100),
    company_name VARCHAR(100),
    salary_year_avg FLOAT,
    job_work_from_home BOOLEAN,
    preferred_level INTEGER,
    job_posted_date DATE,
    updated_at TIMESTAMP
    );

INSERT INTO priority_jobs_snapshot (
    job_id, 
    job_title_short, 
    company_name, 
    salary_year_avg, 
    job_work_from_home, 
    preferred_level, 
    job_posted_date,
    updated_at
    )
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.salary_year_avg,
    jpf.job_work_from_home,
    pr.preferred_level AS preferred_level,
    jpf.job_posted_date,
    CURRENT_TIMESTAMP AS updated_at
FROM 
    data_jobs.job_postings_fact AS jpf
LEFT JOIN
    data_jobs.company_dim AS cd
ON
    jpf.company_id = cd.company_id
INNER JOIN
    staging.priority_roles AS pr
ON 
    jpf.job_title_short = pr.role_name;
-- WHERE 
--     jpf.salary_year_avg IS NOT NULL
--     AND jpf.job_work_from_home IS NOT NULL
--     AND jpf.job_posted_date >= CURRENT_DATE - INTERVAL '7 days';


SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    MIN(preferred_level) AS preferred_level,
    MIN(updated_at) AS updated_at
FROM 
    priority_jobs_snapshot
GROUP BY 
    job_title_short
ORDER BY 
    job_count;

SELECT * 
FROM 
    priority_jobs_snapshot
LIMIT 40;