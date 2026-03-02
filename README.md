# Telco Customer Churn & Retention Strategy
**End-to-End Data Analytics Project | SQL Server & Power BI**

## 📌 Project Overview
The objective of this project is to diagnose and solve a critical business problem: customer abandonment (churn). By engineering a raw telco database using SQL and visualizing the insights in Power BI, this project identifies the exact demographics, infrastructure failures, and pricing gaps causing customers to leave, and provides data-backed recommendations to stabilize revenue.

## 📊 Executive Summary
The baseline customer churn rate sits at an unhealthy **26.54%**. An in-depth analysis reveals that this bleed is not evenly distributed across the company. It is highly concentrated within our premium infrastructure and specific demographic cohorts. However, the data also clearly identifies operational "safety nets" that can immediately halt this attrition.

## 💡 Key Business Insights

1. **The Infrastructure Bleed:** Our flagship Fiber Optic network is failing to retain customers. Despite being the premium offering, it has a churn rate of **41.89%**, more than double the churn of our legacy DSL network (18.96%).
2. **The Tech Support Safety Net:** Tech Support is the ultimate retention lever. Customers without Tech Support churn at an alarming **41.64%**, while customers equipped with it drop to a highly stable **15.17%**.
3. **The "Doomsday" Cohort:** The highest risk profile in the entire database is Senior Citizens on Month-to-Month Fiber Optic plans. This specific isolated group abandons the service at a staggering rate of **57.86%**.
4. **The Price Gap:** Customers who leave are paying an average of $74/month—$13 more than our retained customer base ($61/month), indicating a severe price-to-value mismatch.

## 🚀 Strategic Recommendations

* **Mandatory Tech Support Bundling:** Immediately bundle 6 months of complimentary Tech Support with all new Fiber Optic activations to artificially create ecosystem "stickiness."
* **Audit the Fiber Network:** A 42% churn rate on a premium product indicates failing infrastructure. Initiate an urgent engineering audit on Fiber Optic reliability and conduct a competitor pricing analysis.
* **Incentivize Annual Contracts:** Month-to-month contracts carry a 42.71% churn rate, dropping drastically to 11.27% on a 1-year agreement. Shift marketing spend to aggressively offer first-month discounts to transition M2M customers into 1-year commitments.

## 🗂️ Repository Navigation (For Technical Reviewers)
* **`/reports`**: Contains the interactive Power BI dashboard (`.pbix`) and the static Executive PDF export.
* **`/notebooks`**: Contains the Jupyter Notebook detailing the Exploratory Data Analysis (EDA), SQL logic, and mathematical proofs.
* **`/sql`**: Contains the raw T-SQL scripts used to clean, transform, and aggregate the database into analytics-ready Gold views.
* **`/data`**: Contains the raw dataset.

## 🛠️ Tech Stack Used
* **Database & Processing:** Microsoft SQL Server (T-SQL, CTEs, Temp Tables, Views)
* **Data Visualization:** Power BI (DAX, Cross-filtering, UI/UX Design)
* **Documentation:** Jupyter Notebooks & Markdown