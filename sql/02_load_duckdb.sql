COPY buildings           FROM 'data/buildings.csv'           (HEADER);
COPY meter_readings      FROM 'data/meter_readings.csv'      (HEADER);
COPY outdoor_temperature FROM 'data/outdoor_temperature.csv' (HEADER);
COPY tariff_prices       FROM 'data/tariff_prices.csv'       (HEADER);
COPY emission_factors    FROM 'data/emission_factors.csv'    (HEADER);
