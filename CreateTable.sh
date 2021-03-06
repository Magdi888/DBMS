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
        else
	    echo "Invalid Input"
        fi
    fi
}

function CreateTableValue {
    read -p "Enter Number of columns: " NumbOfColumn
    # Check if it is a number
    if [[ $NumbOfColumn =~ ^[0-9]+$ ]]
    then
        # if it is not equal to zero
	    if [[ $NumbOfColumn != 0 ]]
	    then

# create inital parameters
    (( counter=1 ))
    columnDelimiter=":"
    rowSperator="\n"
    ColumnPK="No"
    metaData="Field"$columnDelimiter"Type"$columnDelimiter"PK"
    while [[ counter -le NumbOfColumn ]]
    do
        read -p "Enter column Name $counter : " ColumnName
    if ! [[ $OldName == $ColumnName ]]
    then
        if [[ $ColumnName =~ ^[a-zA-Z] ]]
        then
            # Select variable type
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
            # Set the primary key
            if [[ $ColumnPK == "No" ]]
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
                        ColumnPK="No"
                        metaData+=$rowSperator$ColumnName$columnDelimiter$ColumnType$columnDelimiter$ColumnPK
                        break;;
                        * ) 
                        echo "Invalid"
                    esac
                done
            else
            # Code is designed for only one PK per table in case if you select primary key once, you don't have to go to select menu again
                metaData+=$rowSperator$ColumnName$columnDelimiter$ColumnType$columnDelimiter"No"
            fi
            OldName=$ColumnName
            (( counter++ ))
        else
            echo "Column Name Must Be String"
            continue
        fi
    else 
        echo "There is column Has This Name"
        continue
    fi
    done
# in case if user didn't set any primary key on any parameter -> it will loop back again 
    if [[ $ColumnPK == "No" ]]
    then
        echo "There is No PK"
        echo "Insert your Data Again"
        CreateTableValue $1
    else
        touch $1 $1.meta
        echo -e $metaData >> $1.meta
    fi
    else
	    echo "Number of columns Can Not Be Zero "
	    CreateTableValue $1
    fi
    else
	    echo "Number of columns Must Be Number "
	    CreateTableValue $1
    fi

}
