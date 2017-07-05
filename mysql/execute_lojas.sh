#! /bin/sh
sql_file=$1
cat ./ip_lojas.txt | while read ip
do
echo "atualizando $ip"
./execute_script.sh $ip $sql_file
echo "OK!"
done 
