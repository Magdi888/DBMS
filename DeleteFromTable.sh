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
				 (( ColumnNum=$(awk  -F : -v c=$ColName '{if($1 == c)print NR }' $1.meta) -1 ))
				 Arr=($(awk -F : -v x=$Cond '{if($'$ColumnNum' == x) print NR}' $1)) ####array of [record numbers of condition value]
				 if ! [[ ${Arr[*]} == "" ]]
				 then
				 	for (( i =${#Arr[*]}-1;i>=0;i-- ))
					 do
				 		sed -i ''${Arr[i]}'d' $1
						echo "Row ${Arr[i]} has value = $Cond is deleted"
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