class_name ChoixScenarioScript_
extends Node2D


var _IUT : IUTFacade
var _app : RenovIUTApp
var scenario


func init(iut : IUTFacade, app : RenovIUTApp) -> void:
	_IUT = iut
	_app = app
	_on_button_election_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$audioSonore.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	_IUT.chooseScenario(scenario)
	_app.choiceDifficulty()
