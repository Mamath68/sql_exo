--
-- Base de données : `librairie`
--
-- --------------------------------------------------------
--
-- Structure de la table `auteurs`
--
DROP TABLE IF EXISTS `auteurs`;

CREATE TABLE
  IF NOT EXISTS `auteurs` (
    `id_auteur` int NOT NULL AUTO_INCREMENT,
    `nom` varchar(50) NOT NULL,
    `prenom` varchar(50) DEFAULT NULL,
    `date_naissance` date DEFAULT NULL,
    `nationalite` varchar(50) DEFAULT NULL,
    `total_ventes` int DEFAULT '0',
    PRIMARY KEY (`id_auteur`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 16;

--
-- Déchargement des données de la table `auteurs`
--
INSERT INTO
  `auteurs` (
    `id_auteur`,
    `nom`,
    `prenom`,
    `date_naissance`,
    `nationalite`,
    `total_ventes`
  )
VALUES
  (
    1,
    'Camus',
    'Albert',
    '1913-11-07',
    'Française',
    150000
  ),
  (
    2,
    'de Beauvoir',
    'Simone',
    '1908-01-09',
    'Française',
    120000
  ),
  (
    3,
    'Hugo',
    'Victor',
    '1802-02-26',
    'Française',
    200000
  ),
  (
    4,
    'Sartre',
    'Jean-Paul',
    '1905-06-21',
    'Française',
    130000
  ),
  (
    5,
    'Duras',
    'Marguerite',
    '1914-04-04',
    'Française',
    90000
  ),
  (
    6,
    'Modiano',
    'Patrick',
    '1945-07-30',
    'Française',
    80000
  ),
  (
    7,
    'Nothomb',
    'Amélie',
    '1966-08-09',
    'Belge',
    95000
  ),
  (
    8,
    'Ernaux',
    'Annie',
    '1940-09-01',
    'Française',
    110000
  ),
  (
    9,
    'Houellebecq',
    'Michel',
    '1956-02-26',
    'Française',
    140000
  ),
  (
    10,
    'Despentes',
    'Virginie',
    '1969-06-13',
    'Française',
    85000
  ),
  (
    11,
    'Proust',
    'Marcel',
    '1871-07-10',
    'Française',
    NULL
  ),
  (
    12,
    'Woolf',
    'Virginia',
    NULL,
    'Britannique',
    75000
  ),
  (13, 'Kafka', 'Franz', '1883-07-03', NULL, NULL),
  (14, 'Yourcenar', NULL, NULL, 'Française', 80000),
  (
    15,
    'García Márquez',
    'Gabriel',
    '1927-03-06',
    'Colombienne',
    NULL
  );

-- --------------------------------------------------------
--
-- Structure de la table `auteurs_livres`
--
DROP TABLE IF EXISTS `auteurs_livres`;

CREATE TABLE
  IF NOT EXISTS `auteurs_livres` (
    `id_auteur` int NOT NULL,
    `id_livre` int NOT NULL,
    `role` enum ('principal', 'contributeur') DEFAULT NULL,
    PRIMARY KEY (`id_auteur`, `id_livre`),
    KEY `id_livre` (`id_livre`)
  ) ENGINE = InnoDB;

--
-- Déchargement des données de la table `auteurs_livres`
--
INSERT INTO
  `auteurs_livres` (`id_auteur`, `id_livre`, `role`)
VALUES
  (1, 1, 'principal'),
  (2, 2, 'principal'),
  (2, 8, 'contributeur'),
  (4, 4, 'principal'),
  (5, 5, 'principal'),
  (6, 6, 'principal'),
  (6, 8, NULL),
  (7, 7, 'principal'),
  (8, 8, 'principal'),
  (8, 37, NULL),
  (9, 9, 'principal'),
  (10, 10, 'principal'),
  (12, 43, NULL),
  (15, 8, 'contributeur');

-- --------------------------------------------------------
--
-- Structure de la table `categories`
--
DROP TABLE IF EXISTS `categories`;

CREATE TABLE
  IF NOT EXISTS `categories` (
    `id_categorie` int NOT NULL AUTO_INCREMENT,
    `nom` varchar(50) NOT NULL,
    `description` text,
    PRIMARY KEY (`id_categorie`)
  ) ENGINE = InnoDB;

--
-- Déchargement des données de la table `categories`
--
INSERT INTO
  `categories` (`id_categorie`, `nom`, `description`)
VALUES
  (1, 'Roman', 'Romans contemporains et classiques'),
  (2, 'Essai', 'Essais philosophiques et critiques'),
  (3, 'Poésie', 'Recueils de poésie'),
  (
    4,
    'Science-Fiction',
    'Romans de science-fiction et fantastiques'
  ),
  (
    5,
    'Jeunesse',
    'Littérature pour enfants et adolescents'
  ),
  (
    6,
    'Théâtre',
    'Pièces de théâtre classiques et contemporaines'
  ),
  (7, 'Policier', 'Romans policiers et thrillers'),
  (8, 'Philosophie', 'Ouvrages philosophiques'),
  (
    9,
    'Histoire',
    'Livres d\'histoire et biographies'
  ),
  (10, 'Arts', 'Beaux livres sur l\'art');

-- --------------------------------------------------------
--
-- Structure de la table `clients`
--
DROP TABLE IF EXISTS `clients`;

CREATE TABLE
  IF NOT EXISTS `clients` (
    `id_client` int NOT NULL AUTO_INCREMENT,
    `nom` varchar(50) NOT NULL,
    `prenom` varchar(50) DEFAULT NULL,
    `email` varchar(100) DEFAULT NULL,
    `date_inscription` date DEFAULT NULL,
    `fidelite_points` int DEFAULT '0',
    PRIMARY KEY (`id_client`),
    UNIQUE KEY `email` (`email`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 16;

--
-- Déchargement des données de la table `clients`
--
INSERT INTO
  `clients` (
    `id_client`,
    `nom`,
    `prenom`,
    `email`,
    `date_inscription`,
    `fidelite_points`
  )
VALUES
  (
    1,
    'Dubois',
    'Marie',
    'marie.dubois@email.com',
    '2020-01-15',
    150
  ),
  (
    2,
    'Martin',
    'Jean',
    'jean.martin@email.com',
    '2020-02-20',
    75
  ),
  (
    3,
    'Bernard',
    'Sophie',
    'sophie.bernard@email.com',
    '2020-03-10',
    200
  ),
  (
    4,
    'Petit',
    'Pierre',
    'pierre.petit@email.com',
    '2020-04-05',
    100
  ),
  (
    5,
    'Robert',
    'Julie',
    'julie.robert@email.com',
    '2020-05-01',
    180
  ),
  (
    6,
    'Dupont',
    'Paul',
    'paul.dupont@email.com',
    '2021-01-15',
    120
  ),
  (
    7,
    'Laurent',
    'Marie',
    'marie.laurent@ancien.com',
    '2021-02-20',
    85
  ),
  (
    8,
    'Mercier',
    'Jean',
    'jean.mercier@email.com',
    '2021-03-10',
    160
  ),
  (
    9,
    'Leroy',
    'Sophie',
    'sophie.leroy@ancien.com',
    '2021-04-05',
    90
  ),
  (
    10,
    'Garcia',
    'Lucas',
    'lucas.garcia@email.com',
    '2021-05-01',
    140
  ),
  (
    11,
    'Moreau',
    NULL,
    'moreau@email.com',
    '2024-01-15',
    NULL
  ),
  (12, 'Lefebvre', 'Anne', NULL, NULL, 50),
  (
    13,
    'Williams',
    'John',
    'jwilliams@email.com',
    '2024-01-15',
    NULL
  ),
  (14, 'Martinez', 'Carmen', NULL, '2024-01-15', 75),
  (
    15,
    'Anderson',
    'Paul',
    'panderson@email.com',
    NULL,
    NULL
  );

-- --------------------------------------------------------
--
-- Structure de la table `commandes`
--
DROP TABLE IF EXISTS `commandes`;

CREATE TABLE
  IF NOT EXISTS `commandes` (
    `id_commande` int NOT NULL AUTO_INCREMENT,
    `id_client` int DEFAULT NULL,
    `date_commande` datetime DEFAULT NULL,
    `statut` enum ('en_attente', 'expediee', 'livree', 'annulee') DEFAULT NULL,
    `montant_total` decimal(10, 2) DEFAULT NULL,
    PRIMARY KEY (`id_commande`),
    KEY `id_client` (`id_client`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 21;

--
-- Déchargement des données de la table `commandes`
--
INSERT INTO
  `commandes` (
    `id_commande`,
    `id_client`,
    `date_commande`,
    `statut`,
    `montant_total`
  )
VALUES
  (1, 1, '2024-01-01 10:00:00', 'livree', '29.80'),
  (2, 2, '2024-01-02 11:30:00', 'expediee', '25.00'),
  (
    3,
    3,
    '2024-01-03 14:15:00',
    'en_attente',
    '19.90'
  ),
  (4, 4, '2024-01-04 16:45:00', 'livree', '16.80'),
  (5, 5, '2024-01-05 09:20:00', 'annulee', '7.90'),
  (6, 6, '2024-01-10 10:00:00', 'livree', '25.30'),
  (7, 7, '2024-01-11 11:30:00', 'expediee', '16.40'),
  (
    8,
    8,
    '2024-01-12 14:15:00',
    'en_attente',
    '24.70'
  ),
  (9, 9, '2024-01-13 16:45:00', 'livree', '15.80'),
  (10, 10, '2024-01-14 09:20:00', 'annulee', '8.90'),
  (11, 1, '2023-12-15 14:30:00', 'livree', '34.20'),
  (12, 2, '2023-12-20 16:45:00', 'livree', '25.80'),
  (13, 3, '2023-12-25 09:15:00', 'livree', '42.60'),
  (14, 4, '2023-12-30 11:30:00', 'livree', '16.90'),
  (15, 5, '2024-01-05 15:20:00', 'livree', '33.50'),
  (16, 1, '2024-01-15 10:00:00', NULL, '45.80'),
  (17, 2, NULL, 'en_attente', '29.90'),
  (18, 3, '2024-01-15 14:30:00', 'expediee', NULL),
  (19, 4, '2024-01-15 16:45:00', NULL, NULL),
  (20, 5, NULL, NULL, '15.90');

-- --------------------------------------------------------
--
-- Structure de la table `details_commande`
--
DROP TABLE IF EXISTS `details_commande`;

CREATE TABLE
  IF NOT EXISTS `details_commande` (
    `id_commande` int NOT NULL,
    `id_livre` int NOT NULL,
    `quantite` int DEFAULT NULL,
    `prix_unitaire` decimal(10, 2) DEFAULT NULL,
    PRIMARY KEY (`id_commande`, `id_livre`),
    KEY `id_livre` (`id_livre`)
  ) ENGINE = InnoDB;

--
-- Déchargement des données de la table `details_commande`
--
INSERT INTO
  `details_commande` (
    `id_commande`,
    `id_livre`,
    `quantite`,
    `prix_unitaire`
  )
VALUES
  (1, 1, 2, '9.90'),
  (1, 4, 1, '8.90'),
  (2, 2, 1, '25.00'),
  (3, 3, 1, '19.90'),
  (4, 1, 1, '9.90'),
  (4, 4, 1, '8.90'),
  (5, 5, 1, '7.90'),
  (6, 6, 2, '8.50'),
  (6, 7, 1, '8.90'),
  (7, 8, 1, '7.90'),
  (7, 9, 1, '7.50'),
  (8, 10, 2, '8.90'),
  (9, 6, 1, '8.50'),
  (9, 8, 1, '7.90'),
  (10, 7, 1, '8.90'),
  (11, 1, 2, '9.90'),
  (11, 3, 1, '19.90'),
  (12, 2, 1, '25.00'),
  (13, 4, 3, '8.90'),
  (13, 5, 2, '7.90'),
  (14, 1, 1, '9.90'),
  (14, 4, 1, '8.90'),
  (15, 3, 1, '19.90'),
  (15, 5, 2, '7.90'),
  (16, 1, NULL, '9.90'),
  (17, 2, 1, NULL),
  (18, 3, NULL, NULL),
  (19, 4, 2, '8.90'),
  (20, 5, NULL, NULL);

-- --------------------------------------------------------
--
-- Structure de la table `editeurs`
--
DROP TABLE IF EXISTS `editeurs`;

CREATE TABLE
  IF NOT EXISTS `editeurs` (
    `id_editeur` int NOT NULL AUTO_INCREMENT,
    `nom` varchar(100) NOT NULL,
    `ville` varchar(50) DEFAULT NULL,
    `pays` varchar(50) DEFAULT NULL,
    `date_creation` date DEFAULT NULL,
    PRIMARY KEY (`id_editeur`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 16;

--
-- Déchargement des données de la table `editeurs`
--
INSERT INTO
  `editeurs` (
    `id_editeur`,
    `nom`,
    `ville`,
    `pays`,
    `date_creation`
  )
VALUES
  (1, 'Gallimard', 'Paris', 'France', NULL),
  (2, 'Flammarion', 'Paris', 'France', '1875-01-01'),
  (3, 'Actes Sud', 'Arles', 'France', '1978-01-01'),
  (
    4,
    'Albin Michel',
    'Paris',
    'France',
    '1900-01-01'
  ),
  (5, 'Hachette', 'Paris', 'France', '1826-01-01'),
  (6, 'Seuil', 'Paris', 'France', '1935-01-01'),
  (7, 'Minuit', 'Paris', 'France', '1941-01-01'),
  (8, 'POL', 'Paris', 'France', '1983-01-01'),
  (9, 'Verdier', 'Lagrasse', 'France', '1979-01-01'),
  (10, 'Grasset', 'Paris', 'France', '1907-01-01'),
  (11, 'Pocket', NULL, 'France', NULL),
  (
    12,
    'Penguin Books',
    'Londres',
    NULL,
    '1935-07-30'
  ),
  (
    13,
    'Les Éditions de Minuit',
    'Paris',
    'France',
    NULL
  ),
  (14, 'Random House', NULL, NULL, '1927-01-01'),
  (15, 'Folio', 'Paris', NULL, NULL);

-- --------------------------------------------------------
--
-- Structure de la table `livres`
--
DROP TABLE IF EXISTS `livres`;

CREATE TABLE
  IF NOT EXISTS `livres` (
    `id_livre` int NOT NULL AUTO_INCREMENT,
    `titre` varchar(200) NOT NULL,
    `id_editeur` int DEFAULT NULL,
    `id_categorie` int DEFAULT NULL,
    `prix` decimal(10, 2) DEFAULT NULL,
    `date_publication` date DEFAULT NULL,
    `stock` int DEFAULT '0',
    `resume` text,
    `themes` text,
    `critiques` text,
    `mots_cles` text,
    PRIMARY KEY (`id_livre`),
    KEY `id_editeur` (`id_editeur`),
    KEY `id_categorie` (`id_categorie`)
  ) ENGINE = InnoDB AUTO_INCREMENT = 56;

--
-- Déchargement des données de la table `livres`
--
INSERT INTO
  `livres` (
    `id_livre`,
    `titre`,
    `id_editeur`,
    `id_categorie`,
    `prix`,
    `date_publication`,
    `stock`,
    `resume`,
    `themes`,
    `critiques`,
    `mots_cles`
  )
VALUES
  (
    1,
    'L\'Étranger',
    1,
    1,
    '9.90',
    '1942-01-01',
    150,
    'Un employé de bureau à Alger qui, après l\'enterrement de sa mère, se trouve impliqué dans un meurtre sur une plage. Son procès devient celui de son indifférence face aux conventions sociales.',
    'Absurde, aliénation, justice, morale, indifférence, soleil, chaleur, mer, meurtre, procès',
    'Œuvre majeure de l\'existentialisme qui explore l\'absurdité de la condition humaine avec un style épuré et direct.',
    'existentialisme, Camus, Algérie, absurde, procès, justice'
  ),
  (
    2,
    'Le Deuxième Sexe',
    1,
    2,
    '25.00',
    '1949-01-01',
    75,
    'Essai fondamental sur la condition féminine qui analyse comment les femmes ont été construites comme \"l\'Autre\" à travers l\'histoire, la biologie, la psychanalyse et la littérature.',
    'Féminisme, condition féminine, genre, patriarcat, émancipation, corps, sexualité, maternité',
    'Texte fondateur du féminisme moderne, remarquable par sa rigueur analytique et sa portée philosophique.',
    'féminisme, Beauvoir, femmes, philosophie, genre, émancipation'
  ),
  (
    3,
    'Les Misérables',
    2,
    1,
    '19.90',
    '1862-01-01',
    100,
    'L\'histoire de Jean Valjean, ancien bagnard cherchant la rédemption, et d\'une galerie de personnages dans le Paris du XIXe siècle, sur fond de révolte et de justice sociale.',
    'Justice sociale, rédemption, amour, révolution, misère, Paris, barricades',
    'Fresque sociale monumentale alliant histoire collective et destins individuels avec une force narrative exceptionnelle.',
    'Hugo, Paris, révolte, justice, misère, Cosette, Gavroche'
  ),
  (
    4,
    'La Nausée',
    1,
    1,
    '8.90',
    '1938-01-01',
    80,
    'Antoine Roquentin, un historien, fait l\'expérience de la contingence de l\'existence lors de son séjour à Bouville, relatant dans son journal sa découverte de l\'absurdité de la vie.',
    'Existentialisme, contingence, solitude, néant, conscience, quotidien, écriture',
    'Roman philosophique majeur qui pose les bases de l\'existentialisme sartrien à travers une exploration de la conscience.',
    'Sartre, existentialisme, conscience, contingence, journal, néant'
  ),
  (
    5,
    'L\'Amant',
    3,
    1,
    '7.90',
    '1984-01-01',
    120,
    'Dans l\'Indochine coloniale, une adolescente française entame une liaison avec un riche Chinois, histoire qui devient une exploration de la mémoire et du désir.',
    'Amour, désir, colonialisme, adolescence, mémoire, famille, Indochine',
    'Chef-d\'œuvre autobiographique où Duras réinvente son style, créant une narration unique entre fiction et mémoire.',
    'Duras, Indochine, désir, colonialisme, autobiographie, mémoire'
  ),
  (
    6,
    'La Place',
    3,
    1,
    '8.50',
    '1983-01-01',
    90,
    'Récit autobiographique explorant les origines sociales de l\'auteure et sa relation avec son père, ouvrier devenu petit commerçant.',
    'Classe sociale, éducation, famille, ascension sociale, honte, mémoire',
    'Texte majeur sur la mobilité sociale et l\'aliénation culturelle, écrit dans un style d\'une précision clinique.',
    'Ernaux, classe sociale, autobiographie, père, mémoire, sociologie'
  ),
  (
    7,
    'Plateforme',
    4,
    1,
    '8.90',
    '2001-01-01',
    85,
    'Un employé du ministère du Tourisme développe un projet mêlant tourisme sexuel et critique de la société occidentale contemporaine.',
    'Sexualité, mondialisation, tourisme, critique sociale, solitude, capitalisme',
    'Roman provocateur qui analyse les dérives de la société de consommation et la marchandisation des relations humaines.',
    'Houellebecq, société contemporaine, sexualité, mondialisation, critique'
  ),
  (
    8,
    'Hygiene et l\'assassin',
    2,
    1,
    '7.90',
    '1992-01-01',
    70,
    'Premier roman mettant en scène une romancière misanthrope confrontée à un journaliste qui enquête sur son passé trouble.',
    'Littérature, violence, misanthropie, médias, vérité, manipulation',
    'Début fracassant qui pose les bases du style Nothomb, entre humour noir et exploration des rapports de force.',
    'Nothomb, interview, écrivain, violence, humour noir, médias'
  ),
  (
    9,
    'Rue des Boutiques Obscures',
    1,
    1,
    '7.50',
    '1978-01-01',
    65,
    'Un détective privé amnésique enquête sur sa propre identité dans le Paris des années 1960, croisant des figures du passé.',
    'Mémoire, identité, enquête, Paris, passé, occupation, judaïsme',
    'Roman noir poétique sur la mémoire et l\'identité, typique de l\'art de Modiano de faire ressurgir le passé.',
    'Modiano, mémoire, identité, Paris, enquête, occupation'
  ),
  (
    10,
    'Vernon Subutex, tome 1',
    5,
    1,
    '8.90',
    '2015-01-01',
    110,
    'Un ancien disquaire parisien se retrouve à la rue et traverse différentes strates de la société contemporaine.',
    'Précarité, musique, société contemporaine, Paris, déchéance, amitié',
    'Fresque sociale contemporaine qui dresse un portrait saisissant de la précarisation et des mutations sociales.',
    'Despentes, société, musique, précarité, Paris, roman social'
  ),
  (
    11,
    'Le Silence de la mer',
    1,
    1,
    '7.90',
    '1952-03-15',
    45,
    'Pendant l\'Occupation, un officier allemand est hébergé chez un homme et sa nièce qui opposent à sa présence un silence obstiné.',
    'Résistance, occupation, silence, dignité, guerre, choix moral',
    'Une œuvre emblématique de la Résistance qui fait du silence une arme de dignité et de refus.',
    'Vercors, Résistance, Occupation, silence, guerre, dignité'
  ),
  (
    12,
    'Bonjour tristesse',
    2,
    1,
    '6.90',
    '1954-06-20',
    60,
    'Une jeune fille de 17 ans découvre l\'amour et la sensualité pendant ses vacances sur la Côte d\'Azur, bouleversant l\'équilibre familial.',
    'Adolescence, amour, sensualité, famille, jalousie, insouciance',
    'Premier roman précoce qui fit scandale par sa fraîcheur et son audace dans la description des émois adolescents.',
    'Sagan, jeunesse, amour, scandale, été, Côte d\'Azur'
  ),
  (
    13,
    'Le Square',
    3,
    1,
    '8.50',
    '1955-09-10',
    35,
    'Une jeune femme et un homme plus âgé se rencontrent régulièrement sur une place publique, échangeant sur leur vie et leurs aspirations.',
    'Dialogue, solitude, amour, classe sociale, ville, rencontre',
    'Un texte minimaliste qui explore les possibilités du dialogue et les tensions sociales.',
    'Duras, dialogue, rencontre, ville, solitude, classe sociale'
  ),
  (
    14,
    'Le Ravissement de Lol V. Stein',
    1,
    1,
    '9.90',
    '1964-04-25',
    50,
    'Après avoir été abandonnée par son fiancé lors d\'un bal, une jeune femme sombre dans une forme de folie obsessionnelle.',
    'Amour, folie, obsession, mémoire, regard, désir, absence',
    'Roman hypnotique qui révolutionne la narration pour explorer les zones troubles de la psyché.',
    'Duras, folie, bal, abandon, obsession, mémoire'
  ),
  (
    15,
    'Les Choses',
    2,
    1,
    '8.90',
    '1965-11-30',
    40,
    'Un jeune couple parisien est obsédé par l\'acquisition d\'objets et le désir d\'une vie meilleure dans les années 1960.',
    'Consommation, désir, objets, société, couple, argent',
    'Critique acerbe de la société de consommation naissante et du matérialisme moderne.',
    'Perec, consommation, années 60, objets, désir, société'
  ),
  (
    16,
    'La Route des Flandres',
    3,
    1,
    '12.90',
    '1967-02-15',
    30,
    'Un ancien cavalier revit ses souvenirs de la débâcle de 1940, mêlant présent et passé dans un récit fragmenté.',
    'Guerre, mémoire, temps, défaite, cavalerie, Histoire',
    'Chef-d\'œuvre du nouveau roman qui bouleverse la chronologie pour dire l\'expérience de la guerre.',
    'Simon, guerre, mémoire, nouveau roman, temps, défaite'
  ),
  (
    17,
    'Détruire, dit-elle',
    1,
    1,
    '7.50',
    '1972-07-08',
    55,
    'Dans un hôtel, trois personnages sont pris dans un triangle complexe de désirs et de destruction.',
    'Désir, destruction, violence, triangle amoureux, folie, enfermement',
    'Texte radical qui pousse à l\'extrême l\'épurement du style et la déconstruction narrative.',
    'Duras, désir, destruction, triangle, hôtel, violence'
  ),
  (
    18,
    'W ou le Souvenir d\'enfance',
    2,
    1,
    '10.50',
    '1975-09-22',
    45,
    'Deux récits parallèles : l\'histoire d\'une île imaginaire où règne une tyrannie sportive et les souvenirs d\'enfance de l\'auteur.',
    'Mémoire, Shoah, sport, totalitarisme, enfance, disparition',
    'Œuvre unique qui mêle autobiographie et fiction pour dire l\'indicible de la Shoah.',
    'Perec, Shoah, mémoire, sport, autobiographie, totalitarisme'
  ),
  (
    19,
    'Le Vent',
    3,
    1,
    '11.90',
    '1978-12-05',
    35,
    'Un récit qui explore les effets du vent sur un paysage et ses habitants, créant une atmosphère d\'étrangeté croissante.',
    'Nature, perception, paysage, solitude, éléments, temps',
    'Expérience littéraire qui transforme un phénomène naturel en révélateur existentiel.',
    'Simon, nature, perception, nouveau roman, paysage, vent'
  ),
  (
    20,
    'L\'Amant',
    1,
    1,
    '9.90',
    '1984-03-18',
    70,
    'L\'histoire d\'une passion entre une jeune fille et un riche Chinois dans l\'Indochine coloniale, mêlant désir et relations familiales.',
    'Amour, colonialisme, famille, désir, adolescence, Indochine',
    'Récit autobiographique majeur qui révolutionne l\'écriture du souvenir et du désir.',
    'Duras, Indochine, amour, colonialisme, autobiographie, désir'
  ),
  (
    21,
    'Un barrage contre le Pacifique',
    2,
    1,
    '11.50',
    '1986-06-29',
    60,
    'Une famille française tente de survivre en Indochine coloniale en construisant une digue contre l\'océan, confrontée à la corruption locale et à la pauvreté.',
    'Colonialisme, famille, pauvreté, lutte, mer, corruption, désespoir',
    'Roman semi-autobiographique puissant sur l\'échec du rêve colonial et la misère des petits colons.',
    'Duras, Indochine, colonialisme, famille, pauvreté, mer'
  ),
  (
    22,
    'La Lenteur',
    3,
    1,
    '13.90',
    '1989-10-12',
    50,
    'Une réflexion sur la vitesse et la lenteur dans le monde moderne, à travers l\'histoire d\'un homme qui redécouvre le plaisir de la lenteur.',
    'Modernité, temps, vitesse, plaisir, mémoire, philosophie',
    'Méditation romanesque élégante sur notre rapport au temps et à la modernité.',
    'Kundera, temps, modernité, philosophie, lenteur, plaisir'
  ),
  (
    23,
    'Les Particules élémentaires',
    1,
    1,
    '12.90',
    '1998-08-24',
    80,
    'L\'histoire de deux demi-frères, un biologiste et un professeur, qui incarnent le malaise de la fin du XXe siècle entre science et désir.',
    'Science, sexualité, solitude, société contemporaine, famille, génétique',
    'Roman provocateur qui dresse un constat sans concession de la société contemporaine.',
    'Houellebecq, science, sexe, société, solitude, critique'
  ),
  (
    24,
    'Je m\'en vais',
    2,
    1,
    '10.90',
    '1999-11-15',
    65,
    'Un antiquaire quitte sa femme et part à la recherche d\'un trésor artistique dans le Grand Nord, confronté à ses choix de vie.',
    'Voyage, art, couple, quête, solitude, Grand Nord, aventure',
    'Roman d\'aventures contemporain qui mêle quête artistique et exploration personnelle.',
    'Echenoz, voyage, art, aventure, contemporain, prix Goncourt'
  ),
  (
    25,
    'Les Bienveillantes',
    1,
    1,
    '14.90',
    '2006-01-07',
    90,
    'Un officier SS raconte son parcours pendant la Seconde Guerre mondiale, de l\'Ukraine à la chute de Berlin.',
    'Guerre, Shoah, violence, histoire, moral, responsabilité, nazisme',
    'Œuvre monumentale et controversée sur la banalité du mal et la responsabilité individuelle.',
    'Littell, guerre, Shoah, nazisme, histoire, violence'
  ),
  (
    26,
    'La Carte et le Territoire',
    2,
    1,
    '13.90',
    '2008-04-19',
    75,
    'Un artiste contemporain fait le portrait d\'un écrivain célèbre, explorant les liens entre art, littérature et marché de l\'art.',
    'Art contemporain, célébrité, création, marché de l\'art, identité',
    'Réflexion brillante sur l\'art contemporain et ses dérives marchandes.',
    'Houellebecq, art, contemporain, marché, création, prix Goncourt'
  ),
  (
    27,
    'L\'Anomalie',
    1,
    1,
    '15.90',
    '2015-05-30',
    100,
    'Un vol Paris-New York se retrouve dédoublé avec ses passagers, créant une situation qui remet en question la réalité.',
    'Science-fiction, identité, réalité, monde contemporain, paradoxe',
    'Roman vertigineux qui questionne notre rapport à la réalité et à l\'identité.',
    'Le Tellier, science-fiction, réalité, identité, prix Goncourt'
  ),
  (
    28,
    'Leurs enfants après eux',
    2,
    1,
    '14.90',
    '2018-08-16',
    85,
    'Chronique d\'une jeunesse dans la France des années 1990, entre désillusions sociales et espoirs personnels.',
    'Jeunesse, société, classe sociale, France, années 90, désillusion',
    'Fresque sociale puissante sur une génération confrontée au déclin industriel.',
    'Mathieu, jeunesse, social, France, prix Goncourt, génération'
  ),
  (
    29,
    'Le Pays des autres',
    1,
    1,
    '16.90',
    '2020-02-28',
    95,
    'Dans le Maroc des années 1950, une Française suit son mari marocain, confrontée aux défis de l\'adaptation culturelle.',
    'Maroc, colonisation, couple mixte, culture, identité, émancipation',
    'Premier volet d\'une trilogie qui explore les tensions du Maroc colonial.',
    'Slimani, Maroc, colonisation, femmes, culture, identité'
  ),
  (
    30,
    'La Plus Secrète Mémoire des hommes',
    2,
    1,
    '17.90',
    '2023-09-14',
    88,
    'Un jeune écrivain sénégalais enquête sur un mystérieux auteur des années 1930, découvrant des secrets enfouis.',
    'Littérature, colonialisme, mémoire, enquête, Afrique, identité',
    'Roman ambitieux sur la littérature, la mémoire coloniale et la création.',
    'Sarr, littérature, Afrique, mémoire, prix Goncourt, colonial'
  ),
  (
    31,
    'La Modification',
    3,
    1,
    '8.90',
    '1952-05-20',
    40,
    'Un homme en voyage d\'affaires à Rome voit sa vie bouleversée par une expérience mystique dans le train, remettant en question son mariage.',
    'Voyage, conscience, changement, couple, modernité, ville',
    'Roman emblématique du Nouveau Roman qui explore les transformations de la conscience.',
    'Butor, nouveau roman, voyage, conscience, modernité, Rome'
  ),
  (
    32,
    'Le Marteau sans maître',
    4,
    3,
    '9.90',
    '1954-08-15',
    35,
    'Recueil de poèmes révolutionnant le langage poétique, explorant les limites entre musique et poésie.',
    'Poésie, musique, langage, modernité, expérimentation, rythme',
    'Œuvre majeure de la poésie moderne qui repousse les frontières du langage.',
    'Char, poésie, musique, avant-garde, langage, modernité'
  ),
  (
    33,
    'Les Gommes',
    2,
    1,
    '7.90',
    '1955-11-25',
    45,
    'Un détective enquête sur un meurtre qui n\'a peut-être pas eu lieu, dans une ville où le temps semble se répéter.',
    'Enquête, temps, répétition, identité, ville, confusion',
    'Premier roman majeur du Nouveau Roman qui déconstruit les codes du polar.',
    'Robbe-Grillet, nouveau roman, policier, temps, répétition'
  ),
  (
    34,
    'Le Planétarium',
    3,
    1,
    '10.90',
    '1964-07-12',
    55,
    'Une famille bourgeoise est observée à travers les regards croisés de ses membres, révélant tensions et non-dits.',
    'Famille, bourgeoisie, regard, intériorité, objets, espace',
    'Analyse minutieuse des relations familiales à travers une écriture du regard.',
    'Sarraute, nouveau roman, famille, regard, bourgeoisie'
  ),
  (
    35,
    'Pour un nouveau roman',
    4,
    2,
    '11.90',
    '1965-10-18',
    40,
    'Manifeste littéraire théorisant les principes du Nouveau Roman et sa rupture avec le roman traditionnel.',
    'Littérature, théorie, modernité, écriture, roman, avant-garde',
    'Texte théorique essentiel qui définit les enjeux d\'une nouvelle écriture.',
    'Robbe-Grillet, nouveau roman, théorie, modernité, manifeste'
  ),
  (
    36,
    'L\'Herbe',
    2,
    1,
    '9.90',
    '1967-05-30',
    35,
    'Une femme observe sa belle-mère mourante dans un jardin, méditant sur le temps et la nature.',
    'Mort, nature, temps, famille, observation, jardin, mémoire',
    'Texte subtil sur le temps et la mort, caractéristique du style Simon.',
    'Simon, nouveau roman, nature, temps, mort, observation'
  ),
  (
    37,
    'Les Corps conducteurs',
    3,
    1,
    '8.50',
    '1972-09-14',
    50,
    'Un homme traverse New York, ses sensations et perceptions se mêlant aux souvenirs et aux images.',
    'Ville, corps, perception, mouvement, mémoire, sensations',
    'Expérimentation narrative radicale sur la perception et le mouvement.',
    'Simon, nouveau roman, ville, corps, perception, New York'
  ),
  (
    38,
    'Fils',
    4,
    1,
    '11.50',
    '1975-11-30',
    45,
    'Récit autobiographique explorant la relation père-fils et la construction de l\'identité à travers l\'écriture.',
    'Autobiographie, père, psychanalyse, écriture, identité, famille',
    'Œuvre fondatrice de l\'autofiction mêlant analyse et récit personnel.',
    'Doubrovsky, autofiction, psychanalyse, père, identité'
  ),
  (
    39,
    'Le Nom des singes',
    2,
    1,
    '10.90',
    '1978-03-22',
    40,
    'Un roman qui suit plusieurs personnages dans une ville africaine, explorant les relations post-coloniales.',
    'Afrique, colonialisme, ville, identité, politique, relations',
    'Portrait complexe des relations post-coloniales dans l\'Afrique contemporaine.',
    'Sony Labou Tansi, Afrique, post-colonial, politique'
  ),
  (
    40,
    'L\'Été 80',
    3,
    1,
    '10.90',
    '1984-06-25',
    65,
    'Journal d\'un été marqué par des événements politiques et personnels, mêlant actualité et intimité.',
    'Journal, politique, intimité, été, mémoire, histoire',
    'Texte hybride qui tisse liens entre histoire collective et personnelle.',
    'Duras, journal, politique, intimité, histoire, actualité'
  ),
  (
    41,
    'Cherokee',
    4,
    1,
    '12.50',
    '1986-09-10',
    55,
    'Un détective français d\'origine iroquoise enquête sur une série de meurtres dans le milieu du cinéma pornographique.',
    'Enquête, identité, cinéma, violence, sexualité, ville',
    'Roman noir original qui mêle enquête policière et questionnement identitaire.',
    'Echenoz, polar, identité, cinéma, enquête, contemporain'
  ),
  (
    42,
    'Les Années',
    2,
    1,
    '11.90',
    '1989-12-28',
    50,
    'Fresque historique et intime retraçant soixante ans d\'histoire française à travers la mémoire personnelle.',
    'Mémoire, histoire, France, femmes, société, temps',
    'Chef-d\'œuvre d\'Ernaux qui mêle histoire collective et mémoire individuelle.',
    'Ernaux, mémoire, histoire, autobiographie, société, femmes'
  ),
  (
    43,
    'La Reprise',
    3,
    1,
    '13.90',
    '1998-10-15',
    75,
    'Un homme retourne dans sa ville natale de Berlin et revit des souvenirs troublants de son passé.',
    'Mémoire, ville, histoire, identité, retour, Berlin',
    'Exploration subtile de la mémoire et de l\'histoire à travers le prisme personnel.',
    'Robbe-Grillet, Berlin, mémoire, histoire, identité, ville'
  ),
  (
    44,
    'Extension du domaine de la lutte',
    4,
    1,
    '11.90',
    '1999-02-28',
    70,
    'Un informaticien dépressif décrit sa vie professionnelle aliénante et sa solitude dans la société moderne.',
    'Travail, dépression, société moderne, solitude, aliénation',
    'Premier roman coup de poing sur le mal-être dans la société contemporaine.',
    'Houellebecq, travail, société, dépression, modernité'
  ),
  (
    45,
    'Les Échelles du Levant',
    3,
    1,
    '15.90',
    '2006-03-18',
    85,
    'Saga familiale se déroulant au Proche-Orient, explorant les liens entre histoire personnelle et collective.',
    'Proche-Orient, famille, histoire, identité, exil, mémoire',
    'Fresque ambitieuse mêlant grande histoire et destins individuels.',
    'Maalouf, Orient, histoire, famille, identité, exil'
  ),
  (
    46,
    'Ritournelle de la faim',
    4,
    1,
    '14.90',
    '2008-06-30',
    80,
    'Une femme âgée se remémore son enfance pendant la guerre et la faim qui marqua cette période.',
    'Guerre, faim, enfance, mémoire, survie, histoire',
    'Récit poignant sur la guerre vue à travers les yeux d\'une enfant.',
    'Duras, guerre, enfance, faim, mémoire, histoire'
  ),
  (
    47,
    'Boussole',
    3,
    1,
    '16.90',
    '2015-08-12',
    95,
    'Un universitaire spécialiste de l\'Orient voyage à travers le temps et l\'espace, confrontant Orient et Occident.',
    'Orient, voyage, savoir, amour, histoire, culture',
    'Méditation érudite sur les relations entre Orient et Occident.',
    'Enard, Orient, voyage, culture, prix Goncourt, histoire'
  ),
  (
    48,
    'La Septième Fonction du langage',
    4,
    1,
    '15.90',
    '2018-11-25',
    90,
    'Enquête sur la mort mystérieuse de Roland Barthes, mêlant théorie littéraire et thriller.',
    'Littérature, théorie, enquête, université, sémiotique, pouvoir',
    'Roman ludique qui transforme la théorie littéraire en intrigue policière.',
    'Binet, Barthes, théorie, enquête, université, sémiotique'
  ),
  (
    49,
    'Premier sang',
    3,
    1,
    '18.90',
    '2020-05-15',
    100,
    'Récit autobiographique sur la relation de l\'auteure avec son père, ancien résistant devenu policier.',
    'Père, filiation, violence, histoire, famille, résistance',
    'Exploration intime et politique des liens père-fille.',
    'Nothomb, père, autobiographie, famille, violence'
  ),
  (
    50,
    'Le Grand Monde',
    4,
    1,
    '19.90',
    '2023-11-30',
    95,
    'Fresque familiale se déroulant dans les années 20, explorant une famille de commerçants pendant l\'entre-deux-guerres.',
    'Famille, histoire, commerce, entre-deux-guerres, société',
    'Grande fresque historique qui peint le portrait d\'une époque à travers une famille.',
    'Lemaitre, histoire, famille, entre-deux-guerres, société'
  ),
  (
    51,
    'À la recherche du temps perdu',
    1,
    1,
    NULL,
    '1913-11-14',
    50,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  (
    52,
    'Mrs Dalloway',
    NULL,
    1,
    '12.90',
    '1925-05-14',
    30,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  (
    53,
    'Le Procès',
    3,
    NULL,
    '11.50',
    NULL,
    45,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  (
    54,
    'Mémoires d\'Hadrien',
    2,
    1,
    '14.90',
    '1951-01-01',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  (
    55,
    'Cent ans de solitude',
    NULL,
    1,
    NULL,
    '1967-05-30',
    60,
    NULL,
    NULL,
    NULL,
    NULL
  );

--
-- Contraintes pour les tables déchargées
--
--
-- Contraintes pour la table `auteurs_livres`
--
ALTER TABLE `auteurs_livres` ADD CONSTRAINT `auteurs_livres_ibfk_1` FOREIGN KEY (`id_auteur`) REFERENCES `auteurs` (`id_auteur`),
ADD CONSTRAINT `auteurs_livres_ibfk_2` FOREIGN KEY (`id_livre`) REFERENCES `livres` (`id_livre`);

--
-- Contraintes pour la table `commandes`
--
ALTER TABLE `commandes` ADD CONSTRAINT `commandes_ibfk_1` FOREIGN KEY (`id_client`) REFERENCES `clients` (`id_client`);

--
-- Contraintes pour la table `details_commande`
--
ALTER TABLE `details_commande` ADD CONSTRAINT `details_commande_ibfk_1` FOREIGN KEY (`id_commande`) REFERENCES `commandes` (`id_commande`),
ADD CONSTRAINT `details_commande_ibfk_2` FOREIGN KEY (`id_livre`) REFERENCES `livres` (`id_livre`);

--
-- Contraintes pour la table `livres`
--
ALTER TABLE `livres` ADD CONSTRAINT `livres_ibfk_1` FOREIGN KEY (`id_editeur`) REFERENCES `editeurs` (`id_editeur`),
ADD CONSTRAINT `livres_ibfk_2` FOREIGN KEY (`id_categorie`) REFERENCES `categories` (`id_categorie`);

COMMIT;