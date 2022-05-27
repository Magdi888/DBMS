#!/bin/bash
function SelectFromTable {
	# Check if he entered one table
    if [ $# -eq 1 ]
    then
		# check table existence
        if [ -f $1 ]
        then
	    select SELECTED in "All Records" "Record" "Column" "With Condition"
	    do
         	case $SELECTED in
		    "All Records" )
			clear
			# Set initial parameters
			header=""
			ColumnSep=":"
			# How many columns are in meta file
			(( column=$(awk 'END{print NR}' $1.meta) -1 ))
			# Get all columns in array
			ArrField=($(cat $1.meta | awk -F: '{ print $1 }'))

			# SET COLUMN NAMES ABOVE ALL RECORDS AS A HEADER
			for (( j=1;j<=column;j++ ))
			do
				
				if [[ $j == $column ]]
				then
					header+=${ArrField[j]}
				else
					header+=${ArrField[j]}$ColumnSep
				fi
			done
			# DISPLAY THE HEADER
			echo $header
			echo "___________________________________________"
           	cat $1
			break;;
		    "Record" )
			clear
			# Define Primary Key index in meta table file
			(( PKindex=$(awk -F: '{if($3=="Yes")print NR}' $1.meta) -1  ))
			read -p "Enter your Primary Key Value: " record
			# print the existing record (if it existed)
			output=$(awk -F: -v c=$record '{if($'$PKindex'==c)print $0}' $1)
			# check existence
			if [[ $output == "" ]]
			then
				echo "Record Not Found "
			else
				echo $output
			fi
			break;;
			"Column")
			clear
			read -p "Enter your Column Name: " ColumnName
			# get column value from meta file (if existed)
			exist=$(awk  -F : -v c=$ColumnName '{if($1 == c)print $0 }' $1.meta)
			# check existence
			if ! [[ $exist == "" ]]
			then
				echo "Column Exist"
				# get column name index in meta file
				(( number=$(awk  -F : -v c=$ColumnName '{if($1 == c)print NR }' $1.meta) -1 ))
				awk -F : '{print $'$number' }' $1 
			else
				echo "Column $ColumnName Does Not Exist"
			fi
			break;;
			"With Condition")
			read -p "Enter Column Name Condition: " ColNameCond
			# get column value in meta file (if existed)
			exist=$(awk  -F : -v c=$ColNameCond '{if($1 == c)print $0 }' $1.meta)
			# check existence
			if ! [[ $exist == "" ]]
			then
				# get column index of column name condition
				(( ConditionColNum=$(awk  -F : -v c=$ColNameCond '{if($1 == c)print NR }' $1.meta) -1 ))
				read -p "Enter the Value Condition : " Val
				# get the value in meta file (if existed)
				ValExist=$(awk  -F : -v c=$Val '{if($'$ConditionColNum' == c)print $0 }' $1)
				# get row index of value condition
				RowIndexVal=($(awk -F : -v c=$Val '{if($'$ConditionColNum' == c)print NR }' $1))
				if ! [[ $ValExist == "" ]]
				then
					for j in ${RowIndexVal[*]}
					do
						# print the value which has this Row Index 
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



