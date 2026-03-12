SELECT
    grade,
    COUNT(*) AS total_loans,
    AVG(interest_rate) AS avg_interest_rate,
    AVG(loan_amnt) AS avg_loan_amount,
    AVG(annual_inc) AS avg_annual_income
FROM {{ ref('stg_loans') }}
GROUP BY grade
ORDER BY grade