-- RIGHT JOIN: It returns all data from the right table to the matching data on the left table. LEFT ANTI JOIN can be used in place of RIGHT JOIN

SELECT
    jpf.job_id,
    cd.name AS company_name,
    jpf.job_title_short,
    jpf.job_location
FROM
    job_postings_fact AS jpf
RIGHT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_title_short = 'Data Engineer' 
AND job_work_from_home = TRUE
LIMIT 20;

