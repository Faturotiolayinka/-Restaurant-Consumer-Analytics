SELECT * FROM consumer_preferences;
select * from consumers;
select * from ratings;
select * from restaurant_cuisines;
select * from restaurants;

alter table consumer_preferences
rename column ï»¿Consumer_ID to Consumer_ID;

alter table consumers
rename column ï»¿Consumer_ID to Consumer_ID;

alter table ratings
rename column ï»¿Consumer_ID to Consumer_ID;

alter table restaurant_cuisines
rename column ï»¿Restaurant_ID to Restaurant_ID;

alter table restaurants
rename column ï»¿Restaurant_ID to Restaurant_ID;

-- 1. Which cuisine is most preferred by consumers overall?
select  Preferred_Cuisine, 
count(Preferred_Cuisine) as counts 
from consumer_preferences
group by Preferred_Cuisine
order by counts desc
limit 1;

-- 2 Top 5 restaurants with the highest average ratings
select Name, avg(Overall_Rating) as Avg_rating
from ratings rt join restaurants rs
on rt.Restaurant_ID = rs.Restaurant_ID
group by Name order by Avg_rating desc
limit 5;

-- 3 Find consumers who have rated more than 5 different restaurants
SELECT rt.consumer_id,  COUNT(DISTINCT restaurant_id) AS rated_restaurants
FROM ratings rt
JOIN consumers c ON rt.consumer_id = c.consumer_id
GROUP BY consumer_id
HAVING COUNT(DISTINCT restaurant_id) > 5
order by rated_restaurants desc;

-- 4 List all restaurants along with their primary cuisine
select Name, Cuisine 
from restaurants rs join restaurant_cuisines rc
on rs.Restaurant_ID = rc.Restaurant_ID
group by Name, Cuisine order by Cuisine asc;

-- 5 Match consumers’ top-rated cuisine with their preferences 
SELECT c.Consumer_ID, Cuisine, MAX(Overall_Rating) AS top_rating
FROM ratings rt
JOIN consumers c ON rt.Consumer_ID = c.Consumer_ID
JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
GROUP BY Consumer_ID, Cuisine
ORDER BY top_rating DESC;
 
-- 6 Which restaurant has the most diverse set of consumer ratings?
select r.Name,  count(distinct Consumer_ID) Num_Raters
from restaurants r 
join ratings rt on r.Restaurant_ID = rt.Restaurant_ID
group by r.Name 
order by Num_Raters desc
limit 1;

-- 7 Rank restaurants within each cuisine by average rating
select   r.Name, rc.Cuisine,  round(avg(Overall_Rating),2) Avg_rating,
RANK() OVER (PARTITION BY rc.Cuisine ORDER BY AVG(Overall_Rating) DESC) AS cuisine_rank
from restaurants r 
join restaurant_cuisines rc on r.Restaurant_ID = rc.Restaurant_ID
join ratings rt on rt.Restaurant_ID = rc.Restaurant_ID
group by r.Name, Cuisine 
order by Avg_rating;

-- 8 Find consumers whose ratings consistently match their preferences (rated high for preferred cuisines only)
SELECT DISTINCT c.Consumer_ID, Name
FROM ratings rt
JOIN consumers c ON rt.Consumer_ID = c.Consumer_ID
JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN consumer_preferences cp ON c.Consumer_ID = cp.Consumer_ID  
WHERE rt.Overall_Rating >= 2;