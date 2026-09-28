-- .read 'Batch_Pipeline_Processing\staging.priority_roles.sql'


CREATE OR REPLACE TABLE staging.priority_roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50),
    preferred_level INT
    );

INSERT INTO staging.priority_roles (role_id, role_name, preferred_level)
VALUES 
    (1, 'Data Engineer', 1),
    (3, 'Software Engineer', 2),
    (2, 'Data Analyst', 3),
    (4, 'Data Scientist', 1),
    (5, 'Data Architect', 2),
    (7, 'Business Intelligence Analyst', 3),
    (8, 'Database Administrator', 2),
    (9, 'DevOps Engineer', 2),
    (10, 'Cloud Solutions Architect', 1);

SELECT * 
FROM 
    staging.priority_roles;