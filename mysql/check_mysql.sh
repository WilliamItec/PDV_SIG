#! /bin/sh
rm ip_mysql.txt
ip_file_txt=$1
cat ./$ip_file_txt | while read ip
do
nc -z $ip 3306
if [ "$?" -eq "0" ]; then
	echo "$ip" >> ip_mysql.txt
fi
done
