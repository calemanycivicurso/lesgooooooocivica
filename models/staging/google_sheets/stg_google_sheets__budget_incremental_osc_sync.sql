
{{
  config(
    materialized='incremental',
    unique_key='_row',
    on_schema_change='sync_all_columns'
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
        --, quantity 
        , date_load
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted
