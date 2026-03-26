-- ========================================================================
-- Projet : Gestion de Location de Véhicules
-- Groupe : 14
-- CHAMMAKHI Amani KHELIDJ Amina SADOUDI Ikram 
-- ========================================================================

-- ==================== SUPPRESSION ====================
DROP TRIGGER InterditSupprimerVehiculeEnLocation;
DROP TRIGGER InterditSupprimerVehiculeRetraite;      
DROP TRIGGER InterditModifVehiculeRetraite;          
DROP TRIGGER InterditSupprimerLigneRetraite;         
DROP TRIGGER MajSituationVehiculeAnnulation;
DROP TRIGGER VerifAnnulationLocation;
DROP TRIGGER MajRetourLocation;
DROP TRIGGER InitialiseLocation;

DROP SEQUENCE seqNumLoc;

DROP TABLE Location CASCADE CONSTRAINTS;
DROP TABLE Tarifs CASCADE CONSTRAINTS;
DROP TABLE Formules CASCADE CONSTRAINTS;
DROP TABLE Categories CASCADE CONSTRAINTS;
DROP TABLE VehiculeRetraite CASCADE CONSTRAINTS;
DROP TABLE Modeles CASCADE CONSTRAINTS;
DROP TABLE Vehicule CASCADE CONSTRAINTS;

-- ==================== SEQUENCE ====================
CREATE SEQUENCE seqNumLoc
  START WITH 1
  INCREMENT BY 1
  NOCYCLE;

-- ==================== TABLES ====================
CREATE TABLE Categories (
    NumCat NUMBER(2) PRIMARY KEY,
    Categorie VARCHAR2(30) NOT NULL UNIQUE,
    PrixKm NUMBER(5,2) NOT NULL CHECK (PrixKm > 0)
);

CREATE TABLE Modeles (
    Modele VARCHAR2(30) PRIMARY KEY,
    Marque VARCHAR2(30) NOT NULL,
    NumCat NUMBER(2) NOT NULL REFERENCES Categories(NumCat),
    CONSTRAINT unique_modele_marque UNIQUE (Modele, Marque)
);

CREATE TABLE Vehicule (
    NumVeh VARCHAR2(10) PRIMARY KEY,
    Modele VARCHAR2(30) NOT NULL REFERENCES Modeles(Modele),
    Km NUMBER(7) DEFAULT 0 NOT NULL CHECK (Km >= 0),
    Situation VARCHAR2(12) DEFAULT 'disponible' CHECK (Situation IN ('disponible', 'location', 'retraite')),
    NbJoursLoc NUMBER(5) DEFAULT 0 NOT NULL CHECK (NbJoursLoc >= 0),
    CAV NUMBER(10,2) DEFAULT 0 NOT NULL CHECK (CAV >= 0)
);

CREATE TABLE VehiculeRetraite (
    NumVeh VARCHAR2(10) PRIMARY KEY REFERENCES Vehicule(NumVeh),
    DateRetraite DATE NOT NULL
);

CREATE TABLE Formules (
    Formule VARCHAR2(30) PRIMARY KEY,
    NbJours NUMBER(3) NOT NULL CHECK (NbJours > 0),
    ForfaitKm NUMBER(6) NOT NULL CHECK (ForfaitKm >= 0)
);

CREATE TABLE Tarifs (
    NumCat NUMBER(2),
    Formule VARCHAR2(30),
    Tarif NUMBER(8,2) NOT NULL CHECK (Tarif > 0),
    PRIMARY KEY (NumCat, Formule),
    FOREIGN KEY (NumCat) REFERENCES Categories(NumCat),
    FOREIGN KEY (Formule) REFERENCES Formules(Formule)
);

CREATE TABLE Location (
    NumLoc VARCHAR2(10) PRIMARY KEY,
    NumVeh VARCHAR2(10) NOT NULL REFERENCES Vehicule(NumVeh),
    Formule VARCHAR2(30) NOT NULL REFERENCES Formules(Formule),
    DateDepart DATE NOT NULL,
    DateRetour DATE,
    KmLoc NUMBER(6) DEFAULT 0 CHECK (KmLoc >= 0),
    Montant NUMBER(10,2) CHECK (Montant >= 0),
    CONSTRAINT chk_dates CHECK (DateRetour >= DateDepart)
);

-- ==================== TRIGGERS ====================

-- INSERT Location
CREATE OR REPLACE TRIGGER InitialiseLocation
BEFORE INSERT ON Location FOR EACH ROW
DECLARE
    v_situation VARCHAR2(12);
    v_nbJours NUMBER;
    v_numcat NUMBER;
    v_tarif NUMBER;
BEGIN
    IF :NEW.DateDepart < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20002, 'DateDepart ne peut pas être antérieure à la date du jour');
    END IF;
    SELECT Situation INTO v_situation FROM Vehicule WHERE NumVeh = :NEW.NumVeh;
    IF v_situation != 'disponible' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le véhicule ' || :NEW.NumVeh || ' n''est pas disponible');
    END IF;
    SELECT NbJours INTO v_nbJours FROM Formules WHERE Formule = :NEW.Formule;
    :NEW.DateRetour := :NEW.DateDepart + v_nbJours;
    :NEW.KmLoc := 0;
    SELECT NumCat INTO v_numcat FROM Modeles
    WHERE Modele = (SELECT Modele FROM Vehicule WHERE NumVeh = :NEW.NumVeh);
    SELECT Tarif INTO v_tarif FROM Tarifs
    WHERE NumCat = v_numcat AND Formule = :NEW.Formule;
    :NEW.Montant := v_tarif;
    :NEW.NumLoc := 'L' || seqNumLoc.NEXTVAL;
    UPDATE Vehicule SET Situation = 'location' WHERE NumVeh = :NEW.NumVeh;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Véhicule, modèle ou tarif introuvable');
