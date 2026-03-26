-- ============================================================================
-- Projet : Gestion de Location de Véhicules
-- Amani CHAMMAKHI - Amina KHELIDJ - Ikram SADOUDI
-- Groupe : 11
-- ============================================================================

-- ============================================================================
-- SUPPRESSION DES OBJETS EXISTANTS
-- ============================================================================

-- Suppression des procédures et fonctions
DROP PROCEDURE AjouterVehicule;
DROP PROCEDURE VehiculesDisponibles;
DROP FUNCTION ChiffreAffaires;
DROP PROCEDURE LouerVehicule;
DROP PROCEDURE RetournerVehicule;
DROP FUNCTION FormuleAvantageuse;

-- Suppression des séquences
DROP SEQUENCE seqVehicule;
DROP SEQUENCE seqLocation;

-- Suppression des tables (dans l'ordre imposé par les contraintes)
DROP TABLE Location CASCADE CONSTRAINTS;
DROP TABLE Tarif CASCADE CONSTRAINTS;
DROP TABLE Formules CASCADE CONSTRAINTS;
DROP TABLE Vehicule CASCADE CONSTRAINTS;
DROP TABLE Modeles CASCADE CONSTRAINTS;
DROP TABLE Types CASCADE CONSTRAINTS;

-- ============================================================================
-- CRÉATION DES TABLES
-- ============================================================================

-- Table Types
CREATE TABLE Types (
    IdType NUMBER PRIMARY KEY,
    Type VARCHAR2(50) NOT NULL UNIQUE
);

-- Table Modeles
CREATE TABLE Modeles (
    Modele VARCHAR2(50) PRIMARY KEY,
    Marque VARCHAR2(50) NOT NULL,
    IdType NUMBER NOT NULL,
    CONSTRAINT fk_modeles_types FOREIGN KEY (IdType) REFERENCES Types(IdType)
);

-- Table Vehicule
CREATE TABLE Vehicule (
    NumVehicule NUMBER PRIMARY KEY,
    Modele VARCHAR2(50) NOT NULL,
    Matricule CHAR(8) NOT NULL UNIQUE,
    DateMatricule DATE NOT NULL,
    Kilometrage NUMBER NOT NULL CHECK (Kilometrage >= 0),
    Situation VARCHAR2(20) DEFAULT 'disponible' CHECK (Situation IN ('disponible', 'location')),
    CONSTRAINT fk_vehicule_modeles FOREIGN KEY (Modele) REFERENCES Modeles(Modele)
);

-- Table Formules
CREATE TABLE Formules (
    Formule VARCHAR2(50) PRIMARY KEY,
    NbJours NUMBER NOT NULL CHECK (NbJours > 0),
    KmMax NUMBER NOT NULL CHECK (KmMax > 0)
);

-- Table Tarif
CREATE TABLE Tarif (
    IdType NUMBER,
    Formule VARCHAR2(50),
    Prix NUMBER NOT NULL CHECK (Prix >= 0),
    PrixKmSupp NUMBER NOT NULL CHECK (PrixKmSupp >= 0),
    CONSTRAINT pk_tarif PRIMARY KEY (IdType, Formule),
    CONSTRAINT fk_tarif_types FOREIGN KEY (IdType) REFERENCES Types(IdType),
    CONSTRAINT fk_tarif_formules FOREIGN KEY (Formule) REFERENCES Formules(Formule)
);

-- Table Location
CREATE TABLE Location (
    NumLocation NUMBER PRIMARY KEY,
    NumVehicule NUMBER NOT NULL,
    Formule VARCHAR2(50) NOT NULL,
    DateDepart DATE NOT NULL,
    DateRetour DATE,
    NbKm NUMBER CHECK (NbKm >= 0),
    Montant NUMBER CHECK (Montant >= 0),
    CONSTRAINT fk_location_vehicule FOREIGN KEY (NumVehicule) REFERENCES Vehicule(NumVehicule),
    CONSTRAINT fk_location_formules FOREIGN KEY (Formule) REFERENCES Formules(Formule),
    CONSTRAINT chk_dates CHECK (DateRetour IS NULL OR DateRetour >= DateDepart)
);

-- ============================================================================
-- CRÉATION DES SÉQUENCES
-- ============================================================================

CREATE SEQUENCE seqVehicule START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seqLocation START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- INSERTION DES DONNÉES
-- ============================================================================

-- Insertion des Types
INSERT INTO Types VALUES (1, 'Citadine');
INSERT INTO Types VALUES (2, 'Berline');
INSERT INTO Types VALUES (3, 'Monospace');
INSERT INTO Types VALUES (4, 'SUV');
INSERT INTO Types VALUES (5, '3m3');
INSERT INTO Types VALUES (6, '9m3');
INSERT INTO Types VALUES (7, '14m3');

-- Insertion des Modèles
INSERT INTO Modeles VALUES ('CLIO', 'RENAULT', 1);
INSERT INTO Modeles VALUES ('SCENIC', 'RENAULT', 3);
INSERT INTO Modeles VALUES ('208', 'PEUGEOT', 1);
INSERT INTO Modeles VALUES ('508', 'PEUGEOT', 2);
INSERT INTO Modeles VALUES ('PICASSO', 'CITROEN', 3);
INSERT INTO Modeles VALUES ('C3', 'CITROEN', 1);
INSERT INTO Modeles VALUES ('A4', 'AUDI', 2);
INSERT INTO Modeles VALUES ('TIGUAN', 'VW', 4);
INSERT INTO Modeles VALUES ('5008', 'PEUGEOT', 4);
INSERT INTO Modeles VALUES ('KANGOO', 'RENAULT', 5);
INSERT INTO Modeles VALUES ('VITO', 'MERCEDES', 6);
INSERT INTO Modeles VALUES ('TRANSIT', 'FORD', 6);
INSERT INTO Modeles VALUES ('DUCATO', 'FIAT', 7);
INSERT INTO Modeles VALUES ('MASTER', 'RENAULT', 7);

-- Insertion des Formules
INSERT INTO Formules VALUES ('jour', 1, 100);
INSERT INTO Formules VALUES ('fin-semaine', 2, 200);
INSERT INTO Formules VALUES ('semaine', 7, 500);
INSERT INTO Formules VALUES ('mois', 30, 1500);

-- Insertion des Tarifs
INSERT INTO Tarif VALUES (1, 'jour', 39, 0.3);
INSERT INTO Tarif VALUES (1, 'fin-semaine', 69, 0.3);
INSERT INTO Tarif VALUES (1, 'semaine', 199, 0.3);
INSERT INTO Tarif VALUES (1, 'mois', 499, 0.3);
INSERT INTO Tarif VALUES (2, 'jour', 59, 0.4);
INSERT INTO Tarif VALUES (2, 'fin-semaine', 99, 0.4);
INSERT INTO Tarif VALUES (2, 'semaine', 299, 0.4);
INSERT INTO Tarif VALUES (2, 'mois', 799, 0.4);
INSERT INTO Tarif VALUES (3, 'jour', 69, 0.4);
INSERT INTO Tarif VALUES (3, 'fin-semaine', 129, 0.4);
INSERT INTO Tarif VALUES (3, 'semaine', 499, 0.4);
INSERT INTO Tarif VALUES (3, 'mois', 1099, 0.4);
INSERT INTO Tarif VALUES (4, 'jour', 69, 0.4);
INSERT INTO Tarif VALUES (4, 'fin-semaine', 129, 0.4);
INSERT INTO Tarif VALUES (4, 'semaine', 499, 0.4);
INSERT INTO Tarif VALUES (4, 'mois', 1099, 0.4);
INSERT INTO Tarif VALUES (5, 'jour', 39, 0.3);
INSERT INTO Tarif VALUES (5, 'fin-semaine', 79, 0.3);
INSERT INTO Tarif VALUES (5, 'semaine', 199, 0.3);
INSERT INTO Tarif VALUES (5, 'mois', 599, 0.3);
INSERT INTO Tarif VALUES (6, 'jour', 49, 0.4);
INSERT INTO Tarif VALUES (6, 'fin-semaine', 99, 0.4);
INSERT INTO Tarif VALUES (6, 'semaine', 259, 0.4);
INSERT INTO Tarif VALUES (6, 'mois', 899, 0.4);
INSERT INTO Tarif VALUES (7, 'jour', 79, 0.45);
INSERT INTO Tarif VALUES (7, 'fin-semaine', 159, 0.45);
INSERT INTO Tarif VALUES (7, 'semaine', 359, 0.45);
INSERT INTO Tarif VALUES (7, 'mois', 1199, 0.45);

COMMIT;

-- ============================================================================
-- PROCÉDURES ET FONCTIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Procédure : AjouterVehicule
-- Description : Ajoute un nouveau véhicule ou met à jour un existant
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE AjouterVehicule(
    Model IN VARCHAR2,
    Mat IN CHAR,
    DateMat IN DATE,
    Km IN NUMBER
) AS
    v_count NUMBER;
    v_num_vehicule NUMBER;
BEGIN
    -- Vérification des paramètres obligatoires
    IF Model IS NULL OR Mat IS NULL OR DateMat IS NULL OR Km IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erreur : Tous les paramètres sont obligatoires');
    END IF;
    
    -- Vérification que le kilométrage n'est pas négatif
    IF Km < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erreur : Le kilométrage ne peut pas être négatif');
    END IF;
    
    -- Vérification que le modèle existe
    SELECT COUNT(*) INTO v_count FROM Modeles WHERE Modele = Model;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Erreur : Le modèle ' || Model || ' n''existe pas');
    END IF;
    
    -- Vérification si le matricule existe déjà
    SELECT COUNT(*) INTO v_count FROM Vehicule WHERE Matricule = Mat;
    
    IF v_count > 0 THEN
        -- Mise à jour du véhicule existant
        UPDATE Vehicule 
        SET Modele = Model,
            DateMatricule = DateMat,
            Kilometrage = Km
        WHERE Matricule = Mat;
        
        DBMS_OUTPUT.PUT_LINE('On fait une modification d''un véhicule existant (Matricule en double)');
    ELSE
        -- Insertion d'un nouveau véhicule
        SELECT seqVehicule.NEXTVAL INTO v_num_vehicule FROM DUAL;
        
        INSERT INTO Vehicule (NumVehicule, Modele, Matricule, DateMatricule, Kilometrage, Situation)
        VALUES (v_num_vehicule, Model, Mat, DateMat, Km, 'disponible');
        
        DBMS_OUTPUT.PUT_LINE('Véhicule ajouté avec le numéro ' || v_num_vehicule);
    END IF;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END AjouterVehicule;
/

-- ----------------------------------------------------------------------------
-- Procédure : VehiculesDisponibles
-- Description : Affiche la liste des véhicules disponibles d'un type donné
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE VehiculesDisponibles(
    Typ IN VARCHAR2
) AS
    v_count NUMBER;
    v_id_type NUMBER;
    
    CURSOR c_vehicules IS
        SELECT v.NumVehicule, v.Modele, m.Marque, v.Matricule, v.Kilometrage
        FROM Vehicule v
        JOIN Modeles m ON v.Modele = m.Modele
        WHERE v.Situation = 'disponible'
        AND m.IdType = v_id_type
        ORDER BY m.Marque, v.Modele;
BEGIN
    -- Vérification que le type existe
    SELECT COUNT(*), MAX(IdType) INTO v_count, v_id_type 
    FROM Types 
    WHERE Type = Typ;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Erreur : Le type ' || Typ || ' n''existe pas');
    END IF;
    
    -- Compter les véhicules disponibles
    SELECT COUNT(*) INTO v_count
    FROM Vehicule v
    JOIN Modeles m ON v.Modele = m.Modele
    WHERE v.Situation = 'disponible'
    AND m.IdType = v_id_type;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pas de véhicule disponible dans le type demandé');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Liste des véhicules disponibles de type ' || Typ || ' :');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
        
        FOR rec IN c_vehicules LOOP
            DBMS_OUTPUT.PUT_LINE('Num: ' || rec.NumVehicule || 
                                ' | Marque: ' || rec.Marque || 
                                ' | Modèle: ' || rec.Modele || 
                                ' | Matricule: ' || rec.Matricule || 
                                ' | Km: ' || rec.Kilometrage);
        END LOOP;
    END IF;
