with trips_renamed as (
    select 'fhv' as type, pickup_datetime, dropoff_datetime, pickup_location_id as pulocationid, dropoff_location_id as dolocationid
    from {{ ref('stg__fhv_tripdata') }}
    union all
    select 'fhvhv' as type, pickup_datetime, dropoff_datetime, pickup_location_id as pulocationid, dropoff_location_id as dolocationid
    from {{ ref('stg__fhvhv_tripdata') }}
    union all
    select 'green' as type, pickup_datetime, dropoff_datetime, pu_location_id as pulocationid, do_location_id as dolocationid
    from {{ ref('stg__green_tripdata') }}
    union all
    select 'yellow' as type, pickup_datetime, dropoff_datetime, pu_location_id as pulocationid, do_location_id as dolocationid
    from {{ ref('stg__yellow_tripdata') }}
)

select
    type,
    pickup_datetime,
    dropoff_datetime,
    datediff('minute', pickup_datetime, dropoff_datetime) as duration_min,
    datediff('second', pickup_datetime, dropoff_datetime) as duration_sec,
    pulocationid,
    dolocationid
from trips_renamed
