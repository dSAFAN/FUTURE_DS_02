IF OBJECT_ID('vw_churndata_gold' , 'V') IS NOT NULL
	DROP VIEW vw_churndata_gold;
GO
CREATE VIEW vw_churndata_gold AS
SELECT
    customerID,
    TRIM(gender) AS gender,
    CASE WHEN SeniorCitizen = 1 THEN 'Yes' ELSE 'No' END AS SeniorCitizen,
    TRIM(Partner) AS Partner,
    TRIM(Dependents) AS Dependents,
    tenure,
    CASE 
        WHEN tenure <= 6 THEN '0-6 Months'
        WHEN tenure > 6 AND tenure <= 12 THEN '6-12 Months'
        WHEN tenure > 12 AND tenure <= 24 THEN '1-2 Years'
        ELSE '2+ Years' 
    END AS tenure_bucket,
    TRIM(PhoneService) AS PhoneService,
    TRIM(MultipleLines) AS MultipleLines,
    TRIM(InternetService) AS InternetService,
    TRIM(OnlineSecurity) AS OnlineSecurity,
    TRIM(OnlineBackup) AS OnlineBackup,
    TRIM(DeviceProtection) AS DeviceProtection,
    TRIM(TechSupport) AS TechSupport,
    TRIM(StreamingTV) AS StreamingTV,
    TRIM(StreamingMovies) AS StreamingMovies,
    TRIM(Contract) AS Contract,
    TRIM(PaperlessBilling) AS PaperlessBilling,
    TRIM(PaymentMethod) AS PaymentMethod,
    MonthlyCharges,
    CAST(NULLIF(TotalCharges, ' ') AS FLOAT) AS TotalCharges,
    Churn,
    CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS is_churned
FROM 
    dbo.raw_telco_churn;

