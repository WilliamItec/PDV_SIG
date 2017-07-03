#! /bin/sh
ip=$1
file_sql=$2
echo "executando $file_sql"
mysql -u sa -pm1lkw4y -h $ip -D SIG_POS_dbo < $file_sql

