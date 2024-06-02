/*
Databases Applied 11 Class Sample Solution
applied11_plsql_soln.sql

Databases Units
Author: FIT Database Teaching Team
License: Copyright Monash University, unless otherwise stated. All Rights Reserved.
COPYRIGHT WARNING
Warning
This material is protected by copyright. For use within Monash University only. NOT FOR RESALE.
Do not remove this notice.
*/

set serveroutput on

set echo on

--Q1 Insert new enrolment procedure

CREATE OR REPLACE PROCEDURE prc_new_enrolment (
    p_stu_nbr IN NUMBER,
    p_unit_code IN CHAR,
    p_enrol_year IN NUMBER,
    p_enrol_sem IN CHAR,
    p_output OUT VARCHAR2
) IS
    var_stu_nbr_found   NUMBER;
    var_unit_code_found NUMBER;
    var_enrolment_found NUMBER;
BEGIN
    SELECT
        COUNT(*) INTO var_stu_nbr_found
    FROM
        student
    WHERE
        stu_nbr = p_stu_nbr;

    SELECT
        COUNT(*) INTO var_unit_code_found
    FROM
        unit
    WHERE
        upper(unit_code) = upper(p_unit_code);

    IF ( var_stu_nbr_found = 0 ) THEN
        p_output := 'Invalid student number, new enrolment process cancelled';
    ELSE
        IF ( var_unit_code_found = 0 ) THEN
            p_output := 'Invalid unit code, new enrolment process cancelled';
        ELSE
            SELECT
                COUNT(*) INTO var_enrolment_found
            FROM
                enrolment
            WHERE
                upper(unit_code) = upper(p_unit_code)
                AND stu_nbr = p_stu_nbr
                AND enrol_year = p_enrol_year
                AND enrol_semester = p_enrol_sem;
            IF(var_enrolment_found <> 0 ) THEN
                p_output := 'Enrolment exists in the system';
            ELSE
                INSERT INTO enrolment VALUES (
                    p_stu_nbr,
                    p_unit_code,
                    p_enrol_year,
                    p_enrol_sem,
                    NULL,
                    NULL
                );
                p_output := 'The new enrolment for student number '
                            || p_stu_nbr
                            || ' has been recorded';
            END IF;
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_output := SQLERRM;
END;
/

--Test harness
--before value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr = 11111121;

--execute the procedure - invalid student number
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_new_enrolment(21111121, 'FIT9131', 2021, '1', output);
    dbms_output.put_line(output);
END;
/

--after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr = 11111121;

--execute the procedure - invalid unitcode
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_new_enrolment(11111121, 'FIT9999', 2021, '1', output);
    dbms_output.put_line(output);
END;
/

--after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr = 11111121;

--execute the procedure - success
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_new_enrolment(11111121, 'FIT9131', 2021, '1', output);
    dbms_output.put_line(output);
END;
/

--after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr = 11111121;

--execute the procedure - fail, duplicate
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_new_enrolment(11111121, 'FIT9131', 2021, '1', output);
    dbms_output.put_line(output);
END;
/

--after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr = 11111121;

--close the transaction
ROLLBACK;
--End of Test Harness

--Q2 Update enrolment mark
DROP TABLE update_log PURGE;

CREATE TABLE update_log (
    update_id NUMBER(6) NOT NULL,
    update_date DATE NOT NULL,
    update_user VARCHAR2(30) NOT NULL,
    stu_nbr NUMBER(8) NOT NULL,
    unit_code CHAR(7) NOT NULL,
    enrol_year NUMBER(4) NOT NULL,
    enrol_semester CHAR(1) NOT NULL,
    update_prev_mark NUMBER(3) NOT NULL,
    update_new_mark NUMBER(3) NOT NULL
);

COMMENT ON COLUMN update_log.update_id IS
    'Update audit id (unique for each audit)';

COMMENT ON COLUMN update_log.update_date IS
    'Update audit date';

COMMENT ON COLUMN update_log.update_user IS
    'Update audit oracle user';

COMMENT ON COLUMN update_log.stu_nbr IS
    'Updated Student number';

COMMENT ON COLUMN update_log.unit_code IS
    'Updated unit code';

COMMENT ON COLUMN update_log.enrol_year IS
    'Updated enrol year';

