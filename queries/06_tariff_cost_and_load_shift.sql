-- Q6. What does each building pay per tariff period, and how much would shifting 10% of peak (P1) use
--     to off-peak (P3) save? (Last 12 months.)
-- Techniques: join to price table, SUM() OVER share, what-if scenario
WITH last_12m AS (
    SELECT h.name, h.tariff_period, SUM(h.kwh) AS kwh, SUM(h.kwh * p.price_eur_kwh) AS cost_eur
    FROM v_hourly h
    JOIN tariff_prices p ON p.period = h.tariff_period
    WHERE h.reading_ts >= TIMESTAMP '2025-10-01' AND h.reading_ts < TIMESTAMP '2026-10-01'
    GROUP BY h.name, h.tariff_period
),
period_pivot AS (
    SELECT name,
           SUM(cost_eur)                                                  AS total_cost_eur,
           SUM(CASE WHEN tariff_period = 'P1' THEN kwh ELSE 0 END)        AS p1_kwh,
           SUM(CASE WHEN tariff_period = 'P1' THEN cost_eur ELSE 0 END)   AS p1_cost_eur
    FROM last_12m
    GROUP BY name
)
SELECT
    name,
    ROUND(total_cost_eur, 0)                                              AS cost_last_12m_eur,
    ROUND(100 * p1_cost_eur / total_cost_eur, 1)                          AS peak_share_of_cost_pct,
    ROUND(0.10 * p1_kwh * ((SELECT price_eur_kwh FROM tariff_prices WHERE period = 'P1')
                         - (SELECT price_eur_kwh FROM tariff_prices WHERE period = 'P3')), 0) AS saving_if_10pct_shifted_eur,
    ROUND(100 * total_cost_eur / SUM(total_cost_eur) OVER (), 1)          AS share_of_campus_cost_pct
FROM period_pivot
ORDER BY cost_last_12m_eur DESC;
