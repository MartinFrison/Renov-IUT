class_name RenovIUTApp
extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label = get_tree().get_root().get_node("Node2D/Label")
	label = label as Label
	label.text = "Bonjour"
	Utils.create_iut_db()
	
	var illkirch = IUTFacade.new()
	illkirch.populate_campus()
	Exemple.new()
	
	Utils.db.clear_tables()
	Utils.db.close_db()
	
