# SQL-Business-Intelligence-Portfolio-E-Commerce-Retail-Analytics
Advanced PostgreSQL project demonstrating business intelligence (BI) reporting, customer segmentation, and relational data modeling. Features a deep-dive analysis of 500k+ e-commerce transactions and a custom bookstore management system.
# 📊 SQL Business Intelligence Portfolio
> **Transforming raw data into actionable business insights using PostgreSQL.**

This repository contains two major SQL projects designed to solve real-world business problems through data extraction, cleaning, and advanced analytical querying.

---

## 🚀 Project 1: Pakistan’s Largest E-Commerce Analysis
**Goal:** Analyze 500,000+ transaction records to optimize revenue and understand customer behavior.

### 🧠 Strategic Business Questions Addressed:
* **Financial Health:** Calculated Total Revenue (Gross Intake) and Average Order Value (AOV).
* **Customer Retention:** Identified "Power Users" (repeat buyers) for targeted loyalty marketing.
* **Inventory Velocity:** Ranked product categories by "Velocity" to identify fast-moving vs. stagnant stock.
* **Logistics & Health:** Analyzed the ratio of Completed vs. Canceled/Refunded orders.
* **Revenue Share:** Used **Window Functions** to calculate the percentage contribution of each category to total company revenue.

### 🛠️ Technical Skills Demonstrated:
* **Advanced Aggregations:** `GROUP BY`, `HAVING`, and `CAST` for financial precision.
* **Window Functions:** `RANK() OVER()` and `SUM() OVER()` for comparative analysis.
* **Data Cleaning:** Handled "Ghost Columns," filtered NULLs, and performed complex **Date Casting** (converting strings to `DATE` types).
* **CTEs & Subqueries:** Leveraged nested logic to compare individual transactions against store averages.

---

## 📚 Project 2: Relational Bookstore Management System
**Goal:** Design a relational database schema for a retail bookstore to manage inventory, customers, and sales.

### 🏗️ Database Architecture:
* **Relational Mapping:** Developed a 3-table schema (`Books`, `Customers`, `Orders`) with Primary and Foreign Key relationships.
* **Joins & Relationships:** Utilized `FULL JOIN` and `INNER JOIN` to connect sales volume to specific book genres and authors.

### 📈 Key Insights Generated:
* Identified the most frequently ordered titles and top-spending customers.
* Tracked inventory levels to highlight "Lowest Stock" items requiring immediate restock.
* Analyzed revenue trends by Genre (e.g., Fantasy vs. Fiction).

---

## 📂 Project Structure
* `/E-commerce_Analysis.sql`: Complete PostgreSQL script for the 500k+ transaction dataset.
* `/Bookstore_System.sql`: Schema design and retail analytics queries.
* `/Results/`: Screenshots of query outputs and data visualizations.

## 🛠️ Tools Used
* **Database:** PostgreSQL (pgAdmin 4)
* **Language:** SQL
* **Techniques:** Window Functions, Joins, Data Type Casting, Table Constraints.

## 💡 Key Takeaway
Through these projects, I demonstrated how SQL can be used to move beyond simple data retrieval and into **Business Intelligence**, providing stakeholders with the specific metrics needed to drive growth and operational efficiency.

---
**Contact:** [Your Name] | [Your LinkedIn Link]
