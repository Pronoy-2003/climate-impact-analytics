/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_weather;
    EXEC silver.load_air_quality;
===============================================================================
*/


-- Weather Silver procedure --
CREATE OR ALTER PROCEDURE silver.load_weather
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO silver.weather
    (
        observation_id,
        ingestion_id,
        observation_timestamp_utc,
        ingestion_timestamp_utc,

        city,
        country,
        latitude,
        longitude,

        weather_id,
        weather_main,
        weather_description,

        temperature_c,
        feels_like_c,
        temp_min_c,
        temp_max_c,

        pressure_hpa,
        humidity_pct,
        visibility_m,

        wind_speed_mps,
        wind_direction_deg,
        wind_gust_mps,

        rain_1h_mm,

        cloudiness_pct,

        data_quality_flag,
        quality_issue,

        source_system
    )

    SELECT

        b.observation_id,

        b.ingestion_id,

        b.observation_timestamp_utc,

        b.ingestion_timestamp_utc,


        -- City

        LTRIM(RTRIM(b.city)),

        UPPER(LTRIM(RTRIM(b.country))),

        b.latitude,

        b.longitude,


        -- Weather

        b.weather_id,

        LTRIM(RTRIM(b.weather_main)),

        LTRIM(RTRIM(b.weather_description)),


        -- Temperature

        b.temperature,

        b.feels_like,

        b.temp_min,

        b.temp_max,


        -- Atmosphere

        b.pressure_hpa,

        b.humidity_percent,

        b.visibility_m,


        -- Wind

        b.wind_speed,

        b.wind_direction_deg,

        b.wind_gust,


        -- Rain

        CASE
            WHEN b.rain_1h_mm < 0
                THEN NULL
            ELSE b.rain_1h_mm
        END,


        -- Clouds

        b.cloudiness_percent,


        -- ====================================================
        -- DATA QUALITY FLAG
        -- ====================================================

        CASE

            WHEN b.temperature IS NULL
                THEN 'INVALID'

            WHEN b.temperature < -90
                OR b.temperature > 60
                THEN 'INVALID'

            WHEN b.humidity_percent IS NOT NULL
                AND (
                    b.humidity_percent < 0
                    OR b.humidity_percent > 100
                )
                THEN 'INVALID'

            WHEN b.pressure_hpa IS NOT NULL
                AND (
                    b.pressure_hpa < 800
                    OR b.pressure_hpa > 1100
                )
                THEN 'INVALID'

            WHEN b.wind_speed IS NOT NULL
                AND b.wind_speed < 0
                THEN 'INVALID'

            WHEN b.rain_1h_mm IS NOT NULL
                AND b.rain_1h_mm < 0
                THEN 'INVALID'

            WHEN b.latitude IS NOT NULL
                AND (
                    b.latitude < -90
                    OR b.latitude > 90
                )
                THEN 'INVALID'

            WHEN b.longitude IS NOT NULL
                AND (
                    b.longitude < -180
                    OR b.longitude > 180
                )
                THEN 'INVALID'

            WHEN
                b.temperature IS NULL
                OR b.humidity_percent IS NULL
                OR b.pressure_hpa IS NULL
                THEN 'WARNING'

            ELSE 'VALID'

        END,


        -- ====================================================
        -- QUALITY ISSUE
        -- ====================================================

        CASE

            WHEN b.temperature IS NULL
                THEN 'Temperature missing'

            WHEN b.temperature < -90
                OR b.temperature > 60
                THEN 'Temperature outside valid range'

            WHEN b.humidity_percent IS NOT NULL
                AND (
                    b.humidity_percent < 0
                    OR b.humidity_percent > 100
                )
                THEN 'Humidity outside valid range'

            WHEN b.pressure_hpa IS NOT NULL
                AND (
                    b.pressure_hpa < 800
                    OR b.pressure_hpa > 1100
                )
                THEN 'Pressure outside expected range'

            WHEN b.wind_speed IS NOT NULL
                AND b.wind_speed < 0
                THEN 'Negative wind speed'

            WHEN b.rain_1h_mm IS NOT NULL
                AND b.rain_1h_mm < 0
                THEN 'Negative rainfall'

            WHEN b.latitude IS NOT NULL
                AND (
                    b.latitude < -90
                    OR b.latitude > 90
                )
                THEN 'Invalid latitude'

            WHEN b.longitude IS NOT NULL
                AND (
                    b.longitude < -180
                    OR b.longitude > 180
                )
                THEN 'Invalid longitude'

            WHEN
                b.temperature IS NULL
                OR b.humidity_percent IS NULL
                OR b.pressure_hpa IS NULL
                THEN 'One or more important fields missing'

            ELSE NULL

        END,


        b.source_system

    FROM bronze.weather_raw b

    WHERE NOT EXISTS
    (
        SELECT 1

        FROM silver.weather s

        WHERE s.observation_id =
              b.observation_id
    );

