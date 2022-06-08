#!/bin/bash
function InsertTable {
	# only one table accpeted
	if [ $# -eq 1 ]
    then
		# check file existence
        if [ -f $1 ]
        then
			# get how many columns in meta file
			(( ColumnNumbers=$(awk 'END{print NR}' $1.meta) -1 ))
			# set some parameters to help us in filtering and adding 
			typeset -i counter
			counter=1
			TableContent=""
			ColumnSep=":"
			RowSep="\n"
			# get all details of every meta column
			ArrField=($(cat $1.meta | awk -F: '{ print $1 }'))
			ArrType=($(cat $1.meta | awk -F: '{ print $2 }'))
			ArrPK=($(cat $1.meta | awk -F: '{ print $3 }'))
			while [[ $counter -le $ColumnNumbers ]]
			do
				read -p "Enter Value for parameter ${ArrField[counter]} (${ArrType[counter]}): " TableParameter
				# Check input type
				if [[ ${ArrType[counter]} == "Integer" ]]
				then
					# in case you choose Integer and entered String
					if ! [[ $TableParameter =~ ^[0-9]+$ ]]
					then 
						echo "Invalid Integer"
						continue
					fi
				elif [[ ${ArrType[counter]} == "String" ]]
				then
					# in case you choose Integer and entered Integer
					if ! [[ $TableParameter =~ ^[a-zA-Z]+$ ]]
					then
						echo "Invalid String"
						continue
					fi
				fi
				# Check PK input in table
				if [[ ${ArrPK[counter]} == "Yes" ]]
				then
					# 
					PK_Values=($(awk -F : '{print $'$counter'}' $1))
					# in case if it is primary key we have to make sure the value are unique
					for i in ${PK_Values[*]}
					do
						if [[ $i ==  $TableParameter ]]
						then
							echo "---------------------------------"
							echo "Error: Value duplication in Primary Key! "
							echo "---------------------------------"
							echo "Please Try Again"
							# get back to the main loop
							continue 2
						fi
					done
				fi
				# in case of it is the last one or not -> set table or table and column seperator
				if [[ $counter == $ColumnNumbers ]]
				then
					TableContent+=$TableParameter
				else
					TableContent+=$TableParameter$ColumnSep
				fi
				(( counter++ ))
			done
			# redirect output to data table
			echo  "$TableContent" >> $1 
        else
            echo "This is not a valid table name"
            echo "Please try again with the right name"
        fi
    else
        echo "You Need to enter One table name"
    fi
}

