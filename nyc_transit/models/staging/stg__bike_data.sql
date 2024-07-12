{{ config(
    materialized='view',
    alias='citi_bike_data' 
) }} -- Improved table name.

with cleaned_bike_data as (
    select distinct
        -- Casting tripduration to integer and ensuring it is not null and >= 0
        case when try_cast(tripduration as integer) is not null and try_cast(tripduration as integer) >= 0
             then try_cast(tripduration as integer)
             else 0  -- Default value to handle null or invalid values
        end as trip_duration,

        -- Converting starttime and stoptime to timestamp and ensuring they are not null
        coalesce(try_cast(starttime as timestamp), current_timestamp) as start_time,
        coalesce(try_cast(stoptime as timestamp), current_timestamp) as stop_time,

        -- Casting station ids to integer and ensuring they are not null and valid
        case when try_cast("start station id" as integer) is not null and try_cast("start station id" as integer) >= 0
             then try_cast("start station id" as integer)
             else -1  -- Default value to handle null or invalid values
        end as start_station_id,
        case when try_cast("end station id" as integer) is not null and try_cast("end station id" as integer) >= 0
             then try_cast("end station id" as integer)
             else -1  -- Default value to handle null or invalid values
        end as end_station_id,

        -- Standardizing station names
        nullif(upper(trim("start station name")), '') as start_station_name,
        nullif(upper(trim("end station name")), '') as end_station_name,

        -- Casting latitude and longitude to double and ensuring they are within valid ranges
        case when try_cast("start station latitude" as double) between -90 and 90
             then try_cast("start station latitude" as double)
             else 0  -- Default value to handle invalid values
        end as start_station_lat,
        case when try_cast("start station longitude" as double) between -180 and 180
             then try_cast("start station longitude" as double)
             else 0  -- Default value to handle invalid values
        end as start_station_lng,
        case when try_cast("end station latitude" as double) between -90 and 90
             then try_cast("end station latitude" as double)
             else 0  -- Default value to handle invalid values
        end as end_station_lat,
        case when try_cast("end station longitude" as double) between -180 and 180
             then try_cast("end station longitude" as double)
             else 0  -- Default value to handle invalid values
        end as end_station_lng,

        -- Casting bikeid to integer and ensuring it is not null
        coalesce(try_cast(bikeid as integer), -1) as bike_id,
        upper(trim(usertype)) as user_type,

        -- Casting birth year to integer and ensuring it is within valid range
        case when try_cast("birth year" as integer) between 1900 and extract(year from current_date)
             then try_cast("birth year" as integer)
             else 1900  -- Default value to handle invalid values
        end as birth_year,

        -- Casting gender to integer and ensuring it is within valid values
        case when try_cast(gender as integer) in (0, 1, 2)
             then try_cast(gender as integer)
             else 0  -- Default value to handle invalid values
        end as gender,

        filename

    from {{ source('main', 'bike_data') }}
)

-- Selecting all cleaned columns and ensuring uniqueness of bike_id
select
    distinct on (bike_id)  -- Ensuring uniqueness by selecting the first occurrence of each bike_id
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
