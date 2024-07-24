select
    type,
    -- Truncate the timestamp to the day and cast it to a date
    date_trunc('day', started_at_ts)::date as date,
    -- Count the number of trips for each type and day
    count(*) as trips,
    -- Calculate the average trip duration in minutes for each type and day
    avg(duration_min) as average_trip_duration_min
from {{ ref('intermediate_all_trips') }}
group by type, date