END;
GO



-- Air Quality Silver procedure --
CREATE OR ALTER PROCEDURE silver.load_air_quality
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO silver.air_quality
    (
        observation_id,
        ingestion_id,
        observation_timestamp_utc,
        ingestion_timestamp_utc,

        city,
        country,
        latitude,
        longitude,

        aqi,

        co,
        no,
        no2,
        o3,
        so2,
        pm2_5,
        pm10,
        nh3,

        data_quality_flag,
        quality_issue,

        source_system
    )

    SELECT

        b.observation_id,

        b.ingestion_id,

        b.observation_timestamp_utc,

        b.ingestion_timestamp_utc,


        LTRIM(RTRIM(b.city)),

        UPPER(LTRIM(RTRIM(b.country))),

        b.latitude,

        b.longitude,


        -- AQI

        b.aqi,


        -- Pollutants

        b.co,

        b.no,

        b.no2,

        b.o3,

        b.so2,

        b.pm2_5,

        b.pm10,

        b.nh3,


        -- ====================================================
        -- DATA QUALITY FLAG
        -- ====================================================

        CASE

            WHEN b.aqi IS NULL
                THEN 'INVALID'

            WHEN b.aqi NOT BETWEEN 1 AND 5
                THEN 'INVALID'

            WHEN
                b.pm2_5 IS NOT NULL
                AND b.pm2_5 < 0
                THEN 'INVALID'

            WHEN
                b.pm10 IS NOT NULL
                AND b.pm10 < 0
                THEN 'INVALID'

            WHEN
                b.co IS NOT NULL
                AND b.co < 0
                THEN 'INVALID'

            WHEN
                b.no IS NOT NULL
                AND b.no < 0
                THEN 'INVALID'

            WHEN
                b.no2 IS NOT NULL
                AND b.no2 < 0
                THEN 'INVALID'

            WHEN
                b.o3 IS NOT NULL
                AND b.o3 < 0
                THEN 'INVALID'

            WHEN
                b.so2 IS NOT NULL
                AND b.so2 < 0
                THEN 'INVALID'

            WHEN
                b.nh3 IS NOT NULL
                AND b.nh3 < 0
                THEN 'INVALID'

            WHEN
                b.pm2_5 IS NULL
                OR b.pm10 IS NULL
                THEN 'WARNING'

            ELSE 'VALID'

        END,


        -- ====================================================
        -- QUALITY ISSUE
        -- ====================================================

        CASE

            WHEN b.aqi IS NULL
                THEN 'AQI missing'

            WHEN b.aqi NOT BETWEEN 1 AND 5
                THEN 'AQI outside OpenWeather 1-5 scale'

            WHEN
                b.pm2_5 IS NOT NULL
                AND b.pm2_5 < 0
                THEN 'Negative PM2.5'

            WHEN
                b.pm10 IS NOT NULL
                AND b.pm10 < 0
                THEN 'Negative PM10'

            WHEN
                b.co IS NOT NULL
                AND b.co < 0
                THEN 'Negative CO'

            WHEN
                b.no IS NOT NULL
                AND b.no < 0
                THEN 'Negative NO'

            WHEN
                b.no2 IS NOT NULL
                AND b.no2 < 0
                THEN 'Negative NO2'

            WHEN
                b.o3 IS NOT NULL
                AND b.o3 < 0
                THEN 'Negative O3'

            WHEN
                b.so2 IS NOT NULL
                AND b.so2 < 0
                THEN 'Negative SO2'

            WHEN
                b.nh3 IS NOT NULL
                AND b.nh3 < 0
                THEN 'Negative NH3'

            WHEN
                b.pm2_5 IS NULL
                OR b.pm10 IS NULL
                THEN 'One or more particulate measurements missing'

            ELSE NULL

        END,


        b.source_system

    FROM bronze.air_quality_raw b

    WHERE NOT EXISTS
    (
        SELECT 1

        FROM silver.air_quality s

        WHERE s.observation_id =
              b.observation_id
    );

END;
GO



-- EXEC silver.load_weather;
-- GO

-- EXEC silver.load_air_quality;
-- GO



