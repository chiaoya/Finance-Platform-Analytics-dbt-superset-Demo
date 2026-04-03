{{ config(materialized='table') }}

select
    application_id,
    loan_id,
    application_date,
    application_month,
    requested_amount,
    approved_amount,
    grade,
    sub_grade,
    purpose,
    state,
    employment_length,
    employment_length_years,
    home_ownership,
    annual_income,
    debt_to_income_ratio,
    loan_status,
    application_outcome,
    risk_score,
    is_approved,
    is_rejected,
    is_default,
    income_band,
    dti_band
from {{ ref('int_applications_combined') }}
