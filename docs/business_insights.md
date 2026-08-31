# Business Insights

## 1. Business Problem

The project helps environmental monitoring teams understand how weather and
air-quality conditions vary across locations and identify areas requiring
greater monitoring attention.

The analysis addresses:

- Cities with the highest pollution levels.
- Pollution hotspots and extreme PM2.5 events.
- PM2.5 and PM10 variation across cities.
- Relationships between weather conditions and PM2.5.
- Differences between pollution segments.
- Air-quality variation by time of day.
- Cities requiring higher monitoring priority.

---

## 2. Key Findings from Power BI

### 2.1 Overall Environmental Situation

The dashboard covers:

- **20 monitored cities**
- Approximately **15K observations**
- Average Temperature: **28.90 °C**
- Average OpenWeather AQI: **1.97**
- Average PM2.5: **17.49 µg/m³**
- Average PM10: **33.71 µg/m³**

City-level analysis shows substantial differences behind these overall
averages.

---

## 3. High-Pollution Cities

The dashboard identifies several cities with relatively high PM2.5 levels:

- **Dubai**
- **Patna**
- **Kolkata**
- **Lucknow**
- **Delhi**

Dubai has the highest average PM2.5 at approximately **71.10 µg/m³**.

### Business Problem

A single overall average can hide cities experiencing much higher
pollution.

### Recommended Action

Prioritize high-pollution cities for more frequent monitoring, pollution
source investigation, local environmental assessment, and regular PM2.5
and PM10 tracking.

---

## 4. Pollution Hotspots and Extreme Pollution

The **Pollution Hotspots & Risk** page identifies **Dubai as the #1
pollution hotspot** based on the project's hotspot score.

**Kolkata** has the highest maximum PM2.5 at approximately **111.07 µg/m³**.

This shows that average pollution and peak pollution provide different
views of environmental risk.

### Business Problem

A city can have a lower average while still experiencing severe short-term
pollution peaks.

### Recommended Action

Monitor both **average PM2.5 and maximum PM2.5**, and investigate the timing
and causes of major pollution spikes.

---

## 5. PM10 Pollution

Dubai also shows a very high average PM10 value of approximately
**252.68 µg/m³** in the hotspot analysis.

### Business Finding

Dubai's pollution burden is visible across multiple particulate indicators,
not only PM2.5.

### Recommended Action

Monitor **PM2.5 and PM10 together** when assessing high-risk locations.

---

## 6. Environmental Relationships with PM2.5

| Environmental Variable | Correlation with PM2.5 |
|---|---:|
| Temperature | **+0.61** |
| Pressure | **-0.60** |
| Humidity | **-0.22** |
| Wind Speed | **-0.14** |
| Rainfall | **+0.02** |

### Business Finding

Temperature and pressure have the strongest observed relationships with
PM2.5 in this dataset. Humidity and wind speed show weaker relationships,
while rainfall has almost no linear relationship.

### Recommended Action

When investigating high-PM2.5 periods, consider **temperature and pressure
alongside pollution measurements**.

> Correlation does not establish cause and effect.

---

## 7. Pollution Trends Over Time

The PM2.5 trend shows a noticeable increase around **Day 25**, followed by a
gradual decline toward Day 30.

### Business Problem

Overall averages can hide short-term pollution events.

### Recommended Action

Maintain time-based monitoring and investigate sudden PM2.5 increases to
identify recurring environmental or local patterns.

---

## 8. Pollution by Time of Day

The dashboard compares AQI and PM2.5 across **Morning, Afternoon and
Evening**.

The displayed analysis shows relatively higher AQI and PM2.5 during the
**afternoon**.

### Business Problem

Daily averages may hide periods with comparatively higher pollution.

### Recommended Action

Use time-of-day analysis to identify higher-pollution periods and support
targeted monitoring and public-awareness activities.

---

## 9. Pollution Segmentation

The advanced analysis includes pollution segmentation to compare cities or
observations across **higher-, moderate-, and lower-pollution groups**.

### Business Problem

Treating every monitored city in the same way can lead to inefficient use
of monitoring resources.

### Recommended Action

Use pollution segments to prioritize high-pollution groups, maintain
regular monitoring for moderate-pollution groups, and continue baseline
monitoring for lower-pollution groups.

> The dashboard screenshots do not provide enough segment-level values to
> state a specific numerical difference between the groups.

---

## 10. Weather Conditions

The Weather & Temperature page shows:

- Average Temperature: **28.90 °C**
- Maximum Temperature: **44.01 °C**
- Minimum Temperature: **16.37 °C**
- Average Humidity: **72.15%**
- Average Wind Speed: **4.37 m/s**

### Business Finding

Pollution should be interpreted together with local weather conditions
rather than using the same environmental interpretation for every city.

### Recommended Action

Combine pollution metrics with temperature, pressure, humidity, wind and
other available environmental variables during monitoring and investigation.

---

## 11. Monitoring Priorities

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

**Action:** Continue close monitoring and compare pollution patterns with
weather conditions.

### Priority 4 — Lucknow and Other Monitored Cities

**Action:** Track trends and increase monitoring priority if pollution
indicators deteriorate.

---

## 12. Business Questions Answered

| Business Question | Project Finding |
|---|---|
| Which cities have the highest pollution? | Dubai, Patna, Kolkata, Lucknow and Delhi show relatively high PM2.5 levels. |
| Which cities are the biggest hotspots? | Dubai is identified as the #1 pollution hotspot. |
| How do PM2.5 and PM10 vary across cities? | Large city-level differences are visible; Dubai has the highest average PM2.5 and very high PM10. |
| How do environmental factors relate to PM2.5? | Temperature (+0.61) and pressure (-0.60) show the strongest observed relationships. |
| How do pollution segments differ? | The project creates higher-, moderate-, and lower-pollution segments for comparison and monitoring prioritization. |
| How does air quality vary by time of day? | The displayed analysis shows relatively higher AQI and PM2.5 during the afternoon. |
| Which cities need greater monitoring attention? | Dubai has the highest priority, followed by Kolkata, Patna, Delhi and Lucknow based on the dashboard findings. |

---

## 13. Final Business Takeaway

The analysis shows that environmental conditions vary substantially across
cities and over time. The most important findings are:

1. **Dubai is the #1 pollution hotspot.**
2. **Dubai has the highest average PM2.5** at approximately **71.10 µg/m³**.
3. **Kolkata has the highest maximum PM2.5** at approximately **111.07 µg/m³**.
4. **Patna, Delhi and Lucknow** also show relatively high pollution levels.
5. **Temperature (+0.61) and pressure (-0.60)** have the strongest observed
   relationships with PM2.5.
6. PM2.5 shows a visible increase around **Day 25** followed by a decline.
7. The displayed time-of-day analysis shows relatively higher AQI and PM2.5
   during the **afternoon**.
8. Pollution segmentation provides a framework for prioritizing monitoring
   resources.

### Overall Recommendation

> **Prioritize high-pollution cities, monitor both average and peak
> pollution, investigate short-term pollution spikes, and combine
> air-quality data with weather conditions for better environmental
> monitoring and decision-making.**
