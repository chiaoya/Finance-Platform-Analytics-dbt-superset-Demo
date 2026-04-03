with approved_loans as (
    select
        'approved-' || loan_id::text as application_id,
        loan_id,
        issue_date as application_date,
        issue_month as application_month,
        loan_amount as requested_amount,
        funded_amount as approved_amount,
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
        'Approved' as application_outcome,
        cast(null as numeric) as risk_score,
        1 as is_approved,
        0 as is_rejected,
        is_default,
        income_band,
        dti_band
    from {{ ref('int_loans_enriched') }}
),
rejected_loans as (
    select
        'rejected-' || row_number() over (
            order by application_date, state, requested_amount, coalesce(loan_title, '')
        )::text as application_id,
        cast(null as bigint) as loan_id,
        application_date,
        application_month,
        requested_amount,
        cast(null as numeric) as approved_amount,
        cast(null as text) as grade,
        cast(null as text) as sub_grade,
        loan_title as purpose,
        state,
        employment_length,
        case
            when employment_length = '10+ years' then 10
            when employment_length = '< 1 year' then 0
            when employment_length ~ '^[0-9]+ years?$'
                then cast(split_part(employment_length, ' ', 1) as integer)
            else null
        end as employment_length_years,
        cast(null as text) as home_ownership,
        cast(null as numeric) as annual_income,
        debt_to_income_ratio,
        'Rejected' as loan_status,
        'Rejected' as application_outcome,
        risk_score,
        0 as is_approved,
        1 as is_rejected,
        0 as is_default,
        'Unknown' as income_band,
        case
            when debt_to_income_ratio < 10 then 'Under 10'
            when debt_to_income_ratio < 20 then '10-20'
            when debt_to_income_ratio < 30 then '20-30'
            when debt_to_income_ratio >= 30 then '30+'
            else 'Unknown'
        end as dti_band
    from {{ ref('stg_lendingclub_rejected_loans') }}
)

select * from approved_loans
union all
select * from rejected_loans
