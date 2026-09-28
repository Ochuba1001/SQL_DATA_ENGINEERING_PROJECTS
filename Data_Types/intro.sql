/* 
 Reasons why data types matters:
 - Data Integrity
 - Data Validation
 - Performance and Storage
 - Type-specific behavior
 
 Common data types
 - Numeric: Int, Float, Double, Decimal, Numeric(p,s: total digit, digits after decimal)
 - Character: Varchar, Char(n: max Character), Text
 - Boolean: True, False
 - Date/Time: Date, Time, Timestamp,Timestampz(timezone)
 - Other types: Array, Json, Binary, UUID
 */

--  Checking Common Data Type
SELECT 
    table_name,
    column_name,
    data_type
FROM 
    information_schema.columns
WHERE 
    table_name = 'job_postings_fact';

-- Describe can also be used but it isn't universal
DESCRIBE job_postings_fact;

DESCRIBE
    SELECT 
        job_title_short,
        salary_year_avg

    FROM     
        job_postings_fact;

-- CAST OPERATOR is used to convert data types
SELECT CAST('123' AS INTEGER);

SELECT  
    CAST(job_id AS Varchar) || '-' || CAST(company_id AS Varchar) AS job_company_id, -- 'more unique identifier
    CAST(job_work_from_home AS INT) AS job_work_from_home, -- From boolean to numeric value
    CAST(job_posted_date AS DATE) AS job_posted_date, -- From timestamp to date
    CAST(salary_year_avg AS INT) AS salary_year_avg -- From double to no decimal places 
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT 20;

-- Instead of using CAST, use :: operator
SELECT  
    (job_id::Varchar) || '-' || (company_id::Varchar) AS job_company_id, -- 'more unique identifier
    (job_work_from_home::INT) AS job_work_from_home, -- From boolean to numeric value
    (job_posted_date::DATE) AS job_posted_date, -- From timestamp to date
    (salary_year_avg::INT) AS salary_year_avg -- From double to no decimal places 
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT 20;
