import os
import json
import glob
from datetime import datetime, timezone

import pandas as pd


# ============================================================
# CONFIGURATION
# ============================================================

RAW_PATH = (
    "data/raw/openweather"
)

REPORT_PATH = (
    "data/reports/data_quality"
)


EXPECTED_CITIES = {

    "Delhi",
    "Mumbai",
    "Kolkata",
    "Bengaluru",
    "Chennai",
    "Hyderabad",
    "Pune",
    "Ahmedabad",
    "Jaipur",
    "Guwahati",
    "Lucknow",
    "Patna",
    "Bhopal",
    "Bhubaneswar",
    "Kochi",
    "London",
    "New York",
    "Tokyo",
    "Singapore",
    "Dubai"
}


# ============================================================
# GET TODAY'S DIRECTORY
# ============================================================

def get_today_directory():

    now = datetime.now(
        timezone.utc
    )

    return os.path.join(

        RAW_PATH,

        now.strftime("%Y"),

        now.strftime("%m"),

        now.strftime("%d")
    )


# ============================================================
# LOAD RAW FILES
# ============================================================

def load_raw_files():

    directory = (
        get_today_directory()
    )


    if not os.path.exists(
        directory
    ):

        return []


    pattern = os.path.join(
        directory,
        "*.json"
    )


    return sorted(
        glob.glob(pattern)
    )


# ============================================================
# VALIDATE BATCH STRUCTURE
# ============================================================

def validate_batches(
    files
):

    results = []

    all_ingestion_ids = []

    all_timestamps = []

    total_weather_success = 0

    total_air_quality_success = 0

    total_city_records = 0


    for file_path in files:

        try:

            with open(
                file_path,
                "r",
                encoding="utf-8"
            ) as file:

                data = json.load(file)


            metadata = data.get(
                "metadata",
                {}
            )


            records = data.get(
                "data",
                []
            )


            ingestion_id = (
                metadata.get(
                    "ingestion_id"
                )
            )


            timestamp = (
                metadata.get(
                    "ingestion_timestamp_utc"
                )
            )


            all_ingestion_ids.append(
                ingestion_id
            )


            all_timestamps.append(
                timestamp
            )


            cities = {

                record.get(
                    "city"
                )

                for record in records
            }


            missing_cities = (
                EXPECTED_CITIES
                - cities
            )


            extra_cities = (
                cities
                - EXPECTED_CITIES
            )


            weather_success = sum(

                1

                for record in records

                if record.get(
                    "weather_status"
                ) == "SUCCESS"
            )


            air_quality_success = sum(

                1

                for record in records

                if record.get(
                    "air_quality_status"
                ) == "SUCCESS"
            )


            total_weather_success += (
                weather_success
            )


            total_air_quality_success += (
                air_quality_success
            )


            total_city_records += (
                len(records)
            )


            results.append({

                "file":
                    os.path.basename(
                        file_path
                    ),

                "ingestion_id":
                    ingestion_id,

                "timestamp":
                    timestamp,

                "city_count":
                    len(records),

                "missing_cities":
                    sorted(
                        missing_cities
                    ),

                "extra_cities":
                    sorted(
                        extra_cities
                    ),

                "weather_success":
                    weather_success,

                "air_quality_success":
                    air_quality_success,

                "status":
                    "PASS"

                    if (
                        len(records) == 20
                        and not missing_cities
                        and not extra_cities
                    )

                    else "WARNING"

            })


        except Exception as e:

            results.append({

                "file":
                    os.path.basename(
                        file_path
                    ),

                "status":
                    "ERROR",

                "error":
                    str(e)

            })


    return (
        results,
        all_ingestion_ids,
        all_timestamps,
        total_weather_success,
        total_air_quality_success,
        total_city_records
    )


# ============================================================
# CHECK DUPLICATE INGESTION IDS
# ============================================================

def find_duplicates(
    values
):

    clean_values = [
        value
        for value in values
        if value
    ]


    series = pd.Series(
        clean_values
    )


    return (
        series[
            series.duplicated(
                keep=False
            )
        ]
        .unique()
        .tolist()
    )


# ============================================================
# CHECK TIME GAPS
# ============================================================

def find_time_gaps(
    timestamps
):

    clean_timestamps = [

        timestamp

        for timestamp in timestamps

        if timestamp
    ]


    if len(clean_timestamps) < 2:

        return []


    df = pd.DataFrame({

        "timestamp":
            pd.to_datetime(
                clean_timestamps,
                utc=True
            )

    })


    df = df.sort_values(
        "timestamp"
    )


    df["difference"] = (
        df["timestamp"]
        .diff()
    )


    gaps = df[
        df["difference"]
        > pd.Timedelta(
            minutes=7.5
        )
    ]


    return [

        {

            "timestamp":
                row["timestamp"].isoformat(),

            "gap":
                str(
                    row["difference"]
                )

        }

        for _, row
        in gaps.iterrows()
    ]


