-- Data Validation --

SELECT COUNT(*)
FROM MARKETING_CAMPAIGN;

-- Undersatnding Columns and Data Types
DESCRIBE TABLE MARKETING_CAMPAIGN;

-- Checking for Duplicate ID's --
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_customers
FROM MARKETING_CAMPAIGN;

-- Checking for Missing Values --
SELECT
    COUNT(*) AS total_rows,
    COUNT(ID) AS id_present,
    COUNT(YEAR_BIRTH) AS year_birth_present,
    COUNT(EDUCATION) AS education_present,
    COUNT(MARITAL_STATUS) AS marital_status_present,
    COUNT(INCOME) AS income_present,
    COUNT(DT_CUSTOMER) AS date_present,
    COUNT(RECENCY) AS recency_present,
    COUNT(COUNTRY) AS country_present
FROM MARKETING_CAMPAIGN;

-- finding missing income rows --
SELECT *
FROM MARKETING_CAMPAIGN
WHERE INCOME IS NULL;

SELECT DISTINCT EDUCATION
FROM MARKETING_CAMPAIGN
ORDER BY EDUCATION;

SELECT DISTINCT MARITAL_STATUS
FROM MARKETING_CAMPAIGN
ORDER BY MARITAL_STATUS;

SELECT DISTINCT COUNTRY
FROM MARKETING_CAMPAIGN
ORDER BY COUNTRY;

SELECT 
    MARITAL_STATUS,
    COUNT(*) AS customer_count
FROM MARKETING_CAMPAIGN
GROUP BY MARITAL_STATUS
ORDER BY customer_count DESC;

-- Numerical Validation --
SELECT 
    MIN(YEAR_BIRTH) AS min_birth_year,
    MAX(YEAR_BIRTH) AS max_birth_year,
    COUNT(*) AS total_customers
FROM MARKETING_CAMPAIGN;

SELECT
    ID,
    YEAR_BIRTH,
    INCOME,
    EDUCATION,
    MARITAL_STATUS,
    DT_CUSTOMER
FROM MARKETING_CAMPAIGN
WHERE YEAR_BIRTH < 1920
ORDER BY YEAR_BIRTH;

SELECT
    MIN(INCOME) AS min_income,
    MAX(INCOME) AS max_income,
    COUNT_IF(INCOME <= 0) AS non_positive_income
FROM MARKETING_CAMPAIGN;

SELECT
    ID,
    YEAR_BIRTH,
    EDUCATION,
    MARITAL_STATUS,
    INCOME,
    COUNTRY
FROM MARKETING_CAMPAIGN
WHERE INCOME = 666666;

--Validating Campaign Fields --
SELECT
    COUNT_IF(ACCEPTEDCMP1 NOT IN (0,1)) AS cmp1_invalid,
    COUNT_IF(ACCEPTEDCMP2 NOT IN (0,1)) AS cmp2_invalid,
    COUNT_IF(ACCEPTEDCMP3 NOT IN (0,1)) AS cmp3_invalid,
    COUNT_IF(ACCEPTEDCMP4 NOT IN (0,1)) AS cmp4_invalid,
    COUNT_IF(ACCEPTEDCMP5 NOT IN (0,1)) AS cmp5_invalid,
    COUNT_IF(RESPONSE NOT IN (0,1)) AS response_invalid,
    COUNT_IF(COMPLAIN NOT IN (0,1)) AS complain_invalid
FROM MARKETING_CAMPAIGN;

-- Valdating Purchase and Household Numbers -- 
SELECT
    COUNT_IF(KIDHOME < 0) AS kidhome_negative,
    COUNT_IF(TEENHOME < 0) AS teenhome_negative,
    COUNT_IF(RECENCY < 0) AS recency_negative,
    COUNT_IF(MNTWINES < 0) AS wines_negative,
    COUNT_IF(MNTFRUITS < 0) AS fruits_negative,
    COUNT_IF(MNTMEATPRODUCTS < 0) AS meat_negative,
    COUNT_IF(MNTFISHPRODUCTS < 0) AS fish_negative,
    COUNT_IF(MNTSWEETPRODUCTS < 0) AS sweets_negative,
    COUNT_IF(MNTGOLDPRODS < 0) AS gold_negative,
    COUNT_IF(NUMDEALSPURCHASES < 0) AS deals_negative,
    COUNT_IF(NUMWEBPURCHASES < 0) AS web_negative,
    COUNT_IF(NUMCATALOGPURCHASES < 0) AS catalog_negative,
    COUNT_IF(NUMSTOREPURCHASES < 0) AS store_negative,
    COUNT_IF(NUMWEBVISITSMONTH < 0) AS visits_negative
