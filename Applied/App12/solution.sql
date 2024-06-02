/*
Applied 12 Sample Solution
applied12_task1_sol.sql

Databases Units
Author: FIT Database Teaching Team
License: Copyright Monash University, unless otherwise stated. All Rights Reserved.
COPYRIGHT WARNING
Warning
This material is protected by copyright. For use within Monash University only. NOT FOR RESALE.
Do not remove this notice. 
*/

SELECT
    JSON_OBJECT ( '_id' VALUE stuid, 'name' VALUE stufname
                || ' '
                || stulname,
                'contactInfo' VALUE JSON_OBJECT (
                                'address' VALUE stuaddress,
                                'phone' VALUE stuphone,
                                'email' VALUE stuemail ),
                'dob' VALUE to_char(studob, 'dd-mm-yyyy'),
                'enrolmentInfo' VALUE JSON_ARRAYAGG(
                                JSON_OBJECT('unitcode' VALUE unitcode,
                                'unitname' VALUE unitname,
                                'year' VALUE to_char(ofyear, 'yyyy'),
                                'semester' VALUE ofsemester,
                                'mark' VALUE enrolmark,
                                'grade' VALUE enrolgrade))
    FORMAT JSON )
    || ','
FROM
    uni.student
    NATURAL JOIN uni.enrolment
    NATURAL JOIN uni.unit
GROUP BY
    stuid,
    stufname,
    stulname,
    stuaddress,
    stuphone,
    stuemail,
    studob
ORDER BY
    stuid;


