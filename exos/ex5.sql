-- 1. Ajouter le client John Smith (john.smith@ancien.com)
INSERT INTO clients (nom, prenom, email)
    VALUE ('Smith', 'John', 'john.smith@ancien.com');

-- 2. Insérer une nouvelle commande comprenant les livres 1, 2 et 3.
INSERT INTO commandes (id_client, date_commande)
VALUES (1, NOW());
INSERT INTO details_commande (id_commande, id_livre, quantite)
VALUES ((SELECT MAX(id_commande) FROM commandes), 1, 1),
       ((SELECT MAX(id_commande) FROM commandes), 2, 1),
       ((SELECT MAX(id_commande) FROM commandes), 3, 1);

-- 3. Ajouter 50 exemplaires au stock de l'éditeur num 1
UPDATE livres
SET stock = stock + 50
WHERE id_editeur = 1;

-- 4. Augmenter de 5 % le prix (arrondi) de tous les livres de l'éditeur num 1
UPDATE livres
SET prix = ROUND(prix * 1.05)
WHERE id_editeur = 1;

-- 5. Modifier le statut des commandes non traitées "en_attente" depuis plus d'un mois à "annulee" .
UPDATE commandes
SET statut = 'annulee'
WHERE statut = 'en_attente'
  AND date_commande < DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- 6. Mettre à jour les points de fidélité selon le montant total des commandes
UPDATE clients c
    INNER JOIN (SELECT id_client, SUM(id_commande) AS total
                FROM commandes
                WHERE statut = 'livree'
                GROUP BY id_client) commandes_total
    ON c.id_client = commandes_total.id_client
SET c.fidelite_points = FLOOR(commandes_total.total / 10);

-- 7. Modifier le domaine de tous les clients @ancien.com en @nouveau.com
UPDATE clients
SET email = REPLACE(email, '@ancien.com', '@nouveau.com')
WHERE email LIKE '%@ancien.com';

-- 8. Mettre à jour le montant total des commandes, uniquement pour celles dont le montant ne correspond pas réellement au détail de la commande
UPDATE commandes c
SET c.montant_total = (SELECT SUM(d.prix_unitaire * d.quantite)
                       FROM details_commande d
                       WHERE d.id_commande = c.id_commande)
WHERE c.montant_total <> (SELECT SUM(d.prix_unitaire * d.quantite)
                          FROM details_commande d
                          WHERE d.id_commande = c.id_commande);

-- 9. Supprimer toutes les commandes annulées de plus de 6 mois (ne pas toucher à la structure de la BDD)
DELETE
FROM commandes
WHERE statut = 'annulee'
  AND date_commande < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- 10. Retirer les auteurs n’ayant publié aucun livre
DELETE
FROM auteurs
WHERE id_auteur NOT IN (SELECT DISTINCT al.id_auteur
                        FROM livres l
                                 INNER JOIN auteurs_livres al
                                            ON al.id_livre = l.id_livre);

-- 11. Supprimer les clients qui ont déjà passé une commande, mais qui n’en ont pas passé depuis plus d'un an (sans supprimer les commandes)
DELETE
FROM clients
WHERE id_client IN (SELECT id_client
                    FROM commandes
                    WHERE date_commande < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
                      AND id_client NOT IN (SELECT DISTINCT id_client
                                            FROM commandes
                                            WHERE date_commande >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)));
