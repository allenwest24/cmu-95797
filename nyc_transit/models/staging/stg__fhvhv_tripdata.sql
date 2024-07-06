-- models/staging/stg__fhvhv_tripdata.sql

{{ config(
    materialized='view',
    alias='for_hire_vehicle_trip_data_extended'
) }} -- Improved table name.

with cleaned_fhvhv_tripdata as (
    -- Remove duplicate rows
    select distinct
        -- Casting hvfhs_license_num to varchar
        try_cast(hvfhs_license_num as varchar) as hvfhs_license_num,
        
        -- Casting dispatching_base_num to varchar
        try_cast(dispatching_base_num as varchar) as dispatching_base_num,
        
        -- Casting originating_base_num to varchar
        try_cast(originating_base_num as varchar) as originating_base_num,
        
        -- Casting datetime columns to timestamp
        try_cast(request_datetime as timestamp) as request_datetime,
        try_cast(on_scene_datetime as timestamp) as on_scene_datetime,
        try_cast(pickup_datetime as timestamp) as pickup_datetime,
        try_cast(dropoff_datetime as timestamp) as dropoff_datetime,
        
        --- Casting location IDs to integer and renaming
        case when try_cast(PULocationID as integer) > 0
             then try_cast(PULocationID as integer)
             else NULL
        end as pickup_location_id,
        case when try_cast(DOLocationID as integer) > 0
             then try_cast(DOLocationID as integer)
             else NULL
        end as dropoff_location_id,
        
        -- Casting trip_miles to double
        case when try_cast(trip_miles as double) >= 0
             then try_cast(trip_miles as double)
             else NULL
        end as trip_miles,
        
        -- Casting trip_time to integer
        case when try_cast(trip_time as integer) >= 0
             then try_cast(trip_time as integer)
             else NULL
        end as trip_time,
        
        -- Casting fare and fee columns to double
        case when try_cast(base_passenger_fare as double) >= 0
             then try_cast(base_passenger_fare as double)
             else NULL
        end as base_passenger_fare,
        case when try_cast(tolls as double) >= 0
             then try_cast(tolls as double)
             else NULL
        end as tolls,
        case when try_cast(bcf as double) >= 0
             then try_cast(bcf as double)
             else NULL
        end as bcf,
        case when try_cast(sales_tax as double) >= 0
             then try_cast(sales_tax as double)
             else NULL
        end as sales_tax,
        case when try_cast(congestion_surcharge as double) >= 0
             then try_cast(congestion_surcharge as double)
             else NULL
        end as congestion_surcharge,
        case when try_cast(tips as double) >= 0
             then try_cast(tips as double)
             else NULL
        end as tips,
        case when try_cast(driver_pay as double) >= 0
             then try_cast(driver_pay as double)
             else NULL
        end as driver_pay,
        
        -- Standardize flag columns to uppercase, trim leading/trailing whitespace, and try_cast to varchar
        case 
            when upper(trim(try_cast(shared_request_flag as varchar))) = 'Y' then 'Y'
            when upper(trim(try_cast(shared_request_flag as varchar))) = 'N' then 'N'
            else 'N' 
        end as shared_request_flag,

        case 
            when upper(trim(try_cast(shared_match_flag as varchar))) = 'Y' then 'Y'
            when upper(trim(try_cast(shared_match_flag as varchar))) = 'N' then 'N'
            else 'N' 
        end as shared_match_flag,

        case 
            when upper(trim(try_cast(access_a_ride_flag as varchar))) = 'Y' then 'Y'
            when upper(trim(try_cast(access_a_ride_flag as varchar))) = 'N' then 'N'
            else 'N' 
        end as access_a_ride_flag,

        case 
            when upper(trim(try_cast(wav_request_flag as varchar))) = 'Y' then 'Y'
            when upper(trim(try_cast(wav_request_flag as varchar))) = 'N' then 'N'
            else 'N' 
        end as wav_request_flag,

        case 
            when upper(trim(try_cast(wav_match_flag as varchar))) = 'Y' then 'Y'
            when upper(trim(try_cast(wav_match_flag as varchar))) = 'N' then 'N'
            else 'N' 
        end as wav_match_flag,
        
        -- Casting filename to varchar
        try_cast(filename as varchar) as filename
    from {{ source('main', 'fhvhv_tripdata') }}
    
    -- Filter out rows where critical columns are null
    where hvfhs_license_num is not null
        and dispatching_base_num is not null
        and pickup_datetime is not null
        and pickup_datetime <= dropoff_datetime
)

-- Excluded airport fee, as it was all null
select
    hvfhs_license_num,
    dispatching_base_num,
    originating_base_num,
    request_datetime,
    on_scene_datetime,
    pickup_datetime,
    dropoff_datetime,
    pickup_location_id,
    dropoff_location_id,
    trip_miles,
    trip_time,
    base_passenger_fare,
    tolls,
    bcf,
    sales_tax,
    congestion_surcharge,
    tips,
    driver_pay,
    shared_request_flag,
    shared_match_flag,
    access_a_ride_flag,
    wav_request_flag,
    wav_match_flag,
    filename
from cleaned_fhvhv_tripdata
