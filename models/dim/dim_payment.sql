{{
    config(
        materialized = 'table'
    )
}}

SELECT
    {{ dbt_utils.generate_surrogate_key(['USER_ID', 'PAYMENT_ID']) }} AS payment_sk, *, 
    CASE 
        WHEN PAYMENT_TYPE = 'captured' THEN 'is_success'
        WHEN PAYMENT_TYPE = 'refunded' THEN 'is_refund'
        WHEN PAYMENT_TYPE = 'failed' THEN 'is_failure'
        WHEN PAYMENT_TYPE = 'wallet' THEN 'is_digital'
        END AS PAYMENT_STATUS

FROM {{ ref('src_payment')}}
