select
    cast(id as bigint) as loan_id,
    cast(nullif(trim(loan_amnt::text), '') as numeric) as loan_amount,
    cast(nullif(trim(funded_amnt::text), '') as numeric) as funded_amount,
    cast(nullif(replace(trim(term::text), ' months', ''), '') as integer) as term_months,
    cast(nullif(replace(trim(int_rate::text), '%', ''), '') as numeric) as interest_rate,
    cast(nullif(trim(installment::text), '') as numeric) as installment_amount,
    trim(grade) as grade,
    trim(sub_grade) as sub_grade,
    trim(emp_length) as employment_length,
    trim(home_ownership) as home_ownership,
    cast(nullif(trim(annual_inc::text), '') as numeric) as annual_income,
    to_date(nullif(trim(issue_d), ''), 'Mon-YYYY') as issue_date,
    date_trunc('month', to_date(nullif(trim(issue_d), ''), 'Mon-YYYY'))::date as issue_month,
    trim(loan_status) as loan_status,
    trim(purpose) as purpose,
    trim(addr_state) as state,
    cast(nullif(trim(dti::text), '') as numeric) as debt_to_income_ratio
from {{ source('raw', 'lendingclub_loans') }}
where trim(id) ~ '^[0-9]+$'
