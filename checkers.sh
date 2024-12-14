#!/usr/bin/bash
function is_num
{
        if [ $# -ne  1 ]
        then
                echo "you must provide an argument that doesn't contain space"
                return 0
        fi
        if [[ $1 =~ ^[0-9]+$  ]]
        then
                return 1
        else
                return 0
        fi

}
function is_char
{
	if [ $# -ne  1 ]
	then
		echo "you must provide an argument that doesn't contain space"
		return 0
	fi
	if [[ ${#1} -eq 1 && $1 =~ ^[a-zA-Z]$ ]]
	then
		echo "char"
		return 1
	else
		echo "not char"
		return 0
	fi
}

