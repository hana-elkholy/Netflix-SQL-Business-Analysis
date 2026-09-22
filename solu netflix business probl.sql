create database netflix_db1;
use netflix_db1;

SELECT * FROM netflix;

-- exploratory dataset

select count(*) as total_content from netflix;
select distinct (type) from netflix;

-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems

-- 1. Count the number of Movies vs TV Shows

select type,count(*) as count
from netflix
group by type
order by count desc;

-- 2. Find the most common rating for movies and TV shows

SELECT TOP 1 WITH TIES
    type,
    rating,
    COUNT(*) AS total_count
FROM netflix
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY ROW_NUMBER() OVER (
    PARTITION BY type
    ORDER BY COUNT(*) DESC
);

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
WHERE release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix

SELECT TOP 5  
    LTRIM(RTRIM(SplitCountry.value)) AS country, COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(netflix.country, ',') AS SplitCountry
WHERE netflix.country IS NOT NULL
GROUP BY LTRIM(RTRIM(SplitCountry.value))
ORDER BY total_content DESC;

 -- 5. Identify the longest movie

SELECT TOP 1 title,duration FROM netflix
WHERE type = 'Movie'
  AND duration LIKE '%min%' -- filter on min 
ORDER BY TRY_CAST(REPLACE(duration, ' min', '') AS INT) DESC ;

-- 6. Find content added in the last 5 years

SELECT title,date_added FROM netflix
WHERE date_added BETWEEN '2017-01-01' AND '2021-12-31'
ORDER BY date_added DESC;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT netflix.*
FROM netflix
CROSS APPLY STRING_SPLIT(director, ',') AS splitdirector
WHERE LTRIM(RTRIM(splitdirector.value)) = 'Rajiv Chilaka';  

--8. List all TV shows with more than 5 seasons

SELECT * FROM netflix
WHERE type = 'TV Show' AND TRY_CAST(REPLACE(duration, ' seasons', '') AS INT) > 5;

-- 9. Count the number of content items in each genre

select LTRIM(RTRIM(split.value)) as listed_in ,count(*) as countt
from netflix 
cross apply string_split(listed_in,',') as split 
GROUP BY LTRIM(RTRIM(split.value))
order by countt desc;

-- 10.Find each year and the average numbers of content release in India on netflix.
-- return top 5 year with highest avg content release !

select top 5 country,release_year,count(*) as numbers_of_content
from netflix
where country ='India'
group by release_year,country
order by numbers_of_content desc;

--11. List all movies that are documentaries

select netflix.*,ltrim(rtrim(split.value)) as genre
from netflix
cross apply string_split(listed_in,',') as split
where type='Movie' and 
ltrim(rtrim(split.value))='Documentaries' ; 

--12. Find all content without a director

SELECT *
FROM netflix
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT *
FROM netflix
WHERE type = 'Movie'
  AND cast LIKE '%Salman Khan%'
  AND release_year BETWEEN 2012 AND 2021;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select top 10 trim(ltrim(split.value)) as actor , count(*) as movie_count 
from netflix
cross apply string_split(cast,',')as split 
where type='Movie' and country='India'
group by  trim(ltrim(split.value))
order by movie_count desc ;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

SELECT 
    CASE
        WHEN description LIKE '%kill%'
          OR description LIKE '%violence%'
        THEN 'Bad'
        ELSE 'Good'
    END AS category, COUNT(*) AS count
FROM netflix
GROUP BY
    CASE
        WHEN description LIKE '%kill%'
          OR description LIKE '%violence%'
        THEN 'Bad'
        ELSE 'Good'
    END;