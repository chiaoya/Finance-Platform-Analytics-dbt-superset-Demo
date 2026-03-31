SELECT
    CAST(NULLIF(TRIM(amount_requested::text), '') AS numeric) AS amount_requested,
    application_date,
    loan_title,
    CAST(NULLIF(TRIM(risk_score::text), '') AS numeric) AS risk_score,
    debt_to_income_ratio,
    zip_code,
    state,
    employment_length,
    policy_code
FROM {{ source('raw', 'lendingclub_rejected_loans') }}
