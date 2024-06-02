/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-pf-insert.sql

--Student ID: 33402973
--Student Name: Tan Chun Ling

/* Comments for your marker:




*/

--------------------------------------
-- INSERT INTO visit
--------------------------------------
-- The insert data as belows: --

-- 1. At least 5 different animal 
    -- Animal 1: visit_id 1, visit_id 2
    -- Animal 2: visit_id 3, visit_id 7
    -- Animal 3: visit_id 4, visit_id 5
    -- Animal 4: visit_id 9
    -- Animal 5: visit_id 10
    -- Animal 8: visit_id 6, visit_id 8, visit_id 10

-- 2. At least 3 different vet
    -- Vet 1002: visit_id 1, visit_id 2
    -- Vet 1003: visit_id 3, visit_id 4, visit_id 7 
    -- Vet 1004: visit_id 5, visit_id 6, visit_id 8, visit_id 10
    -- Vet 1005: visit_id 9

-- 3. At least 3 different clinic 
    -- Clinic 2: visit_id 3, visit_id 4, visit_id 7, visit_id 9
    -- Clinic 3: visit_id 5, visit_id 6, visit_id 8, visit_id 10
    -- Clinic 4: visit_id 1, visit_id 2

-- 4. At least 2 follow up visit 
    -- Follow up 1: visit_id 2 -> visit_id 1
    -- Follow up 2: visit_id 8 -> visit_id 6

-- 5. At least 8 completed visits and 2 incomplete visits
    -- completed visits: visit_id 2, visit_id 3, visit_id 4, visit_id 5, visit_id 7, visit_id 8, visit_id 9, visit_id 10
    -- incompleted visits: visit_id 1, visit_id 6
    
INSERT INTO visit (
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)
VALUES (
    1,
    to_date('16-JAN-2024 2:00PM', 'DD-MON-YY HH:MiAM'),
    30,
    'Dermatology',
    2.5,
    200.99,
    1,
    1002,
    4,
    NULL
);

-- 2. 
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    2,
    to_date('12-MAR-2024 10:30AM', 'DD-MON-YY HH:MiAM'),
    50,
    'Dermatology',
    2.5,
    150,
    1,
    1002,
    4,
    1
);

-- 3. 
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    3,
    to_date('12-FEB-2024 10:30AM', 'DD-MON-YY HH:MiAM'),
    50,
    'Emergency',
    NULL,
    391,
    2,
    1003,
    2,
    NULL
);

-- 4. 
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    4,
    to_date('12-FEB-2024 10:30AM', 'DD-MON-YY HH:MiAM'),
    50,
    'Emergency',
    NULL,
    5,
    3,
    1003,
    2,
    NULL
);

-- 5.
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    5,
    to_date('12-FEB-2024 10:30AM', 'DD-MON-YY HH:MiAM'),
    50,
    'Dental Cleaning',
    NULL,
    90,
    3,
    1004,
    3,
    NULL
);

-- 6.
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    6,
    to_date('30-MAR-2024 10:30AM', 'DD-MON-YY HH:MiAM'),
    50,
    'Dental Cleaning',
    NULL,
    268.50,
    8,
    1004,
    3,
    NULL
);

-- 7.
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    7,
    to_date('05-MAY-2024 10:30AM', 'DD-MON-YY HH:MiAM'),
    50,
    'Emergency',
    5.5,
    120,
    2,
    1003,
    2,
    NULL
);

-- 8.
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    8,
    to_date('20-MAY-2024 3:30PM', 'DD-MON-YY HH:MiAM'),
    50,
    'Dental Cleaning',
    2.5,
    410,
    5,
    1004,
    3,
    6
);

-- 9.
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    9,
    to_date('3-APR-2024 12:00PM', 'DD-MON-YY HH:MiAM'),
    50,
    'General Consultation',
    NULL,
    266.50,
    4,
    1005,
    2,
    NULL
);

-- 10.
INSERT INTO visit 
(
    visit_id,
    visit_date_time,
    visit_length,
    visit_notes,
    visit_weight,
    visit_total_cost,
    animal_id,
    vet_id,
    clinic_id,
    from_visit_id
)

VALUES (
    10,
    to_date('20-JUN-2024 11:30AM', 'DD-MON-YY HH:MiAM'),
    50,
    'Dental Cleaning',
    NULL,
    85,
    5,
    1004,
    3,
    NULL
);
--------------------------------------
--INSERT INTO visit_service
--------------------------------------

-- At least 4 visits that require more than one service in a single visit
-- visit_id 1: S001, S002
-- visit_id 2: S009
-- visit_id 3: S001, S005, S009
-- visit_id 4: S001
-- visit_id 5: S006
-- visit_id 6: S001, S006, S010
-- visit_id 7: S003
-- visit_id 8: S006, S009, S020
-- visit_id 9: S017, S018
-- visit_id 10: S006
INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 1, 'S001', 55 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 1, 'S002', 45 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 2, 'S009', 80 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 3, 'S001', 60 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 3, 'S005', 125 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 3, 'S009', 85 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 4, 'S001', 60 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 5, 'S006', 80 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 6, 'S001', 55 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 6, 'S006', 85 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 6, 'S010', 75 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 7, 'S003', 70 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 8, 'S006', 80 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 8, 'S009', 85 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 8, 'S020', 85 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 9, 'S017', 100 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 9, 'S018', 125 );

INSERT INTO visit_service ( visit_id, service_code, visit_service_linecost )
VALUES ( 10, 'S006', 75 );


--------------------------------------
--INSERT INTO visit_drug
--------------------------------------
-- At least 2 visits with more than one drug prescribed in a single visit
-- visit 1: 102, 119
-- visit_id 2: 104
-- visit_id 3: 119, 105, 104
-- visit_id 4: 119
-- visit_id 5: 106
-- visit_id 6: 119, 106, 110
-- visit_id 7: 103
-- visit_id 8: 106, 104, 120
-- visit_id 9: 117, 118
-- visit_id 10: 106
INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 1,        102,       2,               5,                    3,                      99.99               );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 1,        119,       2,               5,                    3,                      1                   );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 2,        104,       5,               NULL,                 7,                      70                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 3,        104,       3,               NULL,                 7,                      70                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 3,        105,       1,               5,                    1,                      50                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 3,        119,       2,               4,                    3,                      1                   );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 4,        119,       2,               1,                    3,                      5                   );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 5,        106,       1,               2,                    7,                      10                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 6,        119,       3,               NULL,                 5,                      13.5                );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 6,        106,       2,               5,                    7,                      10                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 6,        110,       1,               NULL,                 6,                      30                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 7,        103,       1,              5,                     1,                      50                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 8,        106,       2,               8,                    7,                      10                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 8,        104,       1,               NULL,                 7,                      70                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 8,        120,       5,               NULL,                 7,                      80                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 9,        117,       1,               4,                    9,                      1.5                 );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 9,        118,       1,               5,                    2,                      40                  );

INSERT INTO visit_drug ( visit_id, drug_id,   visit_drug_dose, visit_drug_frequency, visit_drug_qtysupplied, visit_drug_linecost )
VALUES                 ( 10,        106,      2,               1,                    7,                      10                 );

COMMIT;