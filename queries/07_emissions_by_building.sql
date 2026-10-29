-- Q7. What are each building's carbon emissions per year, and which is the most carbon-intensive per m²?
-- Techniques: join to yearly factors, intensity KPI, RANK()
SELECT
    d.name,
    EXTRACT(YEAR FROM d.reading_date)                           AS year,
    COUNT(DISTINCT EXTRACT(MONTH FROM d.reading_date))          AS months_of_data,
    ROUND(SUM(d.kwh) / 1000, 1)                                 AS mwh,
    ROUND(SUM(d.kwh) * MAX(e.kgco2e_per_kwh) / 1000, 1)         AS tonnes_co2e,
    ROUND(SUM(d.kwh) * MAX(e.kgco2e_per_kwh) / MAX(d.floor_area_m2), 1) AS kgco2e_per_m2,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM d.reading_date)
                 ORDER BY SUM(d.kwh) / MAX(d.floor_area_m2) DESC) AS intensity_rank
FROM v_daily d
JOIN emission_factors e ON e.year = EXTRACT(YEAR FROM d.reading_date)
GROUP BY d.name, EXTRACT(YEAR FROM d.reading_date)
ORDER BY year, intensity_rank;
