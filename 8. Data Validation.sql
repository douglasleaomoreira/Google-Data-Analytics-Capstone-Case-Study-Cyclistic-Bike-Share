8. Data Validation.sql

-- ========================================================================
-- Section 3. Check data structure
-- ========================================================================
-- Query metadata (column names, types, and nullability)
SELECT
  column_name,
  data_type,
  is_nullable
FROM `my-project-sandbox-464408.bike_trips.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'all_trips';


-- List column names
SELECT
  column_name
FROM `my-project-sandbox-464408.bike_trips.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'all_trips';


-- ========================================================================
-- Section 4. Data statistics
-- ========================================================================
-- Quality Statistics by Column
SELECT
  COUNT(*) AS total_rows,

  COUNT(DISTINCT ride_id) AS unique_ride_id,
  COUNTIF(ride_id IS NULL) AS null_ride_id,

  COUNT(DISTINCT rideable_type) AS unique_rideable_type,
  COUNTIF(rideable_type IS NULL) AS null_rideable_type,

  COUNT(DISTINCT start_station_id) AS unique_start_station_id,
  COUNTIF(start_station_id IS NULL) AS null_start_station_id,

  COUNT(DISTINCT start_station_name) AS unique_start_station_name,
  COUNTIF(start_station_name IS NULL) AS null_start_station_name,

  COUNT(DISTINCT end_station_id) AS unique_end_station_id,
  COUNTIF(end_station_id IS NULL) AS null_end_station_id,

  COUNT(DISTINCT end_station_name) AS unique_end_station_name,
  COUNTIF(end_station_name IS NULL) AS null_end_station_name,

  COUNT(DISTINCT member_casual) AS unique_member_casual,
  COUNTIF(member_casual IS NULL) AS null_member_casual,

  COUNT(DISTINCT ride_length) AS unique_ride_length,
  COUNTIF(ride_length IS NULL) AS null_ride_length,

  COUNT(DISTINCT day_of_week) AS unique_day_of_week,
  COUNTIF(day_of_week IS NULL) AS null_day_of_week,

  COUNT(DISTINCT date) AS unique_date,
  COUNTIF(date IS NULL) AS null_date,

  COUNT(DISTINCT month) AS unique_month,
  COUNTIF(month IS NULL) AS null_month,

  COUNT(DISTINCT day) AS unique_day,
  COUNTIF(day IS NULL) AS null_day,

  COUNT(DISTINCT year) AS unique_year,
  COUNTIF(year IS NULL) AS null_year

FROM `my-project-sandbox-464408.bike_trips.all_trips`;


-- Descriptive statistics of the ride_length column (if numeric)
SELECT
  ROUND(MIN(CAST(ride_length AS FLOAT64)), 2) AS min_ride_length,
  ROUND(MAX(CAST(ride_length AS FLOAT64)), 2) AS max_ride_length,
  ROUND(AVG(CAST(ride_length AS FLOAT64)), 2) AS avg_ride_length,
  ROUND(STDDEV(CAST(ride_length AS FLOAT64)), 2) AS stddev_ride_length
FROM `my-project-sandbox-464408.bike_trips.all_trips`;


-- Distribution by member_casual
SELECT
  member_casual,
  COUNT(*) AS total
FROM `my-project-sandbox-464408.bike_trips.all_trips`
GROUP BY member_casual
ORDER BY total DESC;


-- Distribution by day_of_week
SELECT
  day_of_week,
  COUNT(*) AS total
FROM `my-project-sandbox-464408.bike_trips.all_trips`
GROUP BY day_of_week
ORDER BY total DESC;


