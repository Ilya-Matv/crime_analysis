# Chicago Crime Analysis

This project analyzes crime data in Chicago using the publicly available dataset in BigQuery. The analysis focuses on finding crime hotspots by calculating the number of crimes within a 1 km radius for each location.

## SQL Query

The SQL query uses the `ST_DISTANCE` function to find the top 10 locations with the most crimes within a 1 km radius.

## Dataset

The dataset used is `bigquery-public-data.chicago_crime.crime`.
