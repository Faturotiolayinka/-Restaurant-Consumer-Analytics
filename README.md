🍽️ Restaurant Consumer Analytics
This project explores consumer behavior and restaurant performance using SQL. The dataset includes tables on consumer preferences, consumer details, restaurant information, ratings, and cuisine types. The goal is to derive meaningful insights about preferences, top-rated cuisines, restaurant rankings, and consumer loyalty.

📂 Dataset Structure
Table Name	Description
consumer_preferences	Contains each consumer’s preferred cuisine.
consumers	Stores consumer demographic information.
ratings	Records restaurant ratings provided by consumers.
restaurant_cuisines	Lists the cuisine(s) associated with each restaurant.
restaurants	Holds the restaurant name and basic info.

🛠️ Data Cleaning
Before running queries, character encoding issues were fixed using ALTER TABLE:

--- 
``` Fixing misencoded column names
ALTER TABLE consumer_preferences RENAME COLUMN ï»¿Consumer_ID TO Consumer_ID;
ALTER TABLE consumers RENAME COLUMN ï»¿Consumer_ID TO Consumer_ID;
ALTER TABLE ratings RENAME COLUMN ï»¿Consumer_ID TO Consumer_ID;
ALTER TABLE restaurant_cuisines RENAME COLUMN ï»¿Restaurant_ID TO Restaurant_ID;
ALTER TABLE restaurants RENAME COLUMN ï»¿Restaurant_ID TO Restaurant_ID;```


📊 SQL Queries & Business Insights
1. ⭐ Most Preferred Cuisine by Consumers
 
SELECT Preferred_Cuisine, COUNT(*) AS counts
FROM consumer_preferences
GROUP BY Preferred_Cuisine
ORDER BY counts DESC
LIMIT 1;
Identifies the most popular cuisine overall.

2. 🏆 Top 5 Restaurants by Average Rating
SELECT Name, AVG(Overall_Rating) AS Avg_rating
FROM ratings rt
JOIN restaurants rs ON rt.Restaurant_ID = rs.Restaurant_ID
GROUP BY Name
ORDER BY Avg_rating DESC
LIMIT 5;
Ranks restaurants based on customer satisfaction.

3. 👥 Consumers Who Rated More Than 5 Restaurants
SELECT rt.Consumer_ID, COUNT(DISTINCT Restaurant_ID) AS rated_restaurants
FROM ratings rt
GROUP BY rt.Consumer_ID
HAVING COUNT(DISTINCT Restaurant_ID) > 5
ORDER BY rated_restaurants DESC;
Detects highly active and loyal users.

4. 🍛 Restaurants and Their Primary Cuisine
SELECT Name, Cuisine
FROM restaurants rs
JOIN restaurant_cuisines rc ON rs.Restaurant_ID = rc.Restaurant_ID
GROUP BY Name, Cuisine
ORDER BY Cuisine;
Matches restaurant names with their cuisine types.

5. 🧠 Top-Rated Cuisines by Each Consumer
SELECT c.Consumer_ID, Cuisine, MAX(Overall_Rating) AS top_rating
FROM ratings rt
JOIN consumers c ON rt.Consumer_ID = c.Consumer_ID
JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
GROUP BY c.Consumer_ID, Cuisine
ORDER BY top_rating DESC;
Matches consumers' best-rated cuisines with actual cuisine types.

6. 🔍 Most Reviewed Restaurant
SELECT r.Name, COUNT(DISTINCT Consumer_ID) AS Num_Raters
FROM restaurants r
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Name
ORDER BY Num_Raters DESC
LIMIT 1;
Shows which restaurant attracted the most attention.

7. 🥇 Restaurant Ranking by Cuisine
SELECT r.Name, rc.Cuisine, ROUND(AVG(Overall_Rating),2) AS Avg_rating,
       RANK() OVER (PARTITION BY rc.Cuisine ORDER BY AVG(Overall_Rating) DESC) AS cuisine_rank
FROM restaurants r
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rt ON rt.Restaurant_ID = rc.Restaurant_ID
GROUP BY r.Name, rc.Cuisine
ORDER BY rc.Cuisine, cuisine_rank;
Ranks restaurants within each cuisine type.

8. ❤️ Consumers Who Favor Their Preferred Cuisine
SELECT DISTINCT c.Consumer_ID, Name
FROM ratings rt
JOIN consumers c ON rt.Consumer_ID = c.Consumer_ID
JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN consumer_preferences cp ON c.Consumer_ID = cp.Consumer_ID
WHERE rt.Overall_Rating >= 2;
Finds consumers who consistently rate their preferred cuisine highly.

✍️ Author
Faturoti Olayinka
Data Analyst | SQL Enthusiast | Educator
