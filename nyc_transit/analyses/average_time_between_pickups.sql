with pickup_intervals as (
    select
        l.zone,
        t.pulocationid,
        t.pickup_datetime,
        lead(t.pickup_datetime) over (partition by l.zone order by t.pickup_datetime) as next_pickup_datetime -- Calculate the next pickup datetime for each zone
    from {{ ref('mart__fact_all_taxi_trips') }} t -- Reference the fact table for all taxi trips
    left join {{ ref('mart__dim_locations') }} l -- Reference the dimension table for locations
    on t.pulocationid = l.locationid -- Join the trips and locations tables on the pickup location ID
)

select
    zone,
    avg(datediff('minute', pickup_datetime, next_pickup_datetime)) as avg_time_between_pickups -- Calculate the average time difference in minutes
from pickup_intervals
group by zone
