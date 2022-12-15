--- CREATE DATABASE ---
--- CREATE DATABASE smash; ---

--- CREATE TABLE ---
CREATE TABLE personne(
   id_personne INT,
   pseudo VARCHAR(50),
   age INT,
   sexe CHAR(1),
   pays VARCHAR(50),
   sponsor VARCHAR(100),
   PRIMARY KEY(id_personne)
);

CREATE TABLE classement(
   rang INT,
   victoires INT,
   ratio REAL,
   id_personne INT NOT NULL,
   PRIMARY KEY(rang),
   FOREIGN KEY(id_personne) REFERENCES personne(id_personne)
);

CREATE TABLE carte(
   id_carte INT,
   nom VARCHAR(100),
   PRIMARY KEY(id_carte)
);

CREATE TABLE franchise(
   id_franchise INT,
   nom VARCHAR(100),
   PRIMARY KEY(id_franchise)
);

CREATE TABLE historique(
   id_commande INT,
   id_changement VARCHAR(50),
   instruction VARCHAR(50),
   table_concernee VARCHAR(50),
   date_sauvegardee DATE,
   PRIMARY KEY(id_commande)
);

CREATE TABLE tierlist(
   id_rang INT,
   id_perso INT,
   nom VARCHAR(50),
   ratio REAL,
   nb_victoire REAL,
   nb_defaite REAL,
   nb_combat REAL,
   PRIMARY KEY(id_rang)
);

CREATE TABLE personnage(
   id_perso INT,
   nom VARCHAR(50),
   id_franchise INT NOT NULL,
   PRIMARY KEY(id_perso),
   FOREIGN KEY(id_franchise) REFERENCES franchise(id_franchise)
);

CREATE TABLE combat(
   id_combat INT,
   id_carte INT,
   score_J1 INT,
   score_J2 INT,
   format VARCHAR(50),
   PRIMARY KEY(id_combat),
   FOREIGN KEY(id_carte) REFERENCES carte(id_carte)
);

CREATE TABLE jouer_dans(
   id_joueur INT,
   id_combat INT NOT NULL,
   id_personne INT NOT NULL,
   id_perso INT NOT NULL,
   PRIMARY KEY(id_joueur),
   FOREIGN KEY(id_combat) REFERENCES combat(id_combat),
   FOREIGN KEY(id_perso) REFERENCES personnage(id_perso),
   FOREIGN KEY(id_personne) REFERENCES personne(id_personne)
);