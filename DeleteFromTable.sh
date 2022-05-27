#!/bin/bash
function DeleteFromTable {
	if [ $# -eq 1 ]
    then
        if [ -f $1 ]
        then
			read -p "Enter the Column Name: " ColName
			# Check column exist, if existed set the row meta data of it
			exist=$(awk  -F : -v c=$ColName '{if($1 == c)print $0 }' $1.meta)
			if ! [[ $exist == "" ]]
			then
				 read -p "Enter Delete Condition Value: " ConditionValue
				 # get the column index in  meta data file
				 (( ColumnIndex=$(awk  -F : -v c=$ColName '{if($1 == c)print NR }' $1.meta) -1 ))
				 # using column index in meta file -> check if the value existed in any line on data file
				 Value=($(awk -F : -v x=$ConditionValue '{if($'$ColumnIndex' == x) print NR}' $1)) 
				 if ! [[ ${Value[*]} == "" ]]
				 then
				 	for (( i =${#Value[*]}-1;i>=0;i-- ))
					 do
				 		sed -i ''${Value[i]}'d' $1
						echo "Row ${Value[i]} has value = $ConditionValue is deleted"
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
