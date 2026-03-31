# dbt (Docker) quick start

This project includes a `dbt` service in `docker/docker-compose.yml` so you can run dbt inside Docker without changing your local Python.

This repo is standardized on a single Postgres database: `platform_demo`.
If you still see `finance_platform` in an older container or pgAdmin connection, treat it as legacy data from an earlier setup rather than the current default.

Quick steps

1. Put your dbt profile at `./profiles/profiles.yml` (a safe sample is included at `profiles/profiles.yml`).
2. Start the postgres service if you need it:

```bash
docker compose -f docker/docker-compose.yml up -d postgres
```

3. Verify dbt version:

```bash
UID=$(id -u) GID=$(id -g) docker compose -f docker/docker-compose.yml run --rm dbt --version
```

4. Run `dbt debug` (requires a valid `profiles/profiles.yml`):

```bash
UID=$(id -u) GID=$(id -g) docker compose -f docker/docker-compose.yml run --rm dbt debug
```

Notes
- Do not commit `profiles/` — it can contain secrets. It's already added to `.gitignore`.
- If you prefer to run dbt locally, create a Python 3.11 venv and install the same dbt version.

Loading raw data

To load both accepted and rejected LendingClub data into Postgres:

```bash
python3 scripts/load_loans.py
```

By default the loader connects to:
- host: `localhost`
- port: `5432`
- database: `platform_demo`
- user: `postgres`
- password: `postgres`

You can override these with environment variables such as `POSTGRES_DB`, `POSTGRES_HOST`, and `POSTGRES_PASSWORD`.

After the load completes, pgAdmin should show these raw tables:
- `raw.lendingclub_loans`
- `raw.lendingclub_rejected_loans`
