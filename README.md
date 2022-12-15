# <span style="color:lightcoral"> SAE Smash </span>

SAE 2.4 de l'IUT, nous avons choisis de faire le classement et la SAE sur un "tournois" compétitif du jeu Super Smash Bros Ultimate.

## Présentation du Projet.

Nous avons décidé de faire un classement avec des joueurs, des personnages et leurs combats basé sur le jeu Super Smash Bros Ultimate.

## Présentation de l'équipe.

Numéro d'équipe : **4**.

Chef de Projet : **Paul Hurdebourcq**.

Collaborateur : **Théo Massias**.

## Comment installer la base de données.

D'abord, il faut que vous crééez la base de données dans laquelle vous allez inséré toutes les données. Vous allez faire cela avec cette commande :

```sql
create database smash;
```

Une fois cela fait, il faut maintenant insérer les données de cette base. Pour cela, vous pouvez tout simplement copier coller les commandes à l'intérieur, ou alors, si vous êtes sur un environnement linux, vous pouvez faire ceci :

<ul>
<ol>1) Faire un clique-droit tout en appuyant sur la touche SHIFT sur le dossier comportant les fichiers sql.</ol>
<ol>2) Sélectionner l'option "Ouvrir l'interpréteur de commandes Linux ici."</ol>
<ol>3) Copier le chemin qui s'affiche dans le terminal.</ol>
<ol>4) Faire dans l'interpréteur SQL la commande qui permet d'exécuter les fichiers, pour moi, c'est comme ceci si je choisis de le faire avec le fichier qui créer les tables :</ol>
</ul>

```sql
\i /mnt/c/Users/petit/Desktop/Cours/SAEs/SAE_SQL_Smash/SAE_Smash/CREATE_TABLE.sql
```
**Attention, il est important de insert le fichier "TRIGGER_TIERLIST.sql" juste après avoir créer les tables, mais avant d'insérer les données pour qu'elles fonctionnent correctement.**

Après avoir inséré les données, vous pouvez insérez le fichier "TRIGGER_HISTORIQUE.sql".