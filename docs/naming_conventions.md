# Naming Conventions

## 1. Overview

This document defines the naming conventions used throughout the
Climate Impact Analysis project.

Consistent naming makes the project easier to:

- Understand
- Maintain
- Debug
- Navigate
- Extend
- Review

The conventions cover:

- Project folders
- Python files
- Python modules
- Python functions
- Python variables
- SQL schemas
- SQL tables
- SQL columns
- Primary and foreign keys
- Power BI measures
- Power BI pages
- Analytical datasets
- Documentation files

---

# 2. General Naming Principles

The project follows these general principles:

1. Use descriptive names.
2. Prefer clarity over short names.
3. Use lowercase for Python module and file names.
4. Use `snake_case` for Python variables and functions.
5. Use lowercase `snake_case` for SQL objects.
6. Use meaningful prefixes for data warehouse objects.
7. Avoid unnecessary abbreviations.
8. Keep naming consistent across all layers.
9. Use names that describe the business meaning of the object.
10. Avoid spaces and special characters in technical object names.

---

# 3. Repository and Folder Naming

Project folders use lowercase `snake_case` where applicable.

Example:

```text
Climate_Impact_Project/
│
├── data/
├── notebooks/
├── sql/
├── src/
├── docs/
├── dashboard/
└── README.md
```

Folders are organized according to their technical responsibility.

---

# 4. Python File Naming

Python files use:

```text
lowercase_snake_case.py
```

Examples from the project:

```text
openweather.py
cities.py
sql_server.py
collect_openweather.py
daily_validation.py
bronze_loader.py
warehouse_transform.py
```

### Rules

- Use lowercase letters.
- Separate words using underscores.
- Use `.py` as the file extension.
- The filename should describe the responsibility of the module.

### Examples

Good:

```text
openweather.py
sql_server.py
daily_validation.py
collect_openweather.py
```

Avoid:

```text
OpenWeather.py
SQLServer.py
DailyValidation.py
weatherFile.py
```

---

# 5. Python Module Naming

Python modules follow the same convention as Python files:

```text
lowercase_snake_case
```

Examples:

```text
api.openweather
config.cities
database.sql_server
ingestion.collect_openweather
validation.daily_validation
warehouse.bronze_loader
warehouse.warehouse_transform
```

The module name should clearly communicate its responsibility.

---

# 6. Python Function Naming

Functions use:

```text
snake_case
```

Function names should describe an action.

Examples:

```python
get_weather()
get_air_quality()
collect_data()
validate_data()
load_bronze()
transform_warehouse()
```

### Naming pattern

Prefer:

```text
verb_noun()
```

Examples:

```text
get_weather()
load_bronze()
validate_data()
transform_data()
```

Avoid vague names such as:

```text
data()
process()
run()
stuff()
```

unless the context makes the purpose completely clear.

---

# 7. Python Variable Naming

Variables use:

```text
snake_case
```

Examples:

```python
city_name
weather_data
air_quality_data
observation_timestamp
temperature_c
pm2_5
wind_speed_mps
```

Variables should represent the meaning of the stored value.

Avoid:

```python
x
data1
temp1
abc
```

when a descriptive name is possible.

---

# 8. Python Constants

Constants use:

```text
UPPER_SNAKE_CASE
```

Example:

```python
CITIES = [...]
```

Other examples:

```python
API_TIMEOUT = 30
MAX_RETRIES = 3
```

Constants should be used for configuration values that should not
normally change during program execution.

---

# 9. API and Source Naming

The project collects environmental data from the OpenWeather API.

The source-related module follows:

```text
openweather.py
```

The collection process follows:

```text
collect_openweather.py
```

This separates:

```text
API communication
       ↓
Data collection
```

rather than combining all responsibilities into a single module.

---

# 10. SQL Schema Naming

SQL schemas use lowercase names.

The warehouse layers are represented by schemas such as:

```text
bronze
silver
gold
```

The naming pattern is:

```text
schema.object_name
```

Examples:

```text
bronze.weather
silver.weather
gold.fact_environment
gold.dim_city
gold.dim_date
gold.dim_time
```

The schema identifies the data warehouse layer to which the object
belongs.

---

# 11. SQL Table Naming

SQL table names use:

```text
lowercase_snake_case
```

### Fact tables

