/*
Trova la somma del n° di lavori da remoto per skill
- Mostra le top 5 skills per domanda nei lavori da remoto
- Includi skill ID, nome, conto dei lavori che richiedono la skill
- Per Data Analysts
*/

WITH remote_job_skills as (
    SELECT
    
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home =True AND
        job_postings.job_title_short= 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT 
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills On skills.skill_id= remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5
