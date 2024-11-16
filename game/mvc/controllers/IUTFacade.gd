# IUTFacade.gd
class_name IUTFacade
extends Node

var _scenario: Scenario
var _time: TimeManagement
var _id

func chooseScenario(id : int) -> void:
	_id = id

func chooseDifficulty(value : int) -> void:
	GlobalData.set_difficulty(value)


func startGame() -> void:
		match _id:
			0:
				_scenario = await ScenarioElection.new()
			1:
				_scenario = await ScenarioRenovation.new()
		
		_time = TimeManagement.new(_scenario)
		add_child(_time)
		add_child(_scenario)
