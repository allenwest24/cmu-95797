with trips_with_zones as (
    select
        t.*,
        l.borough,
        l.zone
    from {{ ref('intermediate_all_trips') }} t -- this is a reference to the intermediate_all_trips model
    left join {{ ref('mart__dim_locations') }} l -- this is a reference to the mart__dim_locations model
    on t.pulocationid = l.locationid
)

select
    borough,
    zone,
    count(*) as number_of_trips,
    avg(duration_min) as avg_trip_duration
from trips_with_zones
group by borough, zone
