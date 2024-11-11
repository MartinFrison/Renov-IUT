class_name ChoixScenario
extends Node2D


var _IUT : IUTFacade
var _app : RenovIUTApp

func init(iut : IUTFacade, app : RenovIUTApp) -> void:
	_IUT = iut
	_app = app
	print("lolll")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("lolll")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_election_pressed() -> void:
	print("lolll")
	_IUT.chooseScenario(0)
	_app.choiceDifficulty()
