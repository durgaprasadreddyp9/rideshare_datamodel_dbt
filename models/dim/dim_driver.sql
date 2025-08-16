{{
    config(
        materialized = 'incremental',
         unique_key='driver_id',     
         on_schema_change='sync_all_columns',   
         incremental_strategy='merge' 
    )
}}

SELECT
    {{ dbt_utils.generate_surrogate_key(['driver_id']) }} AS driver_sk, *,
    CASE 
        when rating_avg >=4.5 then 'elite'
        when rating_avg >=4.0 then 'gold'
        when rating_avg >=3.5 then 'silver'
        when rating_avg IS NULL then 'unknown'
        ELSE 'standard'
        END AS rating_band

from {{ ref('src_driver')}}