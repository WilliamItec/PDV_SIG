#! /bin/sh
rm ip_sqlserver.txt
ip_file_txt=$1
cat ./$ip_file_txt | while read ip
do
nc -w 3 -z $ip 1433
if [ "$?" -eq "0" ]; then
	echo "$ip" >> ip_sqlserver.txt
fi
done
