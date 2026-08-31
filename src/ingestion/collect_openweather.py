"""
OpenWeather Data Ingestion Pipeline

This script collects weather and air-quality data for the monitored cities,
saves each collection cycle as raw JSON, loads the data into the SQL Server
Bronze layer, and triggers the Silver → Gold warehouse transformations.

The pipeline runs automatically every 5 minutes for a maximum of 10 hours
and performs daily data validation after the collection session.
"""


import os
import json
import time
import uuid
import logging
from datetime import datetime, timezone

from src.config.cities import CITIES

from src.api.openweather import (
    get_weather,
    get_air_quality
)

from src.validation.daily_validation import (
    generate_report
)

from src.warehouse.bronze_loader import (
    load_batch
)

from src.warehouse.warehouse_transform import (
    run_warehouse_transformations
)


# ============================================================
# CONFIGURATION
# ============================================================

# Collect data every 5 minutes
COLLECTION_INTERVAL_SECONDS = 5 * 60

# Maximum time to run the ingestion process
# 10 hours = 36,000 seconds
MAX_RUNTIME_SECONDS = 10 * 60 * 60

# Raw data directory
BASE_RAW_PATH = "data/raw/openweather"

# Log file
LOG_PATH = "logs/openweather_ingestion.log"


# ============================================================
# LOGGING SETUP
# ============================================================

os.makedirs(
    "logs",
    exist_ok=True
)


logging.basicConfig(
    filename=LOG_PATH,
    level=logging.INFO,
    format=(
        "%(asctime)s | "
        "%(levelname)s | "
        "%(message)s"
    )
)


logger = logging.getLogger(
    "openweather_ingestion"
)


# ============================================================
# CREATE DAILY DIRECTORY
# ============================================================

def create_daily_directory():

    now = datetime.now(
        timezone.utc
    )

    directory = os.path.join(
        BASE_RAW_PATH,
        now.strftime("%Y"),
        now.strftime("%m"),
        now.strftime("%d")
    )

    os.makedirs(
        directory,
        exist_ok=True
    )

    return directory




# ============================================================
# COLLECT ONE CITY
# ============================================================

def collect_city(
    city,
    city_info,
    ingestion_id,
    ingestion_timestamp
):

    latitude = city_info["latitude"]

    longitude = city_info["longitude"]

    country = city_info["country"]


    weather_data = None

    air_quality_data = None


    weather_status = "FAILED"

    air_quality_status = "FAILED"


    # --------------------------------------------------------
    # WEATHER API
    # --------------------------------------------------------

    try:

        weather_data = get_weather(
            latitude,
            longitude
        )

        weather_status = "SUCCESS"

        logger.info(
            f"Weather API success | {city}"
        )

    except Exception as e:

        logger.error(
            f"Weather API failed | "
            f"{city} | {str(e)}"
        )


    # --------------------------------------------------------
    # AIR QUALITY API
    # --------------------------------------------------------

    try:

        air_quality_data = get_air_quality(
            latitude,
            longitude
        )

        air_quality_status = "SUCCESS"

        logger.info(
            f"Air Quality API success | {city}"
        )

    except Exception as e:

        logger.error(
            f"Air Quality API failed | "
            f"{city} | {str(e)}"
        )


    # --------------------------------------------------------
    # CITY RECORD
    # --------------------------------------------------------

    city_record = {

        "city": city,

        "country": country,

        "latitude": latitude,

        "longitude": longitude,

        "weather_status": weather_status,

        "air_quality_status": air_quality_status,

        "weather": weather_data,

        "air_quality": air_quality_data

    }


    return city_record


# ============================================================
# SAVE ONE COMPLETE COLLECTION CYCLE
# ============================================================

