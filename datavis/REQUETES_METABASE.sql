--- Nombre de personnes par pays ---
select count(id_personne),
       pays
from personne
group by pays
order by count(id_personne);

--- Statistiques genre ---
select sexe,
       count(id_personne)
from personne
group by sexe;

--- Nombre de combats de chaque personnage --- 
select id_perso,
       count(id_combat)
from jouer_dans
group by id_perso;

--- Nombre de combats pour chaques Cartes ---
select c.nom,
       count(c.id_carte)
from combat as co
inner join carte as c on c.id_carte = co.id_carte
group by c.nom;

--- Les franchises qui ont au moins 4 personnages ---
select f.nom,
       count(p.id_perso) as nombre_perso
from personnage as p
inner join franchise as f on p.id_franchise = f.id_franchise
group by f.nom
having count(p.id_perso) >=4;

--- Le ratio de victoire pour la franchose°4, celle de Fire Emblem ---
select (sum(ratio)/count(ratio)) as ratio_victoires
from tierlist as t
inner join personnage as p on t.id_perso = p.id_perso
inner join franchise as f on p.id_franchise = f.id_franchise
where f.id_franchise = 4;