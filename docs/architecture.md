# System Architecture

## 1. Overview

The Climate Impact Analysis project is an end-to-end data analytics
pipeline that collects real-time weather and air-quality data,
validates and stores the data in a layered SQL data warehouse, performs
analytical processing, and presents business insights through Power BI.

The architecture follows a layered approach:

```text
External API
     ↓
Python Data Ingestion
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
Advanced Analytics
     ↓
Power BI
     ↓
Business Insights
```

The architecture separates data collection, data quality,
transformation, analytical processing, and visualization.

---

# 2. High-Level Architecture

![Data Architecture](project_architecture.png)

---

# 3. Architecture Layers

The project consists of the following major layers:

| Layer | Responsibility |
|---|---|
| Source Layer | Provides weather and air-quality data |
| Ingestion Layer | Collects data from the external API |
| Validation Layer | Checks data quality before warehouse loading |
| Bronze Layer | Stores raw collected data |
| Silver Layer | Cleans and standardizes data |
| Gold Layer | Provides business-ready analytical tables |
| Analytical Layer | Performs EDA and advanced analysis |
| Visualization Layer | Presents insights through Power BI |

---

# 4. Source Layer

The primary data source is the:

```text
OpenWeather API
```

The API provides environmental observations including:

### Weather

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

### Air Quality

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

The project collects these observations for a predefined list of
monitored cities.

---

# 5. Python Application Layer

The Python application is responsible for interacting with the API,
collecting data, and performing the initial validation workflow.

The main Python modules are organized by responsibility.

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

---

# 6. Configuration Module

### File

```text
src/config/cities.py
```

### Responsibility

This module contains the configuration for the monitored cities.

It provides the city information required by the data collection
process.

Conceptually:

```text
cities.py
    │
    │ monitored cities
    ▼
collect_openweather.py
```

Keeping city configuration separate from the collection logic makes
the ingestion process easier to maintain.

---

# 7. API Module

### File

```text
src/api/openweather.py
```

### Responsibility

This module handles communication with the OpenWeather API.

It contains the functions required to retrieve:

```text
Weather data
Air-quality data
```

Conceptually:

```text
OpenWeather API
       │
       ▼
openweather.py
       │
       ▼
Weather / Air Quality Response
```

The API module focuses on API communication rather than warehouse
loading or analytical processing.

---

# 8. Ingestion Module

### File

```text
src/ingestion/collect_openweather.py
```

### Responsibility

This module coordinates the data collection process.

The general flow is:

```text
cities.py
    │
    ▼
collect_openweather.py
    │
    ├──► openweather.py
    │
    └──► API responses
             │
             ▼
          Raw data
```

The ingestion process is responsible for collecting the observations
for the configured cities.

---

# 9. Database Module

### File

```text
src/database/sql_server.py
```

### Responsibility

This module provides the database connectivity required for
communication with SQL Server.

Conceptually:

```text
Python Application
       │
       ▼
sql_server.py
       │
       ▼
Microsoft SQL Server
```

The database connection logic is separated from business logic so
that database operations can be reused by different modules.

---

# 10. Validation Layer

### File

```text
src/validation/daily_validation.py
```

### Responsibility

The validation process checks the collected data before it becomes
part of the analytical warehouse.

Typical validation areas include:

```text
Completeness
Missing values
Duplicate observations
Expected columns
Data types
Value validity
Observation consistency
```

Conceptual flow:

```text
Raw Data
   │
   ▼
daily_validation.py
   │
   ├── Valid
   │     │
   │     ▼
   │   Warehouse Loading
   │
   └── Invalid
         │
         ▼
     Data Quality Investigation
```

Validation prevents obviously invalid data from silently moving
through the analytical pipeline.

---

# 11. Bronze Layer

The Bronze layer is the first warehouse layer.

### Purpose

The Bronze layer preserves the collected data in a raw form.

```text
Validated / Collected Data
          │
          ▼
    Bronze Layer
          │
          ▼
       Raw Data
```

The Bronze layer is intended to retain source-level information with
minimal transformation.

This layer provides a traceable starting point for downstream
processing.

---

# 12. Bronze Loader

### File

```text
src/warehouse/bronze_loader.py
```

### Responsibility

The Bronze loader handles the movement of collected data into the
Bronze SQL layer.

