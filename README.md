# Vendor Performance Analysis

## Project Overview

Vendor Performance Analysis is an end-to-end Data Analytics project designed to evaluate vendor sales, purchasing, profitability, freight costs, inventory movement, and product performance.

The project combines **Python/Jupyter Notebook, Microsoft SQL Server, SQL, and Power BI** to transform raw vendor data into business-focused insights and an interactive dashboard.

\---

## Business Objective

The main objective of this project is to analyze vendor and inventory performance and identify:

* High-performing and low-performing vendors
* Sales and purchase performance
* Gross profit and profit margins
* Vendor sales concentration
* Purchase and sales price relationships
* Freight cost impact
* Inventory movement and turnover
* High-value and potentially slow-moving inventory
* Brand-level sales and inventory efficiency
* Statistical relationships between key business metrics

\---

## Tools \& Technologies

* **Python**
* **Jupyter Notebook / JupyterLab**
* **Pandas**
* **NumPy**
* **Matplotlib**
* **Seaborn**
* **SciPy**
* **Scikit-learn**
* **SQL**
* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* **SQLAlchemy + PyODBC**
* **Microsoft Power BI**

\---

## Dataset

The project uses six CSV files:

|File|Description|
|-|-|
|`begin\_inventory.csv`|Beginning inventory information|
|`end\_inventory.csv`|Ending inventory information|
|`purchase\_prices.csv`|Product purchase-price and vendor information|
|`purchases.csv`|Purchase transactions|
|`sales.csv`|Sales transactions|
|`vendor\_invoice.csv`|Vendor invoice, freight, and payment information|

### Dataset Size

The notebook loaded the following records:

|Dataset|Rows|
|-|-:|
|begin\_inventory|206,529|
|end\_inventory|224,489|
|purchase\_prices|12,261|
|purchases|2,372,474|
|sales|12,825,363|
|vendor\_invoice|5,543|

\---

# Project Workflow

```text
Raw CSV Files
      ↓
Python / Pandas
      ↓
SQL Server (VendorPerformanceDB)
      ↓
SQL Analysis \& ETL
      ↓
Vendor Performance Dataset
      ↓
Python EDA \& Statistical Analysis
      ↓
Power BI Dashboard
      ↓
Business Insights
```

\---

# 1\. Data Ingestion

The six raw CSV files were loaded into Python using Pandas.

A SQLAlchemy engine was then created to connect Jupyter Notebook with Microsoft SQL Server.

### SQL Server Database

```text
Server: HIMANSHU\\SQLEXPRESS
Database: VendorPerformanceDB
Driver: ODBC Driver 18 for SQL Server
Authentication: Windows Trusted Connection
```

The six raw datasets were uploaded to SQL Server as tables:

* `begin\_inventory`
* `end\_inventory`
* `purchase\_prices`
* `purchases`
* `sales`
* `vendor\_invoice`

\---

# 2\. SQL Analysis

SQL was used for data validation, vendor-level aggregation, ETL, and business analysis.

Major SQL activities included:

* Table and column validation
* Row-count validation
* NULL-value checks
* Duplicate checks
* Vendor purchase aggregation
* Vendor sales aggregation
* Vendor invoice aggregation
* Vendor price analysis
* Vendor coverage analysis
* Inventory analysis
* Store-level inventory analysis
* Brand-level inventory and sales analysis
* Vendor performance aggregation

The SQL queries used during the project are preserved separately in:

```text
Vendor\_Performance\_Analysis.sql
```

\---

# 3\. Vendor Performance Dataset

A consolidated vendor-level analytical table was created:

```text
vendor\_performance
```

The final analytical dataset contains **123 vendors** and includes metrics such as:

* Vendor Number
* Vendor Name
* Total Purchase Quantity
* Total Purchase Dollars
* Average Purchase Price
* Total Purchase Orders
* Total Sales Quantity
* Total Sales Dollars
* Average Sales Price
* Unique Brands Sold
* Invoice Dollars
* Total Freight
* Invoice PO Count
* Average Listed Purchase Price
* Product Count
* Gross Profit
* Profit Margin Percentage
* Freight Percentage

\---

# 4\. Python Exploratory Data Analysis

Python was used for exploratory and statistical analysis.

The analysis included:

### Descriptive Analysis

* Dataset structure
* Summary statistics
* Distribution analysis
* Vendor performance metrics

### Outlier Analysis

* Boxplots
* IQR-based outlier detection

### Correlation Analysis

Relationships were examined between:

* Purchase Dollars and Sales Dollars
* Product Count and Sales Dollars
* Sales Dollars and Profit Margin
* Unique Brands and Sales Dollars
* Average Purchase Price and Average Sales Price
* Purchase Quantity and Sales Quantity
* Purchase Dollars and Freight

### Regression Analysis

A simple Linear Regression model was used to examine the relationship between:

```text
Product Count → Total Sales Dollars
```

