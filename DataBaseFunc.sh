#!/bin/bash
. Table.sh
function showDatabases {
	list=$(ls DB | wc -l)
    # Check if it is empty or not
	if [[ $list == 0 ]]
	then
		echo "Empty"
	else
		ls DB
	fi
}

function connectToDatabase {
    Db="DB/$1"
    if [ -d $Db ]
    then
        echo "$1 DataBase Connected"
        cd $Db
        TableMenu 
    else
        echo "This database does not exist"
        echo "Do you want to create $1 ?"
	    echo "___________________________________________"
	    select i in "Yes" "No"
	    do
         	 case $i in
		    "Yes")
           		createDatabase $1
			 break;;
		     "No")
			 break;;
		        *)
			echo "Invalid Choice"
	          esac
	    done
    fi
}

function createDatabase {
    Db="DB/$1"
    if [ $# -ne 1 ]
    then
        echo "Invalid Input"
    else
	    if [[ $1 =~ ^[./] ]]      #### . directory already exist
	    then
	    echo "Invalid Input"
        elif [ -d $Db ]
        then
            echo "$1 already exists"
		# check if the first character is string
        elif [[ $1 =~ ^[a-zA-Z] ]]
	    then
			
	        mkdir -p $Db
	        echo " $1 Data Base is Created"
        else
	        echo "Invalid Input"
	    
        fi
    fi
}

function dropDatabase {
    Db="DB/$1"
    if [ $# -eq 1 ]
    then
        if [ -d $Db ]
        then
	    echo "___________________________________________"
	    echo "Do you want to delete $1 ?"
	    echo "___________________________________________"
	    select i in "Yes" "No"
	    do
         	 case $i in
		    "Yes")
           		 rm -r $Db
           		 echo "$1 is deleted successfully"
			 break;;
		     "No")
			 break;;
		        *)
			echo "Invalid Choice"
	          esac
	    done
        else
            echo "This is not a valid database name"
            echo "Please try again with the right name"
        fi
    else
        echo "You Can Not Delete More Than One DB"
    fi
}
