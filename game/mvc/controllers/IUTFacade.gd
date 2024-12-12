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
		_tuto = Tutorial.new(GlobalData.get_difficulty()==1)
		match _id:
			0:
				_scenario = await ScenarioElection.new()
			1:
				_scenario = await ScenarioRenovation.new()
			2: 
				_scenario = await ScenarioElitisme.new()
		
		add_child(_scenario)
		add_child(_tuto)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		RenovIUTApp.app.game_loaded()
		_time = TimeManagement.new(_scenario, _tuto)
		add_child(_time)
		await _time.start()
