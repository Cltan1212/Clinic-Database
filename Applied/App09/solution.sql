/*
Databases Applied 09
applied9_sql_basic_intermediate.sql

student id: 
student name:
applied class number:
last modified date:

*/

/* Retrieving data from a single table */

-- A1
SELECT
    stuid,
    stufname,
    stulname,
    to_char(
        studob, 'dd-Mon-yyyy'
    ) AS date_of_birth,
    stuaddress,
    stuphone,
    stuemail
FROM
    uni.student
WHERE
    upper(stuaddress) LIKE upper(
        '%Caulfield'
    )
ORDER BY
    stuid;

-- A2
SELECT
    *
FROM
    uni.unit
WHERE
    upper(unitcode) LIKE 'FIT1%'
ORDER BY
    unitcode;
    
-- A3
SELECT
    stuid,
    stulname,
    stufname,
    stuaddress
FROM
    uni.student
WHERE
    upper(stulname) LIKE 'S%'
    AND lower(stufname) LIKE '%i%'
ORDER BY
    stuid;

-- A4
SELECT
    unitcode,
    ofsemester
FROM
    uni.offering
WHERE
    to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    unitcode,
    ofsemester;

-- A5
SELECT
    to_char(
        ofyear, 'yyyy'
    ) AS offering_year,
    unitcode
FROM
    uni.offering
WHERE
    ofsemester = 2
    AND ( ( to_char(
        ofyear, 'yyyy'
    ) = '2019' )
          OR ( to_char(
        ofyear, 'yyyy'
    ) = '2020' ) )
ORDER BY
    offering_year,
    unitcode;

-- A6
SELECT
    stuid,
    unitcode,
    enrolmark
FROM
    uni.enrolment
WHERE
    enrolmark < 50
    AND ofsemester = 2
    AND to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    stuid,
    unitcode;
/* OR*/
SELECT
    stuid,
    unitcode,
    enrolmark
FROM
    uni.enrolment
WHERE
    enrolgrade = 'N'
    AND ofsemester = 2
    AND to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    stuid,
    unitcode;

/* Retrieving data from multiple tables */

-- B1
SELECT
    unitcode,
    ofsemester,
    stafffname,
    stafflname
FROM
    uni.offering o
    JOIN uni.staff s ON o.staffid = s.staffid
WHERE
    to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    ofsemester,
    unitcode;

-- B2
SELECT
    e.stuid,
    stufname
    || ' '
    || stulname AS studentname,
    unitname
FROM
    uni.student s
    JOIN uni.enrolment e ON s.stuid = e.stuid
    JOIN uni.unit      u ON u.unitcode = e.unitcode
WHERE
    ofsemester = 1
    AND to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    unitname,
    stuid;

-- B3
SELECT
    unitcode,
    ofsemester,
    cltype,
    clday,
    to_char(
        cltime, 'HHAM'
    )               AS time,
    clduration * 60 AS duration
FROM
    uni.staff s
    JOIN uni.schedclass sc ON s.staffid = sc.staffid
WHERE
    to_char(
        ofyear, 'yyyy'
    ) = '2021'
    AND upper(stafffname) = upper(
        'Windham'
    )
    AND upper(stafflname) = upper(
        'Ellard'
    )
ORDER BY
    unitcode,
    ofsemester;

-- B4
SELECT
    e.unitcode,
    unitname,
    ofsemester,
    to_char(
        ofyear, 'yyyy'
    ) AS year,
    nvl(
        to_char(
            enrolmark, '999'
        ), 'N/A'
    ) AS mark,
    nvl(
        enrolgrade, 'N/A'
    ) AS grade
FROM
    uni.student s
    JOIN uni.enrolment e ON s.stuid = e.stuid
    JOIN uni.unit      u ON e.unitcode = u.unitcode
WHERE
    upper(stufname) = upper(
        'Brier'
    )
    AND upper(stulname) = upper(
        'Kilgour'
    )
ORDER BY
    year,
    ofsemester,
    unitcode;
    
-- B5
SELECT
    u1.unitcode,
    u1.unitname,
    prerequnitcode AS prereq_unitcode,
    u2.unitname    AS prereq_unitname
