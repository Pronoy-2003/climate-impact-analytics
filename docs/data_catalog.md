# Data Catalog

## 1. Overview

The Gold layer contains business-ready data structures designed for
analytical reporting, exploratory analysis, advanced analysis, and
Power BI visualization.

The current Gold layer consists of four tables:

```text
gold
│
├── fact_environment
├── dim_city
├── dim_date
└── dim_time
```

The model follows a dimensional data warehouse structure in which
`fact_environment` acts as the central fact table and the dimension
tables provide contextual information about each environmental
observation.

---

# 2. Gold Layer Data Model

![Data Mart](docs/data_mart.png)

### Relationships

| Parent Table | Parent Key | Child Table | Foreign Key | Relationship |
|---|---|---|---|---|
| `gold.dim_city` | `city_key` | `gold.fact_environment` | `city_key` | 1 : Many |
| `gold.dim_date` | `date_key` | `gold.fact_environment` | `date_key` | 1 : Many |
| `gold.dim_time` | `time_key` | `gold.fact_environment` | `time_key` | 1 : Many |

---

# 3. Gold Table: `gold.fact_environment`

## Purpose

`gold.fact_environment` is the central analytical fact table of the
Gold layer.

It stores weather and air-quality observations collected for monitored
cities.

The table contains:

- Observation identifiers
- City, date, and time keys
- Observation timestamps
- Weather measurements
- Air-quality measurements
- Business-friendly AQI category
- Data-quality flags
- Source and loading metadata

---

## Grain

**One row represents one environmental observation for a city at a
specific observation timestamp.**

This grain allows the data to be analyzed by:

- City
- Date
- Time
- Time period
- Weather condition
- Air-quality condition

---

## Primary Key

```text
environment_key
```

The primary key is a `BIGINT IDENTITY` surrogate key.

---

## Unique Key

```text
observation_id
```

A unique index is created on `observation_id`:

```text
UX_fact_environment_observation
```

This ensures that an observation identifier cannot be duplicated in
the fact table.

---

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---:|---|
| `environment_key` | BIGINT | No | Surrogate primary key for the environmental observation |
| `observation_id` | VARCHAR(150) | No | Unique identifier for the environmental observation |
| `ingestion_id` | UNIQUEIDENTIFIER | No | Identifier associated with the ingestion run |
| `city_key` | INT | No | Foreign key identifying the monitored city |
| `date_key` | INT | No | Foreign key identifying the observation date |
| `time_key` | INT | No | Foreign key identifying the observation time |
| `observation_timestamp_utc` | DATETIME2(0) | No | Observation timestamp in UTC |
| `temperature_c` | DECIMAL(10,2) | Yes | Temperature in degrees Celsius |
| `feels_like_c` | DECIMAL(10,2) | Yes | Feels-like temperature in degrees Celsius |
| `temp_min_c` | DECIMAL(10,2) | Yes | Minimum temperature in degrees Celsius |
| `temp_max_c` | DECIMAL(10,2) | Yes | Maximum temperature in degrees Celsius |
| `humidity_pct` | DECIMAL(5,2) | Yes | Relative humidity percentage |
| `pressure_hpa` | DECIMAL(10,2) | Yes | Atmospheric pressure in hPa |
| `visibility_m` | INT | Yes | Visibility distance in metres |
| `wind_speed_mps` | DECIMAL(10,2) | Yes | Wind speed in metres per second |
| `wind_direction_deg` | DECIMAL(6,2) | Yes | Wind direction in degrees |
| `wind_gust_mps` | DECIMAL(10,2) | Yes | Wind gust speed in metres per second |
| `rainfall_1h_mm` | DECIMAL(10,2) | Yes | Rainfall measured over the previous hour in millimetres |
| `cloudiness_pct` | DECIMAL(5,2) | Yes | Cloudiness percentage |
| `openweather_aqi` | TINYINT | Yes | Air Quality Index value provided by OpenWeather |
| `pm2_5` | DECIMAL(12,2) | Yes | PM2.5 concentration |
| `pm10` | DECIMAL(12,2) | Yes | PM10 concentration |
| `co` | DECIMAL(12,2) | Yes | Carbon monoxide measurement |
| `no` | DECIMAL(12,2) | Yes | Nitric oxide measurement |
| `no2` | DECIMAL(12,2) | Yes | Nitrogen dioxide measurement |
| `o3` | DECIMAL(12,2) | Yes | Ozone measurement |
| `so2` | DECIMAL(12,2) | Yes | Sulfur dioxide measurement |
| `nh3` | DECIMAL(12,2) | Yes | Ammonia measurement |
| `aqi_category` | VARCHAR(30) | Yes | Business-friendly air-quality category |
| `weather_quality_flag` | VARCHAR(30) | Yes | Weather data-quality status |
| `air_quality_flag` | VARCHAR(30) | Yes | Air-quality data-quality status |
| `source_system` | VARCHAR(50) | No | Source system from which the observation originated |
| `loaded_at` | DATETIME2(3) | No | UTC timestamp when the record was loaded into the Gold table |

---

## Fact Table Categories

### Observation Information

```text
observation_id
ingestion_id
observation_timestamp_utc
```

### Dimension Keys

```text
city_key
date_key
time_key
```

### Weather Metrics

```text
temperature_c
feels_like_c
temp_min_c
temp_max_c
humidity_pct
pressure_hpa
visibility_m
wind_speed_mps
wind_direction_deg
wind_gust_mps
rainfall_1h_mm
cloudiness_pct
```

### Air Quality Metrics

```text
openweather_aqi
pm2_5
pm10
co
no
no2
o3
so2
nh3
```

### Business Classification

```text
aqi_category
```

### Data Quality

```text
weather_quality_flag
air_quality_flag
```

### Metadata

```text
source_system
loaded_at
```

---

# 4. Gold Table: `gold.dim_city`

## Purpose

`gold.dim_city` contains descriptive information about the cities
monitored by the environmental data pipeline.

It provides geographical and business context for observations stored
in `gold.fact_environment`.

---

## Primary Key

```text
city_key
```

`city_key` is an `INT IDENTITY` surrogate key.

---

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---:|---|
| `city_key` | INT | No | Surrogate primary key identifying the city |
| `city_name` | VARCHAR(100) | No | Name of the monitored city |
| `country_name` | VARCHAR(100) | Yes | Country containing the city |
| `latitude` | DECIMAL(9,6) | Yes | Geographic latitude |
| `longitude` | DECIMAL(9,6) | Yes | Geographic longitude |
| `region` | VARCHAR(100) | Yes | Business/geographical region assigned to the city |
| `is_monitored` | BIT | No | Indicates whether the city is currently monitored |
| `created_at` | DATETIME2(3) | No | UTC timestamp when the city record was created |

---

## Region Classification

The current city dimension assigns cities to broad regions.

### North/Central/West India

```text
Delhi
Lucknow
Patna
Bhopal
Jaipur
Ahmedabad
```

### West India

```text
Mumbai
Pune
```

### East/Northeast India

```text
Kolkata
Bhubaneswar
Guwahati
```

### South India

```text
Bengaluru
Chennai
Hyderabad
Kochi
```

### International

Cities outside the defined Indian regional groups are assigned to:

```text
International
```

---

# 5. Gold Table: `gold.dim_date`

## Purpose

`gold.dim_date` is the date dimension used to provide calendar context
for environmental observations.

It allows analysis by:

- Year
- Quarter
- Month
- Week
- Day
- Day of week
- Weekend status

---

## Primary Key

```text
date_key
```

The key is represented as an integer in `YYYYMMDD` format.

Example:

```text
20260830
```

represents:

```text
30 August 2026
```

---

## Date Coverage

The current date dimension is populated from:

```text
2026-01-01
```

through:

```text
2030-12-31
```

---

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---:|---|
| `date_key` | INT | No | Surrogate/business date key in YYYYMMDD format |
| `full_date` | DATE | No | Complete calendar date |
| `year_number` | INT | No | Calendar year |
| `quarter_number` | INT | No | Quarter number |
| `month_number` | INT | No | Month number |
| `month_name` | VARCHAR(20) | No | Month name |
| `week_number` | INT | No | Week number |
| `day_number` | INT | No | Day number within the month |
| `day_name` | VARCHAR(20) | No | Day name |
| `day_of_week_number` | INT | No | Numeric day-of-week representation |
| `is_weekend` | BIT | No | Indicates whether the date is classified as a weekend |

---

# 6. Gold Table: `gold.dim_time`

## Purpose

`gold.dim_time` provides time-of-day context for environmental
observations.

It allows analysis of environmental conditions across:

- Hour
- Minute
- Time period

---

## Primary Key

```text
time_key
```

The key is constructed using:

```text
hour_number * 100 + minute_number
```

Examples:

```text
0000 → 00:00
0530 → 05:30
1200 → 12:00
1830 → 18:30
```

---

## Time Granularity

The dimension is populated at **5-minute intervals** throughout the
24-hour day.

This results in:

```text
24 hours × 12 intervals per hour
= 288 time records
```

---

## Columns

| Column | Data Type | Nullable | Description |
|---|---|---:|---|
| `time_key` | INT | No | Primary key representing the time |
| `full_time` | TIME(0) | No | Complete time value |
| `hour_number` | INT | No | Hour number from 0 to 23 |
| `minute_number` | INT | No | Minute component |
| `hour_label` | VARCHAR(20) | No | Human-readable HH:mm representation |
| `time_period` | VARCHAR(30) | No | Business-friendly time period |

---

## Time Period Classification

The current classification is:

| Hour Range | Time Period |
|---|---|
| 00:00–05:59 | Night |
| 06:00–11:59 | Morning |
| 12:00–16:59 | Afternoon |
| 17:00–20:59 | Evening |
| 21:00–23:59 | Night |

This classification is used in analytical and Power BI reporting.

---

# 7. Fact-to-Dimension Mapping

## City

```text
gold.dim_city.city_key
            │
            │ 1
            ▼
gold.fact_environment.city_key
            *
```

The city dimension provides geographical context for each
environmental observation.

---

## Date

```text
gold.dim_date.date_key
            │
            │ 1
            ▼
gold.fact_environment.date_key
            *
```

The date dimension provides calendar context for each observation.

---

## Time

```text
gold.dim_time.time_key
            │
            │ 1
            ▼
gold.fact_environment.time_key
            *
```

The time dimension provides time-of-day context for each observation.

---

# 8. Analytical Usage

The Gold layer supports several types of analysis.

## Weather Analysis

Relevant fields include:

```text
temperature_c
feels_like_c
temp_min_c
temp_max_c
humidity_pct
pressure_hpa
visibility_m
wind_speed_mps
wind_direction_deg
wind_gust_mps
rainfall_1h_mm
cloudiness_pct
```

---

## Air Quality Analysis

Relevant fields include:

```text
openweather_aqi
pm2_5
pm10
co
no
no2
o3
so2
nh3
aqi_category
```

---

## City Comparison

The following dimensions and measures can be combined:

```text
dim_city
    +
fact_environment
```

Examples:

- Average PM2.5 by city
- Average PM10 by city
- Average temperature by city
- Average humidity by city
- Pollution hotspot comparison

---

## Time-Based Analysis

The date and time dimensions allow analysis such as:

```text
Date
 ├── Year
 ├── Quarter
 ├── Month
 ├── Week
 └── Day

Time
 ├── Hour
 ├── Minute
 └── Time Period
```

Examples:

- PM2.5 by day
- Temperature trend
- AQI by time of day
- PM2.5 by time period
- Weather conditions across different periods

---

# 9. Data Quality Fields

The fact table contains two dedicated data-quality fields.

## `weather_quality_flag`

Used to represent the quality/status of weather-related observations.

## `air_quality_flag`

Used to represent the quality/status of air-quality observations.

These fields allow data-quality conditions to be retained alongside
the analytical measurements rather than being discarded during
processing.

---

# 10. Metadata and Traceability

The fact table retains metadata that supports data lineage.

### `observation_id`

Identifies the individual environmental observation.

### `ingestion_id`

Identifies the ingestion run associated with the observation.

### `source_system`

Identifies the originating source system.

### `loaded_at`

Records when the record was loaded into the Gold layer.

Together, these fields provide traceability from analytical records
back toward the ingestion process.

---

# 11. Business-Ready Fields

Some fields are specifically designed to make analysis easier for
business users.

Examples include:

```text
aqi_category
region
time_period
is_weekend
```

These fields reduce the need for repeated classification logic in
Power BI and analytical notebooks.

---

# 12. Power BI Usage

The Gold layer is used as the primary analytical source for the
Power BI dashboard.

The model supports the following dashboard areas:

```text
Climate Impact Overview
        │
        ├── Weather & Temperature
        │
        ├── Air Quality & Pollution
        │
        ├── City Comparison
        │
        ├── Environmental Relationships & Patterns
        │
        └── Pollution Hotspots & Risk
```

The Gold model provides the underlying data used for:

- KPI cards
- Trend analysis
- City comparisons
- Environmental relationships
- Pollution rankings
- Hotspot analysis
- Time-of-day analysis

---

# 13. Analytical Tables and Views

The supplied Gold-layer DDL defines the following four Gold tables:

```text
gold.fact_environment
gold.dim_city
gold.dim_date
gold.dim_time
```

No additional Gold-layer views are documented in the supplied DDL.

If analytical views are added later, they should be documented in this
section with:

- View name
- Purpose
- Source tables
- Grain
- Calculated fields
- Business use
- Power BI usage

---

# 14. Data Catalog Summary

| Object | Type | Role | Grain |
|---|---|---|---|
| `gold.fact_environment` | Fact Table | Environmental observations | One environmental observation |
| `gold.dim_city` | Dimension | City/geographical context | One row per monitored city |
| `gold.dim_date` | Dimension | Calendar context | One row per date |
| `gold.dim_time` | Dimension | Time-of-day context | One row per 5-minute interval |

---

# 15. Gold Layer Design Summary

The Gold layer follows a dimensional model:

![Data Architecture](project_architecture.png)

The design separates:

**Measures and observations**

from

**Descriptive dimensions**

while keeping the Gold layer optimized for analytical querying and
Power BI reporting.
