select
    observation_date,
    -- Calculate the seven-day moving average of precipitation
    avg(precipitation) over (
        partition by null
        order by observation_date
        rows between 3 preceding and 3 following
    ) as seven_day_moving_avg_prcp
from {{ ref('stg__central_park_weather') }}
