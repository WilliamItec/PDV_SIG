#! /bin/sh
ip=$1
file_sql=$2
echo "executando $file_sql"
psql -h $ip -U postgres -d pdv < $file_sql
