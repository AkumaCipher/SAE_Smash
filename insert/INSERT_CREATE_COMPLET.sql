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
   id_rang INT,
   id_personne INT,
   pseudo VARCHAR(50),
   ratio REAL,
   nb_victoire REAL,
   nb_defaite REAL,
   nb_combat REAL,
   PRIMARY KEY(id_rang)
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
   id_franchise INT,
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

create or replace function manuel_stats_joueurs()
returns void as $$

/*
    Cette fonction devait être une table à la base.
    Cependant, la table ne contenant qu'une ligne, nous avons décidé de la transformer en fonction.
    En l'éxecutant, vous obtiendrez donc un tas d'informations au sujet de notre base de joueurs.
    (nb_joueur, nb_joueur/pays, nb garçons/filles)
*/

declare
    nb_joueur real;
    nb_gar real;
    nb_fil real;
    cur refcursor;
    p varchar;
    val integer;
    taux_gar real;
    taux_fil real;
    pourcentage varchar(1) := '%';

begin
    select into nb_fil count(sexe) from personne where sexe='F';
    select into nb_gar count(sexe) from personne where sexe='M';
    select into nb_joueur count(id_personne) from personne;
    open cur for select distinct(personne.pays) from personne; 
    loop
    fetch cur into p;
    exit when not found;
        select into val count(id_personne) from personne where pays=p;
        raise notice '% joueurs provenant du pays : %.', val, p;
    end loop;
    close cur;

    taux_gar = (nb_gar/nb_joueur)*100;
    taux_fil = (nb_fil/nb_joueur)*100;
    raise notice 'Joueurs enregistrés : % (100 %)', nb_joueur, pourcentage;
    raise notice 'Filles enregistrées : % (% %)', nb_fil, taux_fil, pourcentage;
    raise notice 'Garçons enregistrés : % (% %)', nb_gar, taux_gar, pourcentage;
end;
$$ language plpgsql;
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


create or replace function manuel_stats_cartes()
returns void as $$

/*
    Cette fonction permet de savoir de taux d'utilisation de chaque carte disponible dans notre structure.
*/

declare
    nb_combat real;
    cur cursor for select id_carte from combat;
    val real;
    c1 real := 0; c2 real := 0; c3 real := 0; c4 real := 0; c5 real := 0; c6 real := 0; c7 real := 0; c8 real := 0; c9 real := 0; c10 real := 0;
    pourcentage varchar(1) := '%';

begin
    select into nb_combat count(id_combat) from combat;

    open cur;
    loop
    fetch cur into val;
    exit when not found;
        if(val=1) then c1 := c1 + 1; end if;
        if(val=2) then c2 := c2 + 1; end if;
        if(val=3) then c3 := c3 + 1; end if;
        if(val=4) then c4 := c4 + 1; end if;
        if(val=5) then c5 := c5 + 1; end if;
        if(val=6) then c6 := c6 + 1; end if;
        if(val=7) then c7 := c7 + 1; end if;
        if(val=8) then c8 := c8 + 1; end if;
        if(val=9) then c9 := c9 + 1; end if;
        if(val=10) then c10 := c10 + 1; end if;
    end loop;

    c1 := (c1/nb_combat)*100;
    c2 := (c2/nb_combat)*100;
    c3 := (c3/nb_combat)*100;
    c4 := (c4/nb_combat)*100;
    c5 := (c5/nb_combat)*100;
    c6 := (c6/nb_combat)*100;
    c7 := (c7/nb_combat)*100;
    c8 := (c8/nb_combat)*100;
    c9 := (c9/nb_combat)*100;
    c10 := (c10/nb_combat)*100;

    raise notice 'Carte n°1 : % % des combats.', c1, pourcentage;
    raise notice 'Carte n°3 : % % des combats.', c2, pourcentage;
    raise notice 'Carte n°3 : % % des combats.', c3, pourcentage;
    raise notice 'Carte n°4 : % % des combats.', c4, pourcentage;
    raise notice 'Carte n°5 : % % des combats.', c5, pourcentage;
    raise notice 'Carte n°6 : % % des combats.', c6, pourcentage;
    raise notice 'Carte n°7 : % % des combats.', c7, pourcentage;
    raise notice 'Carte n°8 : % % des combats.', c8, pourcentage;
    raise notice 'Carte n°9 : % % des combats.', c9, pourcentage;
    raise notice 'Carte n°10 : % % des combats.', c10, pourcentage;
end;
$$ language plpgsql;
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

--- INSERTION TIERLIST ---
create or replace function insert_tierlist()
returns trigger as $$

/* 
    Le but de cette fonction est de remplir la table tierlist en même temps que la table personnage.
    Inutile de répéter les insert deux fois, c'est pourquoi cette fonction existe, elle est plus "propre" à nos yeux.
    Cela va de soi, si on souhaite retirer un personnage de la table personnage, il se retire de lui-même de la table tierlist.
*/

declare
    id integer;

begin
    select into id max((id_rang)+1) from tierlist;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then
            insert into tierlist values(id, new.id_perso, new.nom, 0, 0, 0, 0);
            return new;
    end if;

    if(TG_OP='DELETE')
        then
            delete from tierlist where id_perso = old.id_perso;
            return old;
    end if;
end;
$$ language plpgsql;

create trigger insert
after insert or delete on personnage
for each row
execute procedure insert_tierlist();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- TRI DE LA TIERLIST ---
create or replace function tri_tierlist()
returns void as $$

/*
    Cette fonction sera utilisée dans un trigger par la suite, elle sert à trier la table tierlist.
    Le tri se fait par rapport à la clé primaire id_rang.
    Cette clé représente la place du personnage par rapport aux autres, id_rang = 1 est donc le personnage le plus perfomant et viable.
    Les personnages sont triés en fonction de leur ratio de victoire, plus le ratio est proche de 100, plus le personnage est bien classé.
*/

declare
    nv_place integer := 0;
    cur refcursor; 
    val integer;
    r integer;
    nb_place integer := 0;
    nb_place_debut integer := 0;
    i integer := 0;

begin
    select into nb_place_debut max(id_rang) from tierlist;
    nb_place := nb_place_debut;
    loop
    exit when i=nb_place_debut;
        nb_place := nb_place + 1;
        i := i + 1;
        update tierlist set id_rang = nb_place where id_rang = i; 
    end loop;

    select into nb_place count(id_rang) from tierlist;
    i := 0;

    open cur for select id_rang, ratio from tierlist order by ratio desc;
    loop
        fetch cur into r, val;
        exit when not found;
     
        i := i + 1;
        nv_place := nv_place + 1;
        update tierlist set id_rang = nv_place where id_rang = r;
        
    end loop;
    close cur; 
end;
$$ language plpgsql;
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- INCREMENTATION STATS DE COMBAT ---
create or replace function stats_tierlist()
returns trigger as $$

/*
    Cette fonction va utiliser la fonction ci-dessus : tri_tierlist.
    Elle a pour but d'incrémenter les différentes colonnes concernant les combats de la table tierlist.
    -> nb_combat, nb_victoire, nb_defaite, et ratio.
*/

declare
    perso integer;
    nb_c integer;

    joueur1 integer;
    joueur1_p integer;
    sco_j1 integer;

    joueur2 integer;
    joueur2_p integer;
    sco_j2 integer;

    nb_joueur integer;

    winrate real;

