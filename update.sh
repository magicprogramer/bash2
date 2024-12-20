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
echo "na equal " $n
echo "you are required to enter the new values for the  fields you will update  or leave it empty to not not change it"
pattern=""
new_values=""
for i in $(seq 1 $n)
do
	  type1=$(sed -n '2p' "./db/$database_name/$table_name" | cut -d "|" -f $i)
	echo "enter the new value for " $(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i) "($type1) : "
	field=""
	while (true)
	do
		read field
		if [ -z $field ]
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
			if [ "$type1" = "char" ]
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
		if [ -z "$new_values" ]
		then
			new_values="$field"
		else
			new_values+="|$field"
		fi
	else
		if [ -z "$new_values" ]
		then
			new_values="null"
		else
			new_values+="|null"
		fi
	fi
done
#echo "new values $new_values"
echo "now enter the conditions that you only change the record when the field = your entered value or leave it empty if you don't want to match with it"
for i in $(seq 1 $n)
do
	echo "enter the value for "  $(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i)
	type1=$(sed -n '2p' "./db/$database_name/$table_name" | cut -d "|" -f $i)	
	echo "its an " "$type1"
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
		#echo "$field"
		is_num $field
	if [ $? = 1 ]
	then
		break
	else
		echo "you should enter an integer"
		continue
	fi
	 fi
	 if [ "$type1" = "char" ]
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
#echo "$new_values \n  $pattern"
	Len=$(wc -l <  "db/$database_name/$table_name")
	#echo "l = $Len"
	headers=$(head -n 1 "db/$database_name/$table_name")
	#types=$(sed -n '2p' "./db/$database_name/$table_name" | cut -d "|" -f $i)
	types=$(sed -n '2p' "./db/$database_name/$table_name")
	awk    -F "|" -v headers="$headers" -v  types="$types" -v new_values="$new_values" -v pattern="$pattern" -v empty="true" -v change="false" -v c=1 -v Len="$Len"  'BEGIN { print headers; print types; split(pattern, arr, "|"); split(new_values, arr2, "|");} NR < 3{next} {
	change="true";
	empty="true";
	
	c ++;
	for (i = 1; i <= NF; i ++)
	{
		if (arr[i] == "null" )
			{
				
				continue;
			}
		if (arr[i] != $i)
			{
				#print "false"
				#print i " -- " $i " -- " arr[i]
				change="false";
				break;
			}
		#print "--------------------\n"
	}
	if (change  == "false")
		{
			print $0;
		}
else
	{
		for (i = 1; i <= NF; i ++)
			{
				if (arr2[i] != "null")
					{
						printf arr2[i];
					}
				else
					{
						printf $i;
					}
				if (i != NF)
					{
						printf "|";
					}
			else 
				{
					printf "\n";
				}
			}
	}
}
' "db/$database_name/$table_name" > "/tmp/f22"
#cat "/tmp/f22"
mv -f "/tmp/f22" "db/$database_name/$table_name"
echo "updated succesfully !"


#types=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f 1-4)
