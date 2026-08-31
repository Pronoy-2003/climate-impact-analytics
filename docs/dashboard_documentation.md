# Power BI Dashboard Documentation

## 1. Dashboard Overview

The Climate Impact Analytics dashboard is the business intelligence
layer of the project.

It transforms the prepared Gold-layer environmental data and analytical
outputs into an interactive dashboard for monitoring and comparing
weather and air-quality conditions across monitored cities.

The dashboard is designed to help users:

- Monitor overall environmental conditions.
- Compare cities.
- Analyze temperature and weather patterns.
- Monitor air-quality conditions.
- Identify pollution hotspots.
- Explore relationships between environmental variables and PM2.5.
- Understand pollution patterns across different time periods.

---

# 2. Dashboard Structure

The dashboard contains six analytical pages:

```text
┌─────────────────────────────────────────┐
│ 1. Climate Impact Overview              │
│                                         │
│ Overall environmental performance       │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│ 2. Weather & Temperature                │
│                                         │
│ Weather conditions and trends           │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│ 3. Air Quality & Pollution              │
│                                         │
│ AQI, PM2.5 and PM10 analysis            │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│ 4. City Comparison                      │
│                                         │
│ Environmental comparison across cities  │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│ 5. Environmental Relationships &        │
│    Patterns                             │
│                                         │
│ Environmental relationships and timing   │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│ 6. Pollution Hotspots & Risk            │
│                                         │
│ Pollution hotspot identification        │
└─────────────────────────────────────────┘
```

---

# 3. Dashboard Data Sources

The dashboard primarily uses the prepared analytical layer of the
project.

The main Gold tables are:

```text
gold.fact_environment
gold.dim_city
gold.dim_date
gold.dim_time
```

Additional analytical outputs are used where appropriate:

```text
city_pollution_profile
segment_environment_effect
relationship_summary
hotspot_analysis
```

The dashboard therefore does not directly depend on the external
OpenWeather API.

The data follows:

```text
OpenWeather API
      ↓
Python Pipeline
      ↓
SQL Server
      ↓
Bronze
      ↓
Silver
      ↓
Gold
      ↓
Analytical Outputs
      ↓
Power BI
```

---

# 4. Data Model Used by Power BI

The main analytical model is based on the Gold dimensional model.

![Data Model](data_mart.png)

### Relationships

```text
dim_city.city_key
        ↓
fact_environment.city_key

dim_date.date_key
        ↓
fact_environment.date_key

dim_time.time_key
        ↓
fact_environment.time_key
```

The fact table provides the environmental measurements, while the
dimensions provide city, date, and time context.

---

# 5. Dashboard Design Principles

The dashboard follows a simple professional design philosophy.

### Simplicity

Each page contains a limited number of visuals to avoid visual
clutter.

### Business Focus

Visuals are selected to answer business questions rather than simply
displaying available data.

### Consistency

The dashboard uses consistent:

- Typography
- KPI formatting
- Number formatting
- Spacing
- Alignment
- Visual hierarchy
- Color usage

### Interactivity

Users can filter and explore the environmental data rather than
viewing only static results.

---

# 6. Page 1 — Climate Impact Overview

![Dashboard Page 1](../powerbi/images/01_climate_impact_overview.png)

---

## Purpose

The first page provides a high-level summary of the environmental
conditions represented in the dataset.

It is intended to answer:

> **What is the overall environmental situation across the monitored
> cities?**

---

## Key Information

The page focuses on high-level KPIs such as:

```text
Average Temperature
Average AQI
Average PM2.5
Observation Count
```

It also provides high-level trend and city comparisons.

---

## Main Analytical Questions

- What is the overall average temperature?
- What is the overall air-quality condition?
- What is the average PM2.5 level?
- How many observations are available?
- How do environmental conditions vary across cities?

---

## Intended User

This page is designed as the dashboard landing page for:

- Managers
- Analysts
- Environmental monitoring teams
- Decision-makers

It provides a quick overview before users move to more detailed pages.

---



# 7. Page 2 — Weather & Temperature

![Dashboard Page 2](../powerbi/images/02_weather_&_temperature.png)

---

## Purpose

This page focuses specifically on weather conditions and temperature
patterns.