begin
    if(TG_OP='INSERT')
        then

            --- stockage du score de chaque joueur
            select into sco_j1 score_j1 from combat where id_combat = new.id_combat;
            select into sco_j2 score_j2 from combat where id_combat = new.id_combat;

            --- ajout du nombre de combat gagnés et perdus pour chaque personnage
            --- SEULEMENT quand un match comporte bien 2 joueurs
            select into nb_joueur count(*) from jouer_dans where id_combat = new.id_combat;
            if(nb_joueur=2)
            then

                --- j1
                select into joueur1 id_joueur from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur limit 1;

                select into joueur1_p id_perso from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur limit 1;

                update tierlist set nb_victoire = nb_victoire + sco_j1 where id_perso = joueur1_p;
                update tierlist set nb_defaite = nb_defaite + sco_j2 where id_perso = joueur1_p;
                update tierlist set nb_combat = nb_combat + sco_j1 where id_perso=joueur1_p;
                update tierlist set nb_combat = nb_combat + sco_j2 where id_perso=joueur1_p;

                select into winrate nb_victoire/nb_combat*100 from tierlist where nb_combat > 0 and id_perso=joueur1_p;
                update tierlist set ratio = winrate where id_perso = joueur1_p;

                --- j2
                select into joueur2 id_joueur from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur desc limit 1;

                select into joueur2_p id_perso from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur desc limit 1;

                update tierlist set nb_victoire = nb_victoire + sco_j2 where id_perso = joueur2_p;
                update tierlist set nb_defaite = nb_defaite + sco_j1 where id_perso = joueur2_p;
                update tierlist set nb_combat = nb_combat + sco_j1 where id_perso=joueur2_p;
                update tierlist set nb_combat = nb_combat + sco_j2 where id_perso=joueur2_p;

                select into winrate nb_victoire/nb_combat*100 from tierlist where nb_combat > 0 and id_perso=joueur2_p;
                update tierlist set ratio = winrate where id_perso = joueur2_p;
            end if;
            perform tri_tierlist();
            return new;
    end if;
end;
$$language plpgsql;

create trigger stats
after insert on jouer_dans
for each row
execute procedure stats_tierlist();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

--- INSERTION CLASSEMENT ---
create or replace function insert_classement()
returns trigger as $$

<<<<<<< Updated upstream
/* 
    Le but de cette fonction est de remplir la table classement en même temps que la table personne.
    Inutile de répéter les insert deux fois, c'est pourquoi cette fonction existe, elle est plus "propre" à nos yeux.
    Cela va de soi, si on souhaite retirer une personne de la table personne, elle se retire d'elle-même de la table classement.
*/
=======
declare
    id integer;

begin
    select into id max((id_rang)+1) from classement;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then
            insert into classement values(id, new.id_personne, new.pseudo, 0, 0, 0, 0);
            return new;
    end if;

    if(TG_OP='DELETE')
        then
            delete from classement where id_personne = old.id_personne;
            return old;
    end if;
end;
$$ language plpgsql;

create trigger insert2
after insert or delete on personne
for each row
execute procedure insert_classement();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- INSERTION CLASSEMENT ---
create or replace function insert_classement()
returns trigger as $$
>>>>>>> Stashed changes

declare
    id integer;

begin
    select into id max((id_rang)+1) from classement;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then
            insert into classement values(id, new.id_personne, new.pseudo, 0, 0, 0, 0);
            return new;
    end if;

    if(TG_OP='DELETE')
        then
            delete from classement where id_personne = old.id_personne;
            return old;
    end if;
end;
$$ language plpgsql;

create trigger insert2
after insert or delete on personne
for each row
execute procedure insert_classement();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- TRI DU CLASSEMENT ---
create or replace function tri_classement()
returns void as $$

/*
    Cette fonction sera utilisée dans un trigger par la suite, elle sert à trier la table classement.
    Le tri se fait par rapport à la clé primaire id_rang.
    Cette clé représente la place de la personne par rapport aux autres, id_rang = 1 est donc la personne la plus perfomante.
    Les personnnes sont triées en fonction de leur ratio de victoire, plus le ratio est proche de 100, plus la personne est bien classée.
*/

declare
    nv_place integer := 0;
    cur refcursor; 
    val integer;
    r integer;
    nb_place integer := 0;
    nb_place_debut integer := 0;
    i integer := 0;

begin
    select into nb_place_debut max(id_rang) from classement;
    nb_place := nb_place_debut;
    loop
    exit when i=nb_place_debut;
        nb_place := nb_place + 1;
        i := i + 1;
        update classement set id_rang = nb_place where id_rang = i; 
    end loop;

    select into nb_place count(id_rang) from classement;
    i := 0;

    open cur for select id_rang, ratio from classement order by ratio desc;
    loop
        fetch cur into r, val;
        exit when not found;
     
        i := i + 1;
        nv_place := nv_place + 1;
        update classement set id_rang = nv_place where id_rang = r;
        
    end loop;
    close cur; 
end;
$$ language plpgsql;
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- INCREMENTATION STATS DE COMBAT ---
create or replace function stats_classement()
returns trigger as $$

/*
    Cette fonction va utiliser la fonction ci-dessus : tri_classement.
    Elle a pour but d'incrémenter les différentes colonnes concernant les combats de la table classement.
    -> nb_combat, nb_victoire, nb_defaite, et ratio.
*/

declare
    perso integer;
    nb_c integer;

    joueur1 integer;
    joueur1_p integer;
    sco_j1 integer;

    joueur2 integer;
    joueur2_p integer;
    sco_j2 integer;

    nb_joueur integer;

    winrate real;

begin
    if(TG_OP='INSERT')
        then

            --- stockage du score de chaque joueur
            select into sco_j1 score_j1 from combat where id_combat = new.id_combat;
            select into sco_j2 score_j2 from combat where id_combat = new.id_combat;

            --- ajout du nombre de combat gagnés et perdus pour chaque personnage
            --- SEULEMENT quand un match comporte bien 2 joueurs
            select into nb_joueur count(*) from jouer_dans where id_combat = new.id_combat;
            if(nb_joueur=2)
            then

                --- j1
                select into joueur1 id_joueur from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur limit 1;

                select into joueur1_p id_personne from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur limit 1;

                update classement set nb_victoire = nb_victoire + sco_j1 where id_personne = joueur1_p;
                update classement set nb_defaite = nb_defaite + sco_j2 where id_personne = joueur1_p;
                update classement set nb_combat = nb_combat + sco_j1 where id_personne = joueur1_p;
                update classement set nb_combat = nb_combat + sco_j2 where id_personne = joueur1_p;

                select into winrate nb_victoire/nb_combat*100 from classement where nb_combat > 0 and id_personne=joueur1_p;
                update classement set ratio = winrate where id_personne = joueur1_p;

                --- j2
                select into joueur2 id_joueur from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur desc limit 1;

                select into joueur2_p id_personne from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur desc limit 1;

                update classement set nb_victoire = nb_victoire + sco_j2 where id_personne = joueur2_p;
                update classement set nb_defaite = nb_defaite + sco_j1 where id_personne = joueur2_p;
                update classement set nb_combat = nb_combat + sco_j1 where id_personne=joueur2_p;
                update classement set nb_combat = nb_combat + sco_j2 where id_personne=joueur2_p;

                select into winrate nb_victoire/nb_combat*100 from classement where nb_combat > 0 and id_personne=joueur2_p;
                update classement set ratio = winrate where id_personne = joueur2_p;
            end if;
            perform tri_classement();
            return new;
    end if;
end;
$$language plpgsql;

create trigger stats2
after insert on jouer_dans
for each row
execute procedure stats_classement();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

--- INSERTIONS ---
INSERT INTO franchise values(1,  'Super Mario'                  );
INSERT INTO franchise values(2,  'Pokemon'                      );
INSERT INTO franchise values(3,  'Zelda'                        );
INSERT INTO franchise values(4,  'Fire Emblem'                  );
INSERT INTO franchise values(5,  'Metroid'                      );
INSERT INTO franchise values(6,  'Kirby'                        );
INSERT INTO franchise values(7,  'Star Fox'                     );
INSERT INTO franchise values(8,  'Kid Icarus'                   );
INSERT INTO franchise values(9,  'Donkey Kong'                  );
INSERT INTO franchise values(10, 'Earthbound'                   );
INSERT INTO franchise values(11, 'Yoshi'                        );
INSERT INTO franchise values(12, 'F-Zero'                       );
INSERT INTO franchise values(13, 'Ice Climber'                  );
INSERT INTO franchise values(14, 'Game & Watch'                 );
INSERT INTO franchise values(15, 'WarioWare'                    );
INSERT INTO franchise values(16, 'Metal Gear'                   );
INSERT INTO franchise values(17, 'Sonic the Hedgehog'           );
INSERT INTO franchise values(18, 'Pikmin'                       );
INSERT INTO franchise values(19, 'Nintendo Entertainment System');
INSERT INTO franchise values(20, 'Animal Crossing'              );
INSERT INTO franchise values(21, 'Megaman'                      );
INSERT INTO franchise values(22, 'Wii Fit'                      );
INSERT INTO franchise values(23, 'Punch-Out'                    );
INSERT INTO franchise values(24, 'Mii'                          );
INSERT INTO franchise values(25, 'Pac-Man'                      );
INSERT INTO franchise values(26, 'Xenoblade'                    );
INSERT INTO franchise values(27, 'Duck Hunt'                    );
INSERT INTO franchise values(28, 'Street Fighter'               );
INSERT INTO franchise values(29, 'Final Fantasy'                );
INSERT INTO franchise values(30, 'Bayonetta'                    );
INSERT INTO franchise values(31, 'Splatoon'                     );
INSERT INTO franchise values(32, 'Castlevania'                  );
INSERT INTO franchise values(33, 'Persona'                      );
INSERT INTO franchise values(34, 'Dragon Quest'                 );
INSERT INTO franchise values(35, 'Banjo-Kazooie'                );
INSERT INTO franchise values(36, 'Fatal Fury'                   );
INSERT INTO franchise values(37, 'Arms'                         );
INSERT INTO franchise values(38, 'Minecraft'                    );
INSERT INTO franchise values(39, 'Tekken'                       );
INSERT INTO franchise values(40, 'Kingdom Hearts'               );

