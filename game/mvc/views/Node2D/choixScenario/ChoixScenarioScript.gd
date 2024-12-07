class_name ChoixScenarioScript_
extends Node2D


var _IUT : IUTFacade
var _app : RenovIUTApp
var scenario = -1
var difficulty = 2

func init(iut : IUTFacade, app : RenovIUTApp) -> void:
	_IUT = iut
	_app = app
	_on_switch_tuto_option_toggled(false)
	var desc = get_node("menu/Description")
	desc.text = "Bienvenue, Monsieur le Directeur ! Quels sont vos projets ?"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$audioSonore.play()
	pass


func _on_button_election_pressed() -> void:
	scenario = 0
	var desc = get_node("menu/Description")
	desc.text = ScenarioElection.get_description()

func _on_button_renovation_pressed() -> void:
	scenario = 1
	var desc = get_node("menu/Description")
	desc.text = ScenarioRenovation.get_description()



func _on_suivant_pressed() -> void:
	if scenario == -1:
		var desc = get_node("menu/Description")
		desc.text = "Décidez-vous."
	else:
		_IUT.chooseMode(scenario, difficulty) # Par défaut, c'est le mode standard / défi qui est lancé
		_app.startGame()



func _on_switch_tuto_option_toggled(toggled_on: bool) -> void:
	difficulty = 1 # Choisir le mode de jeu simplifié, avec tuto
