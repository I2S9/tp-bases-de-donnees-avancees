-- =============================================================================
-- TP4 - Exercice 2 : Table employe (emp) - Gestion des employés
-- =============================================================================

SET SERVEROUTPUT ON;

-- Création de la table emp
CREATE TABLE emp (
    matr    NUMBER(10)   NOT NULL,
    nom     VARCHAR2(50) NOT NULL,
    sal     NUMBER(7,2),
    adresse VARCHAR2(96),
    dep     NUMBER(10)   NOT NULL,
    CONSTRAINT emp_pk PRIMARY KEY (matr)
);

-- Insertion de données initiales
INSERT INTO emp VALUES (1, 'Dupont', 3000, 'rue de Paris', 10);
INSERT INTO emp VALUES (2, 'Martin', 2200, 'bd Victor Hugo', 10);
INSERT INTO emp VALUES (3, 'Bernard', 2800, 'av. des Champs', 75000);
INSERT INTO emp VALUES (5, 'Leroy', 2600, 'rue de Lyon', 92000);
COMMIT;

-- =============================================================================
-- Question 1 : Insertion d'un nouvel employé
-- matr=4, nom=Youcef, sal=2500, adresse=avenue de la République, dep=92002
-- =============================================================================

DECLARE
    v_employe emp%ROWTYPE;
BEGIN
    v_employe.matr    := 4;
    v_employe.nom     := 'Youcef';
    v_employe.sal     := 2500;
    v_employe.adresse := 'avenue de la République';
    v_employe.dep     := 92002;
    INSERT INTO emp VALUES v_employe;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Employé Youcef inséré.');
END;
/

-- =============================================================================
-- Question 2 : Suppression des employés (dep connu) + affichage ROWCOUNT
-- =============================================================================

DECLARE
    v_nb_lignes NUMBER;
BEGIN
    DELETE FROM emp WHERE dep = 10;
    v_nb_lignes := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lignes supprimées : ' || v_nb_lignes);
END;
/

-- =============================================================================
-- Question 3 : Somme des salaires (curseur explicite + LOOP)
-- Équivalent à : SELECT SUM(sal) FROM emp
-- =============================================================================

DECLARE
    v_salaire emp.sal%TYPE;
    v_total   emp.sal%TYPE := 0;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
        END IF;
    END LOOP;
    CLOSE c_salaires;
    DBMS_OUTPUT.PUT_LINE('Total salaires : ' || v_total);
END;
/

-- =============================================================================
-- Question 4 : Salaire moyen (curseur explicite + LOOP)
-- Équivalent à : SELECT AVG(sal) FROM emp
-- =============================================================================

DECLARE
    v_salaire emp.sal%TYPE;
    v_total   emp.sal%TYPE := 0;
    v_count   NUMBER := 0;
    v_moyenne emp.sal%TYPE;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total   := v_total + v_salaire;
            v_count   := v_count + 1;
        END IF;
    END LOOP;
    CLOSE c_salaires;
    v_moyenne := CASE WHEN v_count > 0 THEN v_total / v_count ELSE 0 END;
    DBMS_OUTPUT.PUT_LINE('Salaire moyen : ' || v_moyenne);
END;
/

-- =============================================================================
-- Question 5a : Somme des salaires (FOR IN)
-- =============================================================================

DECLARE
    v_total emp.sal%TYPE := 0;
BEGIN
    FOR v_ligne IN (SELECT sal FROM emp) LOOP
        IF v_ligne.sal IS NOT NULL THEN
            v_total := v_total + v_ligne.sal;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total salaires (FOR IN) : ' || v_total);
END;
/

-- =============================================================================
-- Question 5b : Salaire moyen (FOR IN)
-- =============================================================================

DECLARE
    v_total   emp.sal%TYPE := 0;
    v_count   NUMBER := 0;
    v_moyenne emp.sal%TYPE;
BEGIN
    FOR v_ligne IN (SELECT sal FROM emp) LOOP
        IF v_ligne.sal IS NOT NULL THEN
            v_total := v_total + v_ligne.sal;
            v_count := v_count + 1;
        END IF;
    END LOOP;
    v_moyenne := CASE WHEN v_count > 0 THEN v_total / v_count ELSE 0 END;
    DBMS_OUTPUT.PUT_LINE('Salaire moyen (FOR IN) : ' || v_moyenne);
END;
/

-- =============================================================================
-- Question 6 : Noms des employés des départements 92000 et 75000
-- Curseur paramétré
-- =============================================================================

DECLARE
    CURSOR c_emp(p_dep emp.dep%TYPE) IS
        SELECT dep, nom FROM emp WHERE dep = p_dep;
BEGIN
    FOR v_employe IN c_emp(92000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 92000 : ' || v_employe.nom);
    END LOOP;
    FOR v_employe IN c_emp(75000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 75000 : ' || v_employe.nom);
    END LOOP;
END;
/