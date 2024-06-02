SELECT
    JSON_OBJECT ( '_id' VALUE stuid, 'name' VALUE stufname
                || ' '
                || stulname, 
                'contactInfo' VALUE JSON_OBJECT ( 
                    'address' VALUE stuaddress, 
                    'phone'   VALUE rtrim(stuphone), 
                    'email' VALUE stuemail 
                    ), 
                'dob' VALUE to_char(studob, 'dd-mm-yyyy'),
                'enrolmentInfo' VALUE JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'unitcode' VALUE unitcode, 
                        'unitname' VALUE unitname,
                        'year' VALUE to_char(ofyear, 'yyyy'), 
                        'semester' VALUE ofsemester, 
                        'mark' VALUE enrolmark, 
                        'grade' VALUE enrolgrade
                        )
                    ) FORMAT JSON )
    || ','
FROM
    uni.student
    NATURAL JOIN uni.enrolment  
    NATURAL JOIN uni.unit
GROUP BY
    stuid,
    stufname,
    stulname,
    studob,
    stuaddress,
    stuphone,
    stuemail
ORDER BY
    stuid;