/*
	Data Analyst Job Postings
	SQL Author: Jaime M. Shaker
	Dataset Creator: Luke Barousse (https://www.linkedin.com/in/luke-b/) (https://www.youtube.com/@LukeBarousse)
	Dataset Location: https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search
	Email: jaime.m.shaker@gmail.com or jaime@shaker.dev
	Website: https://www.shaker.dev
	LinkedIn: https://www.linkedin.com/in/jaime-shaker/
	
	File Name: build_tables.sql
	Description:  This script will import data from the CSV files and create the 
	schema, tables and table relationships for this project.  Once it is complete, 
	it will drop any unecessary schemas and tables.
*/

-- Create an schema and table for importing data
DROP SCHEMA import_data CASCADE;
CREATE SCHEMA IF NOT EXISTS import_data;

/*
 *  Github only allows file sizes smaller than 100mb.  This dataset is at over 130mb on 2023-09-09.
 *  I split the CSV files into standard calendar quarters (Q1, Q2, Q3, Q4) for those that wish to use the CSV files on my repo.
 * 
 */

-- Import data from CSV files
-- Create Data Analyst Jobs Table
DROP TABLE IF EXISTS import_data.jobs;
CREATE TABLE import_data.jobs (
	data_job_id TEXT,
	idx TEXT,
	title TEXT,
	company_name TEXT,
	job_location TEXT,
	via TEXT,
	description TEXT,
	extensions TEXT,
	job_id TEXT,
	thumbnail TEXT,
	posted_at TEXT,
	schedule_type TEXT,
	work_from_home TEXT,
	salary TEXT,
	search_term TEXT,
	date_time TEXT,
	search_location TEXT,
	commute_time TEXT,
	salary_pay TEXT,
	salary_rate TEXT,
	salary_avg TEXT,
	salary_min TEXT,
	salary_max TEXT,
	salary_hourly TEXT,
	salary_yearly TEXT,
	salary_standardized TEXT,
	description_tokens TEXT,
	PRIMARY KEY (data_job_id)
);
-- gsearch_jobs 2022 CSV file.
COPY import_data.jobs (
	data_job_id,
	idx,
	title,
	company_name,
	job_location,
	via,
	description,
	extensions,
	job_id,
	thumbnail,
	posted_at,
	schedule_type,
	work_from_home,
	salary,
	search_term,
	date_time,
	search_location,
	commute_time,
	salary_pay,
	salary_rate,
	salary_avg,
	salary_min,
	salary_max,
	salary_hourly,
	salary_yearly,
	salary_standardized,
	description_tokens
)
FROM '/var/lib/postgresql/source_data/csv/gsearch_jobs_2022.csv'
WITH DELIMITER ',' HEADER CSV;

-- gsearch_jobs_2023_q1 CSV file.
COPY import_data.jobs (
	data_job_id,
	idx,
	title,
	company_name,
	job_location,
	via,
	description,
	extensions,
	job_id,
	thumbnail,
	posted_at,
	schedule_type,
	work_from_home,
	salary,
	search_term,
	date_time,
	search_location,
	commute_time,
	salary_pay,
	salary_rate,
	salary_avg,
	salary_min,
	salary_max,
	salary_hourly,
	salary_yearly,
	salary_standardized,
	description_tokens
)
FROM '/var/lib/postgresql/source_data/csv/gsearch_jobs_2023_q1.csv'
WITH DELIMITER ',' HEADER CSV;

-- gsearch_jobs_2023_q2 CSV file.
COPY import_data.jobs (
	data_job_id,
	idx,
	title,
	company_name,
	job_location,
	via,
	description,
	extensions,
	job_id,
	thumbnail,
	posted_at,
	schedule_type,
	work_from_home,
	salary,
	search_term,
	date_time,
	search_location,
	commute_time,
	salary_pay,
	salary_rate,
	salary_avg,
	salary_min,
	salary_max,
	salary_hourly,
	salary_yearly,
	salary_standardized,
	description_tokens
)
FROM '/var/lib/postgresql/source_data/csv/gsearch_jobs_2023_q2.csv'
WITH DELIMITER ',' HEADER CSV;