COMMENT ON COLUMN update_log.enrol_semester IS
    'Updated enrol semester';

COMMENT ON COLUMN update_log.update_prev_mark IS
    'Update previous mark';

COMMENT ON COLUMN update_log.update_new_mark IS
    'Update new mark';


ALTER TABLE update_log ADD CONSTRAINT update_log_pk PRIMARY KEY ( update_id );

DROP SEQUENCE update_seq;

CREATE SEQUENCE update_seq;

CREATE OR REPLACE PROCEDURE prc_update_enrolment (
    p_stu_nbr IN NUMBER,
    p_unit_code IN CHAR,
    p_enrol_year IN NUMBER,
    p_enrol_sem IN CHAR,
    p_enrol_mark IN NUMBER,
    p_output OUT VARCHAR2
) IS
    var_current_enrol_mark NUMBER;
BEGIN
    
        SELECT
            enrol_mark INTO var_current_enrol_mark
        FROM
            enrolment
        WHERE
            stu_nbr = p_stu_nbr
            AND upper(unit_code) = upper(p_unit_code)
            AND enrol_year = p_enrol_year
            AND enrol_semester = p_enrol_sem;

        UPDATE enrolment
        SET
            enrol_mark = p_enrol_mark
        WHERE
            stu_nbr = p_stu_nbr
            AND upper(unit_code) = upper(p_unit_code)
            AND enrol_year = p_enrol_year
            AND enrol_semester = p_enrol_sem;

        INSERT INTO update_log VALUES (
            update_seq.NEXTVAL,
            sysdate,
            user,
            p_stu_nbr,
            p_unit_code,
            p_enrol_year,
            p_enrol_sem,
            var_current_enrol_mark,
            p_enrol_mark
        );

        p_output := 'The new enrolment mark for student number '
                    || p_stu_nbr
                    || ' has been updated';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_output := 'The new enrolment mark cannot be recorded because the enrolment doesn''t exist';
END;
/

--Test harness
--before value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= 11111121;

SELECT
    *
FROM
    update_log
ORDER BY
    update_id;

--execute the procedure - invalid since the enrolment does not exist
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_update_enrolment(11111121, 'FIT9132', 2021, '1', 60, output);
    dbms_output.put_line(output);
END;
/

--after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= '11111121';

SELECT
    *
FROM
    update_log
ORDER BY
    update_id;

--execute the procedure - success
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_update_enrolment(11111121, 'FIT9131', 2020, '1', 50, output);
    dbms_output.put_line(output);
END;
/

--After value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= '11111121';

SELECT
    *
FROM
    update_log
ORDER BY
    update_id;

--close the transaction
ROLLBACK;
--End of Test Harness

-- Q3. Update cascade on unit_code
CREATE OR REPLACE TRIGGER check_student_name BEFORE
    INSERT ON student FOR EACH ROW
BEGIN
    IF(:new.stu_lname IS NULL AND :new.stu_fname IS NULL) THEN
        raise_application_error(-20000, 'student must have at least one name');
    END IF;
    dbms_output.put_line('A new student named '
    ||trim(:new.stu_fname||' '||:new.stu_lname)||' added to the system');
END;
/

-- Test Harness

-- before value
SELECT
    stu_nbr,
    stu_lname,
    stu_fname,
    to_char(stu_dob, 'DD-MON-YYYY') AS student_dob,
    stu_avg_mark
FROM
    student
ORDER BY
    stu_nbr;

-- test trigger - insert student with no names - failed
BEGIN
    INSERT INTO student VALUES (
        11111130,
        NULL,
        NULL,
        TO_DATE('11-AUG-2007', 'DD-MON-YYYY'),
        NULL
    );
END;
/

-- after value
SELECT
    stu_nbr,
    stu_lname,
    stu_fname,
    to_char(stu_dob, 'DD-MON-YYYY') AS student_dob,
    stu_avg_mark
FROM
    student
ORDER BY
    stu_nbr;

-- test trigger - insert student with only last name - success
BEGIN
    INSERT INTO student VALUES (
        11111131,
        'Mouse',
        NULL,
        TO_DATE('11-AUG-2007', 'DD-MON-YYYY'),
        NULL
    );
END;
/

-- after value
SELECT
    stu_nbr,
    stu_lname,
    stu_fname,
    to_char(stu_dob, 'DD-MON-YYYY') AS student_dob,
    stu_avg_mark
