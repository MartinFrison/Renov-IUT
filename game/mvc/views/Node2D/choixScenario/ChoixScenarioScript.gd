class_name ChoixScenarioScript_
extends Node2D


var _IUT : IUTFacade
var _app : RenovIUTApp
var scenario = -1 # ID du scénario séléctionner (par defaut -1 pour forcer a choisir)
var difficulty = 2 # La difficulté 1 correspond au mode tutoriel

# Fonction d'initialisation pour passer la référence vers l'appli et le 
# générateur d'iut
func init(iut : IUTFacade, app : RenovIUTApp) -> void:
	_IUT = iut
	_app = app
	_on_switch_tuto_option_toggled(false)
	var desc = get_node("menu/Description")
	desc.text = "Bonjour et bienvenue parmi nous ! Quels sont vos projets ?"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Au lancement du jeu on joue un son
	var audio_player = get_node("sound")
	audio_player.play()
	pass

# Quand le bouton pour séléctionner le scénario éléction est cliqué
func _on_button_election_pressed() -> void:
	scenario = 0
	var desc = get_node("menu/Description")
	desc.text = ScenarioElection.get_description()

# Quand le bouton pour séléctionner le scénario rénovation est cliqué
func _on_button_renovation_pressed() -> void:
	scenario = 1
	var desc = get_node("menu/Description")
	desc.text = ScenarioRenovation.get_description()

# Quand le bouton pour séléctionner le scénario élitisme est cliqué
func _on_button_elitism_pressed() -> void:
	scenario = 2
	var desc = get_node("menu/Description")
	desc.text = ScenarioElitisme.get_description()


# Quand le bouton pour lancer le jeu est cliqué
func _on_suivant_pressed() -> void:
	# Si le joueur n'a pas choisie le scénario on lui demande de le faire
	if scenario == -1:
		var desc = get_node("menu/Description")
		desc.text = "Décidez-vous."
	else:
		# Sinon on lance le jeu avec le scénario et le mode choisie
		_IUT.chooseMode(scenario, difficulty) # Par défaut, c'est le mode standard / défi qui est lancé
		_app.startGame()


# Bouton pour activer / désactiver le mode tutoriel
func _on_switch_tuto_option_toggled(toggled_on: bool) -> void:
	if toggled_on:
		difficulty = 1 # Choisir le mode de jeu simplifié, avec tuto
	else:
		difficulty = 2
