
USE VideoGamesDB;
GO

-- =========================
-- Data Validation
-- =========================

-- Query 1: Preview the data
SELECT TOP 10 *
FROM dbo.video_games;

-- Query 2: Count total records
SELECT COUNT(*) AS total_rows
FROM dbo.video_games;

-- Query 3: Calculate total global sales
SELECT 
    CAST(ROUND(SUM(global_sales), 2) AS DECIMAL(10,2)) AS total_global_sales
FROM dbo.video_games;


-- =========================
-- Business Analysis
-- =========================

-- Query 4: Top platforms by global sales
SELECT 
    platform,
    CAST(ROUND(SUM(global_sales), 2) AS DECIMAL(10,2)) AS total_sales
FROM dbo.video_games
GROUP BY platform
ORDER BY total_sales DESC;

-- Query 5: Top genres by global sales
SELECT 
    genre,
    CAST(ROUND(SUM(global_sales), 2) AS DECIMAL(10,2)) AS total_sales
FROM dbo.video_games
GROUP BY genre
ORDER BY total_sales DESC;

-- Query 6: Top 10 publishers by global sales
SELECT TOP 10
    publisher,
    CAST(ROUND(SUM(global_sales), 2) AS DECIMAL(10,2)) AS total_sales
FROM dbo.video_games
GROUP BY publisher
ORDER BY total_sales DESC;

-- Query 7: Top 10 games by global sales
SELECT TOP 10
    game_name,
    CAST(ROUND(SUM(global_sales), 2) AS DECIMAL(10,2)) AS total_sales
FROM dbo.video_games
GROUP BY game_name
ORDER BY total_sales DESC;

-- Query 8: Sales trend by year
WITH yearly_sales AS (
    SELECT 
        release_year,
        SUM(global_sales) AS total_sales
    FROM dbo.video_games
    GROUP BY release_year
),
sales_with_previous_year AS (
    SELECT
        release_year,
        total_sales,
        LAG(total_sales) OVER (ORDER BY release_year) AS previous_year_sales
    FROM yearly_sales
),
yearly_trend AS (
    SELECT
        release_year,
        total_sales,
        previous_year_sales,
        total_sales - previous_year_sales AS sales_change,
        100.0 * (total_sales - previous_year_sales) / NULLIF(previous_year_sales, 0) AS sales_change_percent
    FROM sales_with_previous_year
)
SELECT
    release_year,
    CAST(ROUND(total_sales, 2) AS DECIMAL(10,2)) AS total_sales,
    CAST(ROUND(previous_year_sales, 2) AS DECIMAL(10,2)) AS previous_year_sales,
    CAST(ROUND(sales_change, 2) AS DECIMAL(10,2)) AS sales_change,
    CAST(ROUND(sales_change_percent, 2) AS DECIMAL(10,2)) AS sales_change_percent,
    CASE
        WHEN previous_year_sales IS NULL THEN 'No Previous Year'
        WHEN sales_change > 0 THEN 'Growth'
        WHEN sales_change < 0 THEN 'Decline'
        ELSE 'No Change'
    END AS trend_status
FROM yearly_trend
ORDER BY release_year;


-- =========================
-- Key SQL Insights
-- =========================

-- 1. PS2 is the highest-selling platform by global sales.
-- 2. Action is the best-selling genre globally.
-- 3. Nintendo is one of the leading publishers by total global sales.
-- 4. Wii Sports is the top-selling game in the dataset.
-- 5. Global video game sales peaked around 2008–2009, then declined in later years.


-- =========================
-- SQL Summary
-- =========================

-- This SQL analysis validates the dataset and explores video game sales by platform,
-- genre, publisher, game, and release year. The results identify the strongest market
-- segments and show how sales changed over time.

