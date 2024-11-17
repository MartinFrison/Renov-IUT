# Règles détaillées du jeu

Ceci est un document de référence détaillé. Sa lecture n'est pas indispensable pour jouer, ni pour comprendre la logique du jeu, mais il saurait être utile en cas de doute ou en quête d'explications.

Il complète donc le cahier des charges (_README.md_), sans pour autant en être une annexe.

## Déroulement général du jeu

- Des évênement aléatoires qui dépendent du scénario peuvent tomber chaque jour et ce, pour une durée variant d'un jour à la durée totale d'une partie.
- Chaque jour, les opérations du jeu, dont des actions du joueur aussi bien que les événements automatiques, affectent le budget, la satisfaction générale et la réussite des étudiants.
- Les enseignants comme les étudiants dont la satisfaction devient trop faible démissionnent.
- En début d'année, la nouvelle promo est remplie automatiquement en fonction de la difficulté des examens d'entrée. Le niveau des étudiants est calculée aléatoirement dans une fourchette raisonnable.
- En fin d'année, des examens ont lieu. Selon le niveau des étudiants, leur satisfaction et la difficulté des examens ils passent l'année, la redoublent ou bien abandonnent. Il va de soi que le départ normal au bout de trois ans, scellé par l'obtention du diplôme, est également géré par le jeu.

## Les scénarios

À ce stade de développement, nous proposons deux scénarios :

- Le scénario de rénovation où un batiment est en mauvais état de base et où l'on doit le rénover complètement.
- Le scénario d'éléction où l'objectif est de se faire réélire au bout de 5 ans.

## L'argent

- Il y a un budget global, qui peut servir à couvrir n'importe quelle dépense.
- Il y a un budget pour chaque bâtiment, qui ne peut être utilisé que pour les dépenses de celui-ci.
- L'initialisation de l'argent initial dépend de la difficulté et d'un facteur aléatoire.

## Actions sur les bâtiments

- Allumer/Eteindre le chauffage :
    - Coût quotidient si allumé. Dépend de l'isolation.
    - Risque de plainte des occupants si allumé en été (affecte la satisafaction).
    - Risque de plainte des occupants si éteint en hiver (affecte la satisafaction).
- Bloquer/Débloquer les portes :
    - Risque de plainte des étudiants si fermé (affecte la satisafaction).
    - Rend le travail des agents d'entretien deux fois plus facile.
- Embaucher/Virer un enseignant :
    - Il faut que la satisfaction des enseignants par bâtiment soit d'au moins 60% pour pouvoir embaucher.
    - La satisfaction d'un enseignant à l'embauche est comprise entre 40% et 60%.
    - Demande un salaire mensuel de _x_ à payer.
    - Impact sur la réussite étudiante au jour le jour (plafond de l'effet cumulable à partir de 1 prof pour 10 élèves).
- Embaucher/Virer un agent d'entretien :
    - Vaut un salaire mensuel de _x_ à payer.
    - Agit sur la vitesse de dégradation de l'état des lieux (coeff de degradation = 1/(1+nb_agent) ).
    - Risque de plainte des occupants.
- Embaucher/Virer un ouvrier :
    - Vaut un salaire mensuel de _x_ à payer.
    - Permet de faire des travaux.
- Lancer les travaux d'isolation et/ou de rénovation d'un bâtiment :
    - N'est possible que si des ouvriers ont été embauchés.
    - Il n'est possible de lancer des travaux que s'il reste assez de place libre dans les bâtiments pour tout les étudiants (450 places par bâtiment).
    - La vitesse de travaux est proportionelle au nombre d'ouvriers.
    - Logiquement, les ouvriers en grêve ne participent pas au travaux.

## Batiments

- dqsf

## Étudiants

- Si la satisfaction d'un étudiants descend au-dessous de 20%, il abandonne.

## Enseignants

- Si la satisfaction d'un enseignant descend au-dessous de 20%, il démissionne.

## Événements aléatoires

- Les évênements aléatoires ont plus de chance d'arriver en milieu de jeu.
- Certains événements peuvent solliciter un choix du joueur, d'autre produisent simplement un effet.
- Certains événements ont des prérequis pour avoir lieu.

## Liste des événements

- Grève des :
	- professeurs
	- ouvriers
            -
