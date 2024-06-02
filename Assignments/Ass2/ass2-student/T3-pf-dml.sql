/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T3-pf-dml.sql

--Student ID: 33402973
--Student Name: Tan Chun Ling

/* Comments for your marker:




*/

/*(a)*/
DROP SEQUENCE visit_seq;
CREATE SEQUENCE visit_seq START WITH 100 INCREMENT BY 10;

/*(b)*/
-- schedule visit
INSERT INTO visit ( visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id )
VALUES (
    visit_seq.NEXTVAL,
    to_date('19-MAY-2024 2:00PM', 'DD-MON-YY HH:MiAM'),
    30,
    NULL,
    NULL,
    (
        SELECT
            service_std_cost
        FROM 
            service 
        WHERE 
            service_code = 'S001' 
    ),
    (
        SELECT 
            animal_id 
        FROM
            animal
            NATURAL JOIN owner 
            NATURAL JOIN animal_type
        WHERE
            animal_born = TO_DATE('01/6/2018', 'dd/mm/yyyy') AND
            UPPER(owner_givenname) = UPPER('Jack') AND
            UPPER(owner_familyname) = UPPER('JONES') AND 
            UPPER(atype_description) = UPPER('Rabbit')
    ), 
    (
        SELECT 
            vet_id 
        FROM
            vet
        WHERE
            UPPER(vet_givenname) = UPPER('Anna') AND 
            UPPER(vet_familyname) = UPPER('KOWALSKI')
    ),
    3,
    NULL
);

-- general consultation
INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost ) 
VALUES (visit_seq.currval, 'S001', (
        SELECT
            service_std_cost
        FROM 
            service 
        WHERE 
            service_code = 'S001' 
    ));

-- COMMIT;

/*(c)*/

-- only record ear infection
UPDATE visit_service 
SET 
    service_code = (
        SELECT
            service_code
        FROM 
            service 
        WHERE 
            UPPER(service_desc) = UPPER('ear infection treatment')
    ), 
    visit_service_linecost = (
        SELECT
            service_std_cost
        FROM 
            service 
        WHERE 
            UPPER(service_desc) = UPPER('ear infection treatment')
    )
WHERE 
    visit_id = (
                SELECT 
                    MAX(visit_id)
                FROM
                    visit
    );

-- 1 bottle of Clotrimazole 
INSERT INTO visit_drug ( visit_id, drug_id, visit_drug_dose, visit_drug_qtysupplied, visit_drug_linecost )
VALUES ( 
    visit_seq.currval, 
    (
        SELECT 
            drug_id 
        FROM 
            drug 
        WHERE 
            UPPER(drug_name) = UPPER('Clotrimazole')
    ),
    '1 dose',
    1,
    (
        SELECT 
            drug_std_cost 
        FROM 
            drug 
        WHERE 
            UPPER(drug_name) = UPPER('Clotrimazole')
    )
);

-- update information for visit
UPDATE visit 
SET 
    visit_total_cost = (
        SELECT
            service_std_cost
        FROM 
            service 
        WHERE 
            UPPER(service_desc) = UPPER('ear infection treatment')
    ) + (
        SELECT 
            drug_std_cost 
        FROM 
            drug 
        WHERE 
            UPPER(drug_name) = UPPER('Clotrimazole')
    )
WHERE 
    visit_id = (
                SELECT 
                    MAX(visit_id)
                FROM
                    visit
            );


-- schedule next visit
INSERT INTO visit ( visit_id, visit_date_time, visit_length, visit_notes, visit_weight, visit_total_cost, animal_id, vet_id, clinic_id, from_visit_id )
VALUES (
    visit_seq.NEXTVAL,
    (
        SELECT
            TO_DATE(visit_date_time  + 7 || ' 2:00PM' , 'DD-MON-YY HH:MiAM')
        FROM
            visit
        WHERE 
            visit_id = (
                SELECT 
                    MAX(visit_id)
                FROM
                    visit
            )
    ),
    30,
    NULL,
    NULL,
    (
        SELECT
            service_std_cost
        FROM 
            service 
        WHERE 
            UPPER(service_desc) = UPPER('ear infection treatment')
    ),
    (
        SELECT 
            animal_id 
        FROM
            animal
            NATURAL JOIN owner 
            NATURAL JOIN animal_type
        WHERE
            animal_born = TO_DATE('01/6/2018', 'dd/mm/yyyy') AND
            UPPER(owner_givenname) = UPPER('Jack') AND
            UPPER(owner_familyname) = UPPER('JONES') AND 
            UPPER(atype_description) = UPPER('Rabbit')
    ), 
    (
        SELECT 
            vet_id 
        FROM
            vet
        WHERE
            UPPER(vet_givenname) = UPPER('Anna') AND 
            UPPER(vet_familyname) = UPPER('KOWALSKI')
    ),
    (
        SELECT 
            clinic_id
        FROM
            visit
        WHERE 
            visit_id = (
                SELECT 
                    MAX(visit_id)
                FROM
                    visit
            )
    
    ),
    (
        SELECT 
            MAX(visit_id)
        FROM
            visit
    )
);

-- next visit service
INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 
    visit_seq.currval, 
    (
        SELECT
            service_code
        FROM 
            service 
        WHERE 
            UPPER(service_desc) = UPPER('ear infection treatment')
    ), 
    (
        SELECT
            service_std_cost
        FROM 
            service 
        WHERE 
            UPPER(service_desc) = UPPER('ear infection treatment')
    )
);

-- COMMIT;

/*(d)*/

DELETE FROM visit_service 
WHERE 
    visit_id = (
        SELECT 
            max(visit_id)
        FROM 
            visit 
        WHERE 
            animal_id = (
                SELECT 
                    animal_id 
                FROM
                    animal
                    NATURAL JOIN owner 
                    NATURAL JOIN animal_type
                WHERE
                    animal_born = TO_DATE('01/6/2018', 'dd/mm/yyyy') AND
                    UPPER(owner_givenname) = UPPER('Jack') AND
                    UPPER(owner_familyname) = UPPER('JONES') AND 
                    UPPER(atype_description) = UPPER('Rabbit')
            )
    );

DELETE FROM visit 
WHERE 
    visit_id = (
        SELECT 
            max(visit_id)
        FROM 
            visit 
        WHERE 
            animal_id = (
                SELECT 
                    animal_id 
                FROM
                    animal
                    NATURAL JOIN owner 
                    NATURAL JOIN animal_type
                WHERE
                    animal_born = TO_DATE('01/6/2018', 'dd/mm/yyyy') AND
                    UPPER(owner_givenname) = UPPER('Jack') AND
                    UPPER(owner_familyname) = UPPER('JONES') AND 
                    UPPER(atype_description) = UPPER('Rabbit')
            )
    );


COMMIT;