It answers:

> **How do weather conditions vary across cities and time?**

---

## Main Metrics

Examples include:

```text
Average Temperature
Minimum Temperature
Maximum Temperature
Average Humidity
Average Wind Speed
```

---

## Main Analysis Areas

### Temperature Trend

Shows how temperature changes over the available observation period.

### City Comparison

Compares temperature conditions across monitored cities.

### Humidity

Shows differences in humidity between locations.

### Wind

Provides insight into wind-speed patterns.

### Time-of-Day Analysis

Uses the time dimension to analyze environmental conditions across:

```text
Night
Morning
Afternoon
Evening
```

---

## Main Analytical Questions

- Which cities have the highest temperatures?
- Which cities have the lowest temperatures?
- How does temperature change over time?
- How does humidity vary between cities?
- Are there noticeable differences between time periods?

---

# 8. Page 3 — Air Quality & Pollution

![Dashboard Page 3](../powerbi/images/03_air_quality_&_pollution.png)

---

## Purpose

This page focuses on air-quality conditions and pollution levels.

It answers:

> **Where and when are pollution levels highest?**

---

## Main Metrics

```text
Average AQI
Average PM2.5
Average PM10
Maximum PM2.5
```

---

## Main Analysis Areas

### AQI

Provides a high-level view of air-quality conditions.

### PM2.5

Analyzes fine particulate pollution across cities and time.

### PM10

Provides additional particulate pollution context.

### Pollution Trend

Shows how PM2.5 or related pollution measures change over time.

### City Comparison

Identifies cities with comparatively high pollution levels.

### AQI Category

Uses the business-friendly:

```text
aqi_category
```

field to classify air-quality conditions.

---

## Main Analytical Questions

- Which cities have the highest PM2.5?
- Which cities have the highest PM10?
- How does pollution change over time?
- How are cities distributed across AQI categories?
- Which locations require closer attention?

---

# 9. Page 4 — City Comparison

![Dashboard Page 4](../powerbi/images/04_city_comparison.png)

---

## Purpose

This page provides a side-by-side comparison of environmental
conditions across monitored cities.

It answers:

> **How do cities differ in their environmental performance?**

---

## Comparison Areas

Cities can be compared using:

```text
Temperature
AQI
PM2.5
PM10
Humidity
Wind Speed
```

---

## Main Analytical Questions

- Which city has the highest average temperature?
- Which city has the highest average PM2.5?
- Which city has the highest AQI?
- Which cities have relatively better or worse environmental
  conditions?
- How different are environmental conditions between cities?

---

## Business Use

The page supports location-level comparison and helps identify cities
that may require additional environmental monitoring.

---

# 10. Page 5 — Environmental Relationships & Patterns

![Dashboard Page 5](../powerbi/images/05_environmental_relationships_&_patterns.png)

---

## Purpose

This page investigates relationships between PM2.5 and environmental
variables.

It answers:

> **How are environmental conditions associated with PM2.5 levels?**

---

## Environmental Correlation Analysis

The analysis includes:

```text
Temperature
Pressure
Humidity
Wind Speed
Rainfall
```

The observed correlations with PM2.5 are:

| Environmental Variable | Correlation with PM2.5 |
|---|---:|
| Temperature | +0.612 |
| Pressure | -0.598 |
| Humidity | -0.217 |
| Wind Speed | -0.143 |
| Rainfall | +0.024 |

---

## Interpretation

### Temperature

Observed correlation:

```text
+0.612
```

This indicates a relatively strong positive linear association with
PM2.5 in the analyzed dataset.

### Pressure

Observed correlation:

```text
-0.598
```

This indicates a relatively strong negative linear association with
PM2.5.

### Humidity

Observed correlation:

```text
-0.217
```

This represents a relatively weak negative association.

### Wind Speed

Observed correlation:

```text
-0.143
```

This represents a weak negative association.

### Rainfall

Observed correlation:

```text
+0.024
```

This indicates almost no linear association in the analyzed data.

> **Important:** These are correlations and should not be interpreted
> as proof of causation.

---

## Time-Based Patterns

The page also examines pollution and environmental conditions across
different time periods.

Examples:

```text
Night
Morning
Afternoon
Evening
```

---

