-- 1. Lister tous les livres dont le prix est supérieur à 10 €
SELECT titre, prix
FROM livres
WHERE prix > 10
ORDER BY prix DESC;

-- 2. Trouver tous les auteurs français nés après 1900
SELECT nom, prenom, date_naissance
FROM auteurs
WHERE nationalite = 'Française'
  AND YEAR(date_naissance) >= 1900;

-- 3. Lister les éditeurs parisiens par ordre alphabétique
SELECT nom, date_creation
FROM editeurs
WHERE ville = 'Paris'
ORDER BY nom;

-- 4. Lister tous les livres publiés après 2000 avec leur prix
SELECT titre, prix, date_publication
FROM livres
WHERE YEAR(date_publication) > 2000
ORDER BY date_publication;

-- 5. Trouver tous les clients qui ont plus de 100 points de fidélité
SELECT nom, prenom, fidelite_points
FROM clients
WHERE fidelite_points > 100
ORDER BY fidelite_points DESC;

-- 6. Afficher les livres dont le prix est entre 10 € et 20 €
SELECT titre, prix
FROM livres
WHERE prix BETWEEN 10 AND 20
ORDER BY prix;

-- 7. Calculer le prix moyen des livres
SELECT YEAR(date_publication) AS "année",
       ROUND(AVG(prix), 2)    AS "prix_moyen",
       COUNT(id_livre)        AS "nombre_livres"
FROM livres
GROUP BY 1
ORDER BY prix_moyen DESC;

-- 8. Compter le nombre de commandes par statut
SELECT statut,
       COUNT(*)                     AS "nombre_commandes",
       ROUND(SUM(montant_total), 2) AS "montant_total"
FROM commandes
WHERE statut IS NOT NULL
GROUP BY statut
ORDER BY 2 DESC;

-- 9. Trouver le client ayant le plus de points de fidélité
SELECT nom, prenom, fidelite_points
FROM clients
WHERE fidelite_points = (SELECT MAX(fidelite_points)
                         FROM clients);

-- 10. Calculer le chiffre d'affaires total par mois
SELECT DATE_FORMAT(date_commande, '%Y-%m') AS "mois",
       COUNT(*)                            AS "nombre_commandes",
       ROUND(SUM(montant_total), 2)        AS "chiffre_affaires",
       ROUND(AVG(montant_total), 2)        AS "panier_moyen"
FROM commandes
WHERE statut != 'annulee'
  AND date_commande IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- 11. Calculer le taux de conversion des commandes (commandes/clients)
SELECT nombre_clients,
       commandes_validees,
       CONCAT(ROUND(commandes_validees / nombre_clients * 100, 2), '%') AS "taux_conversion"
FROM (SELECT COUNT(DISTINCT id_client)  AS "nombre_clients",
             (SELECT COUNT(id_client)
              FROM commandes
              WHERE statut <> 'annulee'
                AND statut IS NOT NULL) AS "commandes_validees"
      FROM commandes) AS t1;

SELECT COUNT(DISTINCT id_client)                                            AS "nombre_clients",
       (SELECT COUNT(id_commande) FROM commandes WHERE statut != 'annulee') AS "commandes_validees",
       CONCAT(ROUND((SELECT COUNT(id_commande) FROM commandes WHERE statut != 'annulee') / COUNT(DISTINCT id_client),
                    2) * 100, '%')                                          AS "taux_conversion"
FROM commandes;

-- 12. Analyser les ventes par jour de la semaine
SELECT DAYNAME(c.date_commande)     AS "jour",
       COUNT(*)                     AS "nombre_commandes",
       ROUND(AVG(montant_total), 2) AS "panier_moyen",
       ROUND(SUM(montant_total), 2) AS "total_ventes"
FROM commandes c
WHERE statut != 'annulee'
  AND c.date_commande IS NOT NULL
GROUP BY jour;

-- 13. Analyser la distribution des points de fidélité
SELECT CASE
           WHEN fidelite_points IS NULL THEN 'NON DEFINI'
           WHEN fidelite_points < 50 THEN '0-49'
           WHEN fidelite_points < 100 THEN '50-99'
           WHEN fidelite_points < 200 THEN '100-199'
           ELSE '200+'
           END                    AS "tranche_points",
       COUNT(id_client)           AS "nombre_clients",
       CEIL(AVG(fidelite_points)) AS "moyenne_points",
       MIN(fidelite_points)       AS "min_points",
       MAX(fidelite_points)       AS "max_points"
FROM clients
GROUP BY 1
ORDER BY 4;

SELECT CASE
           WHEN fidelite_points IS NULL THEN 'NON DEFINI'
           WHEN fidelite_points BETWEEN 50 AND 99 THEN '50-99'
           WHEN fidelite_points BETWEEN 100 AND 199 THEN '100-199'
           ELSE '200+'
           END                    AS "tranche_points",
       COUNT(id_client)           AS "nombre_clients",
       CEIL(AVG(fidelite_points)) AS "moyenne_points",
       MIN(fidelite_points)       AS "min_points",
       MAX(fidelite_points)       AS "max_points"
FROM clients
GROUP BY tranche_points
ORDER BY 4;

SELECT CASE
           WHEN fidelite_points >= 50 AND fidelite_points < 100 THEN '50-99'
           WHEN fidelite_points >= 100 AND fidelite_points < 200 THEN '100-199'
           WHEN fidelite_points >= 200 THEN '200+'
           END                    AS tranche_points,
       COUNT(*)                   AS nombre_clients,
       CEIL(AVG(fidelite_points)) AS moyenne_points,
       MIN(fidelite_points)       AS min_points,
       MAX(fidelite_points)       AS max_points
FROM clients
WHERE fidelite_points >= 50
GROUP BY tranche_points
ORDER BY min_points;


-- Index FullText
-- 14. Recherche dans titre, résumé, thèmes, critiques, mots_clés
-- Ajout de l'index FULLTEXT
ALTER TABLE livres
    ADD FULLTEXT INDEX idx_fulltext_livre (titre, resume, themes, critiques, mots_cles);

-- 1. Trouver tous les livres qui parlent de "justice" en recherche naturelle
SELECT titre, resume
FROM livres
WHERE MATCH(titre, resume, themes, critiques, mots_cles)
            AGAINST('justice' IN NATURAL LANGUAGE MODE);

-- 2. Trouver les livres qui contiennent "meurtre" mais pas "procès"
SELECT titre, resume
FROM livres
WHERE MATCH(titre, resume, themes, critiques, mots_cles)
            AGAINST('+meurtre -procès' IN BOOLEAN MODE);

-- 3. Trouver les livres contenant l'expression exacte "justice sociale"
SELECT titre, resume
FROM livres
WHERE MATCH(titre, resume, themes, critiques, mots_cles)
            AGAINST('"justice sociale"' IN BOOLEAN MODE);

-- 4.Trouver les livres parlant de (femme OU cavalier) ET (guerre OU philosophie)
SELECT titre, resume
FROM livres
WHERE MATCH(titre, resume, themes, critiques, mots_cles)
            AGAINST('+(femme cavalier) +(guerre philosophie)' IN BOOLEAN MODE);

-- 5. Classer les livres par pertinence pour les termes "société" et "morale"
SELECT titre,
       MATCH(titre, resume, themes, critiques, mots_cles)
             AGAINST('société morale' IN NATURAL LANGUAGE MODE) as pertinence
FROM livres
WHERE MATCH(titre, resume, themes, critiques, mots_cles)
            AGAINST('société morale' IN NATURAL LANGUAGE MODE)
ORDER BY pertinence DESC;

-- Si pas de recherche par index dans le where
SELECT titre,
       MATCH(titre, resume, themes, critiques, mots_cles)
             AGAINST('société morale' IN NATURAL LANGUAGE MODE) AS "pertinence"
FROM livres
HAVING pertinence > 0;
