/*
What are the highest-paying skills for data engineers?
-   Calculate the median salary for each skill required in data engineer positions
-   Focus on remote positions with specified salaries
-   Include skill frequency to identify both salary and demand
Why?
-   Help identify which skills command the highest compensation while also showing how common those skills are, 
    providing a more complete picture for skill development priorities
-   The median is used instead of the average to reduce the impact of outlier salaries
*/


SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
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
HAVING 
    COUNT(jpf.*) > 100
ORDER BY 
    median_salary DESC
LIMIT 30;

/*
┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ c          │      151500.0 │          444 │
│ atlassian  │      151500.0 │          249 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ node       │      150000.0 │          179 │
│ ruby       │      150000.0 │          736 │
│ airflow    │      150000.0 │         9996 │
│ css        │      150000.0 │          262 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
│ visio      │      146500.0 │          105 │
│ kafka      │      145000.0 │         6415 │
│ pandas     │      140000.0 │         2929 │
│ splunk     │      140000.0 │          251 │
│ word       │      140000.0 │          650 │
└────────────┴───────────────┴──────────────┘
  30 rows                         3 columns
  */

/*          KEY INSIGHT
- Rust is the highest paying skill with median salary of $210k but with relatively low demand
- Airflow is the most in-demand skill with about 10,000 posting but isn't in the top 15 highest paying skills
- Kafka and Pandas are among the top 5 most demand skill with a median salary of $145k and $140k but are not among the top 20 highest median salary
- Other notable skills with high median salary and relatively better demand include
    - Kubernetes with $150k
    - GDPR at $169k
    - Graphql at $167k
- Terraform with $184k and posting of about 3,000 is the only skill with a high demand median salary and relatively high posting among the top 5
skills 
*/