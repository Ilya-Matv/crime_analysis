WITH crime_data AS (
  SELECT 
    latitude,
    longitude,
    block,
    primary_type,
    year
  FROM 
    `bigquery-public-data.chicago_crime.crime`
  WHERE 
    year >=2023  -- Filter for the past year
    AND latitude IS NOT NULL
    AND longitude IS NOT NULL
),
filtered_coordinates AS (
  SELECT 
    latitude,
    longitude,
    block,
    primary_type,
    COUNT(*) AS crime_count
  FROM (
    SELECT 
      *,
      ST_DISTANCE(ST_GEOGPOINT(longitude, latitude), ST_GEOGPOINT(-87.6278, 41.8835)) AS distance
    FROM 
      crime_data
  )
  WHERE distance <= 1000 -- 1 km radius in meters
  GROUP BY 
    latitude, longitude, block, primary_type
  ORDER BY 
    crime_count DESC
)
SELECT * 
FROM filtered_coordinates;
