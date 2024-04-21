


WITH CTE_Q1_jobs AS (
    SELECT job_id, job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM march_jobs
    ),
    CTE_month_skill_demand AS (
    SELECT
        skills.skills,
        EXTRACT(YEAR FROM CTE_Q1_jobs.job_posted_date) AS year,
        EXTRACT(MONTH FROM CTE_Q1_jobs.job_posted_date) AS month,
        COUNT(CTE_Q1_jobs.job_id) AS post_count
    FROM CTE_Q1_jobs
            INNER JOIN skills_job_dim ON CTE_Q1_jobs.job_id = skills_job_dim.job_id
            INNER JOIN skills_dim AS skills ON skills_job_dim.skill_id = skills.skill_id
    GROUP BY skills.skills, year, month
    )
    SELECT
        skills,
        year,
        month,
        post_count
    FROM CTE_month_skill_demand 
    ORDER BY skills, month, year

/*
Analyze the monthly demand for skills by counting the number of job postings for each skill in 
the first quarter (January to March), utilizing data from separate tables for each month. 
Ensure to include skills from all job postings across these months. 
The tables for the first quarter job postings were created in the Advanced Section - 
Practice Problem 6 [include timestamp of Youtube video].

🔎 Hints:

Use UNION ALL to combine job postings from January, February, and March into a consolidated dataset.
Apply the EXTRACT function to obtain the year and month from job posting dates, even though the 
month will be implicitly known from the source table.
Group the combined results by skill to summarize the total postings for each skill across 
the first quarter.
Join with the skills dimension table to match skill IDs with skill names.





SELECT
    Q1_jobs.job_id,
    Q1_jobs.job_title_short,
    Q1_jobs.salary_year_avg,
    Q1_jobs.job_location,
    Q1_jobs.job_via,
    skills.skills,
    skills.type
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS Q1_jobs    LEFT JOIN skills_job_dim ON Q1_jobs.job_id = skills_job_dim.job_id
                LEFT JOIN skills_dim AS skills ON skills_job_dim.skill_id = skills.skill_id
WHERE Q1_jobs.salary_year_avg > 70000
ORDER BY
    Q1_jobs.job_id

Retrieve the job id, job title short, job location, job via, skill and skill 
type for each job posting from the first quarter (January to March). 
Using a subquery to combine job postings from the first quarter (these tables were created 
in the Advanced Section - Practice Problem 6 [include timestamp of Youtube video]) 
Only include postings with an average yearly salary greater than $70,000.

🔎 Hints:

Use UNION ALL to combine job postings from January, February, and March into a single dataset.
Apply a LEFT JOIN to include skills information, allowing for job postings without associated 
skills to be included.
Filter the results to only include job postings with an average yearly salary above $70,000.


(
SELECT -- AS with_salary   --Gets job info for postings with salary 
    job_id,
    job_title,
    'With Salary Info' AS salary_info -- custom field indicating salary info presence
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
)
UNION ALL
(
SELECT -- AS without_salary   --Gets job info for postings without salary 
    job_id,
    Job_title,
    'Without Salary Info' AS salary_info -- custom field indicating salary info presence
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NULL AND salary_hour_avg IS NULL
)
ORDER BY 
    job_id


Create a unified query that categorizes job postings into two groups: those with salary information 
(salary_year_avg or salary_hour_avg is not null) and those without it. 
Each job posting should be listed with its job_id, job_title, and an indicator of whether salary 
information is provided.

🔎 Hints:

Use UNION ALL to merge results from two separate queries.
For the first query, filter job postings where either salary field is not null to identify postings 
with salary information.
For the second query, filter for postings where both salary fields are null to identify postings 
without salary information.
Include a custom field to indicate the presence or absence of salary information in the output.
When categorizing data, you can create a custom label directly in your query using string literals, 
such as 'With Salary Info' or 'Without Salary Info'. These literals are manually inserted values that 
indicate specific characteristics of each record. An example of this is as a new column in the query 
that doesn’t have salary information put: 'Without Salary Info' AS salary_info. As the last column in 
the SELECT statement.


SELECT *
FROM january_jobs;

SELECT *
FROM february_jobs;

SELECT *
FROM march_jobs;

SELECT --Get jobs and companies from January
    job_title_short,
    company_id,
    job_location
FROM january_jobs
UNION ALL --Combines january_jobs and february_jobs
SELECT --Get jobs and companies from February
    job_title_short,
    company_id,
    job_location
FROM february_jobs
UNION ALL --combines additional column
SELECT --Get jobs and companies from March
    job_title_short,
    company_id,
    job_location
FROM march_jobs


SELECT
    skills,
    type
FROM
    skills_dim


SELECT  
    job_id,
    EXTRACT(QUARTER FROM job_posted_date) AS job_post_quarter
FROM 
    job_postings_fact


SELECT --Get basic info from the quarter1_job_postings table
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
SELECT * --Combines job posting tables from the first quarter of 2023 (Jan-Mar)
FROM january_jobs
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT *
FROM march_jobs
) AS quarter1_job_postings
WHERE 
    quarter1_job_postings.salary_year_avg > 70000  --Filters job postings with an average yearly salary > 70,000
    AND quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC

Find job postings from the first quarter that have a salary greater than 70,000
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Get job postings with an average yearly salary > 70,000

Get the corresponding skill and skill tyoe for each job posting in q1
Include those without any skills too
WHY? Look at the skills and the type for each job in the first quarter that has a salary > $70,000



 UNION Operators
 Combine result sets of two or more SELECT statements into a single result set.
    UNION: Remove duplicate rows
    UNION ALL: Includes all duplicates rows

NOTE: Each SELECT statement within the UNION must have the same number of columns in the result sets with same/similar data types.

UNION
SELECT column_name
FROM table_one

UNION --combines two tables

SELECT column_name
FROM table_two;

    Gets rid of duplicate rows (unlike UNION ALL)
    all rows are unique

UNION ALL 

SELECT column_name
FROM table_one

UNION ALL --combine the two tables

SELECT column_name
FROM table_two;

    Returns all rows, even duplicates (unlike UNION)
    mostly used as it gets all data
