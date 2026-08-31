# System Architecture & Data Pipeline

## Overview

The Climate Impact Analysis project is an end-to-end analytics pipeline that collects weather and air-quality data from the OpenWeather API, validates and processes the data through a layered SQL Server warehouse, performs analysis, and delivers business insights through Power BI.

## Architecture

![Data Architecture](project_architecture.png)



## End-to-End Data Flow

```text
OpenWeather API
       ↓
Python Data Collection
       ↓
Data Validation
       ↓
Bronze Layer
       ↓
Silver Layer
       ↓
Gold Layer
       ↓
Analytical Notebooks
       ↓
Power BI
       ↓
Business Insights
```

## 1. Source Layer

**OpenWeather API**

Provides weather and air-quality observations for the monitored cities.

Main data includes:

- Temperature and feels-like temperature
- Humidity and pressure
- Wind and rainfall
- AQI
- PM2.5 and PM10
- Other air-quality measurements

## 2. Python Application Layer

Python handles data collection, validation, database connectivity, and warehouse processing.

```text
src/
├── api/
│   └── openweather.py
├── config/
│   └── cities.py
├── database/
│   └── sql_server.py
├── ingestion/
│   └── collect_openweather.py
├── validation/
│   └── daily_validation.py
└── warehouse/
    ├── bronze_loader.py
    └── warehouse_transform.py
```

### Module Responsibilities

| Module | Responsibility |
|---|---|
| `cities.py` | Maintains monitored city configuration |
| `openweather.py` | Handles API communication |
| `collect_openweather.py` | Coordinates data collection |
| `daily_validation.py` | Performs data-quality checks |
| `sql_server.py` | Provides SQL Server connectivity |
| `bronze_loader.py` | Loads data into Bronze |
| `warehouse_transform.py` | Processes warehouse layers |

## 3. Data Validation

Collected data is validated before downstream warehouse processing.

Key checks include:

- Missing values
- Duplicate observations
- Required columns
- Data types
- Invalid or unexpected values

```text
Collected Data
      ↓
Validation
      ↓
Valid Data → Warehouse
```

## 4. SQL Server Warehouse

The warehouse uses a layered architecture:

```text
Bronze
  ↓
Silver
  ↓
Gold
```

### Bronze Layer

Stores collected data in a raw form with minimal transformation.

### Silver Layer

Cleans, standardizes, and prepares data for analytical use.

### Gold Layer

Provides structured, business-ready data for analysis and reporting.

The main Gold model contains:

![Data Model](data_mart.png)

### Gold Tables

```text
gold.fact_environment
gold.dim_city
gold.dim_date
gold.dim_time
```

- `fact_environment` — environmental observations
- `dim_city` — city and geographic information
- `dim_date` — calendar attributes
- `dim_time` — time-of-day attributes

## 5. Analytical Layer

The Gold layer feeds the Jupyter notebooks:

```text
01_data_validation.ipynb
        ↓
02_exploratory_analysis.ipynb
        ↓
03_advanced_analysis.ipynb
```

The analysis covers:

- Data validation
- Exploratory analysis
- City pollution profiles
- Environmental relationships
- Pollution segmentation
- Pollution hotspot analysis

Key analytical outputs include:

```text
city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis
```

## 6. Power BI Layer

The prepared data and analytical outputs are used to build the Power BI dashboard.

The dashboard contains six pages:

1. Climate Impact Overview
2. Weather & Temperature
3. Air Quality & Pollution
4. City Comparison
5. Environmental Relationships & Patterns
6. Pollution Hotspots & Risk

The dashboard converts the analytical results into interactive business insights.

## 7. Data Lineage

```text
OpenWeather API
       │
       ▼
Python Ingestion
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
Gold
       │
       ▼
Analysis
       │
       ▼
Power BI
       │
       ▼
Business Insights
```

## 8. Orchestration

The project does not use a separate enterprise orchestration platform.

The pipeline workflow is coordinated through the Python ingestion,
validation, loading, and warehouse transformation modules.

![Data Pipelining](data_pipeline_architecture.png)

## 9. Key Architecture Principles

- **Layered processing:** Bronze → Silver → Gold
- **Data quality:** Validation before downstream processing
- **Separation of concerns:** Each Python module has a specific responsibility
- **Traceability:** Data can be followed from API source to dashboard
- **Business-ready data:** Gold provides structured data for analytics and reporting

## Summary

The architecture separates the project into clear stages:

**Collect → Validate → Store → Transform → Analyze → Visualize → Decide**

This structure keeps the pipeline maintainable while providing a clear path from raw environmental data to business insights.
