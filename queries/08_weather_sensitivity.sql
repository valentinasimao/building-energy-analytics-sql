-- Q8. How sensitive is each building to the weather? Extra kWh per cooling degree-day (hot days)
--     and per heating degree-day (cold days), weekdays only, excluding the August holiday shutdown.
-- Techniques: statistical aggregates REGR_SLOPE() / REGR_R2() / CORR() in SQL, CASE-filtered regressions
SELECT
    name,
    ROUND(CAST(REGR_SLOPE(CASE WHEN cooling_degree_days > 0 THEN kwh END,
                          CASE WHEN cooling_degree_days > 0 THEN cooling_degree_days END) AS NUMERIC), 0)
                                                                    AS kwh_per_cooling_degree_day,
    ROUND(CAST(REGR_R2(CASE WHEN cooling_degree_days > 0 THEN kwh END,
                       CASE WHEN cooling_degree_days > 0 THEN cooling_degree_days END) AS NUMERIC), 2)
                                                                    AS r2_cooling,
    ROUND(CAST(REGR_SLOPE(CASE WHEN heating_degree_days > 0 THEN kwh END,
                          CASE WHEN heating_degree_days > 0 THEN heating_degree_days END) AS NUMERIC), 0)
                                                                    AS kwh_per_heating_degree_day,
    ROUND(CAST(REGR_R2(CASE WHEN heating_degree_days > 0 THEN kwh END,
                       CASE WHEN heating_degree_days > 0 THEN heating_degree_days END) AS NUMERIC), 2)
                                                                    AS r2_heating
FROM v_daily
WHERE day_type = 'Weekday'
  AND EXTRACT(MONTH FROM reading_date) <> 8
GROUP BY name
ORDER BY kwh_per_cooling_degree_day DESC;
