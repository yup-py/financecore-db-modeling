## Project Overview

This project focuses on the ETL (Extract, Transform, Load) process and Advanced SQL Analytics for FinanceCore SA, a banking institution. The goal is to process transaction data, detect anomalies, and provide business intelligence insights through a structured relational database and analytical views.

## Project Structure

* /data: financecore_clean.csv (Cleaned banking dataset).
* /docs: dbdiagram.png (ERD) and Decision.md (Justifications).
* /notebooks: financecore_sql_analysis.ipynb (Main pipeline).
* /sql: Scripts for table creation, constraints, and performance views.
* /requirements.txt: Project dependencies.

## Infrastructure & Setup

### 1. Database Model (Star Schema)

The database is normalized to 3NF to ensure data integrity and optimized query performance.

* Fact Table: transactions (Contains financial amounts and status).
* Dimension Tables: clients, agencies, products, categories, dim_date.

### 2. ETL Pipeline

* Extraction: Loading raw data from CSV using pandas.
* Transformation: Data cleaning, handling date formats, currency conversion, and anomaly detection.
* Loading: Automated insertion using SQLAlchemy with Upsert logic (ON CONFLICT DO UPDATE) to maintain data consistency and handle updates gracefully via a staging table (temp_transactions).

## SQL Analytics & KPIs

Advanced SQL features implemented in sql/performance.sql:

* Joins: A master view (vw_transactions_full) connecting all 6 tables for complete reporting.
* Aggregations: Monthly performance analysis by agency and product using GROUP BY and HAVING.
* Subqueries: Identifying high-risk clients with balances below the national average.
* CASE WHEN: Calculating the Default Rate (percentage of rejected transactions) per risk segment.
* KPI Views: Real-time dashboard metrics (Revenue, Average Basket, Anomaly Count, Active Clients) with formatted absolute values for clear reporting.

## Getting Started

To set up the environment and install the necessary libraries, follow these steps:

1. Create a Virtual Environment (Recommended):
   python -m venv venv
3. Activate the Environment:

   * Windows: venv\Scripts\activate
   * Mac/Linux: source venv/bin/activate
4. Install Required Libraries:
   Run the following command to install all dependencies listed in requirements.txt:
   pip install -r requirements.txt
   The core libraries included are:

   * pandas: For data manipulation and extraction.
   * sqlalchemy: For the SQL toolkit and Object Relational Mapper.
   * psycopg2-binary: The PostgreSQL adapter for Python.
   * python-dotenv: For managing database credentials via .env files.
5. Environment Configuration:
   Create a .env file in the root directory to store your credentials securely:
   DB_USER=your_db_username
   DB_PASSWORD=your_db_password
   DB_HOST=your_host_address
   DB_PORT=5432
   DB_NAME=your_database_name
6. Execution:
   Run the Jupyter Notebook in notebooks/ to initialize the database schema and process the data.

## Tech Stack

* Database: PostgreSQL.
* Language: Python (Pandas, SQLAlchemy).
* Environment: Jupyter Notebook / VS Code.
