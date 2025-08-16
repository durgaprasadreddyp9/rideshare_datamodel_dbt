{{
    config(
        materialized = 'table'
    )
}}

SELECT
    {{ dbt_utils.generate_surrogate_key(['LOCATION_ID']) }} AS location_sk,
    location_id,                        
    address,
    landmark,
    distance,
    zip_code, 
    round(latitude, 5)  as latitude,     
    round(longitude, 5) as longitude,
    created_at,
    updated_at

from {{ ref('src_location') }}