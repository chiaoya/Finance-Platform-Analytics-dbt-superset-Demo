SELECT
    loan_status,
    COUNT(*) AS loans,
    AVG(interest_rate) AS avg_interest_rate,
    AVG(loan_amnt) AS avg_loan_amount
FROM {{ ref('stg_loans') }}
GROUP BY loan_status
ORDER BY loans DESC