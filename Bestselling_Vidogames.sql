/*view data from both the tables*/ 

SELECT * FROM Reviews;
SELECT * FROM game_sales;

-- Select all information for the top ten best-selling games
-- Order the results from best-selling game down to tenth best-selling
SELECT * FROM game_Sales
ORDER BY Total_Shipped DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

--Missing review scores

-- Join games_sales and reviews
-- Select a count of the number of games where both critic_score and user_score are nullSELECT COUNT(g.game)
--Method-1
SELECT COUNT(Game_name) FROM game_sales
LEFT JOIN reviews
ON game_Sales.Game_name=Reviews.Name

WHERE Critic_Score IS Null AND  USer_Score IS NUll;

--Method-2
SELECT COUNT(g.Game_name)
FROM game_sales g
LEFT JOIN reviews r
ON g.game_name = r.name
WHERE r.critic_score IS NULL AND r.user_score IS NULL;


--Years that video game critics loved

-- Select release year and average critic score for each year, rounded and aliased
-- Join the game_sales and reviews tables
-- Group by release year
-- Order the data from highest to lowest avg_critic_score and limit to 10 results
SELECT game_Sales.Year,ROUND(AVG(reviews.critic_score),1) AS Avg_critic_Score 
FROM game_Sales
LEFT JOIN reviews
ON game_Sales.Game_name= reviews.Name
GROUP BY game_Sales.Year
ORDER BY Avg_critic_score DESC
OFFSET 0 ROWS 
FETCH NEXT 10 ROWS ONLY;

/*Paste your query from the previous task; update it to add a count 
of games released in each year called num_games
Update the query so that it only returns years that have more than four reviewed games*/

SELECT game_Sales.Year,ROUND(AVG(reviews.critic_score),1) AS Avg_critic_Score,
COUNT(game_sales.Game_name) AS game_Count
FROM game_Sales
INNER JOIN reviews
ON game_Sales.Game_name= reviews.Name
GROUP BY game_Sales.Year
HAVING COUNT(game_sales.Game_name)>4
ORDER BY Avg_critic_score DESC
OFFSET 0 ROWS 
FETCH NEXT 10 ROWS ONLY

--Years that dropped off the critics' favorites list

CREATE TABLE top_critic_years
(
Year INT,
avg_critic_score FLOAT
)
-- inserting data

INSERT INTO		top_critic_years(Year,avg_critic_score)
SELECT game_Sales.Year,ROUND(AVG(reviews.critic_score),1) AS avg_critic_Score 
FROM game_Sales
LEFT JOIN reviews
ON game_Sales.Game_name= reviews.Name
GROUP BY game_Sales.Year
ORDER BY Avg_critic_score DESC
OFFSET 0 ROWS 
FETCH NEXT 10 ROWS ONLY;    
SELECT * FROM top_critic_years


--create table top_critic_years_more_than_four_games

DROP TABLE Top_critic_years_more_than_four_game;
CREATE TABLE Top_critic_years_more_than_four_game
(
Year INT,
avg_critic_score FLOAT,
game_count  INT
)

--INSERTING VALUE
INSERT INTO Top_critic_years_more_than_four_game(Year,avg_critic_score,game_count)
SELECT game_Sales.Year,ROUND(AVG(reviews.critic_score),1) AS Avg_critic_Score,
COUNT(game_sales.Game_name) AS game_Count
FROM game_Sales
INNER JOIN reviews
ON game_Sales.Game_name= reviews.Name
GROUP BY game_Sales.Year
HAVING COUNT(game_sales.Game_name)>4
ORDER BY Avg_critic_score DESC
OFFSET 0 ROWS 
FETCH NEXT 10 ROWS ONLY;

SELECT * FROM Top_critic_years_more_than_four_game

-- Years video game players loved

--Select the year and avg_critic_score for those years that dropped off the list of critic favorites 
-- Order the results from highest to lowest avg_critic_score
SELECT 
    year,avg_critic_score
FROM top_critic_years
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_years_more_than_four_game
ORDER BY avg_critic_score DESC;

-- Select year, an average of user_score, and a count of games released in a given year, aliased and rounded
-- Include only years with more than four reviewed games; group data by year
-- Order data by avg_user_score, and limit to ten results
SELECT TOP 10
    g.year,
    COUNT(g.Game_name) AS num_games,
    ROUND(AVG(r.user_score), 2) AS avg_user_score  
FROM game_sales g
INNER JOIN reviews r
ON g.Game_name = r.Name
GROUP BY g.year
HAVING COUNT(g.Game_name) > 4
ORDER BY avg_user_score DESC;
