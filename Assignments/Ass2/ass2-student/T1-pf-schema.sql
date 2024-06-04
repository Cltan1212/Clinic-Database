--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T1-pf-schema.sql

--Student ID: 33402973
--Student Name: Tan Chun Ling


/* Comments for your marker:




*/

-- Task 1 Add Create table statements for the Missing TABLES below.
-- Ensure all column comments, and constraints (other than FK's)are included. 
-- FK constraints are to be added at the end of this script

-- ==================== VISIT =================== --

-- create table
CREATE TABLE visit (
    visit_id            NUMBER(5)       NOT NULL,
    visit_date_time     DATE            NOT NULL,
    visit_length        NUMBER(2)       NOT NULL,
    visit_notes         VARCHAR2(200),
    visit_weight        NUMBER(4,1),
    visit_total_cost    NUMBER(6,2),
    animal_id           NUMBER(5)       NOT NULL,
    vet_id              NUMBER(4)       NOT NULL,
    clinic_id           NUMBER(2)       NOT NULL,
    from_visit_id       NUMBER(5) 
);

-- comment table
COMMENT ON COLUMN visit.visit_id            IS 'Identifier for visit';
COMMENT ON COLUMN visit.visit_date_time     IS 'Date and time of visit';
COMMENT ON COLUMN visit.visit_length        IS 'Visit length in minutes';
COMMENT ON COLUMN visit.visit_notes         IS 'Vet notes from visit';
COMMENT ON COLUMN visit.visit_weight        IS 'Weight in Kgs';
COMMENT ON COLUMN visit.visit_total_cost    IS 'Total cost for this visit';
COMMENT ON COLUMN visit.animal_id           IS 'Animal identifier';
COMMENT ON COLUMN visit.vet_id              IS 'Identifier for the vet';
COMMENT ON COLUMN visit.clinic_id           IS 'Identifier for the clinic';
COMMENT ON COLUMN visit.from_visit_id       IS 'The previous visit''s identifier';

-- alter table: constraint (pk and check constraint)
ALTER TABLE visit ADD CONSTRAINT visit_pk           PRIMARY KEY ( visit_id );
ALTER TABLE visit ADD CONSTRAINT visit_vet_un       UNIQUE ( visit_date_time, vet_id );
ALTER TABLE visit ADD CONSTRAINT visit_ani_un       UNIQUE ( visit_date_time, animal_id );                                                             
ALTER TABLE visit ADD CONSTRAINT ck_visit_length    CHECK (visit_length BETWEEN 30 AND 90);

-- ================= VISIT_DRUG ==================== --

-- create table
CREATE TABLE visit_drug (
    visit_id                NUMBER(5)       NOT NULL,
    drug_id                 NUMBER(4)       NOT NULL,
    visit_drug_dose         VARCHAR2(20)    NOT NULL,
    visit_drug_frequency    VARCHAR2(20),
    visit_drug_qtysupplied  NUMBER(2)       NOT NULL,
    visit_drug_linecost     NUMBER(5,2)     NOT NULL
);

-- comment table
COMMENT ON COLUMN visit_drug.visit_id               IS 'Identifier for visit';
COMMENT ON COLUMN visit_drug.drug_id                IS 'Drug identifier';
COMMENT ON COLUMN visit_drug.visit_drug_dose        IS 'Dose prescribed in this visit';
COMMENT ON COLUMN visit_drug.visit_drug_frequency   IS 'Frequency prescribed for this drug for this visit';
COMMENT ON COLUMN visit_drug.visit_drug_qtysupplied IS 'Quantity of drug spplied';
COMMENT ON COLUMN visit_drug.visit_drug_linecost    IS 'Cost charged for drug in this visit';

-- alter table: constraint (pk)
ALTER TABLE visit_drug ADD CONSTRAINT visit_drug_pk PRIMARY KEY ( visit_id, drug_id );

-- ================= VISIT_SERVICE ==================== --

-- create table
CREATE TABLE visit_service (
    visit_id                NUMBER(5)   NOT NULL,
    service_code            CHAR(5)     NOT NULL,
    visit_service_linecost  NUMBER(6,2)
);

-- comment table
COMMENT ON COLUMN visit_service.visit_id                IS 'Identifier for visit';
COMMENT ON COLUMN visit_service.service_code            IS 'Service Identifier';
COMMENT ON COLUMN visit_service.visit_service_linecost  IS 'Cost charged for this service in this visit';

-- alter table: constraint (pk)
ALTER TABLE visit_service ADD CONSTRAINT visit_service_pk PRIMARY KEY ( visit_id, service_code );

-- ================= FK Constraints ==================== --
-- visit and animal (animal_id)
ALTER TABLE visit 
    ADD CONSTRAINT visit_animal_fk FOREIGN KEY ( animal_id )   
        REFERENCES animal ( animal_id );

-- visit and vet (vet_id)
ALTER TABLE visit 
    ADD CONSTRAINT visit_vet_fk FOREIGN KEY ( vet_id )   
        REFERENCES vet ( vet_id );

-- visit and clinic (clinic_id)
ALTER TABLE visit
    ADD CONSTRAINT visit_clinic_fk FOREIGN KEY ( clinic_id )
        REFERENCES clinic ( clinic_id );

-- visit and visit (visit_id)
ALTER TABLE visit
    ADD CONSTRAINT visit_from_fk FOREIGN KEY ( from_visit_id )
        REFERENCES visit ( visit_id );

-- visit drug and visit (visit_id)
ALTER TABLE visit_drug
    ADD CONSTRAINT visit_vd_fk FOREIGN KEY ( visit_id )
        REFERENCES visit ( visit_id );

-- visit drug and drug (drug_id)
ALTER TABLE visit_drug 
    ADD CONSTRAINT visit_drug_fk FOREIGN KEY ( drug_id )
        REFERENCES drug ( drug_id );

-- visit service and visit (visit_id)
ALTER TABLE visit_service 
    ADD CONSTRAINT visit_vs_fk FOREIGN KEY ( visit_id ) 
        REFERENCES visit ( visit_id );

-- visit service and service (service_id)
ALTER TABLE visit_service 
    ADD CONSTRAINT visit_service_fk FOREIGN KEY ( service_code ) 
        REFERENCES service ( service_code );