Conceptually:

```text
Collected Data
      │
      ▼
bronze_loader.py
      │
      ▼
Bronze SQL Layer
```

The loader separates ingestion from warehouse storage.

---

# 13. Silver Layer

The Silver layer contains cleaned and standardized data.

Conceptually:

```text
Bronze Layer
     │
     ▼
Silver Transformation
     │
     ▼
Cleaned & Standardized Data
```

The Silver layer is responsible for preparing data for analytical
consumption.

Typical transformation activities include:

```text
Data cleansing
Data standardization
Data type handling
Derived fields
Normalization
Data enrichment
```

The exact transformations are implemented through the project's
warehouse transformation process.

---

# 14. Warehouse Transformation

### File

```text
src/warehouse/warehouse_transform.py
```

### Responsibility

This module handles the warehouse transformation workflow.

Conceptually:

```text
Bronze
  │
  ▼
warehouse_transform.py
  │
  ▼
Silver
  │
  ▼
Gold
```

The transformation process prepares cleaned and structured data for
the Gold analytical layer.

---

# 15. Gold Layer

The Gold layer is the primary business-ready analytical layer.

The project contains four main Gold tables:

```text
gold.fact_environment
gold.dim_city
gold.dim_date
gold.dim_time
```

The logical model follows a dimensional structure:

```text
                  dim_city
                     │
                     │
                     ▼
dim_date ─────► fact_environment ◄───── dim_time
```

---

# 16. Gold Fact Table

### Table

```text
gold.fact_environment
```

### Purpose

This table stores environmental observations.

It contains measurements related to:

```text
Weather
    │
    ├── Temperature
    ├── Feels-like temperature
    ├── Minimum temperature
    ├── Maximum temperature
    ├── Humidity
    ├── Pressure
    ├── Visibility
    ├── Wind
    ├── Rainfall
    └── Cloudiness

Air Quality
    │
    ├── AQI
    ├── PM2.5
    ├── PM10
    ├── CO
    ├── NO
    ├── NO2
    ├── O3
    ├── SO2
    └── NH3
```

It also contains observation identifiers, ingestion metadata,
quality flags, and relationships to the city, date, and time
dimensions.

---

# 17. Gold City Dimension

### Table

```text
gold.dim_city
```

### Purpose

The city dimension provides descriptive information about monitored
cities.

It includes information such as:

```text
City
Country
Latitude
Longitude
Region
Monitoring status
```

Relationship:

```text
dim_city.city_key
        │
        ▼
fact_environment.city_key
```

---

# 18. Gold Date Dimension

### Table

```text
gold.dim_date
```

### Purpose

The date dimension provides calendar attributes for environmental
observations.

It contains attributes such as:

```text
Full date
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

Relationship:

```text
dim_date.date_key
        │
        ▼
fact_environment.date_key
```

---

# 19. Gold Time Dimension

### Table

```text
gold.dim_time
```

### Purpose

The time dimension provides time-of-day attributes.

It contains:

```text
Full time
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

Relationship:

```text
dim_time.time_key
        │
        ▼
fact_environment.time_key
```

---

# 20. Gold Layer Data Model

The Gold layer can be represented as:

```text
                    ┌─────────────────┐
                    │   dim_city      │
                    │                 │
                    │   city_key PK   │
                    └────────┬────────┘
                             │
                             │
                             ▼
┌─────────────────┐    ┌─────────────────────────┐    ┌─────────────────┐
│   dim_date      │    │   fact_environment      │    │   dim_time      │
│                 │    │                         │    │                 │
│ date_key PK     │───►│ environment_key PK      │◄───│ time_key PK     │
│ full_date       │    │ observation_id          │    │ full_time       │
│ year_number     │    │ city_key FK             │    │ hour_number     │
│ month_number    │    │ date_key FK             │    │ minute_number   │
│ day_name        │    │ time_key FK             │    │ time_period     │
│ is_weekend      │    │ temperature_c           │    └─────────────────┘
└─────────────────┘    │ humidity_pct            │
                       │ pressure_hpa            │
                       │ wind_speed_mps          │
                       │ rainfall_1h_mm          │
                       │ openweather_aqi         │
                       │ pm2_5                   │
                       │ pm10                    │
                       │ ...                     │
                       └─────────────────────────┘
```