Fact tables use the prefix:

```text
fact_
```

Example:

```text
gold.fact_environment
```

### Dimension tables

Dimension tables use the prefix:

```text
dim_
```

Examples:

```text
gold.dim_city
gold.dim_date
gold.dim_time
```

### Naming pattern

```text
fact_<business_process>
dim_<business_entity>
```

Examples:

```text
fact_environment
dim_city
dim_date
dim_time
```

---

# 12. Fact Table Naming Convention

Fact tables represent measurable business or analytical events.

The project uses:

```text
fact_environment
```

The table contains environmental observations such as:

```text
temperature
humidity
pressure
wind
rainfall
PM2.5
PM10
AQI
```

The prefix makes it immediately clear that the table is a fact table.

---

# 13. Dimension Table Naming Convention

Dimension tables provide descriptive context around facts.

The project uses:

```text
dim_city
dim_date
dim_time
```

The naming pattern is:

```text
dim_<entity>
```

Examples:

```text
dim_city
dim_date
dim_time
```

---

# 14. SQL Column Naming

SQL columns use:

```text
lowercase_snake_case
```

Examples:

```text
city_name
country_name
temperature_c
humidity_pct
pressure_hpa
wind_speed_mps
observation_timestamp_utc
```

Column names should describe:

1. What the value represents.
2. The unit where appropriate.

---

# 15. Unit Naming Convention

Units are included in column names when they improve clarity.

Examples:

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
rainfall_1h_mm
cloudiness_pct
```

Common unit suffixes used in the project:

| Suffix | Meaning |
|---|---|
| `_c` | Degrees Celsius |
| `_pct` | Percentage |
| `_hpa` | Hectopascals |
| `_m` | Metres |
| `_mps` | Metres per second |
| `_deg` | Degrees |
| `_mm` | Millimetres |
| `_utc` | UTC timestamp |

This makes the unit of measurement clear without requiring users to
look up the data dictionary.

---

# 16. Primary Key Naming

Surrogate primary keys use:

```text
<entity>_key
```

Examples:

```text
environment_key
city_key
date_key
time_key
```

Examples:

```text
gold.fact_environment.environment_key
gold.dim_city.city_key
gold.dim_date.date_key
gold.dim_time.time_key
```

---

# 17. Foreign Key Naming

Foreign keys use the same name as the corresponding primary key in
the referenced dimension.

Example:

```text
dim_city
    city_key
       │
       ▼
fact_environment
    city_key