END VehiculesDisponibles;
/

-- ----------------------------------------------------------------------------
-- Fonction : ChiffreAffaires
-- Description : Calcule le chiffre d'affaires selon les critères
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ChiffreAffaires(
    Formul IN VARCHAR2,
    Typ IN VARCHAR2
) RETURN NUMBER AS
    v_total NUMBER := 0;
    v_count NUMBER;
BEGIN
    -- Vérification que la formule existe (si non NULL)
    IF Formul IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count FROM Formules WHERE Formule = Formul;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20013, 'Erreur : La formule ''' || Formul || ''' n''existe pas');
        END IF;
    END IF;
    
    -- Vérification que le type existe (si non NULL)
    IF Typ IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count FROM Types WHERE Type = Typ;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20014, 'Erreur : Le type ''' || Typ || ''' n''existe pas');
        END IF;
    END IF;
    -- Calcul du chiffre d'affaires
    SELECT NVL(SUM(l.Montant), 0) INTO v_total
    FROM Location l
    JOIN Vehicule v ON l.NumVehicule = v.NumVehicule
    JOIN Modeles m ON v.Modele = m.Modele
    JOIN Types t ON m.IdType = t.IdType
    WHERE l.Montant IS NOT NULL
    AND (Formul IS NULL OR l.Formule = Formul)
    AND (Typ IS NULL OR t.Type = Typ);
    
    RETURN v_total;
END ChiffreAffaires;
/

-- ----------------------------------------------------------------------------
-- Procédure : LouerVehicule
-- Description : Enregistre une location de véhicule
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE LouerVehicule(
    NumVeh IN NUMBER,
    Formul IN VARCHAR2,
    Depart IN DATE
) AS
    v_count NUMBER;
    v_situation VARCHAR2(20);
    v_num_location NUMBER;
    v_date_retour DATE;
    v_nb_jours NUMBER;
BEGIN
    -- Vérification que le véhicule existe
    SELECT COUNT(*), MAX(Situation) INTO v_count, v_situation
    FROM Vehicule
    WHERE NumVehicule = NumVeh;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Erreur : Le véhicule ' || NumVeh || ' n''existe pas');
    END IF;
    
    -- Vérification que le véhicule est disponible
    IF v_situation != 'disponible' THEN
        RAISE_APPLICATION_ERROR(-20006, 'Erreur : Le véhicule est déjà en location');
    END IF;
    
    -- Vérification que la formule existe
    SELECT COUNT(*), MAX(NbJours) INTO v_count, v_nb_jours
    FROM Formules
    WHERE Formule = Formul;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Erreur : La formule ' || Formul || ' n''existe pas');
    END IF;
    
    -- Vérification de la date de départ
    IF Depart < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : La date de départ doit être >= date du jour');
    END IF;
    
    -- Calcul de la date de retour prévisionnelle
    v_date_retour := Depart + v_nb_jours;
    
    -- Création de la location
    SELECT seqLocation.NEXTVAL INTO v_num_location FROM DUAL;
    
    INSERT INTO Location (NumLocation, NumVehicule, Formule, DateDepart, DateRetour, NbKm, Montant)
    VALUES (v_num_location, NumVeh, Formul, Depart, v_date_retour, NULL, NULL);
    
    -- Mise à jour de la situation du véhicule
    UPDATE Vehicule
    SET Situation = 'location'
    WHERE NumVehicule = NumVeh;
    
    DBMS_OUTPUT.PUT_LINE('Location créée avec le numéro ' || v_num_location);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END LouerVehicule;
/

-- ----------------------------------------------------------------------------
-- Procédure : RetournerVehicule
-- Description : Enregistre le retour d'un véhicule loué
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE RetournerVehicule(
    NumVeh IN NUMBER,
    Retour IN DATE,
    Km IN NUMBER
) AS
    v_count NUMBER;
    v_num_location NUMBER;
    v_date_depart DATE;
    v_formule VARCHAR2(50);
    v_id_type NUMBER;
    v_prix NUMBER;
    v_prix_km_supp NUMBER;
    v_km_max NUMBER;
    v_montant NUMBER;
BEGIN
    -- Vérification que le véhicule existe
    SELECT COUNT(*) INTO v_count FROM Vehicule WHERE NumVehicule = NumVeh;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : Le véhicule ' || NumVeh || ' n''existe pas');
    END IF;
    
    -- Vérification qu'il y a une location en cours
    SELECT COUNT(*), MAX(NumLocation), MAX(DateDepart), MAX(Formule)
    INTO v_count, v_num_location, v_date_depart, v_formule
    FROM Location
    WHERE NumVehicule = NumVeh
    AND Montant IS NULL
    AND NbKm IS NULL;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Erreur : Pas de location en cours pour ce véhicule');
    END IF;
    
    -- Vérification de la date de retour
    IF Retour < v_date_depart THEN
        RAISE_APPLICATION_ERROR(-20011, 'Erreur : La date de retour ne peut pas être inférieure à la date de départ');
    END IF;
    
    -- Vérification du kilométrage
    IF Km <= 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Erreur : Le kilométrage doit être positif');
    END IF;
    
    -- Récupération des informations de tarification
    SELECT m.IdType INTO v_id_type
    FROM Vehicule v
    JOIN Modeles m ON v.Modele = m.Modele
    WHERE v.NumVehicule = NumVeh;
    
    SELECT Prix, PrixKmSupp INTO v_prix, v_prix_km_supp
    FROM Tarif
    WHERE IdType = v_id_type
    AND Formule = v_formule;
    
    SELECT KmMax INTO v_km_max
    FROM Formules
    WHERE Formule = v_formule;
    
    -- Calcul du montant
    IF (Km - v_km_max) > 0 THEN
        v_montant := v_prix + v_prix_km_supp * (Km - v_km_max);
    ELSE
        v_montant := v_prix;
    END IF;
    
    -- Mise à jour de la location
    UPDATE Location
    SET DateRetour = Retour,
        NbKm = Km,
        Montant = v_montant
    WHERE NumLocation = v_num_location;
    
    -- Mise à jour du véhicule
    UPDATE Vehicule
    SET Situation = 'disponible',
        Kilometrage = Kilometrage + Km
    WHERE NumVehicule = NumVeh;
    
    DBMS_OUTPUT.PUT_LINE('Retour enregistré - Montant: ' || v_montant || ' Euros');
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END RetournerVehicule;
/

-- ----------------------------------------------------------------------------
-- Fonction : FormuleAvantageuse
-- Description : Retourne la formule la plus économique
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION FormuleAvantageuse(
    Duree IN NUMBER,
    Typ IN VARCHAR2,
    Km IN NUMBER
) RETURN VARCHAR2 AS
    v_count NUMBER;
    v_id_type NUMBER;
    v_formule_opt VARCHAR2(50);
    v_tarif_opt NUMBER := 999999;
    v_tarif_calc NUMBER;
    v_prix NUMBER;
    v_prix_km_supp NUMBER;
    v_km_max NUMBER;
    v_result VARCHAR2(200);
    
    CURSOR c_tarifs IS
        SELECT t.Formule, t.Prix, t.PrixKmSupp, f.KmMax, f.NbJours
        FROM Tarif t
        JOIN Formules f ON t.Formule = f.Formule
        WHERE t.IdType = v_id_type
        AND f.NbJours >= Duree;
BEGIN
    -- Vérification des paramètres obligatoires
    IF Duree IS NULL OR Typ IS NULL OR Km IS NULL THEN
        RETURN 'Erreur : Un des paramètres ne peut pas être NULL';
    END IF;
    
    -- Vérification que le type existe
    SELECT COUNT(*), MAX(IdType) INTO v_count, v_id_type
    FROM Types
    WHERE Type = Typ;
    
    IF v_count = 0 THEN
        RETURN 'Erreur : Le type ' || Typ || ' est inconnu';
    END IF;
    
    -- Recherche de la formule la plus avantageuse
   FOR rec IN c_tarifs LOOP
    IF (Km - rec.KmMax) > 0 THEN
        v_tarif_calc := rec.Prix + rec.PrixKmSupp * (Km - rec.KmMax);
    ELSE
        v_tarif_calc := rec.Prix;
    END IF;
    
    IF v_tarif_calc < v_tarif_opt THEN
        v_tarif_opt := v_tarif_calc;
        v_formule_opt := rec.Formule;
    END IF;
END LOOP;
    
    IF v_formule_opt IS NULL THEN
        RETURN 'Aucune formule disponible pour cette durée';
    END IF;
    
    v_result := 'Formule "' || v_formule_opt || '" au tarif de ' || v_tarif_opt || ' Euros';
    RETURN v_result;
END FormuleAvantageuse;
/

-- ============================================================================
-- FIN DU SCRIPT
-- ============================================================================

-- Activation de l'affichage des sorties
SET SERVEROUTPUT ON;

-- Message de fin
BEGIN
    DBMS_OUTPUT.PUT_LINE('Script compilé avec succès !');
    DBMS_OUTPUT.PUT_LINE('Toutes les tables, séquences, procédures et fonctions ont été créées.');
END;
/



-- Test de AjouterVehicule
EXECUTE AjouterVehicule('CLIO','GA001AG','01/09/2021',1400);
EXECUTE AjouterVehicule('208','GA002AG','01/09/2021',1500);
EXECUTE AjouterVehicule('C3','GB003BG','15/09/2021',1000);
EXECUTE AjouterVehicule('A4','GB004BG','15/09/2021',500);
EXECUTE AjouterVehicule('508','GC006CG','01/10/2021',900);
EXECUTE AjouterVehicule('PICASSO','GF007FG','15/10/2021',300);
EXECUTE AjouterVehicule('SCENIC','GF008FG','15/10/2021',400);
EXECUTE AjouterVehicule('5008','GF009FG','15/10/2021',1000);
EXECUTE AjouterVehicule('KANGOO','GA010AG','01/09/2021',2000);
EXECUTE AjouterVehicule('TRANSIT','GA011AG','01/09/2021',2500);
-- La ligne suivante doit indiquer qu'on fait une modification d'un v�hicule existant (Matricule en double)
EXECUTE AjouterVehicule('MASTER','GA011AG','11/09/2021',1500); 
-- La ligne suivante doit lever une erreur car le Kilom�trage est n�gatif
EXECUTE AjouterVehicule('DUCATO','GB013BG','15/09/2021',-1000);
--  La ligne suivante doit lever une erreur car le mod�le est inexistant
EXECUTE AjouterVehicule('PASSAT','GC005CG','01/10/2021',1200);
-- La ligne suivante doit lever une erreur car une des valeurs est NULL (ou absente)
EXECUTE AjouterVehicule('208','GF005FG',NULL,1200);

-- Test de LouerVehicule
EXECUTE LouerVehicule(1,'jour',SYSDATE);
EXECUTE LouerVehicule(2,'mois',SYSDATE+1);
EXECUTE LouerVehicule(4,'jour',SYSDATE);
EXECUTE LouerVehicule(6,'fin-semaine',SYSDATE+2);
EXECUTE LouerVehicule(7,'semaine',SYSDATE);
EXECUTE LouerVehicule(10,'fin-semaine',SYSDATE+1);
-- La ligne suivante doit que le V�hicule est d�j� en location (non disponible)
EXECUTE LouerVehicule(2,'semaine',SYSDATE+1);
-- La ligne suivante doit afficher que le V�hicule n'existe pas
EXECUTE LouerVehicule(11,'semaine',SYSDATE);
-- La ligne suivante doit afficher que le Formule n'existe pas 
EXECUTE LouerVehicule(3,'week-end',SYSDATE);

-- Test de VehiculesDisponibles
-- liste des v�hicules de type 'Citadine' disponibles
EXECUTE VehiculesDisponibles('Citadine');
 -- La ligne suivante doit lever une erreur car il n'y a pas de v�hicule disponible pour le type '14m3'
EXECUTE VehiculesDisponibles('14m3');
-- La ligne suivante doit afficher que le Type Utilitaire est inconnu
EXECUTE VehiculesDisponibles('Utilitaire');

-- Test de RetournerVehicule
EXECUTE RetournerVehicule(1,SYSDATE+3,120);
EXECUTE RetournerVehicule(4,SYSDATE+1,100);
EXECUTE RetournerVehicule(7,SYSDATE+7,900);
--  La ligne suivante doit afficher qu'il n'y a pas de location pour ce v�hicule
EXECUTE RetournerVehicule(1,SYSDATE+1,100);
--  La ligne suivante doit afficher que le V�hicule n'existe pas
EXECUTE RetournerVehicule(11,SYSDATE+1,110); 
--  La ligne suivante doit afficher que la date de retour ne peut pas �tre inf�rieure � la date de d�part
EXECUTE RetournerVehicule(6,SYSDATE+1,500);
--  La ligne suivante doit provoquer une erreur car Km est n�gatif ou nul
EXECUTE RetournerVehicule(6,SYSDATE+4,-500);

-- Test de ChiffreAffaires
-- R�sultat de CA - Jour - Citadine = 45
SELECT ChiffreAffaires('jour','Citadine') FROM Dual; 
-- R�sultat de CA - NULL - Monospace = 659
SELECT ChiffreAffaires(null,'Monospace') FROM Dual; 
-- R�sultat de CA - Jour - NULL = 104
SELECT ChiffreAffaires('jour',null) FROM Dual;
-- R�sultat de CA - NULL - NULL = 763
SELECT ChiffreAffaires(null,null) FROM Dual; 
-- Doit provoquer une erreur car la formule est inconnue (-1)
SELECT ChiffreAffaires('week-end','Berline') FROM Dual;
-- Doit provoquer une erreur car le type est inconnu (-2)
SELECT ChiffreAffaires('semaine', 'Utilitaire') FROM Dual;

-- Test de FormuleAvantageuse
-- La ligne suivante doit afficher que la formule "semaine" au Tarif de 199 Euros est la plus avantageuse
SELECT FormuleAvantageuse(3,'Citadine',500) FROM Dual;
-- ligne suivante doit afficher que le Type est inconnu
SELECT FormuleAvantageuse(3,'4x4',500) FROM Dual;
-- La ligne suivante doit afficher qu'un des param�tres ne peut pas �tre NULL
SELECT FormuleAvantageuse(3,'4x4',NULL) FROM Dual;
