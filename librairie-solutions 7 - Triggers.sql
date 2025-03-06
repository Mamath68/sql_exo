/* TRIGGERS */
/* 1. Calculer automatiquement le montant total d'une commande après insertion du détail de la commande */
DELIMITER |
CREATE TRIGGER after_insert_details_commande AFTER INSERT
ON details_commande FOR EACH ROW
BEGIN
	UPDATE commandes
    SET montant_total = (SELECT SUM(quantite*prix_unitaire)
						 FROM details_commande
						 WHERE id_commande = NEW.id_commande)
	WHERE id_commande = NEW.id_commande;
END |
DELIMITER ;

/* 2a. Trigger après ajout d'une commande */
DELIMITER |
CREATE TRIGGER after_details_commande_insert 
AFTER INSERT ON details_commande
FOR EACH ROW
BEGIN
    UPDATE livres 
    SET stock = stock - NEW.quantite
    WHERE id_livre = NEW.id_livre;
END |
DELIMITER ;

/* 2b. Trigger après modification du statut d'une commande (pour l'annulation) */
DELIMITER |
CREATE TRIGGER after_commande_update 
AFTER UPDATE ON commandes
FOR EACH ROW
BEGIN
    -- Si la commande passe au statut 'annulee'
    IF NEW.statut = 'annulee' AND OLD.statut != 'annulee' THEN
        -- On remet en stock les quantités de tous les articles de la commande
        UPDATE livres l
        INNER JOIN details_commande dc ON l.id_livre = dc.id_livre
        SET l.stock = l.stock + dc.quantite
        WHERE dc.id_commande = NEW.id_commande;
    END IF;
END |
DELIMITER ;

/* 2c. Trigger avant suppression d'une commande */
DELIMITER |
CREATE TRIGGER before_commande_delete
BEFORE DELETE ON commandes
FOR EACH ROW
BEGIN
    -- Si la commande n'était pas annulée, on remet en stock
    IF OLD.statut != 'annulee' THEN
        UPDATE livres l
        INNER JOIN details_commande dc ON l.id_livre = dc.id_livre
        SET l.stock = l.stock + dc.quantite
        WHERE dc.id_commande = OLD.id_commande;
    END IF;
END |
DELIMITER ;

/* 3. Créer une table d'historique des prix des livres qui conserve les changements de prix 
	(prendre en compte les nouveaux livres) */
/* 3a. Création de la table d'historique */
CREATE TABLE historique_prix (
    id_historique INT PRIMARY KEY AUTO_INCREMENT,
    id_livre INT,
    ancien_prix DECIMAL(10,2),
    nouveau_prix DECIMAL(10,2),
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP,
    type_modification ENUM('CREATION', 'MODIFICATION') NOT NULL,
    FOREIGN KEY (id_livre) REFERENCES livres(id_livre)
);

/* 3b. Trigger pour les nouveaux livres */
DELIMITER |
CREATE TRIGGER after_livre_insert
AFTER INSERT ON livres
FOR EACH ROW
BEGIN
    INSERT INTO historique_prix (
        id_livre,
        ancien_prix,
        nouveau_prix,
        type_modification
    ) VALUES (
        NEW.id_livre,
        NULL,
        NEW.prix,
        'CREATION'
    );
END |
DELIMITER ;

/* 3c. Trigger pour les modifications de prix */
DELIMITER |
CREATE TRIGGER before_livre_update
BEFORE UPDATE ON livres
FOR EACH ROW
BEGIN
    IF OLD.prix != NEW.prix THEN
        INSERT INTO historique_prix (
            id_livre,
            ancien_prix,
            nouveau_prix,
            type_modification
        ) VALUES (
            NEW.id_livre,
            OLD.prix,
            NEW.prix,
            'MODIFICATION'
        );
    END IF;
END |
DELIMITER ;