CREATE TABLE Personnes(
   id_personne INT,
   nom VARCHAR(50),
   prenom VARCHAR(50),
   contact VARCHAR(50),
   age INT,
   sexe CHAR(1),
   datenaissance DATE,
   pays VARCHAR(50),
   sponsor VARCHAR(100),
   PRIMARY KEY(id_personne)
);

CREATE TABLE Classement(
   rang INT,
   wins INT,
   ratios DOUBLE,
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