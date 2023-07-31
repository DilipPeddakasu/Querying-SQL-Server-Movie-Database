/*
	
	Movie Database  Project - 1

*/
						/* [SECTION - A] */

--1.Write a query to fetch a actor who acted in longest duration movie.

select a.act_fname, a.act_lname from actor a
inner join movie_cast mc on mc.act_id=a.act_id
inner join movie m on m.mov_id=mc.mov_id
and m.mov_time = (select MAX(mov_time) from movie);


--2. How many directors have acted in atleast one movie assuming no actor and  directors have same first names.

select COUNT(d.dir_id) As NoOfDirectors
from actor a 
Inner join movie_cast mc ON mc.act_id=a.act_id
Inner join movie m on m.mov_id = mc.mov_id 
Inner join movie_direction md ON md.mov_id =m.mov_id
inner join director d on d.dir_id=md.dir_id
where a.act_fname = d.dir_fname and a.act_lname = d.dir_lname;


--3.List the first names and last names of male and female actors who have acted together in more than one movie.

select act_fname, act_lname from actor where act_id in 
(select act_id from movie_cast where mov_id in (
select mov_id from movie_cast group by mov_id having count(mov_id)>2));


--4.How many movies are associated with more than one genre.

select COUNT(DISTINCT mov_id) as Mov_With_More_Gens from movie_genres
group by mov_id having COUNT(mov_id) >1;


--5.List 3 female actors who are most frequently casted in action movie genre.

Select a.act_fname, a.act_lname from actor a
inner join movie_cast mc on mc.act_id=a.act_id
Inner join movie_genres mg on mg.mov_id=mc.mov_id
inner join genres g on g.gen_id=mg.gen_id
Where a.act_gender = 'F' and g.gen_title = 'Action';


--6.List all movies which ends with ‘MAN’.

Select mov_title
from movie
where mov_title Like '%Man';


--7.Write a query to display all the actors who didn’t act in any movie the year 2015.

select a.act_fname, a.act_lname from actor a
inner join movie_cast mc on a.act_id = mc.act_id
inner join movie m on m.mov_id=mc.mov_id
where NOT m.mov_year = 2015;


--8.Write a query to fetch movie title with second largest no of rating using windowing function.

with NoOfRating
as
( 
select m.mov_title, r.num_o_ratings, ROW_NUMBER() OVER (order by 
r.num_o_ratings DESC) Rnk
from movie m
inner join rating r on r.mov_id = m.mov_id 
) 
select mov_title from NoOfRating where Rnk = 2;

--9.Create a View with computed column ”Top Rating Flag” along with movie and rating details. Top Rating Flag : When review stars geater than 8 then treated as Y else N

Create view MovieRatings
AS
Select m.mov_id,m.mov_title,r.rev_stars,
CASE
WHEN rev_stars >=8 THEN 'Y'
Else 'N'
END AS TopRatingFlag
from movie m
inner join rating r on r.mov_id = m.mov_id;
select * from MovieRatings;


--10.Create check constraint on rev stars field on rating table to make sure the value is not greater than 10.

ALTER TABLE rating 
ADD CONSTRAINT check_ratings
CHECK (rev_stars <= 10 );


--11.Write a query to fetch a directors who made movies with more than two genres.

select d.dir_fname from director d
inner join movie_direction md on md.dir_id=d.dir_id
inner join movie_genres mg on mg.mov_id=md.mov_id
group by d.dir_fname,mg.mov_id having COUNT(mg.mov_id)>1;


		/* [SECTION - B] */

--Create a Stored procedure to cast a new actorto the movie.
 
Create procedure Cast_Actor_To_Movie
@act_id int,
@mov_id int
As
begin
if exists ( select act_id, mov_id from movie_cast
where act_id = @act_id and mov_id = @mov_id )
print('This Actor is already casted For the movie')
else
insert into movie_cast( act_id, mov_id )
values ( @act_id, @mov_id )
End
Exec Cast_Actor_To_Movie 124,928
Exec Cast_Actor_To_Movie 124,921

