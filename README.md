# Data Analyst Job Postings (SQL Based)

**Author**: Jaime M. Shaker <br />
**Email**: jaime.m.shaker@gmail.com <br />
**Website**: https://www.shaker.dev <br />
**LinkedIn**: https://www.linkedin.com/in/jaime-shaker/  <br />

**Dataset Created By**: Luke Barousse ([LinkedIn](https://www.linkedin.com/in/luke-b/) | [YouTube](https://www.youtube.com/@LukeBarousse))<br />
**Dataset**: [Data Analyst Job Postings [Pay, Skills, Benefits]](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search) <br />

## Introduction

This SQL project is based on [Data Analyst Job Postings [Pay, Skills, Benefits]](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search) dataset by [Luke Barousse](https://www.linkedin.com/in/luke-b/) hosted on [Kaggle](https://www.kaggle.com/).

This repository provides an SQL analysis of employment listings scraped from Google job search results. The dataset spans from November 4, 2022 through September 9, 2023 using PosgreSQL within a Docker container. 

The goal of this analysis is to gain insight into the skills that are frequently mentioned in the job descriptions, frequency of job postings and basic salary statistics.

## SQL Analysis
- [SQL Analysis](./sql_analysis.md) (Markdown File)
- [Build SQL Tables](./source_data/scripts/build_tables.sql) (SQL File)
- [SQL Analysis](./source_data/scripts/sql_analysis.sql) (SQL File)

## Datasets
The complete, updated daily dataset can be found on [Kaggle](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search).  Github restricts file sizes to under 100mb.  Because of this restriction, I have split the current CSV (2022-11-04 through 2023-09-09)  into standard calendar quarters (Q1, Q2, Q3, Q4).

- <strong>gsearch_jobs_2022.csv</strong>: 
- <strong>gsearch_jobs_2023_q1.csv</strong>: (Jan/Feb/Mar 2023)
- <strong>gsearch_jobs_2023_q2.csv</strong>: (Apr/May/Jun 2023)
- <strong>gsearch_jobs_2023_q3.csv</strong>: (Jul/Aug/Sep 2023)

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:
