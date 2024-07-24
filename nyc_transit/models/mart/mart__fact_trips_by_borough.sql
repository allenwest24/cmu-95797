with trips_with_borough as (
    select
        t.type,
        t.started_at_ts,
        t.ended_at_ts,
        t.duration_min,
        t.duration_sec,
        t.pulocationid,
        t.dolocationid,
        l.borough as pickup_borough
    from {{ ref('intermediate_all_trips') }} t
    left join {{ ref('mart__dim_locations') }} l
    on t.pulocationid = l.locationid
)

select
    pickup_borough,
    count(*) as number_of_trips
from trips_with_borough
group by pickup_borough
