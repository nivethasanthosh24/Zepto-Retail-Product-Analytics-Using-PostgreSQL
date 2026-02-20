
# 🛒 Zepto Retail Product Analytics Using PostgreSQL

📌 Overview

This project focuses on performing data exploration, cleaning, and business analytics on a retail product dataset (Zepto).
The analysis was conducted using PostgreSQL to extract meaningful insights related to pricing, discounts, inventory management, and revenue estimation.

The goal of this project is to demonstrate strong SQL skills and the ability to derive business insights from structured data.

## 📂 Dataset Description

The dataset contains product-level information including:

SKU ID

Category

Product Name

MRP (Maximum Retail Price)

Discount Percentage

Discounted Selling Price

Available Quantity

Product Weight (in grams)

Stock Status (In-stock / Out-of-stock)

Quantity

## 🛠 Tools & Technologies Used

PostgreSQL

SQL (DDL, DML, Aggregations, Window Functions)

Git & GitHub

## 🔎 Project Workflow

### 1️⃣ Database Setup

Created table structure using CREATE TABLE

Imported dataset into PostgreSQL

Defined appropriate data types

### 2️⃣ Data Exploration

Counted total records

Checked null values

Identified duplicate product names

Analyzed stock availability

Explored distinct product categories

### 3️⃣ Data Cleaning

Removed products with zero price

Converted price values from paise to rupees

Validated numeric fields

Ensured consistency in stock data

### 4️⃣ Business Analysis Queries

## Key analysis performed:

### 💰 Pricing & Discount Analysis

Top 10 products with highest discount percentage

Products with high MRP but low discount

Products offering best value (price per gram)

### 📦 Inventory Analysis

In-stock vs Out-of-stock comparison

Total inventory weight per category

Estimated revenue per category

High-value inventory products

### 📊 Category Performance

Average discount per category

Revenue contribution by category

Identification of high out-of-stock categories

### 📈 Key Insights Generated

Identified top discount-driven products.

Estimated potential revenue per category.

Detected pricing inefficiencies.

Evaluated inventory weight distribution.

Analyzed stock risk areas.

### 🧠 Advanced SQL Concepts Used

Aggregation functions (SUM, AVG, COUNT)

CASE statements

Subqueries

Window Functions (RANK, OVER)

Group By & Having

Views creation

Revenue estimation logic

## 🚀 How to Run This Project

Install PostgreSQL.

Create a new database.

Run the table creation script.

Import dataset (CSV file).

Execute SQL queries provided in the project file.

## 🎯 Project Highlights

✔ Real-world retail analytics use case
✔ Business-focused SQL queries
✔ Data cleaning and transformation
✔ Revenue and inventory intelligence
✔ Resume-ready SQL project

## 📌 Future Enhancements

Create Power BI dashboard for visualization

Add stored procedures

Implement indexing for performance optimization

Automate reporting using SQL views
