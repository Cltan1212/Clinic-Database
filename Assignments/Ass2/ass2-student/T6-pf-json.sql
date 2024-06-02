/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-pf-json.sql

--Student ID: 33402973
--Student Name: Tan Chun Ling


/* Comments for your marker:




*/

-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT TO GENERATE 
-- THE COLLECTION OF JSON DOCUMENTS HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
SELECT JSON_OBJECT(
    '_id' VALUE c.clinic_id,
    'name' VALUE c.clinic_name,
    'address' VALUE c.clinic_address,
    'phone' VALUE c.clinic_phone,
    'head_vet' VALUE JSON_OBJECT(
        'id' VALUE hv.vet_id,
        'name' VALUE hv.vet_givenname || ' ' || hv.vet_familyname
    ),
    'no_of_vets' VALUE COUNT(v.vet_id),
    'vets' VALUE JSON_ARRAYAGG(
        JSON_OBJECT(
            'id' VALUE v.vet_id,
            'name' VALUE v.vet_givenname || ' ' || v.vet_familyname,
            'specialisation' VALUE NVL(s.spec_description, 'N/A')
        )
    )
)
FROM 
    clinic c
    JOIN vet v ON c.clinic_id = v.clinic_id
    LEFT JOIN specialisation s ON v.spec_id = s.spec_id
    JOIN vet hv ON (
        c.clinic_id = hv.clinic_id AND 
        c.vet_id = hv.vet_id
    ) 
GROUP BY 
    c.clinic_id, 
    c.clinic_name, 
    c.clinic_address, 
    c.clinic_phone, 
    hv.vet_id, 
    hv.vet_givenname, 
    hv.vet_familyname
ORDER BY 
    c.clinic_id;

COMMIT;