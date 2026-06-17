# Customer Activity Analysis

## 📋 Project Description

This repository contains a comprehensive analysis of customer activity based on user account data, email interactions, user sessions, and geographic information.

The project uses SQL to combine account-related metrics and email marketing metrics across different time dimensions. The final result helps identify the most active countries, evaluate email engagement, and analyze customer behavior across regions.

---

## 🎯 Project Objectives

The main goals of this project are to:

* Analyze customer activity by country and date;
* Measure the number of created user accounts;
* Evaluate account verification and subscription status;
* Analyze email marketing performance;
* Track sent, opened, and clicked email messages;
* Rank countries by user activity and email communication volume;
* Identify the top-performing countries by key customer metrics.

---

## 🛠️ Technology Stack

* **SQL (Google BigQuery)** – data extraction and analysis;
* **Google BigQuery** – cloud data warehouse;
* **Common Table Expressions (CTEs)** – modular query structure;
* **UNION ALL** – combining metrics from different time axes;
* **Window Functions** – country ranking calculations;
* **PDF Reporting** – customer activity documentation.

---

## 📂 Project Structure

```text
Customer-Activity-Analysis/
├── README.md
├── analysis_of_user_activity.sql
└── Customer_activity.pdf
```

---

## 📊 Data Sources

The analysis uses the following tables:

| Table              | Description                                                                                     |
| ------------------ | ----------------------------------------------------------------------------------------------- |
| DA.account         | User account information, including send interval, verification status, and subscription status |
| DA.account_session | Relationship between user accounts and sessions                                                 |
| DA.session         | User session data and session dates                                                             |
| DA.session_params  | Session parameters, including country                                                           |
| DA.email_sent      | Sent email message data                                                                         |
| DA.email_open      | Opened email message data                                                                       |
| DA.email_visit     | Email click / visit data                                                                        |

---

## 📈 Key Metrics

The analysis calculates the following customer and email metrics:

### Account Metrics

* Number of created accounts;
* Number of verified accounts;
* Subscription status;
* Send interval preferences;
* Country-level account activity.

### Email Metrics

* Number of sent emails;
* Number of opened emails;
* Number of clicked emails;
* Email engagement by country;
* Email communication volume.

### Ranking Metrics

* Top countries by number of accounts;
* Top countries by number of sent emails;
* Top-10 countries by customer activity or email volume.

---

## ❓ Business Questions

This project aims to answer the following questions:

* Which countries have the highest number of created accounts?
* Which countries receive the highest number of email messages?
* How does email engagement vary across countries?
* What is the distribution of verified and unsubscribed users?
* Which markets show the highest customer activity?
* How can email marketing performance be analyzed by geography?

---

## 📊 SQL Analysis Overview

The SQL query is structured using several Common Table Expressions:

### 1. Account Data

Collects account-related metrics by date, country, send interval, verification status, and subscription status.

### 2. Email Metrics

Calculates email communication metrics, including sent, opened, and clicked messages. The query also calculates the actual email sent date based on the session date and email sending interval.

### 3. Union Data

Combines account metrics and email metrics into a unified dataset using `UNION ALL`. This approach allows the analysis to preserve different time axes:

* Account creation / session date;
* Email sent date.

### 4. Country Ranking

Aggregates total account and email metrics by country and ranks countries using `DENSE_RANK`.

### 5. Final Result

Combines detailed daily metrics with country-level rankings and keeps only the top 10 countries by account activity or email communication volume.

---

## 💡 Key Insights

The analysis provides insights into:

* Customer activity by geography;
* Top countries by account creation;
* Top countries by email communication volume;
* Email engagement patterns;
* User verification and subscription behavior;
* Regional customer activity trends.

---

## 🚀 Business Value

The results can help businesses:

* Identify the most active customer markets;
* Evaluate email marketing performance by country;
* Improve customer engagement strategies;
* Optimize email communication frequency;
* Analyze user verification and subscription behavior;
* Support data-driven marketing decisions.

---

## 📄 Documentation

The repository includes:

* **Customer_activity.pdf** – detailed report on customer activity analysis;
* **SQL query** – complete analytical workflow;
* **README** – project overview and documentation.

---

## 🎓 Skills Demonstrated

This project showcases practical experience in:

* SQL querying;
* Google BigQuery;
* Data aggregation;
* JOIN operations;
* Common Table Expressions (CTEs);
* UNION ALL;
* Window Functions;
* DENSE_RANK;
* Customer analytics;
* Email marketing analytics;
* Geographic analysis;
* Business reporting;
* Data storytelling.

---

## 📌 Conclusion

Customer Activity Analysis demonstrates how SQL can be used to combine customer account data, user sessions, and email marketing metrics into a unified analytical dataset. The project provides a clear overview of customer activity across countries and helps identify the most important markets by account creation and email communication volume.
