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