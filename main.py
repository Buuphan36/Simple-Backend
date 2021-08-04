from database import DB


class Account:
    def __init__(self, name, user_id):
        self.name = name
        self.user_id = user_id


def show_table_names(db_object, tables, account, database):
    """
    Show all the tables names
    :param tables: a list with the tables names.
                   You can get it by calling the method
                   get_table_names() from DB object
    :return: VOID
    """
    table_size = db_object.get_table_names()
    # checks for unusual changes to the table
    if len(tables) != len(table_size):
        print('A problem has occurred with the database! Attempting to restart...')
        db_object.create_database(database=database, drop_database_first=True)
        db_object.run_sql_file("databasemodel.sql")
        db_object.run_sql_file("insert.sql")
        db_object.run_sql_file("transactions.sql")
        print('Database has been restore!')

    # checks for admin
    if account.name == "admin" and account.user_id == 1:
        index = 1
        print('Available tables for {}'.format(account.name))
        print("\nTables: ")
        for table in tables:
            print('{}. {}'.format(index, table[0]))  # print tables names
            index += 1

    # for normal users
    else:
        print('Available tables for {}'.format(account.name))
        index = 1
        normal_tables = ['doctor', 'medical_field', 'medical_exam', 'healthcare_plan']
        for table in normal_tables:
            print('{}. {}'.format(index, table))  # print tables names
            index += 1


def create_account(db_object):
    print('\n--------Create Account--------')
    user_firstname = input('Please enter your name: ')
    user_lastname = input('Please enter your last name: ')
    user_email = input('Please enter your Email: ')
    user_password = input('Please enter a password: ')
    attributes = ['user_firstname', 'user_lastname', 'user_email']
    values = [user_firstname, user_lastname, user_email]
    try:
        if db_object.insert(table='user', attributes=attributes, values=values):
            # creates a user and account with default password
            try:
                query = """UPDATE account JOIN user ON account.account_id = user.user_id
                                       SET account.account_password= '{}' 
                                       WHERE user.user_email = '{}'""".format(user_password, user_email)
                # updates account password
                if db_object.update(query):
                    print('Account successfully created!')
            except:
                print('Failed to set password!')
    except:
        print("Error: failed to create an account!")


def login(db_object):
    print('\n----------Login----------')
    try:
        # get user input
        value = input('Please enter your email: ')
        user_password = input('Please enter your password: ')

        # build queries with the user input
        query = """SELECT user.user_id, user.user_firstname, user.user_email, account.account_password FROM user 
                              JOIN account ON account.account_id = user.user_id
                              WHERE user.user_email = '{}'""".format(value)

        # get the results from the above query
        results = db_object.select(query=query)
        user_id = results[0][0]
        username = results[0][1]
        password = results[0][3]

        # checks user password
        if user_password == password:
            print('Logged in as', username)
            return Account(username, user_id)
        else:
            print('Email or Password is invalid')
    except:  # handle error
        print("Error: failed to log in!\n")


# accepts in a number and returns the name of the table selected
def table_list(tables):
    table_index = int(input("\nSelect a table number, 0 to exit: "))
    # for exiting
    if table_index == 0:
        return None
    # Checks for admin
    if account.name == "admin" and account.user_id == 1:
        print('You have selected this table:', tables[table_index - 1][0])
        return tables[table_index - 1][0]
    # for normal users
    else:
        table = ['doctor', 'medical_field', 'medical_exam', 'healthcare_plan']
        print('You have selected this table:', table[table_index - 1])
        return table[table_index - 1]


def search(db_object, tables, account, database):
    print('\n----------Search----------')
    # checks if the user login yet
    if not account:
        print('Please login first!')
        return
    try:
        # shows that tables names in menu
        show_table_names(db_object, tables, account, database)
        # get user input
        table_selected = table_list(tables)

        # exits if users enter 0
        if not table_selected:
            return
        attribute_selected = input("Search by (i.e name)? ")
        value = input("Enter the value: ")

        # build queries with the user input
        query = """SELECT * FROM {} WHERE {} = %s""".format(table_selected, attribute_selected)

        if table_selected == "medical_exam":
            query = """SELECT doctor.doctor_name as examiner, medical_field.field_name as field, user.user_firstname as patient, medical_exam.schedule FROM medical_exam
									JOIN doctor ON medical_exam.examiner = doctor.doctor_id
                                    JOIN medical_field ON doctor.doctor_specialty = medical_field.medical_field_id
                                    JOIN user ON medical_exam.patient = user.user_id
                                    WHERE medical_exam.{} = '{}'""".format(attribute_selected, value)
            results = db_object.select(query=query)
            columns = ['Examiner', 'Field', 'Patient', 'Time']
            if len(results) == 0:
                print('Error: data does not exist or is deleted!')
                return
            print("\n")
            print("Results from: " + table_selected)
            # prints result
            result_counter = 1
            for result in results:
                result_index = 0
                print('\n---------RESULT#{}---------'.format(result_counter))
                for column in columns:
                    print("{}: {}".format(column, result[result_index]))
                    result_index += 1
                result_counter += 1
                print("\n")

        elif table_selected == "doctor":
            query = """SELECT doctor.doctor_name as name, medical_field.field_name as specialty FROM doctor
							JOIN  medical_field ON medical_field.medical_field_id = doctor.doctor_specialty
                            WHERE doctor.{} = '{}'""".format(attribute_selected, value)
            results = db_object.select(query=query)
            columns = ['Name', 'Specialty']
            if len(results) == 0:
                print('Error: data does not exist or is deleted!')
                return
            print("\n")
            print("Results from: " + table_selected)
            result_counter = 1
            for result in results:
                result_index = 0
                print('\n---------RESULT#{}---------'.format(result_counter))
                for column in columns:
                    print("{}: {}".format(column, result[result_index]))
                    result_index += 1
                result_counter += 1
                print("\n")

        elif table_selected == "medical_field":
            query = """SELECT medical_field.field_name as field, doctor.doctor_name as doctor FROM medical_field
                                JOIN doctor ON doctor.doctor_specialty = medical_field.medical_field_id
                                WHERE medical_field.{} = '{}'""".format(attribute_selected, value)
            results = db_object.select(query=query)
            columns = ['Field', 'Available Doctor']
            if len(results) == 0:
                print('Error: data does not exist or is deleted!')
                return
            print("\n")
            print("Results from: " + table_selected)
            result_counter = 1
            for result in results:
                result_index = 0
                print('\n---------RESULT#{}---------'.format(result_counter))
                for column in columns:
                    print("{}: {}".format(column, result[result_index]))
                    result_index += 1
                result_counter += 1
                print("\n")
        else:
            columns = db_object.get_column_names(table_selected)  # get columns names for the table selected
            # get the results from the above query
            results = db_object.select(query=query, values=value)
            if len(results) == 0:
                print('Error: data does not exist or is deleted!')
                return
            # print results
            print("\n")
            print("Results from: " + table_selected)
            result_counter = 1
            for result in results:
                result_index = 0
                print('\n---------RESULT#{}---------'.format(result_counter))
                for column in columns:
                    print("{}: {}".format(column[0], result[result_index]))
                    result_index += 1
                result_counter += 1
                print("\n")
    except:  # handle error
        print("Error: the data requested couldn't be found!\n")


