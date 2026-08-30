/*
===============================================================================
Stored Procedure: Load Gold fact_environment (silver -> gold)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'gold' schema from 'silver' schema. 
    It performs the following actions:
    - Truncates the gold tables before loading data.
    - Uses the `INSERT` command to load data.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC gold.load_fact_environment;
===============================================================================
*/

CREATE OR ALTER PROCEDURE gold.load_fact_environment
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO gold.fact_environment
    (
        observation_id,
        ingestion_id,

        city_key,
        date_key,
        time_key,

        observation_timestamp_utc,

        temperature_c,
        feels_like_c,
        temp_min_c,
        temp_max_c,

        humidity_pct,
        pressure_hpa,
        visibility_m,

        wind_speed_mps,
        wind_direction_deg,
        wind_gust_mps,

        rainfall_1h_mm,
        cloudiness_pct,

        openweather_aqi,

        pm2_5,
        pm10,
        co,
        no,
        no2,
        o3,
        so2,
        nh3,

        aqi_category,

        weather_quality_flag,
        air_quality_flag,

        source_system
    )

    SELECT

        w.observation_id,

        w.ingestion_id,


        -- ====================================================
        -- CITY DIMENSION
        -- ====================================================

        c.city_key,


        -- ====================================================
        -- DATE DIMENSION
        -- ====================================================

        d.date_key,


        -- ====================================================
        -- TIME DIMENSION
        -- ====================================================

        t.time_key,


        w.observation_timestamp_utc,


        -- ====================================================
        -- WEATHER
        -- ====================================================

        w.temperature_c,

        w.feels_like_c,

        w.temp_min_c,

        w.temp_max_c,

        w.humidity_pct,

        w.pressure_hpa,

        w.visibility_m,

        w.wind_speed_mps,

        w.wind_direction_deg,

        w.wind_gust_mps,

        w.rain_1h_mm,

        w.cloudiness_pct,


        -- ====================================================
        -- AIR QUALITY
        -- ====================================================

        a.aqi,

        a.pm2_5,

        a.pm10,

        a.co,

        a.no,

        a.no2,

        a.o3,

        a.so2,

        a.nh3,


        -- ====================================================
        -- AQI CATEGORY
        -- ====================================================

        CASE

            WHEN a.aqi = 1
                THEN 'Good'

            WHEN a.aqi = 2
                THEN 'Fair'

            WHEN a.aqi = 3
                THEN 'Moderate'

            WHEN a.aqi = 4
                THEN 'Poor'

            WHEN a.aqi = 5
                THEN 'Very Poor'

            ELSE 'Unknown'

        END,


        -- ====================================================
        -- DATA QUALITY
        -- ====================================================

        w.data_quality_flag,

        a.data_quality_flag,


        w.source_system


    FROM silver.weather w


    -- ========================================================
    -- JOIN AIR QUALITY
    -- Same ingestion batch + city
    -- ========================================================

    INNER JOIN silver.air_quality a

        ON a.ingestion_id =
           w.ingestion_id

        AND a.city =
            w.city


    -- ========================================================
    -- CITY DIMENSION
    -- ========================================================

    INNER JOIN gold.dim_city c

        ON c.city_name =
           w.city


    -- ========================================================
    -- DATE DIMENSION
    -- ========================================================

    INNER JOIN gold.dim_date d

        ON d.full_date =
           CAST(
               w.observation_timestamp_utc
               AS DATE
           )


    -- ========================================================
    -- TIME DIMENSION
    -- ========================================================

    INNER JOIN gold.dim_time t

        ON t.hour_number =
           DATEPART(
               HOUR,
               w.observation_timestamp_utc
           )

        AND t.minute_number =
            (
                DATEPART(
                    MINUTE,
                    w.observation_timestamp_utc
                ) / 5
            ) * 5


    -- ========================================================
    -- GOLD DUPLICATE PROTECTION
    -- ========================================================

    WHERE NOT EXISTS
    (
        SELECT 1

        FROM gold.fact_environment f

        WHERE f.observation_id =
              w.observation_id
    );

END;
GO

/*
EXEC gold.load_fact_environment;
GO
*/
