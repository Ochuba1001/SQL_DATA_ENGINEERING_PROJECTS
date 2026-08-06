SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM
    job_postings_fact
LIMIT 20;

SELECT *
FROM  information_schema.tables
WHERE table_catalog = 'data_jobs';


SELECT *
FROM  information_schema.columns
WHERE table_catalog = 'data_jobs';

PRAGMA show_tables_expanded;

DESCRIBE job_postings_fact;