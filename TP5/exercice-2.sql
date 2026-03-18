-- TP5 - Exercice 2 : Transactions concurrentes - Isolation
-- Ne pas utiliser SET AUTOCOMMIT OFF (comportement par défaut).
-- Ouvrir deux sessions T1 et T2.

-- ========== Schéma + données initiales ==========

CREATE TABLE vol (
    idVol                 VARCHAR2(44),
    capaciteVol           NUMBER(10),
    nbrPlacesReserveesVol NUMBER(10)
);

CREATE TABLE client (
    idClient                 VARCHAR2(44),
    prenomClient             VARCHAR2(50),
    nbrPlacesReserveesClient NUMBER(10)
);

INSERT INTO vol VALUES ('V1', 100, 0);
INSERT INTO client VALUES ('C1', 'Alice', 0);
INSERT INTO client VALUES ('C2', 'Bob', 0);
COMMIT;

-- ========== Test isolation de base ==========
-- T1 : réserver sans COMMIT
-- T2 : SELECT sur le client

-- T1 :
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 5 WHERE idClient = 'C1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 5 WHERE idVol = 'V1';
-- Ne pas COMMIT
SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C1';
-- T1 voit 5

-- T2 :
SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C1';
-- T2 voit 0 (modifs non commitées invisibles)

-- ========== Modifications concurrentes ==========

-- T1 : réserver 5 places pour C1 (sans COMMIT)
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 5 WHERE idClient = 'C1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 5 WHERE idVol = 'V1';

-- T2 : consulter C1
SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C1';
-- T2 voit 0 (T1 non commité)

-- T2 : réserver 10 places pour C1
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 10 WHERE idClient = 'C1';
-- T2 bloque (attend le verrou détenu par T1)

-- T1 : COMMIT
COMMIT;

-- T2 : se débloque, l'UPDATE s'exécute
-- T2 : consulter
SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C1';
-- T2 voit 15 (5 de T1 + 10 de T2)

-- ========== Interblocage (deadlock) ==========
-- Réinit. si besoin : UPDATE client SET nbrPlacesReserveesClient=0; UPDATE vol SET nbrPlacesReserveesVol=0; COMMIT;

-- T1 : réserver 1 place pour C1
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 1 WHERE idClient = 'C1';

-- T2 : réserver 1 place pour C2
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 1 WHERE idClient = 'C2';

-- T1 : réserver 1 place pour C2
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 1 WHERE idClient = 'C2';
-- T1 bloque (C2 verrouillé par T2)

-- T2 : réserver 1 place pour C1
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 1 WHERE idClient = 'C1';
-- Deadlock détecté : Oracle annule une des transactions (ORA-00060)

-- ========== ROLLBACK ==========

-- T1 : réserver puis annuler
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 3 WHERE idClient = 'C1';
ROLLBACK;

SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C1';
-- Valeur inchangée (ROLLBACK annule tout)

-- ========== COMMIT ==========

-- T1 : réserver puis valider
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 3 WHERE idClient = 'C1';
COMMIT;

-- T2 : consulter
SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C1';
-- T2 voit la nouvelle valeur (COMMIT = visible par les autres)
-- Conclusion : Oracle utilise READ COMMITTED par défaut

-- ========== Isolation incomplète (READ COMMITTED) ==========
-- Mises à jour perdues. Réinit. : UPDATE client SET nbrPlacesReserveesClient=0; UPDATE vol SET nbrPlacesReserveesVol=0; COMMIT;

-- T1 : SELECT vol, SELECT client
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V1';
SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C1';

-- T2 : SELECT vol, SELECT client
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V1';
SELECT nbrPlacesReserveesClient FROM client WHERE idClient = 'C2';

-- T1 : UPDATE client C1 +2, UPDATE vol +2, COMMIT
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 2 WHERE idClient = 'C1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 2 WHERE idVol = 'V1';
COMMIT;

-- T2 : UPDATE client C2 +3, UPDATE vol +3, COMMIT
UPDATE client SET nbrPlacesReserveesClient = nbrPlacesReserveesClient + 3 WHERE idClient = 'C2';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 3 WHERE idVol = 'V1';
COMMIT;

SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V1';
-- Vol affiche 3 au lieu de 5 (T2 a écrasé la MAJ de T1)

-- ========== Isolation complète (SERIALIZABLE) ==========
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- T1 :
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 2 WHERE idVol = 'V1';

-- T2 (en parallèle) :
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 3 WHERE idVol = 'V1';
-- Une des deux transactions sera rejetée (ORA-08177)
-- Oracle utilise un mécanisme proche du verrouillage à deux phases
