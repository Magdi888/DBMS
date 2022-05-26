#!/bin/bash
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

