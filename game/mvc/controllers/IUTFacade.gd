# IUTFacade.gd
class_name IUTFacade
extends Node

var scenario: Scenario
var time: TimeManagement

func _init():
	scenario = ScenarioElection.new()
	time = TimeManagement.new(scenario)

# Remplir le campus
func populate_campus():
	add_child(time)
	# construire les batiments