--- INSERTIONS ---
INSERT INTO carte values(1 , 'Destination Finale');
INSERT INTO carte values(2 , 'Champs de Bataille');
INSERT INTO carte values(3 , 'Smashville'        );
INSERT INTO carte values(4 , 'Secteur Z'         );
INSERT INTO carte values(5 , 'Route arc-en-ciel' );
INSERT INTO carte values(6 , 'Temple'            );
INSERT INTO carte values(7 , 'Yoshi Story'       );
INSERT INTO carte values(8 , 'Venom'             );
INSERT INTO carte values(9 , 'Stade Pokemon'     );
INSERT INTO carte values(10, 'Fourside'          );

--- INSERTIONS ---
INSERT INTO personnage values(1 , 'Mario'           , 1 );
INSERT INTO personnage values(2 , 'Donkey Kong'     , 9 );
INSERT INTO personnage values(3 , 'Link'            , 3 );
INSERT INTO personnage values(4 , 'Samus'           , 5 );
INSERT INTO personnage values(5 , 'Dark Samus'      , 5 );
INSERT INTO personnage values(6 , 'Yoshi'           , 11);
INSERT INTO personnage values(7 , 'Kirby'           , 6 );
INSERT INTO personnage values(8 , 'Fox'             , 7 ); 
INSERT INTO personnage values(9 , 'Pikachu'         , 2 );
INSERT INTO personnage values(10, 'Luigi'           , 1 );
INSERT INTO personnage values(11, 'Ness'            , 10);
INSERT INTO personnage values(12, 'Captain Falcon'  , 12);
INSERT INTO personnage values(13, 'Jigglypuff'      , 2 );
INSERT INTO personnage values(14, 'Peach'           , 1 );
INSERT INTO personnage values(15, 'Daisy'           , 1 );
INSERT INTO personnage values(16, 'Bowser'          , 1 );
INSERT INTO personnage values(17, 'Ice Climbers'    , 13);
INSERT INTO personnage values(18, 'Sheik'           , 3 );
INSERT INTO personnage values(19, 'Zelda'           , 3 );
INSERT INTO personnage values(20, 'Dr. Mario'       , 1 );
INSERT INTO personnage values(21, 'Pichu'           , 2 );
INSERT INTO personnage values(22, 'Falco'           , 7 );
INSERT INTO personnage values(23, 'Marth'           , 4 );
INSERT INTO personnage values(24, 'Lucina'          , 4 );
INSERT INTO personnage values(25, 'Young Link'      , 3 );
INSERT INTO personnage values(26, 'Ganondorf'       , 3 );
INSERT INTO personnage values(27, 'Mewtwo'          , 2 );
INSERT INTO personnage values(28, 'Roy'             , 4 );
INSERT INTO personnage values(29, 'Chrom'           , 4 );
INSERT INTO personnage values(30, 'Mr. Game & Watch', 14);
INSERT INTO personnage values(31, 'Meta Knight'     , 6 );
INSERT INTO personnage values(32, 'Pit'             , 8 );
INSERT INTO personnage values(33, 'Dark Pit'        , 8 );
INSERT INTO personnage values(34, 'Zero Suit Samus' , 5 );
INSERT INTO personnage values(35, 'Wario'           , 15);
INSERT INTO personnage values(36, 'Snake'           , 16);
INSERT INTO personnage values(37, 'Ike'             , 4 );
INSERT INTO personnage values(38, 'Pokemon Trainer' , 2 );
INSERT INTO personnage values(39, 'Diddy Kong'      , 9 );
INSERT INTO personnage values(40, 'Lucas'           , 10);
INSERT INTO personnage values(41, 'Sonic'           , 17);
INSERT INTO personnage values(42, 'King Dedede'     , 6 );
INSERT INTO personnage values(43, 'Olimar'          , 18);
INSERT INTO personnage values(44, 'Lucario'         , 2 );
INSERT INTO personnage values(45, 'R.O.B'           , 19);
INSERT INTO personnage values(46, 'Toon Link'       , 3 );
INSERT INTO personnage values(47, 'Wolf'            , 7 );
INSERT INTO personnage values(48, 'Villager'        , 20);
INSERT INTO personnage values(49, 'Mega Man'        , 21);
INSERT INTO personnage values(50, 'Wii Fit Trainer' , 22);
INSERT INTO personnage values(51, 'Rosalina & Luma' , 1 );
INSERT INTO personnage values(52, 'Little Mac'      , 23);
INSERT INTO personnage values(53, 'Greninja'        , 2 );
INSERT INTO personnage values(54, 'Mii Brawler'     , 24);
INSERT INTO personnage values(55, 'Mii Swordfighter', 24);
INSERT INTO personnage values(56, 'Mii Gunner'      , 24);
INSERT INTO personnage values(57, 'Palutena'        , 8 );
INSERT INTO personnage values(58, 'Pac-Man'         , 25);
INSERT INTO personnage values(59, 'Robin'           , 4 );
INSERT INTO personnage values(60, 'Shulk'           , 26);
INSERT INTO personnage values(61, 'Bowser Jr.'      , 1 );
INSERT INTO personnage values(62, 'Duck Hunt'       , 27);
INSERT INTO personnage values(63, 'Ryu'             , 28);
INSERT INTO personnage values(64, 'Ken'             , 28);
INSERT INTO personnage values(65, 'Cloud'           , 29);
INSERT INTO personnage values(66, 'Corrin'          , 4 );
INSERT INTO personnage values(67, 'Bayonetta'       , 30);
INSERT INTO personnage values(68, 'Inkling'         , 31);
INSERT INTO personnage values(69, 'Ridley'          , 5 );
INSERT INTO personnage values(70, 'Simon'           , 32);
INSERT INTO personnage values(71, 'Richter'         , 32);
INSERT INTO personnage values(72, 'King K. Rool'    , 9 );
INSERT INTO personnage values(73, 'Isabelle'        , 20);
INSERT INTO personnage values(74, 'Incineroar'      , 2 );
INSERT INTO personnage values(75, 'Piranha Plant'   , 1 );
INSERT INTO personnage values(76, 'Joker'           , 33);
INSERT INTO personnage values(77, 'Hero'            , 34);
INSERT INTO personnage values(78, 'Banjo & Kazooie' , 35);
INSERT INTO personnage values(79, 'Terry'           , 36);
INSERT INTO personnage values(80, 'Byleth'          , 4 );
INSERT INTO personnage values(81, 'Min Min'         , 37);
INSERT INTO personnage values(82, 'Steve'           , 38);
INSERT INTO personnage values(83, 'Sephiroth'       , 29);
INSERT INTO personnage values(84, 'Pyra/Mythra'     , 26);
INSERT INTO personnage values(85, 'Kazuya'          , 39);
INSERT INTO personnage values(86, 'Sora'            , 40);

