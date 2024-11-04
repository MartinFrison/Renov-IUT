# IUTFacade.gd
class_name IUTFacade
extends Node

var teaching: Teaching
var study: Study
var scenario: Scenario
var time: TimeManagement

func _init():
	teaching = Teaching.new()
	study = Study.new()
	scenario = ScenarioElection.new()
	time = TimeManagement.new(scenario)

# Remplir le campus
func populate_campus():
	teaching.populate()
	study.populate()
	add_child(time)
	# construire les batiments