def insert(db_object, tables, account, database):
    print('\n---------Insert---------')
    if not account:
        print('Please login first!')
        return
    try:
        # show tables names
        show_table_names(db_object, tables, account, database)
        table = table_list(tables)
        if not table:
            return
        # get user input for insert
        attributes_str = input("Enter the name attribute/s separated by comma? ")
        values_str = input("Enter the values separated by comma: ")

        # from string to list of attributes and values
        if "," in attributes_str:  # multiple attributes
            attributes = attributes_str.split(",")
            values = values_str.split(",")
        else:  # one attribute
            attributes = [attributes_str]
            values = [values_str]

        if db_object.insert(table=table, attributes=attributes, values=values):
            print("Data successfully inserted into {} \n".format(table))

    except:  # data was not inserted, then handle error #
        print("Error:", values_str, "failed to be inserted in ", table, "\n")


def update(db_object, tables, account, database):
    print('\n----------Update----------')
    if not account:
        print('Please login first!')
        return
    # show tables names
    show_table_names(db_object, tables, account, database)
    table = table_list(tables)
    if not table:
        return
    user_fields = input("Enter a field: ")
    user_values = input("Enter a value: ")

    if "," in user_values:  # multiple attributes
        fields = user_fields.split(",")
        values = user_values.split(",")
    else:
        fields = [user_fields]
        values = [user_values]
    fields_to_str = ", ".join(fields)
    query = """UPDATE {} SET {}=""".format(table, fields_to_str)
    try:
        if db_object.update(query=query, values=values):
            print("Data successfully update data in {} \n".format(table))

    except:
        print("Error: failed to update data in", table, "\n")


def delete(db_object, tables, account, database):
    print('\n----------Delete----------')
    if not account:
        print('Please login first!')
        return
    # show tables names
    show_table_names(db_object, tables, account, database)
    table = table_list(tables)
    if not table:
        return
    field = input("Enter a field: ")
    values = input("Enter a value: ")
    query = """DELETE FROM {} WHERE {} =""".format(table, field)
    try:
        if db_object.delete(query=query, values=values):
            print("Data successfully deleted in {} \n".format(table))
    except:
        print("Error: failed to delete data in", table, "\n")


if __name__ == '__main__':

    print("Setting up the database......\n")

    # DB API object
    db = DB(config_file="sqlconfig.conf")

    # create a database (must be the same as the one is in your config file)
    database = "healthcaredb"
    if db.create_database(database=database, drop_database_first=True):
        print("Created database {}".format(database))
    else:
        print("An error occurred while creating database {} ".format(database))

    # create all the tables from databasemodel.sql
    db.run_sql_file("databasemodel.sql")
    db.trigger()
    # insert sample data from insert.sql
    db.run_sql_file("insert.sql")

    print("\nSet up process finished\n")
    tables = db.get_table_names()
    account = None
    while True:
        try:
            print('USER MENU')
            print('1. Create Account')
            print('2. Login ')
            print('3. Search')
            print('4. Insert')
            print('5. Update')
            print('6. Delete')
            print('7. Exit')
            print('\n')
            user_input = int(input('Select an option: '))
            if user_input == 1:
                create_account(db)
            elif user_input == 2:
                account = login(db)
            elif user_input == 3:
                search(db, tables, account, database)
            elif user_input == 4:
                insert(db, tables, account, database)
            elif user_input == 5:
                update(db, tables, account, database)
            elif user_input == 6:
                delete(db, tables, account, database)
            elif user_input == 7:
                print('Have a nice day!')
                break
            else:
                # checks if the user enter a number that is out of scope
                print('Please enter a number between 1-7 only!')
        except:
            print('NOT A VALID INPUT!')
