#! /bin/sh
cat ./$1 | while read ip
do
echo "atualizando $ip"
./execute_all.sh $ip
echo "OK!"
done 
