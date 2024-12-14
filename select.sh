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
cat "db/$database_name/$table_name"