def save_collection(
    records,
    ingestion_id,
    ingestion_timestamp
):

    directory = create_daily_directory()


    current_time = datetime.now(
        timezone.utc
    )


    filename = (
        "openweather_"
        + current_time.strftime(
            "%Y%m%d_%H%M%S"
        )
        + "_"
        + ingestion_id
        + ".json"
    )


    filepath = os.path.join(
        directory,
        filename
    )


    collection_data = {

        "metadata": {

            "ingestion_id":
                ingestion_id,

            "source":
                "OpenWeather",

            "ingestion_timestamp_utc":
                ingestion_timestamp,

            "city_count":
                len(records),

            "weather_api_calls":
                len(records),

            "air_quality_api_calls":
                len(records),

            "total_api_calls":
                len(records) * 2

        },

        "data": records

    }


    with open(
        filepath,
        "w",
        encoding="utf-8"
    ) as file:

        json.dump(
            collection_data,
            file,
            indent=4,
            ensure_ascii=False
        )


    return filepath


# ============================================================
# ONE INGESTION CYCLE
# ============================================================

def collect_all_cities():

    ingestion_id = str(
        uuid.uuid4()
    )


    ingestion_timestamp = (
        datetime.now(
            timezone.utc
        ).isoformat()
    )


    cycle_start = time.time()


    logger.info(
        "================================================"
    )

    logger.info(
        f"Starting ingestion cycle | "
        f"{ingestion_id}"
    )


    records = []


    # --------------------------------------------------------
    # COLLECT ALL 20 CITIES
    # --------------------------------------------------------

    for city, city_info in CITIES.items():

        print(
            f"Collecting: {city}..."
        )


        city_record = collect_city(
            city=city,
            city_info=city_info,
            ingestion_id=ingestion_id,
            ingestion_timestamp=
                ingestion_timestamp
        )


        records.append(
            city_record
        )


        print(
            f"Completed: {city}"
        )


    # --------------------------------------------------------
    # SAVE ONE FILE
    # --------------------------------------------------------

    filepath = save_collection(
        records=records,
        ingestion_id=ingestion_id,
        ingestion_timestamp=
            ingestion_timestamp
    )

    # --------------------------------------------------------
    # LOAD BATCH INTO SQL SERVER BRONZE
    # --------------------------------------------------------
    
    print(
        "\nLoading batch into SQL Server Bronze..."
    )
    
    try:

        # ====================================================
        # BRONZE
        # ====================================================
    
        load_batch(filepath)
    
        logger.info(
            f"Bronze loading successful | "
            f"File: {filepath}"
        )
    
        print(
            "Bronze loading completed successfully."
        )


        # ====================================================
        # SILVER → GOLD
        # ====================================================
    
        run_warehouse_transformations()


    except Exception as e:
    
        logger.exception(
            f"Data warehouse processing failed | "
            f"{filepath} | {str(e)}"
        )
    
        print(
            "\nWARNING: Data warehouse processing failed."
        )
    
        print(
            f"Error: {e}"
        )


    # --------------------------------------------------------
    # STATISTICS
    # --------------------------------------------------------

    weather_success = sum(
        1
        for record in records
        if record["weather_status"]
        == "SUCCESS"
    )


    air_quality_success = sum(
        1
        for record in records
        if record["air_quality_status"]
        == "SUCCESS"
    )


    cycle_duration = (
        time.time() - cycle_start
    )


    logger.info(
        f"Ingestion completed | "
        f"Weather: "
        f"{weather_success}/20 | "
        f"Air Quality: "
        f"{air_quality_success}/20 | "
        f"Duration: "
        f"{cycle_duration:.2f}s | "
        f"File: {filepath}"
    )


    print(
        "\n"
        "==============================================\n"
        "INGESTION CYCLE COMPLETED\n"
        "=============================================="
    )


    print(
        f"Weather successful: "
        f"{weather_success}/20"
    )


    print(
        f"Air Quality successful: "
        f"{air_quality_success}/20"
    )


    print(
        f"API calls made: "
        f"{len(records) * 2}"
    )


    print(
        f"Duration: "
        f"{cycle_duration:.2f} seconds"
    )


    print(
        f"Saved file:\n"
        f"{filepath}"
    )


    print(
        "==============================================\n"
    )


    return records


# ============================================================
# AUTOMATIC LOOP
# ============================================================

