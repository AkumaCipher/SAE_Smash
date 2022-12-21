# <span style="color:lightcoral"> Smash'em All! </span>

Pour la SAE 2.4 de l'IUT, nous avons décidé de proposer une structure accueillant des combats compétitifs sur le jeu **Super Smash Bros. Ultimate**. <br>
Ce jeu de combat propose un total de *86* personnages jouables issus de *40* franchises mondialement connues.
Notre structure permet aux joueurs le souhaitant, de se mettre en relation et de jouer un match (1v1) contre un autre joueur.

## <span style="color:grey"> Présentation du projet. </span>

Nous avons décidé de faire un classement des personnages : la table *tierlist*, recensant le nombre de combats combattus par le personnage, son nombre de victoires et de défaites, permettant ainsi d'indiquer un pourcentage de victoire : le ratio. <br>
Le ratio est très important car il permet de classer les différents personnages, grâce à leur *rang*. Ce rang étant très représentatif aux yeux de nos joueurs moins expérimentés, qui voudraient choisir un nouveau personnage à jouer. <br>
Nous avons également opté pour un historique de commande : la table *historique*, permettant de connaître tout les changements effectués sur notre base de données. <br>
*Attention* les changements effectués sur les tables "automatisées" (historique, tierlist) ne sont pas pris en compte, seuls les changements manuels sont enregistrés.

## <span style="color:grey"> Notre équipe. </span>

Numéro d'équipe : **4**.

Chef de Projet : **Paul Hurdebourcq**.

Collaborateur : **Théo Massias**.

## <span style="color:red"> Comment installer la base de données ? </span>

D'abord, il faudrait que vous créer la base de données dans laquelle vous allez insérer toutes les données. Un exemple simple :
```sql
create database smash;
```

N'oubliez pas de vous "déplacer" dans votre nouvelle base de données :
```sql
\c smash
```

Une fois cela fait, il faut maintenant insérer les données dans cette base. Pour cela, vous pouvez tout simplement copier coller les commandes à l'intérieur, ou alors, si vous êtes sur un **environnement linux**, vous pouvez faire ceci :

<ol>
<li>Faire un clic-droit tout en appuyant sur la touche SHIFT sur le dossier comportant les fichiers sql.</li>
<li>Sélectionner l'option "Ouvrir l'interpréteur de commandes Linux ici."</li>
<li>Copier le chemin qui s'affiche dans le terminal.</li>
<li>Faire dans l'interpréteur SQL la commande qui permet d'exécuter les fichiers, pour moi, c'est comme ceci si je choisis de le faire avec le fichier qui créer les tables :</li>
</ol>

```sql
\i /mnt/c/Users/petit/Desktop/Cours/SAEs/SAE_SQL_Smash/SAE_Smash/CREATE_TABLE.sql
```

