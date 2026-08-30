/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


-- Create bronze.weather_raw --
IF OBJECT_ID('bronze.weather_raw', 'U') IS NOT NULL
    DROP TABLE bronze.weather_raw;
GO

CREATE TABLE bronze.weather_raw
(
    -- =========================================================
    -- IDENTIFICATION
    -- =========================================================

    weather_key BIGINT IDENTITY(1,1) PRIMARY KEY,

    ingestion_id UNIQUEIDENTIFIER NOT NULL,

    observation_id VARCHAR(150) NOT NULL,

    observation_timestamp_utc DATETIME2(0) NOT NULL,

    ingestion_timestamp_utc DATETIME2(3) NOT NULL,


    -- =========================================================
    -- CITY INFORMATION
    -- =========================================================

    city VARCHAR(100) NOT NULL,

    country VARCHAR(100) NULL,

    latitude DECIMAL(9,6) NULL,

    longitude DECIMAL(9,6) NULL,


    -- =========================================================
    -- API STATUS
    -- =========================================================

    weather_status VARCHAR(30) NULL,


    -- =========================================================
    -- WEATHER CONDITION
    -- =========================================================

    weather_id INT NULL,

    weather_main VARCHAR(50) NULL,

    weather_description VARCHAR(100) NULL,

    weather_icon VARCHAR(20) NULL,


    -- =========================================================
    -- TEMPERATURE
    -- =========================================================

    temperature DECIMAL(10,2) NULL,

    feels_like DECIMAL(10,2) NULL,

    temp_min DECIMAL(10,2) NULL,

    temp_max DECIMAL(10,2) NULL,


    -- =========================================================
    -- ATMOSPHERIC CONDITIONS
    -- =========================================================

    pressure_hpa DECIMAL(10,2) NULL,

    humidity_percent DECIMAL(5,2) NULL,

    sea_level_pressure_hpa DECIMAL(10,2) NULL,

    ground_level_pressure_hpa DECIMAL(10,2) NULL,

    visibility_m INT NULL,


    -- =========================================================
    -- WIND
    -- =========================================================

    wind_speed DECIMAL(10,2) NULL,

    wind_direction_deg DECIMAL(6,2) NULL,

    wind_gust DECIMAL(10,2) NULL,


    -- =========================================================
    -- RAINFALL
    -- =========================================================

    rain_1h_mm DECIMAL(10,2) NULL,


    -- =========================================================
    -- CLOUDS
    -- =========================================================

    cloudiness_percent DECIMAL(5,2) NULL,


    -- =========================================================
    -- SUN INFORMATION
    -- =========================================================

    sunrise_utc DATETIME2(0) NULL,

    sunset_utc DATETIME2(0) NULL,


    -- =========================================================
    -- OPENWEATHER INFORMATION
    -- =========================================================

    openweather_city_id BIGINT NULL,

    openweather_city_name VARCHAR(150) NULL,

    timezone_offset_seconds INT NULL,

    api_response_code INT NULL,


    -- =========================================================
    -- DATA ENGINEERING METADATA
    -- =========================================================

    source_system VARCHAR(50) NOT NULL DEFAULT 'OpenWeather',

    loaded_at DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO


-- Create bronze.air_quality_raw --
IF OBJECT_ID('bronze.air_quality_raw', 'U') IS NOT NULL
    DROP TABLE bronze.air_quality_raw;
GO

CREATE TABLE bronze.air_quality_raw
(
    -- =========================================================
    -- IDENTIFICATION
    -- =========================================================

    air_quality_key BIGINT IDENTITY(1,1) PRIMARY KEY,

    ingestion_id UNIQUEIDENTIFIER NOT NULL,

    observation_id VARCHAR(150) NOT NULL,

    observation_timestamp_utc DATETIME2(0) NOT NULL,

    ingestion_timestamp_utc DATETIME2(3) NOT NULL,


    -- =========================================================
    -- CITY INFORMATION
    -- =========================================================

    city VARCHAR(100) NOT NULL,

    country VARCHAR(100) NULL,

    latitude DECIMAL(9,6) NULL,

    longitude DECIMAL(9,6) NULL,


    -- =========================================================
    -- API STATUS
    -- =========================================================

    air_quality_status VARCHAR(30) NULL,


    -- =========================================================
    -- AIR QUALITY INDEX
    -- =========================================================

    aqi TINYINT NULL,


    -- =========================================================
    -- POLLUTANTS
    -- OpenWeather air-quality values
    -- =========================================================

    co DECIMAL(12,2) NULL,

    no DECIMAL(12,2) NULL,

    no2 DECIMAL(12,2) NULL,

    o3 DECIMAL(12,2) NULL,

    so2 DECIMAL(12,2) NULL,

    pm2_5 DECIMAL(12,2) NULL,

    pm10 DECIMAL(12,2) NULL,

    nh3 DECIMAL(12,2) NULL,


    -- =========================================================
    -- DATA ENGINEERING METADATA
    -- =========================================================

    source_system VARCHAR(50) NOT NULL DEFAULT 'OpenWeather',

    loaded_at DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO



-- Create bronze.ingestion_log --
IF OBJECT_ID('bronze.ingestion_log', 'U') IS NOT NULL
    DROP TABLE bronze.ingestion_log;
GO

CREATE TABLE bronze.ingestion_log
(
    ingestion_log_key BIGINT IDENTITY(1,1) PRIMARY KEY,

    ingestion_id UNIQUEIDENTIFIER NOT NULL,

    ingestion_timestamp_utc DATETIME2(3) NOT NULL,

    source_system VARCHAR(50) NOT NULL DEFAULT 'OpenWeather',

    city_count INT NULL,

    weather_api_calls INT NULL,

    air_quality_api_calls INT NULL,

    total_api_calls INT NULL,

    ingestion_status VARCHAR(30) NOT NULL,

    weather_success_count INT NULL,

    weather_failure_count INT NULL,

    air_quality_success_count INT NULL,

    air_quality_failure_count INT NULL,

    source_file_name VARCHAR(500) NULL,

    loaded_at DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO



CREATE UNIQUE INDEX UX_weather_batch_city
ON bronze.weather_raw
(
    ingestion_id,
    city
);
GO

CREATE UNIQUE INDEX UX_air_quality_batch_city
ON bronze.air_quality_raw
(
    ingestion_id,
    city
);
GO



CREATE UNIQUE INDEX UX_weather_observation
ON bronze.weather_raw(observation_id);
GO

CREATE UNIQUE INDEX UX_air_quality_observation
ON bronze.air_quality_raw(observation_id);
GO

CREATE UNIQUE INDEX UX_ingestion_id
ON bronze.ingestion_log(ingestion_id);
GO
