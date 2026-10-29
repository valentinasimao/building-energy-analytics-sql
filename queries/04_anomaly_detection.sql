-- Q4. Detect abnormal days: daily consumption more than 3 standard deviations above the building's
--     recent normal for the same type of day (weekday vs weekend) AND at least 25% above it.
--     Each flag gets a first-pass explanation so the facilities team only chases the real leaks.
-- Techniques: rolling AVG/STDDEV window frames that exclude the current row, z-score, CASE triage
WITH stats AS (
    SELECT
        name, reading_date, day_type, kwh, cooling_degree_days,
        AVG(kwh)                 OVER w AS rolling_avg,
        STDDEV_SAMP(kwh)         OVER w AS rolling_std,
        COUNT(*)                 OVER w AS days_in_window,
        AVG(cooling_degree_days) OVER w AS rolling_cdd,
        MIN(reading_date)        OVER w AS window_start
    FROM v_daily
    WINDOW w AS (PARTITION BY building_id, day_type ORDER BY reading_date
                 ROWS BETWEEN 20 PRECEDING AND 1 PRECEDING)
)
SELECT
    name, reading_date, day_type,
    ROUND(kwh, 0)                                  AS kwh,
    ROUND(rolling_avg, 0)                          AS expected_kwh,
    ROUND((kwh - rolling_avg) / rolling_std, 1)    AS z_score,
    ROUND(kwh - rolling_avg, 0)                    AS excess_kwh,
    CASE
        WHEN EXTRACT(MONTH FROM window_start) = 8
         AND EXTRACT(MONTH FROM reading_date) = 9     THEN 'Back from August shutdown - expected'
        WHEN cooling_degree_days >= rolling_cdd + 1  THEN 'Hotter than recent days - check cooling schedule'
        ELSE 'Investigate - no weather or calendar explanation'
    END                                            AS triage
FROM stats
WHERE days_in_window >= 14                    -- need enough history
  AND rolling_std > 0
  AND (kwh - rolling_avg) / rolling_std > 3
  AND kwh > 1.25 * rolling_avg                  -- and at least 25% above normal (ignore tiny blips)
ORDER BY reading_date, name;
