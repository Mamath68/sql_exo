-- 1. Afficher le montant des commandes par année et selon leur statut, avec l'opérateur ensembliste UNION, en respectant l'affichage.
SELECT YEAR(date_commande) AS "Année",
       SUM(en_attente)     AS "En attente",
       SUM(expediee)       AS "Expediées",
       SUM(livree)         AS "Livrées",
       SUM(annulee)        AS "Annulées",
       SUM(sans_statut)    AS "Sans statut"
FROM (SELECT date_commande,
             montant_total AS "en_attente",
             0             AS "expediee",
             0             AS "livree",
             0             AS "annulee",
             0             AS "sans_statut"
      FROM `commandes`
      WHERE statut = 'en_attente'
      UNION
      SELECT date_commande,
             0             AS "en_attente",
             montant_total AS "expediee",
             0             AS "livree",
             0             AS "annulee",
             0             AS "sans_statut"
      FROM `commandes`
      WHERE statut = 'expediee'
      UNION
      SELECT date_commande,
             0             AS "en_attente",
             0             AS "expediee",
             montant_total AS "livree",
             0             AS "annulee",
             0             AS "sans_statut"
      FROM `commandes`
      WHERE statut = "livree"
      UNION
      SELECT date_commande,
             0             AS "en_attente",
             0             AS "expediee",
             0             AS "livree",
             montant_total AS "annulee",
             0             AS "sans_statut"
      FROM `commandes`
      WHERE statut = "annulee"
      UNION
      SELECT date_commande,
             0             AS "en_attente",
             0             AS "expediee",
             0             AS "livree",
             0             AS "annulee",
             montant_total AS "sans_statut"
      FROM `commandes`
      WHERE statut IS NULL) AS liste
WHERE date_commande IS NOT NULL
GROUP BY 1;

-- 2. Utilisation du fenêtrage
-- 2-a. Numéroter les livres par ordre de prix décroissant, avec le rang.
SELECT titre,
       prix,
       ROW_NUMBER() OVER (ORDER BY prix DESC) as rang
FROM livres;

-- 2-b. Comparer le prix de chaque livre avec le précédent (par date de publication)
SELECT titre,
       date_publication,
       prix,
       LAG(prix) OVER (ORDER BY date_publication)        as prix_precedent,
       prix - LAG(prix) OVER (ORDER BY date_publication) as difference
FROM livres
WHERE date_publication IS NOT NULL
  AND prix IS NOT NULL;

-- 2-c. Calculer le prix moyen cumulé par éditeur
SELECT l.titre,
       e.nom                                                                   as editeur,
       l.prix,

       ROUND(AVG(l.prix) OVER (PARTITION BY e.id_editeur ORDER BY l.titre), 2) as prix_moyen_cumul
FROM livres l
         INNER JOIN editeurs e ON l.id_editeur = e.id_editeur
WHERE prix IS NOT NULL;

-- 2-d. Afficher les livres par catégorie, en précisant le nombre de ventes (classé par nom de catégorie et par nombre de ventes décroissant), en mentionnant le livre le plus vendu et le moins vendu de la catégorie en question
SELECT l.titre,
       c.nom                                                                              as categorie,
       COUNT(dc.id_commande)                                                              as nb_ventes,
       FIRST_VALUE(l.titre)
                   OVER (PARTITION BY c.id_categorie ORDER BY COUNT(dc.id_commande) DESC) as plus_vendu_categorie,
       LAST_VALUE(l.titre) OVER (
           PARTITION BY c.id_categorie
           ORDER BY
               IF(COUNT(dc.id_commande) = 0, 10, COUNT(dc.id_commande)) DESC, l.titre
           )                                                                              as moins_vendu_categorie
FROM livres l
         INNER JOIN categories c ON l.id_categorie = c.id_categorie
         LEFT OUTER JOIN details_commande dc ON l.id_livre = dc.id_livre
GROUP BY l.id_livre, c.id_categorie
ORDER BY c.nom, nb_ventes DESC;

