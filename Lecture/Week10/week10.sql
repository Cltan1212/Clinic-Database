SET ECHO ON;
SET SERVEROUTPUT ON;

-- Stored procedure --
CREATE OR REPLACE PROCEDURE prc_drone_cost_increase10
IS BEGIN
   UPDATE drone
   SET drone_cost_hr = drone_cost_hr * 1.1;
   dbms_output.put_line('Drone cost per hour has been increased by 10%');
END;
/

--before value
select * from drone;
--execute the procedure
exec prc_drone_cost_increase10();
--after value
select * from drone;
--closes transaction
rollback;

-- Stored procedure: with input argument --
DROP SEQUENCE rental_seq;
CREATE SEQUENCE rental_seq start with 1;

CREATE OR REPLACE PROCEDURE prc_insert_rental (p_drone_id IN NUMBER) IS
    p_drone_bond NUMBER;
BEGIN
   SELECT drone_pur_price * 10 / 100 INTO p_drone_bond FROM drone WHERE drone_id = p_drone_id;

   INSERT INTO rental VALUES (
       rental_seq.NEXTVAL, p_drone_bond, sysdate, sysdate+7, NULL, p_drone_id);
   dbms_output.put_line('A new rental for drone ' || p_drone_id || ' has been inserted');
EXCEPTION -- capture the error
    WHEN NO_DATA_FOUND THEN
       dbms_output.put_line('Drone ' || p_drone_id ||  ' does not exist');
END; 
/

--before value
select * from rental;
--execute the procedure
exec prc_insert_rental(100);
--after value
select * from rental;
--execute the procedure --error
exec prc_insert_rental(102);
--after value
select * from rental;
--closes transaction
rollback;

-- Stored procedure - with IN/OUT arguments and exception --

DROP SEQUENCE rental_seq;
CREATE SEQUENCE rental_seq start with 1;

CREATE OR REPLACE PROCEDURE prc_insert_rental_output (p_drone_id IN NUMBER,p_output OUT VARCHAR2) IS
   p_drone_bond NUMBER;
BEGIN
   SELECT drone_pur_price * 10 / 100 INTO p_drone_bond FROM drone WHERE drone_id = p_drone_id;

   INSERT INTO rental VALUES (rental_seq.NEXTVAL,p_drone_bond,sysdate,sysdate+7,NULL,p_drone_id);
   p_output := 'A new rental for drone ' || p_drone_id || ' has been inserted';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Drone ' || p_drone_id ||  ' does not exist');
END; 
/


--before value
select * from rental;
--call the procedure - success
DECLARE
   output VARCHAR2(200);
BEGIN
   prc_insert_rental_output(100,output);
   dbms_output.put_line(output);
END;
/
--after value
select * from rental;

-- task 1
CREATE OR REPLACE PROCEDURE prc_return_rental (p_rent_no IN NUMBER, p_hours_flown IN NUMBER, p_output
OUT VARCHAR2) IS
    p_drone_id NUMBER;

BEGIN
    IF(p_hours_flown <=0) THEN
        p_output := 'Invalid number of hours flown by the drone, the value must be a positive value';
    ELSE
        UPDATE rental
        SET rent_in = sysdate
        WHERE rent_no = p_rent_no;

        SELECT drone_id into p_drone_id
        FROM rental WHERE rent_no = p_rent_no;
        UPDATE DRONE
        SET drone_flight_time = drone_flight_time + p_hours_flown
        WHERE drone_id = p_drone_id;
        p_output := 'Rental ' || p_rent_no || ' has been returned, and drone '
            ||p_drone_id||' total flight time has been updated';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Rental number ' || p_rent_no ||  ' does not exist');
        WHEN OTHERS THEN
            dbms_output.put_line( SQLERRM ); -- SQL error message

END;
/

--initial data
insert into rental values (101,200,sysdate,sysdate+7,null, 100);
--before value
select * from drone;
select * from rental;
--call the procedure - error rental number
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_return_rental(102,100,output);
    dbms_output.put_line(output);
END;
/
--after value
select * from drone;
select * from rental;
--call the procedure - error hours flown
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_return_rental(101,-6,output);
    dbms_output.put_line(output);
END;
/
--after value
select * from drone;
select * from rental;