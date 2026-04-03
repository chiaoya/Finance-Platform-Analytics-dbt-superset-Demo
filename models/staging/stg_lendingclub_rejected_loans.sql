select
    cast(nullif(trim(amount_requested::text), '') as numeric) as requested_amount,
    case
        when trim(application_date) ~ '^\d{4}-\d{2}-\d{2}$'
            then to_date(trim(application_date), 'YYYY-MM-DD')
        when trim(application_date) ~ '^[A-Za-z]{3}-\d{4}$'
            then to_date(trim(application_date), 'Mon-YYYY')
        else null
    end as application_date,
    date_trunc(
        'month',
        case
            when trim(application_date) ~ '^\d{4}-\d{2}-\d{2}$'
                then to_date(trim(application_date), 'YYYY-MM-DD')
            when trim(application_date) ~ '^[A-Za-z]{3}-\d{4}$'
                then to_date(trim(application_date), 'Mon-YYYY')
            else null
        end
    )::date as application_month,
    trim(loan_title) as loan_title,
    cast(nullif(trim(risk_score::text), '') as numeric) as risk_score,
    cast(nullif(replace(trim(debt_to_income_ratio::text), '%', ''), '') as numeric) as debt_to_income_ratio,
    trim(zip_code) as zip_code,
    trim(state) as state,
    trim(employment_length) as employment_length,
    trim(policy_code) as policy_code
from {{ source('raw', 'lendingclub_rejected_loans') }}