def run_pipeline():

    print(
        "\n"
        "====================================================\n"
        "      CLIMATE IMPACT DATA INGESTION PIPELINE\n"
        "====================================================\n"
    )

    print(
        "Cities monitored       : 20"
    )

    print(
        "Weather calls/cycle    : 20"
    )

    print(
        "Air Quality calls/cycle: 20"
    )

    print(
        "Total calls/cycle      : 40"
    )

    print(
        "Collection interval    : 5 minutes"
    )

    print(
        "Maximum runtime        : 10 hours"
    )

    print(
        "\nPress CTRL+C to stop early.\n"
    )


    logger.info(
        "Automatic OpenWeather "
        "ingestion started"
    )


    # --------------------------------------------------------
    # START TIME
    # --------------------------------------------------------

    pipeline_start_time = time.time()


    cycle_number = 0


    try:

        while True:

            # ------------------------------------------------
            # CHECK RUNTIME
            # ------------------------------------------------

            elapsed_runtime = (
                time.time()
                - pipeline_start_time
            )


            if (
                elapsed_runtime
                >= MAX_RUNTIME_SECONDS
            ):

                print(
                    "\n"
                    "================================================\n"
                    "10-HOUR COLLECTION WINDOW COMPLETED\n"
                    "================================================"
                )


                logger.info(
                    "Maximum runtime of "
                    "10 hours reached."
                )


                break


            # ------------------------------------------------
            # INGESTION CYCLE
            # ------------------------------------------------

            cycle_number += 1


            print(
                f"\n"
                f"Starting collection cycle "
                f"#{cycle_number}"
            )


            cycle_start_time = time.time()


            try:

                collect_all_cities()


            except Exception as e:

                logger.exception(
                    "Unexpected pipeline error: "
                    f"{str(e)}"
                )


                print(
                    f"\nUnexpected error: {e}"
                )


            # ------------------------------------------------
            # CALCULATE REMAINING RUNTIME
            # ------------------------------------------------

            elapsed_runtime = (
                time.time()
                - pipeline_start_time
            )


            remaining_runtime = (
                MAX_RUNTIME_SECONDS
                - elapsed_runtime
            )


            if remaining_runtime <= 0:

                break


            # ------------------------------------------------
            # WAIT UNTIL NEXT 5-MINUTE CYCLE
            # ------------------------------------------------

            cycle_duration = (
                time.time()
                - cycle_start_time
            )


            wait_time = min(
                COLLECTION_INTERVAL_SECONDS
                - cycle_duration,
                remaining_runtime
            )


            wait_time = max(
                0,
                wait_time
            )


            hours_remaining = (
                remaining_runtime
                / 3600
            )


            print(
                f"\nNext collection in "
                f"{wait_time / 60:.2f} minutes."
            )


            print(
                f"Runtime remaining: "
                f"{hours_remaining:.2f} hours."
            )


            time.sleep(
                wait_time
            )


    except KeyboardInterrupt:

        print(
            "\n"
            "================================================\n"
            "INGESTION STOPPED BY USER\n"
            "================================================"
        )


        logger.info(
            "Automatic ingestion "
            "stopped by user."
        )


    # --------------------------------------------------------
    # FINAL SUMMARY
    # --------------------------------------------------------

    total_runtime = (
        time.time()
        - pipeline_start_time
    )


    print(
        "\n"
        "====================================================\n"
        "        INGESTION SESSION COMPLETED\n"
        "===================================================="
    )


    print(
        f"Total cycles completed: "
        f"{cycle_number}"
    )


    print(
        f"Total runtime: "
        f"{total_runtime / 3600:.2f} hours"
    )


    logger.info(
        f"Ingestion session completed | "
        f"Cycles: {cycle_number} | "
        f"Runtime: "
        f"{total_runtime / 3600:.2f} hours"
    )


    # --------------------------------------------------------
    # RUN DAILY VALIDATION
    # --------------------------------------------------------

    print(
        "\nStarting daily data validation..."
    )


    generate_report()

# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":

    run_pipeline()
