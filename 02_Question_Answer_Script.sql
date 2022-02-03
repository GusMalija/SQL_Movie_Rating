use movie_rating;

-- Question 1
-- Find the titles of all movies directed by Steven Spielberg
select title
from Movie 
where director = 'Steven Spielberg';

-- Question 2
-- Find all years that have a movie that received a rating of 4 or 5, 
-- and sort them in increasing order.
select distinct Movie.year
from Rating left join Movie
on Rating.mID = Movie.MID
where Rating.stars > 3
order by Movie.year;

-- Question 3
-- Find the titles of all movies that have no ratings.
select Movie.title
from Movie left join Rating  
on Movie.mID = Rating.mID
where Rating.stars is null;

-- Question 4
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who 
-- have ratings with a NULL value for the date.
select Reviewer.name
from Reviewer left join Rating 
on Reviewer.rID = Rating.rID
where Rating.ratingDate is null;


-- Question 5
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select Reviewer.name, Movie.title, Rating.stars, Rating.RatingDate
from (Rating left join Reviewer on Rating.rID = Reviewer.rID) left join Movie on Rating.mID = Movie.mID
order by name asc, title asc, stars desc;


-- Question 6
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
-- return the reviewer's name and the title of the movie.

SELECT Reviewer.name, Movie.title
FROM (Rating AS r1 LEFT JOIN Movie ON r1.mID = Movie.mid) LEFT JOIN Reviewer ON r1.rID = Reviewer.rID, Rating AS r2
WHERE r1.rID = r2.rID AND 
    r1.mID = r2.mID AND
    r1.ratingDate > r2.ratingDate AND
    r1.stars > r2.stars;
    

-- QUESTION 7
-- For each movie that has at least one rating, find the highest number of stars that movie received. 
-- Return the movie title and number of stars. Sort by movie title.

select title, max(stars) as stars
from Rating left join Movie 
on Rating.mID = Movie.mID
group by Rating.mID
order by title;

-- QUESTION 8
-- For each movie, return the title and the 'rating spread', that is, 
-- the difference between highest and lowest ratings given to that movie. 
-- Sort by rating spread from highest to lowest, then by movie title.

select title, max(stars) - min(stars) as spread
from Rating left join Movie on Rating.mID = Movie.mID
group by Rating.mID
order by spread desc, title asc;


-- Find the difference between the average rating of movies released before 1980 and 
-- the average rating of movies released after 1980. 
-- (Make sure to calculate the average rating for each movie, then the average of 
-- those averages for movies before 1980 and movies after. 
-- Don't just calculate the overall average rating before and after 1980.)

select AVG(before_1980.avg_per_movie) - AVG(after_1980.avg_per_movie)
from (select avg(stars) AS avg_per_movie
   from Rating left join Movie on Rating.mID = Movie.mID
   where year < 1980
   group by movie.mID) as before_1980,
   (select avg(stars) as avg_per_movie
   from rating left join Movie on Rating.mID = Movie.mID
   where year > 1980
   group by Movie.mID) as after_1980;
