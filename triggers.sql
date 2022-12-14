--- Historique Personne ---
create or replace function up_personne()
returns trigger as $$

declare
    id integer;

begin
    if(TG_OP='UPDATE')
    then 
        select into id max((id_commande)+1) from historique;
        if(id=NULL)
        then
        id = 1;
        insert into historique values(id, old.id_personne, 'UPDATE', 'personnes', current_timestamp);
        return old;
    end if;
end;
$$ language plpgsql;

create trigger update_personne
after update on personnes 
for each row
execute procedure up_personne();