# 11. Page 6 — Pollution Hotspots & Risk

![Dashboard Page 6](../powerbi/images/06_pollution_hotspots_&_risk.png)

---

## Purpose

The final page focuses on identifying cities with comparatively high
pollution burdens.

It answers:

> **Which cities should receive the greatest attention based on the
> pollution indicators analyzed?**

---

## Main Metrics

Examples include:

```text
Highest Average PM2.5
Highest Maximum PM2.5
Top Pollution Hotspot
```

---

## Hotspot Analysis

The hotspot analysis combines multiple pollution indicators rather than
relying on a single measurement.

The analytical output includes:

```text
Average PM2.5
Median PM2.5
Maximum PM2.5
Average PM10
Observation Count
PM2.5 Average Rank
PM2.5 Maximum Rank
PM10 Average Rank
Hotspot Score
```

---

## Hotspot Score

The hotspot score is used to rank cities according to their relative
pollution burden based on multiple pollution indicators.

This allows the dashboard to identify high-priority cities more
systematically than using average PM2.5 alone.

---

## Main Analytical Questions

- Which city has the highest average PM2.5?
- Which city records the highest maximum PM2.5?
- Which cities rank highest across multiple pollution indicators?
- Which cities represent the strongest pollution hotspots?

---

# 12. DAX Measures

The Power BI dashboard uses DAX measures to calculate business
metrics dynamically.

Typical measures include:

```text
Average Temperature
Average AQI
Average PM2.5
Average PM10
Minimum Temperature
Maximum Temperature
Average Humidity
Average Wind Speed
Observation Count
```

Measures are preferred for dynamic calculations because they respond to
filters and slicers applied by the dashboard user.

---

# 13. Previous-Day Measures

Where required, previous-day comparisons are calculated using the
Power BI date dimension.

Conceptually:

```text
Current Day
     │
     ▼
Current Metric
     │
     ▼
Previous Day Metric
     │
     ▼
Difference / Change
```

These calculations allow KPI cards to communicate changes rather than
only displaying absolute values.

---

# 14. KPI Cards

KPI cards are used to communicate important metrics quickly.

Examples:

```text
Average Temperature
Average AQI
Average PM2.5
Maximum PM2.5
Observation Count
```

Where appropriate, cards can also display:

```text
Current Value
Previous-Day Value
Absolute Change
Percentage Change
```

This provides both the current state and contextual movement.

---

# 15. Conditional Formatting

Conditional formatting is used to improve interpretation without adding
additional charts.

For example, the Environmental Correlation table uses different
colors to distinguish positive and negative correlations.

Conceptually:

```text
Strong Negative
       ↓
     RED

Weak / Neutral
       ↓
    NEUTRAL

Strong Positive
       ↓
    GREEN
```

This allows users to identify important relationships quickly.

---

# 16. Environmental Correlation Table

The correlation table provides a compact summary of the relationship
between environmental variables and PM2.5.

Displayed fields:

```text
Environmental Variable
Correlation with PM2.5
```

Example:

```text
Temperature        +0.612
Pressure           -0.598
Humidity           -0.217
Wind Speed         -0.143
Rainfall           +0.024
```

The table is intentionally used instead of adding another complex
visual because the primary purpose is to communicate the correlation
values clearly.

---

# 17. Filters and Interactivity

The dashboard can be explored using available filters and slicers.

Typical analytical dimensions include:

```text
City
Date
Time
Time Period
Region
AQI Category
```

Filters allow users to move from an overall view to a specific
location or time period.

---

# 18. Units and Number Formatting

The dashboard uses units consistent with the Gold-layer data model.

Examples:

| Metric | Unit |
|---|---|
| Temperature | °C |
| Humidity | % |
| Pressure | hPa |
| Visibility | m |
| Wind Speed | m/s |
| Wind Direction | degrees |
| Rainfall | mm |
| PM2.5 | concentration unit from source |
| PM10 | concentration unit from source |
| AQI | OpenWeather AQI scale |

Technical field names remain in the data model, while dashboard
labels use business-friendly names.

Example:

```text
temperature_c
        ↓
Temperature (°C)
```

```text
humidity_pct
        ↓
Humidity (%)
```

---

# 19. Dashboard Navigation

