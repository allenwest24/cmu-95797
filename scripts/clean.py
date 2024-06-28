import pandas as pd
import csv

# Preprocess citibike-tripdata.csv
citibike_df = pd.read_csv('data/citibike-tripdata.csv', dtype=str)
citibike_df.to_csv('data/citibike-tripdata_cleaned.csv', index=False)

# Preprocess central_park_weather.csv
weather_df = pd.read_csv('data/central_park_weather.csv', dtype=str)
weather_df.to_csv('data/central_park_weather_cleaned.csv', index=False)

# Preprocess original fhv_bases.csv
fhv_bases_df = pd.read_csv('data/fhv_bases.csv', quotechar='"', escapechar='\\', dtype=str)
# Ensure all columns are treated as strings and handle missing values
fhv_bases_df = fhv_bases_df.astype(str).fillna('')
fhv_bases_df.to_csv('data/fhv_bases_cleaned.csv', index=False, quoting=csv.QUOTE_NONNUMERIC, escapechar='\\', doublequote=False)
