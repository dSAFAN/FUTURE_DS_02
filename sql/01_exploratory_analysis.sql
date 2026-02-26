SELECT
TOP 10 *
FROM dbo.raw_telco_churn

GO

-- CTE 1
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

-- CTE 2
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