FROM MARKETING_CAMPAIGN;

CREATE OR REPLACE TABLE MARKETING_CAMPAIGN_CLEAN AS

SELECT
    ID,

    CASE
        WHEN YEAR_BIRTH < 1920 THEN NULL
        ELSE YEAR_BIRTH
    END AS YEAR_BIRTH,

    EDUCATION,

    CASE
        WHEN MARITAL_STATUS IN ('Alone', 'Absurd', 'YOLO')
            THEN 'Unknown'
        ELSE MARITAL_STATUS
    END AS MARITAL_STATUS,

    CASE
        WHEN INCOME = 666666 THEN NULL
        ELSE INCOME
    END AS INCOME,

    KIDHOME,
    TEENHOME,
    DT_CUSTOMER,
    RECENCY,
    MNTWINES,
    MNTFRUITS,
    MNTMEATPRODUCTS,
    MNTFISHPRODUCTS,
    MNTSWEETPRODUCTS,
    MNTGOLDPRODS,
    NUMDEALSPURCHASES,
    NUMWEBPURCHASES,
    NUMCATALOGPURCHASES,
    NUMSTOREPURCHASES,
    NUMWEBVISITSMONTH,
    ACCEPTEDCMP3,
    ACCEPTEDCMP4,
    ACCEPTEDCMP5,
    ACCEPTEDCMP1,
    ACCEPTEDCMP2,
    RESPONSE,
    COMPLAIN,
    COUNTRY

FROM MARKETING_CAMPAIGN;

-- Verifying Cleaned table --
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_customers,
    COUNT_IF(INCOME IS NULL) AS missing_income,
    COUNT_IF(YEAR_BIRTH IS NULL) AS invalid_birth_years,
    COUNT_IF(MARITAL_STATUS = 'Unknown') AS unknown_marital_status
FROM MARKETING_CAMPAIGN_CLEAN;

-- Verifying Date Ranges --
SELECT
    MIN(DT_CUSTOMER) AS earliest_customer,
    MAX(DT_CUSTOMER) AS latest_customer
FROM MARKETING_CAMPAIGN_CLEAN;

-- Creating Analytical Fields --
CREATE OR REPLACE TABLE MARKETING_CAMPAIGN_ANALYTICS AS

SELECT
    *,
    
    2014 - YEAR_BIRTH AS AGE,

    MNTWINES
        + MNTFRUITS
        + MNTMEATPRODUCTS
        + MNTFISHPRODUCTS
        + MNTSWEETPRODUCTS
        + MNTGOLDPRODS AS TOTAL_SPENDING,

    NUMDEALSPURCHASES
        + NUMWEBPURCHASES
        + NUMCATALOGPURCHASES
        + NUMSTOREPURCHASES AS TOTAL_PURCHASES,

    ACCEPTEDCMP1
        + ACCEPTEDCMP2
        + ACCEPTEDCMP3
        + ACCEPTEDCMP4
        + ACCEPTEDCMP5 AS TOTAL_CAMPAIGNS_ACCEPTED

FROM MARKETING_CAMPAIGN_CLEAN;


-- we are finished with the data cleaning/validation part so lets start with our analysis --


-- Overall Campaign Response rate --
SELECT
    COUNT(*) AS total_customers,
    SUM(RESPONSE) AS responses,
    ROUND(SUM(RESPONSE) * 100.0 / COUNT(*), 2) AS response_rate_pct
FROM MARKETING_CAMPAIGN_ANALYTICS;

-- Now we check if the latest campaign is actually better or worse than the previous cama=paigns--

SELECT
    'Campaign 1' AS campaign,
    SUM(ACCEPTEDCMP1) AS accepted_customers,
    ROUND(SUM(ACCEPTEDCMP1) * 100.0 / COUNT(*), 2) AS acceptance_rate_pct
FROM MARKETING_CAMPAIGN_ANALYTICS

UNION ALL

SELECT
    'Campaign 2',
    SUM(ACCEPTEDCMP2),
    ROUND(SUM(ACCEPTEDCMP2) * 100.0 / COUNT(*), 2)
FROM MARKETING_CAMPAIGN_ANALYTICS

UNION ALL

