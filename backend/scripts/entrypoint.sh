#!/bin/sh

set -o errexit
set -o pipefail
cmd="$@"


function postgres_ready(){
python << END
import os

import sys
import psycopg2

try:
    dbname = os.environ.get('POSTGRES_DB')
    user = os.environ.get('POSTGRES_USER')
    password = os.environ.get('POSTGRES_PASSWORD')
    conn = psycopg2.connect(dbname=dbname, user=user, password=password, host='postgres', port=5432)
except psycopg2.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}

until postgres_ready; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - continuing..."
exec $cmd
