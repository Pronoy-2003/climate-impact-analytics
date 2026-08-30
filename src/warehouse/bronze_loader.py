import json
import sys
from pathlib import Path
from datetime import datetime, timezone


from src.database.sql_server import (
    get_sql_connection
)


# ============================================================
# LOAD JSON FILE
# ============================================================

def load_json_file(file_path):

    with open(
        file_path,
        "r",
        encoding="utf-8"
    ) as file:

        return json.load(file)


# ============================================================
# UNIX TIMESTAMP → UTC DATETIME
# ============================================================

def unix_to_datetime(timestamp):

    if timestamp is None:
        return None

    return datetime.fromtimestamp(
        timestamp,
        tz=timezone.utc
    ).replace(
        tzinfo=None
    )


# ============================================================
# SAFE DECIMAL VALUE
# ============================================================

def get_value(dictionary, key):

    if not dictionary:
        return None

    return dictionary.get(key)


# ============================================================
# WEATHER ROW
# ============================================================

def create_weather_row(
    city_data,
    ingestion_id,
    ingestion_timestamp
):

    weather = city_data.get(
        "weather"
    )

    if not weather:
        return None

    main = weather.get(
        "main",
        {}
    )

    wind = weather.get(
        "wind",
        {}
    )

    clouds = weather.get(
        "clouds",
        {}
    )

    rain = weather.get(
        "rain",
        {}
    )

    weather_conditions = weather.get(
        "weather",
        []
    )

    condition = (
        weather_conditions[0]
        if weather_conditions
        else {}
    )

    coord = weather.get(
        "coord",
        {}
    )

    sys_data = weather.get(
        "sys",
        {}
    )

    observation_timestamp = (
        unix_to_datetime(
            weather.get("dt")
        )
    )

    observation_id = (
        f"WEATHER_"
        f"{ingestion_id}_"
        f"{city_data['city']}"
    )

    return (

        ingestion_id,

        observation_id,

        observation_timestamp,

        ingestion_timestamp,

        city_data.get("city"),

        city_data.get("country"),

        city_data.get("latitude"),

        city_data.get("longitude"),

        city_data.get("weather_status"),

        condition.get("id"),

        condition.get("main"),

        condition.get("description"),

        condition.get("icon"),

        main.get("temp"),

        main.get("feels_like"),

        main.get("temp_min"),

        main.get("temp_max"),

        main.get("pressure"),

        main.get("humidity"),

        main.get("sea_level"),

        main.get("grnd_level"),

        weather.get("visibility"),

        wind.get("speed"),

        wind.get("deg"),

        wind.get("gust"),

        rain.get("1h"),

        clouds.get("all"),

        unix_to_datetime(
            sys_data.get("sunrise")
        ),

        unix_to_datetime(
            sys_data.get("sunset")
        ),

        weather.get("id"),

        weather.get("name"),

        weather.get("timezone"),

        weather.get("cod"),

        "OpenWeather"
    )


# ============================================================
# AIR QUALITY ROW
# ============================================================

def create_air_quality_row(
    city_data,
    ingestion_id,
    ingestion_timestamp
):

    air_quality = city_data.get(
        "air_quality"
    )

    if not air_quality:
        return None

    air_list = air_quality.get(
        "list",
        []
    )

    if not air_list:
        return None

    air_data = air_list[0]

    air_main = air_data.get(
        "main",
        {}
    )

    components = air_data.get(
        "components",
        {}
    )

    coord = air_quality.get(
        "coord",
        {}
    )

    observation_timestamp = (
        unix_to_datetime(
            air_data.get("dt")
        )
    )

    observation_id = (
        f"AQ_"
        f"{ingestion_id}_"
        f"{city_data['city']}"
    )

    return (

        ingestion_id,

        observation_id,

        observation_timestamp,

        ingestion_timestamp,

        city_data.get("city"),

        city_data.get("country"),

        city_data.get("latitude"),

        city_data.get("longitude"),

        city_data.get("air_quality_status"),

        air_main.get("aqi"),

        components.get("co"),

        components.get("no"),

        components.get("no2"),

        components.get("o3"),

        components.get("so2"),

        components.get("pm2_5"),

        components.get("pm10"),

        components.get("nh3"),

        "OpenWeather"
    )


# ============================================================
# LOAD WEATHER
# ============================================================

def load_weather(
    cursor,
    weather_rows
):

    sql = """
    INSERT INTO bronze.weather_raw
    (
        ingestion_id,
        observation_id,
        observation_timestamp_utc,
        ingestion_timestamp_utc,

        city,
        country,
        latitude,
        longitude,

        weather_status,

        weather_id,
        weather_main,
        weather_description,
        weather_icon,

        temperature,
        feels_like,
        temp_min,
        temp_max,

        pressure_hpa,
        humidity_percent,
        sea_level_pressure_hpa,
        ground_level_pressure_hpa,

        visibility_m,

        wind_speed,
        wind_direction_deg,
        wind_gust,

        rain_1h_mm,

        cloudiness_percent,

        sunrise_utc,
        sunset_utc,

        openweather_city_id,
        openweather_city_name,
        timezone_offset_seconds,
        api_response_code,

        source_system
    )

    SELECT
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM bronze.weather_raw
        WHERE observation_id = ?
    );
    """

    inserted = 0

    for row in weather_rows:

        values = (
            *row,
            row[1]
        )

        cursor.execute(
            sql,
            values
        )

        if cursor.rowcount > 0:
            inserted += 1

    return inserted


