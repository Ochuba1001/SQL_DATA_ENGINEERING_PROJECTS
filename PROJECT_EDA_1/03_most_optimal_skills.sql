/*
 What are the most optimal skills for data engineers - balancing both demand and salary?
 - Create a ranking column that combines demand count and median salary to identify the most valuable skills
 - Focus only on remote Data Engineer positions with specified annual salaries 
 Why?
 - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately rather than letting
 rare, outlier skills distort the results 
 */


SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 2) AS ln_demand_count,
    ROUND(
        MEDIAN(jpf.salary_year_avg) * COUNT(jpf.*) / 1_000_000,
        0
    ) AS optimal_score
FROM 
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE 
        (jpf.job_title_short = 'Data Engineer')
    AND 
        (jpf.job_work_from_home = TRUE)
    AND 
        (jpf.salary_year_avg IS NOT NULL)
GROUP BY 
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY 
        optimal_score DESC 
LIMIT 30;


/*
                        A breakdown of the most optimal skills for Data Engineers base on high demand and high salaries 
    - Python is the leading skill with an optimal score of 153 and a median salary of $135k with over 1100 posting 
    - SQL is slightly behind with  similar posting and salary as Python but a lower optimal score of 143
    - AWS (783 posting and median salary of $137k), Spark (median salary of $140k with posting of 503), and Azure(median salary $128k with posting of 475) are among the top 5
    most optimal skills
    - Terraform which has the highest median salary of $184k and posting of 193 but has a low optimal score of 41
    Other notable skills include
        - Snowflake with $135k, posting of 438 and optimal score of 59
        - Airflow has $150k median salary, 386 posting and 58 optimal score
        - Kafka got 42 optimal score, $145k median salary and 292 posting
        - Git with 208 posting, $140k median salary and 29 optimal score
    
 ┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ python     │      135000.0 │         1133 │            7.03 │         153.0 │
│ sql        │      130000.0 │         1128 │            7.03 │         147.0 │
│ aws        │      137320.0 │          783 │            6.66 │         108.0 │
│ spark      │      140000.0 │          503 │            6.22 │          70.0 │
│ azure      │      128000.0 │          475 │            6.16 │          61.0 │
│ snowflake  │      135500.0 │          438 │            6.08 │          59.0 │
│ airflow    │      150000.0 │          386 │            5.96 │          58.0 │
│ kafka      │      145000.0 │          292 │            5.68 │          42.0 │
│ java       │      135000.0 │          303 │            5.71 │          41.0 │
│ terraform  │      184000.0 │          193 │            5.26 │          36.0 │
│ redshift   │      130000.0 │          274 │            5.61 │          36.0 │
│ databricks │      132750.0 │          266 │            5.58 │          35.0 │
│ scala      │      137290.0 │          247 │            5.51 │          34.0 │
│ git        │      140000.0 │          208 │            5.34 │          29.0 │
│ gcp        │      136000.0 │          196 │            5.28 │          27.0 │
│ hadoop     │      135000.0 │          198 │            5.29 │          27.0 │
│ nosql      │      134415.0 │          193 │            5.26 │          26.0 │
│ kubernetes │      150500.0 │          147 │            4.99 │          22.0 │
│ pyspark    │      140000.0 │          152 │            5.02 │          21.0 │
│ tableau    │      115000.0 │          164 │             5.1 │          19.0 │
│ docker     │      135000.0 │          144 │            4.97 │          19.0 │
│ r          │      134775.0 │          133 │            4.89 │          18.0 │
│ mongodb    │      135750.0 │          136 │            4.91 │          18.0 │
│ github     │      135000.0 │          127 │            4.84 │          17.0 │
│ bigquery   │      135000.0 │          123 │            4.81 │          17.0 │
│ sql server │      120000.0 │          139 │            4.93 │          17.0 │
│ go         │      140000.0 │          113 │            4.73 │          16.0 │
│ postgresql │      122500.0 │          129 │            4.86 │          16.0 │
│ power bi   │      120000.0 │          129 │            4.86 │          15.0 │
│ oracle     │      124500.0 │          109 │            4.69 │          14.0 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
  30 rows                                                           5 columns
 */