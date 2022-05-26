#!/bin/bash
function DeleteFromTable {
	if [ $# -eq 1 ]
    then
        if [ -f $1 ]
        then
			read -p "Enter the Column Name: " ColName
			exist=$(awk  -F : -v c=$ColName '{if($1 == c)print $0 }' $1.meta)
			if ! [[ $exist == "" ]]
			then
				 read -p "Enter Delete Condition: " Cond
				 (( num=$(awk  -F : -v c=$ColName '{if($1 == c)print NR }' $1.meta) -1 ))
				 echo $num
				 Arr=($(awk -F : -v x=$Cond '{if($'$num' == x) print NR}' $1)) 
				 echo ${#Arr[*]}
				 if ! [[ ${Arr[*]} == "" ]]
				 then
				 	for (( i =${#Arr[*]}-1;i>=0;i-- ))
					 do
				 		sed -i ''${Arr[i]}'d' $1
						echo "Row $ind is deleted"
					done
				 else
				 	echo "Value not found"
				 fi
			else
				echo "column not found"
			fi
		else
			echo "table not found"
		fi
	else
		echo "table not found"
	fi
}