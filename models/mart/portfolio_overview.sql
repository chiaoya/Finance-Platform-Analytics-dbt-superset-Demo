SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amnt) AS total_loan_volume,
    AVG(loan_amnt) AS avg_loan_amount,
    AVG(interest_rate) AS avg_interest_rate,
    AVG(annual_inc) AS avg_annual_income
FROM {{ ref('stg_loans') }}