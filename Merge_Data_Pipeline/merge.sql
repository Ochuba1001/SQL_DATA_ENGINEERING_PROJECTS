-- .read 'Merge_Data_Pipeline\merge.sql'


CREATE OR REPLACE TEMPORARY TABLE src_priority_jobs AS
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

        -- MERGE STATEMENT 


MERGE INTO main.priority_jobs_snapshot AS trgt
USING src_priority_jobs AS src
ON trgt.job_id = src.job_id
WHEN MATCHED AND 
    trgt.preferred_level IS DISTINCT FROM src.preferred_level 
    THEN
        UPDATE SET 
            preferred_level = src.preferred_level,
            updated_at = src.updated_at
WHEN NOT MATCHED 
    THEN
        INSERT (
            job_id, 
            job_title_short, 
            company_name, 
            salary_year_avg, 
            job_work_from_home, 
            preferred_level, 
            job_posted_date,
            updated_at
        )
        VALUES (
            src.job_id,
            src.job_title_short, 
            src.company_name, 
            src.salary_year_avg, 
            src.job_work_from_home, 
            src.preferred_level, 
            src.job_posted_date,
            src.updated_at
        )
WHEN NOT MATCHED BY 
    SOURCE 
    THEN 
        DELETE;


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