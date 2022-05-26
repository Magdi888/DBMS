#!/bin/bash
function SelectFromTable {
	# 3ayz agyb el parameter DB mn gwa DataBaseFunc.sh
    TableName=$1
    if [ $# -eq 1 ]
    then
        if [ -f $TableName ]
        then
	    select tx in "All Records" "Record" "Column"
	    do
         	case $tx in
		    "All Records" )
			clear
           	cat $1
			break;;
		    "Record" )
			clear
			# Define Primary Key index in meta table file
			(( PKindex=$(awk -F: '{if($3=="Yes")print NR}' $1.meta) -1  ))
			echo $PKindex
			read -p "Enter your Primary Key Value: " record
			# print the existing record
			output=$(awk -F: -v c=$record '{if($'$PKindex'==c)print $0}' $1)
			echo $output
			if [[ $output == "" ]]
			then
				echo "Record Not Found "
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