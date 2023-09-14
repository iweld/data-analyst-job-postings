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

DROP TABLE IF EXISTS get_record_count;
CREATE TEMP TABLE get_record_count AS (
	SELECT
		count(*) AS record_count
	FROM
		data_analyst.jobs
);

SELECT * FROM get_record_count;

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

-- 3. How many records do not have any salary information and what is the percentage of records that do not have any salary information?

WITH get_totals_cte AS (
	SELECT
		(SELECT * FROM get_record_count) AS total_records,
		count(*) AS no_salary_count
	FROM
		data_analyst.jobs
	WHERE
		salary_standardized IS NULL
)
SELECT
	total_records AS total_record_count,
	no_salary_count,
	total_records - no_salary_count AS record_diff,
	round(100 * no_salary_count::numeric / total_records, 2) AS no_salary_percentage
FROM
	get_totals_cte;

-- Results:

/*

total_record_count|no_salary_count|record_diff|no_salary_percentage|
------------------+---------------+-----------+--------------------+
             28375|          23255|       5120|               81.96|
   
 */

-- 4. List basic salary statistics (mean, min, median...) for hourly rates and the specific shedule type.

WITH get_hourly_stats AS (
	SELECT
		CASE
			WHEN schedule_type = 'Contractor and Temp work' THEN 'Contractor'
			WHEN schedule_type = 'Full-time and Part-time' OR schedule_type = 'Full-time, Part-time, and Internship' THEN 'Full-time'
			WHEN schedule_type IS NULL THEN 'Uknown'
			ELSE schedule_type
		END AS hourly_rate_schedule_type,
		count(*) AS number_of_jobs,
		round(min(salary_hourly)::NUMERIC, 2) AS hourly_min,
		round(avg(salary_hourly)::NUMERIC, 2) AS hourly_avg,
		round(percentile_cont(0.25) WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS hourly_25_perc,
		round(percentile_cont(0.5) WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS hourly_median,
		round(percentile_cont(0.75) WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS hourly_75_perc,
		round(MODE() WITHIN GROUP (ORDER BY salary_hourly)::NUMERIC, 2) AS hourly_mode,
		round(max(salary_hourly)::NUMERIC, 2) AS hourly_max
	FROM
		data_analyst.jobs
	WHERE
		salary_hourly IS NOT NULL
	GROUP BY
		hourly_rate_schedule_type
)
SELECT
	hourly_rate_schedule_type,
	number_of_jobs,
	cast(hourly_min AS money) AS hourly_min,
	cast(hourly_avg AS money) AS hourly_min,
	cast(hourly_25_perc AS money) AS hourly_25_perc,
	cast(hourly_median AS money) AS hourly_median,
	cast(hourly_75_perc AS money) AS hourly_75_perc,
	cast(hourly_mode AS money) AS hourly_mode,
	cast(hourly_max AS money) AS hourly_max
FROM
	get_hourly_stats;

-- Results:

/*

hourly_rate_schedule_type|number_of_jobs|hourly_min|hourly_min|hourly_25_perc|hourly_median|hourly_75_perc|hourly_mode|hourly_max|
-------------------------+--------------+----------+----------+--------------+-------------+--------------+-----------+----------+
Contractor               |          2639|     $9.00|    $43.92|        $29.00|       $39.90|        $57.50|     $57.50|   $300.00|
Full-time                |           511|    $11.00|    $41.27|        $23.27|       $35.50|        $57.50|     $23.27|   $125.00|
Internship               |             3|    $21.00|    $22.17|        $21.75|       $22.50|        $22.75|     $21.00|    $23.00|
Part-time                |            50|    $12.00|    $43.27|        $25.00|       $31.50|        $56.13|     $30.00|   $112.50|
Uknown                   |             6|    $27.50|    $57.46|        $57.95|       $62.50|        $66.88|     $67.50|    $67.50|
       
 */

-- 5. List basic salary statistics (mean, min, median...) for yearly rates and the specific shedule type.

WITH get_yearly_stats AS (
	SELECT
		COALESCE(schedule_type, 'Unknown') AS yearly_rate_schedule_type,
		count(*) AS number_of_jobs,
		round(min(salary_yearly)::NUMERIC, 2) AS yearly_min,
		round(avg(salary_yearly)::NUMERIC, 2) AS yearly_avg,
		round(percentile_cont(0.25) WITHIN GROUP (ORDER BY salary_yearly)::NUMERIC, 2) AS yearly_25_perc,
		round(percentile_cont(0.5) WITHIN GROUP (ORDER BY salary_yearly)::NUMERIC, 2) AS yearly_median,
		round(percentile_cont(0.75) WITHIN GROUP (ORDER BY salary_yearly)::NUMERIC, 2) AS yearly_75_perc,
		round(MODE() WITHIN GROUP (ORDER BY salary_yearly)::NUMERIC, 2) AS yearly_mode,
		round(max(salary_yearly)::NUMERIC, 2) AS yearly_max
	FROM
		data_analyst.jobs
	WHERE
		salary_yearly IS NOT NULL
	GROUP BY
		schedule_type
)
SELECT
	yearly_rate_schedule_type,
	number_of_jobs,
	cast(yearly_min AS money) AS yearly_min,
	cast(yearly_avg AS money) AS yearly_min,
	cast(yearly_25_perc AS money) AS yearly_25_perc,
	cast(yearly_median AS money) AS yearly_median,
	cast(yearly_75_perc AS money) AS yearly_75_perc,
	cast(yearly_mode AS money) AS yearly_mode,
	cast(yearly_max AS money) AS yearly_max
FROM
	get_yearly_stats;

-- Results:

/*

yearly_rate_schedule_type|number_of_jobs|yearly_min|yearly_min |yearly_25_perc|yearly_median|yearly_75_perc|yearly_mode|yearly_max |
-------------------------+--------------+----------+-----------+--------------+-------------+--------------+-----------+-----------+
Contractor               |            51|$43,000.00| $96,318.82|    $75,250.00|   $90,000.00|   $110,000.00| $72,500.00|$175,000.00|
Full-time                |          1847|$29,289.84|$101,582.29|    $85,000.00|   $96,500.00|   $112,500.00| $96,500.00|$233,500.00|
Part-time                |             4|$37,300.00| $79,450.00|    $76,825.00|   $90,000.00|    $92,625.00| $90,000.00|$100,500.00|
       
 */

-- 6. List the top 5 most frequently required technical skills and the overall frequency percentage.

WITH get_skills AS (
	SELECT
		UNNEST(description_tokens) AS technical_skills
	FROM
		data_analyst.jobs
)
SELECT
	technical_skills,
	count(*) AS frequency,
	round(100 * count(*)::NUMERIC / (SELECT * FROM get_record_count), 2) AS freq_perc
FROM
	get_skills
GROUP BY
	technical_skills
ORDER BY
	frequency DESC
LIMIT 5;

-- Results:

/*

technical_skills|frequency|freq_perc|
----------------+---------+---------+
sql             |    14603|    51.46|
excel           |     9656|    34.03|
python          |     8091|    28.51|
power_bi        |     7971|    28.09|
tableau         |     7925|    27.93|
       
 */

-- 7. List the top 20 companies with the most job postings.

SELECT
	initcap(company_name) AS company_name,
	count(*) AS number_of_posts
FROM
	data_analyst.jobs
GROUP BY
	company_name
ORDER BY
	number_of_posts DESC
LIMIT 20;

-- Results:

/*

company_name                           |number_of_posts|
---------------------------------------+---------------+
Upwork                                 |           4459|
Walmart                                |            966|
Edward Jones                           |            755|
Corporate                              |            615|
Talentify.Io                           |            563|
Cox Communications                     |            517|
Dice                                   |            275|
Insight Global                         |            250|
Staffigo Technical Services, Llc       |            167|
Centene Corporation                    |            162|
Jobot                                  |            107|
Elevance Health                        |            104|
Harnham                                |             99|
Unitedhealth Group                     |             90|
State Of Missouri                      |             89|
General Dynamics Information Technology|             79|
Apex Systems                           |             77|
Mtc Holding Corporation                |             73|
Saint Louis County Clerks Office       |             73|
Sam'S Club                             |             72|
       
 */

-- 8. List the top 10 Job titles.

SELECT
	CASE
		WHEN 
			title LIKE '%sr%' 
			OR title LIKE '%iv%' 
			OR title LIKE '%senior data%' 
		THEN 'Senior Data Analyst'
		WHEN 
			title LIKE '%lead%' 
			OR title = 'data analyst 2'
			OR title LIKE '%iii%' 
			OR title LIKE '%ii%' 
		THEN 'Mid-Level Data Analyst'
		WHEN 
			title IN (
				'business intelligence analyst',
				'business analyst', 
				'business systems data analyst',
				'bi data analyst')
		THEN 'Business Data Analyst'
		WHEN 
			title = 'entry level data analyst' 
			OR title IN ( 
				'jr. data analyst', 
				'jr data analyst', 
				'data analyst i',
				'data analyst 1')
		THEN 'Junior Data Analyst'
		WHEN 
			title IN (
				'data analyst (remote)', 
				'data analyst - contract to hire',
				'data analyst - remote', 
				'remote data analyst',
				'data analyst - now hiring',
				'analyst',
				'data analysis')
		THEN 'Data Analyst'
		ELSE initcap(title)
	END AS job_titles,
	count(*) title_count
FROM
	data_analyst.jobs
GROUP BY
	job_titles
ORDER BY
	title_count DESC
LIMIT 10;

-- Results

/*

job_titles             |title_count|
-----------------------+-----------+
Senior Data Analyst    |       4555|
Data Analyst           |       3884|
Mid-Level Data Analyst |       2921|
Business Data Analyst  |        553|
Junior Data Analyst    |        365|
Data Scientist         |        270|
Marketing Data Analyst |        140|
Data Engineer          |        136|
Financial Data Analyst |        122|
Healthcare Data Analyst|         98|
       
 */

-- 9. List monthly job postings for the first 8 months of 2023 in chronological order.

WITH get_monthly_jobs AS (
	SELECT
		to_char(date_time, 'Month') AS job_month,
		count(*) AS job_count
	FROM
		data_analyst.jobs
	WHERE
		EXTRACT('year' FROM date_time) = 2023
	AND
		EXTRACT('month' FROM date_time) < 9
	GROUP BY
		job_month
)
SELECT
	job_month,
	job_count,
	round (100 * (job_count - LAG(job_count) OVER (ORDER BY to_date(job_month, 'Month'))) / LAG(job_count) OVER (ORDER BY to_date(job_month, 'Month'))::NUMERIC, 2) AS month_over_month
FROM
	get_monthly_jobs
ORDER BY
	to_date(job_month, 'Month');

/*

job_month|job_count|month_over_month|
---------+---------+----------------+
January  |     3682|                |
February |     2828|          -23.19|
March    |     2727|           -3.57|
April    |     2493|           -8.58|
May      |     2357|           -5.46|
June     |     2362|            0.21|
July     |     2560|            8.38|
August   |     3008|           17.50|
       
 */

-- 10. List the top 5 days with the highest number of job postings.

WITH get_day_count AS (
	SELECT
		date_time::date AS single_day,
		count(*) AS daily_job_count,
		DENSE_RANK() OVER (ORDER BY count(*) DESC) AS rnk
	FROM
		data_analyst.jobs
	GROUP BY
		date_time::date
	ORDER BY
		single_day
)
SELECT
	single_day,
	daily_job_count
FROM
	get_day_count
WHERE
	rnk < 6
ORDER BY
	rnk;

-- Results:

/*

single_day|daily_job_count|
----------+---------------+
2022-11-04|            279|
2022-12-29|            230|
2022-12-03|            165|
2022-12-20|            160|
2023-01-07|            158|
       
 */

-- 11. List the frequency of benefits listed in the extentions column.

WITH get_all_extensions AS (
	SELECT
		UNNEST(extensions) AS benefits,
		count(*) AS benefits_count
	FROM
		data_analyst.jobs
	GROUP BY
		benefits
)
SELECT
	benefits,
	benefits_count
FROM
	get_all_extensions
WHERE
	benefits IN ('Health insurance','Dental insurance','Paid time off')
ORDER BY
	benefits_count DESC;

-- Results:

/*

benefits        |benefits_count|
----------------+--------------+
Health insurance|          9907|
Paid time off   |          6563|
Dental insurance|          6354|
       
 */

-- 12. List the first 10 companies and the combination of benefits they provide.

DROP TABLE IF EXISTS company_benefits;
CREATE TEMP TABLE company_benefits AS (
	WITH get_all_extensions AS (
		SELECT
			data_job_id,
			company_name,
			UNNEST(extensions) AS benefits
		FROM
			data_analyst.jobs
	)
	SELECT
		data_job_id,
		initcap(company_name) AS company_name,
		array_agg(benefits) AS benefits
	FROM
		get_all_extensions
	WHERE
		benefits IN ('Health insurance','Dental insurance','Paid time off')
	GROUP BY 
		data_job_id,
		company_name
);

SELECT 
	company_name,
	benefits
FROM 
	company_benefits
LIMIT 10;

-- Results:

/*

company_name       |benefits                                               |
-------------------+-------------------------------------------------------+
Chloeta            |{"Health insurance","Dental insurance","Paid time off"}|
Atc                |{"Health insurance"}                                   |
Guidehouse         |{"Health insurance","Dental insurance"}                |
Anmed Health Llc   |{"Health insurance","Dental insurance"}                |
Coinbase           |{"Dental insurance","Health insurance","Paid time off"}|
Prime Team Partners|{"Dental insurance","Health insurance"}                |
Amplify            |{"Dental insurance","Health insurance","Paid time off"}|
Procter & Gamble   |{"Health insurance"}                                   |
Centene Corporation|{"Paid time off","Health insurance","Dental insurance"}|
Geha               |{"Dental insurance","Health insurance","Paid time off"}|
       
*/

-- 13. Using the current temp table list the first 10 companies and the combination of benefits they provide in a table format.

SELECT
	company_name,
	CASE
		WHEN ('Health insurance' = ANY(benefits)) = TRUE THEN 'Yes'
		ELSE 'No'
	END AS health_insurance,
	CASE
		WHEN ('Dental insurance' = ANY(benefits)) = TRUE THEN 'Yes'
		ELSE 'No'
	END AS dental_insurance,
	CASE
		WHEN ('Paid time off' = ANY(benefits)) = TRUE THEN 'Yes'
		ELSE 'No'
	END AS paid_time_off
FROM
	company_benefits;

-- Results:

/*

company_name       |health_insurance|dental_insurance|paid_time_off|
-------------------+----------------+----------------+-------------+
Chloeta            |Yes             |Yes             |Yes          |
Atc                |Yes             |No              |No           |
Guidehouse         |Yes             |Yes             |No           |
Anmed Health Llc   |Yes             |Yes             |No           |
Coinbase           |Yes             |Yes             |Yes          |
Prime Team Partners|Yes             |Yes             |No           |
Amplify            |Yes             |Yes             |Yes          |
Procter & Gamble   |Yes             |No              |No           |
Centene Corporation|Yes             |Yes             |Yes          |
Geha               |Yes             |Yes             |Yes          |
       
*/














