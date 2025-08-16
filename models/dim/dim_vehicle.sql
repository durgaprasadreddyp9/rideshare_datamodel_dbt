{{
    config(
        materialized = 'table'
    )
}}

select
  {{ dbt_utils.generate_surrogate_key(['vehicle_id']) }} as vehicle_sk, * 

from {{ ref('src_vehicle') }}