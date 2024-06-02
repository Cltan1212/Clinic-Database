set serveroutput on;
set echo on;

create or replace PROCEDURE prc_new_enrolment
(
    p_stu_nbr in number,
    p_unit_code in char,
    p_enrol_year in number,
    p_enrol_sem in char,
    p_output out varchar2
)
AS
student_found number;
unit_found number;
enrolment_found number;

BEGIN
select count(*) into student_found
from student 
where stu_nbr = p_stu_nbr;

select count(*) into unit_found
from unit
where unit_code = p_unit_code;

select count(*) into enrolment_found
from enrolment 
where stu_nbr = p_stu_nbr
and unit_code = p_unit_code
and enrol_year = p_enrol_year
and enrol_semester = p_enrol_sem;

if (student_found = 0) THEN
    p_output := 'Invalid student';
ELSE
    if (unit_found = 0) THEN
        p_output := 'Invalid unit';
    ELSE
        if (enrolment_found > 0) THEN
            p_output := 'Enrolment exists';
        ELSE
            insert into enrolment values 
            (p_stu_nbr, p_unit_code, p_enrol_year, p_enrol_sem, null, null);
            p_output := 'New enrolment added';
        END IF;
    END IF;
END IF;

end prc_new_enrolment;
/

-- test harness
-- test case 1
-- fail student not found
-- before
select count(*) from enrolment;
-- during
DECLARE
output varchar2(50);
BEGIN
    prc_new_enrolment('11111129','FIT5057',2021,'1', output);
    dbms_output.put_line(output);
end;
/

-- after
select count(*) from enrolment;

-- test case 2
-- fail student not found
-- before
select count(*) from enrolment;
-- during
DECLARE
output varchar2(50);
BEGIN
    prc_new_enrolment('11111125','FIT5057',2021,'1', output);
    dbms_output.put_line(output);
end;
/

-- after
select count(*) from enrolment;

-- test case 3
-- fail enrolment exist
-- before
select count(*) from enrolment;
-- during
DECLARE
output varchar2(50);
BEGIN
    prc_new_enrolment('11111125','FIT5057',2021,'1', output);
    dbms_output.put_line(output);
end;
/

-- after
select count(*) from enrolment;

-- test case 4
-- success new enrolment
-- before
select count(*) from enrolment;
insert into STUDENT values (11111130,'Bloggs','Fred',to_date('01-FEB-91','DD-MON-YY'),46);
-- during
DECLARE
output varchar2(50);
BEGIN
    prc_new_enrolment('11111130','FIT5057',2021,'1', output);
    dbms_output.put_line(output);
end;
/

-- after
select count(*) from enrolment;

rollback;

create or replace trigger check_student_name
before insert on STUDENT
for each ROW
BEGIN
    if (:new.stu_lname is null and :new.stu_fname is null) then
        raise_application_error(-20000, 'First name or last name is mandatory');
    end if;
END;
/

-- test case 1
-- first name null, last name null
-- pass
-- before
select count(*) from student;
insert into student values (11111140,null,'Andrew',to_date('01-FEB-91','DD-MON-YY'),46);
-- after
select count(*) from student;

-- test case 2
-- first name null, last name null
-- fail
-- before
select count(*) from student;
insert into student values (11111141,null,null,to_date('01-FEB-91','DD-MON-YY'),46);
-- after
select count(*) from student;



-- test harness
create or replace trigger unit_upd_cascade
after update of unit_code on unit 
for each ROW
BEGIN
    update enrolment set unit_code = :new.UNIT_CODE
    where unit_code = :old.unit_code; 
    dbms_output.put_line('Enrolment table has been successfully updated');
end;
/

create or replace trigger maintain_enrolment
after insert or delete on ENROLMENT 
for each ROW
BEGIN
    if inserting THEN 
        update unit 
        set unit_no_student = unit_no_student + 1
        where unit_code = :new.unit_code;
        dbms_output.put_line('Unit table updated');
    end if;

    if deleting THEN 
        update unit 
        set unit_no_student = unit_no_student - 1
        where unit_code = :old.unit_code;
        dbms_output.put_line('Unit table updated');

        insert into audit_log values(audit_seq.nextval, sysdate, user, :old.stu_nbr, :old.unit_code);
        dbms_output.put_line('audit log table has been successfully updated');
    end if;
end;
/