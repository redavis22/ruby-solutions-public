-- #1. List the films where the yr is 1962 [Show id, title]

SELECT movie.id, movie.title
  FROM movie
 WHERE movie.yr = 1962;

-- #2. Give year of 'Citizen Kane'.

SELECT movie.yr
  FROM movie
 WHERE movie.title = 'Citizen Kane';

-- #3. List all of the Star Trek movies, include the id, title and yr
-- #(all of these movies include the words Star Trek in the
-- #title). Order results by year.

  SELECT movie.id, movie.title, movie.yr
    FROM movie
   WHERE movie.title LIKE '%Star Trek%'
ORDER BY movie.yr;


-- #4. What are the titles of the films with id 11768, 11955, 21191.

SELECT movie.title
  FROM movie
 WHERE movie.id IN (11768, 11955, 21191);

-- #5. What id number does the actor 'Glenn Close' have?

SELECT actor.id
  FROM actor
 WHERE actor.name = 'Glenn Close';

-- #6. What is the id of the film 'Casablanca'

SELECT movie.id
  FROM movie
 WHERE movie.title = 'Casablanca';

-- #7. Obtain the cast list for 'Casablanca'. Use the id value that
-- #you obtained in the previous question.

SELECT actor.name
  FROM actor
  JOIN casting
    ON casting.actorid = actor.id
  JOIN movie
    ON movie.id = casting.movieid
 WHERE movie.title = 'Casablanca';

-- #8. Obtain the cast list for the film 'Alien'.

SELECT actor.name
  FROM actor
  JOIN casting
    ON casting.actorid = actor.id
  JOIN movie
    ON movie.id = casting.movieid
 WHERE movie.title = 'Alien';

-- #9. List the films in which 'Harrison Ford' has appeared

SELECT movie.title
  FROM movie
  JOIN casting
    ON casting.movieid = movie.id
  JOIN actor
    ON actor.id = casting.actorid
 WHERE actor.name = 'Harrison Ford';

-- #10. List the films where 'Harrison Ford' has appeared - but not in
-- #the star role. [Note: the ord field of casting gives the position
-- #of the actor. If ord=1 then this actor is in the starring role]

SELECT movie.title
  FROM movie
  JOIN casting
    ON casting.movieid = movie.id
  JOIN actor
    ON actor.id = casting.actorid
 WHERE actor.name = 'Harrison Ford'
   AND casting.ord != 1;

-- #11. List the films together with the leading star for all 1962 films.

SELECT movie.title, actor.name
  FROM movie
  JOIN casting
    ON casting.movieid = movie.id
  JOIN actor
    ON actor.id = casting.actorid
 WHERE movie.yr = 1962
   AND casting.ord = 1;

-- #12. Which were the busiest years for 'John Travolta', show the
-- #year and the number of movies he made each year for any year in
-- #which he made at least 2 movies.

SELECT movie.yr, COUNT(*)
  FROM movie
  JOIN casting
    ON casting.movieid = movie.id
  JOIN actor
    ON actor.id = casting.actorid
 WHERE actor.name = 'John Travolta'
 GROUP BY movie.yr
HAVING COUNT(*) > 1;

-- #13. List the film title and the leading actor for all of 'Julie
-- #Andrews' films.

SELECT m1.title, a1.name
  FROM (SELECT movie.*
          FROM movie
          JOIN casting
            ON casting.movieid = movie.id
          JOIN actor
            ON actor.id = casting.actorid
         WHERE actor.name = 'Julie Andrews') AS m1
  JOIN (SELECT actor.*, casting.movieid AS movieid
          FROM actor
          JOIN casting
            ON casting.actorid = actor.id
         WHERE casting.ord = 1) as a1
    ON m1.id = a1.movieid;

-- #14. Obtain a list of actors in who have had at least 30 starring
-- #roles.

SELECT actor.name
  FROM actor
  JOIN casting
    ON casting.actorid = actor.id
  JOIN movie
    ON movie.id = casting.movieid
 WHERE casting.ord = 1
 GROUP BY actor.id
HAVING COUNT(*) >= 30;

-- #15. List the 1978 films by order of cast list size.

SELECT movie.title, COUNT(*)
  FROM movie
  JOIN casting
    ON casting.movieid = movie.id
  JOIN actor
    ON actor.id = casting.actorid
 WHERE movie.yr = 1978
 GROUP BY movie.id
 ORDER BY COUNT(*) DESC;

-- #16. List all the people who have worked with 'Art Garfunkel'.

SELECT a1.name
  FROM (SELECT movie.*
          FROM movie
          JOIN casting
            ON casting.movieid = movie.id
          JOIN actor
            ON actor.id = casting.actorid
         WHERE actor.name = 'Art Garfunkel') AS m1
  JOIN (SELECT actor.*, casting.movieid
          FROM actor
          JOIN casting
            ON casting.actorid = actor.id
         WHERE casting.ord = 1) as a1
    ON m1.id = a1.movieid;
