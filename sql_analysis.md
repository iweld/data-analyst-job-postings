# Data Analyst Job Postings

**Author**: Jaime M. Shaker <br />
**Email**: jaime.m.shaker@gmail.com <br />
**Website**: https://www.shaker.dev <br />
**LinkedIn**: https://www.linkedin.com/in/jaime-shaker/  <br />

**Dataset Created By**: Luke Barousse ([LinkedIn](https://www.linkedin.com/in/luke-b/) | [YouTube](https://www.youtube.com/@LukeBarousse))<br />
**Dataset**: [Data Analyst Job Postings [Pay, Skills, Benefits]](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search) <br />

## Introduction

This SQL project is based on [Data Analyst Job Postings [Pay, Skills, Benefits]](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search) dataset by [Luke Barousse](https://www.linkedin.com/in/luke-b/) hosted on [Kaggle](https://www.kaggle.com/).

This repository provides an SQL analysis of employment listings scraped from Google job search results. The dataset spans from November 4, 2022 through September 9, 2023 using PostgreSQL within a Docker container. 

The aim of this analysis is to gain insight into the skills that are frequently mentioned in the job descriptions, frequency of job postings and basic salary statistics.

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:

## SQL Analysis

**1.**  How many records does this table contain?

````sql
SELECT
	count(*) AS record_count
FROM
	data_analyst.jobs;
````

**Results:**

record_count|
------------|
28375|

**2.**  List the first six fields (columns) and description tokens for five random rows from this table.

````sql
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
````

**Results:**

data_job_id|idx |title                                                               |company_name      |job_location    |via         |description_tokens         |
-----------|----|--------------------------------------------------------------------|------------------|----------------|------------|---------------------------|
16014|1485|data analyst due diligence                                          |upwork            |anywhere        |upwork      |{excel}                    |
9161| 370|senior data analyst - cox business                                  |cox communications|midwest city, ok|ziprecruiter|{tableau,excel}            |
17520|2991|tableau developer/consultant to help develop and beautify dashboards|upwork            |anywhere        |upwork      |{tableau}                  |
3007| 920|quality assurance data analyst                                      |vets2industry     |united states   |bebee       |{sap,spreadsheet,r,airflow}|
15556|1027|need data scientist                                                 |upwork            |anywhere        |upwork      |{sql,git,docker,python}    |

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation: