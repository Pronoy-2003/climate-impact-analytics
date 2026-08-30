# Data Pipeline

## 1. Overview

The Climate Impact Analysis project uses an end-to-end data pipeline to
collect weather and air-quality observations from the OpenWeather API,
validate the collected data, load it into a layered SQL Server
warehouse, transform it into business-ready analytical tables, and
consume the resulting data through analytical notebooks and Power BI.

The pipeline follows:

```text
OpenWeather API
      ↓
Python Data Collection
      ↓
Raw Data
      ↓
Data Validation
      ↓
Bronze Layer
      ↓
Silver Layer
      ↓
Gold Layer
      ↓
Analytical Processing
      ↓
Power BI
      ↓
Business Insights
```

---

# 2. Pipeline Objective

The pipeline is designed to provide a repeatable process for collecting
and analyzing environmental data across monitored cities.

The main objectives are:

- Collect weather observations.
- Collect air-quality observations.
- Validate incoming data.
- Preserve raw data in the Bronze layer.
- Clean and standardize data in the Silver layer.
- Create business-ready Gold tables.
- Perform exploratory and advanced analysis.
- Provide reliable datasets for Power BI.
- Maintain data lineage from source to dashboard.

---

# 3. Source Data

The pipeline uses the OpenWeather API as its primary external data
source.

The collected data consists of two major categories.

## Weather Data

```text
Temperature
Feels-like temperature
Minimum temperature
Maximum temperature
Humidity
Pressure
Visibility
Wind speed
Wind direction
Wind gust
Rainfall
Cloudiness
```

## Air Quality Data

```text
OpenWeather AQI
PM2.5
PM10
CO
NO
NO2
O3
SO2
NH3
```

The list of monitored cities is maintained separately from the API
communication logic.

---

# 4. Pipeline Components

The Python pipeline is organized into modules according to their
responsibilities.

```text
src/
│
├── api/
│   └── openweather.py
│
├── config/
│   └── cities.py
│
├── database/
│   └── sql_server.py
│
├── ingestion/
│   └── collect_openweather.py
│
├── validation/
│   └── daily_validation.py
│
└── warehouse/
    ├── bronze_loader.py
    └── warehouse_transform.py
```

Each module performs a specific part of the pipeline.

---

# 5. Step 1 — City Configuration

### Module

```text
src/config/cities.py
```

The city configuration module contains the list of monitored cities
used by the collection process.

Conceptually:

```text
cities.py
    │
    ▼
List of monitored cities
    │
    ▼
collect_openweather.py
```

Keeping the city configuration separate allows the monitored cities to
be changed without modifying the core API collection logic.

---

# 6. Step 2 — API Communication

### Module

```text
src/api/openweather.py
```

This module handles communication with the OpenWeather API.

It provides the functionality required to retrieve:

```text
Weather observations
Air-quality observations
```

The basic flow is:

```text
Monitored City
      ↓
OpenWeather API Request
      ↓
API Response
      ↓
Python
```

The API module is responsible for API interaction rather than database
loading or dashboard logic.

---

# 7. Step 3 — Data Collection

### Module

```text
src/ingestion/collect_openweather.py
```

This module coordinates the collection process.

The logical flow is:

```text
cities.py
    │
    ▼
collect_openweather.py
    │
    ├──────────────► openweather.py
    │                     │
    │                     ▼
    │               OpenWeather API
    │                     │
    │                     ▼
    └────────────── API Response
                          │
                          ▼
                       Raw Data
```

For each configured city, the collection process retrieves the
required weather and air-quality observations.

---

# 8. Step 4 — Raw Data

The collected API responses represent the source-level data.

Conceptually:

```text
OpenWeather API
      ↓
API Response
      ↓
Raw Data
```

The raw stage preserves the information received from the external
source before warehouse transformations are applied.

The raw data provides a reference point for downstream validation and
processing.

---

# 9. Step 5 — Data Validation

### Module

```text
src/validation/daily_validation.py
```

The validation stage checks whether the collected data is suitable
for downstream processing.

Validation focuses on data-quality issues such as:

```text
Missing values
Duplicate observations
Required fields
Expected structure
Data types
Invalid values
Observation consistency
```

Conceptually:

```text
Raw Data
   │
   ▼
daily_validation.py
   │
   ├──────────────► Valid Data
   │                    │
   │                    ▼
   │              Warehouse Loading
   │
   └──────────────► Invalid Data
                        │
                        ▼
                 Quality Investigation
```

The purpose is to prevent obvious data-quality problems from moving
silently into downstream analytical layers.

---

# 10. Step 6 — Database Connection

### Module

```text
src/database/sql_server.py
```

This module provides the SQL Server connection functionality used by
the Python pipeline.

Conceptually:

```text
Python Pipeline
      │
      ▼
sql_server.py
      │
      ▼
Microsoft SQL Server
```

Database connectivity is kept separate from ingestion and transformation
logic.

---

# 11. Step 7 — Bronze Layer Loading

### Module

```text
src/warehouse/bronze_loader.py
```

After the data collection and validation stages, data is loaded into
the Bronze layer.

The Bronze layer stores the raw warehouse representation of the
collected data.

```text
Validated Data
      │
      ▼
bronze_loader.py
      │
      ▼
Bronze SQL Layer
```

The Bronze layer provides a persistent starting point for downstream
warehouse processing.

---

# 12. Bronze Layer

The Bronze layer represents the raw stage of the SQL warehouse.

Its primary purpose is:

```text
Preserve source-level data
Maintain traceability
Provide input for transformations
```

Conceptually:

```text
Source Data
    │
    ▼
┌───────────────┐
│ Bronze Layer  │
│               │
│ Raw Data      │
└───────┬───────┘
        │
        ▼
Silver Transformation
```

The Bronze layer should generally contain minimal business
transformation.

---

# 13. Step 8 — Silver Transformation

### Module

```text
src/warehouse/warehouse_transform.py
```

The warehouse transformation process moves the data from the raw
warehouse representation toward cleaned and standardized datasets.

Conceptually:

```text
Bronze
  │
  ▼
warehouse_transform.py
  │
  ▼
Silver
```

Typical processing includes:

```text
Data cleansing
Data standardization
Data type handling
Derived fields
Data normalization
Data enrichment
```

The Silver layer is intended to provide a cleaner and more consistent
representation of the source data.

---

# 14. Silver Layer

The Silver layer contains cleaned and standardized data.

Its purpose is to prepare data for the final analytical warehouse
layer.

```text
Bronze
   │
   ▼
Silver
   │
   ├── Cleaned data
   ├── Standardized values
   ├── Consistent structures
   └── Derived/enriched information
   │
   ▼
Gold
```

The Silver layer separates technical data preparation from
business-oriented analytical modeling.

---

# 15. Step 9 — Gold Layer

The Gold layer contains business-ready analytical data.

The project uses four main Gold tables:

```text
gold.fact_environment
gold.dim_city
gold.dim_date
gold.dim_time
```

The logical model is:

```text
                 dim_city
                    │
                    ▼
dim_date ───► fact_environment ◄─── dim_time
```

---

# 16. Gold Fact Table

### Table

```text
gold.fact_environment
```

This is the central fact table of the analytical model.

It contains environmental observations including:

```text
Weather measurements
Air-quality measurements
Observation timestamps
City relationship
Date relationship
Time relationship
Data-quality flags
Source metadata
Loading metadata
```

Major measurement groups include:

```text
Temperature
Humidity
Pressure
Visibility
Wind
Rainfall
Cloudiness
AQI
PM2.5
PM10
CO
NO
NO2
O3
SO2
NH3
```

---

# 17. Gold Dimension Tables

## 17.1 City Dimension

```text
gold.dim_city
```

Provides city-level descriptive information.

Includes:

```text
City
Country
Latitude
Longitude
Region
Monitoring status
```

---

## 17.2 Date Dimension

```text
gold.dim_date
```

Provides calendar attributes.

Includes:

```text
Date
Year
Quarter
Month
Month name
Week
Day
Day name
Day of week
Weekend indicator
```

---

## 17.3 Time Dimension

```text
gold.dim_time
```

Provides time-of-day attributes.

Includes:

```text
Time
Hour
Minute
Hour label
Time period
```

The time period categorizes observations into:

```text
Night
Morning
Afternoon
Evening
```

---

# 18. Gold Layer Relationships

The central fact table connects the three dimensions.

```text
┌─────────────────┐
│   dim_city      │
│                 │
│   city_key      │
└────────┬────────┘
         │
         │
         ▼
┌──────────────────────────┐
│   fact_environment       │
│                          │
│ environment_key          │
│ observation_id           │
│ city_key                 │
│ date_key                 │
│ time_key                 │
│                          │
│ Weather measurements     │
│ Air-quality measurements │
└──────────┬───────────────┘
           ▲
           │
     ┌─────┴──────┐
     │            │
     │            │
┌────┴──────┐ ┌───┴────────┐
│ dim_date  │ │ dim_time   │
│           │ │            │
│ date_key  │ │ time_key   │
└───────────┘ └────────────┘
```

---

# 19. Step 10 — Analytical Processing

Once the Gold layer is available, the data is used for analytical
processing.

The main notebooks are:

```text
01_data_validation.ipynb
02_exploratory_analysis.ipynb
03_advanced_analysis.ipynb
```

---

## 19.1 Data Validation Analysis

```text
01_data_validation.ipynb
```

The notebook is used to inspect and validate the analytical dataset.

Examples include:

```text
Data completeness
Missing values
Data types
Value ranges
Duplicates
Relationships
```

---

## 19.2 Exploratory Analysis

```text
02_exploratory_analysis.ipynb
```

The notebook explores:

```text
Weather distributions
Air-quality distributions
City-level patterns
Time-based patterns
Pollution patterns
Environmental variables
```

---

## 19.3 Advanced Analysis

```text
03_advanced_analysis.ipynb
```

The advanced analysis produces business-oriented analytical outputs.

Key outputs include:

```text
city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis
```

These datasets support the final business analysis and Power BI
dashboard.

---

# 20. Advanced Analytical Outputs

## City Pollution Profile

```text
city_pollution_profile
```

Provides a city-level pollution summary including:

```text
Average PM2.5
Median PM2.5
Maximum PM2.5
Average PM10
Average temperature
Average humidity
Average wind speed
Observation count
Pollution segment
```

---

## Pollution Segment Analysis

```text
segment_environment_effect
```

Used to compare environmental characteristics across pollution
segments.

The analysis includes:

```text
Lower Pollution
Moderate Pollution
High Pollution
```

and compares environmental conditions such as:

```text
Temperature
Humidity
Wind Speed
```

---

## Environmental Relationships

```text
relationship_summary
```

Used to evaluate relationships between PM2.5 and environmental
variables.

The analysis includes variables such as:

```text
Temperature
Pressure
Humidity
Wind Speed
Rainfall
```

The output contains:

```text
Variable
Correlation with PM2.5
Absolute correlation
```

---

## Pollution Hotspots

```text
hotspot_analysis
```

Used to identify cities with comparatively high pollution burden.

The analysis combines measures such as:

```text
Average PM2.5
Maximum PM2.5
Average PM10
PM2.5 ranking
PM10 ranking
Hotspot score
```

---

# 21. Step 11 — Power BI Consumption

Power BI consumes the prepared Gold and analytical datasets.

The dashboard contains six analytical pages:

```text
1. Climate Impact Overview

2. Weather & Temperature

3. Air Quality & Pollution

4. City Comparison

5. Environmental Relationships & Patterns

6. Pollution Hotspots & Risk
```

The dashboard provides business-facing analysis of:

```text
Weather conditions
Temperature patterns
Air quality
Pollution levels
City comparisons
Environmental relationships
Pollution hotspots
```

---

# 22. End-to-End Pipeline

The complete pipeline can be summarized as:

```text
                    ┌─────────────────────┐
                    │   OpenWeather API   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   cities.py         │
                    │ City Configuration   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │ collect_openweather │
                    │       .py           │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   openweather.py    │
                    │    API Client       │
                    └──────────┬──────────┘
                               │
                               ▼
                         Raw Data
                               │
                               ▼
                    ┌─────────────────────┐
                    │ daily_validation.py │
                    │   Data Validation   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   bronze_loader.py  │
                    └──────────┬──────────┘
                               │
                               ▼
                       Bronze Layer
                               │
                               ▼
                  ┌────────────────────────┐
                  │ warehouse_transform.py │
                  └────────────┬───────────┘
                               │
                               ▼
                       Silver Layer
                               │
                               ▼
                         Gold Layer
                               │
                 ┌─────────────┼─────────────┐
                 │             │             │
                 ▼             ▼             ▼
            fact_environment  dim_city   dim_date
                 │
                 │
                 ▼
              dim_time
                 │
                 ▼
         Analytical Notebooks
                 │
                 ▼
       Advanced Analytical Outputs
                 │
                 ▼
              Power BI
                 │
                 ▼
          Business Insights
```

---

# 23. Data Lineage

A single environmental observation follows this logical lineage:

```text
OpenWeather API
      │
      ▼
API Response
      │
      ▼
Python Collection
      │
      ▼
Validation
      │
      ▼
Bronze
      │
      ▼
Silver
      │
      ▼
Gold fact_environment
      │
      ├──────────► dim_city
      │
      ├──────────► dim_date
      │
      └──────────► dim_time
      │
      ▼
Analytical Dataset
      │
      ▼
Power BI
      │
      ▼
Business Insight
```

---

# 24. Pipeline Responsibilities

| Component | Responsibility |
|---|---|
| `cities.py` | Stores monitored city configuration |
| `openweather.py` | Communicates with OpenWeather API |
| `collect_openweather.py` | Coordinates data collection |
| `sql_server.py` | Provides SQL Server connectivity |
| `daily_validation.py` | Performs data-quality validation |
| `bronze_loader.py` | Loads data into Bronze |
| `warehouse_transform.py` | Performs warehouse transformations |
| Bronze | Stores raw warehouse data |
| Silver | Stores cleaned and standardized data |
| Gold | Stores business-ready analytical data |
| Analytical notebooks | Perform validation, EDA and advanced analysis |
| Power BI | Presents business insights |

---

# 25. Data Flow by Layer

```text
SOURCE
────────────────────────────
OpenWeather API


INGESTION
────────────────────────────
Python API Client
        ↓
Data Collection


VALIDATION
────────────────────────────
Data Quality Checks


BRONZE
────────────────────────────
Raw Warehouse Data


SILVER
────────────────────────────
Cleaned
Standardized
Transformed


GOLD
────────────────────────────
Fact + Dimensions

fact_environment
dim_city
dim_date
dim_time


ANALYTICS
────────────────────────────
EDA
Advanced Analysis

city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis


VISUALIZATION
────────────────────────────
Power BI


CONSUMPTION
────────────────────────────
Business Insights
```

---

# 26. Pipeline Design Principles

The pipeline follows several design principles.

## Separation of Responsibilities

Each Python module performs a specific task.

```text
Configuration
    ↓
API
    ↓
Ingestion
    ↓
Validation
    ↓
Loading
    ↓
Transformation
```

---

## Layered Processing

Data is progressively refined:

```text
Raw
 ↓
Cleaned
 ↓
Business Ready
```

---

## Data Quality

Validation is performed before data moves into downstream warehouse
processing.

---

## Traceability

The Gold fact table contains metadata such as:

```text
observation_id
ingestion_id
source_system
loaded_at
```

These fields support data lineage and traceability.

---

## Reusability

The Gold layer is designed to support multiple consumers, including:

```text
Jupyter notebooks
Power BI
Future analytical workflows
```

---

# 27. Pipeline Output

The final pipeline produces two major types of output.

### Analytical Data

```text
Gold warehouse tables
Analytical datasets
```

### Business Intelligence

```text
Power BI dashboard
```

The final objective is to convert raw environmental observations into
actionable insights about:

```text
Weather conditions
Air quality
Pollution patterns
City-level differences
Environmental relationships
Pollution hotspots
```

---

# 28. Summary

The Climate Impact Analysis pipeline transforms external environmental
data into business-ready insights through a structured sequence:

```text
Collect
  ↓
Validate
  ↓
Store
  ↓
Clean
  ↓
Transform
  ↓
Model
  ↓
Analyze
  ↓
Visualize
  ↓
Interpret
```

This approach provides a clear and traceable path from the original
OpenWeather API observation to the final Power BI business insight.
