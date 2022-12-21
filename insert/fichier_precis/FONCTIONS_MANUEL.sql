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