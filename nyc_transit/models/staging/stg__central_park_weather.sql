-- models/staging/stg__central_park_weather.sql

{{ config(
    materialized='view'
) }}

with cleaned_central_park_weather as (
    -- Remove duplicate rows
    select distinct
        -- Select station as is
        station,
        
        -- Standardize name to all uppercase and trim leading/trailing whitespace
        nullif(upper(trim(name)), '') as station_name,
        
        -- Convert to date type and rename
        try_cast(date as date) as observation_date,
        
        -- Convert awnd, prcp, snow, snwd, tmax, tmin to appropriate types, handle missing values, and appropriately name
        case when try_cast(nullif(trim(awnd), '') as double) >= 0
             then try_cast(nullif(trim(awnd), '') as double)
             else NULL
        end as average_wind_speed,
        case when try_cast(nullif(trim(prcp), '') as double) >= 0
             then try_cast(nullif(trim(prcp), '') as double)
             else NULL
        end as precipitation,
        case when try_cast(nullif(trim(snow), '') as double) >= 0
             then try_cast(nullif(trim(snow), '') as double)
             else NULL
        end as snowfall,
        case when try_cast(nullif(trim(snwd), '') as double) >= 0
             then try_cast(nullif(trim(snwd), '') as double)
             else NULL
        end as snow_depth,
        case when try_cast(nullif(trim(tmax), '') as integer) between -50 and 130
             then try_cast(nullif(trim(tmax), '') as integer)
             else NULL
        end as max_temperature,
        case when try_cast(nullif(trim(tmin), '') as integer) between -50 and 130
             then try_cast(nullif(trim(tmin), '') as integer)
             else NULL
        end as min_temperature,
        
        -- Select filename as is
        filename
    from {{ source('main', 'central_park_weather') }}
)

-- Kept all columns
select
    station,
    station_name,
    observation_date,
    average_wind_speed,
    precipitation,
    snowfall,
    snow_depth,
    max_temperature,
    min_temperature,
    filename
from cleaned_central_park_weather