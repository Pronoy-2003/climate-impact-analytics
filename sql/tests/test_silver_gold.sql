/*
===============================================================================
Test Script: Silver & Gold Layer Data Quality Tests

Purpose:
    Perform the key validation checks required before using the data
    for analytics and Power BI.

Expected Result:
    Each test should return 0 problematic rows unless otherwise stated.
===============================================================================
*/


/* ============================================================================
   SILVER LAYER TESTS
   ============================================================================ */

-- 1. Check for duplicate observations
-- Expected: 0 rows

SELECT
    observation_id,
    COUNT(*) AS duplicate_count
FROM silver.weather
GROUP BY observation_id
HAVING COUNT(*) > 1;


-- 2. Check for missing critical values
-- Expected: 0 rows

SELECT COUNT(*) AS missing_critical_values
FROM silver.weather
WHERE observation_id IS NULL
   OR city IS NULL
   OR observation_timestamp_utc IS NULL;


-- 3. Check for invalid temperature values
-- Expected: 0 rows

SELECT COUNT(*) AS invalid_temperature
FROM silver.weather
WHERE temperature_c < -90
   OR temperature_c > 70;


-- 4. Check for invalid humidity
-- Expected: 0 rows

SELECT COUNT(*) AS invalid_humidity
FROM silver.weather
WHERE humidity_pct < 0
   OR humidity_pct > 100;


-- 5. Check whether Silver contains data
-- Expected: count > 0

SELECT COUNT(*) AS silver_row_count
FROM silver.weather;


/* ============================================================================
   GOLD LAYER TESTS
   ============================================================================ */

-- 6. Check duplicate observations in the fact table
-- Expected: 0 rows

SELECT
    observation_id,
    COUNT(*) AS duplicate_count
FROM gold.fact_environment
GROUP BY observation_id
HAVING COUNT(*) > 1;


-- 7. Check missing required fact-table keys
-- Expected: 0 rows

SELECT COUNT(*) AS missing_fact_keys
FROM gold.fact_environment
WHERE observation_id IS NULL
   OR ingestion_id IS NULL
   OR city_key IS NULL
   OR date_key IS NULL
   OR time_key IS NULL;


-- 8. Check City foreign-key integrity
-- Every city_key in the fact table should exist in dim_city
-- Expected: 0 rows

SELECT COUNT(*) AS invalid_city_keys
FROM gold.fact_environment f
LEFT JOIN gold.dim_city c
    ON f.city_key = c.city_key
WHERE c.city_key IS NULL;


-- 9. Check Date foreign-key integrity
-- Expected: 0 rows

SELECT COUNT(*) AS invalid_date_keys
FROM gold.fact_environment f
LEFT JOIN gold.dim_date d
    ON f.date_key = d.date_key
WHERE d.date_key IS NULL;


-- 10. Check Time foreign-key integrity
-- Expected: 0 rows

SELECT COUNT(*) AS invalid_time_keys
FROM gold.fact_environment f
LEFT JOIN gold.dim_time t
    ON f.time_key = t.time_key
WHERE t.time_key IS NULL;


-- 11. Check duplicate cities
-- Expected: 0 rows

SELECT
    city_name,
    country_name,
    COUNT(*) AS duplicate_count
FROM gold.dim_city
GROUP BY city_name, country_name
HAVING COUNT(*) > 1;


-- 12. Check Gold vs Silver row counts
-- Counts should be equal if Gold contains one row per Silver observation

SELECT
    (SELECT COUNT(*) FROM silver.weather) AS silver_count,
    (SELECT COUNT(*) FROM gold.fact_environment) AS gold_count;


-- 13. Check daily Gold view
-- Expected: query returns data

SELECT TOP 10 *
FROM gold.vw_environment_daily;


-- 14. Check hourly Gold view
-- Expected: query returns data

SELECT TOP 10 *
FROM gold.vw_environment_hourly;


-- 15. Check invalid air-quality measurements
-- Expected: 0 rows

SELECT COUNT(*) AS invalid_air_quality
FROM gold.fact_environment
WHERE pm2_5 < 0
   OR pm10 < 0
   OR co < 0
   OR no < 0
   OR no2 < 0
   OR o3 < 0
   OR so2 < 0
   OR nh3 < 0;


-- 17. Check required dimensions contain data
-- Expected: all counts > 0

SELECT
    (SELECT COUNT(*) FROM gold.dim_city) AS city_count,
    (SELECT COUNT(*) FROM gold.dim_date) AS date_count,
    (SELECT COUNT(*) FROM gold.dim_time) AS time_count;


/* ============================================================================
   FINAL TEST SUMMARY
   ============================================================================

   Important checks:

   Silver:
       ✓ Duplicate observations
       ✓ Missing critical values
       ✓ Invalid temperature
       ✓ Invalid humidity
       ✓ Row count

   Gold:
       ✓ Duplicate observations
       ✓ Required keys
       ✓ City FK integrity
       ✓ Date FK integrity
       ✓ Time FK integrity
       ✓ Duplicate dimensions
       ✓ Silver vs Gold reconciliation
       ✓ Daily view
       ✓ Hourly view

===============================================================================
*/
