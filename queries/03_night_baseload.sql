-- Q3. Which buildings waste energy at night? Compare night-time (00–05h) load with working-hours load.
-- Techniques: conditional averages, ratio KPI, CASE classification
SELECT
    name,
    building_type,
    ROUND(AVG(CASE WHEN hour_of_day BETWEEN 0 AND 4 THEN kwh END), 1)                           AS avg_night_kw,
    ROUND(AVG(CASE WHEN day_type = 'Weekday' AND hour_of_day BETWEEN 9 AND 17 THEN kwh END), 1)  AS avg_workday_kw,
    ROUND(100 * AVG(CASE WHEN hour_of_day BETWEEN 0 AND 4 THEN kwh END)
              / AVG(CASE WHEN day_type = 'Weekday' AND hour_of_day BETWEEN 9 AND 17 THEN kwh END), 1) AS night_vs_day_pct,
    CASE
        WHEN building_type = 'Data centre' THEN 'Expected (24/7 load)'
        WHEN building_type = 'Residence'   THEN 'Expected (people live there)'
        WHEN AVG(CASE WHEN hour_of_day BETWEEN 0 AND 4 THEN kwh END)
           / AVG(CASE WHEN day_type = 'Weekday' AND hour_of_day BETWEEN 9 AND 17 THEN kwh END) > 0.5
             THEN 'Investigate night load'
        ELSE 'OK'
    END AS assessment
FROM v_hourly
GROUP BY name, building_type
ORDER BY night_vs_day_pct DESC;
