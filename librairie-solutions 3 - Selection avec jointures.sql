-- 1. Lister les livres avec leurs auteurs et éditeurs
SELECT l.titre,
       CONCAT(a.prenom, ' ', a.nom) AS "auteur",
       e.nom                        AS "editeur"
FROM livres l
         INNER JOIN auteurs_livres AS al ON l.id_livre = al.id_livre
         INNER JOIN auteurs AS a ON al.id_auteur = a.id_auteur
         INNER JOIN editeurs AS e ON l.id_editeur = e.id_editeur
ORDER BY 1, 2;

-- 2. Trouver toutes les catégories, même celles sans livres, classé par nombre de livres décroissant puis par catégorie
SELECT c.nom AS "categorie", COUNT(l.id_livre) AS "nombre_livres"
FROM categories AS c
         LEFT OUTER JOIN livres AS l ON c.id_categorie = l.id_categorie
GROUP BY c.id_categorie, c.nom
ORDER BY 2 DESC, 1;

-- 3. Lister tous les livres avec leur auteur principal et leur éditeur
SELECT l.titre,
       CONCAT(a.prenom, ' ', a.nom) AS "auteur",
       e.nom                        AS "editeur"
FROM livres AS l
         JOIN auteurs_livres AS al ON l.id_livre = al.id_livre
         JOIN auteurs AS a ON al.id_auteur = a.id_auteur
         JOIN editeurs AS e ON l.id_editeur = e.id_editeur
WHERE al.role = 'principal'
ORDER BY l.titre;

-- 4. Croiser les ventes des auteurs par année
SELECT auteurs.nom,
       YEAR(commandes.date_commande)  AS "annee",
       SUM(details_commande.quantite) AS "total_ventes"
FROM auteurs
         INNER JOIN auteurs_livres ON auteurs.id_auteur = auteurs_livres.id_auteur
         INNER JOIN livres ON auteurs_livres.id_livre = livres.id_livre
         INNER JOIN details_commande ON livres.id_livre = details_commande.id_livre
         INNER JOIN commandes ON details_commande.id_commande = commandes.id_commande
WHERE commandes.date_commande IS NOT NULL
GROUP BY auteurs.id_auteur, YEAR(commandes.date_commande)
ORDER BY auteurs.nom, annee;

-- 5. Afficher les auteurs qui ont écrit dans plusieurs catégories
SELECT a.nom,
       a.prenom,
       COUNT(DISTINCT l.id_categorie) AS "nombre_categories",
       GROUP_CONCAT(DISTINCT cat.nom) AS "categories"
FROM auteurs AS a
         INNER JOIN auteurs_livres AS al ON a.id_auteur = al.id_auteur
         INNER JOIN livres AS l ON al.id_livre = l.id_livre
         INNER JOIN categories AS cat ON l.id_categorie = cat.id_categorie
GROUP BY a.id_auteur
HAVING nombre_categories > 1;

-- 6. Pour chaque livre, montrer le nombre de fois qu’il a été commandé, classé par nombres d'exemplaires décroissants puis par titre.
SELECT l.titre,
       COUNT(dc.id_commande) AS "nombre_commandes",
       SUM(dc.quantite)      AS "exemplaires_vendus"
FROM livres AS l
         LEFT JOIN details_commande AS dc ON l.id_livre = dc.id_livre
GROUP BY l.id_livre
ORDER BY 3 DESC;

-- 7. Calculer la répartition des ventes par catégorie
SELECT cat.nom                                       AS "categorie",
       COUNT(DISTINCT dc.id_commande)                AS "nombre_commandes",
       SUM(dc.quantite)                              AS "quantite_vendue",
       ROUND(SUM(dc.quantite * dc.prix_unitaire), 2) AS "chiffre_affaires",
       ROUND(SUM(dc.quantite * dc.prix_unitaire) * 100.0 /
             (SELECT SUM(quantite * prix_unitaire)
              FROM details_commande), 2)             AS "pourcentage_ca"
FROM categories AS cat
         INNER JOIN livres AS l ON cat.id_categorie = l.id_categorie
         INNER JOIN details_commande AS dc ON l.id_livre = dc.id_livre
GROUP BY cat.id_categorie
ORDER BY chiffre_affaires DESC;

-- 8. Trouver les paires d'auteurs qui ont collaboré sur au moins un livre
SELECT a1.nom AS "auteur_1", a2.nom AS "auteur_2", COUNT(al1.id_livre) AS "collaborations"
FROM auteurs_livres AS al1
         INNER JOIN auteurs_livres AS al2 ON al1.id_livre = al2.id_livre
         INNER JOIN auteurs AS a1 ON al1.id_auteur = a1.id_auteur
         INNER JOIN auteurs AS a2 ON al2.id_auteur = a2.id_auteur
WHERE al1.id_auteur < al2.id_auteur
GROUP BY 1, 2
ORDER BY 3;

