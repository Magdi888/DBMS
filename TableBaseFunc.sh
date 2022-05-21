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

function UpdateTable {
	# Check table parameter if input is more than one table
	if [ $# -eq 1 ]
    then
	# Check if table is existed
        if [ -f $1 ]
        then
			# where cause presentation -> put the condition (column index)
			read -p "Enter where cause condition : " whereCon
			# intiate where cause parameters ()
			exist=$(awk  -F : -v c=$whereCon '{if($1 == c)print $0 }' $1.meta)
			# if where cause condition -> where cause column value
			if ! [[ $exist == "" ]]
			then
				# Check where cause index in meta file
				(( num=$(awk  -F : -v c=$whereCon '{if($1 == c)print NR }' $1.meta) -1 ))
				# Set the old Value
				 read -p "Enter the Old Value : " Val
				# Check if old variable is existed in the column itself -> bring the variable itself
				 in=$(awk  -F : -v c=$Val '{if($'$num' == c)print $0 }' $1)
				# Check if variable is existed in the row itself -> bring variable index we will need it in sed
				 rowIndex=$(awk  -F : -v c=$Val '{if($'$num' == c)print $NR }' $1)
				 if ! [[ $in == "" ]]
				 then
				 	# set the column name
					 read -p "Enter column name: " columnName
					# intiate column parameters ()
					 ColumnExist=$(awk  -F : -v c=$columnName '{if($1 == c)print $0 }' $1.meta)
					 type=$(awk  -F : -v c=$columnName '{if($1 == c)print $2 }' $1.meta)
					# 
					 if ! [[ $ColumnExist == "" ]]
					 then
					 	# Check column index in meta file
						(( ColumnIndex=$(awk  -F : -v c=$columnName '{if($1 == c)print NR }' $1.meta) -1 ))
						# set the new/update value
						read -p "Enter the New Value: " NewVal
						# check value type
						if [[ $type == "Integer" ]]
						then
							# in case integer -> check input is number
							if ! [[ $NewVal =~ ^[0-9]+$ ]]
							then
								echo "Invailed Input"
							fi
						elif [[ $type == "Sting" ]]
						then
							# in case string -> check input is word
							if ! [[ $NewVal =~ ^[a-zA-Z]+$ ]]
							then
								echo "Invailed Input"
							fi
						fi
						sed -i ''$rowIndex's/'$Val'/'$NewVal'/g' $1
						echo "update success"
					else
						echo "Invalid"
					fi
				else
				 	echo "old variable not found"
				fi
			else
				echo "column in where cause not found"
			fi
		else
			echo "table not found"
		fi
	else
		echo "table not found"
	fi
}