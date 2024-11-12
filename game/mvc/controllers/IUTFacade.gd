# IUTFacade.gd
class_name IUTFacade
extends Node

var scenario: Scenario
var time: TimeManagement


func chooseScenario(id : int) -> void:
	match id:
		0:
			scenario = ScenarioElection.new()
		1:
			scenario = ScenarioRenovation.new()

func chooseDifficulty(value : int) -> void:
	GlobalData.set_difficulty(value)


func startGame() -> void:
		time = TimeManagement.new(scenario)
		add_child(time)
