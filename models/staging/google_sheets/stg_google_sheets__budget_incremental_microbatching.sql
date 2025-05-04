
{{
  config(
    materialized='incremental',
    incremental_strategy='microbatch',
    unique_key = '_row',
    begin = '2024-10-25',
    event_time='date_load',
    batch_size='month'
  )
}}

WITH stg_budget_products AS (
    SELECT * 
    FROM {{ ref( 'base_google_sheets__budget') }}
   {% if is_incremental() %}

    where date_load > (select max(date_load) from {{ this }})

   {% endif %}
    ),

renamed_casted AS (
    SELECT
          _row
        , month
        , quantity 
        , date_load
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted where _row<99

