# ✈️ Airline Business Intelligence Dashboard

## 📌 Project Overview
This project presents an **end-to-end Airline Business Intelligence solution** built using **SQL and Power BI**.  
It integrates **flight operations data** with **customer loyalty data** to generate actionable insights for commercial, customer, and strategic decision-making.

The dashboard is designed to support airline stakeholders such as **Revenue Management, Marketing, and Leadership** by answering key business questions related to **passenger behavior, loyalty performance, and flight activity**.

---

## 🧩 Datasets Used

### 1. Flight Data
Contains aggregated flight activity by customer:
- `loyalty_number`
- `total_flights`
- `distance_flown`
- (Derived metrics used for frequency and performance analysis)

### 2. Customer Loyalty Data
Contains demographic and loyalty attributes:
- Gender, Province, City
- Education, Marital Status
- Loyalty Card Type
- Customer Lifetime Value (CLV)
- Customer Status (Active / Cancelled)

---

## 🛠️ Data Preparation & Feature Engineering

### Data Cleaning
- Standardized column names (lowercase)
- Fixed data types
- Loaded cleaned datasets into a relational database

### Missing Value Handling
- **Cancellation date missing values** treated as **Active customers**
- Created `customer_status` column (Active / Cancelled)
- **Salary imputed using education-wise median**
- Retained business meaning of missing values

---

## 📊 Business Questions Answered (via SQL)

- How many total flights and passengers are there by **gender and province**?
- Which provinces generate the **highest flight activity** by loyalty card type?
- How does average flight behavior vary by **education level and marital status**?
- Which gender contributes the most to overall flight volume?
- What is the distribution of **active vs cancelled customers** by gender and province?
- Which customer segments (education, loyalty card) generate the **highest CLV**?
- Which customer segments should be **prioritized for retention campaigns** based on flight frequency, CLV, and churn signals?

All questions are answered using **production-style SQL queries** with joins, aggregations, and window functions.

---

## 📈 Power BI Dashboard Overview

### Dashboard Title
**Airline Business Intelligence Dashboard**

### Key KPIs
- Total Flights
- Total Passengers
- Average Flights per Passenger
- Average Distance per Passenger

### Visual Insights
- Flights by Loyalty Card Type
- Flights by Education Level
- Unique Customers by Loyalty Card
- Unique Customers by Education Level
- Interactive slicers for:
  - Customer Status
  - Gender
  - Marital Status
  - Timeline filtering

The dashboard is designed for **executive readability** and **self-service exploration**.

---

## 🧠 Analytical Highlights

- Identified high-value loyalty segments driving disproportionate flight activity
- Revealed education-based differences in travel frequency
- Highlighted churn patterns across demographic and geographic segments
- Created retention priority segments using CLV and behavioral signals

---

## 🧪 Tools & Technologies
- **SQL (PostgreSQL-style)**
- **Power BI**
- Data modeling & feature engineering
- Business-focused analytics

---

## 🚀 Use Cases
- Executive performance monitoring
- Loyalty program optimization
- Customer retention strategy
- Commercial and marketing decision support

---

## 📎 Repository Structure