--- INSERTIONS ---
INSERT INTO personne values(1  , 'MKleo'         , 21, 'M', 'Mexique'    , 'T1'                 );
INSERT INTO personne values(2  , 'HungryBox'     , 29, 'F', 'Etats-Unis' , 'T1'                 );
INSERT INTO personne values(3  , 'Capitaine'     , 25, 'M', 'France'     , 'IUT'                );
INSERT INTO personne values(4  , 'Pacou'         , 42, 'F', 'France'     , 'IUT'                );
INSERT INTO personne values(5  , 'Gudrun'        , 20, 'M', 'France'     , 'Yggdrazil'          );
INSERT INTO personne values(6  , 'Akuma'         , 20, 'F', 'Angleterre' , 'Cipher'             );
INSERT INTO personne values(7  , 'Dany'          , 26, 'M', 'France'     , 'SQL'                );
INSERT INTO personne values(8  , 'Moqmoq'        , 14, 'M', 'Espagne'    , 'Pokegang'           );
INSERT INTO personne values(9  , 'Akvir'         , 62, 'F', 'France'     , 'Eco Smash'          );
INSERT INTO personne values(10 , 'Pherax'        , 24, 'F', 'Irlande'    , 'SKUIZI'             );
INSERT INTO personne values(11 , 'Maximum Propum', 24, 'M', 'Suède'      , 'ArmadaTeam'         );
INSERT INTO personne values(12 , 'Moquouss'      , 18, 'M', 'France'     , 'Yggdrazil'          );
INSERT INTO personne values(13 , 'Joyca'         , 26, 'M', 'Ecosse'     , 'Rhinoshield'        );
INSERT INTO personne values(14 , 'Glutonny'      , 27, 'M', 'France'     , 'WaaaaTeam'          );
INSERT INTO personne values(15 , 'Pataploup'     , 19, 'M', 'Etats-Unis' , 'Xiaomi'             );
INSERT INTO personne values(16 , 'Jeff'          , 44, 'M', 'Etats-Unis' , 'Samsung'            );
INSERT INTO personne values(17 , 'Armada'        , 26, 'M', 'Suisse'     , 'Iphone'             );
INSERT INTO personne values(18 , 'Mango'         , 34, 'M', 'Etats-Unis' , 'Sony'               );
INSERT INTO personne values(19 , 'MangoBanana'   , 35, 'F', 'Etats-Unis' , 'Sony'               );
INSERT INTO personne values(20 , 'Mew2King'      , 28, 'F', 'Iran'       , 'Microsoft'          );
INSERT INTO personne values(21 , 'JeanPeuPlu'    , 26, 'M', 'Iran'       , 'Microsoft'          );
INSERT INTO personne values(22 , 'Leffen'        , 24, 'F', 'Etats-Unis' , 'Bethesda'           );
INSERT INTO personne values(23 , 'Tayly'         , 28, 'M', 'Listembourg', 'Listembourg'        );
INSERT INTO personne values(24 , 'Dusty'         , 23, 'M', 'Etats-Unis' , 'Gouvernement'       );
INSERT INTO personne values(25 , 'Craft'         , 28, 'M', 'Iran'       , 'Nintendo'           );
INSERT INTO personne values(26 , 'Skuizi'        , 28, 'M', 'France'     , 'Squeezie'           );
INSERT INTO personne values(27 , 'Kiyu'          , 24, 'M', 'France'     , 'SPA'                );
INSERT INTO personne values(28 , 'Paulok'        , 14, 'M', 'Listembourg', 'Charal'             );
INSERT INTO personne values(29 , 'Laupok'        , 29, 'M', 'France'     , 'Sega'               );
INSERT INTO personne values(30 , 'Socko'         , 19, 'M', 'Listembourg', 'Samsung'            );
INSERT INTO personne values(31 , 'Kennedy'       , 28, 'M', 'Etats-Unis' , 'Gouvernement'       );
INSERT INTO personne values(32 , 'Florian'       , 20, 'F', 'France'     , 'Looping'            );
INSERT INTO personne values(33 , 'ArmadaJr'      , 24, 'F', 'Suède'      , 'Armada'             );
INSERT INTO personne values(34 , 'FilthyBox'     , 44, 'F', 'Mexique'    , 'Wespeed'            );
INSERT INTO personne values(35 , 'Pika1Queen'    , 21, 'F', 'Brésil'     , 'Hal Laboratory Inc.');
INSERT INTO personne values(36 , 'Appol'         , 25, 'M', 'Chine'      , 'Bandai Namco'       );
INSERT INTO personne values(37 , 'Son Jr'        , 35, 'M', 'Japon'      , 'Jump'               );
INSERT INTO personne values(38 , 'Rick'          , 42, 'M', 'Etats-Unis' , 'Cartoon Network'    );
INSERT INTO personne values(39 , 'Moonlight'     , 20, 'F', 'Angleterre' , 'SK Gaming'          );
INSERT INTO personne values(40 , 'Yde'           , 23, 'M', 'Suède'      , 'Tribe'              );
INSERT INTO personne values(41 , 'Fishou'        , 33, 'M', 'France'     , 'Solary'             );
INSERT INTO personne values(42 , 'Odemian'       , 27, 'M', 'France'     , 'Twitch'             );
INSERT INTO personne values(43 , 'Amko'          , 18, 'F', 'Etats-Unis' , 'Gabaret'            );
INSERT INTO personne values(44 , 'Yurika'        , 22, 'F', 'Inde'       , 'Oreo'               );
INSERT INTO personne values(45 , 'Lolodrog'      , 23, 'M', 'France'     , 'Rhinoshield'        );
INSERT INTO personne values(46 , 'ChianRelou'    , 34, 'M', 'France'     , 'Rhinoshield'        );
INSERT INTO personne values(47 , 'Mily'          , 28, 'F', 'Etats-Unis' , 'In shape'           );
INSERT INTO personne values(48 , 'Koya'          , 18, 'M', 'Japon'      , 'Jump'               );
INSERT INTO personne values(49 , 'Russkiya'      , 25, 'F', 'Japon'      , 'Jump'               );
INSERT INTO personne values(50 , 'Gudrun'        , 20, 'M', 'France'     , 'Yggdrazil'          );
INSERT INTO personne values(51 , 'Swamey'        , 31, 'F', 'France'     , 'Yggdrazil'          );
INSERT INTO personne values(52 , 'Lix'           , 22, 'F', 'France'     , 'Yggdrazil'          );
INSERT INTO personne values(53 , 'Airika'        , 21, 'F', 'Angleterre' , 'Cipher'             );
INSERT INTO personne values(54 , 'Afton'         , 25, 'M', 'France'     , 'SQL'                );
INSERT INTO personne values(55 , 'Crouton'       , 22, 'M', 'France'     , 'SQL'                );
INSERT INTO personne values(56 , 'Shiron'        , 34, 'F', 'Espagne'    , 'Pokegang'           );
INSERT INTO personne values(57 , 'DraxEZ'        , 18, 'F', 'Espagne'    , 'Pokegang'           );
INSERT INTO personne values(58 , 'Deadlight'     , 20, 'M', 'Espagne'    , 'Pokegang'           );
INSERT INTO personne values(59 , 'Artemisa'      , 40, 'F', 'France'     , 'Eco Smash'          );
INSERT INTO personne values(60 , 'Hatsuko'       , 34, 'M', 'France'     , 'Eco Smash'          );
INSERT INTO personne values(61 , 'Kehba'         , 39, 'F', 'France'     , 'Eco Smash'          );
INSERT INTO personne values(62 , 'Menthys'       , 30, 'M', 'France'     , 'Eco Smash'          );
INSERT INTO personne values(63 , 'Callate'       , 32, 'F', 'Irlande'    , 'SKUIZI'             );
INSERT INTO personne values(64 , 'Kei'           , 23, 'F', 'Irlande'    , 'SKUIZI'             );
INSERT INTO personne values(65 , 'Mooon'         , 28, 'M', 'Suède'      , 'ArmadaTeam'         );
INSERT INTO personne values(66 , 'DimitryOS'     , 29, 'M', 'Suède'      , 'ArmadaTeam'         );
INSERT INTO personne values(67 , 'Relty'         , 28, 'F', 'Suède'      , 'ArmadaTeam'         );
INSERT INTO personne values(68 , 'Megumi'        , 19, 'F', 'Etats-Unis' , 'Xiaomi'             );
INSERT INTO personne values(69 , 'Nice'          , 18, 'F', 'Etats-Unis' , 'Xiaomi'             );
INSERT INTO personne values(70 , 'Rubby'         , 19, 'F', 'Etats-Unis' , 'Xiaomi'             );
INSERT INTO personne values(71 , 'Shinya'        , 34, 'M', 'Etats-Unis' , 'Samsung'            );
INSERT INTO personne values(72 , 'Feuj'          , 35, 'M', 'Etats-Unis' , 'Samsung'            );
INSERT INTO personne values(73 , 'Steffy'        , 32, 'M', 'Etats-Unis' , 'Samsung'            );
INSERT INTO personne values(74 , 'Snake'         , 20, 'M', 'Suisse'     , 'Iphone'             );
INSERT INTO personne values(75 , 'Trapzi'        , 19, 'M', 'Suisse'     , 'Iphone'             );
INSERT INTO personne values(76 , 'Utako'         , 41, 'M', 'Etats-Unis' , 'Sony'               );
INSERT INTO personne values(77 , 'Elo'           , 42, 'M', 'Etats-Unis' , 'Sony'               );
INSERT INTO personne values(78 , 'Winnie'        , 38, 'M', 'Iran'       , 'Microsoft'          );
INSERT INTO personne values(79 , 'Alphau'        , 41, 'M', 'Iran'       , 'Microsoft'          );
INSERT INTO personne values(80 , 'irony'         , 45, 'M', 'Iran'       , 'Microsoft'          );
INSERT INTO personne values(81 , 'Fundy'         , 24, 'M', 'Etats-Unis' , 'Bethesda'           );
INSERT INTO personne values(82 , 'Sapnap'        , 29, 'F', 'Etats-Unis' , 'Bethesda'           );
INSERT INTO personne values(83 , 'Dumzy'         , 21, 'F', 'Listembourg', 'Listembourg'        );
INSERT INTO personne values(84 , 'Duma'          , 20, 'F', 'Listembourg', 'Listembourg'        );
INSERT INTO personne values(85 , 'Squirrels'     , 19, 'M', 'Listembourg', 'Listembourg'        );
INSERT INTO personne values(86 , 'Xenon'         , 18, 'M', 'Listembourg', 'Listembourg'        );
INSERT INTO personne values(87 , 'Altirix'       , 43, 'M', 'Etats-Unis' , 'Gouvernement'       );
INSERT INTO personne values(88 , 'Bigdodab'      , 33, 'M', 'Etats-Unis' , 'Gouvernement'       );
INSERT INTO personne values(89 , 'Bush'          , 27, 'M', 'Iran'       , 'Nintendo'           );
INSERT INTO personne values(90 , 'Piralio'       , 27, 'F', 'Iran'       , 'Nintendo'           );
INSERT INTO personne values(91 , 'Falink'        , 29, 'F', 'Iran'       , 'Nintendo'           );
INSERT INTO personne values(92 , 'Jertzu'        , 21, 'M', 'France'     , 'Squeezie'           );
INSERT INTO personne values(93 , 'Tronberry'     , 18, 'M', 'France'     , 'Squeezie'           );
INSERT INTO personne values(94 , 'Mx'            , 47, 'M', 'France'     , 'SPA'                );
INSERT INTO personne values(95 , 'Volak'         , 46, 'M', 'France'     , 'SPA'                );
INSERT INTO personne values(96 , 'Volkzak'       , 49, 'M', 'France'     , 'SPA'                );
INSERT INTO personne values(97 , 'Zen'           , 19, 'M', 'Listembourg', 'Charal'             );
INSERT INTO personne values(98 , 'Bloodyvortex'  , 25, 'M', 'Listembourg', 'Charal'             );
INSERT INTO personne values(99 , 'Poot'          , 34, 'M', 'France'     , 'Sega'               );
INSERT INTO personne values(100, 'Frozen'        , 31, 'M', 'France'     , 'Sega'               );
INSERT INTO personne values(101, 'Florian'       , 33, 'F', 'France'     , 'Looping'            );
INSERT INTO personne values(102, 'Niemman'       , 38, 'F', 'Mexique'    , 'Wespeed'            );
INSERT INTO personne values(103, 'Shirli'        , 38, 'M', 'Mexique'    , 'Wespeed'            );
INSERT INTO personne values(104, 'Wilflol'       , 39, 'M', 'Mexique'    , 'Wespeed'            );
INSERT INTO personne values(105, 'Logicman'      , 36, 'F', 'Brésil'     , 'Hal Laboratory Inc.');
INSERT INTO personne values(106, 'Illumina'      , 36, 'F', 'Brésil'     , 'Hal Laboratory Inc.');
INSERT INTO personne values(107, 'Brash'         , 36, 'M', 'Chine'      , 'Bandai Namco'       );
INSERT INTO personne values(108, 'Cryptobazeo'   , 35, 'M', 'Chine'      , 'Bandai Namco'       );
INSERT INTO personne values(109, 'Draken'        , 33, 'M', 'Chine'      , 'Bandai Namco'       );
INSERT INTO personne values(110, 'Cheesy'        , 34, 'M', 'Chine'      , 'Bandai Namco'       );
INSERT INTO personne values(111, 'Jaoname'       , 46, 'M', 'Etats-Unis' , 'Cartoon Network'    );
INSERT INTO personne values(112, 'Loki'          , 45, 'M', 'Etats-Unis' , 'Cartoon Network'    );
INSERT INTO personne values(113, 'Luiyi'         , 22, 'F', 'Angleterre' , 'SK Gaming'          );
INSERT INTO personne values(114, 'Replays'       , 23, 'F', 'Angleterre' , 'SK Gaming'          );
INSERT INTO personne values(115, 'Toga'          , 23, 'F', 'Angleterre' , 'SK Gaming'          );
INSERT INTO personne values(116, 'Yuki'          , 29, 'M', 'Suède'      , 'Tribe'              );
INSERT INTO personne values(117, 'Mina'          , 32, 'F', 'Suède'      , 'Tribe'              );
INSERT INTO personne values(118, 'Pigmansly'     , 34, 'M', 'Suède'      , 'Tribe'              );
INSERT INTO personne values(119, 'Marinus'       , 37, 'M', 'France'     , 'Solary'             );
INSERT INTO personne values(120, 'Agus'          , 36, 'M', 'France'     , 'Solary'             );
INSERT INTO personne values(121, 'Anto'          , 25, 'M', 'France'     , 'Twitch'             );
INSERT INTO personne values(122, 'Flukely'       , 31, 'F', 'France'     , 'Twitch'             );
INSERT INTO personne values(123, 'Aizen'         , 30, 'F', 'France'     , 'Twitch'             );
INSERT INTO personne values(124, 'Rizu'          , 26, 'M', 'France'     , 'Twitch'             );
INSERT INTO personne values(125, 'Xel'           , 27, 'M', 'France'     , 'Twitch'             );
INSERT INTO personne values(126, 'Dejavu'        , 21, 'F', 'Etats-Unis' , 'Gabaret'            );
INSERT INTO personne values(127, 'Aleria'        , 19, 'F', 'Etats-Unis' , 'Gabaret'            );
INSERT INTO personne values(128, 'Eureka'        , 18, 'F', 'Etats-Unis' , 'Gabaret'            );
INSERT INTO personne values(129, 'Unsociable'    , 28, 'F', 'Chine'      , 'Bing chilling'      );
INSERT INTO personne values(130, 'Gordon'        , 29, 'M', 'Chine'      , 'Bing chilling'      );
INSERT INTO personne values(131, 'Ramsey'        , 29, 'M', 'Chine'      , 'Bing chilling'      );
INSERT INTO personne values(132, 'Asvex'         , 28, 'F', 'Etats-Unis' , 'Gabaret'            );
INSERT INTO personne values(133, 'Lonny'         , 27, 'F', 'Etats-Unis' , 'Gabaret'            );
INSERT INTO personne values(134, 'Wulpu'         , 32, 'F', 'Inde'       , 'Oreo'               );
INSERT INTO personne values(135, 'Zurikimo'      , 32, 'F', 'Inde'       , 'Oreo'               );
INSERT INTO personne values(136, 'Tayeb'         , 34, 'M', 'France'     , 'Rhinoshield'        );
INSERT INTO personne values(137, 'Apeiron'       , 36, 'M', 'France'     , 'Rhinoshield'        );
INSERT INTO personne values(138, 'Kat'           , 38, 'F', 'Etats-Unis' , 'In shape'           );
INSERT INTO personne values(139, 'Tibo'          , 32, 'M', 'Etats-Unis' , 'In shape'           );
INSERT INTO personne values(140, 'Tobi'          , 40, 'M', 'Etats-Unis' , 'In shape'           );
INSERT INTO personne values(141, 'Meuf'          , 39, 'F', 'Etats-Unis' , 'In shape'           );
INSERT INTO personne values(142, 'Jonne'         , 42, 'M', 'Etats-Unis' , 'Bing chilling'      );
INSERT INTO personne values(143, 'Senna'         , 42, 'M', 'Etats-Unis' , 'Bing chilling'      );
INSERT INTO personne values(144, 'Sun Tzu'       , 50, 'M', 'Chine'      , 'Bing chilling'      );

