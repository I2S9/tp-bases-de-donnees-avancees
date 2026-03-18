-- TP5 - Exercice 1 : Atomicité d'une transaction
-- SET AUTOCOMMIT OFF à chaque connexion. Ouvrir S1 et S2.

-- S1 - Étape 1 : Création table
SET AUTOCOMMIT OFF;

CREATE TABLE transaction (
    idTransaction   VARCHAR2(44),
    valTransaction  NUMBER(10)
);

-- S2 - Étape 2 : INSERT, UPDATE, DELETE puis ROLLBACK
SET AUTOCOMMIT OFF;

INSERT INTO transaction VALUES ('T1', 100);
INSERT INTO transaction VALUES ('T2', 200);
INSERT INTO transaction VALUES ('T3', 300);
UPDATE transaction SET valTransaction = 150 WHERE idTransaction = 'T1';
DELETE FROM transaction WHERE idTransaction = 'T3';

ROLLBACK;

SELECT * FROM transaction;
-- Table vide

-- S2 - Étape 3 : Ré-insertion puis quit
SET AUTOCOMMIT OFF;

INSERT INTO transaction VALUES ('T4', 400);
INSERT INTO transaction VALUES ('T5', 500);

quit;

-- S1 : consulter
SELECT * FROM transaction;
-- quit = COMMIT implicite

-- S1 - Étape 4 : Insertion puis fermeture brutale
SET AUTOCOMMIT OFF;

INSERT INTO transaction VALUES ('T6', 600);
INSERT INTO transaction VALUES ('T7', 700);

-- Fermer brutalement sqlplus, puis se reconnecter :
SELECT * FROM transaction;
-- Données perdues (ROLLBACK implicite)

-- Nouvelle session - Étape 5 : DDL puis ROLLBACK
SET AUTOCOMMIT OFF;

INSERT INTO transaction VALUES ('T8', 800);
INSERT INTO transaction VALUES ('T9', 900);

ALTER TABLE transaction ADD val2transaction NUMBER(10);

ROLLBACK;

SELECT * FROM transaction;
-- DDL = COMMIT implicite, les INSERT restent

-- ========== Question 6 - Conclusion ==========
-- Session : connexion client-SGBD, contexte (utilisateur, transactions, curseurs).
-- Transaction : suite d'opérations traitée comme une unité (atomicité ACID).
-- COMMIT : valide définitivement les modifications.
-- ROLLBACK : annule les modifications depuis le dernier COMMIT.
