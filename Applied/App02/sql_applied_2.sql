-- Retrieve all student details
select * from student; 

-- Display all students who live in Moorabbin
select *
from student
where studaddress like '%Moorabbin%';

-- Display all students
select studfname, studlname
from student
where studaddress like '%Moorabbin%';