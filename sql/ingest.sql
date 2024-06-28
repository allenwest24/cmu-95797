-- sql/ingest.sql

-- Create the bike_data table
CREATE TABLE IF NOT EXISTS bike_data (
    tripduration INTEGER,
    starttime TIMESTAMP,
    stoptime TIMESTAMP,
    start_station_id INTEGER,
    start_station_name VARCHAR,
    start_station_latitude DOUBLE,
    start_station_longitude DOUBLE,
    end_station_id INTEGER,
    end_station_name VARCHAR,
    end_station_latitude DOUBLE,
    end_station_longitude DOUBLE,
    bikeid INTEGER,
    usertype VARCHAR,
    birth_year INTEGER,
    gender INTEGER,
    ride_id VARCHAR,
    rideable_type VARCHAR,
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name_2 VARCHAR,
    start_station_id_2 VARCHAR,
    end_station_name_2 VARCHAR,
    end_station_id_2 VARCHAR,
    start_lat DOUBLE,
    start_lng DOUBLE,
    end_lat DOUBLE,
    end_lng DOUBLE,
    member_casual VARCHAR
);

-- Create the central_park_weather table
CREATE TABLE IF NOT EXISTS central_park_weather (
    station VARCHAR,
    name VARCHAR,
    date VARCHAR,  
    awnd REAL,
    prcp REAL,
    snow REAL,
    snwd REAL,
    tmax INTEGER,
    tmin INTEGER
);

-- Create the fhv_bases table
CREATE TABLE IF NOT EXISTS fhv_bases (
    base_number VARCHAR,
    base_name VARCHAR,
    dba VARCHAR,
    dba_category VARCHAR
);

-- Load data into the tables
COPY bike_data FROM 'data/citibike-tripdata_cleaned.csv' 
    (DELIMITER ',', HEADER TRUE, QUOTE '"', ESCAPE '\', NULL_PADDING TRUE, IGNORE_ERRORS TRUE);

COPY central_park_weather FROM 'data/central_park_weather_cleaned.csv' 
    (DELIMITER ',', HEADER TRUE, QUOTE '"', ESCAPE '\', NULL_PADDING TRUE, IGNORE_ERRORS TRUE);

COPY fhv_bases FROM 'data/fhv_bases_cleaned.csv' 
    (FORMAT 'csv', DELIMITER ',', HEADER TRUE, QUOTE '"', ESCAPE '\', NULL 'NULL');
