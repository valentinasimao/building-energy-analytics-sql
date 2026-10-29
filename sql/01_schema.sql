-- =====================================================================
-- Campus Building Energy Analytics — schema
-- Portable SQL: tested on PostgreSQL 16 and DuckDB
-- =====================================================================
CREATE TABLE buildings (
    building_id    INTEGER      PRIMARY KEY,
    name           VARCHAR(40)  NOT NULL,
    building_type  VARCHAR(20)  NOT NULL,
    floor_area_m2  INTEGER      NOT NULL,
    retrofit_date  DATE                         -- date an energy-efficiency retrofit went live
);

CREATE TABLE meter_readings (                   -- hourly electricity use per building
    building_id  INTEGER       NOT NULL REFERENCES buildings(building_id),
    reading_ts   TIMESTAMP     NOT NULL,        -- start of the hour (local time)
    kwh          DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (building_id, reading_ts)
);

CREATE TABLE outdoor_temperature (
    reading_ts     TIMESTAMP     PRIMARY KEY,
    temperature_c  DECIMAL(4,1)  NOT NULL
);

CREATE TABLE tariff_prices (                    -- Spanish 2.0TD-style periods, illustrative prices
    period         CHAR(2)       PRIMARY KEY,   -- P1 peak, P2 shoulder, P3 off-peak
    price_eur_kwh  DECIMAL(6,4)  NOT NULL
);

CREATE TABLE emission_factors (                 -- grid emission factor, illustrative values
    year             INTEGER       PRIMARY KEY,
    kgco2e_per_kwh   DECIMAL(6,4)  NOT NULL
);
