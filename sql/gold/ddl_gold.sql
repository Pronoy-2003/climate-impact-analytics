/*
===============================================================================
DDL Script: Create Gold Tables
===============================================================================
Script Purpose:
    This script creates tables for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each tables performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These tables can be queried directly for analytics and reporting.
===============================================================================
*/

-- gold.fact_environment --
IF OBJECT_ID('gold.fact_environment', 'U') IS NOT NULL
    DROP TABLE gold.fact_environment;
GO

CREATE TABLE gold.fact_environment
(
    environment_key BIGINT IDENTITY(1,1)
        PRIMARY KEY,

    observation_id VARCHAR(150) NOT NULL,

    ingestion_id UNIQUEIDENTIFIER NOT NULL,

    city_key INT NOT NULL,

    date_key INT NOT NULL,

    time_key INT NOT NULL,


    -- =====================================================
    -- OBSERVATION TIME
    -- =====================================================

    observation_timestamp_utc DATETIME2(0) NOT NULL,


    -- =====================================================
    -- WEATHER METRICS
    -- =====================================================

    temperature_c DECIMAL(10,2) NULL,

    feels_like_c DECIMAL(10,2) NULL,

    temp_min_c DECIMAL(10,2) NULL,

    temp_max_c DECIMAL(10,2) NULL,

    humidity_pct DECIMAL(5,2) NULL,

    pressure_hpa DECIMAL(10,2) NULL,

    visibility_m INT NULL,

    wind_speed_mps DECIMAL(10,2) NULL,

    wind_direction_deg DECIMAL(6,2) NULL,

    wind_gust_mps DECIMAL(10,2) NULL,

    rainfall_1h_mm DECIMAL(10,2) NULL,

    cloudiness_pct DECIMAL(5,2) NULL,


    -- =====================================================
    -- AIR QUALITY
    -- =====================================================

    openweather_aqi TINYINT NULL,

    pm2_5 DECIMAL(12,2) NULL,

    pm10 DECIMAL(12,2) NULL,

    co DECIMAL(12,2) NULL,

    no DECIMAL(12,2) NULL,

    no2 DECIMAL(12,2) NULL,

    o3 DECIMAL(12,2) NULL,

    so2 DECIMAL(12,2) NULL,

    nh3 DECIMAL(12,2) NULL,


    -- =====================================================
    -- BUSINESS-FRIENDLY AQ CATEGORY
    -- =====================================================

    aqi_category VARCHAR(30) NULL,


    -- =====================================================
    -- DATA QUALITY
    -- =====================================================

    weather_quality_flag VARCHAR(30) NULL,

    air_quality_flag VARCHAR(30) NULL,


    -- =====================================================
    -- METADATA
    -- =====================================================

    source_system VARCHAR(50) NOT NULL,

    loaded_at DATETIME2(3)
        NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_fact_environment_observation
ON gold.fact_environment
(
    observation_id
);
GO


-- gold.dim_city --
IF OBJECT_ID('gold.dim_city', 'U') IS NOT NULL
    DROP TABLE gold.dim_city;
GO

CREATE TABLE gold.dim_city
(
    city_key INT IDENTITY(1,1) PRIMARY KEY,

    city_name VARCHAR(100) NOT NULL,

    country_name VARCHAR(100) NULL,

    latitude DECIMAL(9,6) NULL,

    longitude DECIMAL(9,6) NULL,

    region VARCHAR(100) NULL,

    is_monitored BIT NOT NULL DEFAULT 1,

    created_at DATETIME2(3)
        NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

INSERT INTO gold.dim_city
(
    city_name,
    country_name,
    latitude,
    longitude,
    region,
    is_monitored
)
SELECT DISTINCT

    city,

    country,

    latitude,

    longitude,

    CASE
        WHEN city IN
        (
            'Delhi',
            'Lucknow',
            'Patna',
            'Bhopal',
            'Jaipur',
            'Ahmedabad'
        )
        THEN 'North/Central/West India'

        WHEN city IN
        (
            'Mumbai',
            'Pune'
        )
        THEN 'West India'

        WHEN city IN
        (
            'Kolkata',
            'Bhubaneswar',
            'Guwahati'
        )
        THEN 'East/Northeast India'

        WHEN city IN
        (
            'Bengaluru',
            'Chennai',
            'Hyderabad',
            'Kochi'
        )
        THEN 'South India'

        ELSE 'International'

    END,

    1

FROM silver.weather;
GO


-- gold.dim_date --
IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL
    DROP TABLE gold.dim_date;
GO

CREATE TABLE gold.dim_date
(
    date_key INT PRIMARY KEY,

    full_date DATE NOT NULL,

    year_number INT NOT NULL,

    quarter_number INT NOT NULL,

    month_number INT NOT NULL,

    month_name VARCHAR(20) NOT NULL,

    week_number INT NOT NULL,

    day_number INT NOT NULL,

    day_name VARCHAR(20) NOT NULL,

    day_of_week_number INT NOT NULL,

    is_weekend BIT NOT NULL
);
GO


DECLARE @StartDate DATE = '2026-01-01';
DECLARE @EndDate DATE = '2030-12-31';

;WITH DateSeries AS
(
    SELECT @StartDate AS full_date

    UNION ALL

    SELECT DATEADD(DAY, 1, full_date)

    FROM DateSeries

    WHERE full_date < @EndDate
)

INSERT INTO gold.dim_date
(
    date_key,
    full_date,
    year_number,
    quarter_number,
    month_number,
    month_name,
    week_number,
    day_number,
    day_name,
    day_of_week_number,
    is_weekend
)
SELECT

    CONVERT(
        INT,
        CONVERT(
            VARCHAR(8),
            full_date,
            112
        )
    ),

    full_date,

    YEAR(full_date),

    DATEPART(
        QUARTER,
        full_date
    ),

    MONTH(full_date),

    DATENAME(
        MONTH,
        full_date
    ),

    DATEPART(
        WEEK,
        full_date
    ),

    DAY(full_date),

    DATENAME(
        WEEKDAY,
        full_date
    ),

    DATEPART(
        WEEKDAY,
        full_date
    ),

    CASE
        WHEN DATEPART(
            WEEKDAY,
            full_date
        ) IN (1,7)
        THEN 1
        ELSE 0
    END

FROM DateSeries

OPTION (MAXRECURSION 0);
GO


-- gold.dim_time --
IF OBJECT_ID('gold.dim_time', 'U') IS NOT NULL
    DROP TABLE gold.dim_time;
GO

CREATE TABLE gold.dim_time
(
    time_key INT PRIMARY KEY,

    full_time TIME(0) NOT NULL,

    hour_number INT NOT NULL,

    minute_number INT NOT NULL,

    hour_label VARCHAR(20) NOT NULL,

    time_period VARCHAR(30) NOT NULL
);
GO




DECLARE @MinuteOfDay INT = 0;

WHILE @MinuteOfDay < 1440
BEGIN

    DECLARE @HourNumber INT;
    DECLARE @MinuteNumber INT;
    DECLARE @Time TIME(0);
    DECLARE @HourLabel VARCHAR(20);
    DECLARE @TimePeriod VARCHAR(30);


    -- Calculate hour and minute

    SET @HourNumber =
        @MinuteOfDay / 60;

    SET @MinuteNumber =
        @MinuteOfDay % 60;


    -- Create TIME value

    SET @Time =
        CAST(
            DATEADD(
                MINUTE,
                @MinuteOfDay,
                CAST('1900-01-01 00:00:00' AS DATETIME)
            )
            AS TIME(0)
        );


    -- Create HH:mm label without FORMAT()

    SET @HourLabel =
        RIGHT(
            '0' + CAST(@HourNumber AS VARCHAR(2)),
            2
        )
        + ':'
        +
        RIGHT(
            '0' + CAST(@MinuteNumber AS VARCHAR(2)),
            2
        );


    -- Determine time period

    SET @TimePeriod =
        CASE

            WHEN @HourNumber BETWEEN 0 AND 5
                THEN 'Night'

            WHEN @HourNumber BETWEEN 6 AND 11
                THEN 'Morning'

            WHEN @HourNumber BETWEEN 12 AND 16
                THEN 'Afternoon'

            WHEN @HourNumber BETWEEN 17 AND 20
                THEN 'Evening'

            ELSE 'Night'

        END;


    -- Insert

    INSERT INTO gold.dim_time
    (
        time_key,
        full_time,
        hour_number,
        minute_number,
        hour_label,
        time_period
    )
    VALUES
    (
        @HourNumber * 100
            + @MinuteNumber,

        @Time,

        @HourNumber,

        @MinuteNumber,

        @HourLabel,

        @TimePeriod
    );


    -- Move to next 5-minute interval

    SET @MinuteOfDay =
        @MinuteOfDay + 5;

END;
GO

