-- Q5. Did Lab B's January 2026 retrofit really save energy?
--     Difference-in-differences: compare Lab B's Feb–Sep change (2026 vs 2025) with the change in the other buildings.
-- Techniques: CTE pivot with conditional sums, control group, DiD estimate
WITH period_totals AS (
    SELECT
        name,
        CASE WHEN name = 'Lab B' THEN 'Retrofitted' ELSE 'Control' END AS grp,
        SUM(CASE WHEN EXTRACT(YEAR FROM reading_date) = 2025 THEN kwh END) AS kwh_2025,
        SUM(CASE WHEN EXTRACT(YEAR FROM reading_date) = 2026 THEN kwh END) AS kwh_2026
    FROM v_daily
    WHERE EXTRACT(MONTH FROM reading_date) BETWEEN 2 AND 9
      AND building_type <> 'Data centre'
    GROUP BY name
),
by_group AS (
    SELECT grp,
           100.0 * (SUM(kwh_2026) - SUM(kwh_2025)) / SUM(kwh_2025) AS change_pct
    FROM period_totals
    GROUP BY grp
)
SELECT
    ROUND(MAX(CASE WHEN grp = 'Retrofitted' THEN change_pct END), 1)   AS lab_b_change_pct,
    ROUND(MAX(CASE WHEN grp = 'Control'     THEN change_pct END), 1)   AS control_change_pct,
    ROUND(MAX(CASE WHEN grp = 'Retrofitted' THEN change_pct END)
        - MAX(CASE WHEN grp = 'Control'     THEN change_pct END), 1)   AS retrofit_effect_pct,
    (SELECT ROUND(kwh_2025 - kwh_2026, 0) FROM period_totals WHERE name = 'Lab B') AS lab_b_kwh_saved
FROM by_group;
