#!/bin/bash
. CreateTable.sh
. TableBaseFunc.sh
function TableMenu {
    while [ true ]
    do
        echo "--------------MENU---------------"
        select Menu in "Create New Table" "List Tables" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
        do
            case $Menu in
                "Create New Table" )
		clear
                read -p "Enter Table name: " Table
                CreateTable $Table
                break;;
                "List Tables" )
		clear
                ListTables
                break;;
                "Drop Table" )
		clear
                read -p "Enter Table Name: " Table
                DropTable $Table
                break;;
                "Insert Into Table" )
		clear
                read -p "Enter Table name: " Table
                InsertTable $Table
                break;;
                "Select From Table" )
		clear
                read -p "Enter Table name: " Table
                SelectFromTable $Table
                break;;
                "Delete From Table" )
		clear
                read -p "Enter Table name: " Table
                DeleteFromTable $Table
                break;;
                "Update Table" )
		clear
                read -p "Enter Table name: " Table
                UpdateTable $Table
                break;;
		"Exit")
		clear
		cd ../..
		pwd
		break 2 ;;
                * )
		clear
		echo "Invalid Choice"
            esac
        done
    done
}