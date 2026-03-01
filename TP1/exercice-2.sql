-- Question 1 : Afficher la structure de la relation section et son contenu (cours proposes).
DESC section;
SELECT *
FROM section;

-- Question 2 : Afficher tous les renseignements sur les cours que l'on peut programmer (relation course).
SELECT *
FROM course;

-- Question 3 : Afficher les titres des cours et les departements qui les proposent.
SELECT title, dept_name
FROM course;

-- Question 4 : Afficher les noms des departements ainsi que leur budget.
SELECT dept_name, budget
FROM department;

-- Question 5 : Afficher tous les noms des enseignants et leur departement.
SELECT name, dept_name
FROM teacher;

-- Question 6 : Afficher tous les noms des enseignants ayant un salaire superieur strictement a 65.000 $.
SELECT name
FROM teacher
WHERE salary > 65000;

-- Question 7 : Afficher les noms des enseignants ayant un salaire compris entre 55.000 $ et 85.000 $.
SELECT name
FROM teacher
WHERE salary BETWEEN 55000 AND 85000;

-- Question 8 : Afficher les noms des departements, en utilisant la relation teacher et eliminer les doublons.
SELECT DISTINCT dept_name
FROM teacher;

-- Question 9 : Afficher tous les noms des enseignants du departement informatique ayant un salaire superieur strictement a 65.000 $.
SELECT name
FROM teacher
WHERE salary > 65000
  AND dept_name = 'Comp. Sci.';

-- Question 10 : Afficher tous les renseignements sur les cours proposes au printemps 2010 (relation section).
SELECT *
FROM section
WHERE semester = 'Spring'
  AND year = 2010;

-- Question 11 : Afficher tous les titres des cours dispenses par le departement informatique qui ont plus de trois credits.
SELECT title
FROM course
WHERE dept_name = 'Comp. Sci.'
  AND credit > 3;

-- Question 12 : Afficher tous les noms des enseignants ainsi que le nom de leur departement et les noms des batiments qui les hebergent.
SELECT t.name, t.dept_name, d.building
FROM teacher t
JOIN department d ON d.dept_name = t.dept_name;
