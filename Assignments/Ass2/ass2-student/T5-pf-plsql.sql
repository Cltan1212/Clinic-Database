--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T5-pf-plsql.sql

--Student ID:
--Student Name:

/* Comments for your marker:


*/


--(a)
--Write your trigger statement,
--finish it with a slash(/) followed by a blank line

-- trigger to check the service cost
CREATE OR REPLACE TRIGGER check_service_cost
BEFORE INSERT OR UPDATE OR DELETE ON visit_service
FOR EACH ROW
DECLARE
    v_standard_cost service.service_std_cost%TYPE;
    v_min_cost NUMBER(6,2);
    v_max_cost NUMBER(6,2);
BEGIN
    -- Retrieve the standard cost of the visit_service if not deleting
    IF INSERTING OR UPDATING THEN
        SELECT service_std_cost INTO v_standard_cost
        FROM service
        WHERE service_code = :NEW.service_code;

        -- Calculate the min and max allowable cost
        v_min_cost := v_standard_cost * 0.90;
        v_max_cost := v_standard_cost * 1.10;

        -- Check if the visit service line cost is within the allowed range
        IF :NEW.visit_service_linecost < v_min_cost OR :NEW.visit_service_linecost > v_max_cost THEN
            RAISE_APPLICATION_ERROR(-20001, 'Visit service line cost must be within 10% of the standard cost.');
        END IF;
    END IF;

    -- Handle inserting, updating, and deleting
    IF INSERTING THEN
        UPDATE visit
        SET
            visit_total_cost = visit_total_cost + :NEW.visit_service_linecost
        WHERE
            visit_id = :NEW.visit_id;
        dbms_output.put_line ('The visit service has been inserted');
    ELSIF UPDATING THEN
        UPDATE visit
        SET
            visit_total_cost = visit_total_cost - :OLD.visit_service_linecost + :NEW.visit_service_linecost
        WHERE
            visit_id = :NEW.visit_id;
        dbms_output.put_line ('The visit service has been updated');
    ELSIF DELETING THEN
        UPDATE visit
        SET
            visit_total_cost = visit_total_cost - :OLD.visit_service_linecost
        WHERE
            visit_id = :OLD.visit_id;
        dbms_output.put_line ('The visit service has been deleted');
    END IF;
END;
/

-- Write Test Harness for (a) -- invalid value?

-- INSERT
-- before value
SELECT 
    * 
FROM
    visit
WHERE
    visit_id = 1;

-- Test trigger - insert 
BEGIN
    INSERT INTO visit_service (visit_id, service_code, visit_service_linecost)
    VALUES (1, 'S003', 75.00);
END;
/

-- after value
SELECT 
    * 
FROM
    visit
WHERE
    visit_id = 1;

-- UPDATE
-- before value
SELECT 
    * 
FROM
    visit
WHERE
    visit_id = 1;

-- Test trigger - update 
BEGIN
    UPDATE visit_service 
    SET visit_service_linecost = 74.00
    WHERE visit_id = 1 and service_code = 'S003';
END;
/

-- after value
SELECT 
    * 
FROM
    visit
WHERE
    visit_id = 1;

-- DELETE
-- before value
SELECT 
    * 
FROM
    visit
WHERE
    visit_id = 1;

-- Test trigger - insert 
BEGIN
    DELETE FROM
        visit_service
    WHERE
        visit_id = 1 and service_code = 'S003';
END;
/

-- after value
SELECT 
    * 
FROM
    visit
WHERE
    visit_id = 1;

--(b)
-- Complete the procedure below
CREATE OR REPLACE PROCEDURE prc_followup_visit (
    p_prevvisit_id IN NUMBER,
    p_newvisit_datetime IN DATE,
    p_newvisit_length IN NUMBER,
    p_output OUT VARCHAR2
) IS
    v_visit_date_time DATE;
    v_animal_id NUMBER(5);
    v_vet_id NUMBER(4);
    v_clinic_id NUMBER(2);
    v_service_code CHAR(5);
    v_service_cost NUMBER(6,2);
BEGIN
    SELECT visit_date_time, animal_id, vet_id, clinic_id 
    INTO v_visit_date_time, v_animal_id, v_vet_id, v_clinic_id
    FROM visit
    WHERE visit_id = p_prevvisit_id; 

    -- validate the visit_date_time
    IF p_newvisit_datetime IS NULL OR p_newvisit_datetime < v_visit_date_time THEN
        p_output := 'Invalid date provided';
        RETURN;
    END IF;

    -- default service
    SELECT
        service_code, service_std_cost 
    INTO 
        v_service_code, v_service_cost
    FROM
        service
    WHERE
        UPPER(service_desc) = UPPER('General Consultation');

    -- insert visit
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

    -- insert visit_service
    INSERT INTO
        visit_service (visit_id, service_code, visit_service_linecost)
    VALUES
        (visit_seq.CURRVAL, v_service_code, v_service_cost);

    -- Set the output message
    p_output := 'Follow-up visit created successfully with ID: ' || visit_seq.CURRVAL;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_output := 'Previous visit ID does not exist';
    WHEN OTHERS THEN
        p_output := 'Error occurred: ' || SQLERRM;
END prc_followup_visit;
/

-- Write Test Harness for (b)
-- valid data
-- before value
SELECT 
    * 
FROM
    visit;

-- insert valid data
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


-- invalid data - with invalid date (will not update)
-- before value
SELECT 
    * 
FROM
    visit;

-- insert 
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