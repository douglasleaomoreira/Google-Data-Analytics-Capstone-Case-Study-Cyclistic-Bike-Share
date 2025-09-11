-- 6. Data Combination.sql

-- ========================================================================
-- Section 1. Prepare and preview data
-- ========================================================================
SELECT * 
FROM my-project-sandbox-464408.bike_trips.trips_2019_v3
LIMIT 10;

SELECT * 
FROM my-project-sandbox-464408.bike_trips.trips_2020_v3
LIMIT 10;

-- Create ride ids for trips in 2019
CREATE OR REPLACE TABLE `my-project-sandbox-464408.bike_trips.trips_2019_v3_indexed` AS
SELECT
  CONCAT(CAST(ROW_NUMBER() OVER () AS STRING), "-19") AS ride_id,
  *
FROM `my-project-sandbox-464408.bike_trips.trips_2019_v3`;


-- Create ride ids for trips in 2020
CREATE OR REPLACE TABLE `my-project-sandbox-464408.bike_trips.trips_2020_v3_indexed` AS
SELECT
  CONCAT(CAST(ROW_NUMBER() OVER () AS STRING), "-20") AS ride_id,
  *
FROM `my-project-sandbox-464408.bike_trips.trips_2020_v3`;


-- Change rideable_type format to STRING
CREATE OR REPLACE TABLE `my-project-sandbox-464408.bike_trips.trips_2019_v3_indexed` AS
SELECT
  ride_id,
  CAST(rideable_type AS STRING) AS rideable_type,
  start_station_id,
  start_station_name,
  end_station_id,
  end_station_name,
  member_casual,
  ride_length,
  day_of_week,
  date,
  month,
  day,
  year
FROM `my-project-sandbox-464408.bike_trips.trips_2019_v3_indexed`;


-- ========================================================================
-- Section 2. Join dataframes and create table
-- ========================================================================
-- Join tables
CREATE OR REPLACE TABLE `my-project-sandbox-464408.bike_trips.all_trips` AS
SELECT *
FROM `my-project-sandbox-464408.bike_trips.trips_2019_v3_indexed`

UNION ALL

SELECT *

FROM `my-project-sandbox-464408.bike_trips.trips_2020_v3_indexed`;