The fact table contains the environmental measurements while the
dimension tables provide contextual information.

---

# 21. Analytical Layer

The Gold layer feeds the analytical notebooks.

The analytical workflow contains:

```text
notebooks/
│
├── 01_data_validation.ipynb
├── 02_exploratory_analysis.ipynb
└── 03_advanced_analysis.ipynb
```

---

## 21.1 Data Validation Notebook

```text
01_data_validation.ipynb
```

Purpose:

```text
Inspect Gold data
Check data quality
Validate relationships
Identify missing or unexpected values
```

---

## 21.2 Exploratory Analysis Notebook

```text
02_exploratory_analysis.ipynb
```

Purpose:

```text
Explore distributions
Analyze weather patterns
Analyze air-quality patterns
Compare cities
Study temporal patterns
```

---

## 21.3 Advanced Analysis Notebook

```text
03_advanced_analysis.ipynb
```

Purpose:

```text
City pollution profiles
Pollution segmentation
Environmental relationships
Correlation analysis
Pollution hotspot analysis
```

The advanced analysis produces analytical datasets such as:

```text
city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis
```

These outputs support the business analysis and dashboard development.

---

# 22. Power BI Layer

Power BI is the presentation and business intelligence layer.

The dashboard consumes the prepared Gold data and analytical outputs.

The current dashboard contains six pages:

```text
1. Climate Impact Overview

2. Weather & Temperature

3. Air Quality & Pollution

4. City Comparison

5. Environmental Relationships & Patterns

6. Pollution Hotspots & Risk
```

The dashboard allows users to explore:

```text
Weather conditions
Air quality
PM2.5 / PM10
City-level differences
Environmental relationships
Pollution hotspots
```

---

# 23. Complete Data Lineage

The complete lifecycle of an observation is:

```text
OpenWeather API
       │
       ▼
src/api/openweather.py
       │
       ▼
src/config/cities.py
       │
       ▼
src/ingestion/collect_openweather.py
       │
       ▼
Raw Collected Data
       │
       ▼
src/validation/daily_validation.py
       │
       ▼
src/warehouse/bronze_loader.py
       │
       ▼
Bronze SQL Layer
       │
       ▼
src/warehouse/warehouse_transform.py
       │
       ▼
Silver SQL Layer
       │
       ▼
Gold SQL Layer
       │
       ├──────────────► gold.dim_city
       │
       ├──────────────► gold.dim_date
       │
       ├──────────────► gold.dim_time
       │
       └──────────────► gold.fact_environment
                              │
                              ▼
                       Analytical Notebooks
                              │
                              ▼
                       Analytical Outputs
                              │
                              ▼
                           Power BI
                              │
                              ▼
                       Business Insights
```

---

# 24. Module Dependency Flow

The major Python module relationship is:

```text
                    ┌──────────────────┐
                    │    cities.py     │
                    │   Configuration  │
                    └────────┬─────────┘
                             │
                             ▼
                 ┌─────────────────────────┐
                 │ collect_openweather.py  │
                 │    Ingestion Workflow   │
                 └───────────┬─────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ openweather.py  │
                    │   API Client    │
                    └────────┬────────┘
                             │
                             ▼
                       API Response
                             │
                             ▼
                 ┌─────────────────────────┐
                 │ daily_validation.py    │
                 │    Data Validation     │
                 └───────────┬─────────────┘
                             │
                             ▼
                 ┌─────────────────────────┐
                 │    bronze_loader.py    │
                 │    Bronze Loading      │
                 └───────────┬─────────────┘
                             │
                             ▼
                       Bronze SQL
                             │
                             ▼
                 ┌─────────────────────────┐
                 │ warehouse_transform.py │
                 │ Warehouse Transformation│
                 └───────────┬─────────────┘
                             │
                             ▼
                       Silver / Gold
                             │
                             ▼
                      SQL Server
```

Database connectivity is provided through:

```text
sql_server.py
```

which supports the Python components that need to communicate with
SQL Server.

---

# 25. Orchestration

The project does not use a dedicated enterprise orchestration
platform.

The workflow is coordinated through the Python ingestion and
warehouse-processing modules.

The logical orchestration flow is:

