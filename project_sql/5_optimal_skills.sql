/*
Answer: what are the most optimal skills to learn (high demand and high-paying)?
- Identify skills in high demand and associated with high average salaries for Data Engineer roles
- Concentrate on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
offering strategic insights f9r career development in data engineering
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short= 'Data Engineer' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home= True
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short= 'Data Engineer' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home= True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id= average_salary.skill_id
WHERE
    demand_count>10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;





-- Rewriting it more concisely
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
