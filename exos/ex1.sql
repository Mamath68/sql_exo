-- Créer une table 'evenements_litteraires' avec
-- Un ID auto-incrémenté
-- Un nom d'événement (obligatoire)
-- Une date de début et de fin (la date de fin doit être après la date de début)
-- Une ville
-- Un budget maximum
-- Une contrainte de vérification que le budget est positif
CREATE TABLE evenements_litteraires
(
    id_evenement INT PRIMARY KEY AUTO_INCREMENT,
    nom          VARCHAR(100) NOT NULL,
    date_debut   DATE         NOT NULL,
    date_fin     DATE         NOT NULL,
    ville        VARCHAR(50),
    budget       DECIMAL(10, 2),
    CONSTRAINT chk_dates CHECK (date_fin >= date_debut),
    CONSTRAINT chk_budget CHECK (budget > 0)
) ENGINE = InnoDB;

-- Modifier la table 'livres' pour :
-- Ajouter une colonne 'isbn' unique
-- Ajouter une contrainte sur le prix (doit être > 0)
-- Ajouter un index sur le titre
ALTER TABLE livres
    ADD COLUMN isbn VARCHAR(13) UNIQUE,
    ADD CONSTRAINT chk_prix CHECK (prix > 0),
    ADD INDEX idx_titre (titre);

-- Créer une table 'prix_litteraires' qui :
-- Référence un livre
-- Référence un ou plusieurs auteurs
-- A une année d'attribution
-- A un montant de récompense
-- Ne permet pas d'attribuer le même prix au même livre plusieurs fois
CREATE TABLE prix_litteraires
(
    id_prix  INT PRIMARY KEY AUTO_INCREMENT,
    nom_prix VARCHAR(100) NOT NULL,
    id_livre INT,
    annee    YEAR         NOT NULL,
    montant  DECIMAL(10, 2),
    FOREIGN KEY (id_livre) REFERENCES livres (id_livre),
    UNIQUE KEY unique_prix_livre_annee (nom_prix, id_livre, annee)
) ENGINE = InnoDB;

CREATE TABLE prix_auteurs
(
    id_prix_auteur INT PRIMARY KEY AUTO_INCREMENT,
    id_prix        INT,
    id_auteur      INT,
    FOREIGN KEY (id_prix) REFERENCES prix_litteraires (id_prix),
    FOREIGN KEY (id_auteur) REFERENCES auteurs (id_auteur)
) ENGINE = InnoDB;

-- Créer une table pour gérer les bibliothèques du réseau avec :
-- ID auto-incrémenté
-- Nom (obligatoire)
-- Adresse (obligatoire)
-- Surface en m² (positive)
-- Nombre maximum de livres (doit être > 1000)
-- Code postal (5 caractères exactement)
-- Date d'inauguration
CREATE TABLE bibliotheques
(
    id_bibliotheque   INT PRIMARY KEY AUTO_INCREMENT,
    nom               VARCHAR(100) NOT NULL,
    adresse           TEXT         NOT NULL,
    surface_m2        DECIMAL(8, 2),
    capacite_livres   INT,
    code_postal       CHAR(5),
    date_inauguration DATE,
    CONSTRAINT chk_surface CHECK (surface_m2 > 0),
    CONSTRAINT chk_capacite CHECK (capacite_livres >= 1000),
    CONSTRAINT chk_code_postal CHECK (code_postal REGEXP '^[0-9]{5}$')
) ENGINE = InnoDB;


-- Exercice 2 : Employés
-- Créer une table pour les employés avec :
-- ID auto-incrémenté
-- Numéro de sécurité sociale (unique, 15 caractères)
-- Nom et prénom (obligatoires)
-- Email professionnel (unique)
-- Date d'embauche
-- Salaire (doit être entre le SMIC et 100000)
-- ID de la bibliothèque (clé étrangère)
CREATE TABLE employes
(
    id_employe      INT PRIMARY KEY AUTO_INCREMENT,
    numero_secu     CHAR(15) UNIQUE,
    nom             VARCHAR(50) NOT NULL,
    prenom          VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    date_embauche   DATE        NOT NULL,
    salaire         DECIMAL(8, 2),
    id_bibliotheque INT,
    CONSTRAINT chk_salaire CHECK (salaire BETWEEN 1709.28 AND 100000),
    CONSTRAINT fk_bibliotheque FOREIGN KEY (id_bibliotheque)
        REFERENCES bibliotheques (id_bibliotheque),
    CONSTRAINT chk_numero_secu CHECK (numero_secu REGEXP '^[0-9]{15}$')
) ENGINE = InnoDB;