# ============================================================
# GENERATE REPORT
# ============================================================

def generate_report():

    files = (
        load_raw_files()
    )


    print(
        "\n"
        "=============================================="
    )

    print(
        "DAILY DATA VALIDATION"
    )

    print(
        "=============================================="
    )


    print(
        f"Files found: "
        f"{len(files)}"
    )


    if not files:

        print(
            "No raw files found for today."
        )

        return None


    (
        batch_results,
        ingestion_ids,
        timestamps,
        weather_success,
        air_quality_success,
        total_city_records

    ) = validate_batches(
        files
    )


    # --------------------------------------------------------
    # DUPLICATES
    # --------------------------------------------------------

    duplicate_ids = (
        find_duplicates(
            ingestion_ids
        )
    )


    # --------------------------------------------------------
    # TIME GAPS
    # --------------------------------------------------------

    time_gaps = (
        find_time_gaps(
            timestamps
        )
    )


    # --------------------------------------------------------
    # EXPECTED OBSERVATIONS
    # --------------------------------------------------------

    expected_cycles = (
        len(files)
    )


    expected_city_records = (
        expected_cycles * 20
    )


    # --------------------------------------------------------
    # SUCCESS RATE
    # --------------------------------------------------------

    weather_success_rate = (

        weather_success
        /
        expected_city_records
        *
        100

    ) if expected_city_records else 0


    air_quality_success_rate = (

        air_quality_success
        /
        expected_city_records
        *
        100

    ) if expected_city_records else 0


    # --------------------------------------------------------
    # OVERALL STATUS
    # --------------------------------------------------------

    has_errors = any(

        result.get("status")
        == "ERROR"

        for result
        in batch_results
    )


    has_warnings = any(

        result.get("status")
        == "WARNING"

        for result
        in batch_results
    )


    if has_errors:

        overall_status = "FAIL"

    elif (
        has_warnings
        or duplicate_ids
        or time_gaps
    ):

        overall_status = "WARNING"

    else:

        overall_status = "PASS"


    # --------------------------------------------------------
    # REPORT
    # --------------------------------------------------------

    report = {

        "report_metadata": {

            "generated_at_utc":
                datetime.now(
                    timezone.utc
                ).isoformat(),

            "report_date":
                datetime.now(
                    timezone.utc
                ).strftime(
                    "%Y-%m-%d"
                ),

            "overall_status":
                overall_status

        },


        "summary": {

            "files_found":
                len(files),

            "expected_cities":
                20,

            "total_city_records":
                total_city_records,

            "expected_city_records":
                expected_city_records,

            "weather_success_rate":
                round(
                    weather_success_rate,
                    2
                ),

            "air_quality_success_rate":
                round(
                    air_quality_success_rate,
                    2
                ),

            "duplicate_ingestion_ids":
                duplicate_ids,

            "time_gaps":
                time_gaps

        },


        "batch_results":
            batch_results

    }


    # --------------------------------------------------------
    # SAVE REPORT
    # --------------------------------------------------------

    now = datetime.now(
        timezone.utc
    )


    report_directory = os.path.join(

        REPORT_PATH,

        now.strftime("%Y"),

        now.strftime("%m"),

        now.strftime("%d")

    )


    os.makedirs(
        report_directory,
        exist_ok=True
    )


    report_filename = (

        "data_quality_report_"

        + now.strftime(
            "%Y%m%d"
        )

        + ".json"

    )


    report_path = os.path.join(

        report_directory,

        report_filename

    )


    with open(

        report_path,

        "w",

        encoding="utf-8"

    ) as file:

        json.dump(

            report,

            file,

            indent=4,

            ensure_ascii=False

        )


    # --------------------------------------------------------
    # PRINT SUMMARY
    # --------------------------------------------------------

    print(
        "\n"
        "--------------- SUMMARY ---------------"
    )


    print(
        f"Overall status: "
        f"{overall_status}"
    )


    print(
        f"Collection files: "
        f"{len(files)}"
    )


    print(
        f"City observations: "
        f"{total_city_records}"
    )


    print(
        f"Weather success: "
        f"{weather_success_rate:.2f}%"
    )


    print(
        f"Air quality success: "
        f"{air_quality_success_rate:.2f}%"
    )


    print(
        f"Duplicate batches: "
        f"{len(duplicate_ids)}"
    )


    print(
        f"Time gaps: "
        f"{len(time_gaps)}"
    )


    print(
        f"\nReport saved to:"
    )


    print(
        report_path
    )


    return report


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":

    generate_report()