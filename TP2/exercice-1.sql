-- Question 1 : Afficher le nom du departement qui a le budget le plus eleve.
SELECT dept_name
FROM department
WHERE budget IN (
    SELECT MAX(budget)
    FROM department
);

-- Question 2 : Afficher les salaires et les noms des enseignants qui gagnent plus que le salaire moyen.
SELECT a.name, a.salary
FROM teacher a
WHERE a.salary > (
    SELECT AVG(b.salary)
    FROM teacher b
);

-- Question 3 : Pour chaque enseignant, afficher tous les etudiants qui ont suivi plus de deux cours dispenses par cet enseignant, avec HAVING.
SELECT i.name, s.name, COUNT(*) AS total_cours
FROM teacher i
JOIN teaches te ON te.id = i.id
JOIN takes t
  ON t.course_id = te.course_id
 AND t.sec_id = te.sec_id
 AND t.semester = te.semester
 AND t.year = te.year
JOIN student s ON s.id = t.id
GROUP BY i.name, s.name
HAVING COUNT(*) >= 2;

-- Question 4 : Meme demande que la question 3, mais sans utiliser HAVING.
SELECT t1.teachername, t1.studentname, t1.totalcount
FROM (
    SELECT i.name AS teachername, s.name AS studentname, COUNT(*) AS totalcount
    FROM teacher i
    JOIN teaches te ON te.id = i.id
    JOIN takes t
      ON t.course_id = te.course_id
     AND t.sec_id = te.sec_id
     AND t.semester = te.semester
     AND t.year = te.year
    JOIN student s ON s.id = t.id
    GROUP BY i.name, s.name
) t1
WHERE t1.totalcount >= 2
ORDER BY t1.teachername;

-- Question 5 : Afficher les identifiants et les noms des etudiants qui n'ont pas suivi de cours avant 2010.
SELECT s.id, s.name
FROM student s
EXCEPT
SELECT s.id, s.name
FROM student s
JOIN takes t ON t.id = s.id
WHERE t.year < 2010;

-- Question 6 : Afficher tous les enseignants dont les noms commencent par E.
SELECT *
FROM teacher
WHERE name LIKE 'E%';

-- Question 7 : Afficher les salaires et les noms des enseignants qui percoivent le quatrieme salaire le plus eleve.
SELECT t1.name, t1.salary
FROM teacher t1
WHERE 3 = (
    SELECT COUNT(DISTINCT t2.salary)
    FROM teacher t2
    WHERE t2.salary > t1.salary
);

-- Question 8 : Afficher les noms et salaires des trois enseignants ayant les salaires les moins eleves (ordre decroissant).
SELECT t1.name, t1.salary
FROM teacher t1
WHERE 2 >= (
    SELECT COUNT(DISTINCT t2.salary)
    FROM teacher t2
    WHERE t2.salary < t1.salary
)
ORDER BY t1.salary DESC;

-- Question 9 : Afficher les noms des etudiants qui ont suivi un cours en automne 2009, en utilisant IN.
SELECT s.name
FROM student s
WHERE s.id IN (
    SELECT t.id
    FROM takes t
    WHERE t.semester = 'Fall'
      AND t.year = 2009
);

-- Question 10 : Afficher les noms des etudiants qui ont suivi un cours en automne 2009, en utilisant SOME.
SELECT s.name
FROM student s
WHERE s.id = SOME (
    SELECT t.id
    FROM takes t
    WHERE t.semester = 'Fall'
      AND t.year = 2009
);

-- Question 11 : Afficher les noms des etudiants qui ont suivi un cours en automne 2009, avec NATURAL INNER JOIN.
SELECT DISTINCT name
FROM takes NATURAL INNER JOIN student
WHERE takes.semester = 'Fall'
  AND takes.year = 2009;

-- Question 12 : Afficher les noms des etudiants qui ont suivi un cours en automne 2009, en utilisant EXISTS.
SELECT s.name
FROM student s
WHERE EXISTS (
    SELECT 1
    FROM takes t
    WHERE t.id = s.id
      AND t.semester = 'Fall'
      AND t.year = 2009
);

-- Question 13 : Afficher toutes les paires d'etudiants qui ont suivi au moins un cours ensemble.
SELECT s1.name AS etudiant_1, s2.name AS etudiant_2
FROM takes a
JOIN takes b
  ON a.course_id = b.course_id
 AND a.sec_id = b.sec_id
 AND a.semester = b.semester
 AND a.year = b.year
 AND a.id < b.id
JOIN student s1 ON s1.id = a.id
JOIN student s2 ON s2.id = b.id
GROUP BY s1.name, s2.name
HAVING COUNT(*) >= 1;

-- Question 14 : Pour chaque enseignant qui a assure au moins un cours, afficher le nombre total d'etudiants ayant suivi ses cours.
-- Si un etudiant a suivi deux cours differents avec le meme enseignant, il est compte deux fois.
-- Trier le resultat par ordre decroissant.
SELECT i.name, COUNT(*) AS total_etudiants
FROM takes t
INNER JOIN teaches te
  ON te.course_id = t.course_id
 AND te.sec_id = t.sec_id
 AND te.semester = t.semester
 AND te.year = t.year
INNER JOIN teacher i ON i.id = te.id
GROUP BY i.name, i.id
ORDER BY COUNT(*) DESC;
