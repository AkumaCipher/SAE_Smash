--- INSERTIONS ---
create or replace function insert_tl()
returns trigger as $$

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

create trigger insert_tierlist
after insert or delete on personnage
for each row
execute procedure insert_tl();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


--- INCREMENTATION STATS DE COMBAT ---
create or replace function vic_def()
returns trigger as $$

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

    winrate integer;

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
                select into joueur1 id_joueur from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur limit 1;

                select into joueur1_p id_perso from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur limit 1;

                update tierlist set nb_victoire = nb_victoire + sco_j1 where id_perso = joueur1_p;
                update tierlist set nb_defaite = nb_defaite + sco_j2 where id_perso = joueur1_p;
                update tierlist set nb_combat = nb_combat + sco_j1 where id_perso=joueur1_p;
                update tierlist set nb_combat = nb_combat + sco_j2 where id_perso=joueur1_p;

                select into winrate nb_victoire/nb_combat*100 from tierlist where nb_victoire > 0 and id_perso=joueur1_p;
                update tierlist set ratio = round(winrate, 1) where id_perso = joueur1_p;

                select into joueur2 id_joueur from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur desc limit 1;

                select into joueur2_p id_perso from jouer_dans as jd join combat as c on jd.id_combat = c.id_combat where c.id_combat = new.id_combat order by id_joueur desc limit 1;

                update tierlist set nb_victoire = nb_victoire + sco_j1 where id_perso = joueur2_p;
                update tierlist set nb_defaite = nb_defaite + sco_j2 where id_perso = joueur2_p;
                update tierlist set nb_combat = nb_combat + sco_j1 where id_perso=joueur2_p;
                update tierlist set nb_combat = nb_combat + sco_j2 where id_perso=joueur2_p;

                select into winrate nb_victoire/nb_combat*100 from tierlist where nb_victoire > 0 and id_perso=joueur2_p;
                update tierlist set ratio = round(winrate, 1) where id_perso = joueur2_p;

                raise notice 'joueur1: %, perso1: %', joueur1, joueur1_p;
                
                raise notice 'joueur2: %, perso1: %', joueur2, joueur2_p;
            end if;
            return new;
    end if;
end;
$$language plpgsql;

create trigger test
after insert on jouer_dans
for each row
execute procedure vic_def();
--- select c.id_combat, c.score_j1, c.score_j2, jd.id_joueur, jd.id_perso, jd.id_personne from combat as c join jouer_dans as jd on c.id_combat = jd.id_combat where c.id_combat = 1; 

--- insert into jouer_dans values (260, 3, 120, 22);