
SELECT
    job_id,
    salary_year_avg,
    Job_title,
    CASE
        WHEN job_title ILIKE '%Senior%' THEN 'senior position'
        WHEN job_title ILIKE '%Lead%' OR job_title ILIKE '%Manager%' THEN 'lead/manager position'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'junior/entry position'
        ELSE 'Not Specified'
    END AS experience_level,
     CASE
        WHEN job_work_from_home = TRUE THEN 'Yes'
        WHEN job_work_from_home = FALSE THEN 'No'
        ELSE 'Not Specified'
    END AS remote_option

FROM 
    job_postings_fact

WHERE 
    salary_year_avg IS NOT NULL

ORDER BY
    salary_year_avg DESC;







/*
Write a query that lists all job postings with their job_id, salary_year_avg, 
and two additional columns using CASE WHEN statements called: experience_level a
nd remote_option. 
Use the job_postings_fact table.

For experience_level, categorize jobs based on keywords found in their titles (job_title) 
as 'Senior', 'Lead/Manager', 'Junior/Entry', or 'Not Specified'. Assume that certain 
keywords in job titles (like "Senior", "Manager", "Lead", "Junior", or "Entry") can 
indicate the level of experience required. ILIKE should be used in place of LIKE for this.
NOTE: Use ILIKE in place of how you would normally use LIKE ; ILIKE is a command in SQL, 
specifically used in PostgreSQL. It performs a case-insensitive search, similar to the 
LIKE command but without sensitivity to case.
For remote_option, specify whether a job offers a remote option as either 'Yes' or 'No', 
based on job_work_from_home column.
🔎 Hint:

Use CASE WHEN to categorize data based on conditions.
Look for specific words that indicate job levels, like "Senior", "Manager", "Lead", 
"Junior", or "Entry". Use ILIKE to ensure the search for keywords is not case-sensitive.
For the remote work option based on job_work_from_home column and look at the boolean 
value in this column.












SELECT
    COUNT(DISTINCT(
    CASE
        WHEN job_work_from_home = TRUE THEN company_id
    END))AS wfh_companies,
    COUNT(DISTINCT(
    CASE
        WHEN job_work_from_home = FALSE THEN company_id
    END)) AS non_wfh_companies

FROM 
    job_postings_fact;


/*

Count the number of unique companies that offer work from home (WFH) versus those 
requiring work to be on-site. 
Use the job_postings_fact table to count and compare the distinct companies based 
on their WFH policy (job_work_from_home).

🔎 Hint:

Use COUNT with DISTINCT to find unique values.
CASE WHEN statements to separate companies based on their WFH policy.
The data will be from the job_postings_fact table.



From the job_postings_fact table, categorize the salaries from job 
postings that are data analyst jobs and who have a yearly salary information. 
Put salary into 3 different categories:

If the salary_year_avg is greater than $100,000 then return ‘high salary’.
If the salary_year_avg is between $60,000 and $99,999 return ‘Standard salary’.
If the salary_year_avg is below $60,000 return ‘Low salary’.
Also order from the highest to lowest salaries.

🔎 Hint:

In SELECT retrieve these columns: job_id, job_title, salary_year_avg, and a new 
column for the salary category.
CASE Statement: use to categorize salary_year_avg into 'High salary', 'Standard salary', 
or 'Low salary'.
If the salary is over $100,000, it's a High salary.
For salaries between $60,000 and $99,999, assign Standard salary.
Any salary below $60,000 should be marked as Low salary.
FROM the job_postings_fact table.
WHERE statement
Exclude records without a specified salary_year_avg.
Focus on job_title_short that exactly matches 'Data Analyst'.
use ORDER BY to sort by salary_year_avg in descending order to start with the 
highest salaries first.







Label new column as follows:
-'Anywhere' jobs as 'Remote'
-'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'


A case expression in SQL is a way to apply conditional logic within your SQL queries. Like the IF statement.

SELECT
    CASE
        WHEN column_name = 'Value1' THEN 'Description for Value1'
        WHEN column_name = 'Value2' THEN 'Description for Value2'
        ELSE 'Other'
    END AS column_description
FROM
    table_name;

    CASE - begins the expression
    WHEN - specifies the condition(s) to look at
    THEN - what to do when the condition is TRUE
    ELSE - (optional) provides output if none of the WHEN conditions are met
    END - concludes the CASE expression.
