
SELECT -- Gets the individual skills per job id
    job_id,
    skills_job_dim.skill_id,
    skills
FROM 
    skills_dim 
    INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    job_id
LIMIT 10000


SELECT --Gets the total number of skills per job ID
    job_id,
    COUNT(skills)
FROM 
    skills_dim 
    INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY job_id
ORDER BY
    job_id
LIMIT 10000



SELECT  --Gets the company and the combined unique skills it requires their job postings
    DISTINCT (skills),
    name    
FROM 
    company_dim
    INNER JOIN job_postings_fact ON job_postings_fact.company_id = company_dim.company_id 
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE name = 'Asana'
ORDER BY name
LIMIT 10000


SELECT  --Get the list of jobIDs per company
    company_dim.company_id,
    company_dim.name,
    job_postings_fact.job_id
FROM 
    company_dim 
    INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
ORDER BY company_id
LIMIT 10000



SELECT  --counts the number of job opennings (by jobIDs) per company
    company_dim.company_id,
    company_dim.name,
    COUNT(job_postings_fact.job_id) AS num_Of_job_openings
FROM 
    company_dim 
    INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
GROUP BY company_dim.company_id
ORDER BY num_Of_job_openings DESC
LIMIT 10000



SELECT --Gets all skills required per job ID
    job_postings_fact.job_id,
    skills_dim.skill_id,
    skills_dim.skills
FROM 
    skills_dim 
    INNER JOIN skills_job_dim  ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
ORDER BY job_id
LIMIT 10000



SELECT --Gets job IDs with No skills listed
    job_postings_fact.job_id,
    skills_dim.skill_id,
    skills_dim.skills
FROM 
    skills_dim 
    RIGHT JOIN skills_job_dim  ON skills_dim.skill_id = skills_job_dim.skill_id
    RIGHT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE skills_dim.skill_id IS NULL
ORDER BY job_id



SELECT -- Gets the avg salary per skill 
    skills_dim.skills,
    AVG(job_postings_fact.salary_year_avg) AS avg_skill_salary
FROM 
    skills_dim 
    INNER JOIN skills_job_dim  ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY avg_skill_salary DESC



SELECT -- Gets the avg salary per company 
    company_dim.name,
    AVG(job_postings_fact.salary_year_avg) AS avg_skill_salary
FROM 
    company_dim 
    INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
WHERE job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY company_dim.name
ORDER BY avg_skill_salary DESC



SELECT -- Gets the salary listed per company
    company_dim.name, -- use company_id
    job_postings_fact.salary_year_avg AS salary
FROM 
    company_dim 
    INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
WHERE job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY company_dim.name



SELECT  --Gets the company and the combined unique skills it requires their job postings
    DISTINCT (skills),
    name,
    (SELECT -- Gets the avg salary per skill 
        --skills_dim.skills,
        AVG(job_postings_fact.salary_year_avg) AS avg_skill_salary
    FROM 
        skills_dim 
        INNER JOIN skills_job_dim  ON skills_dim.skill_id = skills_job_dim.skill_id
        INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skills)  AS avg_salary_per_skill
    --ORDER BY avg_skill_salary DESC)    
FROM 
    company_dim
    INNER JOIN job_postings_fact ON job_postings_fact.company_id = company_dim.company_id 
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
--WHERE name = 'Emprego'
ORDER BY name
LIMIT 10000
   




SELECT -- Gets the avg salary per skill 
    skills_dim.skills,
    AVG(job_postings_fact.salary_year_avg) AS avg_skill_salary
FROM 
    skills_dim 
    INNER JOIN skills_job_dim  ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
--WHERE job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
--ORDER BY skills_dim.skills



WITH CTE_total_req_skills AS (
SELECT  --Gets the total number of unique skills it requires for all job postings per company
    COUNT(DISTINCT skills_job_dim.skill_id) AS unique_skill_count, --AS total_req_skills, -- use the skill_id instead of skill name for 3 tables instead of 4
    company_dim.company_id    
FROM 
    company_dim
    LEFT JOIN job_postings_fact ON job_postings_fact.company_id = company_dim.company_id 
    LEFT JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
GROUP BY company_dim.company_id --use company_id
),
CTE_max_salary AS (
SELECT -- Gets the MAX salary listed per company
    job_postings_fact.company_id,
    MAX(job_postings_fact.salary_year_avg) AS highest_avg_salary--AS max_salary
FROM 
    job_postings_fact
WHERE job_postings_fact.job_id IN (
                                    SELECT job_id
                                    FROM skills_job_dim)
GROUP BY job_postings_fact.company_id
)
SELECT  --Gets the company and the combined unique skills it requires their job postings
    company_dim.name,
    CTE_total_req_skills.unique_skill_count,
    CTE_max_salary.highest_avg_salary
FROM 
    company_dim
    LEFT JOIN CTE_total_req_skills ON company_dim.company_id = CTE_total_req_skills.company_id 
    LEFT JOIN CTE_max_salary ON company_dim.company_id  = CTE_max_salary.company_id    
