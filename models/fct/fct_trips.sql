{{ config(
  materialized='incremental',
  incremental_strategy='merge',
  unique_key='trip_id',
  cluster_by=['requested_at'],
  on_schema_change='sync_all_columns'
) }}

with src as (
  
  select * from {{ ref('src_trip') }}
  {% if is_incremental() %}
    where requested_at > (select max(requested_at) from {{ this }})
  {% endif %}
),

du as (select user_id, user_sk    from {{ ref('dim_user') }}),
dd as (select driver_id, driver_sk  from {{ ref('dim_driver') }}),
dv as (select vehicle_id, vehicle_sk from {{ ref('dim_vehicle') }}),
dl as (select location_id, location_sk from {{ ref('dim_location') }})

select
  
  s.trip_id,

  du.user_sk,
  dd.driver_sk,
  dv.vehicle_sk,
  dl.location_sk,

  s.user_id, 
  s.driver_id, 
  s.vehicle_id, 
  s.location_id,

  s.total_fare,

  s.status,
  s.currency,

  s.requested_at, 
  s.accepted_at, 
  s.pickup_at, 
  s.dropoff_at,
  s.trip_start_time, 
  s.trip_end_time,

  datediff('minute', s.requested_at,  s.accepted_at)      as accept_latency_min,
  datediff('minute', s.accepted_at,   s.pickup_at)        as pickup_wait_min,
  datediff('minute', s.trip_start_time, s.trip_end_time)  as trip_duration_min

from src s
left join du on s.user_id    = du.user_id
left join dd on s.driver_id  = dd.driver_id
left join dv on s.vehicle_id = dv.vehicle_id
left join dl on s.location_id= dl.location_id

