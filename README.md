# 🚕 Rideshare Analytics with dbt

## 📌 Overview
Analyze how **rides**, **revenue**, and **operations** (wait times, durations, payments) behave over time, by **driver**, **user**, **vehicle**, and **location**. Using a clean **dbt layered model**, you’ll turn raw trip data into trustworthy facts and easy, dashboard-ready marts.

**What you’ll learn/answer**
- How many **rides** and how much **revenue** per **day / driver / area**  
- **Pickup wait** & **accept latency** trends by hour and region 

---

## 🔹 Tech Stack
- **Warehouse:** Snowflake (works similarly on BigQuery/Redshift)  
- **Transformation:** **dbt** (sources → staging → intermediate → dims/facts → marts)  
- **Package:** `dbt_utils` (for surrogate keys)

---

## 🧱 Data Model (Star Schema)
- **Dimensions (descriptors)**  
  - `dim_user`  
  - `dim_driver`  
  - `dim_vehicle` 
  - `dim_location`  
  - `dim_payment` 
  - `dim_rating`   
  - `dim_trip_descriptor` 
- **Fact (events & measures)**  
  - `fct_trips` – **one row per trip** with SKs to dims, **total_fare**, **tip_amount** (if used), **payment_amount**, **status/currency**, timestamps, and derived **accept latency**, **pickup wait**, **trip duration** (in minutes)

---

## 🔄 Workflow
1) **Ingest + Staging**  
   - Point dbt **sources** to raw tables.  
   
2) **Dimensions**  
   - One row per business key, add **surrogate keys**, simple segments/bands.  
 
3) **Fact**  
   - Incremental build keyed by a time watermark (e.g., `requested_at`).  
  
4) **Marts (analytics)**  
   - Small, focused tables/views for dashboards (daily KPIs, driver/day, hotspots, payment KPIs, hour-of-day, user segment).

---


## ❓ Example Questions You Can Answer
- “How many rides and how much revenue did each **driver** generate **yesterday**?”  
- “Which **ZIP3** had the most trips this **week**, and what were the **avg pickup waits**?”  


---

## ✅ Data Quality & Testing (light but effective)
- **Uniqueness / Not-null** on natural keys and SKs in dims & fact  
- **Accepted values** for standardized enums (status, payment_type, etc.)  
- **Range checks** (e.g., rating 0–5; waits/durations ≥ 0)  
- **Relationships** from fact naturals back to dims (FK integrity)

