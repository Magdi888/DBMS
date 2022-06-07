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
					read -p "Enter Database Name please: " dbName 
					createDatabase $dbName
					echo "___________________________________________"
					break ;;
				"Connect to Database" )
					clear
					echo "___________________________________________"
					read -p "Enter a database name to connect: " dbName
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
					read -p  "Enter a database name you want to drop: " dbName
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
					echo "Invalid Choice"
					echo "___________________________________________"
					break ;;
			esac
		done
	done
}
mainmenu

