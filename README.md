# 🚕 Rideshare Analytics with dbt — Simple Project Overview

## 📌 Overview
Analyze how **rides**, **revenue**, and **operations** (wait times, durations, payments) behave over time, by **driver**, **user**, **vehicle**, and **location**. Using a clean **dbt layered model**, you’ll turn raw trip data into trustworthy facts and easy, dashboard-ready marts.

**What you’ll learn/answer**
- How many **rides** and how much **revenue** per **day / driver / area**  
- **Pickup wait** & **accept latency** trends by hour and region  
- **Payment health** (failure/refund rates) by method  
- **Premium vs standard** user performance  
- Hot **ZIP3** areas and demand curves by **hour of day**

---

## 🔹 Tech Stack
- **Warehouse:** Snowflake (works similarly on BigQuery/Redshift)  
- **Transformation:** **dbt** (sources → staging → intermediate → dims/facts → marts)  
- **Package:** `dbt_utils` (for surrogate keys & handy tests)

---

## 🧱 Data Model (Star Schema)
- **Dimensions (descriptors)**  
  - `dim_user` – user profile, premium flag, cohorts  
  - `dim_driver` – status, rating average & band  
  - `dim_vehicle` – model, color, body type, year  
  - `dim_location` – address/landmark/zip, **zip3** for grouping  
  - *(optional)* `dim_payment` – payment type/status/currency, channel  
  - *(optional)* `dim_rating` – rating per trip, tip flags  
  - *(optional)* `dim_trip_descriptor` – low-cardinality buckets (status, hour, fare band)
- **Fact (events & measures)**  
  - `fct_trips` – **one row per trip** with SKs to dims, **total_fare**, **tip_amount** (if used), **payment_amount**, **status/currency**, timestamps, and derived **accept latency**, **pickup wait**, **trip duration** (in minutes)

---

## 🔄 Workflow
1) **Ingest + Staging**  
   - Point dbt **sources** to raw tables.  
   - Build `stg_*` models: type casts, rename columns, standardize enums, dedupe.
2) **Intermediate (row logic)**  
   - Derive per-trip metrics: **accept_latency_min**, **pickup_wait_min**, **trip_duration_min**.  
   - (You can also join light fields from payments/ratings here.)
3) **Dimensions**  
   - One row per business key, add **surrogate keys**, simple segments/bands.  
   - Include an **unknown** member for late FKs.
4) **Fact**  
   - Incremental build keyed by a time watermark (e.g., `requested_at`).  
   - Include dim SKs + measures + timestamps + derived metrics.
5) **Marts (analytics)**  
   - Small, focused tables/views for dashboards (daily KPIs, driver/day, hotspots, payment KPIs, hour-of-day, user segment).

---

## 📊 Core Marts & Insights
- **Daily KPIs** – trips mix (completed/cancel/no-show), revenue, avg waits  
- **Driver / Day** – completed rides, revenue, avg waits per driver  
- **Location (ZIP3)** – hotspots: trips, revenue, avg pickup wait  
- **Payment KPIs** – failure & refund % by type/status  
- **Hour of Day** – demand/revenue curve across the day  
- **User Segment** – premium vs standard: trips, revenue, avg ticket

---

## ❓ Example Questions You Can Answer
- “How many rides and how much revenue did each **driver** generate **yesterday**?”  
- “Which **ZIP3** had the most trips this **week**, and what were the **avg pickup waits**?”  
- “What % of **wallet** payments **failed** last month?”  
- “When are **peak demand** hours, and how do waits behave then?”  
- “Do **premium** users spend more per trip than standard users?”

---

## ✅ Data Quality & Testing (light but effective)
- **Uniqueness / Not-null** on natural keys and SKs in dims & fact  
- **Accepted values** for standardized enums (status, payment_type, etc.)  
- **Range checks** (e.g., rating 0–5; waits/durations ≥ 0)  
- **Relationships** from fact naturals back to dims (FK integrity)

---

## 🚀 Ops & Scaling Tips
- Keep `fct_trips` **incremental** (MERGE by `trip_id`, filter by latest `requested_at`).  
- Rebuild marts **daily**; run the fact **hourly** (or as needed).  
- Start with the **core 4 dims** (user, driver, vehicle, location). Add optional dims later—marts still work.

---

## 🔐 Governance
- Don’t commit secrets (use local `profiles.yml`).  
- Hash or mask PII where not needed downstream.  
- Grant analysts access to **dims/marts**, not raw tables.

---

## 🗺️ Roadmap Ideas (optional)
- **SCD Type 2** snapshots for driver status history  
- Geospatial service areas & proximity joins (radius, polygons)  
- “Available drivers by area & time” mart to support **surge pricing** logic  
- CI pipeline to run `dbt build` on pull requests and surface docs/tests
