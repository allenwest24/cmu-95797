with ranked_events as (
    select
        *,
        row_number() over (partition by event_id order by event_timestamp desc) as row_num -- Rank events by timestamp
    from {{ ref('events') }}
)

select
    *
from ranked_events
where row_num = 1 -- Select only the most recent event for each event_id
