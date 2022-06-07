#!/bin/bash
. CreateTable.sh
. DropTable.sh
. DeleteFromTable.sh
. InsertTable.sh
. UpdateTable.sh
. SelectFromTable.sh
. ListTables.sh

function TableMenu {
    while [ true ]
    do  
        echo -e "\n--------------MENU---------------"
        select Menu in "Create New Table" "List Tables" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
        do
            case $Menu in
                "Create New Table" )
		clear
                echo "___________________________________________"
                read -p "Enter Table name: " Table
                CreateTable $Table
                echo "___________________________________________"
                break;;
                "List Tables" )
		clear
                echo "___________________________________________"
                ListTables
                echo "___________________________________________"
                break;;
                "Drop Table" )
		clear
                echo "___________________________________________"
                read -p "Enter Table Name: " Table
                DropTable $Table
                echo "___________________________________________"
                break;;
                "Insert Into Table" )
		clear
                echo "___________________________________________"
                read -p "Enter Table name: " Table
                InsertTable $Table
                echo "___________________________________________"
                break;;
                "Select From Table" )
		clear
                echo "___________________________________________"
                read -p "Enter Table name: " Table
                SelectFromTable $Table
                echo "___________________________________________"
                break;;
                "Delete From Table" )
		clear
                echo "___________________________________________"
                read -p "Enter Table name: " Table
                DeleteFromTable $Table
                echo "___________________________________________"
                break;;
                "Update Table" )
		clear
                echo "___________________________________________"
                read -p "Enter Table name: " Table
                UpdateTable $Table
                echo "___________________________________________"
                break;;
		"Exit")
		clear
		cd ../..
		break 2 ;;
                * )
		clear
                echo "___________________________________________"
		echo "Invalid Choice"
                echo "___________________________________________"
            esac
        done
    done
}
