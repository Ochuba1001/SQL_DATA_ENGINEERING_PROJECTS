# Exploratory Data Analysis With SQL: Job Market Analysis

![Project 1 Overview](../PROJECT%20_EDA_1/images/1_1_Project1_EDA.png)

## Project Overview

In this project, I used SQL to explore the job market for **remote Data Engineer** roles. The goal was to understand which technical skills employers are looking for, which skills are linked to higher salaries, and which skills are both in high demand and well paid.

This project helped me practice using SQL to answer real-world business questions with data.

---

## Executive Summary

The analysis focuses on three main questions:

* What are the most in-demand skills for remote Data Engineers?
* Which skills have the highest median salaries?
* Which skills offer the best combination of demand and salary?

To answer these questions, I wrote SQL queries that joined multiple tables, filtered data, grouped results, and calculated summary statistics.

---

## Problems & Context

Many people learning Data Engineering want to know which skills are worth learning. Some skills appear in many job postings, while others may offer higher salaries.

This project analyzes job posting data to help answer questions like:

* Which skills do employers request the most?
* Which skills are associated with higher salaries?
* Which skills are both popular and valuable?

The data comes from three tables:

* **job_postings_fact** – Contains job information such as job title, salary, and remote work status.
* **skills_job_dim** – Connects jobs to the skills required.
* **skills_dim** – Contains the names of the skills.

It analyzes a **data warehouse** built using a star schema design. The data warehouse structure consist of:

![Data Warehouse](/PROJECT%20_EDA_1/images/1_2_Data_Warehouse.png)

---

## Tech Stack

The following tools were used in this project:

* **SQL** – To write queries and analyze the data.
* **VS Code + DuckDB** – To run the SQL queries and terminal for DuckDB CLI.
* **Git & GitHub** – To store and share the project.

---

## Analysis Overview

### 1. Most In-Demand Skills

The first query finds the skills that appear most often in remote Data Engineer job postings.

[Top 10 Demanded Skills](/PROJECT%20_EDA_1/01_top_demanded_skills.sql)

* Filters for remote Data Engineer jobs.
* Joins the job and skill tables.
* Counts how many times each skill appears.
* Displays the top 10 skills.

---

### 2. Highest Paying Skills

The second query finds which skills have the highest median salary.

[Highest Paying Skills](/PROJECT%20_EDA_1/02_highest_paying_skills.sql)

* Calculates the median salary for each skill.
* Only includes skills that appear in more than 100 job postings.
* Sorts the results by salary from highest to lowest.

---

### 3. Best Skills Based on Demand and Salary

The final query combines demand and salary to identify valuable skills. It calculates:

[Most Optimal Skills](/PROJECT%20_EDA_1/03_most_optimal_skills.sql)

* **Demand Count** – The number of job postings requiring each skill.
* **Median Salary** – The middle salary value for each skill.
* **Log Demand** – A logarithmic value used to compare demand more easily.
* **Optimal Score** – A score that combines salary and demand to highlight skills that are both popular and well paid.

---

## SQL Skills Demonstrated

### Query Design & Optimization

Throughout this project, I practiced writing efficient SQL queries to retrieve and organize data. Key skills demonstrated include:

* Using `SELECT` to retrieve specific columns.
* Filtering data with `WHERE`.
* Combining multiple tables using `INNER JOIN`.
* Grouping records with `GROUP BY`.
* Filtering grouped results using `HAVING`.
* Sorting results with `ORDER BY`.
* Limiting output using `LIMIT`.
* Writing clear and readable SQL queries using table aliases.

### Data Analysis Techniques

This project also demonstrates how SQL can be used to analyze data and answer business questions by:

* Counting job postings using `COUNT()`.
* Calculating median salaries with `MEDIAN()`.
* Creating calculated metrics using mathematical functions such as `ROUND()` and `LN()`.
* Comparing skill demand across job postings.
* Analyzing salary trends for different technical skills.
* Combining salary and demand into an **Optimal Score** to identify the most valuable skills in the job market.
* Transforming raw data into meaningful insights to support data-driven decision-making.


