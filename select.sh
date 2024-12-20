#!/usr/bin/bash
if [ $# -ne 2 ]
then
	zenity --error --text="missing args"
	return 
fi
database_name=$1
table_name=$2
source checkers.sh
declare -i n=0
n=$(head -n 1 "db/$database_name/$table_name" | grep -o "|" | wc -l)
n=$((n+1))
zenity --info --title="select from table $table_name" --text="number of fields equals to $n"
zenity --info --title="select from table $table_name" --text="you are required to enter the fields you wil search by it or leave it empty to not search by it"
zenity --info --text="note if you leave all fields empty it will retreive all data in the table"
pattern=""
columns=""
for i in $(seq 1 $n)
do
	type1=$(sed -n '2p' "./db/$database_name/$table_name" | cut -d "|" -f $i)
	columns="$columns --column=$type1 "
	while (true)
	do
	field=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i)
	field=$(zenity --entry --text="enter $field ($type1)")
	if [ $? -eq 1 ]
	then
		continue
	fi
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
		zenity --error --text="expect an integer"
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
		zenity --error --text="expected exactly one character"
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
' "db/$database_name/$table_name" > "/tmp/f11"
	cat /tmp/f11 | tr '|' ' ' |  xargs zenity --list $columns
#echo "$pattern"
echo $columns
#types=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f 1-4)
