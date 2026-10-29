# Q4. Detect abnormal days: daily consumption more than 3 standard deviations above the building's

Query: [`queries/04_anomaly_detection.sql`](../queries/04_anomaly_detection.sql) · **20 rows** (first 15 shown)

| name | reading_date | day_type | kwh | expected_kwh | z_score | excess_kwh | triage |
|---|---|---|---|---|---|---|---|
| Torre A | 2025-03-08 | Weekend | 4378 | 2,867 | 8.3 | 1,511 | Investigate - no weather or calendar explanation |
| Torre A | 2025-03-09 | Weekend | 4541 | 2,946 | 4.1 | 1,594 | Investigate - no weather or calendar explanation |
| Torre A | 2025-03-10 | Weekday | 9411 | 7,216 | 11.6 | 2,195 | Investigate - no weather or calendar explanation |
| Lab B | 2025-06-07 | Weekend | 9781 | 5,183 | 39.7 | 4,598 | Investigate - no weather or calendar explanation |
| Torre A | 2025-06-14 | Weekend | 2253 | 1,648 | 3.2 | 606 | Hotter than recent days - check cooling schedule |
| Torre A | 2025-06-15 | Weekend | 2375 | 1,673 | 3.1 | 703 | Hotter than recent days - check cooling schedule |
| Torre A | 2025-06-21 | Weekend | 2550 | 1,700 | 3.1 | 849 | Hotter than recent days - check cooling schedule |
| Torre A | 2025-09-01 | Weekday | 6488 | 4,470 | 11.5 | 2,019 | Back from August shutdown - expected |
| Torre A | 2025-09-02 | Weekday | 6664 | 4,562 | 4.3 | 2,103 | Back from August shutdown - expected |
| Residència Nord | 2025-11-20 | Weekday | 5612 | 3,517 | 15.9 | 2,095 | Investigate - no weather or calendar explanation |
| Poliesportiu | 2026-02-14 | Weekend | 5959 | 2,990 | 25.8 | 2,969 | Investigate - no weather or calendar explanation |
| Poliesportiu | 2026-02-15 | Weekend | 5896 | 3,148 | 4.1 | 2,748 | Investigate - no weather or calendar explanation |
| Torre A | 2026-06-13 | Weekend | 2265 | 1,628 | 4.1 | 636 | Hotter than recent days - check cooling schedule |
| Torre A | 2026-06-20 | Weekend | 2482 | 1,686 | 3.2 | 796 | Hotter than recent days - check cooling schedule |
| Torre A | 2026-07-04 | Weekend | 4965 | 1,877 | 7.6 | 3,087 | Hotter than recent days - check cooling schedule |
