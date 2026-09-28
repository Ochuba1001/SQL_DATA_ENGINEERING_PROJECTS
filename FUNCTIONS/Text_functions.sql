/* There are six major types of text functions which are -Length & Count, -Case Conversion, -Concatenation, 
-Trimming, -Substring/Extraction, -Replacement. These functions are used to manipulate and analyze text data in SQL. Below is a brief overview of each type of text function:
1. Length & Count Functions: These functions are used to determine the length of a string or count the number of occurrences of a specific character or substring within a string. 
    Common functions include LENGTH(), CHAR_LENGTH(), and COUNT().
2. Case Conversion Functions: These functions are used to convert the case of text data. Common functions include UPPER(), LOWER(), and INITCAP().
3. Concatenation Functions: These functions are used to combine multiple strings into a single string. Common functions include CONCAT(), CONCAT_WS(), and the || operator.
4. Trimming Functions: These functions are used to remove leading and trailing spaces or specific characters from a string. Common functions include TRIM(), LTRIM(), and RTRIM().
5. Substring/Extraction Functions: These functions are used to extract a portion of a string based on specified starting and ending positions. 
    Common functions include SUBSTRING(), LEFT(), RIGHT(), and MID().
6. Replacement Functions: These functions are used to replace specific characters or substrings within a string with new values. Common functions include REPLACE() and TRANSLATE().
*/

-- Length & Count
SELECT LENGTH('SQL');
SELECT CHAR_LENGTH('SQL');

-- Case Conversion
SELECT UPPER('sql');
SELECT LOWER('SQL');

-- Concatenation
SELECT CONCAT('SQL', '-', 'Functions');
SELECT 'SQL' || '-' || 'Functions';

-- Extraction
SELECT LEFT('SQL Functions', 3);
SELECT RIGHT('SQL Functions', 9);

-- Substring
SELECT SUBSTRING('SQL Functions', 5, 3);

-- Trimming
SELECT TRIM('   SQL Functions   ');
SELECT LTRIM('   SQL Functions');
SELECT RTRIM('   SQL Functions   ');

-- Replacement
SELECT REPLACE('SQL Functions', 'Functions', 'Tutorial');
SELECT REGEXP_REPLACE('micheal_tutorial@gmail.com', '^.*(@)', '\1');


--          FINAL EXAMPLE 

WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM
        job_postings_fact
)
SELECT 
    job_title,
    CASE   
        WHEN job_title_clean LIKE '%data%' THEN 'Data'
        WHEN job_title_clean LIKE '%analyst%' THEN 'Analyst'
        WHEN job_title_clean LIKE '%engineer%' THEN 'Engineer'
        ELSE 'Other'
    END AS job_category
FROM 
    title_lower
ORDER BY RANDOM()
LIMIT 30;


WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM
        job_postings_fact
)
SELECT 
    job_title,
    CASE   
        WHEN job_title_clean LIKE '%data%' 
        AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
        AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        -- WHEN job_title_clean LIKE '%data%' THEN 'Data'
        -- WHEN job_title_clean LIKE '%analyst%' THEN 'Analyst'
        -- WHEN job_title_clean LIKE '%engineer%' THEN 'Engineer'
        ELSE 'Other'
    END AS job_category
FROM 
    title_lower
ORDER BY RANDOM()
LIMIT 30;