```text
Configuration
     │
     ▼
API Collection
     │
     ▼
Validation
     │
     ▼
Bronze Loading
     │
     ▼
Warehouse Transformation
     │
     ▼
Gold Layer
```

The orchestration responsibility is therefore distributed across the
application workflow rather than being implemented as a separate
orchestration service.

For a portfolio project, this approach demonstrates the underlying
data engineering workflow without introducing unnecessary platform
complexity.

---

# 26. Separation of Responsibilities

A key architectural principle is separation of responsibilities.

```text
Configuration
    ↓
cities.py

API Communication
    ↓
openweather.py

Data Collection
    ↓
collect_openweather.py

Database Connectivity
    ↓
sql_server.py

Data Validation
    ↓
daily_validation.py

Bronze Loading
    ↓
bronze_loader.py

Warehouse Transformation
    ↓
warehouse_transform.py

Exploratory / Advanced Analysis
    ↓
Jupyter Notebooks

Visualization
    ↓
Power BI
```

Each component has a specific responsibility instead of combining
the entire pipeline into one script.

---

# 27. Why a Layered Architecture?

The layered architecture provides several advantages.

### Traceability

Raw data can be traced through each processing layer.

```text
Source
  ↓
Bronze
  ↓
Silver
  ↓
Gold
```

### Data Quality

Validation and cleaning are separated from analytical processing.

### Maintainability

Changes to one stage can be made without rewriting the entire
pipeline.

### Reusability

The Gold layer can be consumed by multiple analytical tools.

### Business Readiness

The Gold layer provides structured data suitable for Power BI and
business analysis.

### Scalability

Additional cities, measurements, analytical outputs, or dashboard
pages can be added without fundamentally changing the architecture.

---

# 28. End-to-End Architecture Summary

The complete architecture can be summarized as:

```text
┌───────────────────┐
│  OpenWeather API  │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Python Ingestion  │
│                   │
│ cities.py         │
│ openweather.py    │
│ collect_*.py      │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Data Validation    │
│                   │
│ daily_validation  │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Bronze Layer      │
│ Raw Data          │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Silver Layer      │
│ Cleaned Data      │
└─────────┬─────────┘
          │
          ▼
┌─────────────────────────────┐
│ Gold Layer                  │
│                             │
│ fact_environment            │
│ dim_city                    │
│ dim_date                    │
│ dim_time                    │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│ Analytical Layer            │
│                             │
│ EDA                         │
│ Advanced Analysis           │
│ Pollution Analysis          │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│ Power BI                    │
│                             │
│ 6 Analytical Dashboard      │
│ Pages                       │
└─────────────┬───────────────┘
              │
              ▼
       Business Insights
```

---

# 29. Architecture Principles

The project follows these principles:

1. **Separation of concerns**  
   Each component has a clearly defined responsibility.

2. **Layered data processing**  
   Data moves through Bronze, Silver, and Gold layers.

3. **Data quality before analytics**  
   Validation occurs before downstream analytical processing.

4. **Reusable components**  
   API, database, ingestion, validation, and warehouse logic are
   separated into reusable modules.

5. **Business-ready Gold layer**  
   Power BI and analytical workflows consume structured Gold data.

6. **Traceable data lineage**  
   Data can be followed from the external API through the warehouse
   to the final dashboard.

7. **Maintainability**  
   Configuration, ingestion, transformation, analysis, and
   visualization are kept separate.

---

# 30. Architecture at a Glance

```text
SOURCE
  │
  │ OpenWeather API
  ▼
INGESTION
  │
  │ Python
  ▼
VALIDATION
  │
  ▼
BRONZE
  │
  │ Raw
  ▼
SILVER
  │
  │ Cleaned / Standardized
  ▼
GOLD
  │
  ├── fact_environment
  ├── dim_city
  ├── dim_date
  └── dim_time
  │
  ▼
ANALYTICS
  │
  ├── Data Validation
  ├── EDA
  └── Advanced Analysis
  │
  ▼
POWER BI
  │
  ├── Climate Overview
  ├── Weather
  ├── Air Quality
  ├── City Comparison
  ├── Environmental Relationships
  └── Pollution Hotspots
  │
  ▼
BUSINESS INSIGHTS
```

The architecture is intentionally designed to be **simple enough for a
portfolio project while demonstrating a realistic end-to-end data
pipeline**.
