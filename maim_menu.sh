#!/usr/bin/bash
# Check if the databases directory exists or not
db_dir="./db"
if [ ! -d "$db_dir" ]; then
    mkdir -p "$db_dir"
fi

# Function to display the main menu
main_menu(){
 choice=$(zenity --list --title="Database Menu" --text="Please select an option:" --column="database options" \
  "Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit")
    echo $case
    case $choice in
        "Create Database") create_database ;;
        "List Databases") list_databases ;;
        "Connect to Database") connect_database ;;
        "Drop Database") drop_list ;;
        "Exit") exit_script ;;
        *) echo "Invalid choice! Please try again." ;;
    esac
    main_menu
}

# Function to create a new database
create_database() {
    dbname=$(zenity --entry --text="Enter Database name: ")
  ## $dbname="dsfbweh"
    if [ -d "$db_dir/$dbname" ]; then
        zenity --error --text="Database $dbname already exists !"
    else
        mkdir -p "$db_dir/$dbname"
        zenity --info --text="Database $dbname created successfully!"
    fi
    main_menu
}

list_databases(){
if [ $(ls "$db_dir" | wc -l) -eq 0 ]; then 
zenity --info --text="system doesn't contain a database"

else
 zenity --list --column="databases" $(ls "$db_dir")
fi

}


connect_database() {
    
    dbname=$(zenity --entry --text="Enter Database name to connect with: ")

    if [ -d "$db_dir/$dbname" ]; then
	PS3="[$dbname]>"
        source dbms "$dbname"
    else
        zenity --error --text="database $dbname doesn't exist "
        main_menu
    
	fi

}

drop_list(){
	#check if system has databases or not
	if [ $(ls "$db_dir" | wc -l) -eq 0 ]; then
    zenity --error --text="system doesn't contain any database"
	main_menu
	return
	fi
    dbname=$(zenity --entry --text="Enter Database name to drop connect with: ")
	#check if data base is empty
    if [ -z "$dbname" ]; then
        zenity --error --text="you must enter a database name to drop"
        main_menu
        return
    fi
	#check existing of database
    if [ ! -d "$db_dir/$dbname" ]; then
    
        zenity --error --text="you must enter a database name to drop"
        main_menu
        return
    fi
    ans=$(zenity --entry --text="are you sure you want to drop the database $dbname ? [y/n]")
    if [[ "$ans" != "y" ]]; then
        zenity --info --text="cancel..."
        main_menu
        return
    fi

    rm -r "$db_dir/$dbname"
    if [ $? -eq 0 ]; then
        zenity --info --text="$dbname dropped succesfully."
    else
        zenity --info --text="failed to drop database $dbname"
    fi

    main_menu
}

exit_script() {
    zenity --info --text="exist the script"
    exit 0
}

main_menu
