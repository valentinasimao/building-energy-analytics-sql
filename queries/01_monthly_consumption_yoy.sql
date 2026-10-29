-- Q1. How much electricity does each building use per month, per m², and how does it compare with the same month last year?
-- Techniques: DATE_TRUNC, LAG(…, 12) for year-over-year, energy intensity
WITH monthly AS (
    SELECT building_id, name, floor_area_m2,
           DATE_TRUNC('month', reading_ts) AS month,
           SUM(kwh)                        AS kwh
    FROM v_hourly
    GROUP BY building_id, name, floor_area_m2, DATE_TRUNC('month', reading_ts)
)
SELECT
    name,
    CAST(month AS DATE)                                      AS month,
    ROUND(kwh, 0)                                            AS kwh,
    ROUND(kwh / floor_area_m2, 2)                            AS kwh_per_m2,
    ROUND(LAG(kwh, 12) OVER w, 0)                            AS kwh_same_month_last_year,
    ROUND(100 * (kwh - LAG(kwh, 12) OVER w) / LAG(kwh, 12) OVER w, 1) AS yoy_change_pct
FROM monthly
WINDOW w AS (PARTITION BY building_id ORDER BY month)
ORDER BY name, month;
