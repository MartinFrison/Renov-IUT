# IUTFacade.gd
class_name IUTFacade
extends Node

var _scenario: Scenario
var _time: TimeManagement
var _id


func chooseMode(scenario : int, difficulty) -> void:
	_id = scenario
	GlobalData.set_difficulty(difficulty)


func startGame() -> void:
		match _id:
			0:
				_scenario = await ScenarioElection.new()
			1:
				_scenario = await ScenarioRenovation.new()
		
		_time = TimeManagement.new(_scenario)
		add_child(_time)
		add_child(_scenario)
