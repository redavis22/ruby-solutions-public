-- #1. The example shows the population of 'France'.
SELECT world.population
  FROM world
 WHERE world.name = 'France';

-- #2. Show the per capita gdp: gdp/population for each country where
-- #the area is over 5,000,000 km2.
SELECT world.name, world.gdp/world.population
  FROM world
 WHERE worldarea > 5000000;

-- #3. Show the name and continent where the area is less then 2000
-- #and the gdp is more than 5000000000.
SELECT world.name, world.continent
  FROM world
 WHERE world.area < 2000
   AND world.gdp > 5000000000;

-- #4. Show the name and the population for 'Denmark', 'Finland',
-- #'Norway', 'Sweden'.
SELECT world.name, world.population
  FROM world
 WHERE world.name IN ('Denmark', 'Finland', 'Norway', 'Sweden');

-- #5. Show each country that begins with G.
SELECT world.name
  FROM world
 WHERE world.name LIKE 'G%';

-- #6. Show the area in 1000 square km. Show area/1000 instead of area.
SELECT world.name, world.area/1000
  FROM world
 WHERE world.area BETWEEN 207600 AND 244820;
