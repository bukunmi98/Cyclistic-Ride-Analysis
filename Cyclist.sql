
----------------------------------------------------------------------------------------------------------
-- Total number of rides by weekday

SELECT member_casual, DATENAME(WEEKDAY, started_at) AS week_day, COUNT(*) AS num_of_ride
FROM cyclistic_trip
GROUP BY member_casual, DATENAME(WEEKDAY, started_at);



-- Total number of rides by weekday  in a month


SELECT member_casual,  DATENAME(MONTH, started_at) AS ride_month, DATENAME(WEEKDAY, started_at) AS week_day, COUNT(*) AS num_of_ride
FROM cyclistic_trip
GROUP BY  DATENAME(WEEKDAY, started_at), DATENAME(MONTH, started_at), member_casual
ORDER BY 1,2; 


----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- Number of rides in a month

SELECT member_casual,  DATENAME(MONTH, started_at) AS ride_month,  count(*)  AS num_of_ride
FROM cyclistic_trip
GROUP BY  member_casual, DATENAME(MONTH, started_at)
ORDER BY 2,1; 


----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- Average Number of rides in a week

SELECT  total_ride.member_casual, total_ride.ride_month, AVG(total_ride.num_of_ride) AS average_num_of_ride
FROM
(SELECT member_casual, DATENAME(WEEKDAY, started_at) AS week_day,  DATENAME(MONTH, started_at) AS ride_month, count(*)  as num_of_ride
FROM cyclistic_trip
GROUP BY DATENAME(WEEKDAY, started_at),  DATENAME(MONTH, started_at), member_casual) AS total_ride
GROUP BY total_ride.member_casual, total_ride.ride_month
ORDER BY 2,1;

-- Average Number of rides in month

with new_day as (
SELECT member_casual,  DATENAME(MONTH, started_at) AS ride_month, count(*)  AS num_of_ride 
FROM cyclistic_trip
GROUP BY  member_casual, DATENAME(MONTH, started_at)
)
select member_casual, avg(num_of_ride) as avergae_num_ride
from new_day
GROUP BY member_casual;

----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- total Number of ride

SELECT  member_casual, COUNT(*) AS total_ride
FROM cyclistic_trip
GROUP BY member_casual

----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- Total number of rideable bike 

SELECT  member_casual, rideable_type, COUNT(*) AS total_num_rides
FROM cyclistic_trip
GROUP BY member_casual, rideable_type
ORDER BY 2;

-- Total number of rideable bike in a month

SELECT  member_casual, DATENAME(MONTH, started_at) AS ride_month, rideable_type, COUNT(*) AS total_num_rides
FROM cyclistic_trip
GROUP BY member_casual, rideable_type,  DATENAME(MONTH, started_at)
ORDER BY 2, 1;

----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- Total number of ride by hour

SELECT member_casual, DATENAME(HOUR, started_at) AS ride_hour, count(*)  AS num_of_ride 
FROM cyclistic_trip
GROUP BY member_casual, DATENAME(HOUR, started_at)
ORDER BY 2,1 DESC


-- Total number of ride by hour in a month 

SELECT member_casual, DATENAME(MONTH, started_at) AS week_month,  DATENAME(HOUR, started_at) AS ride_hour, count(*)  AS num_of_ride 
FROM cyclistic_trip
GROUP BY member_casual, DATENAME(MONTH, started_at), DATENAME(HOUR, started_at)
ORDER BY 2,3 DESC

----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
-- Total number of ride by hour
SELECT (DATEDIFF( SECOND, ride_length.started_at, ride_length.ended_at) / 60) hello --CAST(ride_length.ended_at AS time),  CAST(ride_length.started_at AS time)
FROM
(SELECT member_casual, SUBSTRING(CAST( started_at AS nvarchar ),12, 8) AS started_at, SUBSTRING(CAST(ended_at AS nvarchar ),12, 8) AS ended_at 
FROM cyclistic_trip) AS ride_length
GROUP BY member_casual
HAVING  (DATEDIFF( SECOND, ride_length.started_at, ride_length.ended_at) / 60) < 1 --CAST(ride_length.ended_at AS time),  CAST(ride_length.started_at AS time) < 1




SELECT moshi_2.member_casual, AVG(moshi_2.date_stand_by) AS MINUTE
FROM
(SELECT moshi.member_casual, SUBSTRING(TRIM(moshi.starting), 1, 5), SUBSTRING(moshi.ending, 1, 5), DATEDIFF( MINUTE, moshi.starting, moshi.ending) date_stand_by --,
--CASE
--    WHEN moshi.starting > moshi.ending  THEN DATEDIFF( MINUTE, moshi.ending, moshi.starting)
--    WHEN moshi.ending >= moshi.starting THEN DATEDIFF( MINUTE, moshi.starting, moshi.ending)
--ELSE DATEDIFF( MINUTE, moshi.starting, moshi.ending)
--END AS time_up
FROM
(SELECT  member_casual, started_at, ended_at, LTRIM(RIGHT(CONVERT(VARCHAR(20), started_at, 100), 7)) starting, LTRIM(RIGHT(CONVERT(VARCHAR(20), ended_at, 100), 7)) ending
FROM cyclistic_trip)  AS moshi) AS moshi_2
GROUP BY moshi_2.member_casual
