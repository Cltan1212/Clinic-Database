/*
Databases Applied 10
applied10_sql_advanced.sql

student id: 33402973
student name: Tan Chun Ling
last modified date: 9 May 2024
*/

SPOOL output.txt
SET LINESIZE 300

--1
select stuid, 
stufname || ' ' || stulname as "full name",
studob
from uni.STUDENT natural join uni.enrolment
where upper(unitcode) = upper('FIT9132')
and studob = 
(
    select min(studob)
    from uni.STUDENT natural join uni.enrolment
    where upper(unitcode) = upper('FIT9132')
)
order by stuid;


--2
select unitcode, ofsemester, count(stuid) as total
from uni.enrolment 
where to_char(ofyear, 'yyyy') = 2019
group by unitcode, ofsemester
having count(stuid) =
(
    select max(count(stuid))
    from uni.enrolment 
    where to_char(ofyear, 'yyyy') = 2019
    group by unitcode, ofsemester
)
order by unitcode, ofsemester;



--3
select stufname || ' ' || stulname as "full name",
enrolmark
from uni.STUDENT natural join uni.enrolment
where upper(unitcode) = 'FIT3157' and ofsemester = 1 
and to_char(ofyear,'yyyy') = 2020
and enrolmark > 
(
    select avg(enrolmark)
    from uni.STUDENT natural join uni.enrolment
    where upper(unitcode) = 'FIT3157' and ofsemester = 1 and to_char(ofyear,'yyyy') = 2020
)
order by enrolmark desc, "full name";


--4
select unitcode, unitname,
to_char(ofyear, 'yyyy') as year,
ofsemester, enrolmark,
case upper(enrolgrade)
    when 'N' then 'Fail'
    when 'P' then 'Pass'
    when 'C' then 'Credit'
    when 'D' then 'Distinction'
    when 'HD' then 'High Distinction'
end as explained_grade
from uni.UNIT natural join uni.STUDENT natural join uni.ENROLMENT
where upper(stufname) = upper('Claudette') and upper(stulname) = upper('Serman')
order by year, ofsemester, unitcode;

--5
select staffid, stafffname, stafflname, ofsemester,
count(clno) as "numberclasses",
CASE
    when count(clno) > 2 then 'Overload'
    when count(clno) = 2 then 'Correct load'
    when count(clno) < 2 then 'Underload'
end as load 
from uni.schedclass natural join uni.staff 
where to_char(ofyear,'yyyy') = 2019
group by staffid, stafffname, stafflname, ofsemester 
order by "numberclasses" desc, staffid, ofsemester; 


--6



--7
/* Using outer join */
select unitcode, unitname --, count(prerequnitcode) 
from uni.unit natural left join uni.prereq
group by unitcode, unitname
having count(prerequnitcode) = 0
order by unitcode;

/* Using set operator MINUS */
select unitcode, unitname from uni.unit 
minus 
select unitcode, unitname from uni.unit natural join uni.prereq
order by unitcode;

/* Using subquery */
select unitcode, unitname from uni.unit 
where unitcode not in 
(
    select unitcode from uni.prereq
)
order by unitcode;

--8



--9



--10



--11
-- select L as 'Lecture' from uni.prereq;

(
    select staffid, 
    stafffname || ' ' || stafflname as STAFFNAME,
    'Lecture' as type,
    count(clno),
    sum(clduration) as TOTAL_HOURS,
    lpad(to_char(sum(clduration) * 75.60, '$900.00'), 14, ' ') as WEEKLY_PAYMENT
    from uni.schedclass natural join uni.staff 
    where upper(cltype) = 'L' and ofsemester = 1 and to_char(ofyear, 'yyyy') = 2020
    group by staffid, stafffname || ' ' || stafflname, cltype
)

union

(   
    select staffid, 
    stafffname || ' ' || stafflname as STAFFNAME,
    'Tutorial' as type,
    count(clno),
    sum(clduration) as TOTAL_HOURS,
    lpad(to_char(sum(clduration) * 75.60, '$900.00'), 14, ' ') as WEEKLY_PAYMENT
    from uni.schedclass natural join uni.staff 
    where upper(cltype) = 'T' and ofsemester = 1 and to_char(ofyear, 'yyyy') = 2020
    group by staffid, stafffname || ' ' || stafflname, cltype
)

order by staffid, type;

--12


    
--13


spool off

