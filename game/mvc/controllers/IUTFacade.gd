# IUTFacade.gd
class_name IUTFacade
extends RefCounted

var scenario: Scenario
var time: TimeManagement

func _init():
	scenario = ScenarioElection.new()
	time = TimeManagement.new(scenario)
