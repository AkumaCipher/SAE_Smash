# <span style="color:lightcoral"> Smash'Em All! </span>

Pour la SAE 2.4 de l'IUT, nous avons décidé de proposer une structure accueillant des combats compétitifs sur le jeu **Super Smash Bros. Ultimate**. <br>
Ce jeu de combat propose un total de *86* personnages jouables issus de *40* franchises mondialement connues.
Notre structure permet aux joueurs le souhaitant, de se mettre en relation et de jouer un match (1v1) contre un autre joueur.

## <span style="color:grey"> Présentation du projet. </span>

Nous avons décidé de faire un classement des personnages : la table *tierlist*, recensant le nombre de combats combattus par le personnage, son nombre de victoires et de défaites, permettant ainsi d'indiquer un pourcentage de victoire : le ratio.
En plus du classement des personnages, la base de données possède bien sûr un classement des personnes : la table *classement*. 
<br>
Le ratio est très important car il permet de classer les différents personnages, grâce à leur *rang*. Ce rang étant très représentatif aux yeux de nos joueurs moins expérimentés, qui voudraient choisir un nouveau personnage à jouer. <br>
Nous avons également opté pour un historique de commande : la table *historique*, permettant de connaître tout les changements effectués sur notre base de données. <br>
*Attention* les changements effectués sur les tables "automatisées" (historique, tierlist, classement) ne sont pas pris en compte, seuls les changements manuels sont enregistrés.

## <span style="color:grey"> Notre équipe. </span>

Numéro d'équipe : **4**.

Chef de Projet : **Paul Hurdebourcq [BUT2-TD2-TPD]**.

Collaborateur : **Théo Massias [BUT2-TD2-TPD]**.

## <span style="color:orange"> N'oubliez pas d'aller voir nos différents datavis !!! </span>

## <span style="color:red"> Comment installer la base de données ? </span>

D'abord, il faudrait que vous créer la base de données dans laquelle vous allez insérer toutes les données. Un exemple simple :
```sql
create database smash;
```

N'oubliez pas de vous "déplacer" dans votre nouvelle base de données :
```sql
\c smash
```

Une fois cela fait, il faut maintenant insérer les données dans cette base. Pour cela, vous pouvez tout simplement copier coller l'intégralité du fichier **INSERT_CREATE_COMPLET.sql**, ou alors, si vous êtes sur un **environnement linux**, vous pouvez faire ceci :

<ol>
<li>Faire un clic-droit tout en appuyant sur la touche SHIFT sur le dossier comportant les fichiers sql.</li>
<li>Sélectionner l'option "Ouvrir l'interpréteur de commandes Linux ici."</li>
<li>Copier le chemin qui s'affiche dans le terminal.</li>
<li>Faire dans l'interpréteur SQL la commande qui permet d'exécuter les fichiers, pour moi, c'est comme ceci si je choisis de le faire avec le fichier qui créer les tables :</li>
</ol>

```sql
\i /mnt/c/Users/petit/Desktop/Cours/SAEs/SAE_SQL_Smash/SAE_Smash/CREATE_TABLE.sql
```

# <span style="color:lightblue"> Comment naviguer dans la base de données ? </span>

Afin d'avoir une vue global de vos bases de données : 
```sql
\l
```

Pour vous déplacer dans une autre base de données : 
```sql
\c [nom_de_la_base]
```

Pour prendre connaissance des fonctions de la base :

```sql
\df
```

Pour regarder dans une table précise :
```sql
select [colonne] from [table];
select * from personne where nom='Pataploup';
```

Appeler une fonction :
```sql
select manuel_stats_joueurs();
```

Regarder les tables de classement :
```sql
select * from tierlist order by id_rang;
select * from classement order by id_rang;
```

**Modifier une table manuellement :**
```sql
insert into [table] values (arg1, arg2, etc...);
delete from [table];
update [table] set [colonne] = [valeur];

insert into personne values (1, 'Paulo', 19, 'M', 'France', 'IUT');
delete from personnage where id_perso=2;
--- delete from personnage supprime toutes les données de la table personnage.
update personne set nom = 'Toto' where id_personne = 1;
```