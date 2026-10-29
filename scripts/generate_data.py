"""
Synthetic hourly electricity data for a fictional 6-building university campus in Barcelona
(Jan 2025 – Sep 2026). Reproducible: fixed seed. Run: python scripts/generate_data.py
"""
import csv, math, random
from datetime import datetime, timedelta
from pathlib import Path
random.seed(7)
OUT = Path(__file__).resolve().parent.parent / "data"; OUT.mkdir(exist_ok=True)
def write(n,h,rows):
    with open(OUT/f"{n}.csv","w",newline="",encoding="utf-8") as f:
        w=csv.writer(f); w.writerow(h); w.writerows(rows)

buildings = [  # id, name, type, floor_area_m2, retrofit_date
    (1,"Torre A","Office",8200,None),
    (2,"Lab B","Laboratory",5600,"2026-01-15"),
    (3,"Biblioteca","Library",4300,None),
    (4,"Residència Nord","Residence",6900,None),
    (5,"Poliesportiu","Sports",3800,None),
    (6,"Data Centre","Data centre",900,None),
]
write("buildings",["building_id","name","building_type","floor_area_m2","retrofit_date"],buildings)

start=datetime(2025,1,1); end=datetime(2026,10,1)
temps=[]; readings=[]
# injected anomalies: (building_id, start, hours, multiplier, description)
anoms=[(1,datetime(2025,3,8,0),60,1.9),(3,datetime(2025,8,15,0),72,2.2),(4,datetime(2025,11,20,2),5,4.0),
       (2,datetime(2025,6,6,18),40,1.8),(5,datetime(2026,2,14,0),48,2.0),(1,datetime(2026,7,4,0),56,1.8)]
def anomaly(b,t):
    for ab,s,h,m in anoms:
        if ab==b and s<=t<s+timedelta(hours=h): return m
    return 1.0
t=start
while t<end:
    doy=t.timetuple().tm_yday; hr=t.hour; wk=t.weekday()
    temp=16.5-7.5*math.cos(2*math.pi*(doy-20)/365)+3.2*math.sin(2*math.pi*(hr-9)/24)+random.gauss(0,1.2)
    temps.append([t,round(temp,1)])
    cool=max(0,temp-22); heat=max(0,14-temp)
    work=wk<5; day=8<=hr<20
    aug=t.month==8
    for b,name,typ,area,retro in buildings:
        if typ=="Office":    base=60+ (380 if work and day else 0)*(0.45 if aug else 1)
        elif typ=="Laboratory": base=170+(260 if work and day else 40)
        elif typ=="Library": base=35+(230 if 8<=hr<22 and (work or wk==5) else 0)*(0.35 if aug else 1)
        elif typ=="Residence": base=90+(160 if 18<=hr<24 else 70 if 7<=hr<9 else 0)
        elif typ=="Sports":  base=30+(190 if 16<=hr<22 else 60 if day else 0)
        else:                base=210
        hvac=(14*cool+8*heat)*area/5000 if typ!="Data centre" else 6*cool
        kwh=(base+hvac)*random.uniform(0.94,1.06)
        if retro and t>=datetime.fromisoformat(retro): kwh*=0.80
        kwh*=anomaly(b,t)
        readings.append([b,t,round(kwh,2)])
    t+=timedelta(hours=1)
write("outdoor_temperature",["reading_ts","temperature_c"],temps)
write("meter_readings",["building_id","reading_ts","kwh"],readings)
# Spanish 2.0TD-style periods (illustrative prices, EUR/kWh)
write("tariff_prices",["period","price_eur_kwh"],[("P1",0.21),("P2",0.15),("P3",0.10)])
write("emission_factors",["year","kgco2e_per_kwh"],[(2025,0.11),(2026,0.10)])
print(len(readings),"readings")
