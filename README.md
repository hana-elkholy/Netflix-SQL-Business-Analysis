# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](netflix.png)

## Overview

This project involves analyzing Netflix movies and TV shows data using SQL Server. The goal is to solve different business problems and extract useful insights from the dataset.

## Objectives

- Analyze the distribution of Movies and TV Shows.
- Identify the most common ratings.
- Analyze content by release year, country, genre, and duration.
- Explore actors and directors.
- Analyze Indian content and releases.
- Categorize content based on keywords in the description.

## Dataset

The dataset contains information about Netflix Movies and TV Shows, including:

- Show ID
- Type
- Title
- Director
- Cast
- Country
- Date Added
- Release Year
- Rating
- Duration
- Listed In
- Description

## Business Problems & Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type,count(*) as count
FROM netflix
GROUP BY type
ORDER BY count desc;


### 2. Find the most common rating for movies and TV shows

```sql
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

### 3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
WHERE release_year = 2020
