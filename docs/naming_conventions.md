# Naming Conventions

## Overview

The project uses consistent naming conventions to keep the repository easy
to understand, maintain, and review.

The main principle is:

> **Use clear, descriptive, and consistent names across all layers.**

## Python

Python files, modules, functions, and variables use `snake_case`.

```text
openweather.py
sql_server.py
collect_openweather.py
daily_validation.py
bronze_loader.py
warehouse_transform.py
```

Examples:

```python
get_weather()
collect_data()
validate_data()

city_name
temperature_c
wind_speed_mps
```

Constants use `UPPER_SNAKE_CASE`:

```python
CITIES = [...]
```

## SQL Server

SQL schemas and objects use lowercase `snake_case`.

### Schemas

```text
bronze
silver
gold
```

### Tables

Fact tables use `fact_`:

```text
gold.fact_environment
```

Dimension tables use `dim_`:

```text
gold.dim_city
gold.dim_date
gold.dim_time
```

### Columns

Columns use descriptive `snake_case` names:

```text
city_name
temperature_c
humidity_pct
pressure_hpa
wind_speed_mps
observation_timestamp_utc
```

## Units

Units are included as suffixes where useful:

| Suffix | Meaning |
|---|---|
| `_c` | Celsius |
| `_pct` | Percentage |
| `_hpa` | Hectopascals |
| `_m` | Metres |
| `_mps` | Metres per second |
| `_deg` | Degrees |
| `_mm` | Millimetres |
| `_utc` | UTC timestamp |

## Keys

Primary and foreign keys follow the `<entity>_key` pattern.

```text
environment_key
city_key
date_key
time_key
```

Example:

```text
fact_environment.city_key
        ↓
dim_city.city_key
```

## Analytical Datasets

Analytical outputs use descriptive business-focused names:

```text
city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis
```

## Jupyter Notebooks

Notebooks use a numeric prefix followed by the purpose:

```text
01_data_validation.ipynb
02_exploratory_analysis.ipynb
03_advanced_analysis.ipynb
```

## Power BI

Power BI uses business-friendly names because the dashboard is designed for
business users.

### Measures

```text
Average Temperature
Average AQI
Average PM2.5
Average PM10
Observation Count
Maximum PM2.5
```

### Pages

```text
Climate Impact Overview
Weather & Temperature
Air Quality & Pollution
City Comparison
Environmental Relationships & Patterns
Pollution Hotspots & Risk
```

## Documentation

Documentation files use lowercase `snake_case`:

```text
data_catalog.md
naming_conventions.md
dashboard_documentation.md
business_insights.md
```

`README.md` remains the standard repository entry point.

## Quick Reference

| Area | Convention | Example |
|---|---|---|
| Python files | `snake_case.py` | `daily_validation.py` |
| Functions | `snake_case()` | `get_weather()` |
| Variables | `snake_case` | `city_name` |
| Constants | `UPPER_SNAKE_CASE` | `CITIES` |
| SQL schemas | lowercase | `gold` |
| Fact tables | `fact_<name>` | `fact_environment` |
| Dimension tables | `dim_<name>` | `dim_city` |
| SQL columns | `snake_case` | `temperature_c` |
| Keys | `<entity>_key` | `city_key` |
| Notebooks | `<number>_<purpose>` | `03_advanced_analysis.ipynb` |
| Power BI | Business-friendly | `Average Temperature` |
| Documentation | `snake_case.md` | `data_catalog.md` |

## Summary

**Technical layers:** clear, consistent `snake_case` naming.

**Presentation layer:** readable, business-friendly naming.

These conventions should be followed when adding new files, tables,
columns, functions, notebooks, measures, or documentation.
