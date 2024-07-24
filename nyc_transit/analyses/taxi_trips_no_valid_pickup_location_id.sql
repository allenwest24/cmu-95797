with valid_location_ids as (
    select distinct locationid
    from {{ ref('mart__dim_locations') }}
)

select
    count(*)
from {{ ref('intermediate_all_trips') }} t
left join valid_location_ids l -- Reference the CTE with valid location IDs
on t.pulocationid = l.locationid
where l.locationid is null
