{{ config(materialized='table') }}

select
    application_month,
    coalesce(grade, 'Unknown') as grade,
    application_outcome,
    count(*) as total_applications,
    sum(is_approved) as approved_applications,
    sum(is_rejected) as rejected_applications,
    sum(is_default) as defaulted_applications,
    sum(requested_amount) as total_requested_amount,
    sum(approved_amount) as total_approved_amount,
    avg(requested_amount) as avg_requested_amount,
    avg(approved_amount) as avg_approved_amount,
    avg(risk_score) as avg_risk_score
from {{ ref('int_applications_combined') }}
group by 1, 2, 3
