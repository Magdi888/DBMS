#!/bin/bash
. DataBaseFunc.sh
mkdir -p DB
function mainmenu {
	while [ true ]
	do
		echo "Enter your choice: "
		echo "___________________________________________"
		select i in "Create Database" "Connect to Database" "Show Databases" "Drop Database" "Exit"
		do
			case $i in
				"Create Database" ) 
				
					clear
					echo "___________________________________________"
					echo "type Database Name please"
					read  dbName
					createDatabase $dbName
					echo "___________________________________________"
					break ;;
				"Connect to Database" )
					clear
					echo "___________________________________________"
					echo "Enter a database name to connect to "
					read  dbName
					echo "___________________________________________"
					connectToDatabase $dbName
					echo "___________________________________________"
					break ;;
				"Show Databases" )
					clear
					echo "___________________________________________"
					echo "Available Databases"
					echo "___________________________________________"
					showDatabases
					echo "___________________________________________"
					break ;;
				"Drop Database" )
					clear
					echo "___________________________________________"
					echo "Enter a databse name you want to drop"
					read  dbName
					echo "___________________________________________"
					dropDatabase $dbName
					echo "___________________________________________"
					break ;;
				"Exit" )
					clear
					exit;;
				* )
					clear
					echo "___________________________________________"
					echo "This is not a valid choice"
					echo "___________________________________________"
					break ;;
			esac
		done
	done
}
mainmenu