-- Trip duration
CREATE OR REPLACE TABLE `my-project-sandbox-464408.bike_trips.trip_duration` AS
SELECT
  TRIM(member_casual) AS member_casual,
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ride_id) AS unique_trips,
  COUNTIF(ride_id IS NULL) AS missing_trip_ids,
  ROUND(MIN(ride_length), 2) AS min_tripduration,
  ROUND(MAX(ride_length), 2) AS max_tripduration,
  ROUND(AVG(ride_length), 2) AS avg_tripduration,
  ROUND(STDDEV(ride_length), 2) AS stddev_tripduration,
  APPROX_QUANTILES(ride_length, 2)[OFFSET(1)] AS median_tripduration
FROM 
  `my-project-sandbox-464408.bike_trips.all_trips`
GROUP BY
  TRIM(member_casual)
ORDER BY
  member_casual;
  /*
Note: Function APPROX_QUANTILES(tripduration, 2) has been used once BigQuery doesn’t have a native `MEDIAN()` function for grouped queries. This function splits the values in tripduration into 2 quantiles (i.e., into 3 buckets: minimum, median, and maximum). It returns an `array` of 3 values: [0] minimun, [1] median, and [2] maximum. [OFFSET(1)] tells BigQuery to retrieve the second element of the `array`
*/


-- ========================================================================
-- Section 5. Clean the data
-- ========================================================================
-- Check for missing values
SELECT
  COUNTIF(ride_id IS NULL) AS ride_id_nulls,
  COUNTIF(rideable_type IS NULL) AS rideable_type_nulls,
  COUNTIF(start_station_id IS NULL) AS start_station_id_nulls,
  COUNTIF(start_station_name IS NULL) AS start_station_name_nulls,
  COUNTIF(end_station_id IS NULL) AS end_station_id_nulls,
  COUNTIF(end_station_name IS NULL) AS end_station_name_nulls,
  COUNTIF(member_casual IS NULL) AS member_casual_nulls,
  COUNTIF(ride_length IS NULL) AS ride_length_nulls,
  COUNTIF(day_of_week IS NULL) AS day_of_week_nulls,
  COUNTIF(date IS NULL) AS date_nulls,
  COUNTIF(month IS NULL) AS month_nulls,
  COUNTIF(day IS NULL) AS day_nulls,
  COUNTIF(year IS NULL) AS year_nulls
FROM `my-project-sandbox-464408.bike_trips.all_trips`;


-- Check for duplicate rows
SELECT
  *,
  COUNT(*) AS duplicate_count
FROM `my-project-sandbox-464408.bike_trips.all_trips`
GROUP BY
  ride_id,
  rideable_type,
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
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Check needing trim whitespace
SELECT
  COUNT(*) AS total_rows,

  -- ride_id
  COUNTIF(TRIM(ride_id) != ride_id) AS values_needing_trim_ride_id,
  COUNTIF(TRIM(ride_id) = ride_id) AS already_trimmed_ride_id,

  -- rideable_type
  COUNTIF(TRIM(rideable_type) != rideable_type) AS values_needing_trim_rideable_type,
  COUNTIF(TRIM(rideable_type) = rideable_type) AS already_trimmed_rideable_type,

  -- day_of_week
  COUNTIF(TRIM(day_of_week) != day_of_week) AS values_needing_trim_day_of_week,
  COUNTIF(TRIM(day_of_week) = day_of_week) AS already_trimmed_day_of_week,

  -- start_station_name
  COUNTIF(TRIM(start_station_name) != start_station_name) AS values_needing_trim_start_station_name,
  COUNTIF(TRIM(start_station_name) = start_station_name) AS already_trimmed_start_station_name,

  -- end_station_name
  COUNTIF(TRIM(end_station_name) != end_station_name) AS values_needing_trim_end_station_name,
  COUNTIF(TRIM(end_station_name) = end_station_name) AS already_trimmed_end_station_name,

  -- member_casual
  COUNTIF(TRIM(member_casual) != member_casual) AS values_needing_trim_member_casual,
  COUNTIF(TRIM(member_casual) = member_casual) AS already_trimmed_member_casual

FROM `my-project-sandbox-464408.bike_trips.all_trips`;