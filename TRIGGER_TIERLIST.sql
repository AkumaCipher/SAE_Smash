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


--- INCREMENTATION VICTOIRE / DEFAITE ---
create or replace function vic_def()
returns trigger as $$

declare
    perso integer;
    nb_c integer;

begin
    if(TG_OP='INSERT')
        then
            select into perso id_perso from jouer_dans where id_perso=new.id_perso;
            select into nb_c nb_combat from tierlist where id_perso=perso;
            nb_c := nb_c + 1;
            update tierlist set nb_combat=nb_c where id_perso=perso;
            return new;
    end if;
end;
$$language plpgsql;

create trigger test
after insert on jouer_dans
for each row
execute procedure vic_def();
--- select c.id_combat, c.score_j1, c.score_j2, jd.id_joueur, jd.id_perso, jd.id_personne from combat as c join jouer_dans as jd on c.id_combat = jd.id_combat where c.id_combat = 1; 