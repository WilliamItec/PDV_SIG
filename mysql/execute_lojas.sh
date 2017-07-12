#! /bin/sh
ip_file_txt=$1
sql_file=$2
cat ./$ip_file_txt | while read ip
do
echo "atualizando $ip"
./execute_script.sh $ip $sql_file
echo "OK!"
done 
