9. Data Analysis.sql

-- ========================================================================
-- Section 6. Filter, sort, and group data
-- ========================================================================
-- Filter and sort trips longer than 1 hour by descending duration
SELECT *
FROM `my-project-sandbox-464408.bike_trips.all_trips_cleaned`
WHERE ride_length > 3600
ORDER BY ride_length DESC;


-- Filter and sort trips from member type by longest to shortest
SELECT *
FROM `my-project-sandbox-464408.bike_trips.all_trips_cleaned`
WHERE member_casual = 'member'
ORDER BY ride_length DESC;

SELECT *
FROM `my-project-sandbox-464408.bike_trips.all_trips_cleaned`
WHERE member_casual = 'casual'
ORDER BY ride_length DESC;


-- Group trips by member type
SELECT
  member_casual,
  COUNT(*) AS total_trips,
  ROUND(AVG(ride_length), 2) AS avg_ride_length,
  MAX(ride_length) AS max_ride_length
FROM
  `my-project-sandbox-464408.bike_trips.all_trips_cleaned`
WHERE
  member_casual = 'member'
GROUP BY
  member_casual
ORDER BY
  avg_ride_length DESC;

SELECT
  member_casual,
  COUNT(*) AS total_trips,
  ROUND(AVG(ride_length), 2) AS avg_ride_length,
  MAX(ride_length) AS max_ride_length
FROM
  `my-project-sandbox-464408.bike_trips.all_trips_cleaned`
WHERE
  member_casual = 'casual'
GROUP BY
  member_casual
ORDER BY
  avg_ride_length DESC;