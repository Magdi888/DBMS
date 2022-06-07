#!/bin/bash
function UpdateTable {
	if [ $# -eq 1 ]
    then
        if [ -f $1 ]
        then
			read -p "Enter the Column Name Condition : " ColName
			exist=$(awk  -F : -v c=$ColName '{if($1 == c)print $0 }' $1.meta)
			if ! [[ $exist == "" ]]
			then
				(( ConditionColNum=$(awk  -F : -v c=$ColName '{if($1 == c)print NR }' $1.meta) -1 ))
				read -p "Enter the Value Condition : " Val
				ValExist=$(awk  -F : -v c=$Val '{if($'$ConditionColNum' == c)print $0 }' $1)
				ConditionValPlace=($(awk -F : -v c=$Val '{if($'$ConditionColNum' == c)print NR }' $1))
				if ! [[ $ValExist == "" ]]
				then
					PassFlag=0
					read -p "Enter Column Name to Set: " ColToSet
					exist=$(awk  -F : -v c=$ColToSet '{if($1 == c)print $0 }' $1.meta)
					type=$(awk  -F : -v c=$ColToSet '{if($1 == c)print $2 }' $1.meta)
					PK=$(awk  -F : -v c=$ColToSet '{if($1 == c)print $3 }' $1.meta)
					if ! [[ $exist == "" ]]
					then
						(( ColToSetNum=$(awk  -F : -v c=$ColToSet '{if($1 == c)print NR }' $1.meta) -1 ))
						read -p "Enter the New Value : " NewVal
						if [[ $type == "Integer" ]]
						then
							if ! [[ $NewVal =~ ^[0-9]+$ ]]
							then
								PassFlag=1
								echo "Invailed Input"
							fi
						elif [[ $type == "Sting" ]]
						then
							if ! [[ $NewVal =~ ^[a-zA-Z]+$ ]]
							then
								PassFlag=1
								echo "Invailed Input"
							fi
						fi
						if [[ $PK == "Yes" ]]
						then
							Arr=($(awk -F : '{print $'$ColToSetNum'}' $1))
						# in case if it is primary key we have to make sure the value are unique
							for i in ${Arr[*]}
							do
								if [[ $i -eq  $NewVal ]]
								then
									PassFlag=1
									echo "PrimaryKey, This Filed has the same value you entered"
									break
								fi
							done
						fi
						if [[ $PassFlag == 0 ]]
						then
							for j in ${ConditionValPlace[*]}
							do
								old=$(awk -F : -v c=$j '{if(NR == c) print $'$ColToSetNum'}' $1)
								awk -F : -v c=$j 'BEGIN { OFS = ":"; ORS = "\n" }{if(NR == c) $'$ColToSetNum'="'$NewVal'"; print $0}' $1 > .temp
								cat .temp > $1 
								rm .temp
							done
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
