#!/bin/bash
#. DataBaseFunc.sh
function DropTable {
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
					# get row index in meta file == column index in data file
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
function InsertTable {
	if [ $# -eq 1 ]
    then
        if [ -f $1 ]
        then
			# how many column we have 
			(( column=$(awk 'END{print NR}' $1.meta) -1 ))
			typeset -i counter
			counter=1
			TableContent=""
			ColumnSep=":"
			RowSep="\n"
			ArrField=($(cat $1.meta | awk -F: '{ print $1 }'))
			ArrType=($(cat $1.meta | awk -F: '{ print $2 }'))
			ArrPK=($(cat $1.meta | awk -F: '{ print $3 }'))
			while [[ $counter -le $column ]]
			do
				read -p "Enter Value for parameter ${ArrField[counter]} :${ArrType[counter]}:" TableParameter
				# Check input type
				if [[ ${ArrType[counter]} == "Integer" ]]
				then
					if ! [[ $TableParameter =~ ^[0-9]+$ ]]
					then 
						echo "Invalid Integer"
						continue
					fi
				elif [[ ${ArrType[counter]} == "String" ]]
				then
					if ! [[ $TableParameter =~ ^[a-zA-Z]+$ ]]
					then
						echo "Invalid String"
						continue
					fi
				fi
				# Check PK input in table
				if [[ ${ArrPK[counter]} == "Yes" ]]
				then
						Arr=($(awk -F : '{print $'$counter'}' $1))
						# in case if it is primary key we have to make sure the value are unique
						for i in ${Arr[*]}
						do
							if [[ $i -eq  $TableParameter ]]
							then
								echo "---------------------------------"
								echo "Error: Value duplication in Primary Key! "
								echo "---------------------------------"
								echo "Please Try Again"
								continue 2
							fi
						done
				fi
				if [[ $counter == $column ]]
				then
					TableContent+=$TableParameter
				else
					TableContent+=$TableParameter$ColumnSep
				fi
				(( counter++ ))
			done
			echo  "$TableContent" >> $1 
        else
            echo "This is not a valid table name"
            echo "Please try again with the right name"
        fi
    else
        echo "You Need to enter One table name"
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
	echo "----------------------------"
	echo "----------------------------"
	echo -e "Example: \n       UPDATE table_name\n       SET column_update_name = update_value\n       WHERE where_column_condition= where_condition_value"
	echo "----------------------------"
	echo "----------------------------"
	# Check table parameter if input is more than one table
	if [ $# -eq 1 ]
    then
		# Check if table is existed
        if [ -f $1 ]
        then
			# where clause presentation -> put the condition (column index)
			read -p "Enter where column condition (column name) : " ColName
			# serach for where clause parameters in meta table ()
			exist=$(awk  -F : -v c=$ColName '{if($1 == c)print $0 }' $1.meta)
			# if where clause/where cause column value existed
			if ! [[ $exist == "" ]]
			then
				# Check where clause index in meta file
				(( num=$(awk  -F : -v c=$ColName '{if($1 == c)print NR }' $1.meta) -1 ))
				# Set the old Value in where
				 read -p "Enter where condition Value : " Val
				# Check if old variable is existed in the column itself -> bring the variable itself
				 in=$(awk  -F : -v c=$Val '{if($'$num' == c)print $0 }' $1)
				# Check if variable is existed in the row itself -> bring variable index we will need it in sed 
				 where=$(awk -F : -v c=$Val '{if($'$num' == c)print NR }' $1)
				if ! [[ $in == "" ]]
				then
					f=0
					 read -p "Enter Column Name to Set: " Cond
					 exist=$(awk  -F : -v c=$Cond '{if($1 == c)print $0 }' $1.meta)
					 type=$(awk  -F : -v c=$Cond '{if($1 == c)print $2 }' $1.meta)
					 PK=$(awk  -F : -v c=$Cond '{if($1 == c)print $3 }' $1.meta)
					if ! [[ $exist == "" ]]
					then
						# Check column index in meta file
						(( num1=$(awk  -F : -v c=$Cond '{if($1 == c)print NR }' $1.meta) -1 ))
						# Detect the old value: the one which will be replaced
						old=$(awk -F : -v c=$where '{if(NR == c) print $'$num1'}' $1)
						# set the new/update value
					 	read -p "Enter the updated Value (Final value): " NewVal
						# check value type
						if [[ $type == "Integer" ]]
						then
							# in case integer -> check input is a number
						 	if ! [[ $NewVal =~ ^[0-9]+$ ]]
							then
								f=1
							 	echo "Invailed Input"
							fi
						elif [[ $type == "Sting" ]]
						then
							# in case string -> check input is a word
						 	if ! [[ $NewVal =~ ^[a-zA-Z]+$ ]]
							then
								f=1
							 	echo "Invailed Input"
				 			fi
						fi
<<<<<<< HEAD
						# substitute the old value with the new one with respect to where row index
						sed -i ''$where's/'$old'/'$NewVal'/g' $1
						echo "update success"
=======
						if [[ $PK == "Yes" ]]
						then
							Arr=($(awk -F : '{print $'$num1'}' $1))
						# in case if it is primary key we have to make sure the value are unique
							for i in ${Arr[*]}
							do
								if [[ $i -eq  $NewVal ]]
								then
									f=1
									echo "this value already exist"
									break
								fi
							done
						fi
						if [[ $f == 0 ]]
						then
							sed -i ''$where's/'$old'/'$NewVal'/g' $1
							echo "update success"
						fi
>>>>>>> 3d546b788d53c0d54de4905cee30fd19e33ad04d
					else
					 	echo "Target column does not exist"
				 	fi
				else 
				 	echo "The value condition does not exist"
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


