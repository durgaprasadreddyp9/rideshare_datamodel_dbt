select trip_id, 
    user_sk,
    driver_sk,
    total_fare,
    datediff('minute', requested_at,  accepted_at)      as accept_latency_min,
    datediff('minute', accepted_at,   pickup_at)        as pickup_wait_min,
    datediff('minute', trip_start_time, trip_end_time)  as trip_duration_min

from {{ ref('fct_trips') }}
