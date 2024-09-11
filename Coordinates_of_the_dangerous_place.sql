WITH crime_locations AS (
  SELECT 
    latitude, 
    longitude, 
    block,
    primary_type,
    COUNT(*) OVER() AS crime_count
  FROM 
    `bigquery-public-data.chicago_crime.crime`
  WHERE 
    latitude IS NOT NULL 
    AND longitude IS NOT NULL
    AND year >= 2023 -- Filter for year
),
-- Calculate distances between crimes
crime_clusters AS (
  SELECT 
    c1.latitude AS lat, 
    c1.longitude AS lon,
    c1.block AS block,
    c1.primary_type AS crime_type,
    COUNT(c2.primary_type) AS crimes_within_radius
  FROM 
    crime_locations AS c1
  JOIN 
    crime_locations AS c2
  ON 
    ST_DISTANCE(ST_GEOGPOINT(c1.longitude, c1.latitude), 
                ST_GEOGPOINT(c2.longitude, c2.latitude)) <= 1000 -- calculates the geographical 1 km radius between two points
  GROUP BY 
    lat, lon, block, crime_type
)
-- Get top 10 locations with most crimes within a 1 km radius
SELECT 
  lat, lon, block, crimes_within_radius, crime_type
FROM 
  crime_clusters
ORDER BY 
  crimes_within_radius DESC
  
LIMIT 1;
