-- models/staging/stg__bike_data.sql

{{ config(
    materialized='view',
    alias='citi_bike_data' 
) }} -- Improved table name.

with cleaned_bike_data as (
    select distinct
        -- Casting tripduration to integer and handling potential null values
        case when try_cast(tripduration as integer) is not null and try_cast(tripduration as integer) >= 0
             then try_cast(tripduration as integer)
             else null
        end as trip_duration,

        -- Converting starttime and stoptime to timestamp and renaming columns
        try_cast(starttime as timestamp) as start_time,
        try_cast(stoptime as timestamp) as stop_time,

        -- Casting station ids to integer and renaming columns
        try_cast("start station id" as integer) as start_station_id,
        try_cast("end station id" as integer) as end_station_id,

        -- Standardizing station names
        nullif(upper(trim("start station name")), '') as start_station_name,
        nullif(upper(trim("end station name")), '') as end_station_name,

        -- Casting latitude and longitude to double and handling potential null values
        case when try_cast("start station latitude" as double) between -90 and 90
             then try_cast("start station latitude" as double)
             else null
        end as start_station_lat,
        case when try_cast("start station longitude" as double) between -180 and 180
             then try_cast("start station longitude" as double)
             else null
        end as start_station_lng,
        case when try_cast("end station latitude" as double) between -90 and 90
             then try_cast("end station latitude" as double)
             else null
        end as end_station_lat,
        case when try_cast("end station longitude" as double) between -180 and 180
             then try_cast("end station longitude" as double)
             else null
        end as end_station_lng,

        -- Selecting remaining columns and handling null values
        try_cast(bikeid as integer) as bike_id,
        upper(trim(usertype)) as user_type,
        case when try_cast("birth year" as integer) between 1900 and extract(year from current_date)
             then try_cast("birth year" as integer)
             else null
        end as birth_year,
        case when try_cast(gender as integer) in (0, 1, 2)
             then try_cast(gender as integer)
             else null
        end as gender,
        filename

    from {{ source('main', 'bike_data') }}

    -- Filtering out rows with essential null values
    where tripduration is not null
      and starttime is not null
      and stoptime is not null
      and bikeid is not null
)

-- excluded all null columns from list
select
    trip_duration,
    start_time,
    stop_time,
    start_station_id,
    start_station_name,
    start_station_lat,
    start_station_lng,
    end_station_id,
    end_station_name,
    end_station_lat,
    end_station_lng,
    bike_id,
    user_type,
    birth_year,
    gender,
    filename
from cleaned_bike_data
