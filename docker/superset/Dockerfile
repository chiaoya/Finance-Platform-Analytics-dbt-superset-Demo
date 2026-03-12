FROM apache/superset:latest

USER root

RUN apt-get update && apt-get install -y gcc python3-dev libpq-dev

RUN python -m ensurepip --upgrade || true
RUN python -m pip install --no-cache-dir psycopg2-binary

USER superset