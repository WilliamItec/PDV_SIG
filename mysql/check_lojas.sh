#! /bin/sh
cat ./ip_lojas.txt | while read ip
do
nc -z -w 15 $ip 8080
#echo "OK!"
done 
