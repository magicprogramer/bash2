#!/usr/bin/bash
if [ $# -ne 2 ]
then
	echo "expected two args"
	exit 1
fi
database_name=$1
table_name=$2
source checkers.sh
declare -i n=0
head -n 1  "db/$database_name/$table_name"
tail -n 1 "db/$database_name/$table_name"
local n=$(head -n 1 "db/$database_name/$table_name" | grep -o "|" | wc -l)
n=$((n+1))
echo $n
echo "you are required to enter the fields you will search by it or leave it empty to not search by it"
for i in {1..$n}
do
	echo $i
	echo "enter "  $(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f "$i") 
done
local types=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f 1-4)
