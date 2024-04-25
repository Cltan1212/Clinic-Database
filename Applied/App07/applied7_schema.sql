/*
Databases Applied 7
applied7_schema.sql

student id: 
student name:
last modified date:

*/

-- DDL for Student-Unit-Enrolment model (using ALTER TABLE)
--

--
-- Place DROP commands at head of schema file
--
set echo on
spool applied7_schema_output.txt

drop table enrolment cascade constraints purge; 
drop table student cascade constraints purge; 
drop table unit cascade constraints purge; 
drop table course cascade constraints purge; 
drop table course_unit cascade constraints purge; 

-- drop table student PURGE;
-- drop table unit PURGE;
-- drop table enrolment PURGE;


-- Create Tables
-- Here using both table and column constraints
--

CREATE TABLE student (
    stu_nbr     NUMBER(8) NOT NULL,
    stu_lname   VARCHAR2(50) NOT NULL,
    stu_fname   VARCHAR2(50) NOT NULL,
    stu_dob     DATE NOT NULL
);

COMMENT ON COLUMN student.stu_nbr IS
    'Student number';

COMMENT ON COLUMN student.stu_lname IS
    'Student last name';

COMMENT ON COLUMN student.stu_fname IS
    'Student first name';

COMMENT ON COLUMN student.stu_dob IS
    'Student date of birth';

/* Add STUDENT constraints here */
ALTER TABLE student ADD CONSTRAINT stu_pk PRIMARY KEY (stu_nbr);
ALTER TABLE student ADD CONSTRAINT check_studenet CHECK (stu_nbr > 10000);

/* Add UNIT data types here */
CREATE TABLE unit (
    unit_code   CHAR(7) NOT NULL,
    unit_name   VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN unit.unit_code IS
    'Unit code';

COMMENT ON COLUMN unit.unit_name IS
    'Unit name';

/* Add UNIT constraints here */
ALTER TABLE unit ADD CONSTRAINT  unit_pk PRIMARY KEY (unit_code);
ALTER TABLE unit ADD CONSTRAINT check_unit_name UNIQUE(unit_name);
ALTER TABLE unit ADD unit_credit NUMBER(2);
ALTER TABLE unit 
    MODIFY unit_credit DEFAULT 6;
ALTER TABLE unit 
    ADD CONSTRAINT check_unit_credit CHECK (unit_credit IN (3,6,9));
ALTER TABLE unit ADD course_code CHAR(4);

/* Add ENROLMENT attributes and data types here */
CREATE TABLE enrolment (
    stu_nbr     NUMBER(8) NOT NULL,
    unit_code   CHAR(7) NOT NULL,
    enrol_year  NUMBER(4) NOT NULL,
    enrol_semester  CHAR(1) NOT NULL,
    enrol_mark  NUMBER(3),
    enrol_grade CHAR(2)
    
);

COMMENT ON COLUMN enrolment.stu_nbr IS
    'Student number';

COMMENT ON COLUMN enrolment.unit_code IS
    'Unit code';

COMMENT ON COLUMN enrolment.enrol_year IS
    'Enrolment year';

COMMENT ON COLUMN enrolment.enrol_semester IS
    'Enrolment semester';

COMMENT ON COLUMN enrolment.enrol_mark IS
    'Enrolment mark (real)';

COMMENT ON COLUMN enrolment.enrol_grade IS
    'Enrolment grade (letter)';

/* Add ENROLMENT constraints here */
ALTER TABLE enrolment ADD CONSTRAINT enrol_pk PRIMARY KEY (stu_nbr, unit_code, enrol_year, enrol_semester);
ALTER TABLE enrolment 
    ADD CONSTRAINT enrolment_student_fk FOREIGN KEY (stu_nbr) 
        REFERENCES student (stu_nbr)
            ON DELETE SET NULL;
ALTER TABLE enrolment 
    ADD CONSTRAINT enrolment_UNIT_fk FOREIGN KEY (unit_code) 
        REFERENCES unit (unit_code)
            ON DELETE SET NULL;
ALTER TABLE enrolment
    ADD CONSTRAINT check_enrol_semester
        CHECK (enrol_semester IN (1,2,3));

CREATE TABLE course (
    course_code         CHAR(5) NOT NULL, 
    course_name         VARCHAR2(100) NOT NULL
);

CREATE TABLE course_unit (
    unit_code
    course_code         CHAR(5) NOT NULL, 
    course_totalpoints  NUMBER(3) NOT NULL
    
);

-- composite key

ALTER TABLE course ADD CONSTRAINT course_pk PRIMARY KEY (course_code);
ALTER TABLE unit 
    ADD CONSTRAINT unit_course FOREIGN KEY (course_code) 
        REFERENCES course (course_code)
            ON DELETE SET NULL;

-- rmb comment for every column
COMMENT ON COLUMN course.course_code IS
    'Student number';


spool off
set echo off