ORDER BY CTE_max_salary.highest_avg_salary






/*

Calculate the number of unique skills required by each company. 
Aim to quantify the unique skills required per company and identify which of these 
companies offer the highest average salary for positions necessitating at least one skill. 
For entities without skill-related job postings, list it as a zero skill requirement and 
a null salary. Use CTEs to separately assess the unique skill count and the maximum 
average salary offered by these companies.

🔎 Hints:

Use two CTEs.
The first should focus on counting the unique skills required by each company.
The second CTE should aim to find the highest average salary offered by these companies.
Ensure the final output includes companies without skill-related job postings. 
This involves use of LEFT JOINs to maintain companies in the result set even if they 
don't match criteria in the subsequent CTEs.
After creating the CTEs, the main query joins the company dimension table with the results 
of both CTEs.


-- gets average job salary for each country
WITH country_sal_avg AS (
    SELECT
        job_country,
        AVG(salary_year_avg) AS avg_country_salary   
    FROM job_postings_fact
    --WHERE salary_year_avg IS NOT NULL
    GROUP BY job_country
)

SELECT  -- Gets basic job data
    jpf.job_id,
    c.name,
    jpf.job_title,
    --jpf.job_country,
    jpf.salary_year_avg,
    CASE  -- categorizes the salary as above or below average the average salary for the country
        WHEN jpf.salary_year_avg < country_sal_avg.avg_country_salary THEN 'Below Average'
        WHEN jpf.salary_year_avg > country_sal_avg.avg_country_salary THEN 'Above Average'
        Else 'Average'
    END AS salary_category,
    EXTRACT(MONTH FROM jpf.job_posted_date) AS job_post_month -- gets the numerical month of the job posting date
    
FROM 
    job_postings_fact AS jpf
    INNER JOIN company_dim AS c ON jpf.company_id = c.company_id
    INNER JOIN country_sal_avg ON jpf.job_country = country_sal_avg.job_country
WHERE salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC

   

  

Explore job postings by listing job id, job titles, company names, and their average 
salary rates, while categorizing these salaries relative to the average in their 
respective countries. 
Include the month of the job posted date. Use CTEs, conditional logic, and date functions, 
to compare individual salaries with national averages.

🔎 Hints:

Define a CTE to calculate the average salary for each country. This will serve as a foundational dataset for comparison.
Within the main query, use a CASE WHEN statement to categorize each salary as 'Above Average' or 'Below Average' 
based on its comparison (>) to the country's average salary calculated in the CTE.
To include the month of the job posting, use the EXTRACT function on the job posting date within your SELECT statement.
Join the job postings data (job_postings_fact) with the CTE to compare individual salaries to the average. 
Additionally, join with the company dimension (company_dim) table to get company names linked to each job posting.







WITH unique_job_count AS (
    SELECT
        DISTINCT(job_title) AS unique_job,
        company_id
    FROM job_postings_fact
    ORDER BY company_id
)
SELECT  
    c.name,
    COUNT(unique_job) AS num_of_jobs
FROM company_dim AS c
JOIN unique_job_count ON c.company_id = unique_job_count.company_id
GROUP BY c.name
ORDER BY num_of_jobs DESC
LIMIT 10



Identify companies with the most diverse (unique) job titles. 
Use a CTE to count the number of unique job titles per company, then select companies with the highest diversity in job titles.

🔎 Hints:

Use a CTE to count the distinct number of job titles for each company.
After identifying the number of unique job titles per company, join this result with the company_dim table to get the company names.
Order your final results by the number of unique job titles in descending order to highlight the companies with the highest diversity.
Limit your results to the top 10 companies. This limit helps focus on the companies with the most significant diversity in job roles. 
Think about how SQL determines which companies make it into the top 10 when there are ties in the number of unique job titles.






SELECT
    company_dim.name
FROM company_dim 
    INNER JOIN (
        SELECT
            company_id,
            AVG(salary_year_avg) AS avg_salary
        FROM job_postings_fact       
        GROUP BY company_id
    ) AS company_salaries ON company_dim.company_id = company_salaries.company_id
WHERE company_salaries.avg_salary > (
    SELECT
        AVG(salary_year_avg)
    FROM job_postings_fact
);

SELECT
    c.company_id,
    c.name,
    jpf.salary_year_avg
FROM job_postings_fact AS jpf
WHERE salary_year_avg > avg_salary
 




Find companies that offer an average salary above the overall average yearly salary 
of all job postings. Use subqueries to select companies with an average salary higher 
than the overall average salary (which is another subquery).

🔎 Hints:

Start by separating the task into two main steps:
calculating the overall average salary
identifying companies with higher averages.
Use a subquery (subquery 1) to find the average yearly salary across all job postings. 
Then join this subquery onto the company_dim table.
Use another a subquery (subquery 2) to establish the overall average salary, which will 
help in filtering in the WHERE clause companies with higher average salaries.
Determine each company's average salary (what you got from the subquery 1) and compare 
it to the overall average you calculated (subquery 2). Focus on companies that greater 
than this average.






SELECT
    company_id,
    name,
    CASE
        WHEN job_posts_per_company < 10 THEN 'Small'
        WHEN job_posts_per_company BETWEEN 10 AND 50 THEN 'Medium'
        WHEN job_posts_per_company > 50 THEN 'Large'
        ELSE 'Other'
    END AS company_size
FROM (
SELECT 
    company.company_id,
    company.name,
    COUNT(job_id) AS job_posts_per_company
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS company ON company.company_id = jpf.company_id
GROUP BY 
    company.company_id,
    company.name
) AS company_job_count;

SELECT 
    job_id,
    jpf.company_id,
    company.name
FROM company_dim AS company
INNER JOIN job_postings_fact AS jpf ON company.company_id = jpf.company_id
ORDER BY jpf.company_id





Determine the size category ('Small', 'Medium', or 'Large') for each company by 
first identifying the number of job postings they have. 
Use a subquery to calculate the total job postings per company. 
A company is considered 'Small' if it has less than 10 job postings, 'Medium' if 
the number of job postings is between 10 and 50, and 'Large' if it has more than 50 
job postings. Implement a subquery to aggregate job counts per company before 
classifying them based on size.

🔎 Hints:

Aggregate job counts per company in the subquery. This involves grouping by company 
and counting job postings.
Use this subquery in the FROM clause of your main query.
In the main query, categorize companies based on the aggregated job counts from the 
subquery with a CASE statement.
The subquery prepares data (counts jobs per company), and the outer query classifies 
companies based on these counts.




SELECT 
    Count(jpf.job_id) skill_count,
    skills.skills AS skill_name

FROM
    skills_dim AS skills
    INNER JOIN skills_job_dim AS s ON skills.skill_id = s.skill_id
    INNER JOIN job_postings_fact AS jpf ON s.job_id = jpf.job_id

GROUP BY
    skill_name

ORDER BY 
    skill_count DESC

LIMIT 5


Identify the top 5 skills that are most frequently mentioned in job postings. 
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table 
and then join this result with the skills_dim table to get the skill names.

🔎 Hints:

Focus on creating a subquery that identifies and ranks (ORDER BY in descending order) 
the top 5 skill IDs by their frequency (COUNT) of mention in job postings.
Then join this subquery with the skills table (skills_dim) to match IDs to skill names.

WITH remote_job_skills AS (
SELECT  
    skill_id,
    COUNT(*) AS skill_count 
    
FROM skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
WHERE   job_work_from_home = TRUE AND job_title_short = 'Data Analyst'
GROUP BY skill_id

)

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count

FROM remote_job_skills
INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY skill_count DESC
LIMIT   5


WITH remote_job_skills AS (
SELECT  
    skill_id,
    COUNT(*) AS skill_count 
    
FROM skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
WHERE   job_work_from_home = TRUE AND job_title_short = 'Data Analyst'
GROUP BY skill_id

)

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count

FROM remote_job_skills
INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY skill_count DESC
LIMIT   5


Find the count of the number of remote job postings per skill
    - display the top 5 skills by their demand in remote jobs
    - include skill id, name, and count of postings requiring the skill




WITH company_job_count AS (
SELECT 
    company_id,
    COUNT(*) AS total_jobs
FROM job_postings_fact
GROUP BY
    company_id
)

SELECT 
    company_dim.name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count 
    ON company_dim.company_id = company_job_count.company_id
ORDER BY
    company_job_count.total_jobs DESC

Find the companies that have the most job openings. Count(company_id) FROM job_postings_fact
 - Get the total number of job postings per comany id GROUP BY name
 - return the total number of jobs with the company name JOIN jpf w/ company dim

 FROM company_dim 
    JOIN job_postings_fact 
    ON company_dim.company_id = job_postings_fact.company_id



SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = true

    ORDER BY
        company_id
    )

Common Table Expressions (CTEs): define a temporary result set that you can reference
    A temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement
    Defined with WITH at the begining of a query
    Exists only during execution of a query
    A defined query that can be referenced in the main query or other CTEs

WITH january_jobs AS ( --CTE definition starts here
    SELECT * 
    FROM job_posting_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) --CTE definition ends here

SELECT *
FROM january_jobs;

Subqueries: a query nested inside a larger query.
   - Can be used in SELECT, FROM, WHERE, or HAVING clauses.
   - Can be used in several places in the main query
   - It's executed first, and the results are passed to the outer query
   - Can be used when you want to perform a calculation before the main query can complete its calculation

SELECT *

FROM (--SubQuery starts here
    SELECT *
    FROM job_posting_fact
    WHERE EXtract(MONTH FROM job_posted_date) = 1) 
    AS january_jobs;
    --SubQuery ends here

SELECT *

FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 
) AS january_jobs;


Subqueries and CTEs Common Table Expressions are used for organizing and simplifying 
complex queries.
 - Helps break the query down into smaller, more manageable parts
 - Use:
    Subqueries for simpler queries
    CTEs for more complex quesries

