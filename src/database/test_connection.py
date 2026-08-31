"""
SQL Server Connection Test

This script verifies that the application can successfully connect
to the configured SQL Server database.

It establishes a connection, retrieves the current database name,
prints the connection status, and then closes the database resources.
"""


from src.database.sql_server import get_sql_connection


def main():

    connection = get_sql_connection()

    cursor = connection.cursor()

    cursor.execute(
        "SELECT DB_NAME()"
    )

    database_name = cursor.fetchone()[0]

    print(
        f"Connected successfully!"
    )

    print(
        f"Database: {database_name}"
    )

    cursor.close()

    connection.close()


if __name__ == "__main__":
    main()
