-- .read 'C:\Users\AI PLUG\Desktop\Data Engineer\SQL_DATA_ENGINEERING_PROJECTS\DDL VS DML\DDL_vs_DML.sql'   

/*
-- DML stands for Data Manipulation Language. It is used to manipulate data into tables. Keywords like INSERT, UPDATE, DELETE, MERGE are used to change or update data 
within an existing table
-- DDL stands for Data Definition Language. They are used to define and modify database structure and schema. It used keyword like ALTER, CREATE, DROP, TRUNCATE
-- DQL which is Data Query Language and they are commands that query and retrieve data from a table such as SELECT, WHERE, GROUP BY
Other query languages are:
-- DCL - Data Central Language 
-- TCL - Transaction Control Language
They are imperative to build out and create different databases, warehouses and even data-mart.
*/

                            -- CREATE VS DROP (Database, Schema, Table)
-- DROP is a very dangerous keyword and needs to be careful when using it.

-- CREATING DATABASE

SHOW DATABASES;

-- CREATE DATABASE jobs_mart;
CREATE DATABASE IF NOT EXISTS jobs_mart; -- It used in case not sure if the database exist

-- DROPPING A DATABASE
-- DROP DATABASE jobs_mart;
-- DROP DATABASE IF EXISTS jobs_mart;

-- CREATING SCHEMA 

SELECT * FROM information_schema.schemata; -- To see which schemas are available

CREATE SCHEMA IF NOT EXISTS jobs_mart.staging;

USE jobs_mart; -- It is used to change the schema you are working with 

-- DROPPING SCHEMA
-- DROP SCHEMA IF EXISTS staging;

-- CREATING/DROPPING TABLE
SHOW TABLES;

CREATE TABLE IF NOT EXISTS preferred_roles
(
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS staging.preferred_roles(
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50)
);

SELECT 
    *
FROM 
    information_schema.tables
WHERE 
    table_catalog = 'jobs_mart';
    

-- DROPPING TABLE
-- DROP TABLE IF EXISTS main.preferred_roles;


                                                        -- INSERTING DATA 
INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES 
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');

SELECT * 
FROM staging.preferred_roles;

-- ALTERING TABLE 
ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN; 

-- ALTER TABLE staging.preferred_roles
-- DROP COLUMN preferred_role; 

-- UPDATING DATA / TABLE
UPDATE staging.preferred_roles
SET 
    preferred_role = TRUE 
WHERE 
    role_id = 1 OR role_id = 2;

UPDATE staging.preferred_roles
SET 
    preferred_role = FALSE
WHERE
    role_id = 3;

-- RENAMING COLUMN AND TABLE
ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

SELECT * 
FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_levels;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_levels TYPE INT;

UPDATE staging.priority_roles
SET 
    priority_levels = 3
WHERE
    role_name = 'Software Engineer';

