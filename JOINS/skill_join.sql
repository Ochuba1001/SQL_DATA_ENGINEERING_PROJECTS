SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT *
FROM skills_dim
LIMIT 10;


SELECT 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM 
    job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd  
    ON sjd.skill_id = sd.skill_id
LIMIT 20;



SELECT 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd  
    ON sjd.skill_id = sd.skill_id
LIMIT 20;
