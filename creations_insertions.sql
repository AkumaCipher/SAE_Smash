--- BASE ET TABLES --- 
CREATE DATABASE smash;

CREATE TABLE Personnes(
   id_personne INT,
   pseudo VARCHAR(50),
   age INT,
   sexe CHAR(1),
   pays VARCHAR(50),
   sponsor VARCHAR(100),
   PRIMARY KEY(id_personne)
);

CREATE TABLE Classement(
   rang INT,
   victoires INT,
   ratio REAL,clear
   id_personne INT NOT NULL,
   PRIMARY KEY(rang),
   FOREIGN KEY(id_personne) REFERENCES Personnes(id_personne)
);

CREATE TABLE Cartes(
   id_carte INT,
   nom VARCHAR(100),
   PRIMARY KEY(id_carte)
);

CREATE TABLE Franchises(
   id_franchise INT,
   nom VARCHAR(100),
   PRIMARY KEY(id_franchise)
);

CREATE TABLE Historique(
   id_commande INT,
   instruction VARCHAR(50),
   table_concernée VARCHAR(50),
   date_save DATE,
   PRIMARY KEY(id_commande)
);

CREATE TABLE Personnages(
   id_perso INT,
   nom VARCHAR(50),
   id_franchise INT NOT NULL,
   PRIMARY KEY(id_perso),
   FOREIGN KEY(id_franchise) REFERENCES Franchises(id_franchise)
);

CREATE TABLE Matchs(
   id_match INT,
   score_J1 INT,
   score_J2 INT,
   id_carte INT NOT NULL,
   regles VARCHAR(50),
   PRIMARY KEY(id_match),
   FOREIGN KEY(id_carte) REFERENCES Cartes(id_carte)
);

CREATE TABLE Jouer_dans(
   id_joueur INT,
   id_match INT NOT NULL,
   id_personne INT NOT NULL,
   id_perso INT NOT NULL,
   PRIMARY KEY(id_joueur),
   FOREIGN KEY(id_match) REFERENCES Matchs(id_match),
   FOREIGN KEY(id_perso) REFERENCES Personnages(id_perso),
   FOREIGN KEY(id_personne) REFERENCES Personnes(id_personne)
);

--- INSERTIONS ---
INSERT INTO franchises values(1,  'Super Mario');
INSERT INTO franchises values(2,  'Pokemon');
INSERT INTO franchises values(3,  'Zelda');
INSERT INTO franchises values(4,  'Fire Emblem');
INSERT INTO franchises values(5,  'Metroid');
INSERT INTO franchises values(6,  'Kirby');
INSERT INTO franchises values(7,  'Star Fox');
INSERT INTO franchises values(8,  'Kid Icarus');
INSERT INTO franchises values(9,  'Donkey Kong');
INSERT INTO franchises values(10, 'Earthbound');
INSERT INTO franchises values(11, 'Yoshi');
INSERT INTO franchises values(12, 'F-Zero');
INSERT INTO franchises values(13, 'Ice Climber');
INSERT INTO franchises values(14, 'Game & Watch');
INSERT INTO franchises values(15, 'WarioWare');
INSERT INTO franchises values(16, 'Metal Gear');
INSERT INTO franchises values(17, 'Sonic the Hedgehog');
INSERT INTO franchises values(18, 'Pikmin');
INSERT INTO franchises values(19, 'Nintendo Entertainment System');
INSERT INTO franchises values(20, 'Animal Crossing');
INSERT INTO franchises values(21, 'Megaman');
INSERT INTO franchises values(22, 'Wii Fit');
INSERT INTO franchises values(23, 'Punch-Out');
INSERT INTO franchises values(24, 'Mii');
INSERT INTO franchises values(25, 'Pac-Man');
INSERT INTO franchises values(26, 'Xenoblade');
INSERT INTO franchises values(27, 'Duck Hunt');
INSERT INTO franchises values(28, 'Street Fighter');
INSERT INTO franchises values(29, 'Final Fantasy');
INSERT INTO franchises values(30, 'Bayonetta');
INSERT INTO franchises values(31, 'Splatoon');
INSERT INTO franchises values(32, 'Castlevania');
INSERT INTO franchises values(33, 'Persona');
INSERT INTO franchises values(34, 'Dragon Quest');
INSERT INTO franchises values(35, 'Banjo-Kazooie');
INSERT INTO franchises values(36, 'Fatal Fury');
INSERT INTO franchises values(37, 'Arms');
INSERT INTO franchises values(38, 'Minecraft');
INSERT INTO franchises values(39, 'Tekken');
INSERT INTO franchises values(40, 'Kingdom Hearts');

