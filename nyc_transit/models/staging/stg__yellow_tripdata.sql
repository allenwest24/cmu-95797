-- models/staging/stg__yellow_tripdata.sql

{{ config(
    materialized='view',
    alias='yellow_cab_trip_data'
) }} -- Improved table name.

with cleaned_yellow_tripdata as (
    -- Remove duplicate rows
    select distinct
        -- Casting VendorID to integer and changing column name to vendor_id
        case when try_cast(VendorID as integer) > 0
             then try_cast(VendorID as integer)
             else NULL
        end as vendor_id,

        -- Setting datetime fields to timestamps and changing column names
        try_cast(tpep_pickup_datetime as timestamp) as pickup_datetime,
        try_cast(tpep_dropoff_datetime as timestamp) as dropoff_datetime,

        -- Casting passenger_count to integer and changing column name
        case when try_cast(passenger_count as integer) >= 0
             then try_cast(passenger_count as integer)
             else NULL
        end as passenger_count,

        -- Casting numeric fields to double and handling missing values
        case when try_cast(trip_distance as double) >= 0
             then try_cast(trip_distance as double)
             else NULL
        end as trip_distance,
        case when try_cast(RatecodeID as integer) > 0
             then try_cast(RatecodeID as integer)
             else NULL
        end as rate_code_id,

        -- Standardizing store_and_fwd_flag to uppercase, removing leading/trailing whitespace, and changing column name
        nullif(upper(trim(store_and_fwd_flag)), '') as store_and_fwd_flag,

        -- Casting location IDs to integers and changing column names
        case when try_cast(PULocationID as integer) > 0
             then try_cast(PULocationID as integer)
             else NULL
        end as pu_location_id,
        case when try_cast(DOLocationID as integer) > 0
             then try_cast(DOLocationID as integer)
             else NULL
        end as do_location_id,

        -- Casting payment_type to integer and changing column name
        case when try_cast(payment_type as integer) > 0
             then try_cast(payment_type as integer)
             else NULL
        end as payment_type,

        -- Casting numeric fields to double and handling missing values
        case when try_cast(fare_amount as double) >= 0
             then try_cast(fare_amount as double)
             else NULL
        end as fare_amount,
        case when try_cast(extra as double) >= 0
             then try_cast(extra as double)
             else NULL
        end as extra,
        case when try_cast(mta_tax as double) >= 0
             then try_cast(mta_tax as double)
             else NULL
        end as mta_tax,
        case when try_cast(tip_amount as double) >= 0
             then try_cast(tip_amount as double)
             else NULL
        end as tip_amount,
        case when try_cast(tolls_amount as double) >= 0
             then try_cast(tolls_amount as double)
             else NULL
        end as tolls_amount,
        case when try_cast(improvement_surcharge as double) >= 0
             then try_cast(improvement_surcharge as double)
             else NULL
        end as improvement_surcharge,
        case when try_cast(total_amount as double) >= 0
             then try_cast(total_amount as double)
             else NULL
        end as total_amount,
        case when try_cast(congestion_surcharge as double) >= 0
             then try_cast(congestion_surcharge as double)
             else NULL
        end as congestion_surcharge,

        -- Selecting filename as is
        filename

    from {{ source('main', 'yellow_tripdata') }}

    -- Filtering out rows with essential null values
    where VendorID is not null
      and tpep_pickup_datetime is not null
      and tpep_dropoff_datetime is not null
      and try_cast(tpep_dropoff_datetime as timestamp) >= try_cast(tpep_pickup_datetime as timestamp)
)

-- Excluding airport fee
select
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count,
    trip_distance,
    rate_code_id,
    store_and_fwd_flag,
    pu_location_id,
    do_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    filename
from cleaned_yellow_tripdata
