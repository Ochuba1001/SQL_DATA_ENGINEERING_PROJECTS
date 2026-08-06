-- OUTER JOIN: It returns all rows in both tables been joined

SELECT
    jpf.job_id,
    cd.name AS company_name,
    jpf.job_title_short,
    jpf.job_location
FROM
    job_postings_fact AS jpf
FULL OUTER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_title_short = 'Data Engineer' 
AND job_work_from_home = TRUE
LIMIT 20;