# ============================================================
# LOAD AIR QUALITY
# ============================================================

def load_air_quality(
    cursor,
    air_quality_rows
):

    sql = """
    INSERT INTO bronze.air_quality_raw
    (
        ingestion_id,
        observation_id,
        observation_timestamp_utc,
        ingestion_timestamp_utc,

        city,
        country,
        latitude,
        longitude,

        air_quality_status,

        aqi,

        co,
        no,
        no2,
        o3,
        so2,
        pm2_5,
        pm10,
        nh3,

        source_system
    )

    SELECT
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM bronze.air_quality_raw
        WHERE observation_id = ?
    );
    """

    inserted = 0

    for row in air_quality_rows:

        values = (
            *row,
            row[1]
        )

        cursor.execute(
            sql,
            values
        )

        if cursor.rowcount > 0:
            inserted += 1

    return inserted


# ============================================================
# INGESTION LOG
# ============================================================

def load_ingestion_log(
    cursor,
    data,
    source_file_name
):

    metadata = data["metadata"]

    ingestion_id = metadata[
        "ingestion_id"
    ]

    ingestion_timestamp = (
        datetime.fromisoformat(
            metadata[
                "ingestion_timestamp_utc"
            ]
        )
        .replace(
            tzinfo=None
        )
    )

    sql = """
    INSERT INTO bronze.ingestion_log
    (
        ingestion_id,
        ingestion_timestamp_utc,
        source_system,

        city_count,

        weather_api_calls,
        air_quality_api_calls,
        total_api_calls,

        ingestion_status,

        weather_success_count,
        weather_failure_count,

        air_quality_success_count,
        air_quality_failure_count,

        source_file_name
    )

    SELECT
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM bronze.ingestion_log
        WHERE ingestion_id = ?
    );
    """

    weather_success = sum(
        1
        for city in data["data"]
        if city.get(
            "weather_status"
        ) == "SUCCESS"
    )

    weather_failure = (
        metadata["city_count"]
        - weather_success
    )

    air_success = sum(
        1
        for city in data["data"]
        if city.get(
            "air_quality_status"
        ) == "SUCCESS"
    )

    air_failure = (
        metadata["city_count"]
        - air_success
    )

    values = (

        ingestion_id,

        ingestion_timestamp,

        "OpenWeather",

        metadata["city_count"],

        metadata["weather_api_calls"],

        metadata["air_quality_api_calls"],

        metadata["total_api_calls"],

        "SUCCESS",

        weather_success,

        weather_failure,

        air_success,

        air_failure,

        source_file_name,

        ingestion_id
    )

    cursor.execute(
        sql,
        values
    )


# ============================================================
# MAIN LOADER
# ============================================================

def load_batch(file_path):

    print(
        f"\nLoading: {file_path}"
    )

    data = load_json_file(
        file_path
    )

    metadata = data["metadata"]

    ingestion_id = metadata[
        "ingestion_id"
    ]

    ingestion_timestamp = (
        datetime.fromisoformat(
            metadata[
                "ingestion_timestamp_utc"
            ]
        )
        .replace(
            tzinfo=None
        )
    )

    weather_rows = []

    air_quality_rows = []

    for city_data in data["data"]:

        weather_row = create_weather_row(
            city_data,
            ingestion_id,
            ingestion_timestamp
        )

        if weather_row:
            weather_rows.append(
                weather_row
            )

        air_row = create_air_quality_row(
            city_data,
            ingestion_id,
            ingestion_timestamp
        )

        if air_row:
            air_quality_rows.append(
                air_row
            )

    print(
        f"Weather records found: "
        f"{len(weather_rows)}"
    )

    print(
        f"Air quality records found: "
        f"{len(air_quality_rows)}"
    )

    connection = get_sql_connection()

    cursor = connection.cursor()

    try:

        weather_inserted = load_weather(
            cursor,
            weather_rows
        )

        air_inserted = load_air_quality(
            cursor,
            air_quality_rows
        )

        load_ingestion_log(
            cursor,
            data,
            Path(file_path).name
        )

        connection.commit()

        print(
            f"\nWeather inserted: "
            f"{weather_inserted}"
        )

        print(
            f"Air quality inserted: "
            f"{air_inserted}"
        )

        print(
            "\nBronze loading completed."
        )

    except Exception:

        connection.rollback()

        raise

    finally:

        cursor.close()

        connection.close()


# ============================================================
# COMMAND LINE
# ============================================================

if __name__ == "__main__":

    if len(sys.argv) != 2:

        print(
            "Usage:"
        )

        print(
            "python "
            "src/warehouse/bronze_loader.py "
            "<json_file>"
        )

        sys.exit(1)

    load_batch(
        sys.argv[1]
    )