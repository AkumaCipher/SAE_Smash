--- BASE ET TABLES --- 
CREATE DATABASE smash;

CREATE TABLE Personnes(
   id_personne INT,
   nom VARCHAR(50),
   prenom VARCHAR(50),
   age INT,
   sexe CHAR(1),
   datenaissance DATE,
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
   id_perso INT NOT NULL,
   id_personne INT NOT NULL,
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