FROM
    student
ORDER BY
    stu_nbr;

-- Test trigger - insert student with only first name - success
BEGIN
    INSERT INTO student VALUES (
        11111132,
        NULL,
        'Mickey',
        TO_DATE('11-AUG-2007', 'DD-MON-YYYY'),
        NULL
    );
END;
/

-- after value
SELECT
    stu_nbr,
    stu_lname,
    stu_fname,
    to_char(stu_dob, 'DD-MON-YYYY') AS student_dob,
    stu_avg_mark
FROM
    student
ORDER BY
    stu_nbr;

-- Close the transaction
ROLLBACK;
-- End of Test Harness

-- Q4. Update cascade on unit_code

CREATE OR REPLACE TRIGGER unit_upd_cascade BEFORE
    UPDATE OF unit_code ON unit FOR EACH ROW
BEGIN
    UPDATE enrolment
    SET
        unit_code = :new.unit_code
    WHERE
        upper(unit_code) = upper(:old.unit_code);
    dbms_output.put_line ('Related unit codes in ENROLMENT have been updated');
END;
/

-- Test Harness

-- before value
SELECT
    *
FROM
    unit
ORDER BY
    unit_code;

SELECT
    *
FROM
    enrolment
ORDER BY
    unit_code,
    stu_nbr,
    enrol_year,
    enrol_semester;

-- Test trigger
BEGIN
    UPDATE unit
    SET
        unit_code = 'FIT9999'
    WHERE
        upper(unit_code) = upper('FIT5057');
END;
/

-- after value
SELECT
    *
FROM
    unit
ORDER BY
    unit_code;

SELECT
    *
FROM
    enrolment
ORDER BY
    unit_code,
    stu_nbr,
    enrol_year,
    enrol_semester;

--close the transaction
ROLLBACK;
--End of Test Harness

-- Q5. Unit Count Maintenance

CREATE OR REPLACE TRIGGER maintain_enrolment AFTER
    INSERT OR
        DELETE ON enrolment FOR EACH ROW
    BEGIN
        IF inserting THEN
            UPDATE unit
            SET
                unit_no_student = unit_no_student + 1
            WHERE
                upper(unit_code) = upper(:new.unit_code);
            dbms_output.put_line ('The number of enrolment of '
                                  ||:new.unit_code
                                  || ' is increased by one');
        END IF;

        IF deleting THEN
            UPDATE unit
            SET
                unit_no_student = unit_no_student - 1
            WHERE
                upper(unit_code) = upper(:old.unit_code);
            dbms_output.put_line ('The number of enrolment of '
                                  ||:old.unit_code
                                  || ' is decreased by one');
            INSERT INTO audit_log VALUES (
                audit_seq.NEXTVAL,
                sysdate,
                user,
                :old.stu_nbr,
                :old.unit_code
            );
            dbms_output.put_line ('The delete has been recorded in audit_log table');
        END IF;
    END;
/

--Test Harness
--before value
SELECT
    *
FROM
    unit
WHERE
    upper(unit_code)=upper('FIT9131');

-- Test trigger - insert
BEGIN
    INSERT INTO enrolment VALUES (
        11111121,
        'FIT9131',
        2021,
        '1',
        NULL,
        NULL
    );
END;
/

--after value
SELECT
    *
FROM
    unit
WHERE
    upper(unit_code)=upper('FIT9131');

-- Test trigger - delete
BEGIN
    DELETE FROM enrolment
    WHERE
        stu_nbr= 11111121
        AND upper(unit_code) = upper('FIT9131')
        AND enrol_semester = '1'
        AND enrol_year = 2021;
END;
/

--after value
SELECT
    *
FROM
    unit
WHERE
    upper(unit_code)=upper('FIT9131');

SELECT
    *
FROM
    audit_log;

--close the  transaction
ROLLBACK;
-- End of Test Harness

-- NOTE the value of the audit_no which was generated by a sequence does not rollback, 
-- once sequences called via nextval must advance to the next available value, no rollback is possible

-- Q6 Maintain student average

CREATE OR REPLACE TRIGGER maintain_student_average AFTER
    UPDATE OF enrol_mark ON enrolment
