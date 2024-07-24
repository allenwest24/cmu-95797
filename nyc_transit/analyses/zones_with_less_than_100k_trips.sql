with trips_with_zones as (
    select
        t.*,
        l.zone
    from {{ ref('intermediate_all_trips') }} t
    left join {{ ref('mart__dim_locations') }} l
    on t.pulocationid = l.locationid
)

select
    zone,
    count(*) as number_of_trips
from trips_with_zones
group by zone
having count(*) < 100000 -- Filter to include only zones with less than 100,000 trips