INSERT INTO personnages values(1,  'Mario', 1);
INSERT INTO personnages values(2,  'Donkey Kong', 9);
INSERT INTO personnages values(3,  'Link', 3);
INSERT INTO personnages values(4,  'Samus', 5);
INSERT INTO personnages values(5,  'Dark Samus', 5);
INSERT INTO personnages values(6,  'Yoshi', 11);
INSERT INTO personnages values(7,  'Kirby', 6);
INSERT INTO personnages values(8,  'Fox', 7);
INSERT INTO personnages values(9,  'Pikachu', 2);
INSERT INTO personnages values(10, 'Luigi', 1);
INSERT INTO personnages values(11, 'Ness', 10);
INSERT INTO personnages values(12, 'Captain Falcon', 12);
INSERT INTO personnages values(13, 'Jigglypuff', 2);
INSERT INTO personnages values(14, 'Peach', 1);
INSERT INTO personnages values(15, 'Daisy', 1);
INSERT INTO personnages values(16, 'Bowser', 1);
INSERT INTO personnages values(17, 'Ice Climbers', 13);
INSERT INTO personnages values(18, 'Sheik', 3);
INSERT INTO personnages values(19, 'Zelda', 3);
INSERT INTO personnages values(20, 'Dr. Mario', 1);
INSERT INTO personnages values(21, 'Pichu', 2);
INSERT INTO personnages values(22, 'Falco', 7);
INSERT INTO personnages values(23, 'Marth', 4);
INSERT INTO personnages values(24, 'Lucina', 4);
INSERT INTO personnages values(25, 'Young Link', 3);
INSERT INTO personnages values(26, 'Ganondorf', 3);
INSERT INTO personnages values(27, 'Mewtwo', 2);
INSERT INTO personnages values(28, 'Roy', 4);
INSERT INTO personnages values(29, 'Chrom', 4);
INSERT INTO personnages values(30, 'Mr. Game & Watch', 14);
INSERT INTO personnages values(31, 'Meta Knight', 6);
INSERT INTO personnages values(32, 'Pit', 8);
INSERT INTO personnages values(33, 'Dark Pit', 8);
INSERT INTO personnages values(34, 'Zero Suit Samus', 5);
INSERT INTO personnages values(35, 'Wario', 15);
INSERT INTO personnages values(36, 'Snake', 16);
INSERT INTO personnages values(37, 'Ike', 4);
INSERT INTO personnages values(38, 'Pokemon Trainer', 2);
INSERT INTO personnages values(39, 'Diddy Kong', 9);
INSERT INTO personnages values(40, 'Lucas', 10);
INSERT INTO personnages values(41, 'Sonic', 17);
INSERT INTO personnages values(42, 'King Dedede', 6);
INSERT INTO personnages values(43, 'Olimar', 18);
INSERT INTO personnages values(44, 'Lucario', 2);
INSERT INTO personnages values(45, 'R.O.B', 19);
INSERT INTO personnages values(46, 'Toon Link', 3);
INSERT INTO personnages values(47, 'Wolf', 7);
INSERT INTO personnages values(48, 'Villager', 20);
INSERT INTO personnages values(49, 'Mega Man', 21);
INSERT INTO personnages values(50, 'Wii Fit Trainer', 22);
INSERT INTO personnages values(51, 'Rosalina & Luma', 1);
INSERT INTO personnages values(52, 'Little Mac', 23);
INSERT INTO personnages values(53, 'Greninja', 2);
INSERT INTO personnages values(54, 'Mii Brawler', 24);
INSERT INTO personnages values(55, 'Mii Swordfighter', 24);
INSERT INTO personnages values(56, 'Mii Gunner', 24);
INSERT INTO personnages values(57, 'Palutena', 8);
INSERT INTO personnages values(58, 'Pac-Man', 25);
INSERT INTO personnages values(59, 'Robin', 4);
INSERT INTO personnages values(60, 'Shulk', 26);
INSERT INTO personnages values(61, 'Bowser Jr.', 1);
INSERT INTO personnages values(62, 'Duck Hunt', 27);
INSERT INTO personnages values(63, 'Ryu', 28);
INSERT INTO personnages values(64, 'Ken', 28);
INSERT INTO personnages values(65, 'Cloud', 29);
INSERT INTO personnages values(66, 'Corrin', 4);
INSERT INTO personnages values(67, 'Bayonetta', 30);
INSERT INTO personnages values(68, 'Inkling', 31);
INSERT INTO personnages values(69, 'Ridley', 5);
INSERT INTO personnages values(70, 'Simon', 32);
INSERT INTO personnages values(71, 'Richter', 32);
INSERT INTO personnages values(72, 'King K. Rool', 9);
INSERT INTO personnages values(73, 'Isabelle', 20);
INSERT INTO personnages values(74, 'Incineroar', 2);
INSERT INTO personnages values(75, 'Piranha Plant', 1);
INSERT INTO personnages values(76, 'Joker', 33);
INSERT INTO personnages values(77, 'Hero', 34);
INSERT INTO personnages values(78, 'Banjo & Kazooie', 35);
INSERT INTO personnages values(79, 'Terry', 36);
INSERT INTO personnages values(80, 'Byleth', 4);
INSERT INTO personnages values(81, 'Min Min', 37);
INSERT INTO personnages values(82, 'Steve', 38);
INSERT INTO personnages values(83, 'Sephiroth', 29);
INSERT INTO personnages values(84, 'Pyra/Mythra', 26);
INSERT INTO personnages values(85, 'Kazuya', 39);
INSERT INTO personnages values(86, 'Sora', 40);

