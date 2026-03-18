-- =============================================================================
-- TP4 - Exercice 3 : Package gestion des clients (surcharge + exceptions)
-- =============================================================================

SET SERVEROUTPUT ON;

-- Table client
CREATE TABLE client (
    id      NUMBER(10)   NOT NULL,
    nom     VARCHAR2(50) NOT NULL,
    adresse VARCHAR2(96),
    email   VARCHAR2(100),
    CONSTRAINT client_pk PRIMARY KEY (id)
);

-- =============================================================================
-- Spécification du package GESTION_CLIENTS
-- Deux procédures ajouter_client (surcharge)
-- =============================================================================

CREATE OR REPLACE PACKAGE gestion_clients IS
    -- Version 1 : paramètres individuels
    PROCEDURE ajouter_client(
        p_id      IN client.id%TYPE,
        p_nom     IN client.nom%TYPE,
        p_adresse IN client.adresse%TYPE DEFAULT NULL,
        p_email   IN client.email%TYPE DEFAULT NULL
    );
    -- Version 2 : enregistrement (record)
    PROCEDURE ajouter_client(p_client IN client%ROWTYPE);
END gestion_clients;
/

-- =============================================================================
-- Corps du package GESTION_CLIENTS
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY gestion_clients IS

    -- Version 1 : insertion par paramètres
    PROCEDURE ajouter_client(
        p_id      IN client.id%TYPE,
        p_nom     IN client.nom%TYPE,
        p_adresse IN client.adresse%TYPE DEFAULT NULL,
        p_email   IN client.email%TYPE DEFAULT NULL
    ) IS
    BEGIN
        IF p_nom IS NULL OR TRIM(p_nom) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Le nom ne peut pas être vide.');
        END IF;
        INSERT INTO client (id, nom, adresse, email)
        VALUES (p_id, p_nom, p_adresse, p_email);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Client ' || p_nom || ' (id=' || p_id || ') ajouté.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20002, 'ID client déjà existant : ' || p_id);
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ajouter_client;

    -- Version 2 : insertion par record
    PROCEDURE ajouter_client(p_client IN client%ROWTYPE) IS
    BEGIN
        IF p_client.nom IS NULL OR TRIM(p_client.nom) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Le nom ne peut pas être vide.');
        END IF;
        INSERT INTO client VALUES p_client;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Client ' || p_client.nom || ' (id=' || p_client.id || ') ajouté.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20002, 'ID client déjà existant : ' || p_client.id);
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ajouter_client;

END gestion_clients;
/

-- =============================================================================
-- Tests
-- =============================================================================

-- Test version 1 (paramètres)
BEGIN
    gestion_clients.ajouter_client(1, 'Dupont', 'rue de Paris', 'dupont@mail.com');
END;
/

-- Test version 2 (record)
DECLARE
    v_client client%ROWTYPE;
BEGIN
    v_client.id      := 2;
    v_client.nom     := 'Martin';
    v_client.adresse := 'bd Victor Hugo';
    v_client.email   := 'martin@mail.com';
    gestion_clients.ajouter_client(v_client);
END;
/

-- Test exception : doublon
BEGIN
    gestion_clients.ajouter_client(1, 'Autre', NULL, NULL);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception capturée : ' || SQLERRM);
END;
/
