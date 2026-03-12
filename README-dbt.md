# dbt (Docker) quick start

This project includes a `dbt` service in `docker/docker-compose.yml` so you can run dbt inside Docker without changing your local Python.

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
