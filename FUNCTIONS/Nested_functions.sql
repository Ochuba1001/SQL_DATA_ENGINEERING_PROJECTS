/* Nested Functions in SQL are functions that are called within other functions.
 They allow you to perform complex calculations and transformations by combining multiple functions together. 
 Nested functions can be used in various SQL statements, such as SELECT, WHERE, and HAVING clauses. 
 The most common use cases for nested functions include data manipulation, aggregation, and conditional logic.
 SYNTAX:
     SELECT 
         function1(function2(column_name)) AS new_column
     FROM 
         table_name;
 The first function (function1) is the outer function, and the second function (function2) is the inner function.
 Example:
     SELECT 
         UPPER(TRIM(column_name)) AS cleaned_column
     FROM 
         table_name;
  The five most common nested data types are Arrays/Lists, JSON, Array of Structs, (XML), Structs/Records/Row, and Maps/Dictionaries/Objects.
  Arrays/Lists:
    - Arrays or lists are ordered collections of elements that can be of any data type.
    - They allow you to store multiple values in a single column, making it easier to work with related data.
    - Common operations on arrays include accessing elements by index, iterating through the array, and performing aggregate functions on the array elements.
  JSON:
    - JSON (JavaScript Object Notation) is a lightweight data interchange format that is easy for humans to read and write, and easy for machines to parse and generate.
    - It allows you to store structured data in a single column, making it easier to work with hierarchical data.
    - Common operations on JSON include extracting values using JSON path expressions, modifying JSON objects, and performing aggregate functions on JSON elements.
  XML:
    - XML (eXtensible Markup Language) is a markup language that defines a set of rules for encoding documents in a format that is both human-readable and machine-readable.
    - It allows you to store structured data in a single column, making it easier to work with hierarchical data.
    - Common operations on XML include extracting values using XPath expressions, modifying XML elements, and performing aggregate functions on XML elements.
  Structs/Records/Row:
    - Structs, records, or rows are composite data types that allow you to group multiple related values together into a single column.
    - They allow you to store complex data structures in a single column, making it easier to work with related data.
    - Common operations on structs include accessing individual fields, modifying field values, and performing aggregate functions on struct elements.
      Maps/Dictionaries/Objects:
    - Maps, dictionaries, or objects are key-value pairs that allow you to store and retrieve data based on a unique key.
    - They allow you to store complex data structures in a single column, making it easier to work with related data.
    - Common operations on maps include accessing values by key, modifying key-value pairs, and performing aggregate functions on map elements.
  Arrays of Structs:
   - Arrays of structs are collections of composite data types that allow you to store multiple related values together in a single column.
   - They allow you to store complex data structures in a single column, making it easier to work with related data.
   - Common operations on arrays of structs include accessing individual struct elements, modifying struct values, and performing aggregate functions on array elements.

A nested function is a function that is called within another function. In SQL, you can use nested functions to perform complex calculations and transformations on your data. For example, you can use the UPPER() function to convert a string to uppercase, and then use the TRIM() function to remove any leading or trailing spaces from the string. By nesting these functions together, you can create a new column that contains cleaned and formatted data.   
*/ 

--                              Query to demonstrate nested functions in SQL
--                               Arrays/Lists

WITH jobs_titles AS (
    SELECT 
        ARRAY_AGG(DISTINCT job_title_short) AS unique_job_titles
    FROM 
        job_postings_fact
)
SELECT 
    unique_job_titles,
    ARRAY_LENGTH(unique_job_titles) AS total_unique_job_titles
FROM 
    jobs_titles;

--  Accessing using index

WITH jobs_titles AS (
    SELECT 
        ARRAY_AGG(DISTINCT job_title_short) AS unique_job_titles
    FROM 
        job_postings_fact
)
SELECT 
    unique_job_titles[0] AS first_job_title,
    unique_job_titles[1] AS second_job_title,
    unique_job_titles[-1] AS last_job_title
FROM 
    jobs_titles;

