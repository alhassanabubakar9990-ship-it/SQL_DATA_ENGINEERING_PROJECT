# 🔍 Exploratory Data Analysis w/ SQL: Job Market Analytics

![project 1 overview](image/1_1_Project1_EDA.png)


## EDA Project Overview

A SQL project analyzing the data engineer job market using real-world job posting data. It demonstrates my ability to write production-quality analytical SQL, design efficient queries, and turn business questions into data-driven insights.## 🧾 Executive Summary (For Hiring Managers)

## 🧾 Executive Summary (For Hiring Managers)

- ✅ **Project Scope:** Built three analytical SQL queries to answer key questions about the data engineer job market.
- ✅ **Data Modeling:** Used multi-table joins across fact and dimension tables to extract meaningful insights.
- ✅ **Analytics:** Applied filtering, aggregations, sorting, and grouping to identify high-demand and high-paying skills.
- ✅ **Outcome:** Produced actionable insights into SQL, Python, cloud technologies, and salary trends.

If you only have a minute, review these:


### Key SQL Files

1. [01_top_demanded_skills.sql](../1_EDA/01_top_demanded_skills.sql) – Demand analysis using multi-table joins.
2. [../02_top_paying_skills.sql](../1_EDA/02_top_paying_skills.sql) – Salary analysis using aggregations.
3. [03_optimal_skills.sql](../1_EDA/03_optimal_skills.sql) – Combines salary and demand to identify the most valuable skills.

## 🧩 Problem & Context

This project answers three important questions about the data engineering job market:

- 🎯 Which skills are most in demand?
- 💰 Which skills have the highest salaries?
- ⚖️ Which skills provide the best balance between demand and salary?

The analysis uses a data warehouse designed with a **Star Schema**, making it easy to perform analytical SQL queries.

![data werehouse](image/1_2_Project2_Data_Pipeline.png)

### Fact Table

- **job_postings_fact**
  - Stores job posting information such as:
    - Job title
    - Company
    - Salary
    - Location
    - Posting date
    ### Dimension Tables

- **company_dim**
  - Contains company information.

- **skills_dim**
  - Contains the list of technical skills.
  ### Bridge Table

- **skills_job_dim**
  - Connects job postings with skills.
  - Resolves the many-to-many relationship between jobs and skills.
  By joining these tables together, the project identifies:

- Skill demand
- Salary trends
- The most valuable skills for data engineers

## 🧰 Tech Stack

- 🐤 DuckDB – SQL query engine
- 🧮 SQL – Data analysis language
- 📊 Star Schema – Data warehouse model
- 🛠 VS Code – SQL editor
- 💻 Terminal – DuckDB CLI
- 📦 Git & GitHub – Version control

## 📂 Repository Structure

```
1_EDA/
├── 01_top_demanded_skills.sql
├── 02_top_paying_skills.sql
├── 03_optimal_skills.sql
└── README.md
```

## 🏗 Analysis Overview

## Query Structure

This project consists of three analytical SQL queries that examine the remote Data Engineer job market from different perspectives.

### 1. Top Demanded Skills
Identifies the **10 most in-demand skills** for remote Data Engineer positions by analyzing job posting frequency. This analysis highlights the technologies that employers value most when hiring remote Data Engineers.

### 2. Top Paying Skills
Analyzes the **25 highest-paying skills** by calculating both the median annual salary and the number of job postings associated with each skill. This helps identify technologies that offer the greatest earning potential.

### 3. Optimal Skills
Calculates an **Optimal Score** by combining the **natural logarithm (LN) of job demand** with the **median annual salary**. This approach balances salary potential with market demand to identify the most valuable skills for career growth.

---

## Key Insights

- 🧠 **Core Programming Languages:** SQL and Python each appear in approximately **29,000 job postings**, making them the two most in-demand skills for remote Data Engineers.
- ☁️ **Cloud Platforms:** AWS and Azure are essential technologies, reflecting the industry's continued migration to cloud-based data infrastructure.
- 🧱 **Infrastructure & DevOps:** Kubernetes, Docker, and Terraform are consistently associated with higher-paying positions, highlighting the value of infrastructure automation skills.
- 🔥 **Big Data Technologies:** Apache Spark remains one of the most sought-after big data frameworks due to its strong demand and competitive compensation.

---

## SQL Skills Demonstrated

### Query Design & Optimization

- **Complex Joins:** Performed multi-table `INNER JOIN` operations across `job_postings_fact`, `skills_job_dim`, and `skills_dim`.
- **Aggregations:** Used `COUNT()`, `MEDIAN()`, and `ROUND()` to generate statistical insights.
- **Filtering:** Applied `WHERE` clauses with multiple conditions such as `job_title_short`, `job_work_from_home`, and `salary_year_avg IS NOT NULL`.
- **Sorting & Limiting:** Ranked results using `ORDER BY` and `LIMIT` to identify the top-performing records.

### Data Analysis Techniques

- **Grouping:** Utilized `GROUP BY` to summarize job postings by skill.
- **Mathematical Functions:** Applied the `LN()` function to normalize job demand when calculating the Optimal Score.
- **Calculated Metrics:** Combined demand and salary into a single metric to rank the most valuable skills.
- **HAVING Clause:** Filtered aggregated results to include only skills appearing in at least 100 job postings.
- **NULL Handling:** Excluded incomplete salary records using `salary_year_avg IS NOT NULL`.

---

## Business Value

This project provides valuable insights for both aspiring and experienced Data Engineers by:

- Helping job seekers identify the most in-demand technical skills.
- Highlighting high-paying technologies to prioritize during learning.
- Demonstrating practical SQL techniques used in real-world data analysis.
- Supporting data-driven career decisions through market trend analysis.
- Showcasing advanced SQL skills for portfolio and professional development.
