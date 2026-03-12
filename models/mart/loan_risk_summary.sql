SELECT
    grade,
    loan_status,
    COUNT(*) AS loans,
    AVG(interest_rate) AS avg_interest,
    AVG(annual_inc) AS avg_income,
    AVG(loan_amnt) AS avg_loan_amount
FROM {{ ref('stg_loans') }}
GROUP BY grade, loan_status