-- gsearch_jobs_2023_q3 CSV file.
COPY import_data.jobs (
	data_job_id,
	idx,
	title,
	company_name,
	job_location,
	via,
	description,
	extensions,
	job_id,
	thumbnail,
	posted_at,
	schedule_type,
	work_from_home,
	salary,
	search_term,
	date_time,
	search_location,
	commute_time,
	salary_pay,
	salary_rate,
	salary_avg,
	salary_min,
	salary_max,
	salary_hourly,
	salary_yearly,
	salary_standardized,
	description_tokens
)
FROM '/var/lib/postgresql/source_data/csv/gsearch_jobs_2023_q3.csv'
WITH DELIMITER ',' HEADER CSV;

-- Create working table with 'cleaned' data.

DROP SCHEMA IF EXISTS data_analyst CASCADE;
CREATE SCHEMA IF NOT EXISTS data_analyst;

-- Import data from CSV files
-- Create Data Analyst Jobs Table
DROP TABLE IF EXISTS data_analyst.jobs;
CREATE TABLE data_analyst.jobs (
	data_job_id int UNIQUE,
	idx int NOT NULL,
	title TEXT NOT NULL,
	company_name TEXT NOT NULL,
	job_location TEXT,
	via TEXT,
	description TEXT,
	extensions TEXT [],
	job_id TEXT,
	thumbnail TEXT,
	posted_at TEXT,
	schedule_type TEXT,
	work_from_home boolean,
	salary TEXT,
	search_term TEXT,
	date_time timestamp NOT NULL,
	search_location TEXT,
	commute_time TEXT,
	salary_pay TEXT,
	salary_rate TEXT,
	salary_avg NUMERIC,
	salary_min NUMERIC,
	salary_max NUMERIC,
	salary_hourly NUMERIC,
	salary_yearly NUMERIC,
	salary_standardized NUMERIC,
	description_tokens TEXT [],
	PRIMARY KEY (data_job_id)
);

INSERT INTO data_analyst.jobs (
	data_job_id,
	idx,
	title,
	company_name,
	job_location,
	via,
	description,
	extensions,
	job_id,
	thumbnail,
	posted_at,
	schedule_type,
	work_from_home,
	salary,
	search_term,
	date_time,
	search_location,
	commute_time,
	salary_pay,
	salary_rate,
	salary_avg,
	salary_min,
	salary_max,
	salary_hourly,
	salary_yearly,
	salary_standardized,
	description_tokens
) (
	SELECT
		data_job_id::int,
		idx::int,
		lower(trim(title)) AS title,
		lower(trim(company_name)) AS company_name,
		lower(trim(job_location)) AS job_location,
		-- Remove 'via ' from column 
		lower(trim(RIGHT(via, length(via) - 4))) AS via,
		-- Remove Pilcrow character and replace with newline
		trim(regexp_replace(description, E'[\\n]+', chr(13), 'g' )) AS description,
		-- Format to a proper PostgreSQL Array
		string_to_array(REGEXP_REPLACE(extensions, '[\[\]'']', '', 'g'), ', ') AS extensions,
		job_id,
		thumbnail,
		posted_at,
		schedule_type,
		upper(work_from_home)::boolean AS work_from_home,
		salary,
		search_term,
		date_time::timestamp,
		search_location,
		commute_time,
		salary_pay,
		salary_rate,
		salary_avg::NUMERIC,
		salary_min::NUMERIC,
		salary_max::NUMERIC,
		salary_hourly::NUMERIC,
		salary_yearly::NUMERIC,
		salary_standardized::NUMERIC,
		-- Format to a proper PostgreSQL Array
		string_to_array(REGEXP_REPLACE(description_tokens, '[\[\]'']', '', 'g'), ', ') AS description_tokens
	FROM
		import_data.jobs
);

-- Remove the posted_at value from the extensions column

UPDATE data_analyst.jobs
SET
	extensions = array_remove(extensions, posted_at);

-- Drop import schema and table

DROP TABLE import_data.jobs;
DROP SCHEMA import_data CASCADE;





