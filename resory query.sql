/*----- Total number and Avgerage Price of different types of resorts -----*/
SELECT COUNT(*) AS 'Total', AVG(Price) AS 'Avg Price'
FROM ski;

SELECT COUNT(*) AS 'Total', AVG(Price) AS 'Avg Price of child-friendly resorts'
FROM ski
WHERE `Child friendly` = 'Yes';

SELECT COUNT(*) AS 'Total', AVG(Price) AS 'Avg Price of nightskiing resorts'
FROM ski
WHERE Nightskiing = 'Yes';

SELECT COUNT(*) AS 'Total', AVG(Price) AS 'Avg Price of snowparks resorts'
FROM ski
WHERE Snowparks = 'Yes';

SELECT COUNT(*) AS 'Total', AVG(Price) AS 'Avg Price of summer-skiing resorts'
FROM ski
WHERE `Summer skiing` = 'Yes';


/*----- Which countries have the most ski resorts? -----*/
Select COALESCE(Continent, 'All resort') AS Continent, # Replace Null values with 'all resorts'
       COALESCE(Country, '/') AS Country,
       Count(*) AS Total,
       Avg(Price) AS AVG_Price
FROM ski
GROUP BY Continent, Country WITH ROLLUP
ORDER BY Continent, Country;

/*----- Which resorts have the highest mountain peaks and elevation changes? -----*/
With peak_rank AS(
SELECT Continent, 
	   Country, 
	   Resort, 
	   `Highest point`,
	   rank()over(partition by Continent order by `Highest point` DESC) AS 'highest_point_continent_rank',
       rank()over(order by `Highest point` DESC) AS 'highest_point_world_rank'
FROM ski
)
SELECT * 
From peak_rank
WHERE highest_point_continent_rank <=5;

With elevation_rank AS(
SELECT Continent, 
	   Country, 
	   Resort, 
	   (`Highest point`-`Lowest point`) AS elevation,
	   rank()over(partition by Continent order by (`Highest point`-`Lowest point`) DESC) AS 'elevation_continent_rank',
       rank()over(order by (`Highest point`-`Lowest point`) DESC) AS 'elevation_world_rank'
FROM ski
)
SELECT * 
From elevation_rank
WHERE elevation_continent_rank <=5;


/*----- What are the best resorts for beginners? What about experts? -----*/
SELECT Continent, Country, Resort, `Beginner slopes`
FROM ski
ORDER BY `Beginner slopes` DESC;

SELECT Continent, Country, Resort, `Intermediate slopes`
FROM ski
ORDER BY `Beginner slopes` DESC;

SELECT Continent, Country, Resort, `Difficult slopes`
FROM ski
ORDER BY `Difficult slopes` DESC;

/*----- How do ski seasons vary by location? Does the snow cover reflect this? -----*/
WITH difficulty AS(
	SELECT ID,
	       Continent, 
		   Country, 
		   Resort,
		   'Beginner slopes' AS 'Difficulty',
			`Beginner slopes` AS 'Total'
	FROM ski
	WHERE `Beginner slopes` IS NOT NULL

	UNION

	SELECT ID,
	       Continent, 
		   Country, 
		   Resort,
		   'Intermediate slopes' AS 'Difficulty',
			`Intermediate slopes` AS 'Total'
	FROM ski
	WHERE `Intermediate slopes` IS NOT NULL

	UNION

	SELECT ID,
	       Continent, 
		   Country, 
		   Resort,
		   'Difficult slopes' AS 'Difficulty',
			`Difficult slopes` AS 'Total'
	FROM ski
	WHERE `Difficult slopes` IS NOT NULL
)

SELECT *
FROM difficulty
ORDER BY ID;