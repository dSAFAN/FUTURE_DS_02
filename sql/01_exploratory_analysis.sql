SELECT
TOP 10 *
FROM dbo.raw_telco_churn;

GO

-- =========================================================================
-- MASTER TEMP TABLE: Build base dataset with integer churn flag for math
-- =========================================================================
IF OBJECT_ID('tempdb..#churn_base') IS NOT NULL 
    DROP TABLE #churn_base;
SELECT 
    customerID,
    Contract,
    InternetService,
    TechSupport,
    Dependents,
    SeniorCitizen,
    StreamingTV,
    CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS is_churned
INTO #churn_base
FROM 
    dbo.raw_telco_churn;

GO
-- =========================================================================
-- PILLAR : Core Infrastructure
-- Insight Target: Is our flagship product (Fiber) losing to competitors?
-- =========================================================================
SELECT 
    InternetService,
    COUNT(customerID) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(customerID) AS DECIMAL(5,2)) AS churn_rate_pct
FROM 
    #churn_base
GROUP BY 
    InternetService
ORDER BY 
    churn_rate_pct DESC;
GO
-- =========================================================================
-- PILLAR : The "Stickiness" Feature
-- Insight Target: Does the security ecosystem create customer loyalty?
-- =========================================================================
SELECT 
    TechSupport,
    COUNT(customerID) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(customerID) AS DECIMAL(5,2)) AS churn_rate_pct
FROM 
    #churn_base
GROUP BY 
    TechSupport
ORDER BY 
    churn_rate_pct DESC;
GO
-- =========================================================================
-- PILLAR : Demographics (Testing Senior Citizens)
-- Insight Target: Are older demographics more stable, or high flight risks?
-- =========================================================================
SELECT 
    SeniorCitizen,
    COUNT(customerID) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(customerID) AS DECIMAL(5,2)) AS churn_rate_pct
FROM 
    #churn_base
GROUP BY 
    SeniorCitizen
ORDER BY 
    churn_rate_pct DESC; 
GO
-- =========================================================================
-- PILLAR : Entertainment (Testing Streaming TV)
-- Insight Target: Does bundling TV with internet improve retention?
-- =========================================================================
SELECT 
    StreamingTV,
    COUNT(customerID) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(customerID) AS DECIMAL(5,2)) AS churn_rate_pct
FROM 
    #churn_base
GROUP BY 
    StreamingTV
ORDER BY 
    churn_rate_pct DESC; 

GO
-- =========================================================================
-- PILLAR : Financials (Price Sensitivity)
-- Insight Target: Are we simply pricing people out of our service?
-- =========================================================================
SELECT 
    Churn,
    COUNT(customerID) AS total_customers,
    CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) AS avg_monthly_bill
FROM 
    dbo.raw_telco_churn
GROUP BY 
    Churn;
GO
-- =========================================================================
-- ISOLATED CTE ANALYSIS: Billing Contracts
-- Insight Target: Identify the financial bleed in short-term vs long-term plans
-- =========================================================================
WITH silver_churn_contract AS (
    SELECT 
        customerID,
        Contract,
        CASE WHEN churn = 'Yes' THEN 1 ELSE 0 
        END AS is_churned 
    FROM 
        dbo.raw_telco_churn
)

SELECT 
    Contract,
    COUNT(customerID) AS total_customers, 
    SUM(is_churned) AS churned_customers, 
    CAST((SUM(is_churned) * 100.0 ) / COUNT(customerID) AS DECIMAL(5,2)) AS churn_rate_pct
FROM 
    silver_churn_contract
GROUP BY 
    Contract
ORDER BY 
    churn_rate_pct DESC;

GO

-- =========================================================================
-- ISOLATED CTE ANALYSIS: Cohort Retention (Tenure)
-- Insight Target: Map the customer survival curve to find onboarding failures
-- =========================================================================
WITH silver_churn_tenure AS (
    SELECT 
        customerID,
        tenure,
        CASE WHEN churn = 'Yes' THEN 1 ELSE 0 
        END AS is_churned, 
        CASE 
        WHEN tenure <= 6 THEN '0-6 Months'
        WHEN tenure > 6 AND tenure <= 12 THEN '6-12 Months'
        WHEN tenure > 12 AND tenure <= 24 THEN '1-2 Years'
        ELSE '2+ Years' 
    END AS tenure_bucket
    FROM 
        dbo.raw_telco_churn
)

SELECT 
    tenure_bucket,
    COUNT(customerID) AS total_customers, 
    SUM(is_churned) AS churned_customers, 
    CAST((SUM(is_churned) * 100.0 ) / COUNT(customerID) AS DECIMAL(5,2))  AS churn_rate_pct
FROM 
    silver_churn_tenure
GROUP BY 
    tenure_bucket
ORDER BY 
    churn_rate_pct DESC;
GO
-- =========================================================================
-- DEEP DIVE 1: Cross-Sectional Analysis (Product vs. Ecosystem)
-- Insight Target: Can Tech Support save our failing Fiber Optic product?
-- =========================================================================
SELECT 
    InternetService,
    TechSupport,
    COUNT(customerID) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(customerID) AS DECIMAL(5,2)) AS churn_rate_pct
FROM 
    #churn_base
WHERE 
    InternetService = 'Fiber optic' -- Isolating the problem child
GROUP BY 
    InternetService,
    TechSupport
ORDER BY 
    churn_rate_pct DESC;
GO
-- =========================================================================
-- DEEP DIVE 2: The "Doomsday" Segment (High-Risk Profile Identification)
-- Insight Target: What is the absolute worst-case intersection of variables?
-- Combining worst contract (Month-to-month) + worst product (Fiber) + high-risk demographic (Seniors)
-- =========================================================================
SELECT 
    Contract,
    InternetService,
    SeniorCitizen,
    COUNT(customerID) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(customerID) AS DECIMAL(5,2)) AS churn_rate_pct
FROM 
    #churn_base
WHERE 
    InternetService = 'Fiber optic' AND SeniorCitizen = 1
GROUP BY 
    Contract,
    InternetService,
    SeniorCitizen
ORDER BY 
    churn_rate_pct DESC;