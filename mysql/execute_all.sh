#! /bin/sh

for sql in `ls *.sql`;
do
	./execute_script.sh $1 $sql
done