INSERT INTO personnes values(1,  'MKleo', 21, 'M', 'Mexique', 'T1');
INSERT INTO personnes values(2,  'HungryBox', 29, 'Etats-Unis', 'T1');
INSERT INTO personnes values(3,  'Capitaine', 25, 'France','IUT');
INSERT INTO personnes values(4,  'Pacou',42,'F','France','IUT');
INSERT INTO personnes values(5,  'Gudrun',20,'M','France','Yggdrazil');
INSERT INTO personnes values(6,  'Akuma',20,'F','Angleterre','Cipher');
INSERT INTO personnes values(7,  'Dany',26,'M','France','SQL');
INSERT INTO personnes values(8,  'Moqmoq',14,'Espagne','Pokegang');
INSERT INTO personnes values(9,  'Akvir',62,'France','Eco Smash');
INSERT INTO personnes values(10, 'Pherax',24,'Irlande','SKUIZI');
INSERT INTO personnes values(11, 'Maximum Propum',24,'M','Suède','ArmadaTeam');
INSERT INTO personnes values(12, 'Moquouss',18,'M','France','Yggdrazil');
INSERT INTO personnes values(13, 'Joyca',26,'M','Écosse','Rhinoshield');
INSERT INTO personnes values(14, 'Glutonny',27,'M','France','WaaaaTeam');
INSERT INTO personnes values(15, 'Pataploup',19,'M','Etats-Unis','Xiaomi');
INSERT INTO personnes values(16, 'Jeff',44,'M','Etats-Unis','Samsung');
INSERT INTO personnes values(17, 'Armada',26,'M','Suisse','Iphone');
INSERT INTO personnes values(18, 'Mango',34,'M','Etats-Unis','Sony');
INSERT INTO personnes values(20, 'Mew2King',28,'F','Iran','Microsoft');
INSERT INTO personnes values(22, 'Leffen',24,'F','Etats-Unis','Bethesda');
INSERT INTO personnes values(23, 'Tayly',28,'M','Listembourg','Listembourg');
INSERT INTO personnes values(24, 'Dusty',23,'M','Etats-Unis','Gouvernement');
INSERT INTO personnes values(25, 'Craft',28,'M','Iran','Nintendo');
INSERT INTO personnes values(26, 'Skuizi',28,'M','France','Squeezie');
INSERT INTO personnes values(27, 'Kiyu',24,'M','France','SPA');
INSERT INTO personnes values(28, 'Paulok',14,'M','Listembourg','Charal');
INSERT INTO personnes values(29, 'Laupok',29,'M','France','Sega');
INSERT INTO personnes values(30, 'Socko',19,'M','Listembourg','Samsung');
INSERT INTO personnes values(31, 'Kennedy',28,'M','Etats-Unis','Gouvernement');
INSERT INTO personnes values(32, 'Florian',20,'F','France','Looping');
INSERT INTO personnes values(33, 'ArmadaJr',24,'F','Suède','Armada');
INSERT INTO personnes values(34, 'FilthyBox',44,'F','Mexique','Wespeed');
INSERT INTO personnes values(35, 'Pika1Queen',21,'F','Brésil','Hal Laboratory Inc.');
INSERT INTO personnes values(36, 'Appol', 25,'M','Chine','Bandai Namco');
INSERT INTO personnes values(37, 'Son Jr', 35,'M','Japon','Jump');
INSERT INTO personnes values(38, 'Rick', 42,'M','Etats-Unis','Cartoon Network');
INSERT INTO personnes values(39, 'Moonlight', 20, 'F', 'Angleterre', 'SK Gaming');
INSERT INTO personnes values(40, 'Yde', 23, 'M', 'Suède', 'Tribe');
INSERT INTO personnes values(41, 'Fishou', 33, 'M', 'France', 'Solary');
INSERT INTO personnes values(42, 'Odemian', 27, 'M', 'France', 'Twitch');
INSERT INTO personnes values(43, 'Amko', 18, 'F', 'Etats-Unis', 'Gabaret');
INSERT INTO personnes values(44, 'Tpixel', 19, 'F', 'Chine', 'Bing chilling');
INSERT INTO personnes values(43, 'Amko', 18, 'F', 'Etats-Unis', 'Gabaret');
INSERT INTO personnes values(44, 'Yurika', 22, 'F', 'Inde', 'Oreo');
INSERT INTO personnes values(45, 'Lolodrog', 23, 'M', 'France', 'Rhinoshield');
INSERT INTO personnes values(47, 'Mily', 28, 'F', 'Etats-Unis', 'In shape');
INSERT INTO personnes values(48, 'Koya', 18,'M','Japon','Jump');
INSERT INTO personnes values(49, 'Russkiya', 25,'F','Japon','Jump');
INSERT INTO personnes values(50, 'Gudrun',20,'M','France','Yggdrazil');
INSERT INTO personnes values(51, 'Swamey',31,'F','France','Yggdrazil');
INSERT INTO personnes values(52, 'Lix', 22,'F','France','Yggdrazil');
INSERT INTO personnes values(53, 'Airika',21,'F','Angleterre','Cipher');
INSERT INTO personnes values(54, 'Afton',25,'M','France','SQL');
INSERT INTO personnes values(55, 'Crouton',22,'M','France','SQL');
INSERT INTO personnes values(56, 'Shiron',34,'Espagne','Pokegang');
INSERT INTO personnes values(57, 'DraxEZ',18,'Espagne','Pokegang');
INSERT INTO personnes values(58, 'Deadlight',20,'Espagne','Pokegang');
INSERT INTO personnes values(59, 'Artemisa',40,'France','Eco Smash');
INSERT INTO personnes values(60, 'Hatsuko',34,'France','Eco Smash');
INSERT INTO personnes values(61, 'Kehba',39,'France','Eco Smash');
INSERT INTO personnes values(62, 'Menthys',30,'France','Eco Smash');
INSERT INTO personnes values(63, 'Callate',32,'Irlande','SKUIZI');
INSERT INTO personnes values(64, 'Kei',23,'Irlande','SKUIZI');
INSERT INTO personnes values(65, 'Mooon',28,'M','Suède','ArmadaTeam');
INSERT INTO personnes values(66, 'DimitryOS',29,'M','Suède','ArmadaTeam');
INSERT INTO personnes values(67, 'Relty',28,'F','Suède','ArmadaTeam');
INSERT INTO personnes values(68, 'Megumi',19,'F','Etats-Unis','Xiaomi');
INSERT INTO personnes values(69, 'Nice',18,'F','Etats-Unis','Xiaomi');
INSERT INTO personnes values(70, 'Rubby',19,'F','Etats-Unis','Xiaomi');
INSERT INTO personnes values(71, 'Shinya',34,'M','Etats-Unis','Samsung');
INSERT INTO personnes values(72, 'Feuj',35,'M','Etats-Unis','Samsung');
INSERT INTO personnes values(73, 'Steffy',32,'M','Etats-Unis','Samsung');
INSERT INTO personnes values(74, 'Snake',20,'M','Suisse','Iphone');
INSERT INTO personnes values(75, 'Trapzi',19,'M','Suisse','Iphone');
INSERT INTO personnes values(76, 'Utako',41,'M','Etats-Unis','Sony');
INSERT INTO personnes values(77, 'Elo',42,'M','Etats-Unis','Sony');
INSERT INTO personnes values(78, 'Winnie',38,'M','Iran','Microsoft');
INSERT INTO personnes values(79, 'Alphau',41,'M','Iran','Microsoft');
INSERT INTO personnes values(80, 'irony',45,'M','Iran','Microsoft');
INSERT INTO personnes values(81, 'Fundy',24,'M','Etats-Unis','Bethesda');
INSERT INTO personnes values(82, 'Sapnap',29,'F','Etats-Unis','Bethesda');
INSERT INTO personnes values(83, 'Dumzy',21,'F','Listembourg','Listembourg');
INSERT INTO personnes values(84, 'Duma',20,'F','Listembourg','Listembourg');
INSERT INTO personnes values(85, 'Squirrels',19,'M','Listembourg','Listembourg');
INSERT INTO personnes values(86, 'Xenon',18,'M','Listembourg','Listembourg');
INSERT INTO personnes values(87, 'Altirix',43,'M','Etats-Unis','Gouvernement');
INSERT INTO personnes values(88, 'Bigdodab',33,'M','Etats-Unis','Gouvernement');
INSERT INTO personnes values(89, 'Bush',27,'M','Iran','Nintendo');
INSERT INTO personnes values(90, 'Piralio',27,'F','Iran','Nintendo');
INSERT INTO personnes values(91, 'Falink',29,'F','Iran','Nintendo');
INSERT INTO personnes values(92, 'Jertzu',21,'M','France','Squeezie');
INSERT INTO personnes values(93, 'Tronberry',18,'M','France','Squeezie');
INSERT INTO personnes values(94, 'Mx',47,'M','France','SPA');
INSERT INTO personnes values(95, 'Volak',46,'M','France','SPA');
INSERT INTO personnes values(96, 'Volkzak',49,'M','France','SPA');
INSERT INTO personnes values(97, 'Zen',19,'M','Listembourg','Charal');
INSERT INTO personnes values(98, 'Bloodyvortex',25,'M','Listembourg','Charal');
INSERT INTO personnes values(99, 'Poot',34,'M','France','Sega');
INSERT INTO personnes values(100, 'Frozen',31,'M','France','Sega');
INSERT INTO personnes values(100, 'Genesis',30,'F','France','Looping');
INSERT INTO personnes values(101, 'Florian',33,'F','France','Looping');
INSERT INTO personnes values(102, 'Niemman',38,'F','Mexique','Wespeed');
INSERT INTO personnes values(103, 'Shirli',38,'M','Mexique','Wespeed');
INSERT INTO personnes values(104, 'Wilflol',39,'M','Mexique','Wespeed');
INSERT INTO personnes values(105, 'Logicman',36,'F','Brésil','Hal Laboratory Inc.');
INSERT INTO personnes values(106, 'Illumina',36,'F','Brésil','Hal Laboratory Inc.');
INSERT INTO personnes values(107, 'Brash', 36,'M','Chine','Bandai Namco');
INSERT INTO personnes values(108, 'Cryptobazeo', 35,'M','Chine','Bandai Namco');
INSERT INTO personnes values(109, 'Draken', 33,'M','Chine','Bandai Namco');
INSERT INTO personnes values(110, 'Cheesy', 34,'M','Chine','Bandai Namco');
INSERT INTO personnes values(111, 'Jaoname', 46,'M','Etats-Unis','Cartoon Network');
INSERT INTO personnes values(112, 'Loki', 45,'M','Etats-Unis','Cartoon Network');
INSERT INTO personnes values(113, 'Luiyi', 22, 'F', 'Angleterre', 'SK Gaming');
INSERT INTO personnes values(114, 'Replays', 23, 'F', 'Angleterre', 'SK Gaming');
INSERT INTO personnes values(115, 'Toga', 23, 'F', 'Angleterre', 'SK Gaming');
INSERT INTO personnes values(116, 'Yuki', 29, 'M', 'Suède', 'Tribe');
INSERT INTO personnes values(117, 'Mina', 32, 'F', 'Suède', 'Tribe');
INSERT INTO personnes values(118, 'Pigmansly', 34, 'M', 'Suède', 'Tribe');
INSERT INTO personnes values(119, 'Marinus', 37, 'M', 'France', 'Solary');
INSERT INTO personnes values(120, 'Agus', 36, 'M', 'France', 'Solary');
INSERT INTO personnes values(121, 'Anto', 25, 'M', 'France', 'Twitch');
INSERT INTO personnes values(122, 'Flukely', 31, 'F', 'France', 'Twitch');
INSERT INTO personnes values(123, 'Aizen', 30, 'F', 'France', 'Twitch');
INSERT INTO personnes values(124, 'Rizu', 26, 'M', 'France', 'Twitch');
INSERT INTO personnes values(125, 'Xel', 27, 'M', 'France', 'Twitch');
INSERT INTO personnes values(126, 'Dejavu', 21, 'F', 'Etats-Unis', 'Gabaret');
INSERT INTO personnes values(127, 'Aleria', 19, 'F', 'Etats-Unis', 'Gabaret');
INSERT INTO personnes values(128, 'Eureka', 18, 'F', 'Etats-Unis', 'Gabaret');
INSERT INTO personnes values(129, 'Unsociable', 28, 'F', 'Chine', 'Bing chilling');
INSERT INTO personnes values(130, 'Gordon', 29, 'M', 'Chine', 'Bing chilling');
INSERT INTO personnes values(131, 'Ramsey', 29, 'M', 'Chine', 'Bing chilling');
INSERT INTO personnes values(132, 'Asvex', 28, 'F', 'Etats-Unis', 'Gabaret');
INSERT INTO personnes values(133, 'Lonny', 27, 'F', 'Etats-Unis', 'Gabaret');
INSERT INTO personnes values(134, 'Wulpu', 32, 'F', 'Inde', 'Oreo');
INSERT INTO personnes values(135, 'Zurikimo', 32, 'F', 'Inde', 'Oreo');
INSERT INTO personnes values(136, 'Tayeb', 34, 'M', 'France', 'Rhinoshield');
INSERT INTO personnes values(137, 'Apeiron', 36, 'M', 'France', 'Rhinoshield');
INSERT INTO personnes values(138, 'Kat', 38, 'F', 'Etats-Unis', 'In shape');
INSERT INTO personnes values(139, 'Tibo', 32, 'M', 'Etats-Unis', 'In shape');
INSERT INTO personnes values(140, 'Tobi', 40, 'M', 'Etats-Unis', 'In shape');
INSERT INTO personnes values(141, 'Meuf', 39, 'F', 'Etats-Unis', 'In shape');
INSERT INTO personnes values(142, 'Jonne', 42, 'M', 'Etats-Unis', 'Bing chilling');
INSERT INTO personnes values(143, 'Senna', 42, 'M', 'Etats-Unis', 'Bing chilling');
INSERT INTO personnes values(144, 'Sun Tzu', 50, 'M', 'Chine', 'Bing chilling');

