# IUTFacade.gd
class_name IUTFacade
extends Node

var _tuto : Tutorial
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
				_tuto = Tutorial.new(true)
			1:
				_scenario = await ScenarioRenovation.new()
				_tuto = Tutorial.new(false)
			2: 
				_scenario = await ScenarioElitisme.new()
				_tuto = Tutorial.new(false)
		
		add_child(_time)
		add_child(_scenario)
		add_child(_tuto)
		_time = TimeManagement.new(_scenario, _tuto)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		RenovIUTApp.app.game_loaded()
