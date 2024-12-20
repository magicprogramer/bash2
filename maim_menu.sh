#!/bin/bash

# Check if the databases directory exists or not
db_dir="./db"
if [ ! -d "$db_dir" ]; then
    mkdir -p "$db_dir"
fi

# Function to display the main menu
main_menu() {
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect To Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) create_database ;;
        2) list_databases ;;
        3) connect_database ;;
        4) drop_database ;;
        5) exit_script ;;
        *) echo "Invalid choice! Please try again." ;;
    esac
    main_menu
}

# Function to create a new database
create_database() {
    read -p "Enter Database name: " dbname
    if [ -d "$db_dir/$dbname" ]; then
        echo "Database $dbname already exists!"
    else
        mkdir -p "$db_dir/$dbname"
        echo "Database $dbname created successfully!"
    fi
    main_menu
}

list_databases(){
if [ $(ls "$db_dir" | wc -l) -eq 0 ]; then 
echo "System doesn't contain any database"

else
echo "Databases in system: "	
ls "$db_dir"
fi

}


connect_database() {
    read -p "Enter database name to connect: " dbname

    if [ -d "$db_dir/$dbname" ]; then
	PS3="[$dbname]>"
        source dbms "$dbname"
    else
        echo "Database '$dbname' doesn't exist."
        main_menu
    
	fi

}

drop_list(){
	#check if system has databases or not
	if [ $(ls "$db_dir" | wc -l) -eq 0 ]; then
	echo "System doesn't contain any database to delete"
	main_menu
	return
	fi
    read -p "Enter database name to drop: " dbname
	#check if data base is empty
    if [ -z "$dbname" ]; then
        echo "You must enter the database name to drop."
        main_menu
        return
    fi
	#check existing of database
    if [ ! -d "$db_dir/$dbname" ]; then
        echo "Database '$dbname' does not exist."
        main_menu
        return
    fi

	#cofirm deleting the database
    read -p "Are you sure you want to drop the database '$dbname'? [y/n]: " ans
    if [[ "$ans" != "y" ]]; then
        echo "canceling drop of database .."
        main_menu
        return
    fi

    rm -r "$db_dir/$dbname"
    if [ $? -eq 0 ]; then
        echo "Database '$dbname' dropped successfully."
    else
        echo " Failed to delete database '$dbname'."
    fi

    main_menu
}

exit_script() {
    echo "Exiting the script.."
    exit 0
}

main_menu