The model achieved an R² of approximately **0.4243**.

\---

# 5\. Inventory Analysis

Inventory analysis was added to understand how inventory movement relates to business performance.

The analysis covered:

* Beginning inventory
* Ending inventory
* Inventory value
* Inventory value change
* Inventory turnover proxy
* Store-level inventory turnover
* Slow-moving stores
* High-value inventory
* Potential overstock
* Brand-level inventory movement
* Brand sales performance
* Inventory efficiency

The inventory turnover analysis is treated as a **proxy**, because formal accounting turnover based on COGS was not available in the dataset.

\---

# 6\. Statistical Analysis

Hypothesis testing and confidence intervals were performed using Python.

The analysis included:

* High-sales vs low-sales vendor profit margin comparison
* Welch's t-test
* 95% confidence interval for profit-margin differences
* Product Count vs Sales correlation test
* 95% confidence interval for Pearson correlation
* High-freight vs low-freight vendor comparison
* Welch's t-test
* 95% confidence interval for freight/profit-margin differences

These tests were used to determine whether observed differences and relationships were statistically supported by the available vendor-level data.

\---

# 7\. Power BI Dashboard

The final Power BI dashboard provides an interactive view of vendor performance.

### Dashboard Components

* KPI cards
* Top vendors by sales
* Top vendors by gross profit
* Sales vs purchase comparison
* Top vendors by sales contribution
* Monthly sales trend
* Vendor sales vs purchase scatter plot
* Vendor filtering
* Brand filtering
* Classification filtering

### Main KPIs

The dashboard includes:

* Total Sales
* Total Purchase
* Total Gross Profit
* Total Vendors
* Average Profit Margin

The Power BI dashboard is stored as:

```text
Dashboard.pbix
```

A PNG preview is also included:
<img width="1476" height="801" alt="Dashboard" src="https://github.com/user-attachments/assets/c360cca4-75a3-4857-9852-419fd25a3438" />


\---

# Key Findings

The analysis produced several important observations:

* The final vendor-level analytical dataset contains **123 vendors**.
* Total sales were approximately **$452.06M**.
* Total purchases were approximately **$321.90M**.
* The simplified sales-minus-purchase gross profit measure was approximately **$130.16M**.
* Average vendor profit margin was approximately **4.89%**.
* The correlation between vendor purchase dollars and sales dollars was approximately **0.9986**.
* Product count and sales dollars showed a positive relationship, with a correlation of approximately **0.6514**.
* The Product Count → Sales Dollars regression produced an R² of approximately **0.4243**.
* Inventory analysis identified differences in inventory movement and efficiency across stores and brands.
* Freight costs were strongly associated with purchase scale in the vendor-level data.

> Note: The project's simplified `GrossProfit` measure is calculated as Sales Dollars minus Purchase Dollars. It should not be interpreted as formal accounting gross profit because inventory movement and accounting COGS treatment are not fully represented.

\---

# Project Structure

```text
Vendor\_performance\_analysis/
│
├── begin\_inventory.csv
├── end\_inventory.csv
├── purchase\_prices.csv
├── purchases.csv
├── sales.csv
├── vendor\_invoice.csv
│
├── Vendor\_Performance\_Analysis.ipynb
├── Vendor\_Performance\_Analysis.sql
│
├── Dashboard.pbix
└── Dashboard.png
```

\---

# How to Use This Project

## 1\. Python / Jupyter Notebook

Open:

```text
Vendor\_Performance\_Analysis.ipynb
```

The notebook contains:

* Data loading
* SQL Server connection
* Data ingestion
* SQL analysis
* Exploratory data analysis
* Statistical analysis
* Inventory analysis

## 2\. SQL Server

Create or use the database:

```text
VendorPerformanceDB
```

The SQL queries used in the project are available in:

```text
Vendor\_Performance\_Analysis.sql
```

## 3\. Power BI

Open:

```text
Dashboard.pbix
```

The interactive dashboard was developed using Microsoft Power BI and connected to the SQL Server analytical data model used for the project.



Dashboard Preview



Power BI File



The complete interactive Power BI dashboard is available in:



Dashboard.pbix

\---

# Skills Demonstrated

This project demonstrates practical skills in:

* Data Cleaning
* Data Validation
* SQL
* SQL Server
* ETL
* Python
* Pandas
* Exploratory Data Analysis
* Statistical Analysis
* Hypothesis Testing
* Correlation Analysis
* Regression
* Inventory Analysis
* Business Intelligence
* Power BI
* Data Visualization
* Business Insight Generation

\---

# Project Outcome

This project demonstrates an end-to-end analytics workflow starting from raw transactional CSV data and progressing through:

**Data ingestion → SQL ETL → Data validation → Exploratory analysis → Statistical analysis → Business analysis → Power BI visualization.**

The final output is an interactive vendor performance dashboard supported by reproducible Python and SQL analysis.

