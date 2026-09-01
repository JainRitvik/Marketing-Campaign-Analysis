# Marketing-Campaign-Analysis

# Marketing Campaign Analysis

## Business Problem

A consumer business has been running multiple marketing campaigns across its customer base, but campaign performance has varied significantly.

The marketing team wants to understand:

* Which customer segments are most responsive to marketing campaigns?
* Which purchasing channels are associated with higher campaign response?
* Does customer spending behavior relate to campaign engagement?
* How has campaign performance changed across campaigns?
* Which customer segments should be prioritized in future campaigns?

The objective of this analysis was to use historical customer, purchasing, and campaign-response data to identify actionable patterns that could help the marketing team improve customer targeting and campaign effectiveness.

---

## My Approach

I approached this as a typical marketing analytics project, starting with data validation and cleaning before moving into exploratory analysis and dashboard development.

### 1. Data Validation & Cleaning

I loaded the customer-level dataset into **Snowflake** and performed data-quality checks to identify:

* Missing values
* Duplicate customer IDs
* Invalid income values
* Unusual birth years
* Invalid categorical values
* Date ranges and consistency
* Campaign-response data quality

The original data was preserved while analytical fields were created where appropriate for segmentation and reporting.

---

### 2. Customer & Campaign Analysis

Using **SQL**, I analyzed customer behavior across multiple dimensions, including:

* Campaign response rates
* Customer age groups
* Income segments
* Customer spending levels
* Preferred purchasing channel
* Education
* Country

I also compared response rates across the five historical campaigns and the latest campaign to identify changes in campaign performance.

---

### 3. Power BI Dashboard

I built an interactive **Power BI dashboard** to communicate the findings to a non-technical marketing audience.

The dashboard includes:

* Overall customer and response KPIs
* Campaign response-rate trend
* Overall response distribution
* Response rate by customer spending
* Response rate by preferred purchasing channel
* Customer response by education
* Income vs. total spending analysis
* Response rate by country
* Interactive customer segmentation filters

---

## Key Findings

### 1. Latest Campaign Showed Stronger Response

The latest campaign achieved a **14.91% response rate**, compared with response rates between **1.34% and 7.46%** across the previous campaigns.

This represents a substantial improvement in observed campaign response.

However, because the dataset does not contain a randomized control group, the analysis does **not establish that the latest campaign caused the improvement**.

---

### 2. High-Spending Customers Were Much More Responsive

Customer spending showed a strong relationship with campaign response.

| Customer Spending | Response Rate |
| ----------------- | ------------: |
| Under 250         |         8.66% |
| 250–750           |        12.24% |
| 750–1,500         |        16.01% |
| 1,500+            |        41.87% |

Customers spending 1,500+ had a response rate of **41.87%**, compared with **8.66%** among customers spending under 250.

This suggests that high-value customers may be an important segment for targeted marketing.

---

### 3. Catalog-Focused Customers Had the Highest Response

Customers were classified according to their dominant purchasing channel.

| Preferred Channel | Response Rate |
| ----------------- | ------------: |
| Catalog           |        34.31% |
| Web               |        20.93% |
| Store             |        10.73% |

Catalog-focused customers showed substantially higher campaign response than store-focused customers.

This suggests that purchasing behavior could be useful when defining future campaign audiences.

---

## Recommendations

Based on the analysis, I would recommend that the marketing team:

### 1. Prioritize high-value customers

Develop targeted campaigns for customers with higher historical spending, given their substantially higher observed response rates.

### 2. Investigate the latest campaign

Analyze what changed in the latest campaign — including offer, messaging, targeting, timing, and channel mix — to understand why response was substantially higher.

### 3. Leverage behavioral segmentation

Use purchasing behavior and customer value to create more targeted campaign audiences rather than treating the entire customer base uniformly.

### 4. Test campaign strategies

The observed differences should be followed by controlled **A/B testing** to determine whether changes in offers, messaging, or targeting actually cause higher conversion.

---

## Business Impact

The analysis provides the marketing team with a data-driven framework for identifying high-response customer segments and evaluating campaign performance.

Rather than simply measuring total campaign responses, the analysis focuses on **who responds, how they purchase, how much they spend, and how response varies across campaigns**.

This can support more targeted customer selection and more efficient allocation of future marketing efforts.

---

## Tools & Technologies

* **Snowflake** — Data storage, validation and SQL analysis
* **SQL** — Data cleaning, segmentation and campaign analysis
* **Power BI** — Interactive dashboard and data visualization

---

## Dataset

The dataset contains **2,240 customer records** with demographic information, purchasing behavior, website activity, campaign acceptance history, and customer engagement information.

### Main fields include:

* Customer ID
* Income
* Education
* Marital Status
* Customer enrollment date
* Product spending
* Web, catalog and store purchases
* Website visits
* Historical campaign responses
* Latest campaign response
* Country

---

## Project Structure

```text
marketing-campaign-analysis/
│
├── data/
│   └── marketing_campaign.csv
│
├── sql/
│   ├── 01_data_cleaning.sql
│   └── 02_campaign_analysis.sql
│
├── powerbi/
│   └── marketing_campaign_analysis.pbix
│
├── screenshots/
│   ├── campaign_overview.png
│   └── customer_insights.png
│
└── README.md
```

---

## Dashboard Preview

### Campaign Overview

*Add Campaign Overview screenshot here.*

### Customer Insights

*Add Customer Insights screenshot here.*
