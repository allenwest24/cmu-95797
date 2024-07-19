select
    l.service_zone,
    -- Count the total number of trips for each service zone
    count(*) as total_trips
from {{ ref('mart__fact_all_taxi_trips') }} f
-- Join with the locations dimension table based on dropoff locations
join {{ ref('mart__dim_locations') }} l
on f.dolocationid = l.LocationID
-- Filter to include only trips to specific service zones (Airports and EWR)
where l.service_zone in ('Airports', 'EWR')
-- Group the results by service zone
group by l.service_zone;
