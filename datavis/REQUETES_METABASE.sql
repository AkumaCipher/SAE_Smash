--- Nombre de personnes par pays ---
select count(id_personne), pays from personne group by pays order by count(id_personne);

--- Statistiques genre ---
select sexe, count(id_personne) from personne group by sexe;

--- Nombre de combats de chaque personnage --- 
select id_perso, count(id_combat) from jouer_dans group by id_perso;

--- Nombre de combats pour chaques Cartes ---
select c.nom, count(c.id_carte) from combat as co inner join carte as c on c.id_carte = co.id_carte group by c.nom;