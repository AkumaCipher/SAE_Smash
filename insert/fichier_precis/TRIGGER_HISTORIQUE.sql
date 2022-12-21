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