-- Hourly readings enriched with tariff period, price, cost, emissions and temperature
CREATE VIEW v_hourly AS
SELECT
    r.building_id, b.name, b.building_type, b.floor_area_m2,
    r.reading_ts,
    CAST(r.reading_ts AS DATE)                  AS reading_date,
    EXTRACT(HOUR FROM r.reading_ts)             AS hour_of_day,
    CASE WHEN EXTRACT(DOW FROM r.reading_ts) IN (0, 6) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    r.kwh,
    t.temperature_c,
    CASE
        WHEN EXTRACT(DOW FROM r.reading_ts) IN (0, 6)                        THEN 'P3'
        WHEN EXTRACT(HOUR FROM r.reading_ts) IN (10,11,12,13,18,19,20,21)    THEN 'P1'
        WHEN EXTRACT(HOUR FROM r.reading_ts) IN (8,9,14,15,16,17,22,23)      THEN 'P2'
        ELSE 'P3'
    END                                          AS tariff_period
FROM meter_readings r
JOIN buildings b                ON b.building_id = r.building_id
LEFT JOIN outdoor_temperature t ON t.reading_ts  = r.reading_ts;

-- One row per building per day
CREATE VIEW v_daily AS
SELECT
    building_id, name, building_type, floor_area_m2, reading_date, day_type,
    SUM(kwh)                          AS kwh,
    AVG(temperature_c)                AS avg_temp_c,
    GREATEST(AVG(temperature_c) - 21, 0) AS cooling_degree_days,
    GREATEST(15 - AVG(temperature_c), 0) AS heating_degree_days
FROM v_hourly
GROUP BY building_id, name, building_type, floor_area_m2, reading_date, day_type;
