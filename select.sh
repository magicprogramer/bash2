#!/usr/bin/bash
if [ $# -ne 2 ]
then
	echo "expected two args"
	return 
fi
database_name=$1
table_name=$2
source checkers.sh
declare -i n=0
#head -n 1  "db/$database_name/$table_name"
#tail -n 1 "db/$database_name/$table_name"
n=$(head -n 1 "db/$database_name/$table_name" | grep -o "|" | wc -l)
n=$((n+1))
echo "number of fields equal to " $n
echo "you are required to enter the fields you will search by it or leave it empty to not search by it"
echo "not if you leave all fields empty it will retrieve all data in the table"
pattern=""
for i in $(seq 1 $n)
do
	type1=$(sed -n '2p' "./db/$database_name/$table_name" | cut -d "|" -f $i)
	echo "enter "  $(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i) "($type1) : "
	field=""
	while (true)
	do
	 read field
	 if [ -z  "$field" ]
	then 
		break
	 fi
	 if [ "$type1" = "integer" ]
	then 
	is_num $field
	if [ $? = 1 ]
	then
		break
	else
		echo "you should enter an integer"
		continue
	fi
	 fi
	 if [ "$type1" = char ]
	then
	is_char $field
	if [ $? = 1 ]
	then 
		break
	else
		echo "you should enter exactly one character"
		continue
	fi
	 fi
	 break
	done
	if [ -n "$field" ]
	then
		if [ -z "$pattern" ]
		then
			pattern=$field
		
	else
		pattern+="|$field"
	fi
	else
		if [ -z "$pattern" ]
		then
			pattern='null'
		else
			pattern+='|null'
	fi
	fi
	#echo "pattern : $pattern"
done
	Len=$(wc -l <  "db/$database_name/$table_name")
	#echo "l = $Len"
	awk -F "|" -v pattern="$pattern" -v good="true" -v c=1 -v Len="$Len"  'BEGIN {split(pattern, arr, "|");} NR <= 2 {next} {
	good="true";
	
	c ++;
	for (i = 1; i <= NF; i ++)
	{
		if (arr[i] != $i  && arr[i] != "null")
			{
				#print "not good"
				#print i " -- " $i " -- " arr[i]
				good="false";
				break;
			}
		#print "--------------------\n"
	}
	if (good == "true")
		{
			print $0;
		}
}
' "db/$database_name/$table_name"

#echo "$pattern"

#types=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f 1-4)
