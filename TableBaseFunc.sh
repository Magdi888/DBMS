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
function InsertTable {
	if [ $# -eq 1 ]
    then
        if [ -f $1 ]
        then
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
	if [ $# -eq 1 ]
    then
        if [ -f $1 ]
        then
			read -p "Enter the Column Name Condition : " ColName
			exist=$(awk  -F : -v c=$ColName '{if($1 == c)print $0 }' $1.meta)
			if ! [[ $exist == "" ]]
			then
				(( num=$(awk  -F : -v c=$ColName '{if($1 == c)print NR }' $1.meta) -1 ))
				 read -p "Enter the Value Condition : " Val
				 in=$(awk  -F : -v c=$Val '{if($'$num' == c)print $0 }' $1)
				 echo $in
				 where=$(awk -F : -v c=$Val '{if($'$num' == c)print NR }' $1)
				 echo $where
				if ! [[ $in == "" ]]
				then
					f=0
					 read -p "Enter Column Name to Set: " Cond
					 exist=$(awk  -F : -v c=$Cond '{if($1 == c)print $0 }' $1.meta)
					 type=$(awk  -F : -v c=$Cond '{if($1 == c)print $2 }' $1.meta)
					 PK=$(awk  -F : -v c=$Cond '{if($1 == c)print $3 }' $1.meta)
					if ! [[ $exist == "" ]]
					then
						(( num1=$(awk  -F : -v c=$Cond '{if($1 == c)print NR }' $1.meta) -1 ))
						echo $num1
						echo $where
						old=$(awk -F : -v c=$where '{if(NR == c) print $'$num1'}' $1)
						echo $old
					 	read -p "Enter the New Value : " NewVal
						if [[ $type == "Integer" ]]
						then
						 	if ! [[ $NewVal =~ ^[0-9]+$ ]]
							then
								f=1
							 	echo "Invailed Input"
							fi
						elif [[ $type == "Sting" ]]
						then
						 	if ! [[ $NewVal =~ ^[a-zA-Z]+$ ]]
							then
								f=1
							 	echo "Invailed Input"
				 			fi
						fi
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