-- 9. Afficher les auteurs n’ayant pas eu de ventes le mois courant de l'année précédente
SELECT a.nom, a.prenom
FROM auteurs a
WHERE a.id_auteur NOT IN (SELECT DISTINCT al.id_auteur
                          FROM auteurs_livres AS al
                                   INNER JOIN livres AS l ON al.id_livre = l.id_livre
                                   INNER JOIN details_commande AS dc ON l.id_livre = dc.id_livre
                                   INNER JOIN commandes AS c ON dc.id_commande = c.id_commande
                          WHERE MONTH(c.date_commande) = MONTH(CURRENT_DATE)
                            AND YEAR(c.date_commande) = YEAR(CURRENT_DATE) - 1);

-- 10. Afficher les livres plus chers que la moyenne de leur catégorie
SELECT l.titre, l.prix, c.nom AS "categorie"
FROM livres AS l
         INNER JOIN categories AS c ON l.id_categorie = c.id_categorie
WHERE l.prix > (SELECT AVG(prix)
                FROM livres AS l2
                WHERE l2.id_categorie = l.id_categorie)
ORDER BY c.nom, l.prix DESC;

-- 11. Lister les clients qui ont acheté plus que la moyenne
SELECT c.nom,
       c.prenom,
       SUM(cmd.montant_total) AS "total_achats"
FROM clients AS c
         INNER JOIN commandes AS cmd ON c.id_client = cmd.id_client
WHERE cmd.statut != 'annulee'
GROUP BY c.id_client
HAVING total_achats > (SELECT AVG(sous_total)
                       FROM (SELECT SUM(montant_total) AS "sous_total"
                             FROM commandes
                             WHERE statut != 'annulee'
                             GROUP BY id_client) AS moyennes);

-- 12. Trouver les auteurs qui ont vendu plus que la moyenne des auteurs de leur nationalité
SELECT a.nom,
       a.prenom,
       a.nationalite,
       COUNT(dc.id_commande) AS "ventes"
FROM auteurs AS a
         INNER JOIN auteurs_livres AS al ON a.id_auteur = al.id_auteur
         INNER JOIN livres AS l ON al.id_livre = l.id_livre
         INNER JOIN details_commande AS dc ON l.id_livre = dc.id_livre
         INNER JOIN commandes AS c ON dc.id_commande = c.id_commande
WHERE c.statut != 'annulee'
GROUP BY a.id_auteur
HAVING ventes > (SELECT AVG(ventes_auteur)
                 FROM (SELECT COUNT(dc2.id_commande) AS "ventes_auteur"
                       FROM auteurs AS a2
                                INNER JOIN auteurs_livres AS al2 ON a2.id_auteur = al2.id_auteur
                                INNER JOIN livres AS l2 ON al2.id_livre = l2.id_livre
                                INNER JOIN details_commande AS dc2 ON l2.id_livre = dc2.id_livre
                                INNER JOIN commandes AS c2 ON dc2.id_commande = c2.id_commande
                       WHERE a2.nationalite = a.nationalite
                         AND c2.statut != 'annulee'
                       GROUP BY a2.id_auteur) AS moyennes)
ORDER BY a.nom, a.prenom;

-- 13.	Afficher les livres, ainsi que les informations sur leurs ventes
SELECT e.nom                                                              AS "editeur",
       l.titre,
       GROUP_CONCAT(DISTINCT CONCAT(a.prenom, ' ', a.nom) SEPARATOR ', ') AS "auteurs",
       c.nom                                                              AS "categorie",
       COUNT(DISTINCT dc.id_commande)                                     AS "nombre_commandes",
       COALESCE(total.exemplaires_vendus, 0)                              AS "exemplaires_vendus",
       COALESCE(total.chiffre_affaires, 0)                                AS "chiffre_affaires"
FROM editeurs AS e
         LEFT OUTER JOIN livres AS l ON e.id_editeur = l.id_editeur
         LEFT OUTER JOIN auteurs_livres AS al ON l.id_livre = al.id_livre
         LEFT OUTER JOIN auteurs AS a ON al.id_auteur = a.id_auteur
         LEFT OUTER JOIN categories AS c ON l.id_categorie = c.id_categorie
         LEFT OUTER JOIN details_commande AS dc ON l.id_livre = dc.id_livre
         LEFT OUTER JOIN (SELECT id_livre,
                                 SUM(quantite)                 AS "exemplaires_vendus",
                                 SUM(quantite * prix_unitaire) AS "chiffre_affaires"
                          FROM details_commande
                          GROUP BY id_livre) AS total ON total.id_livre = l.id_livre
GROUP BY e.id_editeur, l.id_livre, c.id_categorie
ORDER BY chiffre_affaires DESC;

-- 14. Afficher les livres et leur éditeur, avec une jointure naturelle.
-- Qu’est-ce qui aurait pu poser un problème ?
SELECT titre, date_publication, nom AS "editeur"
FROM livres
         NATURAL JOIN editeurs
ORDER BY titre;
/* Problème : Si le champ titre est modifié en nom,
	la jointure naturelle ne fonctionnerait plus,
	car elle prend en compte tous les champs qui ont le même nom */
