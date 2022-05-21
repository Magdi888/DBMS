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
			# Define Primary Key index in meta table file
			(( PKindex=$(awk -F: '{if($3=="Yes")print NR-1}' $1.meta) ))
			read -p "Enter your Primary Key Value: " record
			# print the existing record
			awk -F: '{if($'$PKindex'=='$record')print $0}' $1
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
        echo "You Can Not Delete More Than One table"
    fi
}
function InsertTable {
	if [ $# -eq 1 ]
    then
        if [ -f $1 ]
        then
			(( column=$(awk 'END{print NR}' $1.meta) -1 ))
			typeset -i x
			x=1
			TableContent=""
			ColumnSep=":"
			RowSep="\n"
			ArrField=($(cat $1.meta | awk -F: '{ print $1 }'))
			ArrType=($(cat $1.meta | awk -F: '{ print $2 }'))
			ArrPK=($(cat $1.meta | awk -F: '{ print $3 }'))
			while [[ $x -le $column ]]
			do
				read -p "Enter Value for parameter ${ArrField[x]} :${ArrType[x]}:" TableParameter
				# Check input type
				if [[ ${ArrType[x]} == "Integer" ]]
				then
					if ! [[ $TableParameter =~ ^[0-9]+$ ]]
					then 
						echo "Invalid Integer"
						continue
					fi
				elif [[ ${ArrType[x]} == "String" ]]
				then
					if ! [[ $TableParameter =~ ^[a-zA-Z]+$ ]]
					then
						echo "Invalid String"
						continue
					fi
				fi
				# Check PK input in table
				if [[ ${ArrPK[x]} == "Yes" ]]
				then
						# in case if it is primary key we have to make sure the value are unique
						if [[ $TableParameter =~ ^[$(awk -F : '{print $'$x'}' $1)]$ ]]
						then
							echo "---------------------------------"
							echo "Error: Value duplication in Primary Key! "
							echo "---------------------------------"
							echo "Please Try Again"
							continue
						fi
				fi
				if [[ $x == $column ]]
				then
					TableContent+=$TableParameter
				else
					TableContent+=$TableParameter$ColumnSep
				fi
				(( x++ ))
			done
			echo  "$TableContent" >> $1 
        else
            echo "This is not a valid table name"
            echo "Please try again with the right name"
        fi
    else
        echo "You Can Not Insert More Than One table"
    fi
}

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
				 ind=$(awk -F : -v x=$Cond '{if($'$num' == x) print NR}' $1) 
				 if ! [[ $ind == "" ]]
				 then
				 	sed -i ''$ind'd' $1
					echo "Row $ind is deleted"
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


