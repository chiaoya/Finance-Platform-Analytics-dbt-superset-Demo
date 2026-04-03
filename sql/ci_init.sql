create schema if not exists raw;
create schema if not exists analytics;

drop table if exists raw.lendingclub_loans;
create table raw.lendingclub_loans (
    id text,
    loan_amnt text,
    funded_amnt text,
    term text,
    int_rate text,
    installment text,
    grade text,
    sub_grade text,
    emp_length text,
    home_ownership text,
    annual_inc text,
    issue_d text,
    loan_status text,
    purpose text,
    addr_state text,
    dti text
);

insert into raw.lendingclub_loans (
    id,
    loan_amnt,
    funded_amnt,
    term,
    int_rate,
    installment,
    grade,
    sub_grade,
    emp_length,
    home_ownership,
    annual_inc,
    issue_d,
    loan_status,
    purpose,
    addr_state,
    dti
)
values
    ('1001', '12000', '12000', '36 months', '12.5%', '401.23', 'B', 'B3', '10+ years', 'MORTGAGE', '85000', 'Jan-2018', 'Fully Paid', 'debt_consolidation', 'CA', '12.4'),
    ('1002', '8000', '8000', '60 months', '18.2%', '204.10', 'C', 'C2', '3 years', 'RENT', '62000', 'Feb-2018', 'Charged Off', 'credit_card', 'NY', '21.3');

drop table if exists raw.lendingclub_rejected_loans;
create table raw.lendingclub_rejected_loans (
    amount_requested text,
    application_date text,
    loan_title text,
    risk_score text,
    debt_to_income_ratio text,
    zip_code text,
    state text,
    employment_length text,
    policy_code text
);

insert into raw.lendingclub_rejected_loans (
    amount_requested,
    application_date,
    loan_title,
    risk_score,
    debt_to_income_ratio,
    zip_code,
    state,
    employment_length,
    policy_code
)
values
    ('15000', '2018-03-14', 'home_improvement', '690', '16.8%', '941xx', 'CA', '5 years', '0'),
    ('5000', '2018-03-20', 'small_business', '610', '28.5%', '100xx', 'NY', '< 1 year', '0');
