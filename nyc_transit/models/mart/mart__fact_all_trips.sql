select
    type,
    date_trunc('day', started_at_ts)::date as date,
    count(*) as trips,
    avg(duration_min) as average_trip_duration_min
from {{ ref('intermediate_all_trips') }}
group by type, date