-- Exercice 3 : Prêts
-- Créer une table pour gérer les prêts avec :
-- ID auto-incrémenté
-- ID du livre (clé étrangère)
-- ID du client (clé étrangère)
-- Date de prêt (obligatoire)
-- Date de retour prévue (obligatoire, doit être > date de prêt)
-- Date de retour effective
-- État du livre au retour (bon, moyen, mauvais)
CREATE TABLE prets
(
    id_pret               INT PRIMARY KEY AUTO_INCREMENT,
    id_livre              INT,
    id_client             INT,
    date_pret             DATE NOT NULL,
    date_retour_prevue    DATE NOT NULL,
    date_retour_effective DATE,
    etat_retour           ENUM ('bon', 'moyen', 'mauvais'),
    FOREIGN KEY (id_livre) REFERENCES livres (id_livre),
    FOREIGN KEY (id_client) REFERENCES clients (id_client),
    CONSTRAINT chk_dates_prevue CHECK (date_retour_prevue > date_pret)

) ENGINE = InnoDB;


-- Exercice 4 : Fournisseurs
-- Créer une table pour les fournisseurs avec :
-- ID auto-incrémenté
-- Raison sociale (obligatoire)
-- SIRET (unique, 14 caractères)
-- Contact principal (email et téléphone)
-- Délai de livraison en jours (entre 1 et 30)
-- Note de fiabilité (de 1 à 5)
-- Liste des catégories fournies (utiliser un type ENUM)
CREATE TABLE fournisseurs
(
    id_fournisseur      INT PRIMARY KEY AUTO_INCREMENT,
    raison_sociale      VARCHAR(100) NOT NULL,
    siret               CHAR(14) UNIQUE,
    email_contact       VARCHAR(100),
    telephone_contact   VARCHAR(15),
    delai_livraison     INT,
    note_fiabilite      DECIMAL(2, 1),
    categories_fournies SET ('Roman', 'Essai', 'Poésie', 'Jeunesse', 'BD'),
    CONSTRAINT chk_siret CHECK (siret REGEXP '^[0-9]{14}$'),
    CONSTRAINT chk_delai CHECK (delai_livraison BETWEEN 1 AND 30),
    CONSTRAINT chk_note CHECK (note_fiabilite BETWEEN 1 AND 5)
) ENGINE = InnoDB;


-- Exercice 5 : Événements
-- Créer une table pour les événements culturels avec :
-- ID auto-incrémenté
-- Type d'événement (conférence, atelier, lecture, exposition)
-- Date et heure de début
-- Durée en minutes (positive)
-- Nombre de places disponibles (> 0)
-- Public visé (enfants, ados, adultes, tout public)
-- Budget alloué (positif)
-- ID de la bibliothèque organisatrice (clé étrangère)
CREATE TABLE evenements
(
    id_evenement       INT PRIMARY KEY AUTO_INCREMENT,
    type_evenement     ENUM ('conférence', 'atelier', 'lecture', 'exposition') NOT NULL,
    date_heure_debut   DATETIME                                                NOT NULL,
    duree_minutes      INT,
    places_disponibles INT,
    public_vise        ENUM ('enfants', 'ados', 'adultes', 'tout public')      NOT NULL,
    budget             DECIMAL(8, 2),
    id_bibliotheque    INT,
    CONSTRAINT chk_event_duree CHECK (duree_minutes > 0),
    CONSTRAINT chk_event_places CHECK (places_disponibles > 0),
    CONSTRAINT chk_event_budget CHECK (budget > 0),
    FOREIGN KEY (id_bibliotheque) REFERENCES bibliotheques (id_bibliotheque)
) ENGINE = InnoDB;
