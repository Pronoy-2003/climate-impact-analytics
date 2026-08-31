"""
SQL Server Database Connection

This module manages the SQL Server database connection used by the
data pipeline.

It loads database configuration from environment variables, validates
the required settings, and provides a function to create a SQL Server
connection using pyodbc.
"""


import os

import pyodbc

from dotenv import load_dotenv


# ============================================================
# LOAD ENVIRONMENT VARIABLES
# ============================================================

load_dotenv()


# ============================================================
# DATABASE CONFIGURATION
# ============================================================

SQL_SERVER = os.getenv("SQL_SERVER")

SQL_DATABASE = os.getenv("SQL_DATABASE")

SQL_DRIVER = os.getenv("SQL_DRIVER")


# ============================================================
# VALIDATE CONFIGURATION
# ============================================================

if not SQL_SERVER:
    raise ValueError(
        "SQL_SERVER is not configured in .env"
    )

if not SQL_DATABASE:
    raise ValueError(
        "SQL_DATABASE is not configured in .env"
    )

if not SQL_DRIVER:
    raise ValueError(
        "SQL_DRIVER is not configured in .env"
    )


# ============================================================
# CREATE SQL SERVER CONNECTION
# ============================================================

def get_sql_connection():

    connection_string = (

        f"DRIVER={{{SQL_DRIVER}}};"

        f"SERVER={SQL_SERVER};"

        f"DATABASE={SQL_DATABASE};"

        "Trusted_Connection=yes;"

        "TrustServerCertificate=yes;"

    )


    connection = pyodbc.connect(
        connection_string
    )


    return connection
