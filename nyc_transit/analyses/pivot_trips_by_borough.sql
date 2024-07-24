with trips_with_borough as (
    select
        date_trunc('day', t.started_at_ts)::date as date, -- Truncate the timestamp to the day and cast it to a date
        l.borough,
        count(*) as number_of_trips
    from {{ ref('intermediate_all_trips') }} t -- Join with the locations dimension table based on pickup locations
    left join {{ ref('mart__dim_locations') }} l -- Group the results by date and borough
    on t.pulocationid = l.locationid
    group by date, l.borough
)

-- Pivot the results to have a separate column for each borough
select
    date,
    sum(case when borough = 'Bronx' then number_of_trips else 0 end) as bronx_trips,
    sum(case when borough = 'Brooklyn' then number_of_trips else 0 end) as brooklyn_trips,
    sum(case when borough = 'Manhattan' then number_of_trips else 0 end) as manhattan_trips,
    sum(case when borough = 'Queens' then number_of_trips else 0 end) as queens_trips,
    sum(case when borough = 'Staten Island' then number_of_trips else 0 end) as staten_island_trips
from trips_with_borough
group by date
