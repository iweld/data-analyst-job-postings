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

-- Results:

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

-- Results:

/*

data_job_id|idx |title                                                               |company_name      |job_location    |via         |description_tokens         |
-----------+----+--------------------------------------------------------------------+------------------+----------------+------------+---------------------------+
      16014|1485|data analyst due diligence                                          |upwork            |anywhere        |upwork      |{excel}                    |
       9161| 370|senior data analyst - cox business                                  |cox communications|midwest city, ok|ziprecruiter|{tableau,excel}            |
      17520|2991|tableau developer/consultant to help develop and beautify dashboards|upwork            |anywhere        |upwork      |{tableau}                  |
       3007| 920|quality assurance data analyst                                      |vets2industry     |united states   |bebee       |{sap,spreadsheet,r,airflow}|
      15556|1027|need data scientist                                                 |upwork            |anywhere        |upwork      |{sql,git,docker,python}    |
       
 */

-- 3. List basic salary statistics (mean, min, median...) for hourly rates and the specific shedule type.

SELECT
	COALESCE(schedule_type, 'unknown') AS hourly_rate_schedule_type,
	count(*) AS number_of_jobs,
	round(min(salary_min)::NUMERIC, 2) AS min_salary,
	round(avg(salary_hourly)::NUMERIC, 2) AS avg_salary,
	round(percentile_cont(0.25) WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS perc_25_salary,
	round(percentile_cont(0.5) WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS median_salary,
	round(percentile_cont(0.75) WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS perc_75_salary,
	round(MODE() WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS mode_salary,
	round(max(salary_max)::NUMERIC, 2) AS max_salary
FROM
	data_analyst.jobs
WHERE
	salary_hourly IS NOT NULL
GROUP BY
	schedule_type;

-- Results:

/*

hourly_rate_schedule_type           |number_of_jobs|min_salary|avg_salary|perc_25_salary|median_salary|perc_75_salary|mode_salary|max_salary|
------------------------------------+--------------+----------+----------+--------------+-------------+--------------+-----------+----------+
Contractor                          |          2625|      8.00|     43.89|         29.00|        39.90|         57.50|      57.50|    500.00|
Contractor and Temp work            |            14|     12.00|     49.43|         27.25|        40.00|         59.00|      59.00|    180.00|
Full-time                           |           509|     10.00|     41.34|         23.27|        36.00|         57.50|      23.27|    150.00|
Full-time and Part-time             |             1|     18.33|     23.27|         23.27|        23.27|         23.27|      23.27|     28.20|
Full-time, Part-time, and Internship|             1|     18.46|     22.70|         22.70|        22.70|         22.70|      22.70|     26.93|
Internship                          |             3|     17.00|     22.17|         21.75|        22.50|         22.75|      21.00|     28.00|
Part-time                           |            50|     10.00|     43.27|         25.00|        31.50|         56.13|      30.00|    150.00|
                                    |             6|     25.00|     57.46|         57.95|        62.50|         66.88|      67.50|     75.00|
       
 */