-- Unnesting an array

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL 
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT 
    UNNEST(skills)          -- To unnnest a list or array 
FROM
    skills_array;


--                    Structs/Records/Row

SELECT 
    {skill:'Python', experience: 3, location: 'New York'} AS job_info;

WITH skill_stuct AS (
    SELECT 
        STRUCT_PACK(
            skill:= 'Python',
            experience:= 3,
            location:= 'New York',
            salary:= 120000,
            type:= 'Full-time'
        ) AS job_info
)
SELECT 
    job_info.skill AS skill,
    job_info.experience AS experience,
    job_info.location AS location,
    job_info.salary AS salary,
    job_info.type AS type
FROM
    skill_stuct;


WITH skill_table AS (
    SELECT 'python' AS skills, 3 AS experiences, 'New York' AS locations, 120000 AS salaries, 'Full-time' AS types
    UNION ALL
    SELECT 'java', 5, 'San Francisco', 150000, 'Full-time'
    UNION ALL
    SELECT 'javascript', 2, 'Los Angeles', 100000, 'Part-time'
    UNION ALL
    SELECT 'sql', 4, 'Chicago', 130000, 'Full-time'
)
SELECT 
    STRUCT_PACK(
        skill:= skills,
        experience:= experiences,
        location:= locations,
        salary:= salaries,
        type:= types
    ) AS job_info
FROM
    skill_table;

                        --           ARRAYS OF STRUCTS

SELECT [
    {skill:'Python', experience: 3, location: 'New York', salary: 120000, type: 'Full-time'},
    {skill:'Java', experience: 5, location: 'San Francisco', salary: 150000, type: 'Full-time'},
    {skill:'JavaScript', experience: 2, location: 'Los Angeles', salary: 100000, type: 'Part-time'},
    {skill:'SQL', experience: 4, location: 'Chicago', salary: 130000, type: 'Full-time'}
] AS skill_array_struct;

WITH skill_table AS (
    SELECT 'python' AS skills, 3 AS experiences, 'New York' AS locations, 120000 AS salaries, 'Full-time' AS types
    UNION ALL
    SELECT 'java', 5, 'San Francisco', 150000, 'Full-time'
    UNION ALL
    SELECT 'javascript', 2, 'Los Angeles', 100000, 'Part-time'
    UNION ALL
    SELECT 'sql', 4, 'Chicago', 130000, 'Full-time'
),skill_array_struct AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill:= skills,
                experience:= experiences,
                location:= locations,
                salary:= salaries,
                type:= types
            )
        ) AS array_struct
    FROM
        skill_table
)
SELECT 
    array_struct[1] AS first_skill_struct,
    array_struct[2] AS second_skill_struct,
    array_struct[-1].salary AS last_skill_struct_salary
FROM
    skill_array_struct;


                                        -- MAPS/DICTIONARIES/OBJECTS

WITH skill_map AS (
    SELECT 
        MAP{'skill': 'python','type': 'Full-time'} AS job_info
)
SELECT 
    job_info['skill'] AS skill,
    job_info['type'] AS type
FROM
    skill_map;

    
                        -- JSON
SELECT 
    JSON_OBJECT('skill', 'python', 'experience', 3, 'location', 'New York', 'salary', 120000, 'type', 'Full-time') AS job_info;

SELECT 
    JSON_EXTRACT(job_info, '$.skill') AS skill,
    JSON_EXTRACT(job_info, '$.experience') AS experience,
    JSON_EXTRACT(job_info, '$.location') AS location,
    JSON_EXTRACT(job_info, '$.salary') AS salary,
    JSON_EXTRACT(job_info, '$.type') AS type
FROM (
    SELECT 
        JSON_OBJECT('skill', 'python', 'experience', 3, 'location', 'New York', 'salary', 120000, 'type', 'Full-time') AS job_info
) AS job_info_table;


--  JSON TO STRUCT

