{{
    config(
        materialized = 'table'
    )
}}

SELECT
    {{ dbt_utils.generate_surrogate_key(['RATING_ID', 'TRIP_ID']) }} AS ratign_sk, *, 
    case
        when driver_rating >= 4.5 then 'superb'
        when driver_rating >= 4.0 then 'great'
        when driver_rating >= 3.5 then 'good'
        when driver_rating >= 3.0 then 'ok'
        when driver_rating is null then 'unknown'
        else 'low'
    end as rating_band,
    case
        when tips is null or tips = 0 then '0'
        when tips < 3 then '0-2.99'
        when tips < 6 then '3-5.99'
        when tips < 11 then '6-10.99'
        else '11+'
  end as tip_bucket

from {{ ref('src_rating')}}