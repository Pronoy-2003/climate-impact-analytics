/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/


-- Silver weather --
IF OBJECT_ID('silver.weather', 'U') IS NOT NULL
    DROP TABLE silver.weather;
GO

CREATE TABLE silver.weather
(
    silver_weather_key BIGINT IDENTITY(1,1) PRIMARY KEY,

    observation_id VARCHAR(150) NOT NULL,

    ingestion_id UNIQUEIDENTIFIER NOT NULL,

    observation_timestamp_utc DATETIME2(0) NOT NULL,

    ingestion_timestamp_utc DATETIME2(3) NOT NULL,

    city VARCHAR(100) NOT NULL,

    country VARCHAR(100) NULL,

    latitude DECIMAL(9,6) NULL,

    longitude DECIMAL(9,6) NULL,


    -- Weather condition

    weather_id INT NULL,

    weather_main VARCHAR(50) NULL,

    weather_description VARCHAR(100) NULL,


    -- Temperature

    temperature_c DECIMAL(10,2) NULL,

    feels_like_c DECIMAL(10,2) NULL,

    temp_min_c DECIMAL(10,2) NULL,

    temp_max_c DECIMAL(10,2) NULL,


    -- Atmosphere

    pressure_hpa DECIMAL(10,2) NULL,

    humidity_pct DECIMAL(5,2) NULL,

    visibility_m INT NULL,


    -- Wind

    wind_speed_mps DECIMAL(10,2) NULL,

    wind_direction_deg DECIMAL(6,2) NULL,

    wind_gust_mps DECIMAL(10,2) NULL,


    -- Rain

    rain_1h_mm DECIMAL(10,2) NULL,


    -- Clouds

    cloudiness_pct DECIMAL(5,2) NULL,


    -- Data quality

    data_quality_flag VARCHAR(30) NOT NULL,

    quality_issue VARCHAR(500) NULL,


    -- Metadata

    source_system VARCHAR(50) NOT NULL,

    processed_at DATETIME2(3) NOT NULL
        DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_silver_weather_observation
ON silver.weather(observation_id);
GO



-- Silver Air Quality --
IF OBJECT_ID('silver.air_quality', 'U') IS NOT NULL
    DROP TABLE silver.air_quality;
GO

CREATE TABLE silver.air_quality
(
    silver_air_quality_key BIGINT IDENTITY(1,1) PRIMARY KEY,

    observation_id VARCHAR(150) NOT NULL,

    ingestion_id UNIQUEIDENTIFIER NOT NULL,

    observation_timestamp_utc DATETIME2(0) NOT NULL,

    ingestion_timestamp_utc DATETIME2(3) NOT NULL,


    city VARCHAR(100) NOT NULL,

    country VARCHAR(100) NULL,

    latitude DECIMAL(9,6) NULL,

    longitude DECIMAL(9,6) NULL,


    -- Air Quality Index

    aqi TINYINT NULL,


    -- Pollutants

    co DECIMAL(12,2) NULL,

    no DECIMAL(12,2) NULL,

    no2 DECIMAL(12,2) NULL,

    o3 DECIMAL(12,2) NULL,

    so2 DECIMAL(12,2) NULL,

    pm2_5 DECIMAL(12,2) NULL,

    pm10 DECIMAL(12,2) NULL,

    nh3 DECIMAL(12,2) NULL,


    -- Data quality

    data_quality_flag VARCHAR(30) NOT NULL,

    quality_issue VARCHAR(500) NULL,


    -- Metadata

    source_system VARCHAR(50) NOT NULL,

    processed_at DATETIME2(3) NOT NULL
        DEFAULT SYSUTCDATETIME()
);
GO

CREATE UNIQUE INDEX UX_silver_air_quality_observation
ON silver.air_quality(observation_id);
GO
