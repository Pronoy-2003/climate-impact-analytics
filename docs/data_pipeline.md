# Data Pipeline

## Overview

The Climate Impact Analysis project uses an end-to-end pipeline to collect
weather and air-quality data from the OpenWeather API, process it through
SQL Server's layered warehouse, and deliver insights through Power BI.

## Data Flow

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
Advanced Analysis
       ↓
Power BI
       ↓
Business Insights
```

## Pipeline Components

| Component | Purpose |
|---|---|
| OpenWeather API | Source of weather and air-quality data |
| Python | Collects and validates API data |
| Bronze Layer | Stores raw warehouse data |
| Silver Layer | Cleans and standardizes data |
| Gold Layer | Provides business-ready analytical data |
| Jupyter Notebooks | Performs EDA and advanced analysis |
| Power BI | Visualizes data and business insights |

## Python Pipeline Modules

```text
cities.py
    ↓
collect_openweather.py
    ↓
openweather.py
    ↓
daily_validation.py
    ↓
bronze_loader.py
    ↓
warehouse_transform.py
```

### Main Responsibilities

- `cities.py` — Maintains monitored cities
- `openweather.py` — Handles OpenWeather API communication
- `collect_openweather.py` — Coordinates data collection
- `daily_validation.py` — Performs data-quality checks
- `bronze_loader.py` — Loads data into Bronze
- `warehouse_transform.py` — Processes Bronze → Silver → Gold

## Warehouse Layers

### Bronze

Stores raw source data with minimal transformation.

### Silver

Cleans, standardizes, and prepares data for analytical modeling.

### Gold

Contains business-ready tables:

```text
gold.fact_environment
gold.dim_city
gold.dim_date
gold.dim_time
```

The Gold layer follows a fact-and-dimension structure, with
`fact_environment` as the central environmental observation table.

## Analytical Outputs

The Gold data is further analyzed using Jupyter notebooks.

Key outputs include:

```text
city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis
```

These outputs support the Power BI dashboard and business analysis.

## Power BI

The final analytical data is consumed by Power BI through six dashboard pages:

1. Climate Impact Overview
2. Weather & Temperature
3. Air Quality & Pollution
4. City Comparison
5. Environmental Relationships & Patterns
6. Pollution Hotspots & Risk

## Data Lineage

```text
OpenWeather API
      ↓
Python
      ↓
Validation
      ↓
Bronze
      ↓
Silver
      ↓
Gold
      ↓
Analysis
      ↓
Power BI
      ↓
Business Insights
```

## Architecture


![Data Pipeline Architecture](data_pipeline_architecture.png)

## Summary

The pipeline transforms raw environmental API data into structured,
business-ready insights through a repeatable process:

**Collect → Validate → Transform → Analyze → Visualize**
