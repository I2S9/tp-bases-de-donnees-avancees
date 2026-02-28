-- Question 1 : Definir la table section avec la contrainte sur semester.
CREATE TABLE section (
    course_id    VARCHAR(8),
    sec_id       VARCHAR(8),
    semester     VARCHAR(6),
    year         NUMERIC(4,0),
    building     VARCHAR(15),
    room_number  VARCHAR(7),
    time_slot_id VARCHAR(4),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course,
    FOREIGN KEY (building, room_number) REFERENCES classroom,
    CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer'))
);

-- Question 2 : Determiner le diagramme entite-association.
-- Reponse : Cette question est conceptuelle (diagramme EA), pas une requete SQL.

-- Question 3 : Creer la base et la peupler en lancant le script test.sql.
-- Reponse (SQL*Plus) :
-- SQL> @test.sql

-- Question 4 : Inserer le cours BIO-101.
INSERT INTO course VALUES ('BIO-101', 'Intro. to Biology', 'Biology', '4');