SELECT
    'Campaign 3',
    SUM(ACCEPTEDCMP3),
    ROUND(SUM(ACCEPTEDCMP3) * 100.0 / COUNT(*), 2)
FROM MARKETING_CAMPAIGN_ANALYTICS

UNION ALL

SELECT
    'Campaign 4',
    SUM(ACCEPTEDCMP4),
    ROUND(SUM(ACCEPTEDCMP4) * 100.0 / COUNT(*), 2)
FROM MARKETING_CAMPAIGN_ANALYTICS

UNION ALL

SELECT
    'Campaign 5',
    SUM(ACCEPTEDCMP5),
    ROUND(SUM(ACCEPTEDCMP5) * 100.0 / COUNT(*), 2)
FROM MARKETING_CAMPAIGN_ANALYTICS

UNION ALL

SELECT
    'Latest Campaign',
    SUM(RESPONSE),
    ROUND(SUM(RESPONSE) * 100.0 / COUNT(*), 2)
FROM MARKETING_CAMPAIGN_ANALYTICS;

-- We find that the latest campaign has performed better than all the past campaigns --

-- nextwe try to find out what characteristics make a customer more likely to respond to the latest campaign --
-- Customer Segmentation --
SELECT
    CASE
        WHEN AGE < 30 THEN 'Under 30'
        WHEN AGE BETWEEN 30 AND 39 THEN '30-39'
        WHEN AGE BETWEEN 40 AND 49 THEN '40-49'
        WHEN AGE BETWEEN 50 AND 59 THEN '50-59'
        WHEN AGE >= 60 THEN '60+'
        ELSE 'Unknown'
    END AS age_group,

    COUNT(*) AS customers,
    SUM(RESPONSE) AS responses,

    ROUND(
        SUM(RESPONSE) * 100.0 / COUNT(*),
        2
    ) AS response_rate_pct

FROM MARKETING_CAMPAIGN_ANALYTICS

GROUP BY age_group

ORDER BY response_rate_pct DESC;

-- We find that age doesnt make a huge difference--

--segmenting by income --
SELECT
    CASE
        WHEN INCOME < 30000 THEN 'Under 30K'
        WHEN INCOME < 50000 THEN '30K-50K'
        WHEN INCOME < 75000 THEN '50K-75K'
        WHEN INCOME < 100000 THEN '75K-100K'
        WHEN INCOME >= 100000 THEN '100K+'
        ELSE 'Unknown'
    END AS income_group,

    COUNT(*) AS customers,
    SUM(RESPONSE) AS responses,

    ROUND(
        SUM(RESPONSE) * 100.0 / COUNT(*),
        2
    ) AS response_rate_pct

FROM MARKETING_CAMPAIGN_ANALYTICS

GROUP BY income_group

ORDER BY response_rate_pct DESC;

-- Response by marketing/purchase channel --
SELECT
    CASE
        WHEN NUMWEBPURCHASES >= NUMSTOREPURCHASES
             AND NUMWEBPURCHASES >= NUMCATALOGPURCHASES
            THEN 'Web'
        WHEN NUMSTOREPURCHASES >= NUMWEBPURCHASES
             AND NUMSTOREPURCHASES >= NUMCATALOGPURCHASES
            THEN 'Store'
        ELSE 'Catalog'
    END AS PREFERRED_CHANNEL,

    COUNT(*) AS CUSTOMERS,
    SUM(RESPONSE) AS RESPONSES,

    ROUND(
        SUM(RESPONSE) * 100.0 / COUNT(*),
        2
    ) AS RESPONSE_RATE_PCT

FROM MARKETING_CAMPAIGN_ANALYTICS

GROUP BY PREFERRED_CHANNEL

ORDER BY RESPONSE_RATE_PCT DESC;

-- Checking if customers who spend more are likely to respind --
SELECT
    CASE
        WHEN TOTAL_SPENDING < 250 THEN 'Under 250'
        WHEN TOTAL_SPENDING < 750 THEN '250-750'
        WHEN TOTAL_SPENDING < 1500 THEN '750-1500'
        ELSE '1500+'
    END AS spending_group,

    COUNT(*) AS customers,
    SUM(RESPONSE) AS responses,

    ROUND(
        SUM(RESPONSE) * 100.0 / COUNT(*),
        2
    ) AS response_rate_pct

FROM MARKETING_CAMPAIGN_ANALYTICS

GROUP BY spending_group

ORDER BY response_rate_pct DESC;


SELECT CURRENT_ACCOUNT_NAME(), CURRENT_REGION();