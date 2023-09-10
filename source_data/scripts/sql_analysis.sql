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


-- How many records does this table contain?

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



