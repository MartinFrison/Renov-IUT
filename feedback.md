## Retours de testeurs extérieurs

### Incohérences, questions, informations manquantes...

- Peut-on visualiser combien coûtent les travaux ? On voit le budget, mais pas ce qu'on dépense, cela ne permet pas d'imaginer une bonne stratégie.
- Pourquoi le niveau des étudiants s'améliore alors qu'on ne fait rien, c'est normal ? 
	- Ceci dit, il peut aussi chuter de manière radicale, je l'ai expérimenté... mais à vérifier.
- La proportion de bonhommes verts/oranges ne correspond pas au taux de satisfaction, c'est gênant.

### Interface & design

- Mettre un sablier ou autre signe compréhensible pour signifier le temps d'attente bloquante (au lancement du jeu et au changement de trimestre).
- Il n'a pas de sortie d'urgence, que faire si l'exit standard est bloqué ? (d'autant plus qu'on est en plein écran...)
	- Voir dans les paramètres de Godot si on peut basculer entre plein écran et mode fenêtre, tout en gardant le plein écran pour défaut.

### Bogues

- Le lancement des travaux n'est pas toujours immédiat.
- Il faut appuyer avec beaucoup de précision sur le bouton qui lance le jeu.
- Bogue lié à l'isolation.
	- Commenté la ligne qui posait problème, mais il faudrait soit supprimer l'isolation là où elle figure encore, ou alors la (ré)implémenter.

