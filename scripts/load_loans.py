import os

import pandas as pd
from sqlalchemy import create_engine, text


# Keep one project default so pgAdmin, Docker, and dbt all point at the same database.
DB_NAME = os.getenv("POSTGRES_DB", "platform_demo")
DB_USER = os.getenv("POSTGRES_USER", "postgres")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "postgres")
DB_HOST = os.getenv("POSTGRES_HOST", "localhost")
DB_PORT = os.getenv("POSTGRES_PORT", "5432")
DB_SCHEMA = os.getenv("POSTGRES_SCHEMA", "raw")
LOAD_MODE = os.getenv("LOAD_MODE", "append")
ACCEPTED_LOAD_MODE = os.getenv("ACCEPTED_LOAD_MODE", LOAD_MODE)
REJECTED_LOAD_MODE = os.getenv("REJECTED_LOAD_MODE", LOAD_MODE)
LOAD_ACCEPTED = os.getenv("LOAD_ACCEPTED", "true").lower() == "true"
LOAD_REJECTED = os.getenv("LOAD_REJECTED", "true").lower() == "true"

ACCEPTED_CSV_PATH = os.getenv(
    "ACCEPTED_CSV_PATH", "data/raw/lendingclub/accepted_subset.csv"
)
REJECTED_CSV_PATH = os.getenv(
    "REJECTED_CSV_PATH",
    "data/raw/lendingclub/rejected_2007_to_2018q4.csv/rejected_2007_to_2018Q4.csv",
)


engine = create_engine(
    f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)


def ensure_schema() -> None:
    with engine.begin() as connection:
        connection.execute(text(f"CREATE SCHEMA IF NOT EXISTS {DB_SCHEMA}"))


def load_accepted_loans() -> None:
    accepted_df = pd.read_csv(ACCEPTED_CSV_PATH)

    accepted_df = accepted_df[
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

    accepted_df.to_sql(
        "lendingclub_loans",
        engine,
        schema=DB_SCHEMA,
        if_exists=ACCEPTED_LOAD_MODE,
        index=False,
        chunksize=5000,
    )


def load_rejected_loans() -> None:
    rejected_df = pd.read_csv(REJECTED_CSV_PATH)

    rejected_df = rejected_df[
        [
            "Amount Requested",
            "Application Date",
            "Loan Title",
            "Risk_Score",
            "Debt-To-Income Ratio",
            "Zip Code",
            "State",
            "Employment Length",
            "Policy Code",
        ]
    ].rename(
        columns={
            "Amount Requested": "amount_requested",
            "Application Date": "application_date",
            "Loan Title": "loan_title",
            "Risk_Score": "risk_score",
            "Debt-To-Income Ratio": "debt_to_income_ratio",
            "Zip Code": "zip_code",
            "State": "state",
            "Employment Length": "employment_length",
            "Policy Code": "policy_code",
        }
    )

    rejected_df.to_sql(
        "lendingclub_rejected_loans",
        engine,
        schema=DB_SCHEMA,
        if_exists=REJECTED_LOAD_MODE,
        index=False,
        chunksize=5000,
    )


if __name__ == "__main__":
    ensure_schema()
    if LOAD_ACCEPTED:
        load_accepted_loans()
    if LOAD_REJECTED:
        load_rejected_loans()
    print(
        "Finished loading configured datasets into "
        f"{DB_SCHEMA}.lendingclub_loans and/or "
        f"{DB_SCHEMA}.lendingclub_rejected_loans"
    )