END;
/

-- UPDATE Location (retour)
CREATE OR REPLACE TRIGGER MajRetourLocation
BEFORE UPDATE ON Location FOR EACH ROW
DECLARE
    v_km_actuel NUMBER(7);
    v_km_total NUMBER(7);
    v_prixkm NUMBER(5,2);
    v_forfait NUMBER(6);
    v_depassement NUMBER(10,2);
    v_duree NUMBER(5);
    v_situation VARCHAR2(12);
BEGIN
    -- Protection colonnes immuables
    IF :NEW.NumLoc != :OLD.NumLoc OR :NEW.NumVeh != :OLD.NumVeh OR
       :NEW.Formule != :OLD.Formule OR :NEW.DateDepart != :OLD.DateDepart THEN
        RAISE_APPLICATION_ERROR(-20030, 'Seuls DateRetour et KmLoc peuvent être modifiés');
    END IF;
    -- Alerte si date de retour dépassée
    IF :NEW.DateRetour > :OLD.DateRetour THEN
        DBMS_OUTPUT.PUT_LINE('ATTENTION : la date de retour a été dépassée pour le véhicule ' || :OLD.NumVeh);
    END IF;
    -- KmLoc doit être > 0
    IF :NEW.KmLoc <= 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'KmLoc doit être supérieur à 0');
    END IF;
    -- Récupération Km actuel et calcul Km total
    SELECT Km INTO v_km_actuel FROM Vehicule WHERE NumVeh = :OLD.NumVeh;
    v_km_total := v_km_actuel + :NEW.KmLoc;
    -- Calcul dépassement kilométrique
    SELECT PrixKm INTO v_prixkm FROM Categories
    WHERE NumCat = (SELECT NumCat FROM Modeles
                    WHERE Modele = (SELECT Modele FROM Vehicule WHERE NumVeh = :OLD.NumVeh));
    SELECT ForfaitKm INTO v_forfait FROM Formules WHERE Formule = :OLD.Formule;
    v_depassement := GREATEST(0, :NEW.KmLoc - v_forfait) * v_prixkm;
    :NEW.Montant := :OLD.Montant + v_depassement;
    -- Calcul durée de la location
    v_duree := :NEW.DateRetour - :OLD.DateDepart + 1;
    -- Détermination de la situation finale
    IF v_km_total > 50000 THEN
        v_situation := 'retraite';
        DBMS_OUTPUT.PUT_LINE('Le véhicule ' || :OLD.NumVeh || ' a pris sa retraite');
    ELSE
        v_situation := 'disponible';
    END IF;
    -- Un seul UPDATE sur Vehicule
    UPDATE Vehicule
       SET Km = v_km_total,
           Situation = v_situation,
           NbJoursLoc = NbJoursLoc + v_duree,
           CAV = CAV + :NEW.Montant
     WHERE NumVeh = :OLD.NumVeh;
    -- Insertion dans VehiculeRetraite après le UPDATE
    IF v_km_total > 50000 THEN
        INSERT INTO VehiculeRetraite (NumVeh, DateRetraite)
        VALUES (:OLD.NumVeh, SYSDATE);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Données manquantes lors du retour');
END;
/

-- Location : vérification annulation
CREATE OR REPLACE TRIGGER VerifAnnulationLocation
BEFORE DELETE ON Location FOR EACH ROW
BEGIN
    IF :OLD.KmLoc != 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'L''annulation n''est possible que si KmLoc = 0');
    END IF;
END;
/

-- Location : remise en disponible (si pas déjà retraite)
CREATE OR REPLACE TRIGGER MajSituationVehiculeAnnulation
AFTER DELETE ON Location FOR EACH ROW
BEGIN
    UPDATE Vehicule SET Situation = 'disponible' 
     WHERE NumVeh = :OLD.NumVeh 
       AND Situation != 'retraite';
END;
/

-- Interdiction de supprimer un véhicule en location
CREATE OR REPLACE TRIGGER InterditSupprimerVehiculeEnLocation
BEFORE DELETE ON Vehicule FOR EACH ROW
BEGIN
    IF :OLD.Situation = 'location' THEN
        RAISE_APPLICATION_ERROR(-20041, 'Impossible de supprimer un véhicule en location');
    END IF;
END;
/

-- Interdiction de modifier un véhicule en retraite
CREATE OR REPLACE TRIGGER InterditModifVehiculeRetraite
BEFORE UPDATE ON Vehicule FOR EACH ROW
BEGIN
    IF :OLD.Situation = 'retraite' THEN
        RAISE_APPLICATION_ERROR(-20050, 'Impossible de modifier un véhicule en retraite (historique)');
    END IF;
END;
/

-- Interdiction de supprimer un véhicule en retraite
CREATE OR REPLACE TRIGGER InterditSupprimerVehiculeRetraite
BEFORE DELETE ON Vehicule FOR EACH ROW
BEGIN
    IF :OLD.Situation = 'retraite' THEN
        RAISE_APPLICATION_ERROR(-20051, 'Impossible de supprimer un véhicule en retraite (historique)');
    END IF;
END;
/

-- Interdiction de supprimer une ligne dans VehiculeRetraite (historique protégé)
CREATE OR REPLACE TRIGGER InterditSupprimerLigneRetraite
BEFORE DELETE ON VehiculeRetraite FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20052, 'Impossible de supprimer un véhicule de la table VehiculeRetraite est une table historique ');
END;
/
