#!/usr/bin/bash
function is_num
{
        if [ $# -eq 0 ]
        then
                echo "you must provide an argument"
                exit 1
        fi
        if [[ $1 =~ ^[0-9]+$  ]]
        then
                return 1
        else
                return 0
        fi

}

