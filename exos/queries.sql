-- Lister tous les livres dont le prix est supérieur à 10 €
SELECT l.titre, l.prix
FROM livres l
WHERE l.prix > 10
ORDER BY l.prix DESC;

-- 2. Trouver tous les auteurs français nés après 1900
SELECT a.prenom, a.nom, a.date_naissance
FROM auteurs a
WHERE a.nationalite = 'Française'
  AND YEAR(a.date_naissance) >= 1900
ORDER BY a.date_naissance;

-- 3. Lister les éditeurs parisiens par ordre alphabétique
SELECT e.nom, e.date_creation
FROM editeurs e
WHERE e.ville = 'Paris'
ORDER BY e.nom;

-- 4. Lister tous les livres publiés après 2000 avec leur prix
SELECT l.titre, l.prix, l.date_publication
FROM livres l
WHERE YEAR(l.date_publication) > 2000
ORDER BY l.date_publication;

-- 5. Trouver tous les clients qui ont plus de 100 points de fidélité
SELECT c.prenom, c.nom, c.fidelite_points
FROM clients c
WHERE c.fidelite_points > 100
ORDER BY c.fidelite_points DESC;

-- 6. Afficher les livres dont le prix est entre 10 € et 20 €
SELECT l.titre, l.prix
FROM livres l
WHERE l.prix BETWEEN 10 AND 20
ORDER BY l.prix;

-- 7. Calculer le prix moyen des livres
SELECT YEAR(l.date_publication) AS 'Année',
       ROUND(AVG(l.prix), 2)    AS 'Prix moyen',
       COUNT(l.id_livre)        AS 'Nombre de livres'
FROM livres l
GROUP BY 1
ORDER BY `prix moyen` DESC;

-- 8. Compter le nombre de commandes par statut
SELECT c.statut,
       COUNT(*)                       AS 'nombre de commandes',
       ROUND(SUM(c.montant_total), 2) AS 'montant total'
FROM commandes c
WHERE c.statut IS NOT NULL
GROUP BY c.statut
ORDER BY 2 DESC;

-- 9. Trouver le client ayant le plus de points de fidélité
SELECT c.prenom, c.nom, c.fidelite_points
FROM clients c
WHERE fidelite_points = (SELECT MAX(c.fidelite_points)
                         FROM clients c);

-- 10. Calculer le chiffre d'affaires total par mois
SELECT DATE_FORMAT(c.date_commande, '%Y-%m') AS mois,
       COUNT(*)                              AS nombre_commandes,
       ROUND(SUM(c.montant_total), 2)        AS chiffre_affaires_total,
       ROUND(AVG(c.montant_total), 2)        AS panier_moyen
FROM commandes c
WHERE c.date_commande is not null
  and c.statut != 'annulee'
GROUP BY 1
ORDER BY 1;

-- 11. Calculer le taux de conversion des commandes (commandes/clients)
SELECT COUNT(DISTINCT c.id_client)                                                AS "nombre_clients",
       (SELECT COUNT(c.id_commande) FROM commandes c WHERE c.statut != 'annulee') AS "commandes_validees",
       CONCAT(ROUND((SELECT COUNT(id_commande) FROM commandes WHERE statut != 'annulee') / COUNT(DISTINCT c.id_client),
                    2) * 100, '%')                                                AS "taux_conversion"
FROM commandes c;

-- 12. Analyser les ventes par jour de la semaine
SELECT DAYNAME(c.date_commande)       AS jour_semaine,
       COUNT(*)                       AS nombre_commandes,
       ROUND(AVG(c.montant_total), 2) AS panier_moyen,
       SUM(c.montant_total)           AS total_ventes
FROM commandes c
WHERE c.date_commande IS NOT NULL
  AND c.statut != 'annulee'
GROUP BY jour_semaine;

-- 13. Afficher la distribution des points de fidélité
SELECT CASE
           WHEN c.fidelite_points < 49 THEN '0-49'
           WHEN c.fidelite_points < 100 THEN '50-99'
           WHEN c.fidelite_points < 200 THEN '100-199'
           ELSE '200+'
           END                       AS tranche_points,
       COUNT(*)                      AS nombre_clients,
       ROUND(AVG(c.fidelite_points)) AS points_moyens,
       ROUND(MIN(c.fidelite_points)) AS points_min,
       ROUND(MAX(c.fidelite_points)) AS points_max
FROM clients c
where c.fidelite_points IS NOT NULL
GROUP BY 1
ORDER BY 4;

-- 14. Recherche dans titre, résumé, thèmes, critiques, mots_clés

-- 14.1 Trouver tous les livres qui parlent de "justice" en recherche naturelle
SELECT l.titre, l.resume
FROM livres l
WHERE MATCH(l.titre, l.resume, l.themes, l.critiques, l.mots_cles)
            AGAINST('justice' IN NATURAL LANGUAGE MODE);

-- 14.2 Trouver les livres qui contiennent "meurtre" mais pas "procès"
SELECT l.titre, l.resume
FROM livres l
WHERE MATCH(l.titre, l.resume, l.themes, l.critiques, l.mots_cles)
            AGAINST('meurtre' IN NATURAL LANGUAGE MODE)
  AND l.resume NOT LIKE '%procès%';

-- 14.3 Trouver les livres contenant l'expression exacte "justice sociale"
SELECT l.titre, l.resume
FROM livres l
WHERE MATCH(l.titre, l.resume, l.themes, l.critiques, l.mots_cles)
            AGAINST('"justice sociale"' IN NATURAL LANGUAGE MODE);

-- 14.4 Trouver les livres parlant de (femme OU cavalier) ET (guerre OU philosophie)
SELECT l.titre, l.resume
FROM livres l
WHERE (MATCH(l.titre, l.resume, l.themes, l.critiques, l.mots_cles) AGAINST('femme' IN NATURAL LANGUAGE MODE) OR
       MATCH(titre, RESUME, themes, critiques, mots_cles) AGAINST('cavalier' IN NATURAL LANGUAGE MODE))
  AND (MATCH(titre, RESUME, themes, critiques, mots_cles) AGAINST('guerre' IN NATURAL LANGUAGE MODE) OR
       MATCH(titre, RESUME, themes, critiques, mots_cles) AGAINST('philosophie' IN NATURAL LANGUAGE MODE));

-- 15.5 Classer les livres par pertinence pour les termes "société" et "morale"
SELECT l.titre,
       l.resume,
       MATCH(l.titre, l.resume, l.themes, l.critiques, l.mots_cles)
             AGAINST('société morale' IN NATURAL LANGUAGE MODE) AS pertinence
FROM livres l
HAVING pertinence > 0
ORDER BY pertinence DESC;
