class_name ChoixScenarioScript
extends Node2D


var _IUT : IUTFacade
var _app : RenovIUTApp
var difficulty


func init(iut : IUTFacade, app : RenovIUTApp) -> void:
	_IUT = iut
	_app = app
	_on_easy_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_easy_pressed() -> void:
	difficulty = 1
	var desc = get_node("menu/Description")
	desc.text = "Facile"


func _on_medium_pressed() -> void:
	difficulty = 2
	var desc = get_node("menu/Description")
	desc.text = "Moyen"


func _on_hard_pressed() -> void:
	difficulty = 3
	var desc = get_node("menu/Description")
	desc.text = "Difficile"


func _on_suivant_pressed() -> void:
	_IUT.chooseDifficulty(difficulty)
	_app.start_game()