FROM
    uni.unit u1
    JOIN uni.prereq p ON u1.unitcode = p.unitcode
    JOIN uni.unit   u2 ON u2.unitcode = p.prerequnitcode
ORDER BY
    unitcode,
    prereq_unitcode;

-- B6
SELECT
    prerequnitcode AS prereq_unitcode,
    u2.unitname    AS prereq_unitname
FROM
    uni.unit u1
    JOIN uni.prereq p ON u1.unitcode = p.unitcode
    JOIN uni.unit   u2 ON u2.unitcode = p.prerequnitcode
WHERE
    upper(
        u1.unitname
    ) = upper(
        'Introduction to data science'
    )
ORDER BY
    prereq_unitcode;

-- B7
SELECT
    s.stuid,
    stufname,
    stulname
FROM
    uni.student s
    JOIN uni.enrolment e ON s.stuid = e.stuid
WHERE
    upper(enrolgrade) = 'HD'
    AND upper(unitcode) = 'FIT2094'
    AND ofsemester = 2
    AND to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    s.stuid;

-- B8
SELECT
    stufname
    || ' '
    || stulname AS student_fullname,
    e.unitcode
FROM
    uni.student s
    JOIN uni.enrolment e ON s.stuid = e.stuid
WHERE
    enrolmark IS NULL
    AND ofsemester = 1
    AND to_char(
        ofyear, 'yyyy'
    ) = '2021'
ORDER BY
    student_fullname;

/* Aggregate Function, Group By and Having */

-- C1
SELECT
    to_char(
        ofyear, 'YYYY'
    ) AS year,
    ofsemester,
    to_char(
        AVG(enrolmark), '990.0'
    ) AS average_mark
FROM
    uni.enrolment
WHERE
    upper(unitcode) = 'FIT9136'
GROUP BY
    to_char(
        ofyear, 'YYYY'
    ),
    ofsemester
ORDER BY
    year,
    ofsemester;

-- C2
-- a. Repeat students are counted multiple times in each semester of 2019

SELECT
    COUNT(stuid) AS student_count
FROM
    uni.enrolment
WHERE
    upper(unitcode) = 'FIT1045'
    AND to_char(
        ofyear, 'YYYY'
    ) = '2019';

-- b. Repeat students are only counted once across 2019

SELECT
    COUNT(DISTINCT stuid) AS student_count
FROM
    uni.enrolment
WHERE
    upper(unitcode) = 'FIT1045'
    AND to_char(
        ofyear, 'YYYY'
    ) = '2019';

-- C3

SELECT
    unitcode,
    COUNT(prerequnitcode) AS no_prereqs
FROM
    uni.prereq
GROUP BY
    unitcode
ORDER BY
    unitcode;

-- C4
SELECT
    unitcode,
    COUNT(stuid) AS total_no_students
FROM
    uni.enrolment
WHERE
    ofsemester = 2
    AND to_char(
        ofyear, 'yyyy'
    ) = '2020'
    AND upper(enrolgrade) = 'WH'
GROUP BY
    unitcode
ORDER BY
    total_no_students DESC,
    unitcode;
    
-- C5
SELECT
    unitcode,
    ofsemester,
    COUNT(stuid) AS total_enrolment
FROM
    uni.enrolment
WHERE
    to_char(
        ofyear, 'YYYY'
    ) = '2019'
GROUP BY
    unitcode,
    ofsemester
ORDER BY
    total_enrolment,
    unitcode,
    ofsemester;

-- C6
SELECT
    prerequnitcode    AS unitcode,
    u.unitname,
    COUNT(u.unitcode) AS no_times_used
FROM
    uni.prereq p
    JOIN uni.unit u ON u.unitcode = p.prerequnitcode
GROUP BY
    prerequnitcode,
    u.unitname
ORDER BY
    unitcode;

-- C7
SELECT
    unitcode,
    unitname
FROM
    uni.enrolment
    NATURAL JOIN uni.unit
WHERE
    ofsemester = 2
    AND to_char(
        ofyear, 'yyyy'
    ) = '2021'
    AND upper(enrolgrade) = 'DEF'
GROUP BY
    unitcode,
    unitname
HAVING
    COUNT(*) >= 2
ORDER BY
    unitcode;