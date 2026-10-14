# Superset dashboard exercise

Local sandbox for trying [Apache Superset](https://superset.apache.org/) via the official Docker Compose quickstart.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker Engine + Compose)
- Git

## Start

```bash
./start.sh
```

That clones Apache Superset `6.0.0` into `./superset` (gitignored), then runs:

```bash
docker compose -f docker-compose-image-tag.yml up -d
```

First boot pulls images and loads example data — often several minutes.

Then open **http://localhost:8088**

| | |
|---|---|
| Username | `admin` |
| Password | `admin` |

## Stop

```bash
./stop.sh
```

Use `stop` (not `down`) so local volume data is preserved. To wipe everything:

```bash
cd superset && docker compose -f docker-compose-image-tag.yml down -v
```

## What to try next

1. Log in and open an **example dashboard** (loaded on first start).
2. **SQL Lab** → run a query against an example database.
3. Create a **chart** from a dataset, then add it to a **dashboard**.

Docs: [Quickstart](https://superset.apache.org/docs/quickstart) · [First dashboard](https://superset.apache.org/docs/creating-charts-dashboards/creating-your-first-dashboard)

## Connecting Databricks

Superset has first-party Databricks support. The recommended driver is the official **Databricks SQL Python connector** (`databricks-sql-connector`).

### Install the driver

Superset does not ship every DB driver. Install the Databricks extra in the environment that runs Superset:

```bash
pip install "apache-superset[databricks]"
```

**Docker Compose note:** the stock quickstart image may not include this package. Install it inside the Superset container (or bake it into a custom image), then restart:

```bash
docker compose -f docker-compose-image-tag.yml exec superset pip install "apache-superset[databricks]"
docker compose -f docker-compose-image-tag.yml restart superset
```

### Add the connection in the UI

1. **Settings → Database Connections** (or **Data → Databases**)
2. **+ Database**
3. Choose **Databricks**, or paste a SQLAlchemy URI
4. **Test Connection** → **Connect**

### SQLAlchemy URI

```text
databricks://token:{access_token}@{host}:{port}?http_path={http_path}&catalog={catalog}&schema={schema}
```

| Piece | Where to get it |
|---|---|
| `access_token` | Databricks → Settings → User Settings → Access Tokens |
| `host`, `port`, `http_path` | SQL warehouse or cluster → **Connection details** / JDBC/ODBC |
| `catalog`, `schema` | Unity Catalog catalog + schema to default into |

Works with Databricks **SQL warehouses** and **clusters**. Other options (Hive connector, ODBC, legacy `databricks-dbapi`) exist; prefer the Python connector for new setups.

Official docs: [Databricks | Superset](https://superset.apache.org/user-docs/databases/supported/databricks/)

## Common pitfall: time grains on numeric years

If you see:

```text
function date_trunc(unknown, double precision) does not exist
DATE_TRUNC('MONTH', year)
```

the column is a **number** (e.g. `2008`), not a timestamp. Clear the time grain / use `year` as a dimension, or cast first:

```sql
DATE_TRUNC('month', MAKE_DATE(year::int, 1, 1))
```

## Note

Docker Compose here is for local exploration only, not production.
