-- EXERCICES INSERT
-- 1. Ajouter le client John Smith (john.smith@ancien.com)
INSERT INTO clients (nom, prenom, email, date_inscription, fidelite_points)
VALUES ('Smith', 'John', 'john.smith@ancien.com', CURRENT_DATE, 0);

-- 2. Insérer une nouvelle commande comprenant les livres 1, 2 et 3.
INSERT INTO commandes (id_client, date_commande, statut)
VALUES (16, NOW(), 'en_attente');
INSERT INTO details_commande (id_commande, id_livre, quantite, prix_unitaire)
SELECT LAST_INSERT_ID(),
       id_livre,
       1,
       prix
FROM livres
WHERE id_livre IN (1, 2, 3);

-- 3.	Ajouter 50 exemplaires au stock de l'éditeur num 1
UPDATE livres
SET stock = stock + 50
WHERE id_editeur = 1;

-- 4.	Augmenter de 5 % le prix (arrondi) de tous les livres de l'éditeur num 1
UPDATE livres
SET prix = ROUND(prix * 1.05, 2)
WHERE id_editeur = 1;

-- 5.	Modifier le statut (annulee) des commandes non traitées (en_attente) depuis plus d'un mois
UPDATE commandes
SET statut = 'annulee'
WHERE statut = 'en_attente'
  AND date_commande < DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- 6. Mettre à jour les points de fidélité selon le montant total des commandes
UPDATE clients
SET fidelite_points = 0
WHERE fidelite_points IS NOT NULL;

UPDATE clients
SET fidelite_points = (SELECT FLOOR(SUM(montant_total) / 10)
                       FROM commandes
                       WHERE (statut = 'livree' OR statut = 'expediee')
                         AND commandes.id_client = clients.id_client);

-- 7.	Modifier le domaine de tous les clients @ancien.com en @nouveau.com
UPDATE clients
SET email = REPLACE(email, '@ancien.com', '@nouveau.com')
WHERE email LIKE '%@ancien.com';

-- 8.	Mettre à jour le montant total des commandes, uniquement pour celles dont le montant ne correspond pas réellement au détail de la commande
WITH montant_commande AS (SELECT id_commande, SUM(quantite * prix_unitaire) as "total_calcule"
                          FROM details_commande
                          GROUP BY id_commande)
UPDATE commandes
    INNER JOIN montant_commande
    ON commandes.id_commande = montant_commande.id_commande
SET montant_total = total_calcule
WHERE montant_total != total_calcule
   OR total_calcule IS NULL;

-- Pour vérifier
SELECT commandes.id_commande, montant_total, SUM(quantite * prix_unitaire)
FROM commandes
         INNER JOIN details_commande ON details_commande.id_commande = commandes.id_commande
GROUP BY commandes.id_commande;

-- EXERCICES DELETE
-- 9.	Supprimer toutes les commandes annulées de plus de 6 mois
DELETE
FROM details_commande
WHERE details_commande.id_commande IN (SELECT id_commande
                                       FROM commandes
                                       WHERE statut = 'annulee'
                                         AND date_commande < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH));

DELETE
FROM commandes
WHERE statut = 'annulee'
  AND date_commande < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- 10.	Retirer les auteurs n’ayant publié aucun livre
DELETE
FROM auteurs
WHERE id_auteur NOT IN (SELECT DISTINCT id_auteur
                        FROM auteurs_livres);

-- 11.	Supprimer les clients qui ont déjà passé une commande, mais qui n’en ont pas passé depuis plus d'un an (sans supprimer les commandes)
ALTER TABLE `commandes`
    DROP FOREIGN KEY `commandes_ibfk_1`;
ALTER TABLE `commandes`
    ADD CONSTRAINT `commandes_ibfk_1`
        FOREIGN KEY (`id_client`) REFERENCES `clients` (`id_client`)
            ON DELETE SET NULL
            ON UPDATE SET NULL;

DELETE
FROM clients
WHERE id_client IN (SELECT DISTINCT clients.id_client
                    FROM clients
                             INNER JOIN commandes ON clients.id_client = commandes.id_client
                    WHERE clients.id_client NOT IN (SELECT id_client
                                                    FROM commandes
                                                    WHERE date_commande > DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)));