The recommended analytical flow is:

```text
Overview
   ↓
Weather
   ↓
Air Quality
   ↓
City Comparison
   ↓
Environmental Relationships
   ↓
Pollution Hotspots
```

This moves the user from:

```text
What is happening?
        ↓
What are the weather conditions?
        ↓
What is the pollution situation?
        ↓
How do cities compare?
        ↓
What environmental relationships exist?
        ↓
Where are the major hotspots?
```

---

# 20. Dashboard Design Philosophy

The dashboard intentionally avoids excessive visual density.

Each page focuses on a limited number of high-value visuals.

The design prioritizes:

```text
Clarity
     ↓
Hierarchy
     ↓
Comparison
     ↓
Trend
     ↓
Insight
```

The dashboard is designed to support decision-making rather than
simply displaying every available metric.

---

# 21. Business Questions Answered by the Dashboard

| Business Question | Dashboard Page |
|---|---|
| What is the overall environmental situation? | Climate Impact Overview |
| How do weather conditions vary? | Weather & Temperature |
| Where are pollution levels highest? | Air Quality & Pollution |
| How do cities compare? | City Comparison |
| Which variables are associated with PM2.5? | Environmental Relationships & Patterns |
| Which cities are pollution hotspots? | Pollution Hotspots & Risk |

---

# 22. Key Dashboard Insights

The dashboard communicates several major findings from the analytical
work.

### Temperature and PM2.5

Temperature showed the strongest positive correlation with PM2.5 among
the analyzed environmental variables:

```text
+0.612
```

### Pressure and PM2.5

Pressure showed a strong negative correlation:

```text
-0.598
```

### Humidity

Humidity showed a weaker negative relationship:

```text
-0.217
```

### Wind Speed

Wind speed showed a weak negative relationship:

```text
-0.143
```

### Rainfall

Rainfall showed almost no linear relationship:

```text
+0.024
```

These relationships describe the observed dataset and should not be
interpreted as causal effects.

---

# 23. Dashboard-to-Data Lineage

The dashboard follows this lineage:

```text
OpenWeather API
       ↓
Python Ingestion
       ↓
Bronze
       ↓
Silver
       ↓
Gold
       ↓
Analytical Processing
       ↓
Analytical Outputs
       ↓
Power BI Data Model
       ↓
DAX Measures
       ↓
Dashboard Visuals
       ↓
Business Insights
```

---

# 24. Dashboard Maintenance

When the underlying data is refreshed:

```text
New API Data
      ↓
Pipeline Processing
      ↓
Gold Layer Updated
      ↓
Power BI Dataset Refresh
      ↓
Dashboard Updated
```

The dashboard should be refreshed after the underlying analytical data
has been successfully processed and validated.

---

# 25. Limitations

The dashboard should be interpreted within the limitations of the
underlying dataset.

### Observation Period

The available historical period determines how confidently temporal
patterns can be interpreted.

### Correlation

Correlation does not establish causation.

### API Data

The analysis depends on the measurements and definitions provided by
the OpenWeather API.

### Geographic Coverage

The conclusions apply to the monitored cities and should not
automatically be generalized to locations outside the dataset.

### Forecasting

Forecasting is not included as a core dashboard feature at the current
stage.

A forecasting component can be considered after sufficient historical
data has been collected.

---

# 26. Dashboard Outcome

The Power BI dashboard converts the project's analytical results into
a business-friendly reporting layer.

It allows users to move from:

```text
Overall Environmental Monitoring
             ↓
Weather Analysis
             ↓
Air Quality Analysis
             ↓
City Comparison
             ↓
Environmental Relationships
             ↓
Pollution Hotspot Identification
```

The final dashboard provides a single interactive interface for
understanding environmental conditions, comparing cities, and
identifying areas that may require greater monitoring attention.

---

# 27. Summary

The six-page Power BI dashboard represents the final visualization
layer of the Climate Impact Analytics project.

It combines:

```text
Gold Data
   +
Analytical Outputs
   +
DAX Measures
   +
Interactive Visualizations
   +
Business Interpretation
```

to transform environmental observations into actionable analytical
insights.

The dashboard is intentionally designed to remain simple, professional,
and focused on the highest-value business questions.
