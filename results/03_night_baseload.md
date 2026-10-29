# Q3. Which buildings waste energy at night? Compare night-time (00–05h) load with working-hours load.

Query: [`queries/03_night_baseload.sql`](../queries/03_night_baseload.sql) · **6 rows** (first 6 shown)

| name | building_type | avg_night_kw | avg_workday_kw | night_vs_day_pct | assessment |
|---|---|---|---|---|---|
| Residència Nord | Residence | 118.2 | 119.2 | 99.1 | Expected (people live there) |
| Data Centre | Data centre | 210.1 | 217 | 96.8 | Expected (24/7 load) |
| Lab B | Laboratory | 214.3 | 416.3 | 51.5 | Investigate night load |
| Poliesportiu | Sports | 45.6 | 134.9 | 33.8 | OK |
| Torre A | Office | 94 | 455.7 | 20.6 | OK |
| Biblioteca | Library | 52.5 | 269.9 | 19.5 | OK |
