/* 
- What are the most in-demand skills for data engineers?
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why?
    - Retrieve the top 10 skills with the highest demand in the remote job market, providing insights into the most valuable
        skills for data engineers seeking remote work
*/

SELECT 
    sd.skills,
    COUNT(jpf.*)  AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE 
        (jpf.job_title_short = 'Data Engineer')
    AND
        (jpf.job_work_from_home = TRUE)
GROUP BY 
    sd.skills
ORDER BY 
    demand_count DESC
LIMIT 10;

/*
    Below are the top 10 in-demand skills for Data Engineers
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
  10 rows         2 columns

    - The top of the list is SQL with about 29,000 and then Python with about 28,000 which indicates that they are the top most fundamental skills needed by
    a Data Engineer.
    - Cloud platforms such as AWS at about 18,000 followed by Azure at 14,000 are the two most in-demand cloud platform.
    - Big data tool like Spark at 12,000 rounds the top 5 most required skills for a Data Engineer.
    - Data pipeline such as snowflake, databricks and airflow with airflow leading are showing increase in demand
    - Java with GCP round up the 10 highly demanded skills for Data Engineer.
  */