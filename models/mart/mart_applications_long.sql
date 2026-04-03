{{ config(materialized='table') }}

select
    grade,
    application_month::date as application_month,
    extract(year from application_month)::int as application_year,
    lpad(extract(month from application_month)::int::text, 2, '0') as application_month_num,
    to_char(application_month::date, 'YYYY-MM') as application_year_month,
    'Approved' as application_outcome,
    approved_applications as value
from {{ ref('mart_applications_summary') }}

union all

select
    grade,
    application_month::date as application_month,
    extract(year from application_month)::int as application_year,
    lpad(extract(month from application_month)::int::text, 2, '0') as application_month_num,
    to_char(application_month::date, 'YYYY-MM') as application_year_month,
    'Rejected' as application_outcome,
    rejected_applications as value
from {{ ref('mart_applications_summary') }}
