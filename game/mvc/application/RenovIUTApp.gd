class_name RenovIUTApp
extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label = get_tree().get_root().get_node("Node2D/Label")
	label = label as Label
	label.text = "Bonjour"
	Utils.create_iut_db()
	
	Exemple.new()
	
	var scenario = Scenario.new()
	var time = TimeManagement.new(scenario)
	
	add_child(time)
	time.add_child(scenario)
	
	
