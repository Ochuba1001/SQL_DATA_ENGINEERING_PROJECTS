-- .read 'Batch_Pipeline_Processing\priority_jobs_snapshot.sql'



-- CREATE A TEMP TABLE THAT CONTAINS QUERY THAT CREATES THE SOURCE TABLE

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


-- UPDATE STATEMENT TO CAPTURE THE LATEST RECORDS FROM THE SOURCE TABLE AND UPDATE THE SNAPSHOT TABLE  [MATCHED ROWS]

UPDATE 
    main.priority_jobs_snapshot AS trgt
SET 
    preferred_level = src.preferred_level,
    updated_at = src.updated_at
FROM 
    src_priority_jobs AS src
WHERE 
    trgt.job_id = src.job_id
AND 
    trgt.preferred_level IS DISTINCT FROM src.preferred_level;


-- INSERT STATEMENT WHERE JOBS WERE ADDED TO THE PRIORITY TABLE  [UNMATCHED INCOMING ROWS]

INSERT INTO main.priority_jobs_snapshot (
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
    src.job_id,
    src.job_title_short, 
    src.company_name, 
    src.salary_year_avg, 
    src.job_work_from_home, 
    src.preferred_level, 
    src.job_posted_date,
    src.updated_at
FROM
    src_priority_jobs AS src
WHERE NOT EXISTS (
    SELECT 1
    FROM 
        main.priority_jobs_snapshot AS trgt
    WHERE 
        trgt.job_id = src.job_id
);


-- DELETE STATEMENT WHERE JOBS WERE REMOVED FROM THE PRIORITY TABLE  [UNMATCHED EXISTING ROWS]

DELETE FROM 
    main.priority_jobs_snapshot AS trgt
WHERE NOT EXISTS (
    SELECT 1
    FROM 
        src_priority_jobs AS src
    WHERE 
        trgt.job_id = src.job_id
);


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



/* 
        THIS IS A FULL DATA PIPELINE IN ORDER TO PERFORM BATCH PROCESSING 
        BY LOADING TEMPORARY TABLES
        UPDATING THE SNAPSHOT TABLE WITH THE LATEST DATA FROM THE SOURCE TABLE
        INSERTING NEW RECORDS INTO THE SNAPSHOT TABLE
        DELETING RECORDS FROM THE SNAPSHOT TABLE THAT ARE NO LONGER PRESENT IN THE SOURCE TABLE
        AND FINALLY SELECTING THE DATA FROM THE SNAPSHOT TABLE FOR ANALYSIS
*/