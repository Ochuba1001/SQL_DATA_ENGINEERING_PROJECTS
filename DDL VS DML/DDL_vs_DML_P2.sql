-- .read 'DDL VS DML\DDL_vs_DML_P2.sql'


                                                    -- CTAS [CREATE TABLE AS SELECT]

USE jobs_mart;

DESCRIBE
SELECT  
    jpf.*,
    cd.*
FROM 
    data_jobs.job_postings_fact AS jpf
LEFT JOIN 
    data_jobs.company_dim AS cd
ON 
    jpf.company_id = cd.company_id
LIMIT 10;


/*                                       Describe     Result                              
    │                                                                                      │
    │ job_id                integer   not null    company_id            integer            │
    │ job_title_short       varchar               job_title             varchar            │
    │ job_location          varchar               job_via               varchar            │
    │ job_schedule_type     varchar               job_work_from_home    boolean            │
    │ search_location       varchar               job_posted_date       timestamp          │
    │ job_no_degree_mention boolean               job_health_insurance  boolean            │
    │ job_country           varchar               salary_rate           varchar            │
    │ salary_year_avg       double                salary_hour_avg       double             │
    │ company_id            integer   not null    name                  varchar            │
    │ link                  varchar               link_google           varchar            │
    │ thumbnail             varchar                                                        │ */

CREATE OR REPLACE TABLE staging.job_postings_flat AS
    SELECT
        jpf.job_id,
        -- jpf.company_id,
        jpf.job_title_short,
        jpf.job_title,
        jpf.job_location,
        jpf.job_via,
        jpf.job_schedule_type,
        jpf.job_work_from_home,
        jpf.search_location,
        jpf.job_posted_date,
        jpf.job_no_degree_mention,
        jpf.job_health_insurance,
        jpf.job_country,
        jpf.salary_rate,
        jpf.salary_year_avg,
        jpf.salary_hour_avg,
        cd.name AS company_name,
        -- cd.link AS company_link,
        -- cd.link_google,
        -- cd.thumbnail   
    FROM 
        data_jobs.job_postings_fact AS jpf
    LEFT JOIN 
        data_jobs.company_dim AS cd
    ON  
        jpf.company_id = cd.company_id;


SELECT COUNT(*) AS total_records
FROM 
    staging.job_postings_flat;


                                                            -- VIEWS
-- The key benefits is that it is always auto updating 

CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS
    SELECT 
        jpfl.* 
    FROM 
        staging.job_postings_flat AS jpfl
    JOIN 
        staging.priority_roles AS pr
    ON
        
        jpfl.job_title_short = pr.role_name
    WHERE 
        pr.priority_levels = 1;
    -- LIMIT 10;

SELECT 
    job_title_short,
    COUNT(*) AS flat_view_records
FROM 
    staging.priority_jobs_flat_view
GROUP  BY
    job_title_short;

                                                -- TEMPORARY TABLE (TEMP TABLE)

CREATE OR REPLACE TEMPORARY TABLE data_engineer_jobs_flat_temp AS 
    SELECT * 
    FROM 
        staging.job_postings_flat
    WHERE 
        job_title_short = 'Data Engineer';                                                

SELECT 
    job_title_short,
    COUNT(*) AS temp_view_records
FROM 
    data_engineer_jobs_flat_temp
GROUP  BY
    job_title_short;


                                    -- DELETING FROM A TABLE
-- Delete data from before the year 2024 in the jobs_mart 
DELETE FROM 
    staging.job_postings_flat
WHERE 
    job_posted_date < '2024-01-01';

SELECT COUNT(*) AS total_records_after_delete
FROM 
    staging.job_postings_flat;

SELECT COUNT(*) AS total_records_after_delete
FROM
    staging.priority_jobs_flat_view;

SELECT COUNT(*) AS total_records_after_delete
FROM   
    data_engineer_jobs_flat_temp;

SELECT * 
FROM 
    staging.job_postings_flat
ORDER BY 
    job_posted_date DESC
LIMIT 20;

                                        -- TRUNCATING DATA FROM TABLE
-- Truncate deletes all the data in the table but the schema still remains available
-- Provide job postings that are 2024 and greater 

TRUNCATE TABLE staging.job_postings_flat;                                        

INSERT INTO staging.job_postings_flat
SELECT
        jpf.job_id,
        -- jpf.company_id,
        jpf.job_title_short,
        jpf.job_title,
        jpf.job_location,
        jpf.job_via,
        jpf.job_schedule_type,
        jpf.job_work_from_home,
        jpf.search_location,
        jpf.job_posted_date,
        jpf.job_no_degree_mention,
        jpf.job_health_insurance,
        jpf.job_country,
        jpf.salary_rate,
        jpf.salary_year_avg,
        jpf.salary_hour_avg,
        cd.name AS company_name,
        -- cd.link AS company_link,
        -- cd.link_google,
        -- cd.thumbnail   
    FROM 
        data_jobs.job_postings_fact AS jpf
    LEFT JOIN 
        data_jobs.company_dim AS cd
    ON  
        jpf.company_id = cd.company_id
    WHERE 
        job_posted_date >= '2024-01-01';
        

SELECT COUNT(*) AS total_records_after_truncate
FROM 
    staging.job_postings_flat;

SELECT COUNT(*) AS total_records_after_truncate
FROM
    staging.priority_jobs_flat_view;

SELECT COUNT(*) AS total_records_after_truncate
FROM   
    data_engineer_jobs_flat_temp;