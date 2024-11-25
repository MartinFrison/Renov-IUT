class_name ChoixScenarioScript_
extends Node2D


var _IUT : IUTFacade
var _app : RenovIUTApp
var scenario
var difficulty

func init(iut : IUTFacade, app : RenovIUTApp) -> void:
	_IUT = iut
	_app = app
	_on_button_mode_tuto_pressed()
	_on_button_election_pressed()

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

func _on_button_mode_tuto_pressed() -> void:
	difficulty = 1
	var desc = get_node("menu/Description")
	desc.text = "Facile"


func _on_button_mode_standart_pressed() -> void:
	difficulty = 2
	var desc = get_node("menu/Description")
	desc.text = "Moyen"


func _on_suivant_pressed() -> void:
	_IUT.chooseMode(scenario, difficulty)
	_app.startGame()
