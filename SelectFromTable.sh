#!/bin/bash
function SelectFromTable {
    TableName=$1
    if [ $# -eq 1 ]
    then
        if [ -f $TableName ]
        then
	    select tx in "All Records" "Record" "Column" "With Condition"
	    do
         	case $tx in
		    "All Records" )
			clear
			header=""
			ColumnSep=":"
			(( column=$(awk 'END{print NR}' $1.meta) -1 ))
			ArrField=($(cat $1.meta | awk -F: '{ print $1 }'))
			for (( j=1;j<=column;j++))
			do
				if [[ $j == $column ]]
				then
					header+=${ArrField[j]}
				else
					header+=${ArrField[j]}$ColumnSep
				fi
			done
			echo $header
			echo "-------------------"
           	cat $1
			break;;
		    "Record" )
			clear
			# Define Primary Key index in meta table file
			(( PKindex=$(awk -F: '{if($3=="Yes")print NR}' $1.meta) -1  ))
			read -p "Enter your Primary Key Value: " record
			# print the existing record
			output=$(awk -F: -v c=$record '{if($'$PKindex'==c)print $0}' $1)
			if [[ $output == "" ]]
			then
				echo "Record Not Found "
			else
				echo $output
			fi
			break;;
			"Column")
			clear
			read -p "Enter your Column Name: " col
			exist=$(awk  -F : -v c=$col '{if($1 == c)print $0 }' $1.meta)
			if ! [[ $exist == "" ]]
			then
					echo "Column Exist"
					(( number=$(awk  -F : -v c=$col '{if($1 == c)print NR }' $1.meta) -1 ))
					awk -F : '{print $'$number' }' $1 
			else
					echo "Column $col Does Not Exist"
			fi
			break;;
			"With Condition")
			read -p "Enter Column Name Condition: " ColNameCond
			exist=$(awk  -F : -v c=$ColNameCond '{if($1 == c)print $0 }' $1.meta)
			if ! [[ $exist == "" ]]
			then
				(( ConditionColNum=$(awk  -F : -v c=$ColNameCond '{if($1 == c)print NR }' $1.meta) -1 ))
					read -p "Enter the Value Condition : " Val
					ValExist=$(awk  -F : -v c=$Val '{if($'$ConditionColNum' == c)print $0 }' $1)
					ConditionValPlace=($(awk -F : -v c=$Val '{if($'$ConditionColNum' == c)print NR }' $1))
				if ! [[ $ValExist == "" ]]
				then
					for j in ${ConditionValPlace[*]}
					do
						awk -F: -v c=$j '{if(NR == c) print $0}' $1
					done
				else
					echo "The value condition does not exist"
				fi
			else
				echo "Column not found"  
			fi
			break;;
		    * )
			echo "Invalid Choice"
			;;
	        esac
	    done
        else
            echo "This is not a valid table name"
            echo "Please try again with the right name"
        fi
    else
        echo "You Can Not Select More Than One table"
    fi
}



