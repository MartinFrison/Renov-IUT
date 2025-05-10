# T3 - RenovIUT

* **Nom du groupe :** Coruscant
* **Membres du groupe :** [Martin FRISON](https://git.unistra.fr/martin.frison), [Yasmine CHETTATI](https://git.unistra.fr/ychettati), [Elena FRISON](https://git.unistra.fr/e.frison).

## Présentation du projet

Vous incarnez le directeur de l'IUT Robert Schuman sur le campus d'Illkirch. Votre mission est d'assurer l'entretien et les rénovations des bâtiments et des infrastructures, tout en faisant face aux aléas du quotidien.

### Captures d'écran

Toutes les images utilisées sont libres de droits :

* [Banque de photos de l'IUT Robert Schuman](https://seafile.unistra.fr/d/03767a1835b7493b83a6/?p=%2FBelles%20photos%20%28libre%20de%20droits%29&mode=list)
* Certaines ont été dessinées par nos soins, à partir d’images libres de droits trouvées sur Internet.

<p align="left">
  <img src="visuals/screenshots/game_start.png" alt="Lancement" width="600"/>
  <br/>
  <small>Fig.1. Début du jeu</small>
</p>

<p align="left">
  <img src="visuals/screenshots/main_screen.png" alt="Campus" width="600"/>
  <br/>
  <small>Fig.2. Fenêtre principale : le campus au printemps</small>
</p>

<p align="left">
  <img src="visuals/screenshots/shift_view.png" alt="Vue de devant" width="600"/>
  <br/>
  <small>Fig.3. Vue de devant</small>
</p>

<p align="left">
  <img src="visuals/screenshots/popup.png" alt="Notification volante" width="600"/>
  <br/>
  <small>Fig.4. Notification volante</small>
</p>

<p align="left">
  <img src="visuals/screenshots/history.png" alt="Historique" width="600"/>
  <br/>
  <small>Fig.5. L'historique</small>
</p>

### Installation et exécution

Plusieurs options sont possibles.

Vous pouvez forker ce dépôt : cliquez sur le bouton "Fork" (ou "Créer une bifurcation") à droite. Une copie indépendante sera créée sur votre compte GitLab, que vous pourrez ensuite cloner sur votre machine :

```bash
git clone <url_de_votre_fork>
```

Si vous choisissez cette méthode, assurez-vous d'avoir installé `git` (très probablement déjà présent).

Une fois tous les fichiers téléchargés, ouvrez le fichier `project.godot` pour lancer le jeu.

Si vous n'avez pas Godot Engine, vous pouvez l'installer facilement depuis le [site officiel de Godot Engine](https://godotengine.org/download/linux/).

Vous pouvez aussi télécharger directement l'exécutable du jeu pour Windows ou Linux ci-dessous :

#### Windows

Téléchargez directement l'exécutable du jeu ici :

[RenovIUT\_win.zip](https://git.unistra.fr/coruscant/renov-iut/-/raw/main/game/RenovIUT_win.zip)

#### Linux

Téléchargez directement l'exécutable du jeu ici :

[RenovIUT\_lin.zip](https://git.unistra.fr/coruscant/renov-iut/-/raw/main/game/RenovIUT_linux.zip)

Si vous rencontrez des problèmes liés à l'intégration de la base de données, vous pouvez créer vous-même un exécutable :

1. Lancez l'exportation du projet :

![Menu](visuals/screenshots/menu_export.png)

2. Incluez `data/*` comme répertoires hors ressources :

![Ecran1](visuals/screenshots/export1.png)

3. Créez l'archive contenant l'exécutable, un script de lancement et la bibliothèque dynamique nécessaire pour utiliser SQLite :

![Ecran2](visuals/screenshots/export2.png)

**Enjoy !**




## Cahier des charges

### Objectifs pédagogiques généraux

RenovIUT est un **serious game** conçu non seulement pour divertir, mais aussi pour transmettre des connaissances concrètes et utiles. Ses objectifs pédagogiques principaux sont les suivants :

* **Comprendre** le rôle du directeur d'un IUT, établissement doté d'une certaine autonomie administrative, dans la gestion et la rénovation de ses locaux en cohérence avec ses responsabilités sociales.
* **Découvrir** les bonnes pratiques en matière de gestion budgétaire d'un IUT, caractérisé par des financements diversifiés mais limités, afin d'assurer des conditions de travail optimales pour les étudiants et le personnel enseignant.
* **Expérimenter** la prise de décision en situation d'urgence, où il est essentiel de réévaluer rapidement les priorités de l'établissement.

### Objectifs pédagogiques avancés

Selon le scénario choisi, durant un mandat de 5 ans ou sur une durée illimitée, le joueur doit prendre en charge la rénovation des bâtiments et infrastructures, en assurant une gestion efficace du budget entre dépenses d'énergie, salaires et travaux divers, tout en gérant les imprévus.

Le budget n'étant pas illimité, le joueur devra nécessairement faire des choix stratégiques pour équilibrer les intérêts souvent divergents des différentes parties prenantes (étudiants, enseignants, administratifs).

L’objectif ultime du joueur dépend du scénario sélectionné : soit gérer efficacement les ressources disponibles, soit se faire réélire à la fin du mandat en ayant satisfait au mieux les attentes. L'objectif reste toujours d'assurer des conditions de travail adéquates et la satisfaction générale, tout en explorant différentes stratégies de gestion.

Le jeu se structure autour de quatre axes principaux :

1. **Les infrastructures existantes**

   * Évaluer l'état actuel des bâtiments et installations
   * Planifier des travaux de rénovation
   * Coordonner les différents acteurs impliqués
   * Sélectionner des prestataires de services

2. **Le budget**

   * Établir un budget réaliste et viable
   * Diversifier les sources de financement
   * Assurer un suivi précis des finances des projets
   * Faire des choix éclairés lorsque les ressources sont limitées

3. **Les parties prenantes** (étudiants, enseignants, personnels, collectivités locales)

   * Maintenir une communication transparente
   * Veiller à la satisfaction des étudiants et enseignants
   * Implémenter des mécanismes d'amélioration continue
   * Arbitrer en cas de conflits d’intérêts
   * Favoriser l’amélioration du niveau scolaire des étudiants

4. **L'attractivité**

   * Développer des initiatives valorisant l'image du campus
   * Mettre en avant les réussites et points forts de l’établissement
   * Améliorer la qualité des services et infrastructures pour attirer de nouveaux étudiants et enseignants
   * Accroître les performances académiques globales

### Références

#### Fonctionnement des IUT :

* [Le Gouvernement renforce le développement des IUT](https://www.enseignementsup-recherche.gouv.fr/fr/le-gouvernement-renforce-le-developpement-des-iut-et-ameliore-la-reconnaissance-des-enseignants-92382)
* [La rémunération des enseignants](https://www.education.gouv.fr/la-remuneration-des-enseignants-7565)
* [Relations Universités et IUT](https://www.education.gouv.fr/bo/2009/14/esrs0900149c.htm)
* [Inauguration locaux Génie civil IUT Robert Schuman](https://savoirs.unistra.fr/campus/les-locaux-du-departement-genie-civil-construction-durable-de-liut-robert-schuman-inaugures)
* [Historique IUT Robert Schuman](https://iutrs.unistra.fr/iut/historique)
* [Rénovation énergétique IUT Nancy-Brabois](https://iut-nancy-brabois.univ-lorraine.fr/renovation-energetique/)

#### Jeux sérieux :

* [Les Serious Games, un objet en construction](https://larevuedesmedias.ina.fr/les-serious-games-un-objet-en-construction)
* [Jeu sérieux — Wikipédia](https://fr.wikipedia.org/wiki/Jeu_s%C3%A9rieux)
* [Classification collaborative du Serious Game](http://serious.gameclassification.com/FR/index.html)

### Description des fonctionnalités

#### Simulation

**Le rythme de la simulation est trimestriel.**

* Le jeu est structuré en trimestres, permettant au joueur de réagir régulièrement aux événements et défis rencontrés. Chaque trimestre, le directeur de l'IUT incarné par le joueur doit gérer différentes problématiques liées aux infrastructures, au budget et aux relations avec les parties prenantes.
* Le gameplay cherche à reproduire le rythme réel de gestion d’un établissement éducatif, alternant phases actives et phases d’attente. Le joueur doit souvent réagir rapidement à plusieurs situations critiques simultanément, puis patienter avant d’observer les résultats de ses choix. Cette tension fait partie intégrante de l'expérience proposée.
* Le joueur devra accepter qu'il est impossible de résoudre tous les problèmes. Les situations non traitées empirent et nécessitent des choix parfois difficiles.
* Certains indicateurs majeurs ne sont actualisés qu’à la fin de l’année, reflétant la réalité de gestion d’un établissement éducatif :

  * **Attractivité** : recalculée en fin d'année selon les actions menées durant les quatre trimestres (gestion des infrastructures, ratio étudiants/enseignants, satisfaction générale, niveau scolaire des étudiants).
  * **Taux de réussite** : déterminé en fin d'année selon les efforts investis pour améliorer le niveau académique et la satisfaction étudiante, avec un facteur aléatoire pour représenter les imprévus de la vie réelle.

**À chaque fin de trimestre, la population du campus peut évoluer.**

* Les chiffres initiaux concernant enseignants, étudiants et personnels sont basés sur l'IUT Robert Schuman réel, mais ajustés par des coefficients internes au jeu.

* **Nombre d'enseignants** : Dépend des effectifs étudiants. Une baisse notable du nombre d’étudiants peut entraîner des réductions d'effectifs enseignants, tandis qu'une hausse significative nécessitera des recrutements, limités par le budget disponible et l'attractivité du campus.

* **Nombre d'administratifs** : Le joueur peut embaucher librement des administratifs pour renforcer la gestion interne, avec un impact direct sur le budget et indirect sur la satisfaction générale selon l’efficacité des processus administratifs.

* **État des bâtiments** : Influencé par leur âge, leur état initial et les éventuelles rénovations réalisées durant l'année. Ces rénovations dépendent directement du budget attribué.

* **Budget** : Actualisé chaque trimestre en fonction des dépenses engagées et des financements obtenus (subventions, partenariats). Le joueur peut ajuster les priorités budgétaires selon les besoins du campus. Le budget global se compose du budget central et des budgets des départements spécifiques.

* **Satisfaction** : Mesurée séparément pour étudiants et enseignants, elle représente leur perception de la qualité des services, des infrastructures et de la gestion générale. La satisfaction des étudiants est visuellement représentée dans le jeu par des personnages dont la couleur varie selon leur niveau de satisfaction.

### Durée et déroulement du jeu

La durée et le déroulement de la partie dépendent du scénario choisi initialement. Voir la section [« Scénarios »](#scénarios) pour davantage de détails.

### Gestion des données du campus

* Toutes les données du campus sont réinitialisées au début de chaque partie.
* Les valeurs initiales sont inspirées de celles de l'IUT Robert Schuman, avec une certaine composante aléatoire afin de refléter la réalité.
* Les données relatives aux étudiants et enseignants sont stockées dans des bases de données et des tableaux, facilitant une gestion structurée et efficace.

### Rapport de fin de partie

Un rapport détaillé est généré à la fin de chaque partie, récapitulant les décisions prises par le joueur ainsi que leurs conséquences. Ce rapport permet au joueur d’analyser ses choix, en valorisant ses succès et en identifiant clairement les axes d’amélioration.

### Tutoriel

Un tutoriel en 2D est proposé dès le lancement du jeu pour familiariser les nouveaux joueurs aux mécaniques principales sur une période de cinq trimestres. Ce guide interactif présente l’interface utilisateur, les statistiques importantes (budget, attractivité, satisfaction, etc.) et les premières actions à réaliser pour assurer une bonne gestion de l’IUT. Une fois terminé, le joueur accède au mode de jeu principal selon le scénario choisi.

### Interface du jeu

À son lancement, une fenêtre propose au joueur de choisir un scénario et d'activer ou non le tutoriel. Aucun scénario n'est pré-sélectionné, obligeant le joueur à faire explicitement son choix.

* L'interface principale combine des éléments graphiques en 3D avec des panneaux et boutons en 2D.
* Des effets sonores accompagnent les actions, à commencer par le choix du scénario (le volume sonore est géré directement sur l'appareil du joueur).
* **Vue panoramique du campus d’Illkirch** : contrôlée par les touches directionnelles permettant des changements d’angle de vue.
* **Représentation visuelle de la satisfaction étudiante** : les personnages en 3D sur le campus changent de couleur en fonction de leur niveau de satisfaction. Ils sont nettement moins nombreux durant la période estivale.
* **Panneau supérieur d’informations globales** (actualisé annuellement) comprenant :

  * Budget central et total de l’établissement (en euros)
  * Attractivité de l’établissement (en pourcentage)
  * Moyenne de satisfaction des étudiants et enseignants (en pourcentage)
  * Moyenne globale des notes
  * Saison et année en cours
  * Bouton permettant de passer au trimestre suivant
* **Période de transition trimestrielle** : un bref blocage de l'écran accompagné d'une notification visuelle centrale.
* **Affichage détaillé des bâtiments sélectionnés** (par clic zoomant) à droite :

  * **Panneau statique** : nom, logo du département, budget, nombre et satisfaction moyenne des étudiants, satisfaction enseignante.
  * **Panneau dynamique** (boutons avec infobulles) : ajustement du nombre d’administratifs, d’enseignants, du salaire enseignant (par paliers de 500 €), des compétences requises à l'admission et pour la réussite, gestion manuelle du chauffage et des portes.
* **Chantiers de rénovation** : visualisation par grues et équipements de chantier avec effets sonores notables.
* **Notifications** :

  * Résumés de la situation actuelle apparaissant temporairement en haut de l’écran.
  * Consultables à tout moment via un historique accessible depuis une icône dédiée.
  * Une zone inférieure affiche la mission actuelle et les instructions éventuelles du tutoriel.
* **Bouton de sortie** facilement identifiable en rouge.
* **Écran de fin de jeu** : affiche clairement les résultats selon le scénario choisi (gestion des ressources, rénovations réalisées, résultats académiques, réélection du directeur).
* Le curseur standard prend la forme d'une main indiquant clairement les éléments interactifs.

#### Actions du joueur

Le joueur, incarnant le directeur de l'IUT, est amené à réagir à divers défis, qu'ils soient prévus ou imprévus, en prenant des décisions stratégiques adaptées à la situation. Certaines circonstances peuvent ne pas permettre d'actions immédiates.

Concrètement, le joueur peut :

* Valider totalement ou partiellement les rénovations planifiées.
* Répartir et ajuster les allocations budgétaires.
* Régler le calendrier de chauffage des bâtiments.
* Embaucher ou licencier des enseignants afin d'optimiser les dépenses tout en considérant l'impact sur la satisfaction globale et la qualité pédagogique.
* Embaucher ou licencier des personnels administratifs pour mieux gérer les besoins logistiques et les délais liés aux travaux de rénovation.

Les **contrôles** disponibles dans le jeu :

* **Souris** :

  * Sélection d’un bâtiment par clic direct.
  * Modification des paramètres via des boutons interactifs.
  * Fermeture rapide des notifications par clic en dehors de celles-ci.
* **Touches directionnelles** : pour ajuster l'angle de vue du campus.

#### Scénarios

Les scénarios influencent fortement les décisions que doit prendre le directeur. Deux facteurs clés conditionnent chaque scénario :

* La situation initiale rencontrée par le directeur.
* L'objectif précis à atteindre.

Trois scénarios distincts sont proposés :

##### Scénario 1 : Me faire réélire

L’objectif principal est d'obtenir la confiance du Conseil d'administration de l'IUT, composé d’enseignants et d’étudiants, afin de garantir votre réélection en tant que directeur. Cela implique d'améliorer globalement les performances de l’établissement tout en maintenant un équilibre précis entre satisfaction des acteurs, gestion budgétaire et attractivité.

**Durée** : 5 ans (durée d’un mandat).

Un vote final détermine votre succès ou votre échec en termes de réélection.

##### Scénario 2 : Rénover le campus

Le but principal est la modernisation complète des infrastructures pour offrir un environnement optimal à l'apprentissage, accroître la satisfaction générale et réaliser une gestion budgétaire rigoureuse.

**Durée** : Illimitée (jusqu'à ce que tous les bâtiments soient rénovés ou que les ressources financières soient épuisées).

##### Scénario 3 : Viser l'excellence

Votre ambition est d'établir l'IUT comme référence nationale et internationale dans les domaines de l’éducation, de la recherche et de la gestion. Pour cela, il faudra maintenir un très haut niveau de compétences afin de permettre aux diplômés d’intégrer des écoles d'ingénieurs prestigieuses.

**Durée** : 5 ans.

À la fin de cette période, le nombre d'étudiants admis dans les écoles d'ingénieurs sera révélé, illustrant ainsi le succès ou les progrès accomplis grâce à votre gestion.

### Contraintes de développement

Le jeu a été développé avec le moteur [Godot Engine 4](https://godotengine.org/). L'équipe de développement a utilisé des environnements Linux et Windows, garantissant ainsi une compatibilité et un fonctionnement optimal sur les deux systèmes.

La conception logicielle du jeu est détaillée dans un diagramme des classes disponible dans le répertoire `uml/` (fichiers code et images).

Le code source, situé dans le dossier `game/`, est structuré selon les principes des patrons de conception [MVC (Model-View-Controller)](https://www.geeksforgeeks.org/mvc-design-pattern/) et [Observer](https://refactoring.guru/fr/design-patterns/observer), adaptés à la logique de Godot Engine :

* Les **vues**, les **contrôleurs** et les **modèles** sont organisés respectivement dans les dossiers `views/`, `controllers/` et `models/` :

  * Les **vues** sont divisées entre Nodes3D/ et Nodes2D/.
  * Les **contrôleurs** (`Campus/` et `Timeline/`) gèrent le traitement des données et le déroulement de la partie.
  * Les **modèles** (`human/`, `material/`, `GlobalData`) stockent les données essentielles, accessibles en lecture par les vues et modifiables uniquement par les contrôleurs.
* Les **données** sont sauvegardées dans des tables SQLite (`TeacherSQLTable`, `StudentSQLTable`, `NotificationSQLTable`) situées dans le répertoire `data/`.
* Une extension spécifique à l’utilisation de la base de données SQLite est intégrée dans le dossier `addons/`.

Pour optimiser l’accès et le traitement des données, la gestion des tables SQLite utilise les commandes [PRAGMA](https://www.sqlite.org/pragma.html).

### Améliorations possibles

* **Diversification des sources de financement** : Implémenter plusieurs méthodes de financement comme les subventions publiques, partenariats avec des entreprises, campagnes participatives, revenus liés à l'organisation d’événements ou location d’espaces. Chaque méthode pourrait présenter des avantages et contraintes spécifiques.

  * Voir le commit [49dc827b](https://git.unistra.fr/coruscant/renov-iut/-/tree/49dc827b38c754ac47654917b0907d8aa579b27f) pour les ébauches de classes (`Fund` et `Budget`).

* **Sélection d’entreprises pour les rénovations** : Permettre le choix entre plusieurs prestataires aux caractéristiques variées (coût, rapidité, qualité), influençant directement l’état des bâtiments et le budget restant.

* **Choix de niveaux de difficulté** (actuellement fixe mais facilement adaptable dans le code) :

  * Facile : Ressources généreuses, grande tolérance aux erreurs.
  * Intermédiaire : Ressources limitées, exigences modérées des parties prenantes.
  * Difficile : Ressources rares, crises fréquentes, hautes exigences.

* **Gestion des aléas** : Introduction d'événements imprévus (grèves, dégradations majeures, baisses soudaines de financements) auxquels le joueur devra réagir stratégiquement.

* **Gestion approfondie du personnel enseignant** : Différencier titulaires et vacataires, organiser leurs emplois du temps sur l’année, leur accorder une autonomie de proposition et d’expression.

* **Entretien régulier du campus** : Proposer des tâches d’entretien régulières (nettoyage, réparations mineures, maintenance technique) en complément des rénovations importantes.

* **Visualisation améliorée** : Intégration de graphiques et de schémas pour mieux représenter et analyser les différentes variables de gestion.

* **Contrôles clavier additionnels** pour enrichir les possibilités d'interaction avec le jeu.
