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
#head -n 1  "db/$database_name/$table_name"
#tail -n 1 "db/$database_name/$table_name"
n=$(head -n 1 "db/$database_name/$table_name" | grep -o "|" | wc -l)
n=$((n+1))
zenity --info  --title="update table $table_name" --text="number of fields are $n"
zenity --info --title="update table $table_name"  --text="you are required to enter the new value for each field you will update or you
can leave it empty to not update this field"
pattern=""
new_values=""
for i in $(seq 1 $n)
do
	  type1=$(sed -n '2p' "./db/$database_name/$table_name" | cut -d "|" -f $i)
	 #echo "enter the new value for " $(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i) "($type1) : "
	field=""
	while (true)
	do
		field=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i)
		field=$(zenity --entry --title="update table $table_name" --text="enter the new value for $field ($type1) : ")
		#read field
		if [ $? -eq 1 ]
		then 
			continue;
		fi
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
				zenity --error --title="warning" --text="you should enter an integer"
				#echo "you should enter an integer"
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
				zenity --error --title="warning" --text="you should enter exactly one character"
				#echo "you should enter exactly one character"
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
zenity --info --title="update table : $table_name" --text="now for every of the following fields enter the value which based on it you will decide to update the record or not"
#echo "now enter the conditions that you only change the record when the field = your entered value or leave it empty if you don't want to match with it"
for i in $(seq 1 $n)
do
	#echo "enter the value for "  $(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i)
	type1=$(sed -n '2p' "./db/$database_name/$table_name" | cut -d "|" -f $i)
	field=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i)	
	echo "its an " "$type1"
	while (true)
	do
	  field=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f $i)
	field=$(zenity --entry --title="conditions" --text="enter the value for $field ($type1)")
	 #read field
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
		zenity --error --text="you should enter an integer"
		#echo "you should enter an integer"
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
		zenity --info --text="you should enter exactly one character"
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
zenity --info  --text="updated succesfully !"


#types=$(head -n 1 "db/$database_name/$table_name" | cut -d "|" -f 1-4)
