# Business Insights

## 1. Business Problem

Cities experience different weather and air-quality conditions, but it is
difficult to identify:

- Which cities have the highest pollution burden.
- Where extreme PM2.5 pollution occurs.
- How pollution changes over time and during the day.
- Which environmental factors have the strongest relationship with PM2.5.
- Which cities should receive higher monitoring priority.

The purpose of this project is to turn raw environmental observations into
actionable insights for **city-level environmental monitoring and
decision-making**.

---

## 2. Key Findings from Power BI

### 2.1 Overall Environmental Situation

The dashboard currently covers:

- **20 monitored cities**
- Approximately **15K observations**
- Average Temperature: **28.90 °C**
- Average OpenWeather AQI: **1.97**
- Average PM2.5: **17.49 µg/m³**
- Average PM10: **33.71 µg/m³**

The overall averages look reasonable, but city-level analysis shows large
differences between locations.

---

### 2.2 High-Pollution Cities

The Power BI analysis identifies several cities with substantially higher
PM2.5 levels.

The major high-pollution locations include:

- **Dubai**
- **Patna**
- **Kolkata**
- **Lucknow**
- **Delhi**

Dubai has the highest average PM2.5 in the dashboard at approximately
**71.10 µg/m³**.

### Business Finding

Pollution is not evenly distributed across monitored cities. A single
overall average can hide cities experiencing much higher pollution.

### Recommended Action

Prioritize high-pollution cities for:

- More frequent monitoring.
- Deeper investigation of pollution sources.
- Local environmental assessment.
- Regular tracking of PM2.5 and PM10 trends.

---

## 3. Pollution Hotspots and Extreme Pollution

The **Pollution Hotspots & Risk** page identifies **Dubai as the #1
pollution hotspot** based on the project's hotspot score.

Another important finding is that **Kolkata has the highest maximum PM2.5**,
at approximately **111.07 µg/m³**.

This shows that average pollution and peak pollution can tell different
stories.

### Business Problem

A city may have a lower average pollution level but still experience
dangerous short-term pollution peaks.

### Recommended Action

Monitor both:

- Average PM2.5
- Maximum PM2.5

High-peak cities such as Kolkata should be investigated for the causes and
timing of pollution spikes.

---

## 4. PM10 Pollution

Dubai also stands out in the hotspot analysis with a very high average PM10
value of approximately **252.68 µg/m³** in the hotspot detail table.

### Business Finding

Dubai's high ranking is not based only on PM2.5. It also shows a high
particulate pollution burden across multiple indicators.

### Recommended Action

For hotspot cities, monitor PM2.5 and PM10 together instead of relying on
one pollution metric.

---

## 5. Environmental Relationships with PM2.5

The Environmental Relationships & Patterns page shows:

| Environmental Variable | Correlation with PM2.5 |
|---|---:|
| Temperature | **+0.61** |
| Pressure | **-0.60** |
| Humidity | **-0.22** |
| Wind Speed | **-0.14** |
| Rainfall | **+0.02** |

### Business Finding

Temperature and atmospheric pressure have the strongest observed
relationships with PM2.5 in this dataset.

Humidity and wind speed show weaker relationships, while rainfall has almost
no linear relationship with PM2.5.

### Recommended Action

When investigating high PM2.5 periods, environmental monitoring should
consider **temperature and pressure together with pollution levels**.

> These are correlations, not proof of cause and effect.

---

## 6. Pollution Changes Over Time

The dashboard shows that PM2.5 changes across the observed days.

A noticeable PM2.5 increase occurs around **Day 25**, followed by a gradual
decline toward Day 30.

### Business Problem

Looking only at overall averages can hide short-term pollution events.

### Recommended Action

Maintain time-based monitoring and investigate sudden increases in PM2.5
to identify whether they are associated with specific environmental or
local conditions.

---

## 7. Pollution by Time of Day

The dashboard compares AQI and PM2.5 across Morning, Afternoon and Evening.

The displayed analysis shows relatively higher AQI and PM2.5 during the
**afternoon**.

### Business Problem

Pollution exposure can vary throughout the day, so a daily average may not
represent the periods with the highest pollution.

### Recommended Action

Use time-of-day analysis to identify higher-pollution periods and support
more targeted monitoring or public-awareness activities.

---

## 8. Weather Conditions

The Weather & Temperature page shows:

- Average Temperature: **28.90 °C**
- Maximum Temperature: **44.01 °C**
- Minimum Temperature: **16.37 °C**
- Average Humidity: **72.15%**
- Average Wind Speed: **4.37 m/s**

Temperature also varies considerably between cities.

### Business Finding

Different cities operate under very different environmental conditions,
which can affect how pollution patterns should be interpreted.

### Recommended Action

Compare pollution metrics with local weather conditions instead of using
the same environmental interpretation for every city.

---

## 9. Business Priorities

Based on the Power BI findings, the recommended priority is:

### Priority 1 — Dubai

- #1 pollution hotspot.
- Highest average PM2.5.
- Very high particulate pollution across the hotspot metrics.

**Action:** Highest priority for further pollution investigation and
monitoring.

### Priority 2 — Kolkata

- Highest maximum PM2.5.
- High average PM2.5.
- Important location for investigating pollution peaks.

**Action:** Investigate the causes and timing of extreme PM2.5 events.

### Priority 3 — Patna and Delhi

- Both appear among the higher-pollution cities.

**Action:** Continue close monitoring and compare their pollution patterns
with weather conditions.

### Priority 4 — Lucknow and Other Monitored Cities

- Continue monitoring to identify whether pollution levels increase over
  time.

**Action:** Track trends and move cities into higher-priority groups when
  pollution indicators deteriorate.

---

## 10. Final Business Takeaway

The Power BI analysis shows that the main environmental issue is **large
variation in pollution between cities and across time**.

The most important findings are:

1. **Dubai is the #1 pollution hotspot.**
2. **Dubai has the highest average PM2.5** at approximately 71.10 µg/m³.
3. **Kolkata has the highest maximum PM2.5** at approximately 111.07 µg/m³.
4. **Patna, Delhi and Lucknow** also show relatively high pollution levels.
5. **Temperature (+0.61) and pressure (-0.60)** have the strongest observed
   relationships with PM2.5.
6. PM2.5 shows a visible spike around **Day 25**.
7. The displayed time-of-day analysis shows relatively higher AQI and PM2.5
   during the **afternoon**.

### Overall Recommendation

> **Prioritize high-pollution cities, monitor both average and peak pollution,
> investigate short-term pollution spikes, and combine air-quality data with
> weather conditions for better environmental decision-making.**
