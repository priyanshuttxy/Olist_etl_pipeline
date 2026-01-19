import subprocess
import os

PSQL = r"C:\Program Files\PostgreSQL\17\bin\psql.exe"

env = os.environ.copy()
env["PGPASSWORD"] = "829122"

subprocess.run(
    ["python", "ingest.py"],
    check=True,
    env=env
)

subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\customers.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\geolocation.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\order_items.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\order_payments.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\order_review.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\orders.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\product_category.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\products.sql"],
    check=True,
    env=env
)
subprocess.run(
    [PSQL, "-U", "postgres", "-d", "olistdb", "-f", r"clean_level\incremental_queries\sellers.sql"],
    check=True,
    env=env
)
print("Pipeline completed successfully")