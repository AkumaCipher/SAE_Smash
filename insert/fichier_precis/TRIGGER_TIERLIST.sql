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

                update tierlist set nb_victoire = nb_victoire + sco_j1 where id_perso = joueur2_p;
                update tierlist set nb_defaite = nb_defaite + sco_j2 where id_perso = joueur2_p;
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