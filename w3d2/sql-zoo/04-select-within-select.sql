-- #1. List each country name where the population is larger than
-- #'Russia'.
SELECT w1.name
  FROM world w1
 WHERE w1.population > (SELECT w2.population
                          FROM world w2
                         WHERE w2.name = 'Russia');

-- #2. List the name and continent of countries in the continents
-- #containing 'Belize', 'Belgium'.
--
-- This kind of subquery is called an 'uncorrelated' subquery, and is
-- fast, because it doesn't need to be re-executed for each row in the
-- outer query.
SELECT world.name, world.continent
  FROM world
 WHERE world.continent IN (SELECT w2.continent 
                             FROM world w2
                            WHERE w2.name IN ('Belize', 'Belgium'));

-- #3. Show the countries in Europe with a per capita GDP greater than
-- #'United Kingdom'.
SELECT world.name
  FROM world
 WHERE world.continent = 'Europe'
   AND (world.gdp / world.population) > (
         SELECT w2.gdp/w2.population
           FROM world w2
          WHERE w2.name = 'United Kingdom');

-- #4. Which country has a population that is more than Canada but
-- #less than Poland? Show the name and the population.
SELECT world.name, world.population
  FROM world
 WHERE world.population > (SELECT w2.population FROM world w2 WHERE w2.name = 'Canada')
   AND world.population < (SELECT w2.population FROM world w2 WHERE w2.name = 'Poland');

-- #5. Which countries have a GDP greater than any country in Europe?
-- #[Give the name only.]
SELECT world.name
  FROM world
 WHERE world.gdp > (SELECT MAX(w2.gdp)
                      FROM world w2
                     WHERE w2.continent = 'Europe');

-- #6. Find the largest country in each continent, show the continent,
-- #the name and the population.
SELECT w1.continent, w1.name, w1.population
  FROM world w1
 WHERE w1.population = (SELECT MAX(w2.population)
                         FROM world w2
                        WHERE w1.continent = w2.continent)

-- #7. Find each country that belongs to a continent where all
-- #populations are less than 25000000. Show name, continent and
-- #population.
SELECT w1.name, w1.continent, w1.population
  FROM world w1
 WHERE w1.continent NOT IN (SELECT w2.continent
                              FROM world w2
                             WHERE w2.population >= 25000000)

-- #8. Some countries have populations more than three times that of
-- #any of their neighbours (in the same continent). Give the
-- #countries and continents.

-- Damn you, Cote d'Ivoire! They didn't report pop. If w1.population
-- IS NULL, then 3 * w2.population >= w1.population is never true, so
-- a country with an unregistered population looks big...
SELECT name, continent
  FROM world w1
 WHERE w1.population IS NOT NULL 
   AND (SELECT COUNT(*)
          FROM world w2
         WHERE w1.continent = w2.continent
           AND w1.name != w2.name -- got me!
           AND 3 * w2.population >= w1.population) = 0;
