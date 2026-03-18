-- =============================================================================
-- TP4 - Exercice 1 : Introduction au PL/SQL (Oracle)
-- =============================================================================

SET SERVEROUTPUT ON;

-- =============================================================================
-- Question 1 : Procédure anonyme - Somme de deux entiers
-- =============================================================================

DECLARE
    v_nombre1  NUMBER := &nombre1;
    v_nombre2  NUMBER := &nombre2;
    v_somme    NUMBER;
BEGIN
    v_somme := v_nombre1 + v_nombre2;
    DBMS_OUTPUT.PUT_LINE('La somme de ' || v_nombre1 || ' et ' || v_nombre2 || ' est : ' || v_somme);
END;
/

-- =============================================================================
-- Question 2 : Procédure anonyme - Table de multiplication
-- =============================================================================

DECLARE
    v_nombre   NUMBER := &nombre;
    v_i        NUMBER;
    v_produit  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Table de multiplication de ' || v_nombre || ' :');
    FOR v_i IN 1..10 LOOP
        v_produit := v_nombre * v_i;
        DBMS_OUTPUT.PUT_LINE(v_nombre || ' x ' || v_i || ' = ' || v_produit);
    END LOOP;
END;
/

-- =============================================================================
-- Question 3 : Fonction récursive - Puissance x^n
-- =============================================================================

CREATE OR REPLACE FUNCTION puissance(x IN NUMBER, n IN NUMBER) RETURN NUMBER IS
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSIF n = 1 THEN
        RETURN x;
    ELSE
        RETURN x * puissance(x, n - 1);
    END IF;
END puissance;
/

-- Test de la fonction puissance
DECLARE
    v_x NUMBER := &x;
    v_n NUMBER := &n;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_x || '^' || v_n || ' = ' || puissance(v_x, v_n));
END;
/

-- =============================================================================
-- Question 4 : Procédure anonyme - Factoriel stocké dans resultatFactoriel
-- =============================================================================

-- Création de la table resultatFactoriel (à exécuter une seule fois)
CREATE TABLE resultatFactoriel (
    nombre     NUMBER,
    factoriel  NUMBER,
    CONSTRAINT pk_resultat_factoriel PRIMARY KEY (nombre)
);

-- Procédure anonyme
DECLARE
    v_n         NUMBER := &nombre;
    v_factoriel NUMBER := 1;
    v_i         NUMBER;
BEGIN
    IF v_n <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : le nombre doit être strictement positif.');
    ELSE
        FOR v_i IN 1..v_n LOOP
            v_factoriel := v_factoriel * v_i;
        END LOOP;
        INSERT INTO resultatFactoriel (nombre, factoriel) VALUES (v_n, v_factoriel);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(v_n || '! = ' || v_factoriel || ' (stocké dans resultatFactoriel)');
    END IF;
END;
/

-- =============================================================================
-- Question 5 : Procédure anonyme - Factoriels des 20 premiers entiers
-- =============================================================================

-- Création de la table resultatsFactoriels (à exécuter une seule fois)
CREATE TABLE resultatsFactoriels (
    nombre     NUMBER,
    factoriel  NUMBER,
    CONSTRAINT pk_resultats_factoriels PRIMARY KEY (nombre)
);

-- Procédure anonyme
DECLARE
    v_n         NUMBER;
    v_factoriel NUMBER;
    v_i         NUMBER;
BEGIN
    DELETE FROM resultatsFactoriels;  -- permet de réexécuter le script
    FOR v_n IN 1..20 LOOP
        v_factoriel := 1;
        FOR v_i IN 1..v_n LOOP
            v_factoriel := v_factoriel * v_i;
        END LOOP;
        INSERT INTO resultatsFactoriels (nombre, factoriel) VALUES (v_n, v_factoriel);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Les factoriels de 1 à 20 ont été stockés dans resultatsFactoriels.');
END;
/