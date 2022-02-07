use movie_rating;

-- QUESTION 1
-- Find the names of all reviewers who rated Gone with the Wind.
select distinct name 
from Rating left join Reviewer on Rating.rID = Reviewer.rID left join Movie on Rating.mID = Movie.mID
where title = 'Gone with the Wind';

-- QUESTION 2
-- For any rating where the reviewer is the same as the director of the movie, 
-- return the reviewer name, movie title, and number of stars.

select distinct name, title, stars
from Rating left join Reviewer on Rating.rID = Reviewer.rID left join Movie on Rating.mID = Movie.mID
where Reviewer.name = Movie.director;

-- QUESTION 3
-- Return all reviewer names and movie names together in a single list, alphabetized. 
-- (Sorting by the first name of the reviewer and first word in the title is fine; 
-- no need for special processing on last names or removing "The".)
select name from Reviewer
union
select title from Movie 
order by name asc;

-- QUESTION 4
-- Find the titles of all movies not reviewed by Chris Jackson.
select title from Movie 
-- excluding mIDs associated with Chris
where mID not in (
-- returning all mIDs from Rating dataset that match with rIDs then matched to ones
-- in movies dataset by a previous query.
      select Rating.mID
      from Rating left join Reviewer on Rating.rID = Reviewer.rID
      -- extracting ones from Chris
      where name = 'Chris Jackson');
      
-- QUESTION 5
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
-- return the names of both reviewers. Eliminate duplicates, don’t pair reviewers with 
-- themselves, and include each pair only once. For each pair, return the names in the 
-- pair in alphabetical order.

-- splitting reviewer names into two sets to be returned after the query
-- splitting rating and reviewer datasets into two
select distinct rev1.name as reviewer1_name, rev2.name as reviewer2_name
from Rating as rat1, Rating as Rat2, Reviewer as rev1, Reviewer as rev2
-- having same movie from both sets
where rat1.mID = rat2.mID and
-- equating IDS from rating and review sets
      rat1.rID = rev1.rID and
      rat2.rID = rev2.rID and
      -- eliminating duplicates
      rat1.rID != rat2.rID and
      -- avoiding pairing reviewers with themselves
      rev1.name < rev2.name
order by rev1.name, rev2.name;
      
-- QUESTION 6
-- For each rating that is the lowest (fewest stars) currently in the database, 
-- return the reviewer name, movie title, and number of stars.
select name, title, stars
from (Rating left join Reviewer on Rating.rID = Reviewer.rID) left join Movie on Rating.mID = Movie.mID
-- Select associated with min operator to determine the lowest stars
where Rating.stars = (select min(stars) from Rating);

-- QUESTION 7
-- List movie titles and average ratings, from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order.
select Movie.title, avg(stars) as avg_rating
from Rating left join Movie on Rating.mID = Movie.mID
-- Using group by to return a list of avg rating per movie title
-- Picking mIDs from rating because we are interested the stars
group by Rating.mID
-- clustering same ratings in alphabetical order
order by avg_rating desc, Movie.title asc;

-- QUESTION 8
-- Find the names of all reviewers who have contributed three or more ratings. 
select Reviewer.name 
from Rating left join Reviewer on Rating.rID = Reviewer.rID
group by Rating.rID
-- Determining ratings offered based on rID
having count(Rating.rID) >= 3;


-- QUESTION 9
-- Some directors directed more than one movie. For all such directors, return the titles 
-- of all movies directed by them, along with the director name. Sort by director name, 
-- then movie title. 
select title, director
from Movie 
-- to get names of specific directors for more than one movie 
where director in (
      select director from Movie 
      group by director
      having count(*) > 1)
order by director, title;

-- QUESTION 10
-- Find the movie(s) with the highest average rating. 
-- Return the movie title(s) and average rating.
select Movie.title, avg(Rating.stars)
from Rating left join Movie on Rating.mID = Movie.mID
group by Movie.mID
having avg(Rating.stars) = (
     select max(avg_table.avg_stars)
     from (
     select avg(stars) as avg_stars
     from Rating 
     group by mID)
     as avg_table);
     

-- QUESTION 11
-- Find the movie(s) with the lowest average rating. 
-- Return the movie title(s) and average rating
select Movie. title, avg(Rating.stars)
from Rating left join Movie on Rating.mID = Movie.mID
group by Rating.mID
having avg(Rating.stars) = (
-- selecting minimum stars from average table
     select min(avg_table.avg_stars)
     from (
     select avg(stars) as avg_stars
     from Rating 
     group by mID)
     as avg_table);
     

-- QUESTION 12
-- For each director, return the director's name together with the title(s) of the movie(s) 
-- they directed that received the highest rating among all of their movies, 
-- and the value of that rating. Ignore movies whose director is NULL.
select distinct m1.director, m1.title, r1.stars
from Rating as r1 left join Movie as m1 on r1.mID = m1.mID
where m1.director is not null and
-- extracting ones with the highest rating 
	r1.stars in (
        select max(r2.stars)
        from Rating as r2 left join Movie as m2 on r2.mID = m2.mID
        -- to make sure all names are returned, we equate directors. Otherwise only
        -- one would bereturned
        where m2.director is not null and m1.director = m2.director);