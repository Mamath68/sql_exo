-- 1. Lister les livres avec leurs auteurs et éditeurs, classé par titre et auteur
SELECT l.titre, CONCAT(a.prenom, ' ', a.nom) as "auteur", e.nom as "editeur"
FROM livres l
         INNER JOIN editeurs e
                    ON l.id_editeur = e.id_editeur
         INNER JOIN auteurs_livres al
                    ON al.id_livre = l.id_livre
         INNER JOIN auteurs a
                    ON al.id_auteur = a.id_auteur
ORDER BY 1, 2;

-- 2. Trouver toutes les catégories, même celles sans livres, classé par nombre de livres décroissant puis par catégorie
SELECT c.nom as "categorie", COUNT(l.id_livre) as "nombre_de_livres"
FROM categories c
         LEFT OUTER JOIN livres l
                         ON l.id_categorie = c.id_categorie
GROUP BY 1
ORDER BY 2 DESC, 1;

-- 3. Lister tous les livres avec leur auteur principal et leur éditeur, classé par titre
SELECT l.titre, CONCAT(a.prenom, ' ', a.nom) as "auteur", e.nom as "editeur"
FROM livres l
         INNER JOIN editeurs e
                    ON e.id_editeur = l.id_editeur
         INNER JOIN auteurs_livres al
                    ON al.id_livre = l.id_livre
         INNER JOIN auteurs a
                    ON a.id_auteur = al.id_auteur
WHERE al.role = 'principal'
ORDER BY 1;

-- 4. Croiser les ventes des auteurs par année, classé par année et auteur
SELECT a.nom, YEAR(c.date_commande), SUM(dc.quantite)
FROM auteurs a
         INNER JOIN auteurs_livres al
                    ON a.id_auteur = al.id_auteur
         INNER JOIN livres l
                    ON al.id_livre = l.id_livre
         INNER JOIN details_commande dc
                    ON dc.id_livre = l.id_livre
         INNER JOIN commandes c
                    ON c.id_commande = dc.id_commande
WHERE YEAR(c.date_commande) IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2;

-- 5. Afficher les auteurs qui ont écrit dans plusieurs catégories
SELECT CONCAT(a.prenom, ' ', a.nom)                               as "auteur",
       COUNT(DISTINCT l.id_categorie)                             as "nombre_de_categories",
       GROUP_CONCAT(DISTINCT c.nom ORDER BY c.nom SEPARATOR ', ') as "categories"
FROM auteurs a
         INNER JOIN auteurs_livres al ON a.id_auteur = al.id_auteur
         INNER JOIN livres l ON al.id_livre = l.id_livre
         INNER JOIN categories c ON c.id_categorie = l.id_categorie
GROUP BY a.prenom, a.nom
HAVING COUNT(DISTINCT l.id_categorie) > 1
ORDER BY 2 DESC, 1;

-- 6. Pour chaque livre, montrer le nombre de fois qu’il a été commandé, classé par nombres d'exemplaires décroissants puis par titre.
SELECT l.titre,
       COUNT(dc.id_commande) AS nombre_de_commandes,
       SUM(dc.quantite)      AS total_quantite
FROM livres l
         LEFT OUTER JOIN details_commande dc
                         ON l.id_livre = dc.id_livre
GROUP BY l.titre
ORDER BY total_quantite DESC, l.titre;

-- 7. Calculer la répartition des ventes par catégorie
SELECT c.nom                               AS "categorie",
       COUNT(dc.id_commande)               AS "nombre_commandes",
       SUM(dc.quantite)                    AS "quantite_vendue",
       SUM(dc.prix_unitaire * dc.quantite) AS "chiffre_affaires",
       (
           ROUND(SUM(dc.quantite) * 100.0 / (SELECT SUM(dc.quantite)
                                             FROM details_commande dc), 2)
           )                               AS pourcentage
FROM categories c
         INNER JOIN livres l ON
    c.id_categorie = l.id_categorie
         INNER JOIN details_commande dc ON
    l.id_livre = dc.id_livre
GROUP BY c.nom
ORDER BY chiffre_affaires
        DESC
        ,
         c.nom;

-- 8. Trouver les paires d'auteurs qui ont collaboré sur au moins un livre
SELECT CONCAT(a1.prenom, ' ', a1.nom) as "auteur1",
       CONCAT(a2.prenom, ' ', a2.nom) as "auteur2",
       COUNT(DISTINCT l.id_livre)     as "nombre_de_collaborations"
FROM auteurs a1
         INNER JOIN auteurs_livres al1 ON a1.id_auteur = al1.id_auteur
         INNER JOIN auteurs a2 ON a1.id_auteur < a2.id_auteur
         INNER JOIN auteurs_livres al2 ON a2.id_auteur = al2.id_auteur
         INNER JOIN livres l ON al1.id_livre = l.id_livre AND al2.id_livre = l.id_livre
GROUP BY a1.id_auteur, a2.id_auteur
HAVING COUNT(DISTINCT l.id_livre) > 0
ORDER BY 3 DESC, 1, 2;

-- 9. Afficher les auteurs n’ayant pas eu de ventes le mois courant de l'année précédente
SELECT a.prenom, a.nom
FROM auteurs a
WHERE a.id_auteur NOT IN (SELECT al.id_auteur
                          FROM auteurs_livres al
                                   INNER JOIN livres l ON al.id_livre = l.id_livre
                                   INNER JOIN details_commande dc ON l.id_livre = dc.id_livre
                                   INNER JOIN commandes c ON dc.id_commande = c.id_commande
                          WHERE YEAR(c.date_commande) = YEAR(CURRENT_DATE) - 1
                            AND MONTH(c.date_commande) = MONTH(CURRENT_DATE))
ORDER BY 2;

-- 10. Trouver les livres plus chers que la moyenne de leur catégorie, classé par nom de catégorie puis par prix décroissant
SELECT l.titre, l.prix, c.nom as "categorie"
FROM livres l
         INNER JOIN categories c
                    ON l.id_categorie = c.id_categorie
WHERE l.prix > (SELECT AVG(l.prix)
                FROM livres l
                WHERE l.id_categorie = l.id_categorie)
ORDER BY 3, 2 DESC;

-- 11. Lister les clients qui ont acheté plus que la moyenne des commandes, classé par nom et prénom
SELECT c.prenom, c.nom, COUNT(DISTINCT dc.id_commande) as "nombre_de_commandes"
FROM clients c
         INNER JOIN commandes co
                    ON c.id_client = co.id_client
         INNER JOIN details_commande dc
                    ON co.id_commande = dc.id_commande
GROUP BY c.id_client
HAVING COUNT(DISTINCT dc.id_commande) > (SELECT AVG(nb_commandes)
                                         FROM (SELECT COUNT(DISTINCT dc.id_commande) as "nb_commandes"
                                               FROM clients c
                                                        INNER JOIN commandes co
                                                                   ON c.id_client = co.id_client
                                                        INNER JOIN details_commande dc
                                                                   ON co.id_commande = dc.id_commande
                                               GROUP BY c.id_client) as sub)
ORDER BY 1, 2;
