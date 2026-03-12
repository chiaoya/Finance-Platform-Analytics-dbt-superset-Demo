SELECT
    id,
    CAST(NULLIF(TRIM(loan_amnt::text), '') AS numeric) AS loan_amnt,
    CAST(NULLIF(TRIM(funded_amnt::text), '') AS numeric) AS funded_amnt,
    term,
    CAST(NULLIF(REPLACE(TRIM(int_rate::text), '%', ''), '') AS numeric) AS interest_rate,
    CAST(NULLIF(TRIM(installment::text), '') AS numeric) AS installment,
    grade,
    sub_grade,
    emp_length,
    home_ownership,
    CAST(NULLIF(TRIM(annual_inc::text), '') AS numeric) AS annual_inc,
    issue_d,
    loan_status
FROM {{ source('raw', 'lendingclub_loans') }}