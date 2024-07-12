{{ config(
    materialized='view',
    alias='for_hire_vehicle_trip_data'
) }} -- Improved table name.

with cleaned_fhv_tripdata as (
    -- Remove duplicate rows
    select distinct
        -- Casting dispatching_base_num to varchar
        try_cast(dispatching_base_num as varchar) as dispatching_base_num,
        
        -- Casting pickup_datetime and dropoff_datetime to timestamp
        try_cast(pickup_datetime as timestamp) as pickup_datetime,
        try_cast(dropoff_datetime as timestamp) as dropoff_datetime,

        -- Casting PUlocationID and DOlocationID to integer and ensuring they are valid
        case when try_cast(PUlocationID as integer) is not null and try_cast(PUlocationID as integer) >= 0
             then try_cast(PUlocationID as integer)
             else -1  -- Default value to handle invalid values
        end as pickup_location_id,
        case when try_cast(DOlocationID as integer) is not null and try_cast(DOlocationID as integer) >= 0
             then try_cast(DOlocationID as integer)
             else -1  -- Default value to handle invalid values
        end as dropoff_location_id,

        -- Handling null values and renaming SR_Flag to shared_ride_flag
        case when try_cast(SR_Flag as integer) in (0, 1)
             then try_cast(SR_Flag as integer)
             else 0  -- Default value to handle invalid values
        end as shared_ride_flag,

        -- Handling null values and renaming Affiliated_base_number to affiliated_base_number
        nullif(try_cast(Affiliated_base_number as varchar), '') as affiliated_base_number,

        -- Casting filename to varchar
        try_cast(filename as varchar) as filename
    from {{ source('main', 'fhv_tripdata') }}
)

select
    dispatching_base_num,
    pickup_datetime,
    dropoff_datetime,
    pickup_location_id,
    dropoff_location_id,
    shared_ride_flag,
    affiliated_base_number,
    filename
from cleaned_fhv_tripdata
where
    pickup_datetime is not null
    and dropoff_datetime is not null
    and pickup_datetime <= dropoff_datetime
    and pickup_location_id is not null
    and dropoff_location_id is not null