INSERT INTO cartes values(1,  'Destination Finale');
INSERT INTO cartes values(2,  'Champs de Bataille');
INSERT INTO cartes values(3,  'Smashville');
INSERT INTO cartes values(4,  'Secteur Z');
INSERT INTO cartes values(5,  'Route arc-en-ciel');
INSERT INTO cartes values(6,  'Temple');
INSERT INTO cartes values(7,  'Yoshi Story');
INSERT INTO cartes values(8,  'Venom');
INSERT INTO cartes values(9,  'Stade Pokemon');
INSERT INTO cartes values(10, 'Fourside');

insert into matchs values(1  , 3, 1, round(random()*9)+1, 'Bo5');
insert into matchs values(2  , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(3  , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(4  , 3, 0, round(random()*9)+1, 'Bo5');
insert into matchs values(5  , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(6  , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(7  , 3, 1, round(random()*9)+1, 'Bo5');
insert into matchs values(8  , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(9  , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(10 , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(11 , 0, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(12 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(13 , 0, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(14 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(15 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(16 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(17 , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(18 , 0, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(19 , 0, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(20 , 3, 1, round(random()*9)+1, 'Bo5');
insert into matchs values(21 , 3, 0, round(random()*9)+1, 'Bo5');
insert into matchs values(22 , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(23 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(24 , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(25 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(26 , 3, 1, round(random()*9)+1, 'Bo5');
insert into matchs values(27 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(28 , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(29 , 0, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(30 , 3, 0, round(random()*9)+1, 'Bo5');
insert into matchs values(31 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(32 , 3, 1, round(random()*9)+1, 'Bo5');
insert into matchs values(33 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(34 , 3, 0, round(random()*9)+1, 'Bo5');
insert into matchs values(35 , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(36 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(37 , 0, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(38 , 2, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(39 , 0, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(40 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(41 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(42 , 3, 0, round(random()*9)+1, 'Bo5');
insert into matchs values(43 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(44 , 3, 1, round(random()*9)+1, 'Bo5');
insert into matchs values(45 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(46 , 3, 0, round(random()*9)+1, 'Bo5');
insert into matchs values(47 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(48 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(49 , 3, 2, round(random()*9)+1, 'Bo5');
insert into matchs values(50 , 3, 1, round(random()*9)+1, 'Bo5');
insert into matchs values(51 , 1, 3, round(random()*9)+1, 'Bo5');
insert into matchs values(52 , 3, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(53 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(54 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(55 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(56 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(57 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(58 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(59 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(60 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(61 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(62 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(63 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(64 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(65 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(66 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(67 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(68 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(69 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(70 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(71 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(72 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(73 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(74 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(75 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(76 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(77 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(78 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(79 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(80 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(81 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(82 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(83 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(84 , 2, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(85 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(86 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(87 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(88 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(89 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(90 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(91 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(92 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(93 , 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(94 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(95 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(96 , 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(97 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(98 , 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(99 , 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(100, 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(101, 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(102, 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(103, 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(104, 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(105, 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(106, 2, 0, round(random()*9)+1, 'Bo3');
insert into matchs values(107, 1, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(108, 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(109, 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(110, 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(111, 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(112, 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(113, 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(114, 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(115, 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(116, 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(117, 2, 1, round(random()*9)+1, 'Bo3');
insert into matchs values(118, 0, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(119, 1, 2, round(random()*9)+1, 'Bo3');
insert into matchs values(120, 2, 1, round(random()*9)+1, 'Bo3');

insert into jouer_dans values(1  , 1  , 1 , 74);
insert into jouer_dans values(2  , 1  , 5 , 24);
insert into jouer_dans values(3  , 2  , 4 , 50);
insert into jouer_dans values(4  , 2  , 30, 54);
insert into jouer_dans values(5  , 3  , 24, 54);
insert into jouer_dans values(6  , 3  , 25, 74);
insert into jouer_dans values(7  , 4  , 2 , 20);
insert into jouer_dans values(8  , 4  , 6 , 82);
insert into jouer_dans values(9  , 5  , 3 , 86);
insert into jouer_dans values(10 , 5  , 121 , 85);
insert into jouer_dans values(11 , 6  , 14 , 82);
insert into jouer_dans values(12 , 6  , 18 , 83);
insert into jouer_dans values(13 , 7  , 28 , 82);
insert into jouer_dans values(14 , 7  , 27 , 47);
insert into jouer_dans values(15 , 8  , 31 , 45);
insert into jouer_dans values(16 , 8  , 25 , 42);
insert into jouer_dans values(17 , 9  , 17 , 74);
insert into jouer_dans values(18 , 9  , 37 , 73);
insert into jouer_dans values(19 , 10 , 47 , 23);
insert into jouer_dans values(20 , 10 , 57 , 22);