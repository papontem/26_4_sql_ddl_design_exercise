-- MADE BY PAM --
-- from the terminal run:
-- psql < medical_center_db.sql

DROP DATABASE IF EXISTS medical_center_db;

CREATE DATABASE medical_center_db;

\c medical_center_db

-- A medical center employs several doctors
-- A doctors can see many patients
-- A patient can be seen by many doctors
-- During a visit, a patient may be diagnosed to have one or more diseases.

CREATE TABLE patients
(
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    insured BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE doctors
(
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    main_specification TEXT NOT NULL
);

CREATE TABLE diseases
(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE visits
(
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients (id) ON DELETE CASCADE,
    doctor_id INTEGER REFERENCES doctors (id) ON DELETE CASCADE,
    date_of_visit DATE NOT NULL
);

CREATE TABLE diagnoses
(
    id SERIAL PRIMARY KEY,
    visit_id INTEGER REFERENCES visits (id) ON DELETE CASCADE,
    disease_id INTEGER REFERENCES diseases (id) ON DELETE CASCADE
);

INSERT INTO doctors (first_name, last_name, main_specification) 
VALUES
    ('Clark', 'Kent', 'Physician'),
    ('John', 'Handcock', 'Orthopediatrician'),
    ('Alice', 'Wonderland', 'Anesthesiologist'),
    ('Seymour', 'Butz', 'Proctologist');

INSERT INTO patients (first_name, last_name, insured) 
VALUES
    ('Anne', 'Cox', false),
    ('Loyd', 'Cummings', true),
    ('Oliver', 'Klozoff', true);

INSERT INTO diseases (name) 
VALUES
    ('Healthy'),
    ('Tuberculosis'),
    ('Migraines'),
    ('Asthma'),
    ('Flu'),
    ('Common Cold'),
    ('Influenza'),
    ('Fracture'),
    ('Hypertension'),
    ('Diabetes'),
    ('Coronavirus'),
    ('Pneumonia');

INSERT INTO visits (patient_id, doctor_id, date_of_visit) 
VALUES
    (1, 4, '2023-07-01'),
    (2, 1, '2023-07-01'),
    (3, 1, '2023-07-01'),
    (1, 1, '2023-07-08'),
    (2, 2, '2023-07-10'),
    (3, 2, '2023-07-15'),
    (2, 3, '2023-07-18'),
    (3, 4, '2023-07-31');

INSERT INTO diagnoses (visit_id, disease_id) 
VALUES
    (1, 11),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (1, 10),
    (2, 4),
    (2, 5),
    (3, 8),
    (4, 1),
    (5, 1),
    (5, 3),
    (6, 7),
    (6, 8),
    (7, 1);

SELECT * FROM patients;
SELECT * FROM doctors;
SELECT * FROM diseases;
SELECT * FROM visits;
SELECT * FROM diagnoses;

-- See evetything together
SELECT 
    v.id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    v.date_of_visit,
    dise.name as diagnosed

FROM visits v
FULL JOIN patients p ON v.patient_id = p.id
FULL JOIN doctors d ON v.doctor_id = d.id
FULL JOIN diagnoses diag ON v.id = diag.visit_id
FULL JOIN diseases dise ON diag.disease_id = dise.id;