```

The fact table contains:

```text
city_key
date_key
time_key
```

which reference:

```text
dim_city.city_key
dim_date.date_key
dim_time.time_key
```

This consistent naming makes relationships easier to identify.

---

# 18. Timestamp Naming

Timestamp columns should clearly indicate their timezone when
applicable.

The project uses:

```text
observation_timestamp_utc
```

The suffix:

```text
_utc
```

indicates that the timestamp is stored in Coordinated Universal Time.

Load metadata uses:

```text
loaded_at
```

---

# 19. Boolean Column Naming

Boolean fields should use names that communicate a true/false
condition.

Example:

```text
is_monitored
```

The expected values are:

```text
1 = True
0 = False
```

Other boolean fields should follow the same principle:

```text
is_<condition>
```

or

```text
has_<condition>
```

where appropriate.

---

# 20. Data Quality Field Naming

Data-quality fields use descriptive names.

The project uses:

```text
weather_quality_flag
air_quality_flag
```

The naming pattern is:

```text
<domain>_quality_flag
```

This makes it clear that the field represents a data-quality status
rather than an analytical measurement.

---

# 21. Metadata Column Naming

Metadata columns describe the origin or loading information of a
record.

The project uses:

```text
observation_id
ingestion_id
source_system
loaded_at
```

These fields support traceability and data lineage.

---

# 22. Analytical Dataset Naming

Analytical outputs should use descriptive names that represent their
business purpose.

Examples used during advanced analysis include:

```text
city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis
```

The naming pattern is:

```text
business_concept_analysis
business_concept_summary
business_concept_profile
```

Examples:

```text
city_pollution_profile
relationship_summary
hotspot_analysis
```

---

# 23. Jupyter Notebook Naming

Notebook filenames use:

```text
<number>_<purpose>.ipynb
```

Examples:

```text
01_data_validation.ipynb
02_exploratory_analysis.ipynb
03_advanced_analysis.ipynb
```

The numeric prefix represents the intended execution or analytical
sequence.

The purpose should be short but descriptive.

---

# 24. Power BI Measure Naming

Power BI measures use readable business-friendly names.

Examples:

```text
Average Temperature
Average AQI
Average PM2.5
Average PM10
Average Humidity
Average Wind Speed
Observation Count
Maximum PM2.5
```

Unlike technical SQL objects, Power BI measures are designed for
business users, so spaces and title-style capitalization are used.

---

# 25. Power BI Page Naming

Dashboard page names describe the analytical purpose of each page.

The current dashboard uses:

```text
Climate Impact Overview
Weather & Temperature
Air Quality & Pollution
City Comparison
Environmental Relationships & Patterns
Pollution Hotspots & Risk
```

Page names should:

- Be easy for business users to understand.
- Clearly describe the analysis.
- Avoid technical database terminology.
- Remain concise.

---

# 26. Documentation File Naming

Documentation files use:

```text
lowercase_snake_case.md
```

Examples:

```text
README.md
data_catalog.md
naming_conventions.md
```

Documentation filenames should clearly communicate their purpose.

---

# 27. Naming by Technology

| Area | Convention | Example |
|---|---|---|
| Python files | `snake_case.py` | `daily_validation.py` |
| Python functions | `snake_case()` | `get_weather()` |
| Python variables | `snake_case` | `city_name` |
| Python constants | `UPPER_SNAKE_CASE` | `CITIES` |
| SQL schemas | lowercase | `gold` |
| SQL fact tables | `fact_<name>` | `fact_environment` |
| SQL dimensions | `dim_<name>` | `dim_city` |
| SQL columns | `snake_case` | `temperature_c` |
| Primary keys | `<entity>_key` | `city_key` |
| Foreign keys | `<entity>_key` | `city_key` |
| Units | suffix | `_c`, `_pct`, `_mps` |
| Jupyter notebooks | `<number>_<purpose>` | `03_advanced_analysis.ipynb` |
| Power BI measures | Business-friendly | `Average Temperature` |
| Power BI pages | Business-friendly | `Air Quality & Pollution` |
| Markdown docs | `snake_case.md` | `data_catalog.md` |

---

# 28. Naming Examples Across the Project

A typical environmental observation follows a consistent naming
structure across the different technologies.

### Python

```python
temperature_c
wind_speed_mps
observation_timestamp
```

### SQL

```text
gold.fact_environment.temperature_c
gold.fact_environment.wind_speed_mps
gold.fact_environment.observation_timestamp_utc
```

### Power BI

```text
Average Temperature
Average Wind Speed
Observation Count
```

The technical layers use consistent machine-friendly names, while the
Power BI layer uses business-friendly names for dashboard users.

---

# 29. Naming Anti-Patterns

The following naming patterns should be avoided.

### Avoid unclear abbreviations

```text
tmp
hum
prs
ws
```

Prefer:

```text
temperature_c
humidity_pct
pressure_hpa
wind_speed_mps
```

### Avoid spaces in technical SQL/Python objects

Avoid:

```text
Average Temperature
City Name
```

Prefer:

```text
average_temperature
city_name
```

### Avoid inconsistent capitalization

Avoid mixing:

```text
City_Name
cityName
CITY_NAME
city_name
```

Use:

```text
city_name
```

### Avoid generic technical names

Avoid:

```text
data
table1
result
output
temp
```

when a meaningful name is available.

---

# 30. Naming Convention Summary

The project follows a simple principle:

> **Technical layers use consistent, machine-friendly `snake_case`
> naming, while the presentation layer uses business-friendly names.**

In summary:

```text
Python
    ↓
snake_case

SQL
    ↓
lowercase snake_case

Fact Tables
    ↓
fact_<business_process>

Dimension Tables
    ↓
dim_<business_entity>

Keys
    ↓
<entity>_key

Units
    ↓
descriptive suffix

Notebooks
    ↓
<number>_<purpose>

Power BI
    ↓
business-friendly names

Documentation
    ↓
lowercase_snake_case.md
```

These conventions should be followed whenever new files, tables,
columns, functions, measures, notebooks, or documentation are added
to the project.
