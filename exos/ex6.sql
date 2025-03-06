-- 1. Créer une procédure 'livres_epuises' qui affiche la liste des livres dont le stock est à 0, avec leur titre et leur catégorie.
DELIMITER |
CREATE PROCEDURE livre_epuises()
BEGIN
    SELECT l.titre, c.nom
    FROM livres l
             INNER JOIN categories c ON l.id_categorie = c.id_categorie
    WHERE l.stock = 0
    order by c.nom;
END |
DELIMITER ;

-- 2. Créer une procédure 'livres_par_categorie' qui prend en paramètre un ID de catégorie et affiche tous les livres de cette catégorie avec leur prix et stock.
DELIMITER |
CREATE PROCEDURE livres_par_categorie(IN id_categ INT)
BEGIN
    SELECT l.titre, l.prix, l.stock
    FROM livres l
    WHERE l.id_categorie = id_categ
    ORDER BY l.titre;
END |
DELIMITER ;

-- 3. Créer une procédure 'stats_editeur' qui prend en paramètre l'ID d'un éditeur et renvoie dans des paramètres OUT :
-- • le nombre total de livres
-- • le prix moyen des livres
-- • la valeur totale du stock (prix * quantité en stock)
DELIMITER |
CREATE PROCEDURE stats_editeur(
    IN id_edit INT,
    OUT nb_livres int,
    OUT prix_moyen decimal(7, 2),
    OUT valeur_stock decimal(7, 2)
)
BEGIN
    SELECT count(*), ROUND(AVG(l.prix), 2), SUM(l.prix * l.stock)
    INTO nb_livres, prix_moyen, valeur_stock
    FROM livres l
    WHERE l.id_editeur = id_edit;
END |
DELIMITER ;

-- 4. Créer une procédure 'verifier_stock' qui prend en paramètre un ID de livre et un seuil, et affiche un message différent selon si le stock est :
-- • critique (< seuil)
-- • normal (entre seuil et seuil*3)
-- • élevé (> seuil*3)
DELIMITER |
CREATE PROCEDURE verifier_stock(IN p_livre_id INT, IN p_seuil INT)
BEGIN
    DECLARE v_stock INT;

    SELECT stock
    INTO v_stock
    FROM livres
    WHERE id_livre = p_livre_id;

    IF v_stock < p_seuil THEN
        SELECT CONCAT('Stock critique pour le livre: ', titre, ' (', v_stock, ' exemplaires)') as message
        FROM livres
        WHERE id_livre = p_livre_id;
    ELSEIF v_stock <= p_seuil * 3 THEN
        SELECT CONCAT('Stock normal pour le livre: ', titre, ' (', v_stock, ' exemplaires)') as message
        FROM livres
        WHERE id_livre = p_livre_id;
    ELSE
        SELECT CONCAT('Stock élevé pour le livre: ', titre, ' (', v_stock, ' exemplaires)') as message
        FROM livres
        WHERE id_livre = p_livre_id;
    END IF;
END |
DELIMITER ;

/* Version case dans le concat du select */
DELIMITER |
CREATE PROCEDURE verifier_stock(IN p_livre_id INT, IN p_seuil INT)
BEGIN
    DECLARE v_stock INT;

    SELECT stock
    INTO v_stock
    FROM livres
    WHERE id_livre = p_livre_id;

    SELECT CONCAT('Stock ',
                  CASE
                      WHEN v_stock < p_seuil THEN 'critique'
                      WHEN v_stock <= p_seuil * 3 THEN 'normal'
                      ELSE 'élevé'
                      END,
                  ' pour le livre: ', titre, ' (', v_stock, ' exemplaires)') as message
    FROM livres
    WHERE id_livre = p_livre_id;
END |
DELIMITER ;

-- 5. Créer une procédure 'classer_prix' qui analyse le prix d'un livre (passé en paramètre) et retourne dans un paramètre OUT la catégorie de prix :
-- • 'Économique' si < 10 €
-- • 'Standard' si entre 10 € et 20 €
-- • 'Premium' si > 20 €
DELIMITER |
CREATE PROCEDURE classer_prix(IN p_livre_id INT, OUT p_categorie VARCHAR(20))
BEGIN
    DECLARE v_prix DECIMAL(10, 2);

    SELECT prix
    INTO v_prix
    FROM livres
    WHERE id_livre = p_livre_id;

    CASE
        WHEN v_prix < 10 THEN SET p_categorie = 'Économique';
        WHEN v_prix <= 20 THEN SET p_categorie = 'Standard';
        ELSE SET p_categorie = 'Premium';
        END CASE;
END |
DELIMITER ;

-- 6. Créer une procédure 'augmenter_prix' qui augmente le prix de tous les livres d'un éditeur (ID en paramètre) selon les règles suivantes :
-- • +5 % si prix actuel < 10 €
-- • +3 % si prix entre 10 € et 20 €
-- • +2 % si prix > 20 €
-- • Utiliser un curseur pour parcourir les livres
DELIMITER |
CREATE PROCEDURE augmenter_prix(IN p_editeur_id INT)
BEGIN
    DECLARE v_finished INT DEFAULT 0;
    DECLARE v_livre_id INT;
    DECLARE v_prix DECIMAL(10, 2);

    -- Déclaration du curseur
    DECLARE cur_livres CURSOR FOR
        SELECT id_livre, prix
        FROM livres
        WHERE id_editeur = p_editeur_id;

    -- Handler pour la fin du curseur
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

    OPEN cur_livres;

    update_loop:
    LOOP
        FETCH cur_livres INTO v_livre_id, v_prix;

        IF v_finished = 1 THEN
            LEAVE update_loop;
        END IF;

        -- Mise à jour selon les règles
        IF v_prix < 10 THEN
            UPDATE livres
            SET prix = ROUND(prix * 1.05, 2)
            WHERE id_livre = v_livre_id;
        ELSEIF v_prix <= 20 THEN
            UPDATE livres
            SET prix = ROUND(prix * 1.03, 2)
            WHERE id_livre = v_livre_id;
        ELSE
            UPDATE livres
            SET prix = ROUND(prix * 1.02, 2)
            WHERE id_livre = v_livre_id;
        END IF;

    END LOOP update_loop;

    CLOSE cur_livres;

END |
DELIMITER ;
