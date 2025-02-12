-- 1. Afficher le montant des commandes par année et selon leur statut, avec l'opérateur ensembliste UNION, en respectant l'affichage
SELECT YEAR(liste.date_commande) AS "Année",
       SUM(montant_en_attente)   AS "En_attente",
       SUM(montant_expediees)    AS "Expédiées",
       SUM(montant_livrees)      AS "Livrées",
       SUM(montant_annulees)     AS "Annulées",
       SUM(montant_sans_statut)  AS "Sans_statut"
FROM (select *
      from (SELECT date_commande,
                   c.montant_total AS "montant_en_attente",
                   0               AS "montant_expediees",
                   0               AS "montant_livrees",
                   0               AS "montant_annulees",
                   0               AS "montant_sans_statut"
            FROM commandes c
            WHERE c.statut = 'en_attente') c2

      UNION

      SELECT c.date_commande,
             0               AS "montant_en_attente",
             c.montant_total AS "montant_expediees",
             0               AS "montant_livrees",
             0               AS "montant_annulees",
             0               AS "montant_sans_statut"
      FROM commandes c
      WHERE c.statut = 'expediee'

      UNION

      SELECT c.date_commande,
             0               AS "montant_en_attente",
             0               AS "montant_expediees",
             c.montant_total AS "montant_livrees",
             0               AS "montant_annulees",
             0               AS "montant_sans_statut"
      FROM commandes c
      WHERE c.statut = 'livree'

      UNION

      SELECT c.date_commande,
             0               AS "montant_en_attente",
             0               AS "montant_expediees",
             0               AS "montant_livrees",
             c.montant_total AS "montant_annulees",
             0               AS "montant_sans_statut"
      FROM commandes c
      WHERE c.statut = 'annulee'

      UNION

      SELECT c.date_commande,
             0               AS "montant_en_attente",
             0               AS "montant_expediees",
             0               AS "montant_livrees",
             0               AS "montant_annulees",
             c.montant_total AS "montant_sans_statut"
      FROM commandes c
      WHERE c.statut IS NULL) AS liste
WHERE YEAR(date_commande) IS NOT NULL
GROUP BY 1;

-- 2. Utilisation du fenêtrage
-- 2-a. Numéroter les livres par ordre de prix décroissant, avec le rang
SELECT titre,
       prix,
       ROW_NUMBER() OVER (ORDER BY prix DESC) AS "rang"
FROM livres;

-- 2-b. Comparer le prix de chaque livre avec le précédent (par date de publication)
SELECT t.titre,
       t.date_publication,
       t.prix,
       LAG(t.prix) OVER (
           ORDER BY
               t.date_publication
           ) AS "prix_precedent",
       t.prix - LAG(t.prix) OVER (
           ORDER BY
               t.date_publication
           ) AS "difference"
FROM livres t
WHERE t.date_publication IS NOT NULL
  AND t.prix IS NOT NULL
ORDER BY t.date_publication;

-- 2-c. Calculer le prix moyen cumulé par éditeur
SELECT t.titre,
       e.nom     AS editeur,
       t.prix,
       ROUND(AVG(t.prix) OVER (
           PARTITION BY e.nom
           ORDER BY
               t.titre
           ), 2) AS prix_moyen_cumule
FROM livres t
         INNER JOIN editeurs e ON
    t.id_editeur = e.id_editeur
WHERE t.date_publication IS NOT NULL
  AND t.prix IS NOT NULL;

-- 2-d. Afficher les livres par catégorie, en précisant le nombre de ventes (classé par nom de catégorie et par nombre de ventes décroissant), en mentionnant le livre le plus vendu et le moins vendu de la catégorie en question
SELECT l.titre,
       c.nom                 AS 'Catégorie',
       COUNT(dc.id_commande) AS "nb_commande"
FROM livres l
         LEFT OUTER JOIN categories c ON
    c.id_categorie = l.id_categorie
         LEFT OUTER JOIN details_commande dc ON
    l.id_livre = dc.id_livre
WHERE l.date_publication IS NOT NULL
GROUP BY c.id_categorie,
         l.titre
ORDER BY 2,
         3 DESC;

-- 3. Utilisation des CTE
-- 3-a. Lister les auteurs qui ont écrit à la fois des romans et des essais (en utilisant les noms de catégories)
WITH auteurs_romans AS (SELECT a.id_auteur,
                               CONCAT(a.prenom, ' ', a.nom) AS auteur
                        FROM auteurs a
                                 INNER JOIN auteurs_livres al ON
                            a.id_auteur = al.id_auteur
                                 INNER JOIN livres l ON
                            al.id_livre = l.id_livre
                                 INNER JOIN categories c ON
                            c.id_categorie = l.id_categorie
                        WHERE c.nom = 'Roman'),
     auteurs_essais AS (SELECT a.id_auteur,
                               CONCAT(a.prenom, ' ', a.nom) AS auteur
                        FROM auteurs a
                                 INNER JOIN auteurs_livres al ON
                            a.id_auteur = al.id_auteur
                                 INNER JOIN livres l ON
                            al.id_livre = l.id_livre
                                 INNER JOIN categories c ON
                            c.id_categorie = l.id_categorie
                        WHERE c.nom = 'Essai')
SELECT ar.id_auteur,
       ar.auteur
FROM auteurs_romans ar
         INNER JOIN auteurs_essais ae ON
    ar.id_auteur = ae.id_auteur
ORDER BY ar.auteur;

-- 3-b. Identifier les clients qui n’ont commandé que des livres d'un seul auteur
WITH commandes_par_auteur AS (SELECT c.id_client,
                                     a.id_auteur,
                                     CONCAT(a.prenom, ' ', a.nom) AS auteur
                              FROM clients c
                                       INNER JOIN commandes cmd ON c.id_client = cmd.id_client
                                       INNER JOIN details_commande dc ON cmd.id_commande = dc.id_commande
                                       INNER JOIN livres l ON dc.id_livre = l.id_livre
                                       INNER JOIN auteurs_livres al ON l.id_livre = al.id_livre
                                       INNER JOIN auteurs a ON al.id_auteur = a.id_auteur),
     auteurs_par_client AS (SELECT id_client,
                                   COUNT(DISTINCT id_auteur) AS nb_auteurs
                            FROM commandes_par_auteur
                            GROUP BY id_client)
SELECT c.id_client,
       CONCAT(c.prenom, ' ', c.nom) AS auteur
FROM clients c
         INNER JOIN auteurs_par_client apc ON c.id_client = apc.id_client
WHERE apc.nb_auteurs = 1;

-- 3-c.