BEGIN
    UPDATE student
    SET
        stu_avg_mark = (
            SELECT
                AVG(enrol_mark)
            FROM
                enrolment
            WHERE
                stu_nbr = student.stu_nbr
        );
    dbms_output.put_line ('Students'' average mark has been updated');
END;
/

-- Test Harness
-- initial data
-- before value
SELECT
    stu_nbr,
    stu_lname,
    stu_fname,
    to_char(stu_dob, 'DD-MON-YYYY') AS student_dob,
    stu_avg_mark
FROM
    student
WHERE
    stu_nbr= 11111121;

SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr = 11111121;

-- test trigger - update student's FIT5057 mark
BEGIN
    UPDATE enrolment
    SET
        enrol_mark = 60,
        enrol_grade = 'C'
    WHERE
        stu_nbr= 11111121
        AND upper(unit_code) = upper('FIT5057')
        AND enrol_semester = '1'
        AND enrol_year = 2021;
END;
/

--after value
SELECT
    stu_nbr,
    stu_lname,
    stu_fname,
    to_char(stu_dob, 'DD-MON-YYYY') AS student_dob,
    stu_avg_mark
FROM
    student
WHERE
    stu_nbr= 11111121;

SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr = 11111121;

-- close the transaction
ROLLBACK;

-- End of Test Harness

-- Q7. Calculate_grade trigger

CREATE OR REPLACE TRIGGER calculate_grade BEFORE
    INSERT OR UPDATE OF enrol_mark ON enrolment FOR EACH ROW
DECLARE
    final_grade enrolment.enrol_grade%type;
BEGIN
    IF :new.enrol_mark IS NOT NULL THEN
        IF :new.enrol_mark >= 80 THEN
            final_grade := 'HD';
        ELSIF :new.enrol_mark >= 70 AND :new.enrol_mark < 80 THEN
            final_grade := 'D';
        ELSIF :new.enrol_mark >= 60 AND :new.enrol_mark < 70 THEN
            final_grade := 'C';
        ELSIF :new.enrol_mark >= 50 AND :new.enrol_mark < 60 THEN
            final_grade := 'P';
        ELSIF :new.enrol_mark < 50 THEN
            final_grade := 'N';
        END IF;
 -- Note here we are changing the :new value not directly writing to the table
 -- via say an update which would cause a mutating table error
        :new.enrol_grade := final_grade;
        dbms_output.put_line ('A new grade ('
                              ||:new.enrol_grade
                              ||') is recorded');
    END IF;
END;
/

-- Test Harness
-- after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= 11111121;

-- Test Trigger - update - HD
BEGIN
    UPDATE enrolment
    SET
        enrol_mark = 80
    WHERE
        stu_nbr= 11111121
        AND upper(unit_code) = upper('FIT5057')
        AND enrol_semester = '1'
        AND enrol_year = 2021;
END;
/

-- after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= 11111121;

-- Test Trigger - update - D
BEGIN
    UPDATE enrolment
    SET
        enrol_mark = 70
    WHERE
        stu_nbr= 11111121
        AND upper(unit_code) = upper('FIT5057')
        AND enrol_semester = '1'
        AND enrol_year = 2021;
END;
/

SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= 11111121;

-- Test Trigger - update - C
BEGIN    
    UPDATE enrolment
    SET
        enrol_mark = 60
    WHERE
        stu_nbr= 11111121
        AND upper(unit_code) = upper('FIT5057')
        AND enrol_semester = '1'
        AND enrol_year = 2021;
END;
/

-- after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= 11111121;

-- Test Trigger - update - P
BEGIN
    UPDATE enrolment
    SET
        enrol_mark = 50
    WHERE
        stu_nbr= 11111121
        AND upper(unit_code) = upper('FIT5057')
        AND enrol_semester = '1'
        AND enrol_year = 2021;
    END;
/

-- after value
SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= 11111121;

-- Test Trigger - update - N
BEGIN
    UPDATE enrolment
    SET
        enrol_mark = 40
    WHERE
        stu_nbr= 11111121
        AND upper(unit_code) = upper('FIT5057')
        AND enrol_semester = '1'
        AND enrol_year = 2021;
    END;
/

SELECT
    *
FROM
    enrolment
WHERE
    stu_nbr= 11111121;

-- Undo changes - closes transaction
ROLLBACK;

set echo OFF
set serveroutput OFF