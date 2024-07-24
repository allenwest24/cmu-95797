with avg_fares as (
    select
        fare_amount,
        avg(fare_amount) over () as overall_avg_fare, -- overall average fare
        avg(fare_amount) over (partition by l.borough) as borough_avg_fare, -- average fare by borough
        avg(fare_amount) over (partition by l.zone) as zone_avg_fare -- average fare by zone
    from {{ ref('stg__yellow_tripdata') }} t
    left join {{ ref('mart__dim_locations') }} l
    on t.pu_location_id = l.locationid 
)

-- Calculate the difference between the fare amount and the average fare by overall, borough, and zone
select
    fare_amount,
    overall_avg_fare,
    borough_avg_fare,
    zone_avg_fare,
    fare_amount - overall_avg_fare as overall_diff,
    fare_amount - borough_avg_fare as borough_diff,
    fare_amount - zone_avg_fare as zone_diff
from avg_fares
