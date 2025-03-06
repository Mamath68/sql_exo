-- 1. Mettre à jour le montant total d'une commande lors de son ajout
DELIMITER |
CREATE TRIGGER after_insert_details_commande
    AFTER INSERT
    ON details_commande
    FOR EACH ROW
BEGIN
    UPDATE commandes c
    SET c.montant_total = (SELECT SUM(dc.quantite * dc.prix_unitaire)
                           FROM details_commande dc
                           WHERE dc.id_commande = NEW.id_commande)
    WHERE c.id_commande = NEW.id_commande;
END |
DELIMITER ;

