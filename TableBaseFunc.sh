#!/bin/bash
# error el sourcing "Segmentation fault (core dumped)"
#. DataBaseFunc.sh
function DropTable {
    # 3ayz agyb el parameter DB mn gwa DataBaseFunc.sh
    TableName=$1
    if [ $# -eq 1 ]
    then
        if [ -f $TableName ]
        then
	    echo "___________________________________________"
	    echo "---- Do you want to delete $1 ? ----"
	    echo "___________________________________________"
	    select tx in "Yes" "No"
	    do
         	case $tx in
		    "Yes")
           		rm -r $1 $1.meta
           		echo "$1 is deleted successfully"
			break;;
		    "No")
			break;;
		       *)
			echo "Invalid Choice"
			;;
	        esac
	    done
        else
            echo "This is not a valid table name"
            echo "Please try again with the right name"
        fi
    else
        echo "You Can Not Delete More Than One table"
    fi
}

function ListTables {
# list the current tables with exception to meta file using grep -v (verse)
	list=$(ls  | grep -v meta | wc -l)
	if [[ $list == 0 ]]
	then
		echo "Empty"
	else
		ls | grep -v meta
	fi
}

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
			read -p "Enter your Primary Key Value: " record
			sed -n "/$record/p" $1
			break;;
			"Column")
			clear
			read -p "Enter your Column Name: " col
			exist=$(awk  -F : '{if($1 == "'$col'")print $0 }' $1.meta)
			if [ $? == 0 ]
			then
					echo "Column Exist"
					(( number=$(awk  -F : '{if($1 == "'$col'")print NR }' $1.meta) -1 ))
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
        echo "You Can Not Delete More Than One table"
    fi
}




}