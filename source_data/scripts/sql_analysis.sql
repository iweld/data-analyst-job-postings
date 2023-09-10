/*
	Data Analyst Job Postings
	SQL Author: Jaime M. Shaker
	Dataset Creator: Luke Barousse (https://www.linkedin.com/in/luke-b/) (https://www.youtube.com/@LukeBarousse)
	Dataset Location: https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search
	Email: jaime.m.shaker@gmail.com or jaime@shaker.dev
	Website: https://www.shaker.dev
	LinkedIn: https://www.linkedin.com/in/jaime-shaker/
	
	File Name: sql_analysis.sql
	Description:  The aim of this analysis is to gain insight into the skills that are frequently mentioned in the 
	job descriptions, frequency of job postings and basic salary statistics.
*/


-- 1. How many records does this table contain?

SELECT
	count(*) AS record_count
FROM
	data_analyst.jobs;

-- Results

/*

record_count|
------------+
       28375|
   
 */

-- 2. List the first six fields (columns) and description tokens for five random rows from this table.

SELECT
	data_job_id,
	idx,
	title,
	company_name,
	job_location,
	via,
	description_tokens
FROM
	data_analyst.jobs
ORDER BY
	random()
LIMIT 5;

-- Results

/*

data_job_id|idx |title                                                               |company_name      |job_location    |via         |description_tokens         |
-----------+----+--------------------------------------------------------------------+------------------+----------------+------------+---------------------------+
      16014|1485|data analyst due diligence                                          |upwork            |anywhere        |upwork      |{excel}                    |
       9161| 370|senior data analyst - cox business                                  |cox communications|midwest city, ok|ziprecruiter|{tableau,excel}            |
      17520|2991|tableau developer/consultant to help develop and beautify dashboards|upwork            |anywhere        |upwork      |{tableau}                  |
       3007| 920|quality assurance data analyst                                      |vets2industry     |united states   |bebee       |{sap,spreadsheet,r,airflow}|
      15556|1027|need data scientist                                                 |upwork            |anywhere        |upwork      |{sql,git,docker,python}    |
       
 */



