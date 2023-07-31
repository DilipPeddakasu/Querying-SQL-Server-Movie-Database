/*
	
	Movie Database  Project - 2

*/

-- 1.Write a query to list the Horror movies.

select m.mov_title from Movie m
inner join movie_genres mg on m.mov_id=mg.mov_id
inner join genres g on g.gen_id=mg.gen_id 
where gen_title= 'Horror';


-- 2.Write a query to list the name of reviewers who have rated 8 or more stars.

select ra.rev_stars, r.rev_name from reviewer r 
inner join rating ra on r.rev_id=ra.rev_id 
where ra.rev_stars>=8;


-- 3.Write a query to list the information of the actors who palyed a role in the movie Deliverance.

select a.act_id, CONCAT(act_fname, ',', act_lname) as act_name, a.act_gender from actor a 
inner join movie_cast mc on a.act_id = mc.act_id 
inner join movie m on mc.mov_id = m.mov_id
where m.mov_title = 'Deliverance';


-- 4.Write a query to find the name of the director(First and last name) who directed a movie that casted a role for 'Eyes Wide Shut'.(Using subquery)

select CONCAT(dir_fname,',',dir_lname) as dir_name from director
where dir_id in ( select dir_id from movie_direction where mov_id 
in( select mov_id from movie where mov_title='Eyes Wide Shut'));


-- 5.Write a query to find the movie title, year, date of release, director and actor for those movies which reviewer is 'Neal Wruck'. 

Select m.mov_title, m.mov_year, m.mov_dt_rel, CONCAT(act_fname, ',', act_lname) as 
act_name,
CONCAT(d.dir_fname,',',d.dir_lname) as dir_name, rv.rev_name from movie m
left join rating ra on m.mov_id=ra.mov_id 
left join Reviewer rv on rv.rev_id=ra.rev_id
left join movie_cast mc on m.mov_id = mc.mov_id 
left join Actor a on mc.act_id=a.act_id 
left join movie_direction md on md.mov_id=m.mov_id 
left join director d on md.dir_id=d.dir_id 
where rv.rev_name ='Neal Wruck';


-- 6.write a query to find all the years which produced at least one movie and that recieved a rating of more than 4 stars.

Select Distinct mov_year 
From movie m inner join rating r on m.mov_id = r.mov_id and rev_stars>4
Order by mov_year;


-- 7.write a query to find the name of all movies who have rated their ratings null value.

Select mov_title From movie m
INNER JOIN rating r on m.mov_id = r.mov_id
Where rev_stars IS NULL;


-- 8.Write a query to find the name of movies who were directed by 'David'.

select mov_title from movie m
inner join movie_direction md on m.mov_id=md.mov_id
inner join director d on d.dir_id=md.dir_id
Where dir_fname='David';


-- 9.Write a query to list the first and last names of all the actors who were cast in the movie 'Boogie Nights', and the roles they played in that production.

select a.act_fname, a.act_lname, mc.role from actor a
inner join movie_cast mc on a.act_id=mc.act_id
inner join movie m on m.mov_id=mc.mov_id
where mov_title='Boogie Nights';


-- 10.Find the name of the actor who have worked in more than one movie.

select a.act_fname, a.act_lname
from actor a inner join movie_cast mc on a.act_id=mc.act_id
group by a.act_id,a.act_fname, a.act_lname having count(mc.act_id)>1;


