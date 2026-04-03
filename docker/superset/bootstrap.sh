#!/bin/sh
set -eu

CONFIG_DIR="/app/bootstrap"
IMPORT_DIR="/tmp/superset-import"
ZIP_PATH="/tmp/superset-import.zip"

mkdir -p "${IMPORT_DIR}/databases"

python <<'PY'
import os
import textwrap
import uuid
import zipfile
from pathlib import Path

import_dir = Path("/tmp/superset-import/databases")
zip_path = Path("/tmp/superset-import.zip")

database_name = os.getenv("SUPERSET_ANALYTICS_DB_NAME", "platform_demo")
db_user = os.getenv("SUPERSET_ANALYTICS_DB_USER", "postgres")
db_password = os.getenv("SUPERSET_ANALYTICS_DB_PASSWORD", "postgres")
db_host = os.getenv("SUPERSET_ANALYTICS_DB_HOST", "postgres")
db_port = os.getenv("SUPERSET_ANALYTICS_DB_PORT", "5432")

database_uuid = os.getenv(
    "SUPERSET_ANALYTICS_DB_UUID",
    "f2f0da35-364e-4a7f-a8d5-4a30a7be5f90",
)

yaml_text = textwrap.dedent(
    f"""\
    databases:
      - database_name: {database_name}
        sqlalchemy_uri: postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{database_name}
        expose_in_sqllab: true
        allow_ctas: true
        allow_cvas: true
        allow_dml: true
        allow_run_async: false
        uuid: {database_uuid}
        version: 1.0.0
        tables: []
    """
)

yaml_path = import_dir / "platform_demo.yaml"
yaml_path.write_text(yaml_text, encoding="utf-8")

with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
    zf.write(yaml_path, arcname="databases/platform_demo.yaml")
PY

superset db upgrade
superset fab create-admin \
  --username "${SUPERSET_ADMIN_USERNAME:-admin}" \
  --firstname "${SUPERSET_ADMIN_FIRSTNAME:-admin}" \
  --lastname "${SUPERSET_ADMIN_LASTNAME:-admin}" \
  --email "${SUPERSET_ADMIN_EMAIL:-admin@superset.com}" \
  --password "${SUPERSET_ADMIN_PASSWORD:-admin}" || true
superset init
superset import_datasources -p "${ZIP_PATH}" -u "${SUPERSET_ADMIN_USERNAME:-admin}" || true
superset run -h 0.0.0.0 -p 8088 --with-threads
