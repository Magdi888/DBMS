# DBMS-Using-Bash-Shell-Scripting #
### The Team
[Ahmed Rizk](https://github.com/AhmedRezk95),  [Ahmed Magdi](https://github.com/Magdi888)

Please feel free to communicate with us in anytime :)
### More about the project
In this project we are trying to demonstrate some core features in bash scripting such as:
- sourcing in bash
- awk in bash
- sed in bash

### Before you run
- Make sure to set the project path in .bashrc
```bash
export PATH=$PATH:/"project_path_inside_your_machine"
```
- Make sure that all files has the execution premission

### To run the project
- In your local terminal type the following:
```bash
MainMenu.sh
```
### Structure of DBMS Engine
Basically there are two levels:
- Upperlayer level
- Database level
- Table level

### Structure in Details
First, the engine will create a directory Called "DB" and this is the upper layer directory which will store database directories.
Second, the database directories which will contains the tables.
Third, the tables level, in every table creation in DBMS, the engine will actually create two files:
- MetaData file
- Data file

#### MetaData file:
- It represents table schema informations like (column names, type of that column(String, Integer), which column is the primary key)

#### Data file:
- It represents the actual data stored by you

#### Note:
In this engine we offer one primary key for every single table, composite primary keys are not yet available

## Inside the engine
- You will have two menus

### Database Menu
<table>
<tr>
    <td><b> Create Database </b></td>
    <td> Create a directory to store tables </td>
</tr>
<tr>
    <td><b> Connect to Database </b></td>
    <td> Once you type the database name, system will check if database's dirctory is existed or not, if it is there, engine will enter to the table menu </td>
</tr>
<tr>
    <td><b> Show Databases </b></td>
    <td> Simply display all Database directories  </td>
</tr>
<tr>
    <td><b> Drop Database </b></td>
    <td> In case you want to remove a specific Database, once you type the database name it removes its directory </td>
</tr>
<tr>
    <td><b> Exit </b></td>
    <td> A Safe exit from the engine </td>
</tr>
</table>

### Table Menu
<table>
<tr>
    <td><b> Create New Table </b></td>
    <td> Create a new table inside the existing database directory </td>
</tr>
<tr>
    <td><b> List Tables </b></td>
    <td> Simply display all tables names </td>
</tr>
<tr>
    <td><b> Drop Table </b></td>
    <td> In case you want to remove an existing table, once you type the database name it removes its directory  </td>
</tr>
<tr>
    <td><b> Insert Into Table </b></td>
    <td> Just like any database engine if you want to add new record to the table, you just specify all values base on table schema </td>
</tr>
<tr>
    <td><b> Select From Table </b></td>
    <td> you have multiple options in case you want to see the data (1- All records 2-Specific Column 3-Specifc Column 4-With Condition </td>
</tr>
<tr>
    <td><b> Delete From Table </b></td>
    <td> delete a record inside a specific table based on a column value </td>
</tr>
<tr>
    <td><b> Update Table </b></td>
    <td> Edit any record based on any column and set the new value </td>
</tr>
<tr>
    <td><b> Exit </b></td>
    <td> A Safe exit from the table menu and get back to database menu </td>
</tr>
</table>
