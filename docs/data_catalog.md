# Data Catalog for Gold Layer

## Overview

The **Gold Layer** is the final, business-ready layer of the SQL Server
warehouse. It provides structured data for analytics, reporting, and
Power BI.

The Gold layer follows a **Star Schema**:

```text
                 dim_city
                    │
                    ▼
dim_date ─────► fact_environment ◄───── dim_time
```

It contains:

- 1 Fact Table
- 3 Dimension Tables
- 2 Analytical Views

---

# Dimension Tables

## 1. `gold.dim_city`

**Purpose:**  
Provides city and geographic context for environmental observations.

**Columns:**

| Column | Data Type | Description |
|---|---|---|
| `city_key` | INT IDENTITY | Surrogate primary key |
| `city_name` | VARCHAR(100) | City name |
| `country_name` | VARCHAR(100) | Country name |
| `latitude` | DECIMAL(9,6) | Geographic latitude |
| `longitude` | DECIMAL(9,6) | Geographic longitude |
| `region` | VARCHAR(100) | Geographic/business region |
| `is_monitored` | BIT | Monitoring status |
| `created_at` | DATETIME2(3) | Record creation timestamp |

**Source:** `silver.weather`

**Business Usage:**
- City comparison
- Regional analysis
- Geographic filtering

---

## 2. `gold.dim_date`

**Purpose:**  
Provides calendar attributes for time-based analysis.

**Columns:**

| Column | Data Type | Description |
|---|---|---|
| `date_key` | INT | Primary date key |
| `full_date` | DATE | Calendar date |
| `year_number` | INT | Year |
| `quarter_number` | INT | Quarter |
| `month_number` | INT | Month number |
| `month_name` | VARCHAR(20) | Month name |
| `week_number` | INT | Week number |
| `day_number` | INT | Day of month |
| `day_name` | VARCHAR(20) | Day name |
| `day_of_week_number` | INT | Numeric day of week |
| `is_weekend` | BIT | Weekend indicator |

**Coverage:** `2026-01-01` to `2030-12-31`

**Business Usage:**
- Daily trends
- Monthly/yearly analysis
- Weekday vs weekend analysis

---

## 3. `gold.dim_time`

**Purpose:**  
Provides time-of-day context for environmental observations.

**Columns:**

| Column | Data Type | Description |
|---|---|---|
| `time_key` | INT | Primary time key |
| `full_time` | TIME(0) | Time value |
| `hour_number` | INT | Hour from 0–23 |
| `minute_number` | INT | Minute |
| `hour_label` | VARCHAR(20) | HH:mm display label |
| `time_period` | VARCHAR(30) | Night, Morning, Afternoon, or Evening |

**Granularity:** 5-minute intervals across a 24-hour day.

**Business Usage:**
- Time-of-day analysis
- Pollution pattern analysis
- Time-based Power BI filtering

---

# Fact Table

## 4. `gold.fact_environment`

**Purpose:**  
The central fact table storing weather and air-quality observations.

**Grain:**  
One row represents one environmental observation for a city at a
specific timestamp.

**Columns:**

### Keys & Observation

| Column | Data Type | Description |
|---|---|---|
| `environment_key` | BIGINT IDENTITY | Surrogate primary key |
| `observation_id` | VARCHAR(150) | Unique observation identifier |
| `ingestion_id` | UNIQUEIDENTIFIER | Ingestion run identifier |
| `city_key` | INT | City dimension key |
| `date_key` | INT | Date dimension key |
| `time_key` | INT | Time dimension key |
| `observation_timestamp_utc` | DATETIME2(0) | Observation timestamp in UTC |

### Weather Metrics

| Column | Data Type | Description |
|---|---|---|
| `temperature_c` | DECIMAL(10,2) | Temperature in Celsius |
| `feels_like_c` | DECIMAL(10,2) | Feels-like temperature in Celsius |
| `temp_min_c` | DECIMAL(10,2) | Minimum temperature |
| `temp_max_c` | DECIMAL(10,2) | Maximum temperature |
| `humidity_pct` | DECIMAL(5,2) | Relative humidity percentage |
| `pressure_hpa` | DECIMAL(10,2) | Atmospheric pressure |
| `visibility_m` | INT | Visibility in metres |
| `wind_speed_mps` | DECIMAL(10,2) | Wind speed in m/s |
| `wind_direction_deg` | DECIMAL(6,2) | Wind direction in degrees |
| `wind_gust_mps` | DECIMAL(10,2) | Wind gust speed in m/s |
| `rainfall_1h_mm` | DECIMAL(10,2) | Rainfall in the previous hour |
| `cloudiness_pct` | DECIMAL(5,2) | Cloudiness percentage |

### Air Quality Metrics

| Column | Data Type | Description |
|---|---|---|
| `openweather_aqi` | TINYINT | OpenWeather AQI value |
| `pm2_5` | DECIMAL(12,2) | PM2.5 concentration |
| `pm10` | DECIMAL(12,2) | PM10 concentration |
| `co` | DECIMAL(12,2) | Carbon monoxide |
| `no` | DECIMAL(12,2) | Nitric oxide |
| `no2` | DECIMAL(12,2) | Nitrogen dioxide |
| `o3` | DECIMAL(12,2) | Ozone |
| `so2` | DECIMAL(12,2) | Sulfur dioxide |
| `nh3` | DECIMAL(12,2) | Ammonia |

