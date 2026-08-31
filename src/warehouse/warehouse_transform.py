"""
Warehouse Transformation

This script runs the SQL Server warehouse transformations that move
data through the Bronze → Silver → Gold layers.

It loads and cleans weather and air-quality data into Silver, builds
the Gold environmental fact table, and commits the complete
transformation as a database transaction.
"""


from src.database.sql_server import get_sql_connection


def run_warehouse_transformations():

    connection = None
    cursor = None

    try:

        print(
            "\n"
            "=============================================="
        )

        print(
            "      BRONZE → SILVER → GOLD"
        )

        print(
            "=============================================="
        )


        # ------------------------------------------------
        # CONNECT
        # ------------------------------------------------

        connection = get_sql_connection()

        cursor = connection.cursor()


        # ------------------------------------------------
        # BRONZE → SILVER
        # ------------------------------------------------

        print(
            "\nLoading Silver weather..."
        )

        cursor.execute(
            "EXEC silver.load_weather;"
        )

        print(
            "Silver weather completed."
        )


        print(
            "Loading Silver air quality..."
        )

        cursor.execute(
            "EXEC silver.load_air_quality;"
        )

        print(
            "Silver air quality completed."
        )


        # ------------------------------------------------
        # SILVER → GOLD
        # ------------------------------------------------

        print(
            "\nLoading Gold fact environment..."
        )

        cursor.execute(
            "EXEC gold.load_fact_environment;"
        )

        print(
            "Gold fact environment completed."
        )


        # ------------------------------------------------
        # COMMIT
        # ------------------------------------------------

        connection.commit()


        print(
            "\n"
            "Warehouse transformation completed."
        )

        print(
            "Bronze → Silver → Gold SUCCESS"
        )


    except Exception as e:

        if connection:
            connection.rollback()

        print(
            "\n"
            "ERROR: Warehouse transformation failed."
        )

        print(
            f"Error: {e}"
        )

        raise


    finally:

        if cursor:
            cursor.close()

        if connection:
            connection.close()
