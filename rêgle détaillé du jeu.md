
Voici les différents aspect du fonctionnement du jeu et tout les détails complexe qu'il y a derriere:


Déroulement générale du jeu:
    - Des évênement aléatoire qui dépende du scénario peuvent tomber chaque jours
    - Chaque jour des opérations du jeu affecte le budget, la satisfaction générale et la réussite des étudiants
    - En début d'année la nouvelle promo est remplis automatiquement en fonction de la difficulté des examens d'entrée
    - En fin d'année les examens ont lieux et selon le niveau des étudiant, leur satisfactions et la difficulté des examens il passe l'année, la redouble ou bien abandonne



Scénario:
- Il y a 3 scénario
    - Le scénario de rénovation ou un batiment est en mauvais état de base et ou l'on doit complêtement le rénover
        - Un batiment (ou 2 en mode difficile ) est choisis, sont état est mauvais de base 
        - Un message intermediaire est envoyer quand la rénovation ou l'isolation est finit
        - Quand les travaux sont finit un rapport montre au joueur le temps qu'il à prit et les concéquences de la rénovation
    - Le scénario d'éléction ou le but est d'être réélu au bout de 5 ans
        - 2 ans avant les éléctions le joueur recois un sondage d'intention de vote
        - A la fin des 5 années l'éléctions à lieu et les votes dépendent de plusieurs facteur auquel sont attribué des coeffs
        - Le joueur recoit un rapport avec les voix reçu dans une grille détaillé
        - Le score est définit par le nombre de voix reçu
    - Le scénario de prestige ou le but est d'avoir le plus de diplomé possible sur 5 ans
        - Bonus : Avoir un/des prix nobel (Etudiant ayant réussit avec plus de 95%)
- A la fin de chaque scénario le joueur peut consulter les statistiques détaillé de sa partie
- Il recois également un rapport intelligent sur sa prestation qui lui dit ce qu'il a bien fait et mal fait



L'argent:
    - Il y a un compte global qui peut servir à couvrir n'importe quelle dépense 
    - Il y a un compte pour chaque batiment qui ne peut être utilisé que pour les dépenses de celui ci
    - L'initialisation de l'argent initial dépend de la difficulté et d'un facteur aléatoire



Action sur les batiments:
- Allumer/Eteindre le chauffage
    - Cout quotidient si allumer qui dépend de l'isolation
    - Risque de plainte des occupants si allumer en été (affecte la satisafaction)
    - Risque de plainte des occupants si éteint en hivert (affecte la satisafaction)
- Bloquer/Débloquer les portes:
    - Risque de plainte des étudiants si fermer (affecte la satisafaction)
    - Rend le travail des agents d'entretiens 2 fois plus facile
- Embaucher/Virer un prof
    - Il faut une satisfaction des profs par batiments d'au moins 60% pour pouvoir embaucher
    - La satisfaction d'un prof à l'embauche est compris entre 40% et 60%
    - Demande un salaire mensuel de x à payer
    - Impact sur la réussite étudiante au jours le jours (plafond de l'effet cumulable à partir de 1 prof pour 10 élève)
- Embaucher/Virer un agent d'entretien
    - Possède un salaire mensuel de x à payer
    - Agit sur la vitesse de dégradation de l'état des lieux ( coeff de degradation = 1/(1+nb_agent) )
    - Risque de plainte des 
- Embaucher/Virer un ouvrier
    - Possède un salaire mensuel de x à payer
    - Permet de faire des travaux
- Lancer les travaux d'isolation et/ou de rénovation d'un batiment
    - N'est possible que si des ouvrier on été embaucher
    - Il n'est possible de lancer les travaux que s'il reste assez de place dans les batiments libre pour tout les étudiants (450 place par batiment)
    - La vitesse de travaux est proportionelle au nombre d'ouvrier
    - Les ouvriers en grêve ne participe pas au travaux 
- Définir la difficulté des examens d'entrée
- Définir la difficulté des examens finaux



Les batiments:




Les étudiants:
    - Si la satisfaction d'un étudiants tombe sous les 20% il abandonne



Les professeurs:
    - Si la satisfaction d'un prof tombe sous les 20% il démissionne
    - La satisfaction impact continuellement la réussite des étudiants


Les évenement aléatoire:
    - Les évênement aléatoire on plus de chance d'arriver en milieu de jeu
    - Certain evenement peuvent soliciter un choix du joueur, d'autre produise juste un effet
    - Certain evenement on des prérequis pour avoir lieu
    - Liste des évenements
        - Grève des professeurs
        - Grève des ouvriers
            - 