select
    loan_id,
    loan_amount,
    funded_amount,
    term_months,
    interest_rate,
    installment_amount,
    grade,
    sub_grade,
    employment_length,
    case
        when employment_length = '10+ years' then 10
        when employment_length = '< 1 year' then 0
        when employment_length ~ '^[0-9]+ years?$'
            then cast(split_part(employment_length, ' ', 1) as integer)
        else null
    end as employment_length_years,
    home_ownership,
    annual_income,
    issue_date,
    issue_month,
    loan_status,
    purpose,
    state,
    debt_to_income_ratio,
    case
        when loan_status in ('Charged Off', 'Default') then 1
        else 0
    end as is_default,
    1 as is_approved,
    case
        when annual_income < 50000 then 'Under 50k'
        when annual_income < 100000 then '50k-100k'
        when annual_income < 200000 then '100k-200k'
        when annual_income >= 200000 then '200k+'
        else 'Unknown'
    end as income_band,
    case
        when debt_to_income_ratio < 10 then 'Under 10'
        when debt_to_income_ratio < 20 then '10-20'
        when debt_to_income_ratio < 30 then '20-30'
        when debt_to_income_ratio >= 30 then '30+'
        else 'Unknown'
    end as dti_band
from {{ ref('stg_lendingclub_loans') }}
