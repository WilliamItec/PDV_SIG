#! /bin/sh
cat ./ip_lojas.txt | while read ip
do
echo "atualizando $ip"
./execute_all.sh $ip
echo "OK!"
done 
