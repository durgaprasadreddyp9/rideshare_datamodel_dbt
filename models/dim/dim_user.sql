{{
    config(
        materialized = 'table'
    )
}}

SELECT
    {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS user_sk,
    USER_ID AS user_id,
    EMAIL AS email,
    GENDER AS gender,
    IS_PREMIUM AS is_premium,
    JOINED_DATE AS joined_date,
    NAME AS name,
    PAYMENT_TYPE AS payment_type,
    PHONE_NUMBER AS phone_number,
    UPDATED_AT AS updated_at,
    CREATED_AT AS created_at

from {{ ref('src_app_user') }}