### Business & Quality Fields

| Column | Data Type | Description |
|---|---|---|
| `aqi_category` | VARCHAR(30) | Business-friendly AQ category |
| `weather_quality_flag` | VARCHAR(30) | Weather data-quality status |
| `air_quality_flag` | VARCHAR(30) | Air-quality data-quality status |

### Metadata

| Column | Data Type | Description |
|---|---|---|
| `source_system` | VARCHAR(50) | Source system |
| `loaded_at` | DATETIME2(3) | Warehouse load timestamp |

**Source:** Silver weather/environment data.

**Constraint:** `observation_id` has a unique index to prevent duplicate
observations.

**Business Usage:**
- Weather analysis
- Air-quality analysis
- City comparison
- Pollution trends
- Environmental relationships
- Pollution hotspot analysis
- Power BI reporting

---

# Gold Views

## 5. `gold.vw_environment_daily`

**Purpose:**  
Provides daily aggregated weather and air-quality metrics by city.

**Columns:**

| Column | Description |
|---|---|
| `city_key` | City dimension key |
| `observation_date` | Observation date |
| `observation_count` | Number of observations |
| `avg_temperature_c` | Average temperature |
| `min_temperature_c` | Minimum temperature |
| `max_temperature_c` | Maximum temperature |
| `temperature_stddev_c` | Temperature standard deviation |
| `avg_feels_like_c` | Average feels-like temperature |
| `avg_humidity_pct` | Average humidity |
| `avg_pressure_hpa` | Average pressure |
| `avg_visibility_m` | Average visibility |
| `avg_wind_speed_mps` | Average wind speed |
| `max_wind_speed_mps` | Maximum wind speed |
| `avg_wind_gust_mps` | Average wind gust |
| `max_rainfall_1h_mm` | Maximum rainfall |
| `avg_cloudiness_pct` | Average cloudiness |
| `avg_aqi` | Average AQI |
| `max_aqi` | Maximum AQI |
| `avg_pm2_5` | Average PM2.5 |
| `max_pm2_5` | Maximum PM2.5 |
| `avg_pm10` | Average PM10 |
| `max_pm10` | Maximum PM10 |
| `avg_co` | Average CO |
| `avg_no` | Average NO |
| `avg_no2` | Average NO2 |
| `avg_o3` | Average O3 |
| `avg_so2` | Average SO2 |
| `avg_nh3` | Average NH3 |

**Source:** `gold.fact_environment`

**Business Usage:**
- Daily environmental trends
- City-level KPI reporting
- Power BI analysis

---

## 6. `gold.vw_environment_hourly`

**Purpose:**  
Provides hourly aggregated weather and air-quality metrics by city.

**Columns:**

| Column | Description |
|---|---|
| `city_key` | City dimension key |
| `observation_hour` | Observation hour |
| `observation_count` | Number of observations |
| `avg_temperature_c` | Average temperature |
| `min_temperature_c` | Minimum temperature |
| `max_temperature_c` | Maximum temperature |
| `avg_feels_like_c` | Average feels-like temperature |
| `avg_humidity_pct` | Average humidity |
| `avg_pressure_hpa` | Average pressure |
| `avg_visibility_m` | Average visibility |
| `avg_wind_speed_mps` | Average wind speed |
| `avg_wind_direction_deg` | Average wind direction |
| `avg_wind_gust_mps` | Average wind gust |
| `rainfall_1h_mm` | Rainfall value from the latest observation in the hour |
| `avg_cloudiness_pct` | Average cloudiness |
| `avg_aqi` | Average AQI |
| `avg_pm2_5` | Average PM2.5 |
| `max_pm2_5` | Maximum PM2.5 |
| `avg_pm10` | Average PM10 |
| `max_pm10` | Maximum PM10 |
| `avg_co` | Average CO |
| `avg_no` | Average NO |
| `avg_no2` | Average NO2 |
| `avg_o3` | Average O3 |
| `avg_so2` | Average SO2 |
| `avg_nh3` | Average NH3 |

**Source:** `gold.fact_environment`

**Business Usage:**
- Hourly pollution analysis
- Time-of-day comparison
- AQI and PM2.5 trends
- Power BI analysis

---

# Relationships

```text
                 ┌──────────────┐
                 │   dim_city   │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │              │
                 │fact_environment
                 │              │
                 └──────┬───────┘
                        ▲
                 ┌──────┴───────┐
                 │              │
          ┌──────┴──────┐ ┌─────┴──────┐
          │   dim_date  │ │  dim_time  │
          └─────────────┘ └────────────┘
```

```text
dim_city.city_key → fact_environment.city_key
dim_date.date_key → fact_environment.date_key
dim_time.time_key → fact_environment.time_key
```

Each dimension has a **1-to-many** relationship with the fact table.

---

# Gold Layer Summary

| Object | Type | Role |
|---|---|---|
| `gold.fact_environment` | Fact Table | Environmental observations |
| `gold.dim_city` | Dimension | City context |
| `gold.dim_date` | Dimension | Calendar context |
| `gold.dim_time` | Dimension | Time-of-day context |
| `gold.vw_environment_daily` | View | Daily environmental aggregates |
| `gold.vw_environment_hourly` | View | Hourly environmental aggregates |

**Gold Layer → Analysis → Power BI**
