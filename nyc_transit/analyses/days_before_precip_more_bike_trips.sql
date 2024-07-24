with weather_bike_trips as (
    select
        w.observation_date,
        w.precipitation,
        w.snowfall,
        b.trips,
        lag(b.trips) over (order by w.observation_date) as prev_day_trips -- Calculate the bike trips from the previous day
    from {{ ref('stg__central_park_weather') }} w -- Reference the staging table for Central Park weather 
    left join (
        select 
            type,
            date_trunc('day', started_at_ts)::date as observation_date, -- Truncate the start timestamp to the day level
            count(*) as trips
        from {{ ref('intermediate_all_trips') }} -- Reference the intermediate table for all trips
        where type = 'bike'
        group by 1, 2 -- Group by trip type and observation date
    ) b
    on w.observation_date = b.observation_date
)

-- Calculate average bike trips on days with and without precipitation
select
    case when precipitation > 0 or snowfall > 0 then 'precipitation_day' else 'no_precipitation_day' end as day_type,
    avg(case when precipitation > 0 or snowfall > 0 then prev_day_trips else null end) as avg_trips_before_precipitation,
    avg(case when precipitation > 0 or snowfall > 0 then trips else null end) as avg_trips_on_precipitation_days
from weather_bike_trips
group by 1 -- Group by day type