-- 3. Utilisation des CTE
-- 3-a. Lister les auteurs qui ont écrit à la fois des romans et des essais (en utilisant les noms de catégories)
WITH auteurs_romans AS (SELECT a.id_auteur, a.nom, a.prenom
                        FROM auteurs a
                                 INNER JOIN auteurs_livres al ON a.id_auteur = al.id_auteur
                                 INNER JOIN livres l ON al.id_livre = l.id_livre
                                 INNER JOIN categories cat ON l.id_categorie = cat.id_categorie
                        WHERE cat.nom = 'Roman'),
     auteurs_essais AS (SELECT a.id_auteur, a.nom, a.prenom
                        FROM auteurs a
                                 INNER JOIN auteurs_livres al ON a.id_auteur = al.id_auteur
                                 INNER JOIN livres l ON al.id_livre = l.id_livre
                                 INNER JOIN categories cat ON l.id_categorie = cat.id_categorie
                        WHERE cat.nom = 'Essai')
SELECT id_auteur, nom, prenom
FROM auteurs_romans
WHERE id_auteur IN (SELECT id_auteur FROM auteurs_essais);

-- 3-b. Identifier les clients qui n’ont commandé que des livres d'un seul auteur
WITH auteurs_par_client AS (SELECT c.id_client, COUNT(DISTINCT a.id_auteur) AS total_auteurs
                            FROM clients c
                                     INNER JOIN commandes co ON c.id_client = co.id_client
                                     INNER JOIN details_commande dc ON co.id_commande = dc.id_commande
                                     INNER JOIN livres l ON dc.id_livre = l.id_livre
                                     INNER JOIN auteurs_livres al ON l.id_livre = al.id_livre
                                     INNER JOIN auteurs a ON al.id_auteur = a.id_auteur
                            GROUP BY c.id_client)
SELECT c.id_client, c.nom, c.prenom
FROM clients c
         INNER JOIN auteurs_par_client ac ON c.id_client = ac.id_client
WHERE ac.total_auteurs = 1;

-- 3-c. Hiérarchie des prix par editeur


-- 3-d. Hiérarchie des prix par editeur
WITH categories_prix AS (SELECT id_livre,
                                titre,
                                prix,
                                CASE
                                    WHEN prix < (SELECT AVG(prix) - STDDEV(prix) FROM livres) THEN 'bas'
                                    WHEN prix > (SELECT AVG(prix) + STDDEV(prix) FROM livres) THEN 'élevé'
                                    ELSE 'moyen'
                                    END as gamme_prix
                         FROM livres),
     stats_editeurs AS (SELECT e.nom                 as editeur,
                               cp.gamme_prix,
                               COUNT(*)              as nombre_livres,
                               ROUND(AVG(l.prix), 2) as prix_moyen
                        FROM categories_prix cp
                                 INNER JOIN livres l ON cp.id_livre = l.id_livre
                                 INNER JOIN editeurs e ON l.id_editeur = e.id_editeur
                        GROUP BY e.id_editeur, cp.gamme_prix)
SELECT *
FROM stats_editeurs
ORDER BY editeur, gamme_prix;

-- 4. Analyse des tendances de commandes par client
WITH commandes_clients AS (SELECT c.id_client,
                                  c.nom,
                                  c.prenom,
                                  cmd.date_commande,
                                  cmd.montant_total,
                                  ROW_NUMBER() OVER (PARTITION BY c.id_client ORDER BY cmd.date_commande) as num_commande,
                                  SUM(cmd.montant_total)
                                      OVER (PARTITION BY c.id_client ORDER BY cmd.date_commande)          as cumul_achats
                           FROM clients c
                                    INNER JOIN commandes cmd ON c.id_client = cmd.id_client
                           WHERE date_commande IS NOT NULL
                             AND montant_total IS NOT NULL),
     stats_client AS (SELECT id_client,
                             AVG(montant_total) as panier_moyen
                      FROM commandes_clients
                      WHERE date_commande IS NOT NULL
                      GROUP BY id_client)
SELECT cc.nom,
       cc.prenom,
       cc.date_commande,
       cc.montant_total,
       cc.num_commande,
       cc.cumul_achats,
       s.panier_moyen
FROM commandes_clients cc
         INNER JOIN stats_client s ON cc.id_client = s.id_client
ORDER BY cc.id_client, cc.date_commande;
