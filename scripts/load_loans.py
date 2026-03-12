import pandas as pd
from sqlalchemy import create_engine

csv_path = "data/raw/lendingclub/accepted_subset.csv"

# Be sure to update the connection string with your own credentials and database name
engine = create_engine(
    "postgresql://postgres:postgres@localhost:5432/finance_platform"
)

df = pd.read_csv(csv_path)

df = df[
    [
        "id",
        "loan_amnt",
        "funded_amnt",
        "term",
        "int_rate",
        "installment",
        "grade",
        "sub_grade",
        "emp_length",
        "home_ownership",
        "annual_inc",
        "issue_d",
        "loan_status",
        "purpose",
        "addr_state",
        "dti",
    ]
]

df.to_sql(
    "lendingclub_loans",
    engine,
    schema="raw",
    if_exists="append",
    index=False,
    chunksize=5000
)

print("Finished loading data")