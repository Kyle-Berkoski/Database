----------------------------------------------------------------------------------------
-- Courses and Prerequisites
-- by Alan G. Labouseur
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------

--
-- The table of courses.
--
DROP TABLE IF EXISTS Prerequisites;
DROP TABLE IF EXISTS Courses;

create table Courses (
    num      integer not null,
    name     text    not null,
    credits  integer not null,
  primary key (num)
);


insert into Courses(num, name, credits)
values (499, 'CS/ITS Capping', 3 );

insert into Courses(num, name, credits)
values (308, 'Database Systems', 4 );

insert into Courses(num, name, credits)
values (221, 'Software Development Two', 4 );

insert into Courses(num, name, credits)
values (220, 'Software Development One', 4 );

insert into Courses(num, name, credits)
values (120, 'Introduction to Programming', 4);

/*select * 
from courses
order by num ASC;
*/

--
-- Courses and their prerequisites
--
create table Prerequisites (
    courseNum integer not null references Courses(num),
    preReqNum integer not null references Courses(num),
  primary key (courseNum, preReqNum)
);

insert into Prerequisites(courseNum, preReqNum)
values (499, 308);

insert into Prerequisites(courseNum, preReqNum)
values (499, 221);

insert into Prerequisites(courseNum, preReqNum)
values (308, 120);

insert into Prerequisites(courseNum, preReqNum)
values (221, 220);

insert into Prerequisites(courseNum, preReqNum)
values (220, 120);

		

--
-- An example stored procedure ("function")
--
create or replace function get_courses_by_credits(int, REFCURSOR) returns refcursor as 
$$
declare
   num_credits int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
      select num, name, credits
      from   courses
       where  credits >= num_credits;
   return resultset;
end;
$$ 
language plpgsql;

select get_courses_by_credits(0, 'results');
Fetch all from results;


-- Number 1
create or replace function PreReqsFor(int, refcursor) returns refcursor as 
$$
declare
   crse      	int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
   select prereqnum
   from   Prerequisites
   where  courseNum = crse;
return resultset;
end;
$$ 
language plpgsql;

select PreReqsFor(221, 'results');
Fetch all from results;


-- Number 2
create or replace function IsPreReqFor(int, REFCURSOR) returns refcursor as 
$$
declare
prereq      	int       := $1;
resultset 	  REFCURSOR := $2;
begin
   open resultset for 
   select coursenum
   from   Prerequisites
   where  prereq=prereqnum;
return resultset;
end;
$$ 
language plpgsql;

select IsPreReqFor(220, 'results');
Fetch all from results;