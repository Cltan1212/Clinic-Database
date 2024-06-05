--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T5-pf-plsql.sql

--Student ID:
--Student Name:

/* Comments for your marker:
-===== a =====-
- 1 Create the trigger for service
    - Before because we need to check the cost of before insert and update 
- 2 Test harness
    - a Insert with a valid line cost
    - b Insert with a invalid line cost (> 1.1)
    - c Update with a valid line cost 
    - d Update with a invalid line cost (< 0.9)
    - e Delete visit service

-===== b =====-
- 1 Create the procedure for inserting follow up visit 
- 2 Test harness
    - a Insert with a valid visit
    - b Insert with a invalid visit (invalid date)
*/


--(a)
--Write your trigger statement,
--finish it with a slash(/) followed by a blank line

-- 1
CREATE OR REPLACE TRIGGER check_service_cost
BEFORE INSERT OR UPDATE ON visit_service
FOR EACH ROW
DECLARE
    v_standard_cost     NUMBER(6,2);
    v_min_cost          NUMBER(6,2);
    v_max_cost          NUMBER(6,2);
BEGIN
    SELECT service_std_cost INTO v_standard_cost
    FROM service
    WHERE service_code = :NEW.service_code;

    v_min_cost := v_standard_cost * 0.90;
    v_max_cost := v_standard_cost * 1.10;

    IF :NEW.visit_service_linecost < v_min_cost OR :NEW.visit_service_linecost > v_max_cost THEN
        RAISE_APPLICATION_ERROR(-20001, 'Visit service line cost must be within 10% of the standard cost.');
    END IF;
END;
/

-- 2a
-- before value
SELECT * FROM visit WHERE visit_id = 1;

-- execute the procedure - insert with valid visit service
BEGIN
    INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
    VALUES (1, 'S003', 72.00);
END;
/

-- after value
SELECT * FROM visit WHERE visit_id = 1;

-- 2b
-- before value
SELECT * FROM visit WHERE visit_id = 1;

-- execute the procedure - insert with valid visit service
BEGIN
    INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
    VALUES (1, 'S003', 80.00);
END;
/

-- after value
SELECT * FROM visit WHERE visit_id = 1;

-- 2c
-- before value
SELECT * FROM visit WHERE visit_id = 1;

-- execute the procedure - update with valid visit service
BEGIN
    UPDATE visit_service 
    SET visit_service_linecost = 74.00
    WHERE visit_id = 1 and service_code = 'S003';
END;
/

-- 2d
-- before value
SELECT * FROM visit WHERE visit_id = 1;

-- execute the procedure - update with invalid visit service
BEGIN
    UPDATE visit_service 
    SET visit_service_linecost = 60.00
    WHERE visit_id = 1 and service_code = 'S003';
END;
/

-- after value
SELECT * FROM visit WHERE visit_id = 1;

-- 2e
-- before value
SELECT * FROM visit WHERE visit_id = 1;

-- execute the procedure - delete visit service
BEGIN
    DELETE FROM
        visit_service
    WHERE
        visit_id = 1 and service_code = 'S003';
END;
/

-- after value
SELECT * FROM visit WHERE visit_id = 1;

--(b)
-- Complete the procedure below
-- 1
CREATE OR REPLACE PROCEDURE prc_followup_visit (
    p_prevvisit_id      IN NUMBER,
    p_newvisit_datetime IN DATE,
    p_newvisit_length   IN NUMBER,
    p_output            OUT VARCHAR2
) IS
    v_visit_date_time   DATE;
    v_animal_id         NUMBER(5);
    v_vet_id            NUMBER(4);
    v_clinic_id         NUMBER(2);
    v_service_code      CHAR(5);
    v_service_cost      NUMBER(6,2);
BEGIN
    BEGIN
        SELECT  visit_date_time, animal_id, vet_id, clinic_id 
        INTO    v_visit_date_time, v_animal_id, v_vet_id, v_clinic_id
        FROM    visit
        WHERE   visit_id = p_prevvisit_id; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_output := 'Previous visit not found';
            RETURN;
        END;

    IF p_newvisit_datetime IS NULL OR p_newvisit_datetime <= v_visit_date_time THEN
        p_output := 'Invalid date provided';
        RETURN;
    END IF;

    SELECT  service_code, service_std_cost 
    INTO    v_service_code, v_service_cost
    FROM    service
    WHERE   UPPER(service_desc) = UPPER('General Consultation');

    INSERT INTO 
        visit (visit_id, visit_date_time, visit_length, animal_id, vet_id, clinic_id, from_visit_id)
    VALUES (
        visit_seq.NEXTVAL,
        p_newvisit_datetime,
        p_newvisit_length,
        v_animal_id,
        v_vet_id,
        v_clinic_id,
        p_prevvisit_id
    ); 

    INSERT INTO
        visit_service (visit_id, service_code, visit_service_linecost)
    VALUES
        (visit_seq.CURRVAL, v_service_code, v_service_cost);

    p_output := 'Follow-up visit created successfully with ID: ' || visit_seq.CURRVAL;

EXCEPTION
    WHEN OTHERS THEN
        p_output := 'Error occurred: ' || SQLERRM;
END prc_followup_visit;
/

-- Write Test Harness for (b)
-- 2a 
-- before value
SELECT 
    * 
FROM
    visit;

-- execute the procedure: with valid data
DECLARE
    v_output VARCHAR2(100);
BEGIN
    prc_followup_visit(
        p_prevvisit_id => 1,  
        p_newvisit_datetime => TO_DATE('27/01/24 10:00AM', 'DD/MM/YY HH:MiAM'),  
        p_newvisit_length => 60,  
        p_output => v_output
    );
    DBMS_OUTPUT.PUT_LINE(v_output);
END;
/

-- after value
SELECT 
    * 
FROM
    visit;


-- 2b
-- before value
SELECT 
    * 
FROM
    visit;

-- execute the procedure: with invalid data (invalid date)
DECLARE
    v_output VARCHAR2(100);
BEGIN
    prc_followup_visit(
        p_prevvisit_id => 1,  
        p_newvisit_datetime => TO_DATE('27/01/23 10:00AM', 'DD/MM/YY HH:MiAM'),  
        p_newvisit_length => 60,  
        p_output => v_output
    );
    DBMS_OUTPUT.PUT_LINE(v_output);
END;
/

-- after value
SELECT 
    * 
FROM
    visit;

COMMIT;