-- Already uses CTE borough_trip_counts.

with borough_trip_counts as (
    select
        -- Extract the weekday from the trip pickup timestamp
        weekday(f.pickup_datetime) as weekday,
        -- Count the total number of trips for each weekday
        count(*) as total_trips,
        -- Count the number of inter-borough trips for each weekday
        count(case when lpu.borough != ldo.borough then 1 end) as inter_borough_trips
    from {{ ref('mart__fact_all_taxi_trips') }} f
    -- Join with the locations dimension table for pickup locations
    join {{ ref('mart__dim_locations') }} lpu
    on f.pulocationid = lpu.LocationID
    -- Join with the locations dimension table for dropoff locations
    join {{ ref('mart__dim_locations') }} ldo
    on f.dolocationid = ldo.LocationID
    -- Group the results by weekday
    group by weekday(f.pickup_datetime)
)

select
    weekday,
    total_trips,
    inter_borough_trips,
    -- Calculate the percentage of inter-borough trips
    (inter_borough_trips::float / total_trips) * 100 as inter_borough_percentage
from borough_trip_counts
