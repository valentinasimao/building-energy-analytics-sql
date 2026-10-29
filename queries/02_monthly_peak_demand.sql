-- Q2. When does each building hit its peak demand each month (the hour that drives capacity charges)?
-- Techniques: ROW_NUMBER() to pick the top row per group
WITH ranked AS (
    SELECT name, reading_ts, kwh, temperature_c,
           ROW_NUMBER() OVER (PARTITION BY building_id, DATE_TRUNC('month', reading_ts)
                              ORDER BY kwh DESC) AS rn
    FROM v_hourly
)
SELECT name,
       CAST(DATE_TRUNC('month', reading_ts) AS DATE) AS month,
       reading_ts                                     AS peak_hour,
       kwh                                            AS peak_kw,
       temperature_c
FROM ranked
WHERE rn = 1
ORDER BY name, month;
