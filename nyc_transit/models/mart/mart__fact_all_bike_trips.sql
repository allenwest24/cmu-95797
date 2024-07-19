select
    -- Renaming columns and reformatting to durations.
    start_time as started_at_ts,
    stop_time as ended_at_ts,
    datediff('minute', start_time, stop_time) as duration_min,
    datediff('second', start_time, stop_time) as duration_sec,
    start_station_id,
    end_station_id
from {{ ref('stg__bike_data') }}
