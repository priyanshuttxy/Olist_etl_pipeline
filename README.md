Olist E-commerce Analytics Pipeline

An end-to-end SQL-driven data warehousing and analytics pipeline built using the Olist public e-commerce dataset.
This project simulates how real companies ingest, clean, transform, and analyze daily transactional data for business decision-making.

Project Overview

This pipeline is designed to:

Ingest daily incremental Olist data via API

Store data in a PostgreSQL raw layer

Clean and structure data into a clean layer

Transform it into a business-ready star schema

Connect the business layer to Power BI dashboards for analytics

The goal is to demonstrate practical SQL, ETL design, and BI integration similar to real-world analytics systems.

Layers Explained
1. Raw Layer

Stores the original API data exactly as received.

Used for traceability and incremental ingestion.

2. Clean Layer

Cleans and standardizes data:

Handles missing values

Fixes data types

Establishes relationships across tables

3. Business Layer

Structured into a star schema for analytics.

Calculates important business metrics:

Sales performance

Customer behavior

Order and delivery KPIs

Key Features

Incremental ETL pipeline

SQL-based transformations in PostgreSQL

Star schema data warehouse design

Power BI dashboards for visualization

Realistic workflow used in analytics and data engineering roles

Tools & Technologies

Python – API ingestion and automation

PostgreSQL (PgAdmin) – Data storage and SQL transformations

SQL – Data cleaning and modeling

Power BI – Analytics and dashboard creation

Example Analytics Use Cases

Analyze daily revenue trends

Track customer purchase behavior

Measure delivery performance and delays

Identify top-performing products and sellers

Learning Outcomes

Through this project, I practiced:

Building industry-style ETL pipelines

Structuring and optimizing SQL data models

Designing analytics-ready star schema

Delivering insights through interactive BI dashboards
