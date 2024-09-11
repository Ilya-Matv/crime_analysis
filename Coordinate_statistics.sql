WITH crime_data AS (
  SELECT 
    latitude,
    longitude,
    block,
    primary_type,
    location_description,
    year
  FROM 
    `bigquery-public-data.chicago_crime.crime`
  WHERE 
    year >= 2023
    AND latitude IS NOT NULL
    AND longitude IS NOT NULL
),
filtered_coordinates AS (
  SELECT 
    location_description,
    primary_type,
    COUNT(*) AS crime_count
  FROM (
    SELECT 
      *,
      ST_DISTANCE(ST_GEOGPOINT(longitude, latitude), ST_GEOGPOINT(-87.627876698, 41.883500187)) AS distance
    FROM 
      crime_data
  )
  WHERE distance <= 1000 -- 1 km radius in meters
  GROUP BY 
    location_description, primary_type
  ORDER BY 
    crime_count DESC
)
SELECT 
  location_description, 
  primary_type, 
  crime_count
FROM 
  filtered_coordinates
LIMIT 10;
