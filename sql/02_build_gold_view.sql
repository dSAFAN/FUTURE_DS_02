IF OBJECT_ID('vw_churndata_gold' , 'V') IS NOT NULL
	DROP VIEW vw_churndata_gold;
GO
CREATE VIEW vw_churndata_gold AS
SELECT 
    customerID,
    TRIM(gender) AS gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    CASE 
        WHEN tenure <= 6 THEN '0-6 Months'
        WHEN tenure > 6 AND tenure <= 12 THEN '6-12 Months'
        WHEN tenure > 12 AND tenure <= 24 THEN '1-2 Years'
        ELSE '2+ Years' 
    END AS tenure_bucket,
    TRIM(Contract) AS Contract,
    PaperlessBilling,
    TRIM(PaymentMethod) AS PaymentMethod,
    MonthlyCharges,
    CAST(NULLIF(TotalCharges, ' ') AS FLOAT) AS TotalCharges,
    Churn,
    CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS is_churned
FROM 
    dbo.raw_telco_churn;

