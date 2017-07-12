#! /bin/sh
ip=$1
file_sql=$2
echo "executando $file_sql"
TDSVER=7.0 /usr/bin/tsql -U sa -P '' -S $ip -D SIG_POS < $file_sql

