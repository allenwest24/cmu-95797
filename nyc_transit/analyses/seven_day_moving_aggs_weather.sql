-- Create a table with seven-day moving averages of precipitation and snowfall
select
    observation_date,
    min(precipitation) over seven_day_window as seven_day_min_prcp,
    max(precipitation) over seven_day_window as seven_day_max_prcp,
    avg(precipitation) over seven_day_window as seven_day_avg_prcp,
    sum(precipitation) over seven_day_window as seven_day_sum_prcp,
    min(snowfall) over seven_day_window as seven_day_min_snow,
    max(snowfall) over seven_day_window as seven_day_max_snow,
    avg(snowfall) over seven_day_window as seven_day_avg_snow,
    sum(snowfall) over seven_day_window as seven_day_sum_snow
from {{ ref('stg__central_park_weather') }}
window seven_day_window as (
    partition by null
    order by observation_date
    rows between 3 preceding and 3 following -- Define the window as the current row and the three preceding and following rows
)