WITH json_raw_data AS (
    SELECT 
        JSON_OBJECT('skill', 'python', 'experience', 3, 'location', 'New York', 'salary', 120000, 'type', 'Full-time') AS job_info
)
SELECT 
    STRUCT_PACK(
        skill:= JSON_EXTRACT_STRING(job_info, '$.skill'),
        experience:= JSON_EXTRACT_STRING(job_info, '$.experience'),
        location:= JSON_EXTRACT_STRING(job_info, '$.location'),
        salary:= JSON_EXTRACT_STRING(job_info, '$.salary'),
        type:= JSON_EXTRACT_STRING(job_info, '$.type')
    ) AS job_info_struct
FROM
    json_raw_data;

-- JSON TO ARRAY OF STRUCTS

WITH json_skill AS (
    SELECT 
        '[
        {"skill": "python", "experience": 3, "location": "New York", "salary": 120000, "type": "Full-time"},
        {"skill": "java", "experience": 5, "location": "San Francisco", "salary": 150000, "type": "Full-time"},
        {"skill": "javascript", "experience": 2, "location": "Los Angeles", "salary": 100000, "type": "Part-time"},
        {"skill": "sql", "experience": 4, "location": "Chicago", "salary": 130000, "type": "Full-time"}
        ]'::JSON AS json_array_element
)
SELECT 
    ARRAY_AGG(
        STRUCT_PACK(
            skill:= JSON_EXTRACT_STRING(json_array.value, '$.skill'),
            experience:= JSON_EXTRACT_STRING(json_array.value, '$.experience'),
            location:= JSON_EXTRACT_STRING(json_array.value, '$.location'),
            salary:= JSON_EXTRACT_STRING(json_array.value, '$.salary'),
            type:= JSON_EXTRACT_STRING(json_array.value, '$.type')
        )
        ORDER BY JSON_EXTRACT_STRING(json_array.value, '$.skill')
    ) AS array_of_structs
FROM
    json_skill,json_each(json_array_element) AS json_array;

                                --  FINAL EXAMPLE OF ARRAY
-- Build a flat skill table for co-workers to access job_titles, salary info and skills in one table.
-- This will help them to access the data easily and quickly without having to join multiple tables.

CREATE OR REPLACE TEMP TABLE job_skills_array AS
    SELECT 
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(sd.skills) AS skills_array
    FROM job_postings_fact as jpf
    LEFT JOIN skills_job_dim as sjd
    ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim as sd
    ON sd.skill_id = sjd.skill_id
    GROUP BY 
        ALL;                    -- This is specific to DUCKDB

-- From the perspective of a Data Analyst, analyze the median salary per skill

WITH flat_skills AS(
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM 
        job_skills_array 
)
SELECT 
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM 
    flat_skills
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY 
    skill
ORDER BY 
    median_salary
LIMIT 40;


                                -- FIANL EXAMPLE ON ARRAY OF STRUCT 
-- Build a flat skill and type table for co-worker to access job_titles, salary info, skills, and type in one table

SELECT 
    * 
FROM 
    skills_dim
LIMIT 40;

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
    SELECT 
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(
            STRUCT_PACK(
                skill_type := sd.type,
                skill_name := sd.skills
            )
        ) AS skills_type
    FROM job_postings_fact as jpf
    LEFT JOIN skills_job_dim as sjd
    ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim as sd
    ON sd.skill_id = sjd.skill_id
    -- WHERE job_title_short = 'Data Engineer'
    GROUP BY 
        ALL;    

-- From the perspective of a Data Analyst, analyze the median salary per type of skill

SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type AS skill_type,   -- To access value inside the struct
    UNNEST(skills_type).skill_name AS skill_name
FROM
    job_skills_array_struct;


WITH all_skills AS(
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type, 
        UNNEST(skills_type).skill_name AS skill_name
    FROM
        job_skills_array_struct
)
SELECT 
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM 
    all_skills
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY 
    skill_type
ORDER BY 
    median_salary;