--- INSERTIONS ---
insert into combat values(1  , round(random()*9)+1, 3, 1, 'Bo5');
insert into combat values(2  , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(3  , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(4  , round(random()*9)+1, 3, 0, 'Bo5');
insert into combat values(5  , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(6  , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(7  , round(random()*9)+1, 3, 1, 'Bo5');
insert into combat values(8  , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(9  , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(10 , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(11 , round(random()*9)+1, 0, 3, 'Bo5');
insert into combat values(12 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(13 , round(random()*9)+1, 0, 3, 'Bo5');
insert into combat values(14 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(15 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(16 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(17 , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(18 , round(random()*9)+1, 0, 3, 'Bo5');
insert into combat values(19 , round(random()*9)+1, 0, 3, 'Bo5');
insert into combat values(20 , round(random()*9)+1, 3, 1, 'Bo5');
insert into combat values(21 , round(random()*9)+1, 3, 0, 'Bo5');
insert into combat values(22 , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(23 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(24 , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(25 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(26 , round(random()*9)+1, 3, 1, 'Bo5');
insert into combat values(27 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(28 , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(29 , round(random()*9)+1, 0, 3, 'Bo5');
insert into combat values(30 , round(random()*9)+1, 3, 0, 'Bo5');
insert into combat values(31 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(32 , round(random()*9)+1, 3, 1, 'Bo5');
insert into combat values(33 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(34 , round(random()*9)+1, 3, 0, 'Bo5');
insert into combat values(35 , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(36 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(37 , round(random()*9)+1, 0, 3, 'Bo5');
insert into combat values(38 , round(random()*9)+1, 2, 3, 'Bo5');
insert into combat values(39 , round(random()*9)+1, 0, 3, 'Bo5');
insert into combat values(40 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(41 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(42 , round(random()*9)+1, 3, 0, 'Bo5');
insert into combat values(43 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(44 , round(random()*9)+1, 3, 1, 'Bo5');
insert into combat values(45 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(46 , round(random()*9)+1, 3, 0, 'Bo5');
insert into combat values(47 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(48 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(49 , round(random()*9)+1, 3, 2, 'Bo5');
insert into combat values(50 , round(random()*9)+1, 3, 1, 'Bo5');
insert into combat values(51 , round(random()*9)+1, 1, 3, 'Bo5');
insert into combat values(52 , round(random()*9)+1, 3, 1, 'Bo3');
insert into combat values(53 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(54 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(55 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(56 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(57 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(58 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(59 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(60 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(61 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(62 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(63 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(64 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(65 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(66 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(67 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(68 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(69 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(70 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(71 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(72 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(73 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(74 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(75 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(76 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(77 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(78 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(79 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(80 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(81 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(82 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(83 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(84 , round(random()*9)+1, 2, 2, 'Bo3');
insert into combat values(85 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(86 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(87 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(88 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(89 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(90 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(91 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(92 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(93 , round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(94 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(95 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(96 , round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(97 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(98 , round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(99 , round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(100, round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(101, round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(102, round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(103, round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(104, round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(105, round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(106, round(random()*9)+1, 2, 0, 'Bo3');
insert into combat values(107, round(random()*9)+1, 1, 1, 'Bo3');
insert into combat values(108, round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(109, round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(110, round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(111, round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(112, round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(113, round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(114, round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(115, round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(116, round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(117, round(random()*9)+1, 2, 1, 'Bo3');
insert into combat values(118, round(random()*9)+1, 0, 2, 'Bo3');
insert into combat values(119, round(random()*9)+1, 1, 2, 'Bo3');
insert into combat values(120, round(random()*9)+1, 2, 1, 'Bo3');

--- INSERTIONS ---
insert into jouer_dans values(1  , 1  , 1  , 74);
insert into jouer_dans values(2  , 1  , 5  , 24);
insert into jouer_dans values(3  , 2  , 4  , 50);
insert into jouer_dans values(4  , 2  , 30 , 54);
insert into jouer_dans values(5  , 3  , 24 , 54);
insert into jouer_dans values(6  , 3  , 25 , 74);
insert into jouer_dans values(7  , 4  , 2  , 20);
insert into jouer_dans values(8  , 4  , 6  , 82);
insert into jouer_dans values(9  , 5  , 3  , 86);
insert into jouer_dans values(10 , 5  , 121, 85);
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
insert into jouer_dans values(21 , 11 , 140, 1 );
insert into jouer_dans values(22 , 11 , 2  , 16);
insert into jouer_dans values(23 , 12 , 40 , 86);
insert into jouer_dans values(24 , 12 , 39 , 27);
insert into jouer_dans values(25 , 1  , 133, 42);
insert into jouer_dans values(26 , 13 , 12 , 55);
insert into jouer_dans values(27 , 14 , 16 , 3 );
insert into jouer_dans values(28 , 14 , 76 , 27);
insert into jouer_dans values(29 , 15 , 82 , 2 );
insert into jouer_dans values(30 , 15 , 100, 67);
insert into jouer_dans values(31 , 16 , 98 , 80);
insert into jouer_dans values(32 , 16 , 94 , 50);
insert into jouer_dans values(33 , 17 , 43 , 86);
insert into jouer_dans values(34 , 17 , 12 , 27);
insert into jouer_dans values(35 , 18 , 99 , 20);
insert into jouer_dans values(36 , 18 , 90 , 23);
insert into jouer_dans values(37 , 19 , 45 , 45);
insert into jouer_dans values(38 , 19 , 23 , 79);
insert into jouer_dans values(39 , 20 , 115, 10);
insert into jouer_dans values(40 , 20 , 120, 54);
insert into jouer_dans values(41 , 21 , 65 , 80);
insert into jouer_dans values(42 , 21 , 53 , 43);
insert into jouer_dans values(43 , 22 , 123, 8 );
insert into jouer_dans values(44 , 22 , 47 , 16);
insert into jouer_dans values(45 , 23 , 57 , 70);
insert into jouer_dans values(46 , 23 , 35 , 27);
insert into jouer_dans values(47 , 24 , 123, 45);
insert into jouer_dans values(48 , 24 , 120, 81);
insert into jouer_dans values(49 , 25 , 40 , 6 );
insert into jouer_dans values(50 , 25 , 96 , 45);
insert into jouer_dans values(51 , 26 , 96 , 71);
insert into jouer_dans values(52 , 26 , 63 , 4 );
insert into jouer_dans values(53 , 27 , 22 , 15);
insert into jouer_dans values(54 , 27 , 47 , 63);
insert into jouer_dans values(55 , 28 , 84 , 7 );
insert into jouer_dans values(56 , 28 , 102, 6 );
insert into jouer_dans values(57 , 29 , 108, 10);
insert into jouer_dans values(58 , 29 , 106, 8 );
insert into jouer_dans values(59 , 30 , 56 , 20);
insert into jouer_dans values(60 , 30 , 100, 40);
insert into jouer_dans values(61 , 31 , 9  , 85);
insert into jouer_dans values(62 , 31 , 6  , 83);
insert into jouer_dans values(63 , 32 , 90 , 84);
insert into jouer_dans values(64 , 32 , 47 , 12);
insert into jouer_dans values(65 , 33 , 105, 85);
insert into jouer_dans values(66 , 33 , 8  , 32);
insert into jouer_dans values(67 , 34 , 76 , 46);
insert into jouer_dans values(68 , 34 , 30 , 58);
insert into jouer_dans values(69 , 35 , 144, 31);
insert into jouer_dans values(70 , 35 , 140, 30);
insert into jouer_dans values(71 , 36 , 124, 45);
insert into jouer_dans values(72 , 36 , 123, 40);
insert into jouer_dans values(73 , 37 , 16 , 51);
insert into jouer_dans values(74 , 37 , 67 , 69);
insert into jouer_dans values(75 , 38 , 144, 79);
insert into jouer_dans values(76 , 38 , 33 , 33);
insert into jouer_dans values(77 , 39 , 10 , 78);
insert into jouer_dans values(78 , 39 , 16 , 10);
insert into jouer_dans values(79 , 40 , 28 , 22);
insert into jouer_dans values(80 , 40 , 89 , 78);
insert into jouer_dans values(81 , 41 , 67 , 60);
insert into jouer_dans values(82 , 41 , 69 , 10);
insert into jouer_dans values(83 , 42 , 33 , 33);
insert into jouer_dans values(84 , 42 , 75 , 37);
insert into jouer_dans values(85 , 43 , 90 , 48);
insert into jouer_dans values(86 , 43 , 28 , 41);
insert into jouer_dans values(87 , 44 , 25 , 43);
insert into jouer_dans values(88 , 44 , 39 , 82);
insert into jouer_dans values(89 , 45 , 124, 81);
insert into jouer_dans values(90 , 45 , 122, 83);
insert into jouer_dans values(91 , 46 , 102, 66);
insert into jouer_dans values(92 , 46 , 68 , 13);
insert into jouer_dans values(93 , 47 , 6  , 6 );
insert into jouer_dans values(94 , 47 , 9  , 13);
insert into jouer_dans values(95 , 48 , 67 , 60);
insert into jouer_dans values(96 , 48 , 16 , 54);
insert into jouer_dans values(97 , 49 , 11 , 11);
insert into jouer_dans values(98 , 49 , 14 , 4 );
insert into jouer_dans values(99 , 50 , 87 , 3 );
insert into jouer_dans values(100, 50 , 56 , 5 );
insert into jouer_dans values(101, 51 , 59 , 76);
insert into jouer_dans values(102, 51 , 50 , 50);
insert into jouer_dans values(103, 52 , 142, 72);
insert into jouer_dans values(104, 52 , 140, 77);
insert into jouer_dans values(105, 53 , 85 , 42);
insert into jouer_dans values(106, 53 , 47 , 47);
insert into jouer_dans values(107, 54 , 67 , 54);
insert into jouer_dans values(108, 54 , 112, 81);
insert into jouer_dans values(109, 55 , 104, 84);
insert into jouer_dans values(110, 55 , 14 , 26);
insert into jouer_dans values(111, 56 , 92 , 74);
insert into jouer_dans values(112, 56 , 96 , 14);
insert into jouer_dans values(113, 57 , 128, 5 );
insert into jouer_dans values(114, 57 , 8  , 26);
insert into jouer_dans values(115, 58 , 136, 17);
insert into jouer_dans values(116, 58 , 138, 44);
insert into jouer_dans values(117, 59 , 44 , 25);
insert into jouer_dans values(118, 59 , 76 , 26);
insert into jouer_dans values(119, 60 , 85 , 12);
insert into jouer_dans values(120, 60 , 134, 78);
insert into jouer_dans values(121, 61 , 72 , 52);
insert into jouer_dans values(122, 61 , 79 , 57);
insert into jouer_dans values(123, 62 , 71 , 53);
insert into jouer_dans values(124, 62 , 73 , 54);
insert into jouer_dans values(125, 63 , 75 , 24);
insert into jouer_dans values(126, 63 , 49 , 23);
insert into jouer_dans values(127, 64 , 37 , 82);
insert into jouer_dans values(128, 64 , 61 , 83);
insert into jouer_dans values(129, 65 , 64 , 58);
insert into jouer_dans values(130, 65 , 82 , 7 );
insert into jouer_dans values(131, 66 , 127, 14);
insert into jouer_dans values(132, 66 , 121, 19);
insert into jouer_dans values(133, 67 , 81 , 24);
insert into jouer_dans values(134, 67 , 1  , 12);
insert into jouer_dans values(135, 68 , 91 , 83);
insert into jouer_dans values(136, 68 , 94 , 81);
insert into jouer_dans values(137, 69 , 86 , 27);
insert into jouer_dans values(138, 69 , 144, 29);
insert into jouer_dans values(139, 70 , 74 , 14);
insert into jouer_dans values(140, 70 , 66 , 12);
insert into jouer_dans values(141, 71 , 64 , 4 );
insert into jouer_dans values(142, 71 , 57 , 73);
insert into jouer_dans values(143, 72 , 7  , 86);
insert into jouer_dans values(144, 72 , 114, 74);
insert into jouer_dans values(145, 73 , 118, 54);
insert into jouer_dans values(146, 73 , 111, 52);
insert into jouer_dans values(147, 74 , 119, 83);
insert into jouer_dans values(148, 74 , 121, 1 );
insert into jouer_dans values(149, 75 , 107, 81);
insert into jouer_dans values(150, 75 , 109, 65);
insert into jouer_dans values(151, 76 , 141, 2 );
insert into jouer_dans values(152, 76 , 131, 21);
insert into jouer_dans values(153, 77 , 77 , 77);
insert into jouer_dans values(154, 77 , 78 , 82);
insert into jouer_dans values(155, 78 , 52 , 81);
insert into jouer_dans values(156, 78 , 57 , 83);
insert into jouer_dans values(157, 79 , 14 , 40);
insert into jouer_dans values(158, 79 , 29 , 47);
insert into jouer_dans values(159, 80 , 26 , 45);
insert into jouer_dans values(160, 80 , 29 , 26);
insert into jouer_dans values(161, 81 , 24 , 21);
insert into jouer_dans values(162, 81 , 20 , 8 );
insert into jouer_dans values(163, 82 , 27 , 9);
insert into jouer_dans values(164, 82 , 21 , 1 );
insert into jouer_dans values(165, 83 , 28 , 74);
insert into jouer_dans values(166, 83 , 120, 79);
insert into jouer_dans values(167, 84 , 97 , 71);
insert into jouer_dans values(168, 84 , 93 , 19);
insert into jouer_dans values(169, 85 , 51 , 21);
insert into jouer_dans values(170, 85 , 41 , 17);
insert into jouer_dans values(171, 86 , 42 , round(random()*86)+1);
insert into jouer_dans values(172, 86 , 46 , round(random()*86)+1);
insert into jouer_dans values(173, 87 , 1  , round(random()*86)+1);
insert into jouer_dans values(174, 87 , 13 , round(random()*86)+1);
insert into jouer_dans values(175, 88 , 15 , round(random()*86)+1);
insert into jouer_dans values(176, 88 , 17 , round(random()*86)+1);
insert into jouer_dans values(177, 89 , 19 , round(random()*86)+1);
insert into jouer_dans values(178, 89 , 22 , round(random()*86)+1);
insert into jouer_dans values(179, 90 , 32 , round(random()*86)+1);
insert into jouer_dans values(180, 90 , 34 , round(random()*86)+1);
insert into jouer_dans values(181, 91 , 36 , round(random()*86)+1);
insert into jouer_dans values(182, 91 , 38 , round(random()*86)+1);
insert into jouer_dans values(183, 92 , 48 , round(random()*86)+1);
insert into jouer_dans values(184, 92 , 54 , round(random()*86)+1);
insert into jouer_dans values(185, 93 , 55 , round(random()*86)+1);
insert into jouer_dans values(186, 93 , 58 , round(random()*86)+1);
insert into jouer_dans values(187, 94 , 60 , round(random()*86)+1);
insert into jouer_dans values(188, 94 , 62 , round(random()*86)+1);
insert into jouer_dans values(189, 95 , 63 , round(random()*86)+1);
insert into jouer_dans values(190, 95 , 70 , round(random()*86)+1);
insert into jouer_dans values(191, 96 , 80 , round(random()*86)+1);
insert into jouer_dans values(192, 96 , 83 , round(random()*86)+1);
insert into jouer_dans values(193, 97 , 88 , round(random()*86)+1);
insert into jouer_dans values(194, 97 , 95 , round(random()*86)+1);
insert into jouer_dans values(195, 98 , 110, round(random()*86)+1);
insert into jouer_dans values(196, 98 , 111, round(random()*86)+1);
insert into jouer_dans values(197, 99 , 113, round(random()*86)+1);
insert into jouer_dans values(198, 99 , 101, round(random()*86)+1);
insert into jouer_dans values(199, 100, 103, round(random()*86)+1);
insert into jouer_dans values(200, 100, 116, round(random()*86)+1);
insert into jouer_dans values(201, 101, 117, round(random()*86)+1);
insert into jouer_dans values(202, 101, 125, round(random()*86)+1);
insert into jouer_dans values(203, 102, 126, round(random()*86)+1);
insert into jouer_dans values(204, 102, 129, round(random()*86)+1);
insert into jouer_dans values(205, 103, 130, round(random()*86)+1);
insert into jouer_dans values(206, 103, 132, round(random()*86)+1);
insert into jouer_dans values(207, 104, 134, round(random()*86)+1);
insert into jouer_dans values(208, 104, 135, round(random()*86)+1);
insert into jouer_dans values(209, 105, 137, round(random()*86)+1);
insert into jouer_dans values(210, 105, 139, round(random()*86)+1);
insert into jouer_dans values(211, 106, 143, round(random()*86)+1);
insert into jouer_dans values(212, 106, 144, round(random()*86)+1);
insert into jouer_dans values(213, 107, 116, round(random()*86)+1);
insert into jouer_dans values(214, 107, 116, round(random()*86)+1);
insert into jouer_dans values(215, 108, 120, round(random()*86)+1);
insert into jouer_dans values(216, 108, 8  , round(random()*86)+1);
insert into jouer_dans values(217, 109, 12 , round(random()*86)+1);
insert into jouer_dans values(218, 109, 84 , round(random()*86)+1);
insert into jouer_dans values(219, 110, 54 , round(random()*86)+1);
insert into jouer_dans values(220, 110, 57 , round(random()*86)+1);
insert into jouer_dans values(221, 111, 14 , round(random()*86)+1);
insert into jouer_dans values(222, 111, 2  , round(random()*86)+1);
insert into jouer_dans values(223, 112, 26 , round(random()*86)+1);
insert into jouer_dans values(224, 112, 27 , round(random()*86)+1);
insert into jouer_dans values(225, 113, 29 , round(random()*86)+1);
insert into jouer_dans values(226, 113, 39 , round(random()*86)+1);
insert into jouer_dans values(227, 114, 127, round(random()*86)+1);
insert into jouer_dans values(228, 114, 2  , round(random()*86)+1);
insert into jouer_dans values(229, 115, 46 , round(random()*86)+1);
insert into jouer_dans values(230, 115, 52 , round(random()*86)+1);
insert into jouer_dans values(231, 116, 71 , round(random()*86)+1);
insert into jouer_dans values(232, 116, 128, round(random()*86)+1);
insert into jouer_dans values(233, 117, 20 , round(random()*86)+1);
insert into jouer_dans values(234, 117, 37 , round(random()*86)+1);
insert into jouer_dans values(235, 118, 49 , round(random()*86)+1);
insert into jouer_dans values(236, 118, 58 , round(random()*86)+1);
insert into jouer_dans values(237, 119, 69 , round(random()*86)+1);
insert into jouer_dans values(238, 119, 22 , round(random()*86)+1);
insert into jouer_dans values(239, 120, 10 , round(random()*86)+1);
insert into jouer_dans values(240, 120, 13 , round(random()*86)+1);

--- Historique personne ---
create or replace function op_personne()
returns trigger as $$

/* 
    Cette fonction permet de "sauvegarder" les commandes faites sur la table personne dans la table historique.
*/

declare
    id integer;

begin
    select into id max((id_commande)+1) from historique;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then 
            insert into historique values(id, new.id_personne, 'INSERT', 'personne', current_timestamp);
        return new;
    end if;

    if(TG_OP='UPDATE')
        then 
            insert into historique values(id, old.id_personne, 'UPDATE', 'personne', current_timestamp);
        return old;
    end if;

    if(TG_OP='DELETE')
        then 
            insert into historique values(id, old.id_personne, 'DELETE', 'personne', current_timestamp);
        return old;
    end if;
end;
$$ language plpgsql;

create trigger historique_personne
after insert or delete or update on personne
for each row
execute procedure op_personne();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- Historique personnage ---
create or replace function op_personnage()
returns trigger as $$

/* 
    Cette fonction permet de "sauvegarder" les commandes faites sur la table personnage dans la table historique.
*/

declare
    id integer;

begin
    select into id max((id_commande)+1) from historique;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then 
            insert into historique values(id, new.id_perso, 'INSERT', 'personnage', current_timestamp);
        return new;
    end if;

    if(TG_OP='UPDATE')
        then 
            insert into historique values(id, old.id_perso, 'UPDATE', 'personnage', current_timestamp);
        return old;
    end if;

    if(TG_OP='DELETE')
        then 
            insert into historique values(id, old.id_perso, 'DELETE', 'personnage', current_timestamp);
        return old;
    end if;
end;
$$ language plpgsql;

create trigger historique_personnage
after insert or delete or update on personnage 
for each row
execute procedure op_personnage();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- Historique jouer_dans ---
create or replace function op_jouer_dans()
returns trigger as $$

/* 
    Cette fonction permet de "sauvegarder" les commandes faites sur la table jouer_dans dans la table historique.
*/

declare
    id integer;

begin
    select into id max((id_commande)+1) from historique;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then 
            insert into historique values(id, new.id_joueur, 'INSERT', 'jouer_dans', current_timestamp);
        return new;
    end if;

    if(TG_OP='UPDATE')
        then 
            insert into historique values(id, old.id_joueur, 'UPDATE', 'jouer_dans', current_timestamp);
        return old;
    end if;

    if(TG_OP='DELETE')
        then 
            insert into historique values(id, old.id_joueur, 'DELETE', 'jouer_dans', current_timestamp);
        return old;
    end if;
end;
$$ language plpgsql;

create trigger historique_jouer_dans
after insert or delete or update on jouer_dans
for each row
execute procedure op_jouer_dans();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- Historique franchise ---
create or replace function op_franchise()
returns trigger as $$

/* 
    Cette fonction permet de "sauvegarder" les commandes faites sur la table franchise dans la table historique.
*/

declare
    id integer;

begin
    select into id max((id_commande)+1) from historique;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then 
            insert into historique values(id, new.id_franchise, 'INSERT', 'franchise', current_timestamp);
        return new;
    end if;

    if(TG_OP='UPDATE')
        then 
            insert into historique values(id, old.id_franchise, 'UPDATE', 'franchise', current_timestamp);
        return old;
    end if;

    if(TG_OP='DELETE')
        then 
            insert into historique values(id, old.id_franchise, 'DELETE', 'franchise', current_timestamp);
        return old;
    end if;
end;
$$ language plpgsql;

create trigger historique_franchise
after insert or delete or update on franchise
for each row
execute procedure op_franchise();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- Historique carte ---
create or replace function op_carte()
returns trigger as $$

/* 
    Cette fonction permet de "sauvegarder" les commandes faites sur la table carte dans la table historique.
*/

declare
    id integer;

begin
    select into id max((id_commande)+1) from historique;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then 
            insert into historique values(id, new.id_carte, 'INSERT', 'carte', current_timestamp);
        return new;
    end if;

    if(TG_OP='UPDATE')
        then 
            insert into historique values(id, old.id_carte, 'UPDATE', 'carte', current_timestamp);
        return old;
    end if;

    if(TG_OP='DELETE')
        then 
            insert into historique values(id, old.id_carte, 'DELETE', 'carte', current_timestamp);
        return old;
    end if;
end;
$$ language plpgsql;

create trigger historique_carte
after insert or delete or update on carte
for each row
execute procedure op_carte();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- Historique combat ---
create or replace function op_combat()
returns trigger as $$

/* 
    Cette fonction permet de "sauvegarder" les commandes faites sur la table combat dans la table historique.
*/

declare
    id integer;

begin
    select into id max((id_commande)+1) from historique;
    if(id is NULL)
        then
            id = 1;
    end if;

    if(TG_OP='INSERT')
        then 
            insert into historique values(id, new.id_combat, 'INSERT', 'combat', current_timestamp);
        return new;
    end if;

    if(TG_OP='UPDATE')
        then 
            insert into historique values(id, old.id_combat, 'UPDATE', 'combat', current_timestamp);
        return old;
    end if;

    if(TG_OP='DELETE')
        then 
            insert into historique values(id, old.id_combat, 'DELETE', 'combat', current_timestamp);
        return old;
    end if;
end;
$$ language plpgsql;

create trigger historique_combat
after insert or delete or update on combat
for each row
execute procedure op_combat();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---