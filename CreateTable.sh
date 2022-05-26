#!/bin/bash

function CreateTable {
# Check if user enters more than one table
    if [ $# -ne 1 ]
    then
        echo "Invalid Input, Enter only one Table"
    else
# Check if file is existed
        if [ -f $1 ]
        then
            echo "$1 already exists"
# Check if there is a special character in table name
        elif [[ $1 =~ ^[a-zA-Z] ]]
	    then
	    CreateTableValue $1
	    echo " $1 Table is Created"
	    pwd
        else
	    echo "Invalid Input"
        fi
    fi
}

function CreateTableValue {
    read -p "Enter Column Number: " ColumnNumber
    if [[ $ColumnNumber =~ ^[0-9]+$ ]]
    then
	    if [[ $ColumnNumber != 0 ]]
	    then

# create inital parameters
    (( counter=1 ))
    columnDelimiter=":"
    rowSperator="\n"
    ColumnPK=""
    metaData="Field"$columnDelimiter"Type"$columnDelimiter"PK"
    while [[ counter -le ColumnNumber ]]
    do
        read -p "Enter column Name $counter : " ColumnName
	if [[ $ColumnName =~ ^[a-zA-Z] ]]
	then
        echo "----Select Column Type----"
        select x in "Integer" "String"
        do
            case $x in
                "Integer" ) 
                ColumnType="Integer"
                break;;
                "String" ) 
                ColumnType="String"
                break;;
                * ) 
                echo "Invalid Type"
            esac
        done
        if [[ $ColumnPK == "" ]]
        then
            echo " Is it a PK? "
            select y in "Yes" "No"
            do
                case $y in
                    "Yes" ) 
                    ColumnPK="Yes"
                    metaData+=$rowSperator$ColumnName$columnDelimiter$ColumnType$columnDelimiter$ColumnPK
                    break;;
                    "No" ) 
                    ColumnPK=""
                    metaData+=$rowSperator$ColumnName$columnDelimiter$ColumnType$columnDelimiter$ColumnPK
                    break;;
                    * ) 
                    echo "Invalid"
                esac
            done
        else
            metaData+=$rowSperator$ColumnName$columnDelimiter$ColumnType$columnDelimiter""
        fi
        (( counter++ ))
	else
	    echo "Column Name Must Be String"
	    continue
	fi
    done
# in case if user didn't set any primary key on any parameter -> it will loop back again 
    if [[ $ColumnPK == "" ]]
    then
        echo "There is No PK"
        echo "Insert your Data Again"
        CreateTableValue $1
    else
        touch $1 $1.meta
        echo -e $metaData >> $1.meta
    fi
    else
	    echo "ColumnNumber Can Not Be Zero "
	    CreateTableValue $1
    fi
    else
	    echo "ColumnNumber Must Be Number "
	    CreateTableValue $1
    fi

}
