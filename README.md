# Introduction

📊 Dive into the data job market! Focusing on data engineer roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data engineering.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data engineer job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs (data is taken from Luke Barousse SQL course, of data analytical jobs in 2023).

The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data engineer jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data engineers?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?


# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.


# The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

## 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data engineer positions by average yearly salary and location, focusing on remote jobs. This query highlights the top 10 high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short= 'Data Engineer' AND
    job_location= 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

```
Here's the breakdown of the top data engineer jobs in 2023:

- **Salary Range:** Top 10 paying data engineer roles span from $242,000 to $325,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like Engtal, Durlstone Partners, and Twitch are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Engineer to Director of Engineering, reflecting varied roles and specializations within data engineering.

![Top Paying Roles](assets\top_10_paying_d_e.png)

*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results.*

## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short= 'Data Engineer' AND
        job_location= 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
    )

select 
    top_paying_jobs.*,
    skills
from top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg desc;

```
Here's the breakdown of the most demanded skills for the top 10 highest paying data engineer jobs in 2023:
- **Python** leads with a count of 7
- **Spark** follows with a count of 5 
- **Hadoop, Kafka, Scala** on third place with a count of 3

![Skills Count for the Top 10 Paying Jobs](assets\most_frequent_skills_for_top_10.png)

*Bar graph visualizing the count of skills for the top 10 paying jobs for data engineers; ChatGPT generated this graph from my SQL query results.*

## 3. In-Demand Skills for Data Engineers
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

``` sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short= 'Data Engineer' 
    
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
The table below highlights the most in-demand skills for Data Engineer roles in 2023.
- **SQL** is the most sought-after skill, confirming its fundamental role in manipulating, managing and querying data in structured environments.
- **Python** is placed just below, and is one of the most used programming language for data engineering thanks to its flexibility, vast ecosystem of libraries (such as Pandas, PySpark) and applicability to data pipelines, automation and machine learning.
- Cloud skills such as **AWS and Azure** reflect the growing migration of data infrastructures towards cloud environments
- **Apache Spark** confirms itself as one of the main technologies for the distributed processing of large volumes of data


| Skill  | Demand Count |
|--------|--------------|
| SQL    | 113,375      |
| Python | 108,265      |
| AWS    | 62,174       |
| Azure  | 60,823       |
| Spark  | 53,789       |

*Table of the demand for the top 5 skills in data analyst job postings.*

## 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short= 'Data Engineer' 
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 10;
```
- **High-paying skills are not always the most common** – Technologies like Node, Mongo, and Solidity aren't among the top in demand but offer premium salaries, likely due to specialization and lower supply.

- **Cross-discipline tools stand out** – ggplot2 (a data visualization package from R) and Solidity (used in blockchain development) indicate that cross-functional or niche expertise can significantly boost salary potential for Data Engineers.

- **System-level and backend technologies pay well** – Skills like Ubuntu, Rust, Clojure, and Cassandra show that deep system knowledge and backend architecture proficiency are highly valued in complex data engineering roles.



| Skill      | Average Salary (\$) |
| ---------- | ------------------- |
| Node       | 181,862             |
| Mongo      | 179,403             |
| ggplot2    | 176,250             |
| Solidity   | 166,250             |
| Vue        | 159,375             |
| CodeCommit | 155,000             |
| Ubuntu     | 154,455             |
| Clojure    | 153,663             |
| Cassandra  | 150,255             |
| Rust       | 147,771             |



*Table of the average salary for the top 10 paying skills for data engineers.*

## 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id= skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE
    job_title_short= 'Data Engineer'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home= True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id)>10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 10;
```
| Skill         | Demand Count | Average Salary (\$) |
| ------------- | ------------ | ------------------- |
| Kubernetes    | 56           | 158,190             |
| NumPy         | 14           | 157,592             |
| Cassandra     | 19           | 151,282             |
| Kafka         | 134          | 150,549             |
| Go (Golang)   | 11           | 147,818             |
| Terraform     | 44           | 146,057             |
| Pandas        | 38           | 144,656             |
| Elasticsearch | 21           | 144,102             |
| Ruby          | 14           | 144,000             |

*Table of the most optimal skills for data analyst sorted by salary.*
Here's a breakdown of the most optimal skills for Data Engineers in 2023:
- **Cloud-native & streaming tools dominate** – Tools like Kubernetes, Kafka, and Terraform are at the intersection of DevOps and Data Engineering, reflecting modern infrastructure and real-time processing priorities.

- **Python ecosystem remains key** – NumPy and Pandas are foundational tools for data manipulation, showing that strong data wrangling skills are both in demand and well-compensated.

- **Versatile language knowledge pays off**– Skills like Go and Ruby suggest that language flexibility, especially in scalable systems and scripting, continues to add salary value for Data Engineers.


# What I learned
Throughout this project, I significantly advanced my SQL capabilities, equipping myself with a more powerful and versatile toolkit:

- **Complex Query Development:** Gained proficiency in writing advanced SQL queries, effectively joining multiple tables and leveraging WITH clauses for clean and modular temporary data structures.

- **Robust Data Aggregation:** Deepened my command of GROUP BY operations and aggregate functions such as COUNT() and AVG(), enabling efficient data summarization and analysis.

- **Analytical Problem Solving:** Strengthened my ability to translate real-world questions into insightful, actionable SQL queries —enhancing both the precision and clarity of my data-driven conclusions.



# Conclusion

1. **Top-Paying Data Engineer Roles:** The most lucrative data engineering positions in 2023 offer salaries up to $325,000, highlighting the earning potential of senior technical roles—especially those in remote or flexible settings.
2. **Skills for top paying jobs:** here's the breakdown of the most in-demand skills across the top 10 highest-paying data engineer roles:

- Python leads with a demand count of 7
- Spark follows closely with 5 mentions
- Hadoop, Kafka, Scala share third place with 3 each.
This clearly reflects industry preference for modern, scalable data processing technologies.

3. **Most Demanded Skills:** SQL is the most demanded skill in the data engineer job market, thus making it essential for job seekers.

4. **Top-Paying Skills by Average Salary:** Specialized skills such as Node.js, MongoDB, and ggplot2 command average salaries exceeding $175,000, indicating strong compensation incentives for niche or cross-functional expertise.

5. **High-Demand & High-Paying (Optimal) Skills:** Tools like Kubernetes, Kafka, and Terraform strike the ideal balance of market demand and high average salary—making them strategic investments for long-term career growth.


## Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data engineering job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data engineers can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
