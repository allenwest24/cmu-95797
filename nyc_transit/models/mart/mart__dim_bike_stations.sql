select
    -- Make sure to select only distinct values
    distinct
    -- Rename columns to match the schema
    start_station_id as station_id,
    start_station_name as station_name,
    start_station_lat as station_lat,
    start_station_lng as station_lng
from {{ ref('stg__bike_data') }}
union
select
    -- Make sure to select only distinct values
    distinct
    -- Rename columns to match the schema
    end_station_id as station_id,
    end_station_name as station_name,
    end_station_lat as station_lat,
    end_station_lng as station_lng
from {{ ref('stg__bike_data') }}
