/*
Databases Applied 09
applied9_sql_basic_intermediate.sql

student id: 
student name:
applied class number:
last modified date:

*/

/* Part A - Retrieving data from a single table */

-- A1


-- A2


-- A3
select stuid, stulname, stufname, stuaddress
from uni.STUDENT
where upper(STULNAME) like 'S%'
and lower(STUFNAME) like '%i%'
order by stuid;

-- A4


-- A5
select ofyear from uni.enrolment;

-- A6

select stuid, unitcode, ENROLMARK
from uni.enrolment
where enrolmark < 50
and ofsemester = 2
and to_char(ofyear, 'yyyy') = 2021
order by stuid, unitcode;


/* Part B - Retrieving data from multiple tables */

-- B1
select unitcode, ofsemester, stafffname, STAFFLNAME
from uni.offering natural join uni.STAFF
where to_char(ofyear, 'yyyy') = 2021
order by OFSEMESTER, UNITCODE;

select unitcode, ofsemester, stafffname, STAFFLNAME
from uni.offering natural join uni.STAFF using(staffid)
where to_char(ofyear, 'yyyy') = 2021
order by OFSEMESTER, UNITCODE;

select unitcode, ofsemester, stafffname, STAFFLNAME
from uni.offering natural join uni.STAFF on uni.OFFERING.STAFFID = uni.STAFF.staffid
where to_char(ofyear, 'yyyy') = 2021
order by OFSEMESTER, UNITCODE;

select unitcode, ofsemester, stafffname, STAFFLNAME
from uni.offering o join uni.STAFF s on o.STAFFID = s.staffid
where to_char(ofyear, 'yyyy') = 2021
order by OFSEMESTER, UNITCODE;
-- B2
select stuid, 
stufname || ' ' || stulname as "student name", 
--stufname || ' ' || stulname as studentname,
unitcode, unitname
from uni.student natural join uni.ENROLMENT natural join uni.UNIT
where OFSEMESTER = 1 and to_char(ofyear, 'yyyy') = 2021
order by unitname, stuid;

-- B3
select unitcode, OFSEMESTER, cltype, CLDAY,
to_char(cltime, 'hh:miAM') as time,
CLDURATION * 60 as "duration (in minutes)"
from uni.SCHEDCLASS natural join uni.staff 
where to_char(ofyear, 'yyyy') = 2021
and upper(stafffname) = upper('Windham') and upper(stafflname) = upper('Ellard')
order by unitcode, ofsemester;

-- B4
select unitcode, unitname, OFSEMESTER,
to_char(ofyear, 'yyyy') as year,
nvl(to_char(enrolmark, '990'), 'N/A') as ENROLMARK,
nvl(ENROLGRADE, 'N/A') as enrolgrade
from uni.UNIT natural join uni.ENROLMENT natural join uni.student
where upper(STUFNAME) = upper('Brier') and upper(STULNAME) = upper('Kilgour')
order by ofyear, OFSEMESTER, unitcode;


-- B5
select u.UNITCODE, u.UNITNAME, p.PREREQUNITCODE, u1.UNITNAME as prereqname
from uni.PREREQ p join uni.unit u on p.UNITCODE = u.UNITCODE
join uni.unit u1 on p.PREREQUNITCODE = u1.UNITCODE;

-- B6


-- B7


-- B8



/* Part C - Aggregate Function, Group By and Having */

-- C1
select to_char(ofyear, 'yyyy') as year, ofsemester, 
to_char(avg(enrolmark), '990.00') as AVERAGE
from uni.ENROLMENT
where unitcode = 'FIT9136'
group by to_char(ofyear, 'yyyy') , OFSEMESTER
order by year, OFSEMESTER
-- C2


-- C3


-- C4


-- C5
select unitcode, ofsemester, count(stuid) as total
from uni.ENROLMENT
where to_char(ofyear, 'yyyy') = 2019
group by unitcode, OFSEMESTER
order by total, unitcode, OFSEMESTER;

-- C6


-- C7

