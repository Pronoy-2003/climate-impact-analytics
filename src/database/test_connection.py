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