-- 7. Data Manipulation.sql

-- Standardization and cleaning data
CREATE OR REPLACE TABLE `my-project-sandbox-464408.bike_trips.all_trips_cleaned` AS
SELECT
  LOWER(TRIM(ride_id)) AS ride_id,
  LOWER(TRIM(rideable_type)) AS rideable_type,
  INITCAP(TRIM(start_station_name)) AS start_station_name,
  INITCAP(TRIM(end_station_name)) AS end_station_name,
  LOWER(TRIM(member_casual)) AS member_casual,
  INITCAP(TRIM(day_of_week)) AS day_of_week,

  -- Other fields
  start_station_id,
  end_station_id,
  ride_length,
  date,
  month,
  day,
  year

FROM `my-project-sandbox-464408.bike_trips.all_trips`;
