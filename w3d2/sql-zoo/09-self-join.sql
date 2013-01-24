-- #1. How many stops are in the database.

SELECT COUNT(DISTINCT(stop))
  FROM route;

-- #2. Find the id value for the stop 'Craiglockhart'
SELECT id
  FROM stops
 WHERE name = 'Craiglockhart';

-- #3. Give the id and the name for the stops on the '4' 'LRT'
-- #service.
SELECT route.stop, stops.name
  FROM route
  JOIN stops
    ON route.stop = stops.id
 WHERE (route.company, route.num) = ('LRT', 4);

-- #4. The query shown gives the number of routes that visit either
-- #London Road (149) or Craiglockhart (53). Run the query and notice
-- #the two services that link these stops have a count of 2. Add a
-- #HAVING clause to restrict the output to these two routes.
  SELECT route.company, route.num
    FROM route
   WHERE stop IN (149, 53)
GROUP BY route.company, route.num
  HAVING COUNT(*) = 2; -- Must stop at both stops

-- #5. Execute the self join shown and observe that b.stop gives all
-- #the places you can get to from Craiglockhart. Change the query so
-- #that it shows the services from Craiglockhart to London Road.
SELECT r1.company, r1.num, r2.stop, r1.stop
  FROM route r1
  JOIN (SELECT r2.company, r2.num, r2.stop, r2.pos
          FROM route r2
         WHERE r2.stop = 53) AS r2
    ON (r1.company, r1.num) = (r2.company, r2.num)
 WHERE r1.stop = 149;

-- #6. The query shown is similar to the previous one, however by
-- #joining two copies of the stops table we can refer to stops by
-- #name rather than by number. Change the query so that the services
-- #between 'Craiglockhart' and 'London Road' are shown. If you are
-- #tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT r1.company, r1.num, r2.name, s1.name
  FROM route r1
  JOIN stops s1
    ON r1.stop = s1.id
  JOIN (SELECT r2.company, r2.num, s2.name, r2.pos
          FROM route r2
          JOIN stops s2
            ON r2.stop = s2.id
         WHERE s2.name =  'Craiglockhart') AS r2
    ON (r1.company, r1.num) = (r2.company, r2.num)
 WHERE s1.name = 'London Road';

-- #7. Give a list of all the services which connect stops 115 and 137
-- #('Haymarket' and 'Leith')
SELECT r1.company, r1.num
  FROM (SELECT r1.company, r1.num
          FROM route r1
          JOIN stops s1
            ON r1.stop = s1.id
         WHERE s1.name = 'Haymarket') AS r1
  JOIN (SELECT r2.company, r2.num, s2.name
          FROM route r2
          JOIN stops s2
            ON r2.stop = s2.id
         WHERE s2.name = 'Leith') AS r2
    ON (r1.company, r1.num) = (r2.company, r2.num);

-- #8. Give a list of the services which connect the stops
-- #'Craiglockhart' and 'Tollcross'
SELECT r1.company, r1.num
  FROM (SELECT r1.company, r1.num
          FROM route r1
          JOIN stops s1
            ON r1.stop = s1.id
         WHERE s1.name = 'Craiglockhart') AS r1
  JOIN (SELECT r2.company, r2.num, s2.name
          FROM route r2
          JOIN stops s2
            ON r2.stop = s2.id
         WHERE s2.name = 'Tollcross') AS r2
    ON (r1.company, r1.num) = (r2.company, r2.num);
-- Same as before. Guess the last one was supposed to be by number?

-- #9. Give a list of the stops which may be reached from
-- #'Craiglockhart' by taking one bus. Include the details of the
-- #appropriate service.
SELECT r2.stop, r2.name, r2.company, r2.num
  FROM (SELECT r1.company, r1.num
          FROM route r1
          JOIN stops s1
            ON r1.stop = s1.id
         WHERE s1.name = 'Craiglockhart') AS r1
  JOIN (SELECT r2.company, r2.num, r2.stop, s2.name
          FROM route r2
          JOIN stops s2
            ON r2.stop = s2.id) AS r2
    ON (r1.company, r1.num) = (r2.company, r2.num);

-- #10. Show it is possible to get from Sighthill to Craiglockhart.
SELECT hop1.stop1, hop1.company, hop1.num, hop1.stop2, hop2.company, hop2.num, hop2.stop3
  FROM (SELECT route1.stop AS stop1, route1.company, route1.num, route2a.stop AS stop2
          FROM route route1
          JOIN route route2a
            ON (route1.company, route1.num) = (route2a.company, route2a.num)
         WHERE route1.stop = 53) as hop1
  JOIN (SELECT route2b.stop AS stop2, route2b.company, route2b.num, route3.stop AS stop3
          FROM route route2b
          JOIN route route3
            ON (route2b.company, route2b.num) = (route3.company, route3.num)
         WHERE route3.stop = 213) AS hop2
    ON hop1.stop2 = hop2.stop2;
-- This gives a one-transfer journey between the two. This was a hard one!
